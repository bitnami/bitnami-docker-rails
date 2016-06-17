## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami-bitnami-docker-rails .
##
## RUNNING
##   $ docker run -p 3000:3000 bitnami-bitnami-docker-rails
##
## CONNECTING
##   Lookup the IP of your active docker host using:
##     $ docker-machine ip $(docker-machine active)
##   Connect to the container at DOCKER_IP:3000
##     replacing DOCKER_IP for the IP of your active docker host

FROM gcr.io/stacksmith-images/ubuntu-buildpack:14.04-r07

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="2v2yvmx" \
    STACKSMITH_STACK_NAME="bitnami/bitnami-docker-rails" \
    STACKSMITH_STACK_PRIVATE="1"

RUN bitnami-pkg install ruby-2.3.1-1 --checksum a81395976c85e8b7c8da3c1db6385d0e909bd05d9a3c1527f8fa36b8eb093d84

ENV PATH=/opt/bitnami/ruby/bin:$PATH

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

RUN bitnami-pkg install imagemagick-6.7.5-10-3 --checksum 617e85a42c80f58c568f9bc7337e24c03e35cf4c7c22640407a7e1e16880cf88
RUN bitnami-pkg install mysql-libraries-10.1.13-0 --checksum 71ca428b619901123493503f8a99ccfa588e5afddd26e0d503a32cca1bc2a389
RUN bitnami-pkg install postgresql-libraries-9.5.3-0 --checksum d6499811161e9e97acfc3e0132a016bc2edcfd85374c9b5002359429bd8ab698

# Ruby on Rails template
RUN gem install rails -v 4.2.6 --no-document

# Bundle the gems required for a new application
RUN rails new /tmp/temp_app --database mysql --quiet && rm -r /tmp/temp_app
RUN rails new /tmp/temp_app --database postgresql --quiet && rm -r /tmp/temp_app

ENV RAILS_ENV=development
ENV BITNAMI_APP_NAME=rails
ENV BITNAMI_IMAGE_VERSION=4.2.6-r0

USER bitnami
WORKDIR /app
EXPOSE 3000

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
