import unittest
import subprocess
from subprocess import PIPE
import os

class TestPositiveControl(unittest.TestCase):
    is_github = os.environ.get('IS_GITHUB') == 'T'
    if not is_github:
        print("Skipping tests using a reference checksum. To run, specify --build-arg IS_GITHUB='T' for the build.")

    # Run this once to have the outputs for all tests
    @classmethod
    def setUpClass(cls):
        bash_cmd = "bash /tests/scripts/run_positive_control.sh"
        subprocess.run(bash_cmd, shell=True, stdout=PIPE)

        # # Print files for debugging GH actions checksum mismatch
        # print("FastTree results for debugging:")
        # with open("/data/outdir_parsnp_fasttree/snp_alignment.txt", 'r') as f:
        #     print(f.read())
        # with open("/data/outdir_parsnp_fasttree/parsnp.tree", 'r') as f:
        #     print(f.read())
        # print("RAxML results for debugging (tree only):")
        # with open("/data/outdir_parsnp_raxml/parsnp.tree", 'r') as f:
        #     print(f.read())
        # print("Aligner log for debugging:")
        # with open("/data/outdir_parsnp_raxml/parsnpAligner.log", 'r') as f:
        #     print(f.read())

    def test_alignments_equal(self):
        with open("/data/pos_control/outdir_parsnp_fasttree/parsnp.xmfa.checksum", 'r') as f:
            fasttree_aln_test_hash = f.readlines()[0].split(" ")[0]
        with open("/data/pos_control/outdir_parsnp_raxml/parsnp.xmfa.checksum", 'r') as f:
            raxml_aln_test_hash = f.readlines()[0].split(" ")[0]
        self.assertEqual(fasttree_aln_test_hash, raxml_aln_test_hash)

    def test_fasttree_tree_dist_to_ref(self):
        bash_cmd = "rf /data/pos_control/outdir_parsnp_fasttree/parsnp.tree /tests/files/ref.tre"
        rf_dist = subprocess.run(bash_cmd, shell=True, stdout=PIPE, universal_newlines=True).stdout
        print("Robinson-Foulds distance between FastTree tree and reference tree is: " + rf_dist)
        self.assertLessEqual(float(rf_dist), 0.5)

    def test_raxml_tree_dist_to_ref(self):
        bash_cmd = "rf /data/pos_control/outdir_parsnp_raxml/parsnp_quoted.tree /tests/files/ref.tre"
        rf_dist = subprocess.run(bash_cmd, shell=True, stdout=PIPE, universal_newlines=True).stdout
        print("Robinson-Foulds distance between RAxML tree and reference tree is: " + rf_dist)
        self.assertLessEqual(float(rf_dist), 0.5)

    def test_fasttree_tree_dist_to_raxml_tree(self):
        bash_cmd = "rf /data/pos_control/outdir_parsnp_fasttree/parsnp.tree /data/pos_control/outdir_parsnp_raxml/parsnp_quoted.tree"
        rf_dist = subprocess.run(bash_cmd, shell=True, stdout=PIPE, universal_newlines=True).stdout
        print("Robinson-Foulds distance between FastTree tree and RAxML tree is: " + rf_dist)
        self.assertLessEqual(float(rf_dist), 0.5)

    # Run only if in GitHub actions workflow because builds on different machines yield different alignments, treefiles
    @unittest.skipIf(not is_github, "Skipping because checksums are only valid for image built by GitHub actions workflow.")
    def test_alignments_vs_ref_checksum(self):
        aln_ref_hash = "4f7f0c894af7598740e762ceae2d0694c3fa7dc46dcebc2ebb52cfe75686ee09"
        with open("/data/pos_control/outdir_parsnp_raxml/parsnp.xmfa.checksum", 'r') as f:
            raxml_aln_test_hash = f.readlines()[0].split(" ")[0]
        self.assertEqual(raxml_aln_test_hash, aln_ref_hash)

    @unittest.skipIf(not is_github, "Skipping because checksums are only valid for image built by GitHub actions workflow.")
    def test_fasttree_treefile_vs_ref_checksum(self):
        fasttree_tree_ref_hash = "edc556aa1a74de7d28332456e65bee4163d41fa36a2d380e0eb0170055fcbfb5"
        with open("/data/pos_control/outdir_parsnp_fasttree/parsnp.tree.checksum", 'r') as f:
            fasttree_tree_test_hash = f.readlines()[0].split(" ")[0]
        self.assertEqual(fasttree_tree_test_hash, fasttree_tree_ref_hash)

    @unittest.skipIf(not is_github, "Skipping because checksums are only valid for image built by GitHub actions workflow.")
    def test_raxml_treefile_vs_ref_checksum(self):
        raxml_tree_ref_hash = "14daa21714d8c5b61540bd0b0275cb9472f454237756fda992428002a241475f"
        with open("/data/pos_control/outdir_parsnp_raxml/parsnp.tree.checksum", 'r') as f:
            raxml_tree_test_hash = f.readlines()[0].split(" ")[0]
        self.assertEqual(raxml_tree_test_hash, raxml_tree_ref_hash)


class TestNegativeControl(unittest.TestCase):
    # Run this once to have the outputs for all tests
    @classmethod
    def setUpClass(cls):
        bash_cmd = "bash /tests/scripts/run_negative_control.sh"
        subprocess.run(bash_cmd, shell=True, stdout=PIPE)

    def test_filter(self):
        with open("/data/neg_control/outdir_parsnp_filter/parsnp.tree", 'r') as f:
            filter_tree = f.read()
        self.assertEqual('GCA_000748565.2_ASM74856v2_genomic.fna' in filter_tree, False)


if __name__ == '__main__':
    unittest.main()
