output "ip" {
  description = "Exibe o(s) endereço(s) IP(s) atribuído(s) à(s) instância(s)"
  value       = libvirt_domain.servidores[*].network_interface[0].addresses[0]
}

output "user" {
  description = "Exibe o usuário criado para acesso às instâncias"
  value       = var.user_name
}

output "password" {
  description = "Exibe a senha do usuário criado para acessar as instâncias"
  value       = var.user_password
  sensitive   = true
}