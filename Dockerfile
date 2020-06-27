FROM binhex/arch-base:latest
LABEL maintainer="GwynethStark"
    # additional files
    ##################

    # add supervisor conf file for app
    ADD build/*.conf /etc/supervisor/conf.d/

    # add install bash script
    ADD build/root/*.sh /root/

    # add run bash script
    ADD run/nobody/*.sh /home/nobody/

    # add pre-configured config files for spigot
    ADD config/nobody/ /home/nobody/

    # install app
    #############

    # make executable and run bash scripts to install app
    RUN chmod +x /root/*.sh && \
        /bin/bash /root/install.sh

    # docker settings
    #################

    # map /config to host defined config path (used to store configuration from app)
    VOLUME /config

    # expose port for spigot and DynMap
    EXPOSE 25565
    EXPOSE 8123

    # set permissions
    #################

    # run script to set uid, gid and permissions
    CMD ["/bin/bash", "/usr/local/bin/init.sh"]