data "aws_lb" "vetop" {
  name = "lb-VetOp"
}

resource "aws_wafv2_web_acl_association" "waf_lb_vetop" {
  resource_arn = data.aws_lb.vetop.arn
  web_acl_arn  = aws_wafv2_web_acl.waf_lb_vetop.arn
}
