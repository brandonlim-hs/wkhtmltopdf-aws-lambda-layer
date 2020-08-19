# wkhtmltopdf as AWS Lambda Layer

[wkhtmltopdf](https://wkhtmltopdf.org/) with dependencies published as [AWS Lambda Layer](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html).

## Operating Systems

This layer supports both _Amazon Linux_ and _Amazon Linux 2_.

## Getting Started

Add this layer to Lambda function by providing the layer version ARN.

`arn:aws:lambda:{region}:347599033421:layer:wkhtmltopdf:1`

## Version ARNs

| Region         | ARN                                                                   |
| -------------- | --------------------------------------------------------------------- |
| ap-east-1      | arn:aws:lambda:ap-east-1:347599033421:layer:wkhtmltopdf-0_12_6:1      |
| ap-northeast-1 | arn:aws:lambda:ap-northeast-1:347599033421:layer:wkhtmltopdf-0_12_6:1 |
| ap-northeast-2 | arn:aws:lambda:ap-northeast-2:347599033421:layer:wkhtmltopdf-0_12_6:1 |
| ap-south-1     | arn:aws:lambda:ap-south-1:347599033421:layer:wkhtmltopdf-0_12_6:1     |
| ap-southeast-1 | arn:aws:lambda:ap-southeast-1:347599033421:layer:wkhtmltopdf-0_12_6:1 |
| ap-southeast-2 | arn:aws:lambda:ap-southeast-2:347599033421:layer:wkhtmltopdf-0_12_6:1 |
| ca-central-1   | arn:aws:lambda:ca-central-1:347599033421:layer:wkhtmltopdf-0_12_6:1   |
| eu-central-1   | arn:aws:lambda:eu-central-1:347599033421:layer:wkhtmltopdf-0_12_6:1   |
| eu-north-1     | arn:aws:lambda:eu-north-1:347599033421:layer:wkhtmltopdf-0_12_6:1     |
| eu-west-1      | arn:aws:lambda:eu-west-1:347599033421:layer:wkhtmltopdf-0_12_6:1      |
| eu-west-2      | arn:aws:lambda:eu-west-2:347599033421:layer:wkhtmltopdf-0_12_6:1      |
| eu-west-3      | arn:aws:lambda:eu-west-3:347599033421:layer:wkhtmltopdf-0_12_6:1      |
| sa-east-1      | arn:aws:lambda:sa-east-1:347599033421:layer:wkhtmltopdf-0_12_6:1      |
| us-east-1      | arn:aws:lambda:us-east-1:347599033421:layer:wkhtmltopdf-0_12_6:1      |
| us-east-2      | arn:aws:lambda:us-east-2:347599033421:layer:wkhtmltopdf-0_12_6:1      |
| us-west-1      | arn:aws:lambda:us-west-1:347599033421:layer:wkhtmltopdf-0_12_6:1      |
| us-west-2      | arn:aws:lambda:us-west-2:347599033421:layer:wkhtmltopdf-0_12_6:1      |

See `/arns` directory for other wkhtmltopdf versions.

## Usage

wkhtmltopdf binary will be extracted to the `/opt/bin`.

wkhtmltopdf can be executed directly as a command line binary, or via a wrapper.

Refer to `/tests` directory for example usage.

## Build, Test, Publish

Refer to the following scripts to build and publish your own wkhtmltopdf layer.

1. Run `./build.sh` to build a new layer zip.
2. Run `./test.sh` to test the layer zip.
3. Run `./publish.sh` to publish the layer zip to regions specified in `/config/regions.txt`.

## Fonts

See [fonts-aws-lambda-layer](https://github.com/brandonlim-hs/fonts-aws-lambda-layer) to use fonts on AWS Lambda.
