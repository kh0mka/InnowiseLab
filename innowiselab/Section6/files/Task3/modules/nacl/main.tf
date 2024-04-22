resource "aws_network_acl" "nacl" {
  vpc_id = var.vpc_id

  tags = merge(var.tags, lookup(var.tags_for_resource, "aws_network_acl", {
    "Name" = "Null"
  }))
}

resource "aws_network_acl_rule" "nacl_rules" {
  count = var.rules_count

  // NACL ID, the variable is needed to avoid creating 
  // a new NACL each time. Allows you to attach rules 
  // to an already created NACL
  network_acl_id = var.network_acl_id

  rule_number = element(var.rule_number, count.index) // Rule number of NACL.     List(string)
  egress      = element(var.egress, count.index)      // Egress: true/false.      List(bool)
  protocol    = element(var.protocol, count.index)    // Protocol: tcp/udp/-1.    List(string)
  rule_action = element(var.rule_action, count.index) // Rule Action: allow/deny. List(string)
  cidr_block  = element(var.cidr_block, count.index)  // CIDR Block: A.B.C.D/E.   List(string)
  from_port   = element(var.from_port, count.index)   // From Port: 0-65535.      List(string)
  to_port     = element(var.to_port, count.index)     // To Port: 0-65535.        List(string)
}

resource "aws_network_acl_association" "nacl" {
  count = length(var.subnetid_associate)

  network_acl_id = var.network_acl_id
  subnet_id      = element(var.subnetid_associate, count.index)
}
