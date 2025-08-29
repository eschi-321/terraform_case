variable "tags" {
  description = "Tags that are applied to all resources created by this project."
  type        = map(string)
  default = {
    project_name = "home_case"
  }
}

variable "availability_zone" {
  description = "Availability zone to use for instance and networking"
  type        = string
  default     = "eu-central-1a"
}
