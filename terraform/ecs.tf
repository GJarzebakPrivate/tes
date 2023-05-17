# where we put the service 
resource "aws_ecs_cluster" "app" {
  name = "tessian"
}

# service itself 
resource "aws_ecs_service" "tessian" {
  name            = "tessian"
  task_definition = aws_ecs_task_definition.tessian.arn
  cluster         = aws_ecs_cluster.app.id
  launch_type     = "FARGATE"

  desired_count = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.tessian.arn
    container_name   = "tessian"
    container_port   = "80"
  }

  network_configuration {
    assign_public_ip = false

    security_groups = [
      aws_security_group.egress_all.id,
      aws_security_group.ingress_api.id,
    ]

    subnets = module.vpc.private_subnets

  }
}

# our django app task def
resource "aws_ecs_task_definition" "tessian" {
  family = "tessian"

  container_definitions = <<EOF
  [
    {
      "name": "tessian",
      "image": "${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-west-2.amazonaws.com/${data.aws_ecr_repository.tessian.name}:latest",
      "portMappings": [
        {
          "containerPort": 80
        }
      ]
    }
  ]
EOF

  execution_role_arn = aws_iam_role.tessian_task_execution_role.arn

  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]

  # needed for fargate
  network_mode = "awsvpc"
}

# self explainatory
resource "aws_security_group" "egress_all" {
  name        = "egress-all"
  description = "Allow all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress_api" {
  name        = "http"
  description = "HTTP traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}