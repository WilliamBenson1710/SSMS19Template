SELECT 
A.[ServerPrincipalId]
,A.[ServerName]
,A.[PrincipalName]
,':CONNECT ' + A.[ServerName] + '
GO
USE [master]
GO

IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N' + CHAR(39) + A.[PrincipalName] + CHAR(39) + ')
DROP LOGIN [' + A.[PrincipalName] + ']
GO

'
FROM [Detail].[ServerPrincipals] AS A
INNER JOIN Config.vwServerInformation AS B
ON A.ServerId = B.ServerId
WHERE CHARINDEX('WSECU\admin', A.[PrincipalName]) > 0
AND A.[PrincipalName] = 'WSECU\adminwillb'
AND B.ServerInfoIsActive = 1
ORDER BY A.[PrincipalName]