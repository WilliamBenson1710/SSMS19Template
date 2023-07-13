--:CONNECT OLY-ARCUSQL-02
--GO

USE [arcu]
GO

SELECT TOP (1000) [JobHistoryID]
      ,[QueuedDateTime]
      ,[ProcessDate]
      --,[job_id]
      ,[JobName]
      ,[StepID]
      ,[last_StepID]
      ,[QueuedUser]
      ,[AutomaticSubmission]
      ,[start_execution_date]
      ,[stop_execution_date]
		,rs.RunStatusDescription
      ,[LastUpdated]
      ,[RetryAttempts]
  FROM [arcu].[SSIS].[QueuedJobs] AS qj
  INNER JOIN [SSIS].[RunStatus] AS rs
  ON rs.RunStatusID = qj.RunStatusID
  WHERE ProcessDate >= '20220923'
  ORDER BY ProcessDate DESC
GO