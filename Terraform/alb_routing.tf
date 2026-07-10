# Terraform/alb_routing.tf

# target group for our lambda cache
resource "aws_lb_target_group" "lambda_cache_tg" {
  name        = "tg-vet-cache-proxy"
  target_type = "lambda"
}

# hook lambda to target group
resource "aws_lb_target_group_attachment" "lambda_tg_attachment" {
  target_group_arn = aws_lb_target_group.lambda_cache_tg.arn
  target_id        = aws_lambda_function.cache_proxy.arn 
}

# canary routing rule
resource "aws_lb_listener_rule" "canary_cache_hospital_route" {
  # swap this with your actual ALB listener ARN
  listener_arn = "arn:aws:elasticloadbalancing:eu-west-2:664047078509:listener/app/lb-VetOp/543123630aad3957/243c2e9edccb9b65"
  
  priority     = 100 # check this rule first

  action {
    type = "forward"
    
    forward {
      # THIS IS THE PERCENTAGE TRAFFIC TO BE SENT THE LAMBDA CACHE
      target_group {
        arn    = aws_lb_target_group.lambda_cache_tg.arn
        weight = 100
      }

      # THIS IS THE TRAFFIC GOING TO THE original vendor DB
      target_group {
        # swap this with your existing vendor target group ARN
        arn    = "arn:aws:elasticloadbalancing:eu-west-2:664047078509:targetgroup/lb-tg-VetOp/7e8634d3230cb907"
        weight = 0
      }
    }
  }

  # only grab /hospital/ routes
  condition {
    path_pattern {
      values = ["/hospital/*"]
    }
  }
  
  # only intercept GET requests
  condition {
    http_request_method {
      values = ["GET"]
    }
  }

  # optional IP filtering
  # uncomment to restrict the test to just your IP (e.g., your Cardiff home/office)
  # condition {
  #   source_ip {
  #     values = ["203.0.113.50/32"] # add tester(s) ip addressed in here
  #   }
  # }
}
