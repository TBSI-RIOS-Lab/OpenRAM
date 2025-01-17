#!/bin/bash
CONDA_INSTALLER_URL="https://repo.anaconda.com/miniconda/Miniconda3-py38_22.11.1-1-Linux-x86_64.sh"
CONDA_INSTALLER_FILE="miniconda_installer_py38.sh"
CONDA_BASE="miniconda"

TOOLS="klayout magic netgen ngspice trilinos xyce"

# Install miniconda if not installed
if [ ! -d "miniconda" ]
then
    curl -s -o ${CONDA_INSTALLER_FILE} ${CONDA_INSTALLER_URL}
    /bin/bash ${CONDA_INSTALLER_FILE} -b -p ${CONDA_BASE}
    rm ${CONDA_INSTALLER_FILE}
    source ${CONDA_BASE}/bin/activate

    # Prioritize channels to prevent version conflicts
    conda config --add channels conda-forge
    conda config --add channels vlsida-eda

    # Install iverilog from conda-eda
    conda install -q -y -c litex-hub iverilog

    # Install rest of the tools from vlsida-eda
    for tool in ${TOOLS}
    do
        conda install -q -y -c vlsida-eda ${tool}
    done

    conda deactivate
fi

