import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

from lego_compiler.common import ROOT
from scripts.check_public_tree import findings


class PublicationCheckTests(unittest.TestCase):
    def test_placeholder_is_allowed_but_credentials_are_detected(self):
        self.assertEqual(findings(b'api_key="xxxx"'), [])
        self.assertIn("provider credential", findings(b"sk-" + b"a" * 32))

    def test_report_never_prints_the_detected_value(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            secret = "sk-" + "a" * 32
            (root / "fixture.txt").write_text(secret)
            subprocess.run(["git", "init", "--quiet", str(root)], check=True)
            subprocess.run(["git", "add", "fixture.txt"], cwd=root, check=True)
            result = subprocess.run(
                [sys.executable, str(ROOT / "scripts/check_public_tree.py")],
                cwd=root,
                capture_output=True,
                text=True,
            )
            self.assertEqual(result.returncode, 1)
            self.assertIn("fixture.txt", result.stdout)
            self.assertNotIn(secret, result.stdout + result.stderr)
