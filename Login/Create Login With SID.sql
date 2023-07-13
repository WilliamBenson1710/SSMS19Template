USE [master]
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'')
CREATE LOGIN [] WITH PASSWORD=N'', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], SID=, CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

ALTER LOGIN [] ENABLE
GO