variable "name_prefix" {
}

variable "tags" {
  type = map(string)
}

variable "alb_subnets" {
  type = list(string)
}

variable "alb_security_groups" {
  type = list(string)
}

variable "lambda_functions" {
  type = list(string)
}

