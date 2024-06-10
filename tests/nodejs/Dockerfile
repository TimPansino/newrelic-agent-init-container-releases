ARG RUNTIME_VERSION=20

FROM node:${RUNTIME_VERSION} AS build

WORKDIR /app

COPY index.js .

CMD ["node", "-r", "newrelic", "index.js"]
