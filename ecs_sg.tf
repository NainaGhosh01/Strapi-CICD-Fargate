resource "aws_security_group" "ecs_sg" {
  name        = "naina-ecs-sg"
  description = "Allow traffic from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 1337
    to_port         = 1337
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]  # Only ALB can access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
