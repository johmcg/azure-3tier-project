variable "vnet_address_space" {
  default = ["10.0.0.0/16"]
}

variable "subnet_frontend_prefix" {
  default = ["10.0.1.0/24"]
}

variable "subnet_backend_prefix" {
  default = ["10.0.2.0/24"]
}

variable "subnet_database_prefix" {
  default = ["10.0.3.0/24"]
}

variable "subnet_management_prefix" {
  default = ["10.0.4.0/24"]
}