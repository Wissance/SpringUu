# Script for Automate migration generation with Liquibase and Gradle!
# You MUST Pass 2 parameters : 
#    1) Migration number - integer value from 1 to +INFINITY
#    2) Migration description - what was done, ONLY _ is ALLOWED to use as separator between words
#       however you could pass words separated with spaces but theese words wrapped in single quotes
#       i.e. Updated_column_xxx_name_and_added_unique_constraint_on_name
# Example .\generateMigration.ps1 5 Tables_Employee_Renamed
# Example .\generateMigration.ps1 5 'Tables Employee Renamed'

$migrationNumber = $args[0]
$migrationName = $args[1]

# TODO: UMV: Check Variables

$gradleScriptName = "gradlew.bat"

# 1. Process $migrationName replace ' ' with '_'
$migrationName = $migrationName.Replace(' ', '_')
# 2. Get current datetime
$timestamp = (Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')
$migrationFileName = "$($timestamp)_Migration_$($migrationNumber)_$($migrationName).sql"

Write-Host "Generating migration name: $migrationFileName"

$currentDir = Split-Path (Get-Variable MyInvocation).Value.MyCommand.Path
# Here we assume that gradle is located in same dir as this script
Write-Host "Working directory is: $currentDir"

$gardleFullPath = Join-Path $currentDir $gradleScriptName
Write-Host "Gradle script path is: $gardleFullPath"
# 3. Remove generated files
$migrationPath = Join-Path $currentDir "src\main\resources\db\changelog\"
$liquibaseDiff = Join-Path $currentDir "diffOutputLog.txt"
$liquibaseChangelog = Join-Path $migrationPath "newChangelog.xml"

Write-Host "Liquibase diff file is: $liquibaseDiff"
Write-Host "Liquibase changelog file is: $liquibaseChangelog"

if (Test-Path $liquibaseDiff)
{
    Remove-Item $liquibaseDiff
}

if (Test-Path $liquibaseChangelog)
{
    Remove-Item $liquibaseChangelog
}

# 4. Changelog generation
$liquibaseRunList = "-PrunList=changesGen"
& $gardleFullPath diffChangeLog $liquibaseRunList

# 5. Sql migration from changelog
& $gardleFullPath updateSql $liquibaseRunList

# 6. Copy migration to migrations dir
$migrationFileFullPath = Join-Path $migrationPath $migrationFileName
Copy-Item -Path $liquibaseChangelog -Destination $migrationFileFullPath
# 7. Update Migration Changelog.xml

# 8. Clean-up
if (Test-Path $liquibaseDiff)
{
    Remove-Item $liquibaseDiff
}

if (Test-Path $liquibaseChangelog)
{
    Remove-Item $liquibaseChangelog
}