output "db_url" {
  value = module.database.db_url
  sensitive = true
}