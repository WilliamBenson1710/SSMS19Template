SELECT
--bkups.backup_set_id,
--bkups.media_set_id,
bkups.[database_name],
bkups.[name] AS [backup_name],
bkups.[description] AS [backup_description],
bkups.backup_size,
bkups.is_copy_only,
bkups.backup_start_date,
bkups.backup_finish_date,
bkups.server_name, 
bkups.[user_name],
--bkups.[type],
CASE bkups.[type] 
	WHEN 'D' THEN 'Database' 
	WHEN 'L' THEN 'Log'
	WHEN 'I' THEN 'Differential'
	END AS [backup_type], 
--bkupmed.physical_device_name,
--bkups.first_lsn,
--bkups.last_lsn,
--bkups.first_family_number,
--bkups.last_family_number,
--bkups.first_media_number,
--bkups.last_media_number,
bkups.database_backup_lsn
--, rh.restore_history_id
,bkupmed.[physical_device_name]
FROM msdb.dbo.backupset AS bkups
INNER JOIN msdb.dbo.backupmediafamily AS bkupmed
ON bkups.media_set_id = bkupmed.media_set_id
LEFT OUTER JOIN [msdb].[dbo].[restorehistory] AS rh /* if we have a matching record in the table then its a restore not a backup */
	ON bkups.[backup_set_id] = rh.[backup_set_id]
WHERE rh.restore_history_id IS NULL
ORDER BY bkups.backup_finish_date DESC

/*
SELECT
bkups.[database_name]
,bkups.[name]
,bkups.[description]
,bkups.[is_copy_only]
,bkups.[backup_start_date]
,bkups.[backup_finish_date]
,bkups.[server_name]
,bkups.[user_name]
,CASE bkups.[type] WHEN 'D' THEN 'Database'
	WHEN 'L' THEN 'Log'
	WHEN 'I' THEN 'Differential'
    WHEN 'F' THEN 'File or filegroup'
    WHEN 'G' THEN 'Differential file'
    WHEN 'P' THEN 'Partial'
    WHEN 'Q' THEN 'Differential partial' 
	ELSE NULL
END AS backup_type
,bkupmed.[physical_device_name]
FROM [msdb].[dbo].[backupset] AS bkups
INNER JOIN [msdb].[dbo].[backupmediafamily] AS bkupmed
	ON bkups.[media_set_id] = bkupmed.[media_set_id]
LEFT OUTER JOIN [msdb].[dbo].[restorehistory] AS rh /* if we have a matching record in the table then its a restore not a backup */
	ON bkups.[backup_set_id] = rh.[backup_set_id]
WHERE bkups.[backup_start_date] >= DATEADD(MONTH, -1, SYSDATETIME())
	AND rh.[restore_history_id] IS NULL /* This removed it from being a restore and showing in the data */
	--AND bkups.database_name = 'msdb'
	--AND bkups.type = 'D'
ORDER BY bkups.backup_start_date DESC;
*/