#!/bin/sh -l

set -e

echo "echo GITHUB_EVENT_PATH" && \
echo $GITHUB_EVENT_PATH && \

echo "echo GITHUB_ACTOR" && \

# Installs Git and jq.
apt-get update && \
apt-get install -y git && \
apt-get install -y jq && \


# Gets the commit email/name if it exists in the push event payload.
COMMIT_EMAIL=`jq '.pusher.email' ${GITHUB_EVENT_PATH}`
COMMIT_NAME=`jq '.pusher.name' ${GITHUB_EVENT_PATH}`

# If the commit email/name is not found in the event payload then it falls back to the actor.
if [ -z "$COMMIT_EMAIL" ]
then
  COMMIT_EMAIL="${GITHUB_ACTOR:-hexo-deploy-action}@users.noreply.github.com"
fi

if [ -z "$COMMIT_NAME" ]
then
  COMMIT_NAME="${GITHUB_ACTOR:-Hexo Deploy Action}"
fi

# Directs the action to the the Github workspace.
cd $GITHUB_WORKSPACE && \

echo "Install hexo ..." && \
npm install -g hexo hexo-deployer-git && \

echo "Clean folder ..." && \

hexo clean && \

echo "Build and Deploy ..." && \

hexo deploy && \

echo "Deployment succesful!"

