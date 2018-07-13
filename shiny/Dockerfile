FROM rocker/shiny:latest

RUN chmod a+rwx /usr/local/lib/R/site-library
RUN apt-get update && apt-get install -y libgdal-dev libgdal20 libboost-all-dev libudunits2-0 libudunits2-data libudunits2-dev curl
RUN R -e "install.packages('shinythemes')"
RUN R -e "install.packages(c('Rcpp', 'stringi', 'plyr', 'reshape2', 'scales', 'units', 'digest', 'httpuv', 'htmltools', 'sf'))"
RUN R -e "install.packages(c('mime', 'glue', 'leaflet', 'dplyr', 'tidyr', 'jsonlite', 'rgdal'))" 
RUN chmod -R a+rwx /usr/local/lib/R/site-library
