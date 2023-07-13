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