variable "region" {
  default = "us-east-1"
}


variable "identifier" {
  description = "The identifier for the RDS DB instance."
  type        = string
  default     = "dev-database"
}

variable "allocated_storage" {
  description = "The amount of storage (in gigabytes) to allocate for the DB instance."
  type        = number
  default     = 10
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created."
  type        = string
  default     = "mydb"
}

variable "engine" {
  description = "The name of the database engine to be used for this instance."
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The version number of the database engine to use."
  type        = string
  default     = "5.7"
}

variable "instance_class" {
  description = "The instance type to use."
  type        = string
  default     = "db.t3.micro"
}

variable "username" {
  description = "The master username for the DB instance."
  sensitive = true
}

variable "password" {
  description = "The password for the master database user."
  sensitive = true
}

variable "parameter_group_name" {
  description = "The name of the DB parameter group to associate with this instance."
  type        = string
  default     = "default.mysql5.7"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "The number of days for which automated backups are retained."
  type        = number
  default     = 0
}
