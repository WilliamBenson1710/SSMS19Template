
SELECT TOP (1000) [ID]
      ,[DatabaseName]
      ,[SchemaName]
      ,[ObjectName]
      ,[ObjectType]
      ,[IndexName]
      ,[IndexType]
      ,[StatisticsName]
      ,[PartitionNumber]
      ,[ExtendedInfo]
      ,[Command]
      ,[CommandType]
      ,[StartTime]
      ,[EndTime]
	  ,DATEDIFF(MINUTE,[StartTime],[EndTime]) AS DurMin
      ,[ErrorNumber]
      ,[ErrorMessage]
  FROM [DBAUtility].[dbo].[CommandLog]
  WHERE StartTime >= '2022-06-13'
  AND StartTime < '2022-06-14'
  --WHERE IndexName = 'uq_external_id'
  AND CommandType IN ('ALTER_INDEX','UPDATE_STATISTICS')
 -- AND CommandType NOT IN ('BACKUP_LOG','xp_create_subdir','BACKUP_DATABASE')
  ORDER BY EndTime DESC
  --ORDER BY DATEDIFF(MINUTE,[StartTime],[EndTime]) DESC
