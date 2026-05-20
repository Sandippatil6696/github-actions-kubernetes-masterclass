output "release_name" {
  value = helm_release.envoy_gateway.name
}

output "namespace" {
  value = helm_release.envoy_gateway.namespace
}