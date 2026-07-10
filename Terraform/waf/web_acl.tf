resource "aws_wafv2_web_acl" "waf_lb_vetop" {
  name        = "waf-lb-VetOp"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "block-malformed-auth-header"
    priority = 0

    action {
      block {
        custom_response {
          response_code = 400
        }
      }
    }

    statement {
      and_statement {
        statement {
          size_constraint_statement {
            field_to_match {
              single_header {
                name = "authorization"
              }
            }
            comparison_operator = "GT"
            size                = 0

            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }

        statement {
          not_statement {
            statement {
              regex_pattern_set_reference_statement {
                arn = aws_wafv2_regex_pattern_set.valid_basic_auth_format.arn

                field_to_match {
                  single_header {
                    name = "authorization"
                  }
                }

                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "block-malformed-auth-header"
    }
  }

  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-lb-VetOp"
  }
}