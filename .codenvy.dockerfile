FROM bitnami/minideb-extras:jessie-r19-buildpack

MAINTAINER Bitnami <containers@bitnami.com>

RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list
RUN install_packages -t jessie-backports -y openjdk-8-jdk-headless ghostscript
RUN install_packages git subversion openssh-server rsync
RUN mkdir /var/run/sshd && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# System packages required
RUN install_packages imagemagick libaio1 libjemalloc1 libc6 libffi6 libgcc1 libgmp-dev libmysqlclient18 libmysqlclient-dev libncurses5 libpq5 libreadline6 libssl1.0.0 libstdc++6 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev netcat-traditional

ENV BITNAMI_APP_NAME=che-rails \
    BITNAMI_IMAGE_VERSION=5.1.2-r0 \
    RAILS_ENV=development \
    PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin/:$PATH

# Install Rails dependencies
RUN bitnami-pkg install ruby-2.4.1-0 --checksum eaf2341624588774f61e4aac4f53c437e98b1e97f6915ba6327d3ecdc6c2c3a2
RUN bitnami-pkg install mysql-client-10.1.24-0 --checksum 3ac33998eefe09a8013036d555f2a8265fc446a707e8d61c63f8621f4a3e5dae
RUN bitnami-pkg install mariadb-10.1.24-1 --checksum 0ad8567f9d3d8371f085b56854b5288be38c85a5cb3cd4e36d8355eb6bbbd4cd -- --allowEmptyPassword yes

# Ruby on Rails template
RUN gem install rails -v 5.1.2 --no-document

# Rails template
RUN rails new /tmp/temp_app --database mysql --quiet && rm -r /tmp/temp_app
RUN gem install therubyracer

EXPOSE 3000

# Set up Codenvy integration
LABEL che:server:3000:ref=rails che:server:3000:protocol=http

USER bitnami
WORKDIR /projects

ENV TERM=xterm

CMD sudo /usr/sbin/sshd -D
