#!/bin/bash
set -ex

# delete stack
aws cloudformation delete-stack --stack-name app42

# wait for stack deletion to complete
aws cloudformation wait stack-delete-complete --stack-name app42
