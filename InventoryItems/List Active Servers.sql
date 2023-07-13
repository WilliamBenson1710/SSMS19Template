:CONNECT OLY-DBASQL-01
GO

SELECT
TOP (1000)
[ServerName]
,[EnvironmentName]
,[ADDescription]
,[ADDistinguishedName]
FROM [SqlServerInventory].[Config].[vwServerInformation]
WHERE ServerInfoIsActive = 1
ORDER BY EnvironmentPriority, ServerName
GO