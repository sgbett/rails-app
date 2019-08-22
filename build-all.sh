#!/bin/bash

# builds everything

if [ -z $DOCKER_REPO ]; then
DOCKER_REPO=local
fi

for TARGET in rails rails-app; do
DOCKER_REPO=$DOCKER_REPO ./build.sh $TARGET
done
