FROM gcr.io/stacksmith-images/minideb-buildpack:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' >> /etc/apt/sources.list
RUN apt-get update && apt-get install -t jessie-backports -y openjdk-8-jdk-headless
RUN install_packages git subversion openssh-server rsync
RUN mkdir /var/run/sshd && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV BITNAMI_APP_NAME=che-rails \
    BITNAMI_IMAGE_VERSION=5.0.0.1-r7 \
    RAILS_ENV=development \
    PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin/:$PATH

# Install Rails dependencies
RUN bitnami-pkg install ruby-2.3.1-2 --checksum 041625b9f363a99b2e66f0209a759abe7106232e0fcc3a970958bf73d5a4d9b0
RUN bitnami-pkg install imagemagick-6.7.5-10-3 --checksum 617e85a42c80f58c568f9bc7337e24c03e35cf4c7c22640407a7e1e16880cf88
RUN bitnami-pkg install mysql-libraries-10.1.19-0 --checksum 6729ab22f06052af981b0a78e9f4a700d4cbc565d771e9c6c874f1f57fdb76d2
RUN bitnami-pkg install mysql-client-10.1.19-0 --checksum fdbc292bedabeaf0148d66770b8aa0ab88012ce67b459d6ba2b46446c91bb79c

# Ruby on Rails template
RUN gem install rails -v 5.0.0.1 --no-document

# Rails template
RUN rails new /tmp/temp_app --database mysql --quiet && rm -r /tmp/temp_app
RUN gem install therubyracer

EXPOSE 3000

# Set up Codenvy integration
LABEL che:server:3000:ref=rails che:server:3000:protocol=http

USER bitnami
WORKDIR /projects

ENV TERM=xterm

CMD sudo /usr/sbin/sshd -D && tail -f /dev/null
