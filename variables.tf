variable "location" {
    description = "Azure region"
    type = string
    default = "westeurope"
}

variable "my_ip" {
    description = "IP pública desde la que se permitirá el acceso (formato CIDR)"
    type = string
}

variable "ssh_public_key_path" {
    description = "Ruta a la clave pública SSH"
    type = string
}