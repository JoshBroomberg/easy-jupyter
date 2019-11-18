## Start from a core stack version
FROM easyjupyter/jupyter-ds-gpu:latest

## Root commands
USER root

RUN sudo apt-get -y update && \
  sudo apt-get install -y rsync && \
  sudo apt-get install -y software-properties-common && \
  sudo apt-get install -y libcurl4-openssl-dev libssl-dev && \
  sudo apt-get install -y libxml2 libxml2-dev && \
  #sudo apt-get install -y r-base && \
  #sudo apt-get install -y r-base-dev && \
  sudo apt-get clean

# Configure R 3.6
# https://cran.r-project.org/bin/linux/ubuntu/
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran35/" >> /etc/apt/sources.list
RUN echo "deb http://mirror.enzu.com/ubuntu/ bionic-backports main restricted universe" >> /etc/apt/sources.list
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN sudo add-apt-repository ppa:marutter/c2d4u3.5
RUN sudo apt update && \
  sudo apt install -y r-base r-base-core r-recommended && \
  sudo apt-get install -y r-base-dev && \
  sudo apt install -y r-cran-devtools r-cran-roxygen2 && \
  sudo apt-get clean

## Configure R
COPY r_packages.R /tmp
RUN sudo Rscript /tmp/r_packages.R

## User Commands: set Jovyan as user for rest of script
USER $NB_USER

## Upgrade Jupyter Notebook/Lab

RUN pip install --upgrade jupyterlab && pip install --upgrade notebook && \
  ## Download and enable Notebook extensions
  pip install --upgrade jupyter_contrib_nbextensions && \
  jupyter contrib nbextension install --user && \
  ## Install Google Colab Server Extension
  pip install jupyter_http_over_ws && \
  jupyter serverextension enable --py jupyter_http_over_ws && \
  ## Install NBConvert Export Formatting
  pip install nb_pdf_template && \
  python -m nb_pdf_template.install && \
  ## Install themes
  pip install jupyterthemes && \
  jt -T -t grade3

# Initialize plotting config at start up
# TODO: this doesn't work right now.
# COPY startup.ipy .ipython/profile_default/startup/

## Download and install Lab extensions

RUN jupyter labextension install @ryantam626/jupyterlab_code_formatter --no-build && \
    ## Code formatting
    pip install jupyterlab_code_formatter && \
    jupyter serverextension enable --py jupyterlab_code_formatter  && \
    pip install yapf  && \
    pip install black && \
    ## Spell checking
    jupyter labextension install @ijmbarr/jupyterlab_spellchecker --no-build && \
    ## Build
    jupyter lab build

## Install python packages from requirements.txt file
COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Set destination for tmp R library installation.
RUN mkdir -p /home/jovyan/lib/R/packages
ENV R_LIBS_USER=/home/jovyan/lib/R/packages
