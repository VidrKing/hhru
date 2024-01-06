/*
//Резервируем публичный ip для каждой будущей вм
resource "yandex_vpc_address" "default" {
  count               = var.vm.gl.count
  name                = "${var.statpub_ip.name}${format("%02s", count.index + 1)}"
  deletion_protection = var.statpub_ip.deletion_protection
  external_ipv4_address {
    zone_id = "ru-central1-${element(var.subnet.zone, count.index)}"
  }
}
*/