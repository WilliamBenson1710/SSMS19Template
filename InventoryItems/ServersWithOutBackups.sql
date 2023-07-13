SELECT DISTINCT
COALESCE([ServerAlias],[ServerName]) AS ServerName
,[EnvironmentDesc]
FROM [SqlServerInventory].[DetailView].[vwDatabaseProperties]
WHERE ServerInfoIsActive = 1
AND EnvironmentIsProduction = 0
AND DatabaseStatus = 'ONLINE'
AND DatabaseName NOT IN ('tempdb')
AND ServerName NOT IN ('OLY-EDWSQL-01D','OLY-EDWSQL-01D')
AND LastFullDatabaseBackupInDays IS NULL
ORDER BY ServerName