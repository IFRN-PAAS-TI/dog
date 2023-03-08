FROM debian:stable

ARG FOG_VERSION=1.5.10
ARG IMAGES_LOCATION=/images
ARG INTERFACE=eth0
# N for normal, s for Storage installation type
ARG INSTALLATION_TYPE=N
ARG USE_DHCP="N"
ARG INTERNATIONAL_LOCALIZATION_SUPPORT="N"
ARG SEND_TRACKING_INFORMATION="N"

RUN apt-get update

#Fog project dependencies, we need to intall
#them before we run fog script. This is needed
#due to some of these packages tend to overwrite
#/usr/bin/systemctl, what we want is that OUR
#fake systemctl prevails. So no package installation
#from our installfog.sh friend.
RUN apt-get install -y wget \
                       iproute2 \
                       python3 \
                       sysv-rc-conf \
                       procps \
                       apache2 \
                       bc \
                       build-essential \
                       cpp \
                       curl \
                       g++ \
                       gawk \
                       gcc \
                       genisoimage \
                       git \
                       gzip \
                       htmldoc \
                       isolinux \
                       lftp \
                       libapache2-mod-php \
                       libc6 \
                       libcurl4 \
                       liblzma-dev \
                       m4 \
                       mariadb-client \
                       mariadb-server \
                       net-tools \
                       nfs-kernel-server \
                       openssh-server \
                       php \
                       php-bcmath \
                       php-cli \
                       php-curl \
                       php-fpm \
                       php-gd \
                       php-json \
                       php-ldap \
                       php-mbstring \
                       php-mysql \
                       php-mysqlnd \
                       tar \
                       tftp-hpa \
                       tftpd-hpa \
                       unzip \
                       vsftpd \
                       wget \
                       zlib1g


#We need to add this systemctl replacer so the fog install script doesn't fail

#We need to fake a few commands so the script does't fail
#RUN bash -c 'echo "" > /usr/sbin/service '
#RUN bash -c 'echo "" > /bin/systemctl '
#RUN cp /usr/bin/passwd /usr/bin/passwd.bak
#RUN bash -c 'echo "" > /usr/bin/passwd '
#RUN chmod +x /bin/systemctl

RUN wget -O /fog.tar.gz https://github.com/FOGProject/fogproject/archive/$FOG_VERSION.tar.gz

RUN tar xzvf /fog.tar.gz
RUN chmod +x /fogproject-$FOG_VERSION/bin/installfog.sh
RUN /bin/bash -c '/bin/echo -e "2\n$INSTALLATION_TYPE\nY\n$INTERFACE\nN\nN\n$USE_DHCP\n$INTERNATIONAL_LOCALIZATION_SUPPORT\nN\nN\n$SEND_TRACKING_INFORMATION\nY\n" | /bin/bash /fogproject-$FOG_VERSION/bin/installfog.sh' ; exit 0

ADD https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py /bin/systemctl
RUN chmod +x /bin/systemctl

ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

#Remove line from mysql.service
RUN sed -i '/_WSREP_START_POSITION/d' /lib/systemd/system/mysql.service

CMD [ "/entrypoint.sh" ]
