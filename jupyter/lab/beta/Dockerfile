FROM jupyter/datascience-notebook

COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

USER root

# Install the icommands, curl, and wget
RUN apt-get update \
    && apt-get install -y lsb wget apt-transport-https python2.7 python-requests curl gnupg \
    && apt-get clean \
    && rm -rf /usr/lib/apt/lists/* \
    && fix-permissions $CONDA_DIR

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.irods.org/apt/ xenial main" > /etc/apt/sources.list.d/renci-irods.list \
    && apt-get update \
    && apt-get install -y irods-icommands \
    && apt-get clean \
    && rm -rf /usr/lib/apt/lists/* \
    && fix-permissions $CONDA_DIR


# RUN chown -R jovyan /opt/conda/

USER jovyan

RUN conda update -n base conda \
 && conda install jupyterlab=0.33 \
 && conda clean -tipsy \
 && fix-permissions $CONDA_DIR
RUN jupyter lab --version \
 && jupyter labextension install @jupyterlab/hub-extension @jupyter-widgets/jupyterlab-manager@0.36 jupyterlab_bokeh

# Install the irods plugin for jupyter lab
#RUN pip install jupyterlab_irods
#RUN jupyter serverextension enable --py jupyterlab_irods
#RUN jupyter labextension install @towicode/jupyterlab_irods

ENTRYPOINT ["jupyter"]
CMD ["lab", "--no-browser"]
