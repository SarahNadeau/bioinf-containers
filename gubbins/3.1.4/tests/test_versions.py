import unittest
import subprocess
from subprocess import PIPE
import re

class TestVersions(unittest.TestCase):

    def test_gubbins_version(self):
        bash_cmd = "gubbins -h"
        result = subprocess.run(bash_cmd, shell=True, stdout=PIPE)
        assert re.search(b"Version: 3.1.4", result.stdout)


if __name__ == '__main__':
    unittest.main()
