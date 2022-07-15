resource "nsxt_ns_group" "allow-modification" {
  description  = "NSGroup for Terraform demo"
  display_name = "terraform-nsgroup-demo"
}