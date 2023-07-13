SELECT
[EnvironmentName]
,[ServerName]
,[DatabaseName]
,SUM([FileSize]) AS [FileSize]
,SUM([FileSizeMB]) AS [FileSizeMB]
,SUM([SpaceUsedMB]) AS [SpaceUsedMB]
,SUM([FreeSpaceMB]) AS [FreeSpaceMB]
FROM [SqlServerInventory].[DetailView].[vwDatabaseFileSizes]
WHERE ServerName = 'OLY-EDWSQL-01'
AND [ServerInfoIsActive] = 1
AND [TypeOfFile] = 'ROWS'
--ORDER BY [FileSizeMB] DESC

GROUP BY [EnvironmentName]
,[ServerName]
,[DatabaseName]
ORDER BY SUM([FileSize]) DESC