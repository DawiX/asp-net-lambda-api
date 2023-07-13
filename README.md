# Simple REST API with AWS Lambda as backend

## Function

API works as a simple calculator and S3 reader.

- Calculator controller provides simple arithmetics
- S3 controller enables
  - listing of objects in specified bucket
  - obtaining content of specified object in specified bucket

## Implementation

Lambda is written in ASP.NET to provide multiple endpoints, which are then wrapped in AWS API Gateway as proxy.

## Deployment

- simply run `./package.sh` script to generate lambda zip
- then you can deploy whole infra via terraform with `./deploy.sh`

Deployment iself deploys:

- AWS Lambda itself
- API Gateway as proxy for Lambda
- Sample S3 bucket with 3 sample files that you can query against

## Examples

### Getting file content

```bash
curl -X GET '<API_GW_INVOCATION_URI>/S3/get-object/<bucket_name>t?key=file3.txt'
```

### Listing objects in a bucket

```bash
curl -X GET '<API_GW_INVOCATION_URI>/S3/list/<bucket_name>'
```

### Simple calculation

```bash
curl -X GET '<API_GW_INVOCATION_URI>/Calculator/add/1/2'
```
