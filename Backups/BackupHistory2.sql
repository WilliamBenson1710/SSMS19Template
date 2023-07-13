-- MSDB Backup history
SELECT /* Columns for retrieving information */
       -- CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS SRVNAME, 
       msdb.dbo.backupset.database_name,
       msdb.dbo.backupset.backup_start_date,
       msdb.dbo.backupset.backup_finish_date,
       -- msdb.dbo.backupset.expiration_date,
 
       CASE msdb.dbo.backupset.type
            WHEN 'D' THEN 'Full'
            WHEN 'I' THEN 'Diff'
            WHEN 'L' THEN 'Log'
       END  AS backup_type,
       -- msdb.dbo.backupset.backup_size / 1024 / 1024 as [backup_size MB],  
       msdb.dbo.backupmediafamily.logical_device_name,
       msdb.dbo.backupmediafamily.physical_device_name,
       -- msdb.dbo.backupset.name AS backupset_name,
       -- msdb.dbo.backupset.description,
       msdb.dbo.backupset.is_copy_only,
       msdb.dbo.backupset.is_snapshot,
       msdb.dbo.backupset.checkpoint_lsn,
       msdb.dbo.backupset.database_backup_lsn,
       msdb.dbo.backupset.differential_base_lsn,
       msdb.dbo.backupset.first_lsn,
       msdb.dbo.backupset.fork_point_lsn,
       msdb.dbo.backupset.last_lsn
FROM   msdb.dbo.backupmediafamily
       INNER JOIN msdb.dbo.backupset
            ON  msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id
--WHERE 
--    msdb.dbo.backupset.database_name = 'MondayTestLiteSpeed2'
Order by 
msdb.dbo.backupset.backup_finish_date DESC

