:CONNECT SQL3T
GO

USE msdb
GO

--================================================================
-- DATABASE MAIL CONFIGURATION
--================================================================
DECLARE @ServerName AS sysname
,@DBMailProfileName AS NVARCHAR(100)
,@DBMailAccountName AS sysname =  'SQL Jobs Alerts'
,@DBMailDescription AS nvarchar(256) = 'Automation alerts'
,@DBMailEmailAddress AS nvarchar(128) = '_DBAAlerts@wsecu.org'
,@DBMailReplytoAddress AS nvarchar(128) = '_DBAAlerts@wsecu.org'
,@DBMailDisplayName AS nvarchar(128) = 'SQL Job Alerts'
,@DBMailMailserverName AS sysname = 'outlook.wsecu.net'
,@DBMailPort AS int = 25
;

SELECT @ServerName = @@SERVERNAME
,@DBMailProfileName = 'SQL Job Alerts'

--==========================================================
-- Create a Database Mail account
--==========================================================
EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = @DBMailAccountName,
    @description = @DBMailDescription,
    @email_address = @DBMailEmailAddress,
    @replyto_address = @DBMailReplytoAddress,
    @display_name = @DBMailDisplayName,
    @mailserver_name = @DBMailMailserverName,
	@port = @DBMailPort
	;

--==========================================================
-- Create a Database Mail Profile
--==========================================================
DECLARE @profile_id INT, @profile_description sysname;
SELECT @profile_id = COALESCE(MAX(profile_id),1) FROM msdb.dbo.sysmail_profile
SELECT @profile_description = 'Database Mail Profile for ' + @ServerName 


EXECUTE msdb.dbo.sysmail_add_profile_sp
    @profile_name = @DBMailProfileName,
    @description = @profile_description;

-- Add the account to the profile
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = @DBMailProfileName,
    @account_name = @DBMailAccountName,
    @sequence_number = @profile_id;

-- Grant access to the profile to the DBMailUsers role
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = @DBMailProfileName,
    @principal_id = 0,
    @is_default = 1 ;


--==========================================================
-- Enable Database Mail
--==========================================================
USE master;
GO

sp_CONFIGURE 'show advanced', 1
GO
RECONFIGURE
GO
sp_CONFIGURE 'Database Mail XPs', 1
GO
RECONFIGURE
GO

--EXEC master.dbo.xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'DatabaseMailProfile', N'REG_SZ', N''
--EXEC master.dbo.xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'UseDatabaseMail', N'REG_DWORD', 1
--GO

EXEC msdb.dbo.sp_set_sqlagent_properties @email_save_in_sent_folder = 0
GO


--==========================================================
-- Review Outcomes
--==========================================================
SELECT * FROM msdb.dbo.sysmail_profile;
SELECT * FROM msdb.dbo.sysmail_account;
GO

--================================================================
-- SQL Agent Properties Configuration
--================================================================
DECLARE @databasemail_profile AS NVARCHAR(128)

SELECT @databasemail_profile = sysmp.[Name]
FROM msdb.dbo.sysmail_principalprofile AS sysmpp
INNER JOIN msdb.dbo.sysmail_profile AS sysmp
ON sysmpp.profile_id = sysmp.profile_id
WHERE sysmpp.is_default = 1

EXEC msdb.dbo.sp_set_sqlagent_properties 
	@databasemail_profile = @databasemail_profile
	, @use_databasemail=1
GO

--==========================================================
-- Test Database Mail
--==========================================================
DECLARE @sub VARCHAR(100)
DECLARE @body_text NVARCHAR(MAX)
DECLARE @profile_name AS NVARCHAR(100)
DECLARE @recipients AS NVARCHAR(100)
SELECT @recipients = 'WBenson@wsecu.org'
SELECT @sub = 'Test from New SQL install on ' + @@servername
SELECT @body_text = N'This is a test of Database Mail.' + CHAR(13) + CHAR(13) + 'SQL Server Version Info: ' + CAST(@@version AS VARCHAR(500))

SELECT @profile_name = sysmp.[Name]
FROM msdb.dbo.sysmail_principalprofile AS sysmpp
INNER JOIN msdb.dbo.sysmail_profile AS sysmp
ON sysmpp.profile_id = sysmp.profile_id
WHERE sysmpp.is_default = 1

EXEC msdb.dbo.[sp_send_dbmail] 
    @profile_name = @profile_name
  , @recipients = @recipients
  , @subject = @sub
  , @body = @body_text

  GO