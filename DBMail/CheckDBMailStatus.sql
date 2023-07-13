SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END FROM msdb.dbo.sysmail_account WHERE [name] = 'SQL Jobs Alerts'
SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END FROM msdb.dbo.sysmail_profile WHERE [name] = 'SQL Job Alerts'

EXECUTE master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE'
 ,N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent'
 ,N'UseDatabaseMail'

EXECUTE master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE'
,N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent'
,N'DatabaseMailProfile'