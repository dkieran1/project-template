# terraform/variables.tf

variable "project" {
  type = string
  description = "Project name"
}

variable "subscription" {
  type = string
  description = "Subscription ID"
}

variable "app_registration_client_id" {
  type = string
  description = "App Client Registration ID"
}

variable "environment" {
  type = string
  description = "Environment (dev / stage / prod)"
}

variable "location" {
  type = string
  description = "Azure region to deploy module to"
}

variable "githubtoken" {
  type = string
  description = "GitHub token for accessing project source repo"
}