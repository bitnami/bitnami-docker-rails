FROM gcr.io/stacksmith-images/minideb-buildpack:jessie-r3

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=rails \
    BITNAMI_IMAGE_VERSION=5.0.0.1-r3 \
    RAILS_ENV=development \
    PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin/:$PATH

# Install Rails dependencies
RUN bitnami-pkg install ruby-2.3.1-2 --checksum 041625b9f363a99b2e66f0209a759abe7106232e0fcc3a970958bf73d5a4d9b0
RUN bitnami-pkg install imagemagick-6.7.5-10-3 --checksum 617e85a42c80f58c568f9bc7337e24c03e35cf4c7c22640407a7e1e16880cf88
RUN bitnami-pkg install mysql-libraries-10.1.13-0 --checksum 71ca428b619901123493503f8a99ccfa588e5afddd26e0d503a32cca1bc2a389
RUN bitnami-pkg install mariadb-10.1.14-4 --checksum 4a75f4f52587853d69860662626c64a4540126962cd9ee9722af58a3e7cfa01b

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

CMD ["/entrypoint.sh", "tail", "-f", "/dev/null"]
