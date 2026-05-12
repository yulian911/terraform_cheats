module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"


  name = "demo-vpc-tf"
  cidr = "10.0.0.0/16"

  #   azs = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
  #   public_subnets = ["10.10.0.0/24", "10.10.1.0/24"]
  # public_subnets = [for i in range(length(data.aws_availability_zones.available.names)) : "10.10.${i}.0/24"]
  public_subnets = [for i in range(2) : cidrsubnet("10.0.0.0/16", 8, i + 10)]

  # to jest alternatywny sposób na wygenerowanie publicznych podsieci, gdzie używamy funkcji cidrsubnet do podziału głównej sieci VPC.

  # [10.0.10.0/24, 10.0.11.0/24]

  private_subnets = [for i in range(2) : cidrsubnet("10.0.0.0/16", 8, i + 20)]
  # [10.0.20.0/24, 10.0.21.0/24]

  public_subnet_names  = [for i in range(2) : "public-subnet-${i + 1}"]
  private_subnet_names = [for i in range(2) : "private-subnet-${i + 1}"]

  enable_dns_hostnames = true
  # to jest ważne, ponieważ pozwala na przypisywanie nazw hostów do instancji EC2, co ułatwia zarządzanie i identyfikację zasobów w VPC. Dzięki temu możemy używać nazw hostów zamiast adresów IP do komunikacji między zasobami w VPC.
  enable_dns_support = true
  # to jest ważne, ponieważ umożliwia rozwiązywanie nazw DNS w VPC, co jest niezbędne do komunikacji między zasobami w VPC oraz do korzystania z usług AWS, które wymagają rozwiązywania nazw DNS.
  manage_default_security_group = false
  # to jest ważne, ponieważ domyślna grupa bezpieczeństwa VPC jest zarządzana przez AWS i może mieć nieprzewidywalne reguły, które mogą wpłynąć na bezpieczeństwo naszych zasobów. Ustawienie tego parametru na false pozwala nam na pełną kontrolę nad grupami bezpieczeństwa, które tworzymy i zarządzamy w naszym VPC.
  map_public_ip_on_launch = true
  # to jest ważne, ponieważ pozwala na automatyczne przypisywanie publicznych adresów IP do instancji EC2 uruchamianych w publicznych podsieciach. Dzięki temu instancje EC2 będą miały dostęp do Internetu i będą mogły komunikować się z innymi zasobami poza VPC.

  tags = {
    Environment          = "dev"
    ManagagedByTerrafrom = "yes"
  }
}
