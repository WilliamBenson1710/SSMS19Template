USE SqlServerInventory
GO

SELECT
[EnvironmentName]
,[ServerName]
,[DatabaseId]
,[DatabaseName]
,[TypeOfFile]
,[PhysicalDriveLetter]
,[SizeCheckDatetime]
,SUM([FileSizeMB]) AS [FileSizeMB]
,SUM([SpaceUsedMB]) AS [SpaceUsedMB]
,SUM([FreeSpaceMB]) AS [FreeSpaceMB]
FROM [DetailView].[vwDatabaseFileSizes]
WHERE [ServerInfoIsActive] = 1
AND [TypeOfFile] = 'ROWS'
--AND [DatabaseName] = 'TempDB'
--AND [PhysicalDriveLetter] <> 'T'
--AND [EnvironmentIsProduction] = 0
GROUP BY [EnvironmentName]
,[ServerName]
,[DatabaseId]
,[DatabaseName]
,[TypeOfFile]
,[PhysicalDriveLetter]
,[SizeCheckDatetime]
ORDER BY [EnvironmentName]
,[ServerName]
,[DatabaseId]
,[DatabaseName]
,[TypeOfFile]
,[PhysicalDriveLetter]
,[SizeCheckDatetime]
