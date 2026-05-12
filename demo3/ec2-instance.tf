

# dla pętli for_each, zamiast count, można użyć for_each, aby utworzyć wiele instancji EC2 na podstawie listy lub mapy. Na przykład, jeśli chcemy utworzyć instancje EC2 dla różnych środowisk (dev, staging, prod), możemy zdefiniować mapę z nazwami środowisk i użyć jej do tworzenia instancji EC2. Oto przykład:

resource "aws_instance" "web" {
  # for_each = tomap({
  #   " eu-central-1b" =  "t3.micro",
  #   " eu-central-1a" =  "t3.small",

  # })
  # for_each = toset(keys({
  #   for az, details in data.aws_ec2_instance_type_offerings.my_instance_type :
  #   az => details.instance_types if length(details.instance_types) != 0
  # }))

  for_each = {
    for az in module.vpc.azs : az => az
  }

  ami                    = data.aws_ami.aws_linux_2023.id
  instance_type          = var.instance_type
  key_name               = var.instance_KeyPair
  user_data              = file("${path.module}/userdata/userdata.sh")
  vpc_security_group_ids = [aws_security_group.allow_web_SSH.id]


  tags = merge(local.common_tags, {
    Name = "${local.common_tags["Name"]}-${each.key}" # Nadajemy unikalną nazwę każdej instancji EC2, dodając klucz z mapy do nazwy. Na przykład, pierwsza instancja będzie miała nazwę "web-eu-central-1b", a druga "web-eu-central-1a".
    # Nadajemy unikalną nazwę każdej instancji EC2, dodając klucz z mapy do nazwy. Na przykład, pierwsza instancja będzie miała nazwę "web-eu-central-1b", a druga "web-eu-central-1a".
  })

  # to jest dodatkowy parametr, który pozwala przypisać instancję EC2 do odpowiedniej podsieci (subnet) w zależności od strefy dostępności (availability zone). W tym przypadku, używamy funkcji lookup, aby znaleźć odpowiedni subnet_id dla każdej instancji EC2 na podstawie jej strefy dostępności (each.key). Funkcja zipmap tworzy mapę, gdzie kluczem jest strefa dostępności (az), a wartością jest odpowiadający jej subnet_id z modułu VPC. Dzięki temu każda instancja EC2 zostanie przypisana do odpowiedniej podsieci w swojej strefie dostępności.

  subnet_id = zipmap(
    module.vpc.azs,
    module.vpc.public_subnets
  )[each.key]

}
