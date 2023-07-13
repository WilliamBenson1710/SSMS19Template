SELECT
jobs.[AgentJobRecordId]
--,jobs.[ServerId]
,jobs.[ServerName]
--,jobs.[SQLAgentJobId]
,jobs.[SQLAgentJobName]
,jobs.[SQLAgentJobOwner]
,jobs.[JobDescription]
,jobs.[SQLAgentJobCreateDatetime]
,jobs.[SQLAgnetJobLastModifiedDatetime]
,jobs.[SQLAgentJobIsEnabled]
,jobs.[SQLAgentJobCategoryName]
,jobs.[RecordHash]
,jobs.[ProcessDatetime]
,jobs.[InsertDatetime]
,jobs.[EffecitveDate]
,jobs.[ExpirationDate]
FROM [SqlServerInventory].[Detail].[SQLServerAgentJobs] AS jobs
INNER JOIN Config.vwServerInformation AS Svrinfo
ON Svrinfo.ServerId = jobs.ServerId
AND Svrinfo.ServerInfoIsActive = 1
WHERE jobs.SQLAgentJobOwner NOT IN ('sa','NT SERVICE\SQLServerReportingServices','WSECU\gvcARCUSQL$')
--WHERE jobs.SQLAgentJobOwner = 'WSECU\adminjoe' --'WSECU\AdminPiotr'

--WHERE CHARINDEX('WSECU\admin',jobs.SQLAgentJobOwner) > 0
--AND jobs.SQLAgentJobOwner NOT IN ('WSECU\adminhoward','WSECU\AdminZap','WSECU\adminseanb','WSECU\adminwillb')

ORDER BY jobs.ServerName, jobs.SQLAgentJobName