import unittest
import subprocess
from subprocess import PIPE


class TestVersions(unittest.TestCase):

    def test_harvesttools_version(self):
        bash_cmd = "harvesttools --version"
        result = subprocess.run(bash_cmd, shell=True, stdout=PIPE)
        self.assertEqual(result.stdout, b"1.3\n")


if __name__ == '__main__':
    unittest.main()
