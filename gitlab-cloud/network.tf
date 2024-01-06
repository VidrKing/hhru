//Создаём сеть
resource "yandex_vpc_network" "default" {
  name = "${var.task_id}-network"
}

//Создаём подсеть в зоне доступности А и выдаём пул ip-адресов по протоколу CIDR
resource "yandex_vpc_subnet" "default" {
  count          = var.subnet.count
  network_id     = yandex_vpc_network.default.id
  name           = "${var.task_id}-subnet-${var.subnet.zone[count.index]}"
  v4_cidr_blocks = ["${var.subnet.cidr[count.index]}"] //разобраться, как лучше выдавать айпишки (теоретически, относительно сетевой инфраструктуры)
  zone           = "${var.subnet.prefix_name}${var.subnet.zone[count.index]}"
}