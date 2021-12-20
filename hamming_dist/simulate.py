import random

def simulate_alignment(N=10, M=20000, sim_outfile="./sim_alignment.fasta"):

    with open(sim_outfile, 'w') as f:
        bases = ['A', 'C', 'T', 'G']
        for i in range(N):
            f.write('>Seq_' + str(i) + '\n')
            f.write(''.join(random.choices(bases, k=M)) + '\n')
