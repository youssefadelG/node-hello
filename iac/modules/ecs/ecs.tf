resource "aws_ecs_cluster" "node_hello_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "node_hello_task" {
  family                   = var.node_hello_task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = var.node_hello_task_name
      image     = var.dockerhub_repo_url
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      
      environment = [
        {
          name  = "NEW_RELIC_LICENSE_KEY"
          value = var.new_relic_license_key
        },
        {
            name = "NEW_RELIC_APP_NAME"
            value = "node-hello"
        },
        {
            name  = "NEW_RELIC_APPLICATION_LOGGING_FORWARDING_ENABLED"
            value = "true"
        },
        {
          name  = "NEW_RELIC_APPLICATION_LOGGING_FORWARDING_MAX_SAMPLES_STORED"
          value = "10000"
        },
        {
          name  = "NEW_RELIC_APPLICATION_LOGGING_LOCAL_DECORATING_ENABLED"
          value = "true"
        },
        {
          name  = "NODE_ENV"
          value = "DEVELOPMENT"
        }
      ]

      log_configuration = {
        log_driver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/node-hello"
          "awslogs-region"       = var.aws_region
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }


    }
  ])
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_alb" "application_load_balancer" {
  name               = var.application_load_balancer_name
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_security_group" "alb_sg" {
  name   = "${var.application_load_balancer_name}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_service_sg" {
  name   = "${var.cluster_name}-service-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = var.target_group_name
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  
  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_ecs_service" "node_hello_service" {
  name            = "${var.node_hello_task_family}-service"
  cluster         = aws_ecs_cluster.node_hello_cluster.id
  task_definition = aws_ecs_task_definition.node_hello_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.node_hello_task_name
    container_port   = var.container_port
  }

  depends_on = [
    aws_lb_listener.listener_http,
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy_attachment
    ]
}