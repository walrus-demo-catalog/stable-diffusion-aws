output "endpoint_service_url" {
  description = "URL to access the web UI"
  value = "http://${aws_instance.stable_diffusion.public_ip}:7860"
}
