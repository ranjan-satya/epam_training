variable "instance_type" {
    type = string
    description = "This is the type of the EC2 instance"
}
variable "tag" {
    type = string
    description = "tag name for EC2 instance"
}
variable "region_name" {
    type = string
    description = "region name"
}
variable "ami_id" {
    type = string
    description = "ami image id for EC2 instance based on region name"
}