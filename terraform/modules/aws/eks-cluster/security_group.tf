/******************************************
	Master Role configuration
 *****************************************/
resource "aws_security_group" "cluster_master" {
  name        = "cluster-master"
  description = "EKS cluster master security group"

  tags = merge(
    {
      Name = "eks-master-sg"
    },
    var.tags
  )

  vpc_id = var.vpc_id

  ingress {
    description = "Allow access to Kubernetes API server"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all egress communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/******************************************
	Node Role configuration
 *****************************************/
resource "aws_security_group" "cluster_nodes" {
  name        = "cluster-nodes"
  description = "EKS cluster nodes security group"

  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = "eks-nodes-sg"
    },
    var.tags
  )

  ingress {
    description     = "Allow cluster master to access cluster nodes"
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.cluster_master.id]
  }

  ingress {
    description     = "Allow cluster master to access cluster nodes"
    from_port       = 1025
    to_port         = 65535
    protocol        = "udp"
    security_groups = [aws_security_group.cluster_master.id]
  }

  ingress {
    description = "Allow inter pods communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all egress communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
