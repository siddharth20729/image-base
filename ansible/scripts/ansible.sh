#!/bin/bash

set -eu -o pipefail

sudo yum -y install ansible

ansible --version
