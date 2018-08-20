FROM jupyter/datascience-notebook

COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json

USER root

# Install the icommands, curl, and wget
RUN apt-get update \
    && apt-get install -y lsb wget apt-transport-https python2.7 python-requests curl

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.irods.org/apt/ xenial main" > /etc/apt/sources.list.d/renci-irods.list \
    && apt-get update \
    && apt-get install -y irods-icommands


RUN chown -R jovyan /opt/conda/

USER jovyan

# Install the irods plugin for jupyter lab
RUN pip install jupyterlab_irods
RUN jupyter serverextension enable --py jupyterlab_irods
RUN jupyter labextension install @towicode/jupyterlab_irods

ENTRYPOINT ["jupyter"]
CMD ["lab", "--no-browser"]
