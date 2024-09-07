
/*
    Cria a infra usando os valores especificados e uma chave pública de SSH a partir do arquivo
    Este exemplo usa o modo padrão do módulo para criar uma infra para testes.
    Neste modo, são usados os seguintes valores padrão:

    # dominio usado no hostname das máquinas
    domain => dev.local

    # nome da interface de rede a ser configurada nas máquinas
    interface => ens3

    # nome da rede virtual a ser criada
    virt_net_name => devnet

    # CIDR da rede a ser criada
    # É importante que seja igual ao da rede local para permitir o acesso as máquinas
    virt_net_cidr => 192.168.0.0/24

    # endereço do gateway de rede para as máquinas criadas
    # deve ser o mesmo da rede local para permitir o acesso à internet para as máquinas
    vir_gtw_addr => 192.168.0.54

    # endereço do segundo dns a ser usado nas máquinas
    # por padrão, o dns primário é sempre o do google - 8.8.8.8
    virt_dns_01 => 192.168.0.5

    # noome do pool de máquinas a ser criado
    virt_pool_name => vm-pool

    # diretório a ser criado para o pool de máquinas
    virt_pool_path => ~/virt-pool

    # nome da bridge pré-configurada que será usada pelo libvirt
    bridge_name => br0

    # define os IPs para as máquinas a serem criadas
    server_ips => ["192.168.0.180","192.168.0.190"]

    # define a memória padrão para as máquinas
    # atualmente é um valor padrão para todas as máquinas
    server_memory => 1024

    # define a quantidade de vcpus de cada instância
    # atualmente é um valor padrão para todas as máquinas
    server_vcpu => 1

    # define os hostnames de cada instância
    server_hostname => ["srv01","srv02"]

    # define o nome do usuário padrão das instâncias
    user_name => "devuser"

    # define a senha do usuário padrão
    user_password => "devuser"


    network - 192.168.0.0/24
    servidores - srv01 (192.168.0.180), srv02 (192.168.0.190)

*/

/*
  lê o arquivo que contém a chave pública a ser usada no acesso
  Para gerar a chave, pode-se usar o comando abaixo:
    
    ssh-keygen -f simple

    Irá gerar 2 arquivos:
      simple <= chave privada
      simple.pub =< chave pública

*/

data "local_file" "pubkey" {
  filename = "${path.module}/simple.pub"
}

module "web-dev-env" {
  source = "github.com/descomplicando-terraform/crazybyte-rj_iac-dev-env"
  # definido como true para poder criar a infra
  criar_infra = true

  # dado obrigatório para permitir o acesso ssh nas máquinas
  ssh_pub_key = data.local_file.pubkey.content

  virt_net_name  = "web-net-net"
  virt_pool_name = "webpool"
  # o usuário que executará o código terraform precisa ter permissão para criar a pasta
  virt_pool_path  = "/srv"
  virt_gtw_addr   = "10.0.3.254"
  virt_net_cidr   = "10.0.0.0/22"
  virt_dns_01     = "10.0.0.2"
  server_hostname = ["web01", "web02", "lb01"]
  server_ips      = ["10.0.2.1", "10.0.2.2", "10.0.2.0"]
  server_vcpu     = 2
  server_memory   = 2048
  user_name       = "webuser"
  user_password   = "$3c4etW38"

}