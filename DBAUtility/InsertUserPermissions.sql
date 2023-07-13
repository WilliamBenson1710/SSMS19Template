USE [DBAUtility]
GO

INSERT INTO [Config].[UserDatabasePermissions]
([DatabaseName]
,[UserCredentials]
,[DatabaseRoleName]
,[IsFixedRole]
,[WithExcute]
,[ViewDefinition]
,[IsActive]
,[ServerName]
)
SELECT
[DatabaseName]
,'WSECU\Development' AS [UserCredentials]
,'db_owner' AS [DatabaseRoleName]
,1 AS [IsFixedRole]
,0 AS [WithExcute]
,0 AS [ViewDefinition]
,1 AS [IsActive]
,@@ServerName AS [ServerName]
FROM [DBAUtility].[Config].[UserDatabasePermissions]
WHERE UserCredentials = 'backbase'
AND CHARINDEX('wsecu', DatabaseRoleName) > 0
ORDER BY DatabaseName