:CONNECT OLY-DBASQL-01
GO

USE SqlServerInventory
GO

;WITH cteTempFileCount 
AS (
	SELECT
	[ServerId]
	,[ServerName]
	,COUNT(DISTINCT ([PhysicalName])) AS TempDBFileCount
	FROM [Detail].[DatabaseFileSizes]
	WHERE [TypeOfFile] = 'ROWS'
	AND DatabaseName = 'tempdb'
	GROUP BY [ServerId]
	,[ServerName]
	--ORDER BY [ServerId]
	--,[ServerName]
)
SELECT 
svrp.[ServerId]
,svrp.[ServerName]
,svrp.[SQLVersionBuild]
,svrp.[CostThresholdForParallelism]
,svrp.[MaxDegreeOfParallelism]
,svrp.[LogicalCPUCount]
,tmpct.TempDBFileCount
--,svrp.[EnvironmentName]
--,svrp.[ServerAlias]
FROM [DetailView].[vwSQLServerProperties] AS svrp

LEFT OUTER JOIN cteTempFileCount AS tmpct
ON svrp.ServerName = tmpct.ServerName

WHERE svrp.[ServerInfoIsActive] = 1