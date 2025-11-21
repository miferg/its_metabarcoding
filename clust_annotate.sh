# cargar anaconda
source /opt/miniconda3/bin/activate metabarcoding

# unir secuencias en un solo archivo
cat filtered/*.rodunl.fna > clustering/itsall.fna

# agrupar al 97% de identidad
vsearch --cluster_fast clustering/itsall.fna --id 0.97 --centroids clustering/itsall.97.fna -uc clustering/itsall.97.uc.txt --otutabout clustering/itsall.97.tsv --threads 4

# anotar taxonomia
vsearch --sintax clustering/itsall.97.fna --db /home/daemsel/SINTAX_EUK_ITS_v2.0.fasta --sintax_cutoff 0.8 --tabbedout annotation/itsall_eukits.sintax.tsv --threads 4