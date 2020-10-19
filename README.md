Set of utilities and classes to make easier life with Spring Boot.

Currently ALL tools are working with Gradle build system

1.  Utilities for code first with Spring Boot, JPA, Hibernate using Liquibase
    this utility was built with native shell scripts:
        - powershell for Windows
        - bash for Linux, OSX (not ready)
    
    To generate migration based on changes In model and database state and 
    include migration in changelog.xml (located on standard path: src\main\resources\db\changelog\changelog.xml)
    Do following:
    a. copy appropriate shell script to directory where you build.gradle file is located
    b. if it is a first migration prepare database: .\gradlew.bat updatesql -PrunList='changesGen'
    c. run .\generateMigration.ps1 1 Initial or ./generateMigration.sh 1 Initial
    d. apply migration manually ... or at application start with liquibase