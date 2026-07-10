resource "aws_wafv2_regex_pattern_set" "valid_basic_auth_format" {
  name        = "valid-basic-auth-format"
  description = "Validates Authorization: Basic base64 header format"
  scope       = "REGIONAL"

  regular_expression {
    regex_string = "^Basic [A-Za-z0-9+/]+=*$"
  }
}