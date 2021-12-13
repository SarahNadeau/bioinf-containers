import unittest
import subprocess
from subprocess import PIPE

class TestOutput(unittest.TestCase):

    def test_real_data_output(self):
        bash_cmd = "bash /tests/scripts/run_real_data.sh"
        subprocess.run(bash_cmd, shell=True, stdout=PIPE)
        with open("/data/outdir_parsnp/parsnp.tree.checksum", 'r') as f:
            test_hash = f.readlines()[0]
        ref_hash = "930a9746bf3856a28ac1815fcb2ef36fe6e877844115bd5fc8ab8ab0ed765f8f  outdir_parsnp/parsnp.tree\n"
        self.assertEqual(test_hash, ref_hash)


if __name__ == '__main__':
    unittest.main()
