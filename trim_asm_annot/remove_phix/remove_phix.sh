#!/bin/bash

# This script removes PhiX reads using BBDuk.

source /shared_scripts/verify_file.sh
source /shared_scripts/log_trace.sh

# Set default minimum expected output file size if not already specified
MIN_OUTSIZE=${MIN_OUTSIZE:-"25M"}

# Remove PhiX
/bbmap/bbduk.sh threads=$NSLOTS k=31 hdist=1 \
  ref="$PHIX" in="$R1" in2="$R2"\
  out=$O/trim_reads/"${B}"-noPhiX-R1.fsq out2=$O/trim_reads/"$B"-noPhiX-R2.fsq\
  qin=auto qout=33 overwrite=t # > $O/.log/TrimAsmAnnot.${B}

# Summarize PhiX removal
for suff in R1.fsq R2.fsq ; do
    verify_file "${O}/trim_reads/${B}-noPhiX-${suff}" 'PhiX cleaned read' $MIN_OUTSIZE
  done
  TOT_READS=$(grep '^Input: ' $O/.log/TrimAsmAnnot.${B} \
   | awk '{print $2}')
  TOT_BASES=$(grep '^Input: ' $O/.log/TrimAsmAnnot.${B} \
   | awk '{print $4}')
  if [[ -z "${TOT_READS}" || -z "${TOT_BASES}" ]]; then
    'ERROR: unable to parse input counts from bbduk log' >&2
    exit 1
  fi
  PHIX_READS=$(grep '^Contaminants: ' $O/.log/TrimAsmAnnot.${B} \
   | awk '{print $2}' | sed 's/,//g')
  PHIX_BASES=$(grep '^Contaminants: ' $O/.log/TrimAsmAnnot.${B} \
   | awk '{print $5}' | sed 's/,//g')
  echo "INFO: $TOT_BASES bp and $TOT_READS reads provided as raw input" >&2
  echo "INFO: ${PHIX_BASES:-0} bp of PhiX were detected and removed in ${PHIX_READS:-0} reads" >&2
  echo -e "${B}\t${TOT_BASES} bp Raw\t${TOT_READS} reads Raw" \
   > $O/trim_reads/"$B".raw.tsv
  echo -e "${B}\t${PHIX_BASES:-0} bp PhiX\t${PHIX_READS:-0} reads PhiX" \
   > $O/trim_reads/"$B".phix.tsv