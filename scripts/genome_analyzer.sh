#!/bin/bash

file=$1

echo "Genome Summary Report"
echo "---------------------"

seqs=$(grep -c ">" $file)
echo "Sequences: $seqs"

awk '/^>/ {if (len){print len}; print; len=0; next} {len+=length($0)} END{print len}' $file > sizes.txt

largest=$(grep -v ">" sizes.txt | sort -nr | head -1)
smallest=$(grep -v ">" sizes.txt | sort -n | head -1)

echo "Largest sequence: $largest bp"
echo "Smallest sequence: $smallest bp"

awk '!/^>/' $file > tmpseq.txt
total=$(tr -d '\n' < tmpseq.txt | wc -c)
gc=$(tr -d '\n' < tmpseq.txt | grep -o "[GC]" | wc -l)

gcperc=$(echo "scale=2; $gc/$total*100" | bc)
echo "GC Content: $gcperc%"

rm sizes.txt tmpseq.txt
