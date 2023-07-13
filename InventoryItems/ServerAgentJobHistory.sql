USE SqlServerInventory
GO

SELECT
--saa.[AgentHistoryRecordId]
svrinfo.EnvironmentName
,saa.[ServerName]
,saa.[JobName]
,saa.[JobGuid]
,saa.[StepId]
,saa.[StepName]
,saa.[JobRunDatetime]
--,saa.[NextRunDatetime]
,saa.[StepDuration]
,saa.[RunStatus]
,saa.[ExecutionStatus]
,saa.[JobIsRunning]
,saa.[JobActivityExecutionDate]
,saa.[RetriesAttempted]
,saa.[SQLSeverity]
,saa.[SQLMessageId]
,saa.[InstanceId]
,saa.[JobIsEnabled]
,saa.[JobHistoryMessage]
--,saa.[RecordHash]
,saa.[ProcessDatetime]
--,saa.[InsertDatetime]
--,saa.[EffecitveDate]
--,saa.[ExpirationDate]
,saa.[ServerId]
,svrinfo.EnvironmentPriority 
,svrinfo.EnvironmentIsProduction
FROM [Detail].[SQLServerAgentActivity] AS saa

INNER JOIN (
	SELECT [ServerId],[JobGuid], MAX([InstanceId]) AS InstanceId FROM [Detail].[SQLServerAgentActivity] WHERE [StepId] = 0 GROUP BY [ServerId],[JobGuid]
) AS ssa1
ON ssa1.ServerId = saa.ServerId
	AND ssa1.JobGuid = saa.JobGuid
	AND ssa1.InstanceId = saa.InstanceId

INNER JOIN [Config].[vwServerInformation] AS svrinfo
ON saa.ServerId = svrinfo.ServerId
AND svrinfo.ServerInfoIsActive = 1

WHERE saa.StepId = 0
AND saa.JobRunDateTime >= DATEADD(HOUR, -93,SYSDATETIME())
AND saa.[RunStatus] = 0
AND saa.[JobIsEnabled] = 1

ORDER BY svrinfo.EnvironmentPriority 
GO


