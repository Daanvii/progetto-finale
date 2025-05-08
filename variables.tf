variable "subscription_id" {
  description = "ID della sottoscrizione Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nome del gruppo di risorse"
  type        = string
}

variable "vm_name" {
  description = "Nome della VM"
  type        = string
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_ed25519.pub"
}

variable "ssh_private_key_path" {
  default = "~/.ssh/id_ed25519"
}
