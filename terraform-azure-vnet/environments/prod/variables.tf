# Variables for prod environment
variable "location" {
  default = "eastus"
}
variable "enable_vm" {
  type    = bool
  default = false
}