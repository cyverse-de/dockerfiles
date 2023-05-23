FROM i2incommon/grouper:2.5.68

# Update the base configuration files to look in /etc/grouper for configuration files.
COPY update_base_configs.sh .
RUN chmod +x update_base_configs.sh && \
        ./update_base_configs.sh && \
        rm update_base_configs.sh
