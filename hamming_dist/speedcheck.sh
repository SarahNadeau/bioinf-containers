#!/bin/bash

echo "N, M, N_CPU, EST_FREQ, runtime_pl, runtime_py, runtime_py_minus_pl" > speedcheck.txt

for N_CPU in 1 2 3; do
  for N in 80; do
    for M in 5000 10000 50000; do

      # Simulate an alignment
      python3 simulate_alignment.py -n $N -m $M

      for EST_FREQ in 1.0 "NONE"; do

        if [ "$EST_FREQ" == "NONE" ]; then
          # Test speed of perl program
          start_pl=`date +%s`
          perl pairwiseDistances.pl -n $N_CPU simulated.fasta
          end_pl=`date +%s`
          runtime_pl=$((end_pl-start_pl))

          # Test speed of python program
          start_py=`date +%s`
          python3 calc_hamming_dist.py -n $N_CPU simulated.fasta
          end_py=`date +%s`
          runtime_py=$((end_py-start_py))
        else
          # Test speed of perl program
          start_pl=`date +%s`
          perl pairwiseDistances.pl -n $N_CPU -e -s $EST_FREQ simulated.fasta
          end_pl=`date +%s`
          runtime_pl=$((end_pl-start_pl))

          # Test speed of python program
          start_py=`date +%s`
          python3 calc_hamming_dist.py -n $N_CPU -e -s $EST_FREQ simulated.fasta
          end_py=`date +%s`
          runtime_py=$((end_py-start_py))
        fi

        # Write out results
        echo "$N, $M, $N_CPU, $EST_FREQ, $runtime_pl, $runtime_py, $((runtime_py-runtime_pl))" >> speedcheck.txt

      done

      # Remove simulated alignment
      rm simulated.fasta

    done
  done
done