## Description

   Set of utilities and classes to make easier life with Spring Boot.

## Usefull tools:
    - easily generate migration and include in changelog.xml

Currently ALL tools are working ONLY with Gradle build system

    1.  Utilities for Code First approach with Spring Boot, JPA, Hibernate using Liquibase
        this utility was built with native shell scripts:
        - powershell for Windows
        - bash for Linux, OSX (not ready)

    ### Requirements:
        1. Shell script must be located in the same directory as build.gradle
        2. Gradle script must have special liquibase settings:
            liquibase {
                activities {
                    main {
                        changeLogFile "$projectDir/src/main/resources/db/changelog/changelog.xml"
                        outputFile outputLog
                        driver "org.postgresql.Driver"
                        url "jdbc:postgresql://localhost:5432/webportal"
                        username "developer"
                        password "123"
                        referenceUrl "hibernate:spring:com.wissance.webportal.application.model.entities?dialect=org.hibernate.dialect.PostgreSQL94Dialect&hibernate.physical_naming_strategy=com.wissance.webportal.application.utils.SnakePhysicalNamingStrategy"
                        referenceDriver 'liquibase.ext.hibernate.database.connection.HibernateDriver'
                    }
                    changesGen {
                        changeLogFile "$projectDir/src/main/resources/db/changelog/newChangelog.xml"
                        outputFile outputLog
                        driver "org.postgresql.Driver"
                        url "jdbc:postgresql://localhost:5432/webportal"
                        username "developer"
                        password "123"
                        referenceUrl "hibernate:spring:com.wissance.webportal.application.model.entities?dialect=org.hibernate.dialect.PostgreSQL94Dialect&hibernate.physical_naming_strategy=com.wissance.webportal.application.utils.SnakePhysicalNamingStrategy"
                        referenceDriver 'liquibase.ext.hibernate.database.connection.HibernateDriver'
                    }
                    // changesApply is used for Apply Migrations on Database
                    changesApply {
                        changeLogFile "$projectDir/src/main/resources/db/changelog/changelog.xml"
                        outputFile outputLog
                        driver "org.postgresql.Driver"
                        url "jdbc:postgresql://localhost:5432/monitor"
                        username "developer"
                        password "123"
                        referenceUrl "hibernate:spring:com.wissance.webportal.application.model.entities?dialect=org.hibernate.dialect.PostgreSQL94Dialect&hibernate.physical_naming_strategy=com.wissance.webportal.application.utils.SnakePhysicalNamingStrategy"
                        referenceDriver 'liquibase.ext.hibernate.database.connection.HibernateDriver'
                    }
                }
                runList = project.ext.runList
            }

        3. You MUST include class SnakePhysicalNamingStrategy in your project and configure path in upper mentioned Gradle script
        4. See package for models classes, in gradle settings it were set as - com.wissance.webportal.application.model.entities
    
    ### Algorythm.
    To generate migration based on changes between model and database state and include changes as SQL diff (migration) in changelog.xml (located on standard path: src\main\resources\db\changelog\changelog.xml)
    
    Do following:
        a. copy appropriate shell script to directory where you build.gradle file is located
        b. configure your gradle script as was mentiond in Requirements section and copy class SnakePhysicalNamingStrategy into your project
        c. if it is a first migration prepare database !!!! : .\gradlew.bat update -PrunList='changesApply'
        d. run .\generateMigration.ps1 1 Initial or ./generateMigration.sh 1 Initial
        e. apply migration manually or at application start with liquibase

        Phase c. will possibly (IN FUTURE) moved inside c.

    ### Future PLANS:
        1. Create build.gradle for integration in any project
        2. Create Java package with classes and include it in build.gradle from 1.