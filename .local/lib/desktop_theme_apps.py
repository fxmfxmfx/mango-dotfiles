"""Optional installed application presets for desktop-theme.

No browser/session data belongs in the shared theme definitions.
"""
import configparser
import io
import json
import os
from pathlib import Path
import re

APP_KEYS = {'gtk', 'kvantum', 'vesktop', 'librewolf'}
VESKTOP_BRIDGE = 'DesktopTheme.theme.css'


def ini_update(path, section, values):
    parser = configparser.ConfigParser(interpolation=None, strict=False)
    parser.optionxform = str
    if path.exists():
        parser.read_string(path.read_text())
    if not parser.has_section(section):
        parser.add_section(section)
    for key, value in values.items():
        parser.set(section, key, value)
    output = io.StringIO()
    parser.write(output, space_around_delimiters=False)
    return output.getvalue()


def validate(apps):
    if not isinstance(apps, dict):
        raise ValueError('apps must be an object of installed preset names')
    unknown = set(apps) - APP_KEYS
    if unknown:
        raise ValueError(f'Unknown apps keys: {sorted(unknown)}')
    for key, value in apps.items():
        if value is not None and (not isinstance(value, str) or not value or any(c in value for c in '\r\n\0/\\')):
            raise ValueError(f'apps.{key} must be an installed preset name or null')
    if apps.get('vesktop') == VESKTOP_BRIDGE:
        raise ValueError('Choose a source Vesktop preset, not the managed DesktopTheme file')


def gtk_path(name):
    data = Path(os.environ.get('XDG_DATA_HOME', Path.home() / '.local/share'))
    search = [data / 'themes', Path.home() / '.themes']
    search.extend(Path(p) / 'themes' for p in os.environ.get('XDG_DATA_DIRS', '/usr/local/share:/usr/share').split(':') if p)
    for parent in search:
        path = parent / name
        if (path / 'gtk-3.0/gtk.css').is_file():
            return path
    raise ValueError(f'GTK preset is not installed: {name}')


def kvantum_path(name, config):
    search = [config / 'Kvantum', Path.home() / '.themes', Path('/usr/share/Kvantum'), Path('/usr/local/share/Kvantum')]
    for parent in search:
        path = parent / name
        if (path / f'{name}.kvconfig').is_file() and (path / f'{name}.svg').is_file():
            return path
    raise ValueError(f'Kvantum preset is not installed: {name}')


def render(apps, config):
    validate(apps)
    result = {}
    if apps.get('gtk'):
        theme = gtk_path(apps['gtk'])
        values = {'gtk-theme-name': apps['gtk'], 'gtk-application-prefer-dark-theme': '1'}
        for version in ['gtk-3.0', 'gtk-4.0']:
            path = config / version / 'settings.ini'
            result[path] = ini_update(path, 'Settings', values)
        # GTK 4 needs an explicit user stylesheet for non-Adwaita presets.
        for name in ['gtk.css', 'gtk-dark.css']:
            target = theme / 'gtk-4.0' / name
            if not target.is_file():
                target = theme / 'gtk-4.0/gtk.css'
            if not target.is_file():
                raise ValueError(f'GTK preset lacks GTK 4 CSS: {theme}')
            path = config / 'gtk-4.0' / name
            marker_start = '/* desktop-theme preset begin */'
            marker_end = '/* desktop-theme preset end */'
            # Existing named-theme symlinks are replaced; regular custom CSS is kept.
            custom = '' if path.is_symlink() or not path.exists() else path.read_text()
            custom = re.sub(re.escape(marker_start) + r'.*?' + re.escape(marker_end) + r'\n?', '', custom, flags=re.S)
            result[path] = f'{marker_start}\n@import url({json.dumps(target.resolve().as_uri())});\n{marker_end}\n' + custom
    if apps.get('kvantum'):
        kvantum_path(apps['kvantum'], config)
        path = config / 'Kvantum/kvantum.kvconfig'
        result[path] = ini_update(path, 'General', {'theme': apps['kvantum']})
        # Both versions can coexist; don't replace unrelated Qt settings.
        for version in ['qt5ct', 'qt6ct']:
            path = config / version / f'{version}.conf'
            if path.exists() or version == 'qt6ct':
                result[path] = ini_update(path, 'Appearance', {'style': 'kvantum'})
    if apps.get('vesktop'):
        directory = config / 'vesktop'
        preset = directory / 'themes' / apps['vesktop']
        if preset.suffix.lower() != '.css' or not preset.is_file():
            raise ValueError(f'Vesktop CSS preset is not installed: {preset}')
        css = preset.read_text()
        css, count = re.subn(r'(?m)^(\s*\*?\s*@name\s+).*$', r'\1Desktop Theme', css, count=1)
        if count == 0:
            css = '/**\n * @name Desktop Theme\n * @description Managed by desktop-theme\n */\n' + css
        result[directory / 'themes' / VESKTOP_BRIDGE] = css
    # LibreWolf selection is consumed through its optional native-messaging bridge.
    return result


def refresh(apps, run, config):
    warnings = []
    if apps.get('gtk'):
        import shutil
        if shutil.which('gsettings'):
            for key, value in [('gtk-theme', apps['gtk']), ('color-scheme', 'prefer-dark')]:
                result = run(['gsettings', 'set', 'org.gnome.desktop.interface', key, value], capture_output=True)
                if result.returncode:
                    warnings.append(f'GTK live update: {(result.stderr or result.stdout).strip()}')
        else:
            warnings.append('GTK preset saved; gsettings not installed, applications may need reopening')
    if apps.get('vesktop'):
        settings = config / 'vesktop/settings/settings.json'
        try:
            data = json.loads(settings.read_text())
            if data.get('enabledThemes') != [VESKTOP_BRIDGE] or data.get('themeLinks'):
                warnings.append('Vesktop: enable only Desktop Theme in Vencord > Themes once; turn off other CSS themes/links')
        except (OSError, ValueError):
            warnings.append('Vesktop: enable Desktop Theme in Vencord > Themes once')
    if apps.get('librewolf'):
        status = config / 'desktop-themes/librewolf-bridge-status.json'
        if not status.exists():
            warnings.append('LibreWolf: install and enable the Desktop Theme Bridge add-on once; preset selection is saved')
    return warnings
