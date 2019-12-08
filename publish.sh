#!/bin/bash

ARN_DIR="arns"
ARN_FILE="$ARN_DIR/wkhtmltopdf.csv"
LAYER_NAME="wkhtmltopdf"
LAYER_ZIP="layer.zip"
REGIONS=$(cat config/regions.txt)

# Exit if aws cli is not available
if ! aws --version 1>/dev/null; then
    exit 1
fi

rm -rf $ARN_DIR && mkdir -p $ARN_DIR

echo "Region,ARN" >$ARN_FILE
for region in $REGIONS; do
    printf "%s\n" "Region: $region"
    OUTPUT=$(
        aws lambda publish-layer-version \
            --description "wkhtmltopdf 0.12.5 (with patched qt)" \
            --layer-name $LAYER_NAME \
            --output text \
            --query "[LayerVersionArn, Version]" \
            --region $region \
            --zip-file fileb://$LAYER_ZIP
    )
    LAYER_VERSION_ARN=$(echo $OUTPUT | awk '{print $1}')
    LAYER_VERSION=$(echo $OUTPUT | awk '{print $2}')
    aws lambda add-layer-version-permission \
        --action lambda:GetLayerVersion \
        --layer-name $LAYER_NAME \
        --output text \
        --principal "*" \
        --query "Statement" \
        --region "$region" \
        --statement-id public \
        --version-number "$LAYER_VERSION"
    echo "$region,$LAYER_VERSION_ARN" >>$ARN_FILE
    printf "\n"
done
