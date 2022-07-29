FROM httpd:alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

RUN addgroup -g ${GID} --system www-data
RUN adduser -G www-data --system -D -s /bin/sh -u ${UID} www-data