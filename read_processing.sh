# cargar anaconda
source /opt/miniconda3/bin/activate metabarcoding

# cortar adaptadores
cutadapt -g $(cat /home/daemsel/its3.fna) -G $(cat /home/daemsel/its4.fna) --discard-untrimmed -o filtered/$1.1.np.fastq.gz -p filtered/$1.2.np.fastq.gz reads/$1"__2_ITS2_1".fastq.gz reads/$1"__2_ITS2_2".fastq.gz

# filtrado por calidad
/home/daemsel/fastp -i filtered/$1.1.np.fastq.gz -I filtered/$1.2.np.fastq.gz -o filtered/$1.1.qt.fastq.gz -O filtered/$1.2.qt.fastq.gz --cut_right -W 4 -M 20 --length_required 200 --thread 2 --merge --merged_out filtered/$1.merged.fastq.gz --html filtered/$1.fastp.log.html

# fastq a fasta
seqtk seq -a filtered/$1.merged.fastq.gz > filtered/$1.fna

# renombrar
seqtk rename filtered/$1.fna $1"_" | cut -f1 -d" " > filtered/$1.r.fna

# orientar
vsearch --orient filtered/$1.r.fna --db /home/daemsel/General_EUK_ITS_v2.0.fasta --fastaout filtered/$1.ro.fna 

# dereplicar
vsearch --derep_fulllength filtered/$1.ro.fna --output filtered/$1.rod.fna --sizeout

# denoise
vsearch --cluster_unoise filtered/$1.rod.fna --centroids filtered/$1.rodu.fna --sizein --sizeout --minsize 8 --threads 4

# detectar quimeras
vsearch --uchime_denovo filtered/$1.rodu.fna --nonchimeras filtered/$1.rodun.fna

# agregar sampleid
awk '/^>/ { print $0 ";sample='${1}';" } !/^>/ { print }' filtered/$1.rodun.fna > filtered/$1.rodunl.fna

echo Done!