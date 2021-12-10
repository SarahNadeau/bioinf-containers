import unittest
import subprocess
from subprocess import PIPE


class TestVersions(unittest.TestCase):

    def test_harvesttools_version(self):
        bash_cmd = "ClonalFrameML -version"
        result = subprocess.run(bash_cmd, shell=True, stdout=PIPE)
        self.assertEqual(result.stdout, b"ClonalFrameML v1.12\n")


if __name__ == '__main__':
    unittest.main()
