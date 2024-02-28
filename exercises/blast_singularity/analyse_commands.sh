#!/bin/bash
# use docker://quay.io/biocontainers/blast:2.9.0--pl526h3066fca_4
module load blast/2.12.0--pl5262h3289130_0
cd ../blast_db
makeblastdb -in zebrafish.1.protein.faa -dbtype prot
cd -

blastp -query P04156.fasta -db $TUTO/demos/blast_db/zebrafish.1.protein.faa -out results.txt
