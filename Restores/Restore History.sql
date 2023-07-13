SELECT
@@ServerName AS ServerName
,bs.[server_name] AS SourceServerName
,CASE WHEN rh.[restore_type] = 'D' THEN 'Database'
	WHEN rh.[restore_type] = 'F' THEN 'File'
	WHEN rh.[restore_type] = 'I' THEN 'Differential'
	WHEN rh.[restore_type] = 'L' THEN 'Log'
	ELSE rh.[restore_type] 
END AS [RestoreType]
,rh.[restore_date] AS [RestoreDate]
,bmf.[physical_device_name] AS [SourcePath]
,rf.[destination_phys_name] AS [RestoreFile]
,rh.[user_name] AS [RestoredBy]
FROM [msdb].[dbo].[restorehistory] AS rh
INNER JOIN [msdb].[dbo].[backupset] AS bs
	ON rh.[backup_set_id] = bs.[backup_set_id]
INNER JOIN [msdb].[dbo].[restorefile] AS rf 
	ON rh.[restore_history_id] = rf.[restore_history_id]
INNER JOIN [msdb].[dbo].[backupmediafamily] AS bmf
	ON bmf.[media_set_id] = bs.[media_set_id]
--WHERE  rh.[destination_database_name] = 'msdb'
ORDER BY rh.[restore_history_id] DESC