variable "name_prefix" {
}

variable "tags" {
  type = map(string)
}

variable "alb_subnets" {
  type = list(string)
}

variable "lambda_functions" {
  type = list(string)
}

