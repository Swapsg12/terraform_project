variable "port" {
  type    = list(number)
  default = ["80", "443", "22"]
}


variable "cred_access_key" {
  type = string
}

variable "cred_secret_key" {
  type = string
}