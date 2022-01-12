import unittest
import subprocess
from subprocess import PIPE
import re

class TestVersions(unittest.TestCase):

    def test_bbtools_version(self):
        bash_cmd = "/bbmap/bbduk.sh --version"
        result = subprocess.run(bash_cmd, shell=True, stderr=PIPE)  # version info is output to stderr, not stdout
        assert re.search(b"BBMap version 38.94", result.stderr)


if __name__ == '__main__':
    unittest.main()
