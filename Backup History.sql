SELECT
    bkups.[database_name],
	bkups.[name],
	bkups.[description],
	bkups.is_copy_only,
    bkups.backup_start_date,
    bkups.backup_finish_date,
    bkups.server_name, 
    bkups.[user_name],
CASE bkups.[type] 
      WHEN 'D' THEN 'Database' 
      WHEN 'L' THEN 'Log' 
      END AS backup_type, 
    bkupmed.physical_device_name
FROM msdb.dbo.backupset AS bkups
INNER JOIN msdb.dbo.backupmediafamily AS bkupmed
ON bkups.media_set_id = bkupmed.media_set_id

WHERE bkups.backup_start_date >= DATEADD(MONTH, -1,SYSDATETIME())
AND bkups.type = 'D'
--AND bkups.database_name = 'FICS'

ORDER BY bkups.backup_start_date DESC