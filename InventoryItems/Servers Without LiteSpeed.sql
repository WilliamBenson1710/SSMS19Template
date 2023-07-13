WITH cteLiteSpeedServers
AS (
SELECT DISTINCT
jobs.[ServerName]

FROM [SqlServerInventory].[Detail].[SQLServerAgentJobs] AS jobs
INNER JOIN Config.vwServerInformation AS Svrinfo
ON Svrinfo.ServerId = jobs.ServerId
AND Svrinfo.ServerInfoIsActive = 1
WHERE CHARINDEX('LiteSpeed', jobs.SQLAgentJobName) > 0
)
SELECT
Svrinfo.EnvironmentName
, Svrinfo.ServerName
FROM Config.vwServerInformation AS Svrinfo

LEFT OUTER JOIN cteLiteSpeedServers AS ctel
ON Svrinfo.ServerName = ctel.ServerName

WHERE  Svrinfo.ServerInfoIsActive = 1
	AND ctel.ServerName IS NULL
	AND CHARINDEX('DBPSQL',Svrinfo.ServerName) = 0
ORDER BY Svrinfo.EnvironmentPriority, Svrinfo.ServerName