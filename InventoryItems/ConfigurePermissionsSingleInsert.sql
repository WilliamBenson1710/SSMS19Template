USE [DBAUtility]
GO

INSERT INTO [Config].[UserDatabasePermissions]
([DatabaseName]
,[UserCredentials]
,[DatabaseRoleName]
,[ServerName])
VALUES
('access_control'
,'dbpsqluser'
,'rlDBPApplicationUser'
,@@SERVERNAME
)
--,
--('action_service'
--,'dbpsqluser'
--,'rlDBPApplicationUser'
--,@@SERVERNAME
--)	

GO


