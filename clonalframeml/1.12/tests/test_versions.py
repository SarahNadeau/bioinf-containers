import unittest
import subprocess
from subprocess import PIPE
import re

class TestVersions(unittest.TestCase):

    def test_harvesttools_version(self):
        bash_cmd = "ClonalFrameML -version"
        result = subprocess.run(bash_cmd, shell=True, stdout=PIPE)
        self.assertEqual(result.stdout, b"ClonalFrameML v1.12\n")

    def test_r_version(self):
        bash_cmd = "R --version"
        result = subprocess.run(bash_cmd, shell=True, stdout=PIPE)
        assert re.search(b"4.0.5 \(2021-03-31\)", result.stdout)


if __name__ == '__main__':
    unittest.main()
