/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.goodt.drive.utils;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import liquibase.Contexts;
import liquibase.LabelExpression;
import liquibase.Liquibase;
import liquibase.database.Database;
import liquibase.database.DatabaseFactory;
import liquibase.database.jvm.JdbcConnection;
import liquibase.exception.DatabaseException;
import liquibase.exception.LiquibaseException;
import liquibase.resource.ClassLoaderResourceAccessor;
import org.apache.ibatis.jdbc.ScriptRunner;


public class DatabaseRelatedTestBase {
    public void setUp(String url, String user, String password, String changelogFile, String initScript) throws SQLException, DatabaseException, LiquibaseException, FileNotFoundException {
        conn = DriverManager.getConnection(url, user, password);
        db = DatabaseFactory.getInstance().findCorrectDatabaseImplementation(new JdbcConnection(conn));
        liquibase = new liquibase.Liquibase(changelogFile, new ClassLoaderResourceAccessor(), db);
        liquibase.update(new Contexts(), new LabelExpression());
        // todo: umv: insert data
        ScriptRunner runner = new ScriptRunner(conn);
        runner.runScript(new BufferedReader(new FileReader(initScript)));
    }
    
    public void tearDown() throws SQLException{
        conn.close();
    }
    
    Connection conn;
    Database db;
    Liquibase liquibase;
}
