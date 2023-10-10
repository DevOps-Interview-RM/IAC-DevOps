
output "Prod-Fwl-1-Private-IP" {
  value = aws_instance.prod-node.private_ip
}
output "dmz-Fwl-1-Private-IP" {
  value = aws_instance.dmz-node.private_ip
}
output "Prod-Fwl-1-Public-IP" {
  value = aws_instance.prod-node.public_ip
}
output "dmz-Fwl-1-Public-IP" {
  value = aws_instance.dmz-node.public_ip
}

