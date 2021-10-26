variable "description" {
  type        = string
  description = "Description of the lambda function"
  default     = ""
}

variable "environment_vars" {
  type        = map(any)
  description = "A map with the environment vars"
  default     = {}
}

variable "function_handler" {
  type        = string
  description = "Lambda function entrypoint"
}

variable "function_memory_size" {
  type        = number
  description = "Amount of memory allocated to the lambda function"
  default     = 128
}

variable "function_name" {
  type        = string
  description = "Lambda function name"
}

variable "function_runtime" {
  type        = string
  description = "Lambda choosen runtime"
  validation {
    condition = contains(["nodejs10.x", "nodejs12.x", "nodejs14.x", "java8", "java8.al2", "java11", "python3.6",
    "python3.7", "python3.8", "dotnetcore2.1", "dotnetcore3.1", "go1.x", "ruby2.5", "ruby2.7"], var.function_runtime)
    error_message = "The provided runtime is not valid, please check lambda runtime docs."
  }
}

variable "function_timeout" {
  type        = number
  description = "Amount of seconds to lambda function timeout"
  default     = 3
}

variable "region" {
  type        = string
  description = "Aws region to setup the lambda function"
}

variable "publish_version" {
  type        = bool
  description = "Update lambda version as new changes are deployed"
  default     = false
}
variable "security_group_ids" {
  type        = list(string)
  description = "Optional: List of security groups ids to place lambda inside a VPC"
  default     = []
}

variable "subnet_ids" {
  type        = list(string)
  description = "Optional: List of subnet ids to place lambda inside a VPC"
  default     = []
}

variable "tags" {
  type        = map(any)
  description = "A map with the tags to apply"
  default     = {}
}

variable "iam_policies" {
  type        = list(string)
  description = "List of IAM policies arn"
  default     = []
}
