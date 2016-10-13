FROM gcr.io/stacksmith-images/ubuntu-buildpack:14.04-r9

MAINTAINER Bitnami <containers@bitnami.com>

RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV STACKSMITH_STACK_ID="u9fs9c0" \
    STACKSMITH_STACK_NAME="Ruby for bitnami/bitnami-docker-rails" \
    STACKSMITH_STACK_PRIVATE="1" \
    BITNAMI_APP_NAME=Rails \
    BITNAMI_IMAGE_VERSION=5.0.0.1 \
    BITNAMI_IMAGE_VERSION=5.0.0.1-r0 \
    RAILS_ENV=development \
    PATH=/opt/bitnami/java/bin:/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin/:$PATH

# Install java dependency
RUN bitnami-pkg install java-1.8.0_91-0 --checksum 64cf20b77dc7cce3a28e9fe1daa149785c9c8c13ad1249071bc778fa40ae8773

# Install Rails related dependencies
RUN bitnami-pkg install mariadb-10.1.14-4 --checksum 4a75f4f52587853d69860662626c64a4540126962cd9ee9722af58a3e7cfa01b
RUN bitnami-pkg install ruby-2.3.1-1 --checksum a81395976c85e8b7c8da3c1db6385d0e909bd05d9a3c1527f8fa36b8eb093d84
RUN bitnami-pkg install imagemagick-6.7.5-10-3 --checksum 617e85a42c80f58c568f9bc7337e24c03e35cf4c7c22640407a7e1e16880cf88
RUN bitnami-pkg install mysql-libraries-10.1.13-0 --checksum 71ca428b619901123493503f8a99ccfa588e5afddd26e0d503a32cca1bc2a389

# Ruby on Rails template
RUN gem install rails -v 5.0.0.1 --no-document

# Bundle the gems required for a new application
RUN rails new /tmp/temp_app --database mysql --quiet && rm -r /tmp/temp_app
RUN gem install therubyracer

EXPOSE 3000

LABEL che:server:3000:ref=rails che:server:3000:protocol=http

USER bitnami
WORKDIR /projects

ENV TERM=xterm

CMD ["tail", "-f", "/dev/null"]
