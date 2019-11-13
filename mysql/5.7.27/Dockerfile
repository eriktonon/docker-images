FROM mysql:5.7.27

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    locales-all \
    task-brazilian-portuguese \
    curl \
    wget
    #Set timezone Brazil
RUN rm /etc/localtime &&\
    ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime &&\
    "date"