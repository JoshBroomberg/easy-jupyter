## Start from a core stack version
FROM jupyter/datascience-notebook:latest

## Upgrade pip
RUN pip install --upgrade pip

## Set user for reset of script
USER $NB_USER

#RUN pip install --upgrade jupyterlab

## Set env
ENV JUPYTER_ENABLE_LAB no # default to lab?

## Download and enable Notebook extensions
RUN pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --user && \
    # can modify or enable additional extensions here
    jupyter nbextension enable spellchecker/main --user

# Colab extension
RUN pip install jupyter_http_over_ws && \
    jupyter serverextension enable --py jupyter_http_over_ws

## Download and install Lab extensions

# Code formatting
#RUN jupyter labextension install @ryantam626/jupyterlab_code_formatter && \
#    pip install jupyterlab_code_formatter && \
#    jupyter serverextension enable --py jupyterlab_code_formatter  && \
#    pip install yapf  && \
#    pip install black

# Spell checking
# RUN jupyter labextension install @ijmbarr/jupyterlab_spellchecker

## Install from requirements.txt file
COPY requirements.txt /tmp/

RUN pip install --requirement /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
