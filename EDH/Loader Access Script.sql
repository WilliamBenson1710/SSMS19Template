--Change DB Context
USE [xxxxxxxx];
GO

--Add the svcSSISSQL user
--Add the svcSSISSQL user
IF NOT EXISTS
    (
        SELECT name
        FROM [sys].[database_principals]
        WHERE name = N'WSECU\gvcSsisSql02$'
    )
BEGIN
    CREATE USER [WSECU\gvcSsisSql02$] FOR LOGIN [WSECU\gvcSsisSql02$];
END;
GO
--Permission svcSSISSQL user
ALTER ROLE [db_datareader] ADD MEMBER [WSECU\gvcSsisSql02$];
GO

--Add the svcSSISSQL user
IF NOT EXISTS
    (
        SELECT name
        FROM [sys].[database_principals]
        WHERE name = N'WSECU\gvcSSISSQL02d$'
    )
BEGIN
    CREATE USER [WSECU\gvcSSISSQL02d$] FOR LOGIN [WSECU\gvcSSISSQL02d$];
END;
GO
--Permission svcSSISSQL user
ALTER ROLE [db_datareader] ADD MEMBER [WSECU\gvcSSISSQL02d$];
GO

IF NOT EXISTS
    (
        SELECT name
        FROM [sys].[database_principals]
        WHERE name = N'WSECU\svcSSISSQL'
    )
BEGIN
    CREATE USER [WSECU\svcSSISSQL] FOR LOGIN [WSECU\svcSSISSQL];
END;
GO
--Permission svcSSISSQL user
ALTER ROLE [db_datareader] ADD MEMBER [WSECU\svcSSISSQL];
GO

--Add the svcSSISSQLd user
IF NOT EXISTS
    (
        SELECT name
        FROM [sys].[database_principals]
        WHERE name = N'WSECU\svcSSISSQLd'
    )
BEGIN
    CREATE USER [WSECU\svcSSISSQLd] FOR LOGIN [WSECU\svcSSISSQLd];
END;
GO
--Permission svcSSISSQL user
ALTER ROLE [db_datareader] ADD MEMBER [WSECU\svcSSISSQLd];
GO
--Add the OLY-EDHSQL-01-PRMNRT_BAK-Read group
IF NOT EXISTS
    (
        SELECT name
        FROM [sys].[database_principals]
        WHERE name = N'WSECU\OLY-EDHSQL-01-PRMNRT_BAK-Read'
    )
BEGIN
    CREATE USER [WSECU\OLY-EDHSQL-01-PRMNRT_BAK-Read] FOR LOGIN [WSECU\OLY-EDHSQL-01-PRMNRT_BAK-Read];
END;
GO
--Permission OLY-EDHSQL-01-PRMNRT_BAK-Read group
ALTER ROLE [db_datareader] ADD MEMBER [WSECU\OLY-EDHSQL-01-PRMNRT_BAK-Read];
GO

--Add the WSECU\adminpiotr user
IF NOT EXISTS
    (
        SELECT name
        FROM [sys].[database_principals]
        WHERE name = N'WSECU\adminpiotr'
    )
BEGIN
    CREATE USER [WSECU\adminpiotr] FOR LOGIN [WSECU\adminpiotr];
END;
GO
--Permission WSECU\adminpiotr user
ALTER ROLE [db_datareader] ADD MEMBER [WSECU\adminpiotr];
GO
GRANT SHOWPLAN TO [WSECU\adminpiotr];
GO

--Add the WSECU\adminjoe user
IF NOT EXISTS
    (
        SELECT name
        FROM [sys].[database_principals]
        WHERE name = N'WSECU\adminjoe'
    )
BEGIN
    CREATE USER [WSECU\AdminJoe] FOR LOGIN [WSECU\adminjoe];
END;
GO
--Permission svcSSISSQL user
ALTER ROLE [db_datareader] ADD MEMBER [WSECU\adminjoe];
GO
GRANT SHOWPLAN TO [WSECU\adminjoe];
GO