USE []
GO

SET NOCOUNT ON;
DECLARE @user NVARCHAR(MAX);
DECLARE Orphans CURSOR FOR
SELECT dp.name AS user_name 
FROM sys.database_principals AS dp 
LEFT JOIN sys.server_principals AS sp ON dp.SID = sp.SID 
WHERE sp.SID IS NULL 
AND authentication_type_desc = 'INSTANCE'
AND dp.name IN (SELECT name FROM sys.server_principals);
OPEN Orphans
FETCH NEXT FROM Orphans INTO @user
WHILE @@FETCH_STATUS = 0
BEGIN
 DECLARE @Command NVARCHAR(MAX);
 SET @Command = N'ALTER USER ' + QUOTENAME(@user) + N' WITH LOGIN = ' + QUOTENAME(@user)
 PRINT @Command
 EXEC (@Command);
 FETCH NEXT FROM Orphans INTO @user
END
CLOSE Orphans
DEALLOCATE Orphans