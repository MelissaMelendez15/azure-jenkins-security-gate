variable "location" {
  description = "Azure region"
  type        = string
  default     = "westeurope"
}

variable "my_ip" {
  description = "IP pública desde la que se permitirá el acceso (formato CIDR)"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Ruta a la clave pública SSH"
  type        = string
}

variable "vm_size" {
  description = "Tamaño de la VM"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Usuario administrador en la VM"
  type        = string
  default     = "azureuser"
}

