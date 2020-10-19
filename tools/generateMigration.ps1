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

# Write-Host "Generating migration name: $migrationFileName"

$currentDir = Split-Path (Get-Variable MyInvocation).Value.MyCommand.Path
# Here we assume that gradle is located in same dir as this script
# Write-Host "Working directory is: $currentDir"

$gradleFullPath = Join-Path $currentDir $gradleScriptName
# Write-Host "Gradle script path is: $gardleFullPath"
# 3. Remove generated files
$migrationPath = Join-Path $currentDir "src\main\resources\db\changelog\"
$liquibaseDiff = Join-Path $currentDir "diffOutputLog.txt"
$liquibaseChangelog = Join-Path $migrationPath "newChangelog.xml"

# Write-Host "Liquibase diff file is: $liquibaseDiff"
# Write-Host "Liquibase changelog file is: $liquibaseChangelog"

if (Test-Path $liquibaseDiff)
{
    Remove-Item $liquibaseDiff
}

if (Test-Path $liquibaseChangelog)
{
    Remove-Item $liquibaseChangelog
}

# 4. Diff generation
$liquibaseRunList = "-PrunList=changesGen"

Write-Host "###### 1. Generate Diff file Between Model classes and database ######"
& $gradleFullPath diffChangeLog $liquibaseRunList

# 5. Sql migration from changelog
Write-Host "###### 2. Generate Sql from Xml Diff ######"
# Write-Host "Debug CMD: $gradleFullPath updatesql $liquibaseRunList"
& $gradleFullPath updatesql $liquibaseRunList

# 6. Copy migration to migrations dir
Write-Host "###### 3. Copy migration to standard changelog directory (src\main\resources\db\changelog\) ######"
$migrationFileFullPath = Join-Path $migrationPath $migrationFileName
Copy-Item -Path $liquibaseDiff -Destination $migrationFileFullPath

# 7. Update Migration Changelog.xml
Write-Host "###### 4. Append migration to changelog.xml ######"
$changelogFile = Join-Path $migrationPath "changelog.xml"
$changelogXml=[xml](Get-Content $changelogFile)
$node = $changelogXml.databaseChangeLog
$includeNode = $changelogXml.CreateElement("include", $node.NamespaceURI)
$includeNode.SetAttribute("file", $migrationFileName)
$includeNode.SetAttribute("relativeToChangelogFile", 'true')
$node.AppendChild($includeNode)
$changelogXml.save($changelogFile)

# 8. Clean-up
if (Test-Path $liquibaseDiff)
{
    Remove-Item $liquibaseDiff
}

if (Test-Path $liquibaseChangelog)
{
    Remove-Item $liquibaseChangelog
}