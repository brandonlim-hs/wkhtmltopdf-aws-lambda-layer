# TwoMinShift PDF Generator Lambda

## Build

To build the layer, run `layer_build.sh`. This will create layer.zip. Docker required.

## Publish

Ensure:
* `/arns/0.12.6/wkhtmltopdf.csv` contains your lambda's ARN, for each region to deploy to.
* `/config/regions.txt` contains the regions you want to deploy to.

Then run `layer_publish.sh`.

## Lambda Function

With the layer published create your the function.  Content of the pdf function exists at `/functions/pdf/index.js`.  Copy the contents into the AWS code editor and deploy it.

## Lambda Function Tests

Ensure wkhtmltopdf is installed, then run tests for the pdf lambda function with:

```
$ cd functions/test
$ node test
```

## AWS Function Configuration

The pdf function consumes ~120MB over 2-10 seconds to generate a pdf for a basic html template and signature. AWS Lambda will kill the function if it consumes more than its allotted max memory or max time. The cloudwatch logs will show if this is happening.  The function configuration for memory and time should be set appropriately.