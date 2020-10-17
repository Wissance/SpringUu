# Script for Automate migration generation with Liquibase
# You MUST Pass 2 parameters : 
#    1) Migration number - integer value from 1 to +INFINITY
#    2) Migration description - what was done, ONLY _ is ALLOWED to use as separator between words
#       however you could pass words separated with spaces but theese words wrapped in single quotes
#       i.e. Updated_column_xxx_name_and_added_unique_constraint_on_name
# Example .\generateMigration.ps1 5 Tables_Employee_Renamed
# Example .\generateMigration.ps1 5 'Tables Employee Renamed'

$migrationNumber = $args[0]
$migrationName = $args[1]

# 1. Process $migrationName replace ' ' with '_'
$migrationName = $migrationName.Replace(' ', '_')
# 2. Get current datetime
$migrationFileName="Migration_$($migrationNumber)_$($migrationName).sql"

Write-Host "Generating migration name: $migrationFileName"