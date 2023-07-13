USE [master]
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'WSECU\gvcDBASQL01$')
CREATE LOGIN [WSECU\gvcDBASQL01$] FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]
GO

USE [master]
GO

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'InventoryAdmin' AND type = 'R')
CREATE SERVER ROLE [InventoryAdmin]
GO

USE [master] 
GO 
ALTER SERVER ROLE [InventoryAdmin] ADD MEMBER [WSECU\gvcDBASQL01$] 
GO 
GRANT VIEW SERVER STATE TO [InventoryAdmin] 
GO 
GRANT VIEW ANY DEFINITION TO [InventoryAdmin] 
GO  
GRANT VIEW ANY DATABASE TO [InventoryAdmin]  
GO  
GRANT CONNECT ANY DATABASE TO [InventoryAdmin]  
GO