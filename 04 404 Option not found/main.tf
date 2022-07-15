resource "nsxt_lb_http_application_profile" "lb_http_application_profile" {
  description            = "http application profile provisioned by Terraform"
  display_name           = "terraform-demo-application-profile"
  idle_timeout           = "15"
  request_body_size      = "100"
  request_header_size    = "2048"
  response_timeout       = "60"
}