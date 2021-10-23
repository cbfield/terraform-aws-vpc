locals {
  backend_ports = [
    80,
    443,  # these really depend on what's
    8080, # being served by the back-end;
    8081, # just an example
  ]
  persistence_ports = [
    2049, # NFS
    3306, # MySQL
    5432, # PostgreSQL
    5439, # Redshift
  ]
}
