"""Installed preset rendering and restricted browser-host protocol tests."""
import importlib.machinery
import importlib.util
import io
import json
import os
from pathlib import Path
import shutil
import struct
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

REPO = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(REPO / '.local/lib'))
import desktop_theme_apps as apps


def frame(value):
    payload = json.dumps(value).encode()
    return struct.pack('<I', len(payload)) + payload


class AppThemeTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.config = self.home / '.config'
        self.config.mkdir()

    def create(self, relative, text):
        p = self.config / relative
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(text)
        return p

    def test_no_apps_does_not_change_any_config(self):
        self.assertEqual(apps.render({}, self.config), {})
        self.assertEqual(apps.render({'gtk': None}, self.config), {})

    def test_missing_optional_gtk_and_kvantum_presets_are_skipped(self):
        assignment = {'gtk': 'Missing GTK', 'kvantum': 'Missing Kvantum'}
        self.assertEqual(apps.render(assignment, self.config), {})
        warnings = apps.refresh(assignment, lambda *args, **kwargs: None, self.config)
        self.assertEqual(len(warnings), 2)
        self.assertTrue(any('GTK preset not installed' in item for item in warnings))
        self.assertTrue(any('Kvantum preset not installed' in item for item in warnings))

    def test_invalid_mapping_and_paths_are_rejected(self):
        for bad in ['gtk-theme', {'unknown': 'theme'}, {'gtk': '../theme'}, {'vesktop': apps.VESKTOP_BRIDGE}]:
            with self.subTest(value=bad), self.assertRaises(ValueError):
                apps.validate(bad)

    def test_gtk_keeps_user_css_and_unrelated_settings(self):
        theme = self.home / 'theme'
        for name in ['gtk.css', 'gtk-dark.css']:
            path = theme / 'gtk-4.0' / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text('/* preset */')
        self.create('gtk-3.0/settings.ini', '[Settings]\ngtk-font-name=Custom 12\n')
        self.create('gtk-4.0/gtk.css', '.my-custom-widget { padding: 3px; }\n')
        with patch.object(apps, 'gtk_path', return_value=theme):
            output = apps.render({'gtk': 'Test GTK'}, self.config)
            self.assertIn('gtk-font-name=Custom 12', output[self.config / 'gtk-3.0/settings.ini'])
            self.assertIn('gtk-theme-name=Test GTK', output[self.config / 'gtk-3.0/settings.ini'])
            css = output[self.config / 'gtk-4.0/gtk.css']
            self.assertIn('.my-custom-widget', css)
            self.assertIn((theme / 'gtk-4.0/gtk.css').as_uri(), css)
            (self.config / 'gtk-4.0/gtk.css').write_text(css)
            again = apps.render({'gtk': 'Test GTK'}, self.config)
            self.assertEqual(again[self.config / 'gtk-4.0/gtk.css'].count('desktop-theme preset begin'), 1)

    def test_kvantum_keeps_qt_geometry(self):
        self.create('Kvantum/test/test.kvconfig', '[General]\n')
        self.create('Kvantum/test/test.svg', '<svg/>')
        self.create('qt6ct/qt6ct.conf', '[Appearance]\nstyle=other\n[SettingsWindow]\ngeometry=opaque-data\n')
        output = apps.render({'kvantum': 'test'}, self.config)
        self.assertIn('geometry=opaque-data', output[self.config / 'qt6ct/qt6ct.conf'])
        self.assertIn('style=kvantum', output[self.config / 'qt6ct/qt6ct.conf'])
        self.assertIn('theme=test', output[self.config / 'Kvantum/kvantum.kvconfig'])

    def test_vesktop_does_not_edit_settings_or_original_preset(self):
        css = '/**\n * @name Test Preset\n */\n:root { --accent: #cba6f7; }\n'
        source = self.create('vesktop/themes/Test.theme.css', css)
        settings = self.create('vesktop/settings/settings.json', '{"enabledThemes": ["Test.theme.css"], "other": 1}')
        before = settings.read_text()
        output = apps.render({'vesktop': 'Test.theme.css'}, self.config)
        self.assertEqual(len(output), 1)
        self.assertIn('@name Desktop Theme', output[self.config / 'vesktop/themes/DesktopTheme.theme.css'])
        self.assertEqual(source.read_text(), css)
        self.assertEqual(settings.read_text(), before)

    def test_native_host_returns_only_theme_identity(self):
        root = self.config / 'desktop-themes'; root.mkdir()
        (root / 'active.json').write_text(json.dumps({'apps': {'librewolf': 'test-theme@example'}, 'wallpaper': '/private/path.png'}))
        env = {**os.environ, 'XDG_CONFIG_HOME': str(self.config)}
        result = subprocess.run([str(REPO / '.local/bin/desktop-theme-browser-host')],
                                input=frame({'op': 'get'}), capture_output=True, env=env, check=True)
        length = struct.unpack('<I', result.stdout[:4])[0]
        response = json.loads(result.stdout[4:4 + length])
        self.assertEqual(response['theme_id'], 'test-theme@example')
        self.assertEqual(set(response), {'type', 'theme_id', 'generation'})
        self.assertNotIn(b'private', result.stdout)

    def test_native_host_rejects_unbounded_messages(self):
        result = subprocess.run([str(REPO / '.local/bin/desktop-theme-browser-host')],
                                input=struct.pack('<I', 65537), capture_output=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, b'')


if __name__ == '__main__':
    unittest.main()
