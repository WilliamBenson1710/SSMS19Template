SELECT 
sp.[ServerName]
,sp.[EnvironmentName]
,sp.[SQLVersionBuild]
,sp.[LogicalCPUCount]
,dft.FileCount
,CASE WHEN sp.[LogicalCPUCount] = dft.FileCount THEN 'No Change'
	WHEN sp.[LogicalCPUCount] > dft.FileCount THEN 'Add Files'
	WHEN sp.[LogicalCPUCount] < dft.FileCount THEN 'Remove Files'
	ELSE NULL
END AS ReviewFiles
FROM [SqlServerInventory].[DetailView].[vwSQLServerProperties] AS sp
LEFT OUTER JOIN (
	SELECT
	[ServerName]
	,COUNT(TypeOfFile) AS FileCount
	FROM [SqlServerInventory].[DetailView].[vwDatabaseFileSizes]
	WHERE ServerInfoIsActive = 1
	AND DatabaseName = 'TempDB'
	AND TypeOfFile = 'ROWS'
	--AND ServerName = 'SQL12'
	GROUP BY ServerName
	--ORDER BY ServerName
) AS dft
ON dft.ServerName = sp.ServerName
WHERE sp.ServerInfoIsActive = 1
AND sp.[LogicalCPUCount] > dft.FileCount
ORDER BY sp.EnvironmentPriority, sp.ServerName