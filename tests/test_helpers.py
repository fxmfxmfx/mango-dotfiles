"""Exercise shell helpers and installer behavior without a graphical session."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]


class HelperTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.home = self.root / 'home'
        self.home.mkdir()
        self.bin = self.root / 'bin'
        self.bin.mkdir()
        self.env = {**os.environ, 'HOME': str(self.home),
                    'PATH': str(self.bin) + ':' + os.environ['PATH']}
        xkb = self.root / 'xkb data/rules'
        xkb.mkdir(parents=True)
        (xkb / 'evdev.lst').write_text('! model\n  pc105 Generic\n! layout\n'
                                      '  us English (US)\n  ru Russian\n'
                                      '  de German\n  ua Ukrainian\n! variant\n'
                                      '  invalidvariant ignored\n')
        self.env['XKB_CONFIG_ROOT'] = str(xkb.parent)

    def command(self, name, body):
        path = self.bin / name
        path.write_text('#!/bin/sh\n' + body + '\n')
        path.chmod(0o755)
        return path

    def test_layout_uses_configured_output(self):
        self.command('mmsg', 'printf "%s\\n" "$*" >> "$HOME/calls"; '
                     '[ "$1" != get ] || printf \'{"layout_symbol":"T"}\\n\'')
        for output in ['DP-1', 'eDP-1']:
            with self.subTest(output=output):
                env = {**self.env, 'MANGO_OUTPUT': output}
                subprocess.run(['sh', str(REPO / '.local/bin/layout.sh')], env=env, check=True)
                calls = (self.home / 'calls').read_text()
                self.assertIn(f'get monitor {output}', calls)
                self.assertIn(f'dispatch focusmon,{output}', calls)
                self.assertIn('dispatch setlayout,grid', calls)
                (self.home / 'calls').unlink()

    def test_screenshot_finds_home_tools_and_rejects_invalid_mode(self):
        tools = self.home / '.cargo/bin'
        tools.mkdir(parents=True)
        tool = tools / 'wayfreeze'
        tool.write_text('#!/bin/sh\nprintf "found home tool\\n"\n')
        tool.chmod(0o755)
        script = str(REPO / '.local/bin/screenshot.sh')
        result = subprocess.run(['sh', script, 'full'], env=self.env, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('found home tool', result.stdout)
        for args in [[], ['unknown']]:
            result = subprocess.run(['sh', script, *args], env=self.env, capture_output=True, text=True)
            self.assertEqual(result.returncode, 2)
            self.assertIn('Usage:', result.stderr)

    def test_missing_portal_does_not_skip_other_backends(self):
        self.command('pgrep', 'exit 1')
        for name in ['xdg-desktop-portal', 'xdg-desktop-portal-wlr']:
            self.command(name, 'printf "%s\\n" "' + name + '" >> "$HOME/started"')
        # Isolate discovery from system-installed portal binaries.
        source = (REPO / '.local/bin/start-portals.sh').read_text()
        source = source.replace('/usr/libexec/', str(self.root / 'absent-libexec') + '/')
        source = source.replace('/usr/lib/', str(self.root / 'absent-lib') + '/')
        script = self.root / 'portals.sh'
        script.write_text(source)
        env = {**self.env, 'PATH': str(self.bin)}
        result = subprocess.run(['/bin/sh', str(script)], env=env, capture_output=True, text=True)
        self.assertEqual(result.returncode, 1)
        self.assertIn('missing xdg-desktop-portal-gtk', result.stderr)
        self.assertEqual(set((self.home / 'started').read_text().splitlines()),
                         {'xdg-desktop-portal', 'xdg-desktop-portal-wlr'})

    def test_session_cursor_defaults_and_overrides_reach_mango(self):
        self.command('dbus-run-session', 'shift; exec "$@"')
        self.command('mango', 'printf "%s %s %s %s\\n" "$XCURSOR_THEME" '
                     '"$XCURSOR_SIZE" "$QT_STYLE_OVERRIDE" "$GSK_RENDERER"')
        for address in ['', 'disabled:', 'unix:path=/example']:
            for custom in [False, True]:
                with self.subTest(address=address, custom=custom):
                    env = {**self.env, 'DBUS_SESSION_BUS_ADDRESS': address}
                    for key in ['XCURSOR_THEME', 'XCURSOR_SIZE', 'GSK_RENDERER']:
                        env.pop(key, None)
                    if custom:
                        env.update(XCURSOR_THEME='Adwaita', XCURSOR_SIZE='32', GSK_RENDERER='cairo')
                    result = subprocess.run(['sh', str(REPO / '.local/bin/start-mango.sh')],
                                            env=env, capture_output=True, text=True)
                    self.assertEqual(result.returncode, 0, result.stderr)
                    self.assertEqual(result.stdout.strip(), 'Adwaita 32 kvantum cairo' if custom
                                     else 'Bibata-Modern-Ice 24 kvantum gl')

    def test_offline_install_and_backup_collision(self):
        # Any accidental font download must fail this test.
        self.command('curl', 'echo "unexpected download" >&2; exit 99')
        config = self.home / '.config/mango/config.conf'
        config.parent.mkdir(parents=True)
        config.write_text('original config\n')
        legacy = self.home / '.local/bin/wallpaper-url-add'
        legacy.parent.mkdir(parents=True)
        legacy.write_text('retired helper\n')
        backup = self.root / 'backup'
        env = {**self.env, 'DOTFILES_BACKUP_DIR': str(backup)}
        args = ['sh', str(REPO / 'scripts/install.sh'), '--skip-fonts', '--home', str(self.home)]
        result = subprocess.run(args + ['--dry-run'], env=env, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(config.read_text(), 'original config\n')
        self.assertFalse(backup.exists())
        result = subprocess.run(args, env=env, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        saved = backup / '.config/mango/config.conf'
        self.assertEqual(saved.read_text(), 'original config\n')
        self.assertFalse(legacy.exists())
        self.assertEqual((backup / 'retired/.local/bin/wallpaper-url-add').read_text(),
                         'retired helper\n')
        self.assertTrue((self.home / '.config/vesktop/themes/DesktopTheme.theme.css').is_file())
        self.assertTrue((self.home / 'Wallpaper/prism.png').is_file())
        autostart = (self.home / '.config/mango/conf.d/20-autostart.conf').read_text()
        self.assertIn('exec-once=~/.local/bin/rs-wwidget start', autostart)
        self.assertFalse((self.home / '.local/share/fonts').exists())
        self.assertEqual((self.home / '.config/mango/conf.d/10-input.conf').read_text(),
                         (REPO / '.config/mango/conf.d/10-input.conf').read_text())
        before = {p.relative_to(self.home): p.read_bytes()
                  for p in self.home.rglob('*') if p.is_file()}
        result = subprocess.run(args, env=env, capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('refusing to reuse a nonempty backup directory', result.stderr)
        self.assertEqual(saved.read_text(), 'original config\n')
        self.assertEqual(before, {p.relative_to(self.home): p.read_bytes()
                                 for p in self.home.rglob('*') if p.is_file()})

    def test_keyboard_layout_prompt_yes_and_no(self):
        choices = [('y\n\nDP-1\n', 'us,ru', 'grp:lalt_lshift_toggle'),
                   ('n\nDP-1\n', 'us', ''),
                   ('y\nde\nDP-1\n', 'us,de', 'grp:lalt_lshift_toggle'),
                   ('y\nrussian\n?\nua\nDP-1\n', 'us,ua', 'grp:lalt_lshift_toggle')]
        for index, (answer, layouts, options) in enumerate(choices):
            with self.subTest(answer=answer):
                target = self.root / ('interactive-' + str(index))
                master, slave = os.openpty()
                try:
                    os.write(master, answer.encode())
                    result = subprocess.run(
                        ['sh', str(REPO / 'scripts/install.sh'), '--skip-fonts', '--home', str(target)],
                        stdin=slave, env=self.env, capture_output=True, text=True, timeout=15)
                finally:
                    os.close(master)
                    os.close(slave)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn('Enable keyboard layout switching with Alt+Shift?', result.stdout)
                if 'russian' in answer:
                    self.assertIn('Unknown XKB layout: russian', result.stdout)
                    self.assertIn('ua Ukrainian', result.stdout)
                self.assertIn('Customize xkb_rules_layout and xkb_rules_options', result.stdout)
                text = (target / '.config/mango/conf.d/10-input.conf').read_text()
                self.assertIn(f'xkb_rules_layout={layouts}\n', text)
                self.assertIn(f'xkb_rules_options={options}\n', text)
                self.assertIn('repeat_rate=25', text)

    def test_keyboard_layout_cli_and_invalid_value(self):
        for index, layouts in enumerate(['us', 'us,ru', 'us,de']):
            target = self.root / ('explicit-' + str(index))
            result = subprocess.run(
                ['sh', str(REPO / 'scripts/install.sh'), '--skip-fonts', '--home', str(target),
                 '--keyboard-layouts', layouts], env=self.env, capture_output=True, text=True, timeout=15)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertNotIn('Enable keyboard layout switching', result.stdout)
            text = (target / '.config/mango/conf.d/10-input.conf').read_text()
            self.assertIn(f'xkb_rules_layout={layouts}\n', text)
        for value in ['us;echo', 'us,russian', 'us,invalidvariant']:
            target = self.root / 'invalid-layout'
            result = subprocess.run(
                ['sh', str(REPO / 'scripts/install.sh'), '--home', str(target),
                 '--keyboard-layouts', value], env=self.env, capture_output=True, text=True)
            self.assertEqual(result.returncode, 2, result.stderr)
            self.assertFalse(target.exists())

    def test_missing_xkb_data_fails_before_installing(self):
        target = self.root / 'missing-xkb-target'
        result = subprocess.run(
            ['sh', str(REPO / 'scripts/install.sh'), '--home', str(target),
             '--keyboard-layouts', 'us,ru'],
            env={**self.env, 'XKB_CONFIG_ROOT': str(self.root / 'missing-xkb')},
            capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('cannot validate layouts', result.stderr)
        self.assertFalse(target.exists())


if __name__ == '__main__':
    unittest.main()
