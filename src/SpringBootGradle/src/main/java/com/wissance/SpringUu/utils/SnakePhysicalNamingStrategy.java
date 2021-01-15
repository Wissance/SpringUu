package com.wissance.SprinUu.utils;
import org.hibernate.boot.model.naming.PhysicalNamingStrategy;
import org.hibernate.boot.model.naming.Identifier;
import org.hibernate.engine.jdbc.env.spi.JdbcEnvironment;

public class SnakePhysicalNamingStrategy implements PhysicalNamingStrategy {
 
    @Override
    public Identifier toPhysicalCatalogName(Identifier identifier, JdbcEnvironment jdbcEnv) {
        return identifier;
    }
 
    @Override
    public Identifier toPhysicalColumnName(Identifier identifier, JdbcEnvironment jdbcEnv) {
        return identifier;
    }
 
    @Override
    public Identifier toPhysicalSchemaName(Identifier identifier, JdbcEnvironment jdbcEnv) {
        return identifier;
    }
 
    @Override
    public Identifier toPhysicalSequenceName(final Identifier identifier, JdbcEnvironment jdbcEnv) {
        return identifier;
    }
 
    @Override
    public Identifier toPhysicalTableName(Identifier identifier, JdbcEnvironment jdbcEnv) {
        return toSnakeCase(identifier);
    }
 
    private Identifier toSnakeCase(Identifier identifier) {
        return Identifier.toIdentifier(identifier.getText().replaceAll("([a-z])([A-Z])", "$1_$2").toLowerCase());
    }
}