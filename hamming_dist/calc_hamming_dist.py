# This script finds pairwise distances of entries in an alignment file

import sys
import argparse
from Bio import SeqIO
from multiprocessing import Pool
import functools
import random

def main():
    args = parse_args()

    # Read in sequences
    with open(args.infile) as f:
        n_seqs = int(len(f.readlines()) / 2)
    with open(args.infile) as f:
        f.readline()
        aln_length = len(f.readline()) - 1  # -1 for newline character

    seqs = [ '' for i in range(n_seqs) ]
    headers = [ '' for i in range(n_seqs) ]

    if args.estimate:
        n_positions = int(aln_length * args.estfreq)
        sampled_positions = random.sample(range(0, aln_length), n_positions)
        # logmsg(sampled_positions)

    i = 0
    for rec in SeqIO.parse(args.infile, "fasta"):
        try:
            assert len(rec.seq) == aln_length
        except AssertionError:
            print("Some sequences appear un-aligned!")
            print("{} is length {} instead of expected {}.".format(rec.id, len(rec.seq), aln_length))
            raise
        if args.estimate:
            all_bases = [base for base in rec.seq]
            selected_bases = [all_bases[i] for i in sampled_positions]
            seqs[i] = ''.join(selected_bases)
        else:
            seqs[i] = rec.seq
        headers[i] = rec.id
        i += 1

    logmsg("Loaded {} sequences for comparison".format(n_seqs))

    # Work through tuples of sequence idxs, calculating distances between respective sequences
    jobs = [ (i, j) for i in range(n_seqs) for j in range(i + 1, n_seqs) ]

    with Pool(args.numcpus) as p:
        for i, _ in enumerate(p.imap(functools.partial(pairwise_distance, seqs, headers), jobs)):
            if i % 100 == 0:
                logmsg('{} queries left in the queue\n'.format(len(jobs) - i))


def parse_args():
    parser = argparse.ArgumentParser(description = "Find pairwise distances of entries in an alignment file.")
    parser.add_argument('infile')
    parser.add_argument('outfile', nargs="?", type=argparse.FileType('w'), default=sys.stdout)
    parser.add_argument('-n', '--numcpus', type=int, default=1, help="Number of CPUs (default: 1).")
    parser.add_argument('-e', '--estimate', action='store_true', help="Estimate the number of pairwise distances using random sampling. 1/4 of all pairwise bases will be analyzed instead of 100%%.")
    parser.add_argument('-s', '--estfreq', type=float, default=0.25, help="(to be used with -e) The frequency at which to analyze positions for pairwise differences.")
    return parser.parse_args()


def logmsg(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def pairwise_distance(seqs, headers, idx_tuple):
    bases = ['a', 'c', 't', 'g']
    seq_i = seqs[idx_tuple[0]]
    seq_j = seqs[idx_tuple[1]]
    dist = 0

    nt_pairs = zip(seq_i, seq_j)
    for nt_pair in nt_pairs:
        base_1 = nt_pair[0].lower()
        base_2 = nt_pair[1].lower()
        if base_1 != base_2 and base_1 in bases and base_2 in bases:
            dist += 1
    print("{}\t{}\t{}".format(headers[idx_tuple[0]], headers[idx_tuple[1]], dist), flush=True)
    return None


if __name__ == '__main__':
    main()
