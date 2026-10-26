"""Check tracked content or reachable Git history without printing secret values."""

import argparse
import re
import subprocess
import sys
from pathlib import Path

PATTERNS = {
    "provider credential": rb"\b(?:sk-(?:proj-|ant-)?[A-Za-z0-9_-]{20,}|AIza[0-9A-Za-z_-]{30,})",
    "GitHub credential": rb"\b(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,})",
    "private key": rb"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----",
    "AWS access key": rb"\b(?:AKIA|ASIA)[A-Z0-9]{16}\b",
    "personal absolute path": rb"/(?:Users|home)/[^/\s\"']+/",
}


def findings(data):
    return [name for name, pattern in PATTERNS.items() if re.search(pattern, data)]


def history_blobs():
    objects = subprocess.check_output(
        ["git", "rev-list", "--objects", "--branches", "--tags", "--remotes"], text=True
    )
    paths = dict(line.split(" ", 1) for line in objects.splitlines() if " " in line)
    metadata = subprocess.check_output(
        ["git", "cat-file", "--batch-check=%(objectname) %(objecttype)"],
        input="\n".join(paths) + "\n",
        text=True,
    )
    for row in metadata.splitlines():
        object_id, kind = row.split()
        if kind == "blob":
            yield paths[object_id], subprocess.check_output(["git", "cat-file", "blob", object_id])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--history", action="store_true", help="Check branch, tag and remote-tracking histories"
    )
    args = parser.parse_args()
    if args.history:
        items = history_blobs()
    else:
        names = subprocess.check_output(["git", "ls-files", "-z"]).decode().split("\0")
        items = ((name, Path(name).read_bytes()) for name in names if name and Path(name).is_file())
    failures = 0
    scanned = 0
    for path, data in items:
        scanned += 1
        for kind in findings(data):
            print(f"{path}: {kind} detected (value omitted)")
            failures += 1
    print(f"Scanned {scanned} files/blobs; {failures} findings.")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
