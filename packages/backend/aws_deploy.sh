#!/usr/bin/env bash

PROJECT_DIR=$(cd $(dirname $0); pwd)

COMMAND=${1:-"help"}
ENVIRONMENT=${2:-""}
TAG=${3:-"latest"}

ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
REGION=ap-northeast-1
REGISTRY_PATH=${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

ecr_login() {
  aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${REGISTRY_PATH}
}

check_push_account() {
  CURRENT_ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
  if [ ${ACCOUNT_ID} != ${CURRENT_ACCOUNT_ID} ] ; then
    echo "unauthorized account. current_account:${CURRENT_ACCOUNT_ID}, support_account:${ACCOUNT_ID}"
    exit 1
  fi
}

build() {
  ecr_login
  docker build --platform linux/amd64 --target deploy -t ${REGISTRY_PATH}/${ENVIRONMENT}-integnance-backend:"${TAG}" \
    -f "${PROJECT_DIR}/Dockerfile" . --build-arg ENVIRONMENT=${ENVIRONMENT}
}

push() {
  check_push_account
  ecr_login
  docker push ${REGISTRY_PATH}/${ENVIRONMENT}-integnance-backend:"${TAG}"
}

help() {
  cat <<EOF
------------------------------------------ setup.sh ------------------------------------------
Usage: ./aws_deploy.sh <command> [variables]
  build: create a microservice image
  push:  push a microservice image to ECR
  help:  help

examples:
  ./aws_deploy.sh build prd
-----------------------------------------------------------------------------------------------
EOF
}

case "${COMMAND}" in
  build) build ;;
  push) push ;;
  *) help ;;
esac
