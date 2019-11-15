FROM postgres:11.5
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
RUN sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG pt_BR.UTF-8  
ENV LANGUAGE BR_US:en  
ENV LC_ALL pt_BR.UTF-8    


