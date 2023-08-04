FROM node:20-alpine

RUN apk update && \
  apk add --no-cache bash git && \
  npm install -g semver

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
