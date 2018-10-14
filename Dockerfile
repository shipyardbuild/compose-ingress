FROM nginx:1.14-alpine

# Install wget and install/updates certificates
RUN apk add --no-cache --virtual .run-deps \
    ca-certificates bash wget openssl \
    && update-ca-certificates

# Configure Nginx and apply fix for very long server names
RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
 && sed -i 's/worker_processes  1/worker_processes  auto/' /etc/nginx/nginx.conf

# Install Forego
ADD https://github.com/jwilder/forego/releases/download/v0.16.1/forego /usr/local/bin/forego
RUN chmod u+x /usr/local/bin/forego

# Install docker-gen
ENV DOCKER_GEN_VERSION 0.7.4
RUN wget --quiet https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

# Overlay the system files and set the working directory
COPY ./filesystem /
WORKDIR /srv/

# Set the Docker host
ENV DOCKER_HOST unix:///tmp/docker.sock

# Mark the sensitive nginx directories as volumes
VOLUME ["/etc/nginx/certs", "/etc/nginx/dhparam"]

ENTRYPOINT ["/srv/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
