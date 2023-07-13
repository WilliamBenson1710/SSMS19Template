--:CONNECT OLY-DBASQL-01
--GO

USE [SqlServerInventory]
GO

SELECT
[ServerId]
,[ServerName]
,[ServerAlias]
,[EnvironmentDesc]
,[DatabaseName]
,[DatabaseStatus]
,[RecoveryModel]
,[CompatibilityLevel]
,[CompatibilityLevelDescr]
,[LastFullDatabaseBackupInDays]
,[LastFullDatabseBackup]
,[EnvironmentPriority]
,[EnvironmentIsProduction]
,[ServerInfoIsActive]
,[ProcessDatetime]
FROM [SqlServerInventory].[DetailView].[vwDatabaseProperties]
WHERE ServerInfoIsActive = 1
AND EnvironmentIsProduction = 0
AND DatabaseStatus = 'ONLINE'
AND DatabaseName NOT IN ('tempdb')
AND ServerName NOT IN ('OLY-EDWSQL-01D','OLY-EDWSQL-01D')
AND LastFullDatabaseBackupInDays IS NULL
ORDER BY LastFullDatabaseBackupInDays DESC, EnvironmentPriority
GO
