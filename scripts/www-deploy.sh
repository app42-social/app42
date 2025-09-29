#!/bin/bash
set -ex
DIR=$(cd "$(dirname "$0")/.." && pwd)

aws cloudformation deploy \
    --template-file template.cform.yaml \
    --stack-name app42 \
    --capabilities CAPABILITY_NAMED_IAM 

# wait for deploy to complete
aws cloudformation wait stack-exists --stack-name app42

# get the website bucket name
BUCKET_NAME=$(aws cloudformation describe-stacks \
    --stack-name app42 \
    --query "Stacks[0].Outputs[?OutputKey=='BucketName'].OutputValue" \
    --output text) 

# build the website flutter web on app42 dir
pushd $DIR/app42
flutter build web

# upload the website to the S3 bucket
aws s3 sync ./build/web/ s3://$BUCKET_NAME/ --delete
popd

echo done!