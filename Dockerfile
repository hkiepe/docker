FROM node:6-alpine

RUN apk add --no-cache tini

WORKDIR /usr/src/app

COPY . .

COPY package.json package.json

EXPOSE 3000

RUN npm install \
    && npm cache clean --force

CMD [ "/sbin/tini", "--", "node", "./bin/www" ]


