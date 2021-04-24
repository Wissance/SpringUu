## Description
   SpringUu is a spring Ultimate Utils that makse easier life and work with Spring Boot 2+.

## Usefull tools:
    - easily generate migration and include in changelog.xml

Currently ALL tools are working ONLY with Gradle build system

    1.  Utilities for Code First approach with Spring Boot, JPA, Hibernate using Liquibase
        this utility was built with native shell scripts:
        - powershell for Windows
        - bash for Linux, OSX (not ready)

    ### Requirements:
        1. Shell script must be located in the same directory as build.gradle
        2. Gradle script must have special liquibase settings (see full example here: samples/gradleWithLiquibase):
            liquibase {
                activities {
                    main {
                        changeLogFile "$projectDir/src/main/resources/db/changelog/changelog.xml"
                        outputFile outputLog
                        driver "org.postgresql.Driver"
                        url "jdbc:postgresql://localhost:5432/webportal"
                        username "developer"
                        password "123"
                        referenceUrl "hibernate:spring:com.wissance.webportal.application.model.entities?dialect=org.hibernate.dialect.PostgreSQL94Dialect&hibernate.physical_naming_strategy=com.wissance.utils.SnakePhysicalNamingStrategy"
                        referenceDriver 'liquibase.ext.hibernate.database.connection.HibernateDriver'
                    }
                    changesGen {
                        changeLogFile "$projectDir/src/main/resources/db/changelog/newChangelog.xml"
                        outputFile outputLog
                        driver "org.postgresql.Driver"
                        url "jdbc:postgresql://localhost:5432/webportal"
                        username "developer"
                        password "123"
                        referenceUrl "hibernate:spring:com.wissance.webportal.application.model.entities?dialect=org.hibernate.dialect.PostgreSQL94Dialect&hibernate.physical_naming_strategy=com.wissance.utils.SnakePhysicalNamingStrategy"
                        referenceDriver 'liquibase.ext.hibernate.database.connection.HibernateDriver'
                    }
                    // changesApply is used for Apply Migrations on Database
                    changesApply {
                        changeLogFile "$projectDir/src/main/resources/db/changelog/changelog.xml"
                        outputFile outputLog
                        driver "org.postgresql.Driver"
                        url "jdbc:postgresql://localhost:5432/webportal"
                        username "developer"
                        password "123"
                        referenceUrl "hibernate:spring:com.wissance.webportal.application.model.entities?dialect=org.hibernate.dialect.PostgreSQL94Dialect&hibernate.physical_naming_strategy=com.wissance.utils.SnakePhysicalNamingStrategy"
                        referenceDriver 'liquibase.ext.hibernate.database.connection.HibernateDriver'
                    }
                }
                runList = project.ext.runList
            }

        3. You MUST include class SnakePhysicalNamingStrategy in your project and configure path in upper mentioned Gradle script
        4. See package for models classes, in gradle settings it were set as - com.wissance.webportal.application.model.entities
        5. In above example we assumed that we works with Postgres SQL and therefore your application.yml should be configured in following manner:
        spring:
          jpa:
            show-sql: true
            properties:
              hibernate:
                format_sql: true
                enable_lazy_load_no_trans: true
                naming:
                  physical-strategy: com.wissance.utils.SnakePhysicalNamingStrategy
            hibernate:
              ddl-auto: none
            database-platform: org.hibernate.dialect.PostgreSQL9Dialect
    
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
