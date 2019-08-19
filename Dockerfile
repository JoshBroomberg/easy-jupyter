# Start from a core stack version
FROM jupyter/datascience-notebook:9f9e5ca8fe5a

# Set user for reset of script
USER $NB_USER

# Set env
ENV JUPYTER_ENABLE_LAB no # default to lab?

# Download and enable extensions
RUN pip install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --user && \
    # can modify or enable additional extensions here
    jupyter nbextension enable spellchecker/main --user

# Download and enable the colab extension
RUN pip install jupyter_http_over_ws && \
    jupyter serverextension enable --py jupyter_http_over_ws

# Install from requirements.txt file
COPY requirements.txt /tmp/

RUN pip install --upgrade pip

RUN pip install --requirement /tmp/requirements.txt && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

