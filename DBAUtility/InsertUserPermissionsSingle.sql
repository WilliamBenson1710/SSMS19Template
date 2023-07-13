USE [DBAUtility]
GO

DECLARE @UserCredentials NVARCHAR(100) = ''
,@DatabaseRoleName NVARCHAR(100) = ''
,@IsFixedRole BIT = 0
,@ViewDefinition BIT = 1
,@WithExcute BIT = 1
,@ServerNameToUse sysname = @@SERVERNAME
;

INSERT INTO [Config].[UserDatabasePermissions]
([DatabaseName]
,[UserCredentials]
,[DatabaseRoleName]
,[IsFixedRole]
,[ViewDefinition]
,[WithExcute]
,[ServerName])
VALUES
(''
, @UserCredentials
, @DatabaseRoleName
, @IsFixedRole
, @ViewDefinition
, @WithExcute
, @ServerNameToUse
)