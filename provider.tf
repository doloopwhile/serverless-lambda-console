provider "aws" {
  region  = "ap-northeast-1"
  version = "~> 2.36"
}

provider "archive" {
  version = "~> 1.3"
}

provider "http" {
  version = "~> 1.1"
}

provider "random" {
  version = "~> 2.2"
}
