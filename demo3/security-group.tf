resource "aws_security_group" "allow_web_SSH" {
  name        = "allow_web_SSH"
  description = "Allow SSH,HTTP, and HTTPS traffic to web servers"

  vpc_id = module.vpc.vpc_id

  tags = {
    "Name" = "allow_web_SSH"
  }

}

# Ingress rules for the security group
# Ingress to reguły dla ruchu przychodzącego do grupy bezpieczeństwa. W tym przypadku, definiujemy reguły, które pozwalają na ruch SSH (port 22), HTTP (port 80) i HTTPS (port 443) z dowolnego adresu IP (0.0.0/0).
# Allow SSH traffic (port 22)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_web_SSH.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}
# Allow HTTPS traffic (port 80)
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_web_SSH.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
# Allow HTTPS traffic (port 443)
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_web_SSH.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

# Egress rule for the security group
# Engress to reguły dla ruchu wychodzącego z grupy bezpieczeństwa. W tym przypadku, definiujemy regułę, która pozwala na cały ruch wychodzący (wszystkie porty i protokoły) do dowolnego adresu IP (0.0.0/0).
# Allow all outbound traffic

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.allow_web_SSH.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
