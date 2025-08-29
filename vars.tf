variable "tags" {
  description = "Tags that are applied to all resources created by this project."
  type        = map(string)
  default = {
    project_name = "home_case"
  }
}
