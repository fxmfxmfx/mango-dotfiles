"""Theme file generation and rollback tests; never reload the real desktop.

Run: python3 -m unittest discover -s tests -v
"""
import contextlib
import importlib.machinery
import importlib.util
import io
import json
import os
from pathlib import Path
import shutil
import sys
import tempfile
import unittest
from unittest.mock import patch

REPO = Path(__file__).resolve().parents[1]


class ThemeTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.config = Path(self.temp.name) / '.config'
        self.config.mkdir()
        for component in ['desktop-themes', 'rofi', 'foot', 'mango', 'dunst', 'rs-yambar', 'rs-wwidget']:
            shutil.copytree(REPO / '.config' / component, self.config / component,
                            ignore=shutil.ignore_patterns('active.json', 'current', '.lock', 'backup*'))
        # Test themes use no assigned image, so tests don't depend on HOME assets.
        for theme in (self.config / 'desktop-themes/themes').glob('*.json'):
            data = json.loads(theme.read_text())
            data['wallpaper'] = None
            theme.write_text(json.dumps(data))
        loader = importlib.machinery.SourceFileLoader('desktop_theme', str(REPO / '.local/bin/desktop-theme'))
        with patch.dict(os.environ, {'XDG_CONFIG_HOME': str(self.config)}):
            self.module = importlib.util.module_from_spec(importlib.util.spec_from_loader(loader.name, loader))
            loader.exec_module(self.module)

    def snapshot(self):
        return {p.relative_to(self.config): p.read_bytes()
                for p in self.config.rglob('*') if p.is_file() and p.name != '.lock'}

    def call_main(self, *args):
        with patch.object(sys, 'argv', ['desktop-theme', *args]), \
             patch.object(self.module, 'refresh', return_value=True), \
             patch.object(self.module, 'apply_wallpaper'), \
             patch.object(self.module.shutil, 'which', return_value=None), \
             contextlib.redirect_stdout(io.StringIO()):
            self.module.main()

    def test_both_palettes_generate_complete_active_state(self):
        for name, expected in [('cflowers', '0c0c0c'), ('gruvbox', '282828')]:
            with self.subTest(name=name):
                files = self.module.render(self.module.palette(name))
                active = json.loads(files[self.module.ROOT / 'active.json'])
                self.assertEqual(active['name'], name)
                self.assertEqual(active['terminal']['background'], expected)
                self.assertEqual(len(files), 7)

    def test_check_does_not_write_configs_or_refresh(self):
        before = self.snapshot()
        with patch.object(self.module, 'validate'), \
             patch.object(self.module, 'refresh') as refresh, \
             patch.object(sys, 'argv', ['desktop-theme', '--check', 'gruvbox']), \
             contextlib.redirect_stdout(io.StringIO()):
            self.module.main()
        self.assertEqual(self.snapshot(), before)
        refresh.assert_not_called()

    def test_apply_changes_colors_and_preserves_geometry(self):
        with patch.object(self.module, 'validate'):
            self.call_main('gruvbox')
        self.assertEqual((self.module.ROOT / 'current').read_text(), 'gruvbox\n')
        bar = (self.config / 'rs-yambar/config.toml').read_text()
        self.assertIn('height = 28', bar)
        self.assertIn('background = "#282828ff"', bar)
        self.assertIn('background=282828', (self.config / 'foot/foot.ini').read_text())

    def test_invalid_wallpaper_stops_before_writing(self):
        path = self.module.ROOT / 'themes/gruvbox.json'
        data = json.loads(path.read_text()); data['wallpaper'] = 'https://example.invalid/image.png'
        path.write_text(json.dumps(data)); before = self.snapshot()
        with self.assertRaises(ValueError):
            self.call_main('gruvbox')
        self.assertEqual(self.snapshot(), before)

    def test_write_failure_restores_previous_files(self):
        before = self.snapshot(); real_write = self.module.atomic_write; calls = 0
        def failing_write(path, text):
            nonlocal calls
            calls += 1
            if calls == 3:
                raise OSError('simulated disk failure')
            real_write(path, text)
        with patch.object(self.module, 'validate'), \
             patch.object(self.module, 'atomic_write', side_effect=failing_write), \
             self.assertRaises(OSError):
            self.call_main('gruvbox')
        self.assertEqual(self.snapshot(), before)

    def test_relative_wallpaper_is_based_on_theme_root(self):
        image = self.module.ROOT / 'images' / 'test image.png'
        image.parent.mkdir(); image.write_bytes(b'')
        self.assertEqual(self.module.wallpaper_path('images/test image.png'), image)
        self.assertIsNone(self.module.wallpaper_path(None))
        with self.assertRaises(ValueError):
            self.module.wallpaper_path(str(image.with_suffix('.mp4')))


if __name__ == '__main__':
    unittest.main()
