# resource "aws_instance" "web" {
#   count =  2 # Tworzymy dwie instancje EC2, ponieważ count jest ustawiony na 2. Oznacza to, że Terraform utworzy dwie identyczne instancje EC2 z tymi samymi parametrami.
#   ami           = data.aws_ami.aws_linux_2023.id
#   instance_type = var.instance_type
#   key_name = var.instance_KeyPair
#   user_data = file("${path.module}/userdata/userdata.sh") # Ścieżka do pliku userdata.sh, który znajduje się w katalogu userdata w module. Ten plik będzie zawierał skrypt, który zostanie uruchomiony podczas uruchamiania instancji EC2. Możesz umieścić tam polecenia do instalacji oprogramowania, konfiguracji systemu itp.
#   vpc_security_group_ids = [aws_security_group.allow_web_SSH.id]

#   tags = merge(local.common_tags,{
#     Name ="${local.common_tags["Name"]}-${count.index + 1}" # Nadajemy unikalną nazwę każdej instancji EC2, dodając indeks do nazwy. Na przykład, pierwsza instancja będzie miała nazwę "web-1", a druga "web-2".
#      # Nadajemy unikalną nazwę każdej instancji EC2, dodając indeks do nazwy. Na przykład, pierwsza instancja będzie miała nazwę "web-1", a druga "web-2".
#   })

#   # tags = merge(local.common_tags,{
#   #   AppName = local.AppName
#   # })

# }

# dla pętli for_each, zamiast count, można użyć for_each, aby utworzyć wiele instancji EC2 na podstawie listy lub mapy. Na przykład, jeśli chcemy utworzyć instancje EC2 dla różnych środowisk (dev, staging, prod), możemy zdefiniować mapę z nazwami środowisk i użyć jej do tworzenia instancji EC2. Oto przykład:

resource "aws_instance" "web" {
  # for_each = tomap({
  #   " eu-central-1b" =  "t3.micro",
  #   " eu-central-1a" =  "t3.small",

  # })
  for_each = toset(keys({
    for az, details in data.aws_ec2_instance_type_offerings.my_instance_type :
    az => details.instance_types if length(details.instance_types) != 0
  }))

  ami                    = data.aws_ami.aws_linux_2023.id
  instance_type          = var.instance_type
  key_name               = var.instance_KeyPair
  user_data              = file("${path.module}/userdata/userdata.sh")
  vpc_security_group_ids = [aws_security_group.allow_web_SSH.id]
  availability_zone      = each.key
  tags = merge(local.common_tags, {
    Name = "${local.common_tags["Name"]}-${each.key}" # Nadajemy unikalną nazwę każdej instancji EC2, dodając klucz z mapy do nazwy. Na przykład, pierwsza instancja będzie miała nazwę "web-eu-central-1b", a druga "web-eu-central-1a".
    # Nadajemy unikalną nazwę każdej instancji EC2, dodając klucz z mapy do nazwy. Na przykład, pierwsza instancja będzie miała nazwę "web-eu-central-1b", a druga "web-eu-central-1a".
  })


}
