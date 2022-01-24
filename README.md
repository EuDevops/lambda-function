# Terraform for AWS Lambda Functions

## Lambda

```js
module "my-lambda-function" {
  source                = "git@gitlab.com:eudevops/lambda-function-with-terraform.git?ref=main"
  description           = "My cool lambda function"
  environment_vars      = {ENVIRONMENT="dev"}
  function_handler      = "main.handler"
  function_memory_size  = 128
  function_name         = "my-cool-lambda"
  function_runtime      = "python3.8"
  function_timeout      = 3
  iam_policies          = ["iam-policy-arn"]
  tags                  = {MyTag="Cool Tag"}
}
```

## Lambda in VPC

```js
module "my-lambda-function" {
  source                = "git@gitlab.com:eudevops/lambda-function-with-terraform.git?ref=main"
  description           = "My cool lambda function"
  environment_vars      = {ENVIRONMENT="dev"}
  function_handler      = "main.handler"
  function_memory_size  = 128
  function_name         = "my-cool-lambda"
  function_runtime      = "python3.8"
  function_timeout      = 3
  iam_policies          = ["iam-policy-arn"]
  security_group_ids    = ["my-sec-group-id"]
  subnet_ids            = ["my-subnet-id"]
  tags                  = {MyTag="Cool Tag"}
}
```

**Note**: You may not need to setup the `tags` variable if you are using `default_tags` in terraform provider configuration, however, if your lambda needs custom tags that does not conflict with `default_tags` you need to setup this variable.

## Deploy Terraform

```sh
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

## Deploy Lambda

To deploy a version of the lambda function you don't need to run terraform. Using Gitlab CI/CD you can use the following template to update just the lambda function, assuming that in the `build` of your code you have exported a zip file as artifact.

```yml
.lambdaDeploy: &lambdaDeploy
  image: registry.gitlab.com/gitlab-org/cloud-deploy/aws-base:latest
  stage: deploy
  script:
    - aws lambda update-function-code --function-name $LAMBDA_NAME --zip-file fileb://lambda.zip

# Job definition example
lambda_dev_deploy:
  extends: .lambdaDeploy
  variables:
    LAMBDA_NAME: my-lambda-function
    AWS_ACCESS_KEY_ID: $DEV_AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY: $DEV_AWS_SECRET_ACCESS_KEY
```

**Hint**: Check more templates of Gitlab CI/CD [here](https://gitlab.com/lays147/ci-templates/-/tree/master).

## Dev Requirements

- [Pre commit hook](https://pre-commit.com/)
- [Pre commit terraform](https://github.com/antonbabenko/pre-commit-terraform)


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.70 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.73.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.iam_for_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vpc_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.l](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [archive_file.dummy](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_iam_policy_document.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the lambda function | `string` | `""` | no |
| <a name="input_environment_vars"></a> [environment\_vars](#input\_environment\_vars) | A map with the environment vars | `map(any)` | `{}` | no |
| <a name="input_function_handler"></a> [function\_handler](#input\_function\_handler) | Lambda function entrypoint | `string` | n/a | yes |
| <a name="input_function_memory_size"></a> [function\_memory\_size](#input\_function\_memory\_size) | Amount of memory allocated to the lambda function | `number` | `128` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Lambda function name | `string` | n/a | yes |
| <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime) | Lambda choosen runtime | `string` | n/a | yes |
| <a name="input_function_timeout"></a> [function\_timeout](#input\_function\_timeout) | Amount of seconds to lambda function timeout | `number` | `3` | no |
| <a name="input_iam_policies"></a> [iam\_policies](#input\_iam\_policies) | List of IAM policies arn | `list(string)` | `[]` | no |
| <a name="input_publish_version"></a> [publish\_version](#input\_publish\_version) | Update lambda version as new changes are deployed | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | Aws region to setup the lambda function | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Optional: List of security groups ids to place lambda inside a VPC | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Optional: List of subnet ids to place lambda inside a VPC | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map with the tags to apply | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | n/a |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
