USE msdb
GO

SELECT
@@ServerName AS ServerName
,ja.session_id AS SessionId
,ja.job_id AS JobId
,ja.start_execution_date AS StartExecutionDate   
FROM msdb.dbo.sysjobactivity AS ja
INNER JOIN msdb.dbo.sysjobs AS jb
ON ja.job_id = jb.job_id
WHERE ja.session_id = (SELECT TOP 1 session_id FROM msdb.dbo.syssessions ORDER BY agent_start_date DESC)
AND ja.start_execution_date is not null
AND ja.stop_execution_date is NULL