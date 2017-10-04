output "name" {
  value = "${aws_instance.ansible.tags.Name}"
}

output "ip" {
  value = "${aws_instance.ansible.public_ip}"
}

output "Gitlab" {
  value = "${aws_instance.gitlab.*.private_ip}"
}

output "DBs" {
  value = "${aws_instance.postgres.*.private_ip}"
}
