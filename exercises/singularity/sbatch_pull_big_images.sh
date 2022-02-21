#!/bin/bash -l

#SBATCH --job-name=pull_images
#SBATCH --ntasks=1
#SBATCH --time=06:00:00

# executing a dummy command just to cause images to be downloaded in the cache

singularity exec docker://quay.io/biocontainers/blast:2.9.0--pl526h3066fca_4 echo ciao
singularity exec docker://trinityrnaseq/trinityrnaseq:2.8.6 echo ciao
singularity exec docker://nextflow/rnaseq-nf:latest echo ciao