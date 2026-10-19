"""Signed asset integrity and one-time native-host setup without real profiles."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
import zipfile

REPO = Path(__file__).resolve().parents[1]
BUNDLE = REPO / '.config/desktop-themes/browser-addons'


class BrowserBundleTests(unittest.TestCase):
    def test_signed_archives_match_recorded_checksums(self):
        for line in (BUNDLE / 'SHA256SUMS').read_text().splitlines():
            digest, name = line.split(maxsplit=1)
            with self.subTest(package=name):
                path = BUNDLE / name
                self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), digest)
                with zipfile.ZipFile(path) as zipped:
                    self.assertIsNone(zipped.testzip())
                    self.assertIn('META-INF/mozilla.rsa', zipped.namelist())

    def test_bridge_sources_match_signed_package(self):
        source = REPO / '.config/desktop-themes/browser-extension'
        with zipfile.ZipFile(BUNDLE / 'desktop-theme-bridge-1.0.0.xpi') as zipped:
            self.assertEqual(json.loads(zipped.read('manifest.json')), json.loads((source / 'manifest.json').read_text()))
            for name in ['background.js', 'popup.html', 'popup.js']:
                self.assertEqual(zipped.read(name), (source / name).read_bytes())

    def test_registration_uses_target_user_paths_and_keeps_signed_bytes(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp)
            config = home / '.config'
            shutil.copytree(REPO / '.config/desktop-themes', config / 'desktop-themes',
                            ignore=shutil.ignore_patterns('active.json', 'current', '.lock', 'backup*'))
            bins = home / '.local/bin'; bins.mkdir(parents=True)
            for name in ['desktop-theme-browser-host', 'desktop-theme-browser-setup']:
                shutil.copy2(REPO / '.local/bin' / name, bins / name)
            env = {**os.environ, 'HOME': str(home), 'XDG_CONFIG_HOME': str(config)}
            script = bins / 'desktop-theme-browser-setup'
            subprocess.run([str(script), '--check'], env=env, check=True, capture_output=True)
            self.assertFalse((home / '.mozilla').exists())
            subprocess.run([str(script)], env=env, check=True, capture_output=True)
            for relative in ['.mozilla/native-messaging-hosts', '.librewolf/native-messaging-hosts', '.config/librewolf/native-messaging-hosts']:
                data = json.loads((home / relative / 'io.github.fxmfxmfx.desktop_theme.json').read_text())
                self.assertEqual(data['path'], str(bins / 'desktop-theme-browser-host'))
                self.assertEqual(data['allowed_extensions'], ['desktop-theme@mango-dotfiles.local'])
            self.assertFalse((config / 'desktop-themes/browser-bridge-unsigned.xpi').exists())
            for path in BUNDLE.glob('*.xpi'):
                self.assertEqual(path.read_bytes(), (config / 'desktop-themes/browser-addons' / path.name).read_bytes())

    def test_vesktop_has_two_presets_and_one_managed_bootstrap(self):
        themes = REPO / '.config/vesktop/themes'
        self.assertEqual({p.name for p in themes.glob('*.css')},
                         {'GruvboxSharp.theme.css', 'CatppuccinMochaSharp.theme.css', 'DesktopTheme.theme.css'})
        self.assertIn('vencord:///themes/GruvboxSharp.theme.css', (themes / 'DesktopTheme.theme.css').read_text())


if __name__ == '__main__':
    unittest.main()
