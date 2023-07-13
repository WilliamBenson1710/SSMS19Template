:CONNECT OLY-DBASQL-01
GO

USE [master]
GO

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'WSECU\svcDataDog')
BEGIN
    CREATE LOGIN [WSECU\svcDataDog] FROM WINDOWS WITH DEFAULT_DATABASE=[master] 
END

GRANT CONNECT ANY DATABASE TO [WSECU\svcDataDog]

GRANT VIEW ANY DEFINITION TO [WSECU\svcDataDog]

GRANT VIEW SERVER STATE TO [WSECU\svcDataDog]

GRANT SELECT on sys.dm_os_performance_counters to [WSECU\svcDataDog]
GO