locals {
  prefix        = "${var.env}-${var.project}-${var.module}"
  global_suffix = "${var.region}-${var.account_id}"
}
