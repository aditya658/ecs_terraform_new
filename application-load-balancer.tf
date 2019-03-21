resource "aws_alb" "ecs-load-balancer" {
    name                = "ecs-load-balancer"
    security_groups     = ["${aws_security_group.test_public_sg.id}"]
    subnets             = ["${aws_subnet.test_public_sn_01.id}", "${aws_subnet.test_public_sn_02.id}"]

    tags {
      Name = "ecs-load-balancer"
    }
}

resource "aws_alb_target_group" "ecs-target-group" {
    name                = "ecs-target-group"
    port                = "80"
    protocol            = "HTTP"
    vpc_id              = "${aws_vpc.test_vpc.id}"

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }

    tags {
      Name = "ecs-target-group"
    }
}

resource "aws_alb_listener" "alb-listener" {
    load_balancer_arn = "${aws_alb.ecs-load-balancer.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.ecs-target-group.arn}"
        type             = "forward"
    }
}
resource "aws_alb_listener" "alb_https_listener" {
  load_balancer_arn = "${aws_alb.ecs-load-balancer.arn}"
  port = "443"
  protocol = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::891241530761:server-certificate/MyCertificate"

  default_action {
    target_group_arn = "${aws_alb_target_group.ecs-target-group.arn}"
    type             = "forward"
  }

  lifecycle {
    create_before_destroy = true
  }
}


















# https listener rules
# resource "aws_alb_listener_rule" "alb_https_public_rule" {
#  listener_arn = "${aws_alb_listener.alb_https_listener.arn}"
#  priority = 100

 # action {
 #   type = "forward"
 #   target_group_arn = "${aws_alb_target_group.ecs-target-group.arn}"
 # }

#  condition {
#  field = "host-header"
#   values = ["harielb.tk"]
#  }

#  lifecycle {
#    create_before_destroy = true
#  }
#}

#resource "aws_alb_listener_rule" "alb_https_author_rule" {
 # listener_arn = "${aws_alb_listener.alb_https_listener.arn}"
 # priority = 99
#  action {
#type = "forward"
#    target_group_arn = "${aws_alb_target_group.ecs-target-group.arn}"
#  }
#
#  condition {
#    field = "host-header"
#    values = ["example.corp.com"]
#  }
#
#  lifecycle {
#    create_before_destroy = true
#  }
#}
