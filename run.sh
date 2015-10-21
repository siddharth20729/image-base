#! /bin/bash

set -ef -o pipefail

export NAME=$(cat NAME)
export MASTER_BUILD=$(test -z $CI_PULL_REQUEST && [[ $CIRCLE_BRANCH == 'master' ]] && echo 'true')
export AMI_REGIONS=$(if [ $MASTER_BUILD ]; then echo 'ap-northeast-1,ap-southeast-1,ap-southeast-2,eu-central-1,eu-west-1,sa-east-1,us-east-1,us-west-1,us-west-2'; fi)
export ROLE=$(if [ $MASTER_BUILD ]; then echo ${NAME}; else echo ${NAME}Test; fi)
export GIT_SHA=$CIRCLE_SHA1
export GIT_DESCRIBE=$(git describe --always --tags)
export AMI_REGION="${AMI_REGION-us-west-1}"
#export SOURCE_AMI="${SOURCE_AMI-$(aws ec2 describe-images --region $AMI_REGION --filter 'Name=tag:Role,Values=BaseImage' | jq -r '.Images | sort_by(.CreationDate) | reverse | .[0].ImageId')}"
export SOURCE_AMI=ami-6bcfc42e

echo NAME: $NAME
echo MASTER_BUILD: $MASTER_BUILD
echo AMI_REGIONS: $AMI_REGIONS
echo ROLE: $ROLE
echo SOURCE_AMI: $SOURCE_AMI

packer validate packer.json
packer build packer.json
