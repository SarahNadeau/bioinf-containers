import unittest
import subprocess
from subprocess import PIPE


class TestVersions(unittest.TestCase):

    def test_parsnp_version(self):
        bash_cmd = "parsnp --version"
        result = subprocess.run(bash_cmd, shell=True, stdout=PIPE)
        self.assertEqual(result.stdout, b"parsnp 1.5.6\n")

# TODO: put in data, check what comes out looks right
# class TestOutputFormat(unittest.TestCase):
#
#     def test_parsnp_output_format(self):
#         bash_cmd = "parsnp"


if __name__ == '__main__':
    unittest.main()
