SELECT  
ctg.[Path]  
, s.[Description] SubScriptionDesc  
, sj.[description] AgentJobDesc  
, s.LastStatus  
, s.DeliveryExtension  
, s.[Parameters] 
,CAST(rs.ScheduleID AS sysname) AS SQLJobName
FROM  
ReportServer.dbo.[Catalog] ctg   
INNER JOIN   
ReportServer.dbo.Subscriptions s ON s.Report_OID = ctg.ItemID  
INNER JOIN  
ReportServer.dbo.ReportSchedule rs ON rs.SubscriptionID = s.SubscriptionID  
INNER JOIN  
msdb.dbo.sysjobs sj ON CAST(rs.ScheduleID AS sysname) = sj.name  
--WHERE ctg.Path like '%Application_Caseload_Detail%'  

WHERE s.SubscriptionID IN('b56657f2-96de-4754-b79f-2b9953a7e3ec','f36fb235-dc57-49ab-b538-22c928f7ef69','881ef9f9-a7ea-47be-ab22-92b28d241775','d2ab6826-ee83-4acb-8859-637942db162d','4eb8d4c4-93de-40f6-b2ec-506cc5ecbfdb')
ORDER BY  
rs.ScheduleID; 