variable "project_id" {
  type        = string
  default     = "gcp-assessment-341822"
  description = "The Project ID you'll be using to create resources"
}

variable "region" {
  type        = string
  default     = "us-east4"
  description = "The region you'll be deploying to"
}

variable "project_name" {
  type        = string
  default     = "gcp-assessment"
  description = "The Project ID you'll be using to create resources"
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of Subnet(s) being created"
  default = [
    {
      subnet_name           = "us-east"
      subnet_ip             = "192.168.0.0/24"
      subnet_region         = "us-east4"
      subnet_private_access = true
      description           = "Northern VA Region"
    }
  ]
}

variable "custom_rules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  type = map(object({
    description          = string
    direction            = string
    action               = string # (allow|deny)
    ranges               = list(string)
    sources              = list(string)
    targets              = list(string)
    use_service_accounts = bool
    rules = list(object({
      protocol = string
      ports    = list(string)
    }))
    extra_attributes = map(string)
  }))
  default = {
    allow-http = {
      description          = "Allows http connections"
      direction            = "INGRESS"
      action               = "allow"
      ranges               = ["0.0.0.0/0"]
      sources              = null
      targets              = ["allow-http"]
      use_service_accounts = false
      rules = [
        {
          protocol = "tcp"
          ports    = ["80"]
        }
      ]
      extra_attributes = {}
    }
  }
}

variable "subnetwork_name" {
  type        = string
  default     = "us-east"
  description = "Name of subnetwork to be created"
}
