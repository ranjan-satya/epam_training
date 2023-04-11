provider "aws" {
region = "us-east-1"

}

resource "aws_s3_bucket" "example_bucket" {
bucket = "11912393"
acl = "private"

versioning {
enabled = true
}
}