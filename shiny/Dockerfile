FROM rocker/shiny:latest

RUN chmod a+rwx /usr/local/lib/R/site-library
RUN apt-get update && apt-get install -y libgdal-dev libgdal20 libboost-all-dev libudunits2-0 libudunits2-data libudunits2-dev
RUN R -e "install.packages('shinythemes')"
RUN R -e "install.packages(c('leaflet', 'dplyr', 'tidyr', 'jsonlite', 'units', 'sf', 'rgdal'))" 
RUN chmod -R a+rwx /usr/local/lib/R/site-library
