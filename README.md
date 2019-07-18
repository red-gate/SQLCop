# SQLCop

Welcome to the SQL Cop repository!

These are a set of tSQLt tests designed to allow you to detect common problems in your database, originally maintained by George Mastros on LessThanDot.

This project is now managed by SQLServerCentral and Redgate Software. Steve Jones is the primary contact, but all updates and contributions are welcome by pull request. If you submit a contribution, please include reasons why the changes are helpful to most users of the project.

## Requirements

This project requires the [tsqlt framework](https://tsqlt.org/) to run the tests. All SQL Server versions that support the SQLCLR can use these tests. Please check the tsqlt requirements for your system.

**NOTE** : These Tests are NOT suitable for production databases

## Installing the tests

All tests are created a stored procedures in a test class (schema), called SQLCop. You can compile them in a SQL Server database and use the tsql.run command to execute any of these tests.

## Issues Checked
The following is a list of issues that are checked by the current project.

### Code

    Procedures with SP_
    VarChar Size Problems
    Decimal Size Problem
    Undocumented Procedures
    Procedures without SET NOCOUNT ON
    Procedures with SET ROWCOUNT
    Procedures with @@Identity
    Procedures with dynamic sql
    Procedures using dynamic sql without sp_executesql

### Column

    Column Name Problems
    Columns with float data type
    Columns with image data type
    Tables with text/ntext
    Collation Mismatch
    UniqueIdentifier with NewId

### Table/Views

    Table Prefix
    Table Name Problems
    Missing Foreign Keys
    Wide Tables
    Tables without a primary key
    Empty Tables
    Views with order by
    Unnamed Constraints

### Indexes

    Fragmented indexes
    Missing Foreign Key Indexes
    Forwarded Records

### Configuration

    Database Collation
    Auto Close
    Auto Create
    Auto Shrink
    Auto Update
    Compatibility Level
    Login Language
    Old Backups
    Orphaned Users
    User Aliases
    Ad Hoc Distributed Queries
    CLR
    Database and log files on the same physical disk
    Database Mail
    Deprecated Features
    Instant File Initialization
    Max Degree of Parallelism
    OLE Automation Procedures
    Service Account
    SMO and DMO
    SQL Server Agent Service
    xp cmdshell

### Health

    Buffer cache hit ratio
    Page life expectancy
