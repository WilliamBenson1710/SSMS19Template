--:CONNECT OYL-DBASQL-01
--GO

USE SqlServerInventory
GO

DECLARE @SourceServerName NVARCHAR(500) = 'OLY-DBPSQL-03T'
--, @SourceDatabaseName NVARCHAR(500) = 'bb-dbs'
--, @DestinationServerName NVARCHAR(500) = 'OLY-DBPSQL-02H'
, @DestinationServerName NVARCHAR(500) = 'OLY-DBPSQL-03D'
;

SELECT 
srcTables.[ServerName]
,srcTables.[DatabaseName]
,srcTables.[SchemaName] + '.' + srcTables.[TableName] AS ObjectName
,srcTables.RowCounts AS SourceObjectRowCounts
,DestMovedTables.ServerName AS MovedToServerName
,DestMovedTables.[DatabaseName] AS MovedDatabseName
,DestMovedTables.ObjectName AS MovedDestObjectName
,DestMovedTables.RowCounts AS MovedTableRowCounts
,CASE WHEN srcTables.RowCounts = DestMovedTables.RowCounts THEN 1
	ELSE 0
END AS RowCountsMatch
FROM [Detail].[DatabaseTableSizes] AS srcTables
--[DetailView].[vwDatabaseTableSizes] AS srcTables
LEFT OUTER JOIN (
	SELECT 
	[ServerName]
	,[DatabaseName]
	,[SchemaName]
	,[TableName]
	,[SchemaName] + '.' + [TableName] AS ObjectName
	,[RowCounts]
	FROM [Detail].[DatabaseTableSizes] --[DetailView].[vwDatabaseTableSizes]
	WHERE [ServerName] = @DestinationServerName
	AND [DatabaseName] NOT IN ('bb-dbs','bb-dbsDEV','DBPDeployFail','bb-dbs2_21')
	--AND ExpirationDate = '9999-12-31 23:59:59.9999'
) AS DestMovedTables
ON srcTables.DatabaseName = DestMovedTables.DatabaseName
AND srcTables.SchemaName = DestMovedTables.SchemaName
AND srcTables.TableName = DestMovedTables.TableName

--WHERE srcTables.ProcessDatetime > ='2022-04-05'
WHERE srcTables.[ServerName] = @SourceServerName
AND srcTables.DatabaseName NOT IN ('msdb','model','master','tempdb')
--AND srcTables.ExpirationDate = '9999-12-31 23:59:59.9999'
--AND srcTables.DatabaseName = 'arrangement_manager'
--AND srcTables.[DatabaseName] = DestMovedTables.DatabaseName
--AND srcTables.SchemaName = 'WSECU'



ORDER BY srcTables.[DatabaseName],srcTables.[SchemaName],srcTables.[TableName]
;