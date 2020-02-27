variable "name_prefix" {
  default = "k-omoto-disposable" # TODO: remove
}

variable "tags" {
  type = map(string)
  default = {}
}
