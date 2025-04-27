# terraform/variables.tf

variable "project" {
  type = string
  description = "Project name"
}

variable "subscription" {
  type = string
  description = "Subscription ID"
}

variable "environment" {
  type = string
  description = "Environment (dev / stage / prod)"
}

variable "location" {
  type = string
  description = "Azure region to deploy module to"
}

variable "storagename" {
  type = string
  description = "Last 24 chars of md5 sum of {project}-{environment}-storage"
}
