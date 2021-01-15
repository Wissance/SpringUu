/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.goodt.drive.utils;

import java.io.FileNotFoundException;
import java.sql.SQLException;
import liquibase.exception.DatabaseException;
import liquibase.exception.LiquibaseException;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.springframework.test.context.ActiveProfiles;


@ActiveProfiles("integrationaltests")
public class IntegrationalTestBase extends DatabaseRelatedTestBase {
        @BeforeEach
    public void setUp() throws DatabaseException, LiquibaseException, SQLException, FileNotFoundException{
        setUp("jdbc:postgresql://localhost:5432/goals_integrationaltests", "developer", "123", 
              "db/changelog/changelog.xml", "src/main/resources/db/test/data/test_data_postgres.sql");
    }
    
    @AfterEach
    @Override
    public void tearDown() throws SQLException {
        super.tearDown();
    }
    
}
