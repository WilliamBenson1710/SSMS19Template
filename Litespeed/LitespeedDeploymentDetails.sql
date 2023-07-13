
SELECT TOP (1000)
--ltd.[DeploymentID]
      UPPER(ltd.[ServerName]) AS ServerName
      ,ltd.[DeploymentDate]
      --,ltd.[TemplateID]
      ,ltd.[TemplateRevision]
      ,ltd.[DeploymentUser]
	  ,lst.TemplateName
     -- ,[MaintenancePlanID]
     -- ,[MaintenancePlanName]
      --,ltd.[BackupJobID]
      ,ltd.[BackupJobName]
      --,ltd.[TLogJobID]
      ,ltd.[TLogJobName]
      --,ltd.[DiffJobID]
      ,ltd.[DiffJobName]
      ,ltd.[DeploymentPath]
      ,ltd.[NotifyOperator]
      ,ltd.[IsDeleted]
      ,ltd.[Databases]
      ,ltd.[ScheduledTime]
      ,ltd.[DateDeleted]
      ,ltd.[UserDeleted]
      ,ltd.[Alias]
      ,ltd.[TLogBackupPath]
      ,ltd.[UseTLogBackupPath]
      ,ltd.[DiffBackupPath]
      ,ltd.[UseDiffBackupPath]
      ,ltd.[ExcludeDatabases]
      ,ltd.[Owner]
      ,ltd.[TSMSettings]
  FROM [LiteSpeedCentral].[dbo].[LitespeedTemplateDeployments] AS ltd
  INNER JOIN (SELECT [ServerName] ,MAX([DeploymentID]) AS [DeploymentID] FROM [LiteSpeedCentral].[dbo].[LitespeedTemplateDeployments] /*WHERE IsDeleted = 0*/ GROUP BY [ServerName]) AS maxdply
  ON maxdply.DeploymentID = ltd.DeploymentID
  AND maxdply.ServerName = ltd.ServerName
  LEFT OUTER JOIN [LiteSpeedCentral].[dbo].[LiteSpeedTemplates] AS lst
  ON lst.TemplateID = ltd.TemplateID
  AND lst.TemplateRevision = ltd.TemplateRevision
  --WHERE ltd.[ServerName] IN ('OLY-SSISSQL-02','OLY-MGSQL-01','OLY-BPSQL-01')
  WHERE ltd.DeploymentUser = 'WSECU\adminwillb'
  --ORDER BY ltd.[DeploymentDate] DESC
  ORDER BY lst.TemplateName