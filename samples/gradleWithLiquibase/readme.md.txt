Here is a sample build.gradle script (template). To use it in an any custom project do following:

1. Adjust packages names (set yours), in sample script we have com.wissance as group and com.wissance.webportal as package name in the properties referenceUrl and mainClassName
2. Copy class SnakePhysicalNamingStrategy (from this repository) and place in appropriate location in your app  (see all referenceUrl properties)
3. Configure db settings (properties url, username, password) for all liquibase activities
4. Ensure that you application.yml settings are properly configured i.e.:
```
spring:
  profiles: local
  jpa:
    show-sql: true
    properties:
      hibernate:
        format_sql: true
        enable_lazy_load_no_trans: true
        naming:
            physical-strategy: com.wissance.webportal.application.utils.SnakePhysicalNamingStrategy
    hibernate:
      ddl-auto: none
    database-platform: org.hibernate.dialect.PostgreSQL9Dialect
  datasource:
    driver-class-name: org.postgresql.Driver
    url: jdbc:postgresql://goodt-dev.goodt.me:5432/webportal
    username: monitor_user
    password: tsk_pww_pg_2
  liquibase:
    change-log: classpath:db/changelog/changelog.xml
```