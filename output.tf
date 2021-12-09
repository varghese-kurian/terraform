output "vpcId" {
  value       = aws_vpc.vpc.id
}


output "IGWId" {
  value       = aws_internet_gateway.IGW.id
}

output "NatId" {
  value       = aws_nat_gateway.NAT.id
}

output "PublicRoute" {
  value       = aws_route_table.public.id
}

output "PrivateRoute" {
  value       = aws_route_table.private.id
}