variable "docker_username" {
  description = "Docker Hub username"
  type        = string
}

variable "docker_password" {
  description = "Docker Hub password or access token"
  type        = string
  sensitive   = true
}

variable "docker_image_name" {
  description = "Docker image name to pull and run"
  type        = string
}
