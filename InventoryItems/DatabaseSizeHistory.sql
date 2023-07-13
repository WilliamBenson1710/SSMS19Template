--:CONNECT OLY-DBASQL-01
--GO

USE [SqlServerInventory]
GO

DECLARE @ServerName NVARCHAR(250) = 'OLY-DBPSQL-02'
, @DatabaseName NVARCHAR(250) = 'bb-dbs'
;

SELECT
[ServerId]
,[ServerName]
,[DatabaseName]
--,[DatabaseOwner]
--,[DatabaseStatus]
--,[DatabaseStateDesc]
,CONVERT(DATE,[ProcessDatetime])  AS [ProcessDate]
,CAST(SUM(CAST([DataFilesInMB] AS FLOAT) + CAST([LogFilesInMB] AS FLOAT)) / 1024 AS DECIMAL(10,2)) AS [TotalSizeInGB]
,CAST(SUM(CAST([DataFilesInMB] AS FLOAT)) / 1024 AS DECIMAL(10,2)) AS [DataFilesInGB]
,CAST(SUM(CAST([LogFilesInMB] AS FLOAT)) / 1024 AS DECIMAL(10,2)) AS [LogFilesInGB]
--,[DataFilesInMB]
--,[LogFilesInMB]
--,[InsertDatetime]
--,[EffecitveDate]
--,[ExpirationDate]
FROM [Detail].[DatabaseProperties]
WHERE ServerName = @ServerName
AND Databasename = @DatabaseName
GROUP BY [ServerId]
,[ServerName]
,[DatabaseName]
,CONVERT(DATE,[ProcessDatetime]) 
;

SELECT
[ServerId]
,[ServerName]
,[DatabaseName]
--,[DatabaseOwner]
--,[DatabaseStatus]
--,[DatabaseStateDesc]
,CONVERT(DATE,[ProcessDatetime])  AS [ProcessDate]
,CAST(SUM(cast([DataFilesInMB] as float) + CAST([LogFilesInMB] as float)) / 1024 AS DECIMAL(10,2)) AS [TotalSizeInGB]
,CAST(SUM(cast([DataFilesInMB] as float)) / 1024 AS DECIMAL(10,2)) AS [DataFilesInGB]
,CAST(SUM(cast([LogFilesInMB] as float)) / 1024 AS DECIMAL(10,2)) AS [LogFilesInGB]
--,[DataFilesInMB]
--,[LogFilesInMB]
--,[InsertDatetime]
--,[EffecitveDate]
--,[ExpirationDate]
FROM [Detail].[DatabasePropertiesHisotry]
WHERE ServerName = @ServerName
AND Databasename = @DatabaseName
GROUP BY [ServerId]
,[ServerName]
,[DatabaseName]
,CONVERT(DATE,[ProcessDatetime]) 
ORDER BY CONVERT(DATE,[ProcessDatetime])  DESC
GO