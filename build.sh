#!/bin/bash

# build-script for docker image, defaults to local - specify DOCKER_REPO=<account>.dkr.ecr.eu-west-1.amazonaws.com/<repo> to push to AWS

if [ -z $AWS_REPO ]; then
AWS_REPO="<account>.dkr.ecr.eu-west-1.amazonaws.com/<repo>"
fi

if [ -z $1 ]; then
echo 'ERROR: You must specify the docker directory you want to build e.g rails'
echo 'USAGE:'
echo '  ./build.sh <build_dir>'
exit 1
fi

if [ -z $DOCKER_REPO ]; then
DOCKER_REPO=local
fi

DOCKER_IMAGE="$1:latest"
echo Build Setup
echo ===========
echo

echo Environment:
echo "DOCKER_REPO=$DOCKER_REPO"
echo "DOCKER_IMAGE=$DOCKER_IMAGE"
echo

echo Building from docker/$1/Dockerfile ...
echo ===========
echo

docker build -t $DOCKER_IMAGE -f docker/$1/Dockerfile .

if echo "$DOCKER_REPO" | grep -q -E '^[[:digit:]]+.dkr.ecr.[[:alnum:]-]+.amazonaws.com'; then

  docker tag $DOCKER_IMAGE $DOCKER_REPO/$DOCKER_IMAGE
  echo "Successfully tagged $DOCKER_REPO/$DOCKER_IMAGE"

  echo

  echo Authorising with AWS ECR:
  echo =========================
  echo
  echo Getting login command

  AWS_LOGIN=$(aws ecr get-login --no-include-email --region eu-west-1)
  if echo "$AWS_LOGIN" | grep -q -E '^docker login -u AWS -p [[:alnum:]=]+ https://[[:alnum:]]+.dkr.ecr.[[:alnum:]-]+.amazonaws.com$'; then
    echo Obtained Credentials
  	echo $($AWS_LOGIN)

    echo pushing to $DOCKER_REPO/$DOCKER_IMAGE ...
    docker push $DOCKER_REPO/$DOCKER_IMAGE

  else
  	echo Invalid Login: $AWS_LOGIN
  	echo "Mac(BSD) regex - try '^docker login -u AWS -p \S{1892} -e none https://[0-9]{12}.dkr.ecr.\S+.amazonaws.com$' for POSIX based grep"
  	exit 1
  fi
else
  echo "Local build complete! To configure remote repository for production deployment, specify DOCKER_REPO e.g"
  echo "DOCKER_REPO=$AWS_REPO ./build.sh"
fi
