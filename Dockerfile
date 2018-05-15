#
#inspired by ome/jupyter-docker
FROM jupyter/base-notebook:1dc1481636a2
# jupyter/base-notebook updated 2018-04-27
MAINTAINER anatole.chessel@polytechnique.edu

USER root
RUN apt-get update -y && \
    apt-get install -y \
        build-essential \
        curl \
        git

USER jovyan
# Default workdir: /home/jovyan

# Autoupdate notebooks https://github.com/data-8/nbgitpuller
RUN pip install git+https://github.com/data-8/gitautosync && \
    jupyter serverextension enable --py nbgitpuller

# create a python2 environment (for OMERO-PY compatibility)
RUN mkdir .setup
ADD environment-python3.yml .setup/
RUN conda env update -n root -f .setup/environment-python3.yml && \
    # Jupyterlab component for ipywidgets (must match jupyterlab version) \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager@^0.35

COPY . notebooks

# Autodetects jupyterhub and standalone modes
CMD ["start-notebook.sh"]
