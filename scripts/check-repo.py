#!/usr/bin/env python3
"""Check repository data, script syntax and tests without a desktop or network."""
import json
from pathlib import Path
import os
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def main():
    result = subprocess.run(
        ['git', 'ls-files', '-z', '--cached', '--others', '--exclude-standard'],
        cwd=ROOT, check=True, capture_output=True)
    paths = sorted({ROOT / os.fsdecode(p) for p in result.stdout.split(b'\0') if p})
    checked = 0
    skipped = set()
    errors = []
    for path in paths:
        if not path.is_file():
            continue
        label = str(path.relative_to(ROOT))
        try:
            if path.suffix == '.json':
                json.loads(path.read_text())
                checked += 1
            elif path.suffix == '.toml':
                try:
                    import tomllib
                except ImportError:
                    skipped.add('TOML validation (requires Python 3.11+)')
                else:
                    tomllib.loads(path.read_text())
                    checked += 1
            with path.open('rb') as stream:
                header = stream.readline(256).decode('utf-8', errors='replace').strip()
            interpreter = None
            if header.startswith('#!'):
                words = header[2:].split()
                interpreter = Path(words[0]).name if words else None
                if interpreter == 'env' and len(words) > 1:
                    interpreter = words[1]
            if path.name == '.zshrc' or path.suffix == '.zsh':
                interpreter = 'zsh'
            if interpreter in {'python', 'python3'} or path.suffix == '.py':
                compile(path.read_text(), label, 'exec')
                checked += 1
            elif interpreter in {'sh', 'bash', 'zsh'}:
                if shutil.which(interpreter):
                    subprocess.run([interpreter, '-n', str(path)], check=True,
                                   capture_output=True, text=True)
                    checked += 1
                else:
                    skipped.add(interpreter + ' syntax checks (not installed)')
            elif path.suffix == '.js':
                if shutil.which('node'):
                    subprocess.run(['node', '--check', str(path)], check=True,
                                   capture_output=True, text=True)
                    checked += 1
                else:
                    skipped.add('JavaScript syntax checks (node not installed)')
        except (OSError, ValueError, SyntaxError, subprocess.CalledProcessError) as error:
            detail = error.stderr if isinstance(error, subprocess.CalledProcessError) else str(error)
            errors.append(f'{label}: {detail}')
    print(f'Data/script syntax: {checked} checks', flush=True)
    for item in sorted(skipped):
        print('Skipped: ' + item, flush=True)
    for error in errors:
        print(error, file=sys.stderr)
    tests = subprocess.run(
        [sys.executable, '-m', 'unittest', 'discover', '-s', 'tests', '-v'],
        cwd=ROOT, env={**os.environ, 'PYTHONDONTWRITEBYTECODE': '1'})
    return 1 if errors or tests.returncode else 0


if __name__ == '__main__':
    sys.exit(main())
