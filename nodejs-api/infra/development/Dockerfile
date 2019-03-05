FROM node:11.10.0

ENV NODE_ENV=development
ENV LANG C.UTF-8

ARG project_dir=/usr/src/app

ADD * $project_dir/

WORKDIR $project_dir

RUN rm -rf node_modules && \
    npm i

EXPOSE 3000

ENTRYPOINT ["npm", "run", "start"]
