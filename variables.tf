variable "groups" {
  type        = map(any)
  description = "Object of Identity Center groups"
}

variable "users" {
  type        = map(any)
  description = "Object of Identity Center users"
}
