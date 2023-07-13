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