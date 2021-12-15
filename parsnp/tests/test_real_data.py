import unittest
import subprocess
from subprocess import PIPE
import os

class TestOutput(unittest.TestCase):
    is_github = os.environ.get('IS_GITHUB') == 'T'
    if not is_github:
        print("Skipping tests using a reference checksum. To run, specify --build-arg IS_GITHUB='T' for the build.")

    # Run this once to have the outputs for all tests
    @classmethod
    def setUpClass(cls):
        bash_cmd = "bash /tests/scripts/run_real_data.sh"
        subprocess.run(bash_cmd, shell=True, stdout=PIPE)

        # Print files for debugging GH actions checksum mismatch
        print("FastTree results for debugging:")
        with open("/data/outdir_parsnp_fasttree/snp_alignment.txt", 'r') as f:
            print(f.read())
        with open("/data/outdir_parsnp_fasttree/parsnp.tree", 'r') as f:
            print(f.read())

    def test_alignments_equal(self):
        with open("/data/outdir_parsnp_fasttree/parsnp.xmfa.checksum", 'r') as f:
            fasttree_aln_test_hash = f.readlines()[0].split(" ")[0]
        with open("/data/outdir_parsnp_raxml/parsnp.xmfa.checksum", 'r') as f:
            raxml_aln_test_hash = f.readlines()[0].split(" ")[0]
        self.assertEqual(fasttree_aln_test_hash, raxml_aln_test_hash)

    def test_fasttree_tree_dist_to_ref(self):
        bash_cmd = "rf /data/outdir_parsnp_fasttree/parsnp.tree /tests/files/ref.tre"
        rf_dist = subprocess.run(bash_cmd, shell=True, stdout=PIPE, universal_newlines=True).stdout
        print("Robinson-Foulds distance between FastTree tree and reference tree is: " + rf_dist)
        self.assertLessEqual(float(rf_dist), 0.5)

    def test_raxml_tree_dist_to_ref(self):
        bash_cmd = "rf /data/outdir_parsnp_raxml/parsnp_quoted.tree /tests/files/ref.tre"
        rf_dist = subprocess.run(bash_cmd, shell=True, stdout=PIPE, universal_newlines=True).stdout
        print("Robinson-Foulds distance between RAxML tree and reference tree is: " + rf_dist)
        self.assertLessEqual(float(rf_dist), 0.5)

    def test_fasttree_tree_dist_to_raxml_tree(self):
        bash_cmd = "rf /data/outdir_parsnp_fasttree/parsnp.tree /data/outdir_parsnp_raxml/parsnp_quoted.tree"
        rf_dist = subprocess.run(bash_cmd, shell=True, stdout=PIPE, universal_newlines=True).stdout
        print("Robinson-Foulds distance between FastTree tree and RAxML tree is: " + rf_dist)
        self.assertLessEqual(float(rf_dist), 0.5)

    # Run only if in GitHub actions workflow because builds on different machines yield different alignments, treefiles
    @unittest.skipIf(not is_github, "Skipping because checksums are only valid for image built by GitHub actions workflow.")
    def test_alignments_vs_ref_checksum(self):
        aln_ref_hash = "dad980b7c9a043b335817dbbf4805967a04142b5878bc834faf0ae91fdf6e635"
        with open("/data/outdir_parsnp_raxml/parsnp.xmfa.checksum", 'r') as f:
            raxml_aln_test_hash = f.readlines()[0].split(" ")[0]
        self.assertEqual(raxml_aln_test_hash, aln_ref_hash)

    @unittest.skipIf(not is_github, "Skipping because checksums are only valid for image built by GitHub actions workflow.")
    def test_fasttree_treefile_vs_ref_checksum(self):
        fasttree_tree_ref_hash = "15232b68d14929f3efa9d6c315a4f8e8e41ef462b6951df157d1f5095a45263b"
        with open("/data/outdir_parsnp_fasttree/parsnp.tree.checksum", 'r') as f:
            fasttree_tree_test_hash = f.readlines()[0].split(" ")[0]
        self.assertEqual(fasttree_tree_test_hash, fasttree_tree_ref_hash)

    @unittest.skipIf(not is_github, "Skipping because checksums are only valid for image built by GitHub actions workflow.")
    def test_raxml_treefile_vs_ref_checksum(self):
        raxml_tree_ref_hash = "f4fe7f25d432694e27329f6c16472a8b02a19e97274e536d95c2deb52bb44445"
        with open("/data/outdir_parsnp_raxml/parsnp.tree.checksum", 'r') as f:
            raxml_tree_test_hash = f.readlines()[0].split(" ")[0]
        self.assertEqual(raxml_tree_test_hash, raxml_tree_ref_hash)


if __name__ == '__main__':
    unittest.main()
