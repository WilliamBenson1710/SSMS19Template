/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
[ServerName]
,[DatabaseName]
,[ProcessDatetime]
,SUM([RowCounts]) AS CurrentRowCounts
,SUM([PreviousRowCounts]) AS [PreviousRowCounts]
,SUM([ChangeInRowCounts]) AS [ChangeInRowCounts]
FROM [SqlServerInventory].[DetailView].[vwDatabaseTableSizes]
WHERE ServerName = 'OLY-EDHSQL-01'
AND DatabaseName = 'BB-DBS_BAK'

GROUP BY [ServerName]
,[DatabaseName]
,[ProcessDatetime]

ORDER BY [ProcessDatetime] DESC ,[ServerName]
,[DatabaseName]
