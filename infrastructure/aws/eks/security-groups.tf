#TODO remove "all_worker_mgmt"
resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

# https://developer.hashicorp.com/consul/docs/install/ports
resource "aws_security_group" "all_nodes_mgmt" {
  name_prefix = "${local.name_prefix}-eks-nodes-mgt-sg"
  description = "Security rules for SSH and Consul."
  vpc_id      = data.aws_vpc.selected.id
  tags = merge(
    { "Name" = "${local.name_prefix}-eks-nodes-mgt-sg" },
    { "Environment" = var.env_name }
  )
}

# TODO change cidr_blocks into self
resource "aws_security_group_rule" "nodes_allow_22_bastion" {
  security_group_id        = aws_security_group.all_nodes_mgmt.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  cidr_blocks              = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  description              = "Allow SSH traffic from consul bastion from inside the vpc only."
}

resource "aws_security_group_rule" "consul_server_allow_client_8500" {
  security_group_id        = aws_security_group.all_nodes_mgmt.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8500
  to_port                  = 8500
  cidr_blocks              = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  description              = "Allow HTTP traffic from Consul Client."
}

resource "aws_security_group_rule" "consul_server_allow_client_8600_udp" {
  security_group_id        = aws_security_group.all_nodes_mgmt.id
  type                     = "ingress"
  protocol                 = "udp"
  from_port                = 8600
  to_port                  = 8600
  cidr_blocks              = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  description              = "Allow UDP traffic for DNS queries."
}

resource "aws_security_group_rule" "consul_server_allow_client_8600_tcp" {
  security_group_id        = aws_security_group.all_nodes_mgmt.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8600
  to_port                  = 8600
  cidr_blocks              = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  description              = "Allow TCP traffic for DNS queries."
}

resource "aws_security_group_rule" "consul_server_allow_client_8301_tcp" {
  security_group_id        = aws_security_group.all_nodes_mgmt.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8301
  to_port                  = 8301
  cidr_blocks              = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  description              = "Allow LAN gossip traffic from Consul Client to Server.  For managing cluster membership for distributed health check of the agents."
}

resource "aws_security_group_rule" "consul_server_allow_client_8301_udp" {
  security_group_id        = aws_security_group.all_nodes_mgmt.id
  type                     = "ingress"
  protocol                 = "udp"
  from_port                = 8301
  to_port                  = 8301
  cidr_blocks              = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  description              = "Allow LAN gossip traffic from Consul Client to Server.  For managing cluster membership for distributed health check of the agents."
}

resource "aws_security_group_rule" "consul_server_allow_client_8302_tcp" {
  security_group_id        = aws_security_group.all_nodes_mgmt.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8302
  to_port                  = 8302
  cidr_blocks              = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  description              = "Allow WAN gossip traffic from Consul Client to Server.  For managing cluster membership for distributed health check of the agents."
}

resource "aws_security_group_rule" "consul_server_allow_client_8302_udp" {
  security_group_id        = aws_security_group.all_nodes_mgmt.id
  type                     = "ingress"
  protocol                 = "udp"
  from_port                = 8302
  to_port                  = 8302
  cidr_blocks              = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  description              = "Allow WAN gossip traffic from Consul Client to Server.  For managing cluster membership for distributed health check of the agents."
}

resource "aws_security_group_rule" "consul_server_allow_8300" {
  security_group_id        = aws_security_group.all_nodes_mgmt.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8300
  to_port                  = 8300
  cidr_blocks              = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  description              = "Allow RPC traffic from Consul Client to Server and Server to Server.  For client and server agents to send and receive data stored in Consul."
}

resource "aws_security_group_rule" "consul_server_allow_21000_21255" {
  security_group_id        = aws_security_group.all_nodes_mgmt.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 21000
  to_port                  = 21255
  cidr_blocks              = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  description              = "Allow Sidecar Proxy - ports number to use for automatically assigned sidecar service registrations.."
}

resource "aws_security_group_rule" "consul_server_allow_8080" {
  security_group_id        = aws_security_group.all_nodes_mgmt.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 8080
  to_port                  = 8080
  cidr_blocks              = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  description              = "Allow Sidecar injector - consul-connect-injector service maps 443 into 8080 on the pod."
}

resource "aws_security_group_rule" "nodes_allow_outbound" {
  security_group_id = aws_security_group.all_nodes_mgmt.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow any outbound traffic."
}