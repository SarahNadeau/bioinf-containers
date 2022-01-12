trimmomatic PE -phred33 -threads $NSLOTS\
   $O/trim_reads/"$B"-noPhiX-R1.fsq $O/trim_reads/"$B"-noPhiX-R2.fsq\
   $O/trim_reads/"$B"_R1.paired.fq $O/trim_reads/"$B"_R1.unpaired.fq\
   $O/trim_reads/"$B"_R2.paired.fq $O/trim_reads/"$B"_R2.unpaired.fq\
   ILLUMINACLIP:$ADAPTERS:2:20:10:8:TRUE\
   SLIDINGWINDOW:6:30 LEADING:10 TRAILING:10 MINLEN:50