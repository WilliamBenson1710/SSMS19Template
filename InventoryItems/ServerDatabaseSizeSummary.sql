USE [SqlServerInventory]
GO



SELECT
svrl.[ServerId]
,svrl.[ServerName]
,svrinfo.EnvironmentDesc
,CONVERT(CHAR(10),dbp.[ExpirationDate], 121) AS [ExpirationDate]
,SUM(dbp.[DataFilesInMB]) AS TotalSizeInMB


FROM Lkup.ServerList AS svrl
INNER JOIN Config.vwServerInformation AS svrinfo
ON svrl.ServerId = svrinfo.ServerId

INNER JOIN [Detail].[DatabaseProperties] FOR SYSTEM_TIME ALL AS dbp
ON svrinfo.ServerId = dbp.ServerId

WHERE svrinfo.[ServerInfoIsActive] = 1
--AND dbp.DatabaseName = 'ARCUSYM000'
AND svrl.ServerName = 'OLY-ARCUSQL-02'
AND dbp.DataFileLocation = 'E:\'

GROUP BY svrl.[ServerId]
,svrl.[ServerName]
,svrinfo.EnvironmentDesc
,CONVERT(CHAR(10),dbp.[ExpirationDate], 121)

ORDER BY CONVERT(CHAR(10),dbp.[ExpirationDate], 121) DESC