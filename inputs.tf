variable "env" {
  description = "Current environment name which is being deployed"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.env)
    error_message = "Variable env must be set to dev, stage, or prod."
  }
}
