# cargar anaconda
source /opt/miniconda3/bin/activate base

# preparar ambiente de anaconda
conda create -n metabarcoding -c conda-forge r-vegan r-inext r-irkernel bioconda::cutadapt bioconda::vsearch bioconda::seqtk ipykernel --yes

# cargar nuevo ambiente
source /opt/miniconda3/bin/activate metabarcoding

# iniciar kernel de R
R -e "IRkernel::installspec(name = 'mbc_r', displayname = 'mbc_r')"

# iniciar kernel de python
python -m ipykernel install --user --name=metabarcoding --display-name="mbc_python"

# crear directorios
mkdir filtered
mkdir clustering
mkdir annotation

# copiar lecturas
cp -r /home/daemsel/reads reads

# crear archivo con nombres de muestras
ls reads/ | cut -f1 -d"_" | sort | uniq > sampleids.txt