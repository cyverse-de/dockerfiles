FROM jupyter/datascience-notebook
COPY jupyter_notebook_config.json /opt/conda/etc/jupyter/jupyter_notebook_config.json
USER root
RUN apt-get update && apt-get install -y curl wget
USER jovyan
ENTRYPOINT ["jupyter"]
CMD ["lab", "--no-browser"]
