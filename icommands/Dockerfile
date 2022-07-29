FROM ubuntu:18.04

# Install some utilities and some prerequisites.
RUN apt-get update && \
    apt-get install -y wget curl netcat lsb-release gnupg

# Install the iCommands.
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | \
        tee /etc/apt/sources.list.d/renci-irods.list && \
    apt-get update && \
    apt-get install -y irods-icommands
