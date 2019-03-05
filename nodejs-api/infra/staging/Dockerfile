FROM node:11.10.0

ENV NODE_ENV=production
ENV LANG C.UTF-8

ARG project_dir=/usr/src/app

ADD ./dist/server.js $project_dir/dist/
ADD ./package.json $project_dir

WORKDIR $project_dir

RUN rm -rf node_modules && \
    npm i

EXPOSE 3000

ENTRYPOINT ["node", "./dist/server.js"]
