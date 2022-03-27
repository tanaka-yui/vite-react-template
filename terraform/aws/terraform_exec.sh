#!/bin/bash

BASE_DIR=$(cd $(dirname $0); pwd)

# set env vars
export TF_CLI_ARGS_plan="-input=false"
export TF_CLI_ARGS_apply="-auto-approve -input=false"
export TF_CLI_ARGS_destroy="-auto-approve -input=false"

# terraform variables
export ENVS=$1
export RUN_MODE=$2

export REGION=ap-northeast-1

export ACCOUNT_ID=

case ${ENVS} in
    prd)
      ENVS="prd"
      TARGET="environment"
    ;;
    immutable)
      ENVS="immutable"
      TARGET="immutable"
    ;;
    *) echo "Unknown env: ${ENVS}"
       exit 1 ;;
esac

export TF_VAR_account_id=$(aws sts get-caller-identity --query 'Account' --output text)
export TF_VAR_product_name=sample
export TF_VAR_region=ap-northeast-1
export TF_VAR_env=${ENVS}

check_account() {
  case ${ENVS} in
      prd|immutable)
        if [ ${ACCOUNT_ID} != ${TF_VAR_account_id} ] ; then
          echo "[${ENVS}] unauthorized account. current_account:${TF_VAR_account_id}, support_account:${ACCOUNT_ID}"
          exit 1
        fi
      ;;
      *) echo "Unknown env: ${ENVS}"
         exit 1 ;;
  esac
}

echo_info () {
    echo "[INFO] $1"
}

error_exit () {
    echo "[ERROR] $1"
    exit 1
}

get_terraform_command () {
    if [[ $# -ne 2 ]]; then
        echo "Not enough arguments. Expected 2 got $#"
        exit 1
    fi

    case $1 in
        apply) COMMAND="apply $2" ;;
         plan) COMMAND="plan -detailed-exitcode $2" ;;
            *) echo "Unknown command: $1"
               exit 1 ;;
    esac

    echo ${COMMAND}

}

delete_work_file() {
  rm -rf ./${TARGET}/.terraform/
}

# main
if [[ ${ENVS} = "immutable" ]] ; then
  check_account
  TARGET="${ENVS}"
  terraform -chdir=${TARGET} init
  terraform -chdir=${TARGET} workspace select default
  TERRAFORM_WORKSPACE=$(terraform -chdir=${TARGET} workspace show ${TARGET})
  VARS=""
else
  check_account
  TARGET="environment"
  terraform -chdir=${TARGET} init
#  terraform -chdir=${TARGET} workspace new ${ENVS}
  terraform -chdir=${TARGET} workspace select ${ENVS}
  TERRAFORM_WORKSPACE=$(terraform -chdir=${TARGET} workspace show ${TARGET})
  VARS="-var-file tfvars/${TERRAFORM_WORKSPACE}.tfvars"
fi

echo_info "======================================================================="
echo_info "Target: ${TARGET}"
echo_info "Run mode: ${RUN_MODE}"
if [ -n "$ENVS" ] ; then
  echo_info "Env: ${ENVS}"
fi
if [ -n "$VARS" ] ; then
  echo_info "Vars: ${VARS}"
fi
echo_info "======================================================================="

if [ ${RUN_MODE} = "apply" ] ; then
  echo "Do you want to continue [Y/n]?"
  read INPUT
  if [ ${INPUT} != "Y" ] ; then
    echo_info "Finished."
    exit 0
  fi
  echo_info "Continue."
fi

COMMAND_TERRAFORM="$(get_terraform_command "${RUN_MODE}" "${VARS}")"
if [[ $? -ne 0 ]] ; then
    echo_info "======================================================================="
    error_exit "${COMMAND_TERRAFORM}"
fi

terraform -chdir=${TARGET} ${COMMAND_TERRAFORM}

RET=$?

delete_work_file

echo_info "Finished target: ${ENVS}. Result. ${RET}"
