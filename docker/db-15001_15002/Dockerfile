FROM mariadb:10.9.2

RUN apt-get update && apt-get install -y \
    nano \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv

EXPOSE 3306


