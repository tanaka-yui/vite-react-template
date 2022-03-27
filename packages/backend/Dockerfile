FROM node:17.8.0-alpine3.15

WORKDIR /app

RUN apk add --no-cache --virtual .build-deps alpine-sdk python

COPY package.json package-lock.json ./

RUN npm install --frozen-lockfile

RUN curl -f https://get.pnpm.io/v6.16.js | node - add --global pnpm@6.32.3

COPY . .

RUN pnpm build \
  && apk del .build-deps

CMD [ "pnpm",  "start" ]