resource "aws_ecs_cluster" "threat-composer-lb-ecs" {
  name = var.cluster_name
}


resource "aws_ecs_task_definition" "composer-task-definition" {
  family                   = var.task_definition_name
  requires_compatibilities = var.ecs_launch_type
  network_mode             = var.task_network_mode
  cpu                      = var.ecs_definition_cpu
  memory                   = var.ecs_definition_memory
  execution_role_arn       = aws_iam_role.composer_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = var.ecs_container_name
      image     = var.ecs_container_image_uri
      cpu       = var.ecs_container_cpu
      memory    = var.ecs_container_memory
      essential = true
      portMappings = [
        {
          containerPort = var.ecs_container_port
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "mongo" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.threat-composer-lb-ecs.id
  task_definition = aws_ecs_task_definition.composer-task-definition.arn
  desired_count   = var.ecs_service_count
  launch_type     = var.ecs_service_launch_type

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.ecs_container_name
    container_port   = var.ecs_container_port
  }
}

resource "aws_iam_role" "composer_execution_role" {
  name = var.ecs_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = ["ecs-tasks.amazonaws.com"]
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.composer_execution_role.name
  policy_arn = var.aws_iam_role_policy
}