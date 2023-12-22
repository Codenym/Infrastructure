output "db_name" {
    value = module.database.db_name
    sensitive = false
}

output "db_user" {
    value = module.database.db_user
    sensitive = false
}

output "db_password" {
    value = module.database.db_password
    sensitive = true
}

output "db_endpoint" {
    value = module.database.db_endpoint
    sensitive = false
}

