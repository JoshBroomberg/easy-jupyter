## Start from a core stack version
FROM jupyter/datascience-notebook:latest

## Set user for rest of script
USER $NB_USER

# Upgrade Jupyter Notebook/Lab
RUN pip install --upgrade jupyterlab && pip install --upgrade notebook

## Download and enable Notebook extensions
RUN pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --user

## Modify or enable additional nbextensions here
RUN jupyter nbextension enable spellchecker/main --user

## Install Google Colab Server Extension
RUN pip install jupyter_http_over_ws && \
    jupyter serverextension enable --py jupyter_http_over_ws

## Install NBConvert Export Formatting
RUN pip install nb_pdf_template && \
    python -m nb_pdf_template.install

## Install Jupyter Themes

# Install themes
RUN pip install jupyterthemes && \
  jt -t grade3

# Initialize plotting config at start up
COPY startup.ipy .ipython/profile_default/startup/

## Download and install Lab extensions

# Code formatting
RUN jupyter labextension install @ryantam626/jupyterlab_code_formatter && \
    pip install jupyterlab_code_formatter && \
    jupyter serverextension enable --py jupyterlab_code_formatter  && \
    pip install yapf  && \
    pip install black

# Spell checking
RUN jupyter labextension install @ijmbarr/jupyterlab_spellchecker

## Install from requirements.txt file
COPY requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
