SELECT TOP (1000) [RecordId]
      ,[DatabaseName]
      ,[UserCredentials]
      ,[DatabaseRoleName]
      ,[IsFixedRole]
      ,[WithExcute]
      ,[ViewDefinition]
      ,[IsActive]
      ,[ServerName]
      ,[LastUpdatedDatetime]
      ,[LastAssignedDatetime]
      ,[Comments]
  FROM [DBAUtility].[Config].[UserDatabasePermissions]
  WHERE IsActive = 1
  --AND UserCredentials = 'WSECU\OLY-DBPSQL-04T-backbase-Read'
  --AND UserCredentials = 'WSECU\OLY-DBPSQL-04T-DBP-AllDBs-Read'

  --AND UserCredentials = 'WSECU\OLY-DBPSQL-04T-DBP-AllDBs-Change'  
  AND UserCredentials = 'WSECU\OLY-DBPSQL-04T-backbase-Change'
  ORDER BY UserCredentials, DatabaseName, DatabaseRoleName


  --UPDATE [DBAUtility].[Config].[UserDatabasePermissions]
  --SET IsFixedRole = 0
  --, WithExcute = 0
  --, ViewDefinition = 1
  --WHERE UserCredentials = 'WSECU\OLY-DBPSQL-04T-backbase-Change'

--DELETE FROM [DBAUtility].[Config].[UserDatabasePermissions]
--WHERE RecordId = 80
