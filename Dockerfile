FROM node:14

LABEL "repository"="https://github.com/MilesChou/hexo-deploy-action"
LABEL "homepage"="https://mileschou.github.io/"
LABEL "maintainer"="MilesChou <jangconan@gmail.com>"

LABEL "com.github.actions.name"="Hexo Deploy"
LABEL "com.github.actions.description"="The Deployer of hexo project."
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

RUN set -xe && \
        apt-get update -y && \
        apt-get install -y git-core

RUN npm install -g hexo hexo-deployer-git

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
