# syntax=docker/dockerfile:1

FROM node:18-alpine AS base

WORKDIR /app

COPY [ "package.json", "pnpm-lock*", "./" ]

FROM base AS dev
ENV NODE_ENV=development
RUN npm install -g pnpm
RUN pnpm install
COPY . .
CMD [ "pnpm", "start:dev" ]

FROM dev AS test
ENV NODE_ENV=test
CMD [ "pnpm", "test" ]

FROM test AS test-cov
CMD [ "pnpm", "test:cov" ]

FROM test AS test-watch
ENV GIT_WORK_TREE=/app GIT_DIR=/app/.git
RUN apk add git
CMD [ "yarn", "test:watch" ]

FROM base AS prod
ENV NODE_ENV=production
RUN pnpm install --production
COPY . .
RUN pnpm install @nestjs/cli
RUN pnpm build
CMD [ "pnpm", "start:prod" ]