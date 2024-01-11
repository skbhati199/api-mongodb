# syntax=docker/dockerfile:1

FROM node:18-alpine AS base

WORKDIR /app

COPY [ "package.json", "./" ]

FROM base AS dev
ENV NODE_ENV=development
RUN npm install
COPY . .
CMD [ "npm", "start:dev" ]

FROM dev AS test
ENV NODE_ENV=test
CMD [ "npm", "run", "test" ]

FROM test AS test-cov
CMD [ "npm", "run", "test:cov" ]

FROM test AS test-watch
ENV GIT_WORK_TREE=/app GIT_DIR=/app/.git
RUN apk add git
CMD [ "yarn", "test:watch" ]

FROM base AS prod
ENV NODE_ENV=production
RUN npm install --production
COPY . .
RUN npm install -g @nestjs/cli
RUN npm run build
CMD [ "npm", "start:prod" ]