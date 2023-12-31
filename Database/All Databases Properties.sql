USE msdb
GO

SELECT
@@SERVERNAME AS ServerName,
database_id AS DatabaseId,
CONVERT(NVARCHAR(128), DB.name) AS DatabaseName,
suser_sname(owner_sid) AS DatabaseOwner,
CONVERT(NVARCHAR(16), DATABASEPROPERTYEX(name, 'status')) AS [DatabaseStatus],
state_desc AS DatabaseStateDesc,
(SELECT COUNT(1) FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'rows') AS DataFiles,
(SELECT physical_name FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'rows') AS DataFileLocation,
(SELECT SUM((size*8)/1024) FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'rows') AS [DataFilesInMB],
(SELECT COUNT(1) FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'log') AS LogFiles,
(SELECT physical_name FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'rows') AS LogFileLocation,
(SELECT SUM((size*8)/1024) FROM sys.master_files WHERE DB_NAME(database_id) = DB.name AND type_desc = 'log') AS [LogFilesInMB],
user_access_desc AS [UserAccess],
recovery_model_desc AS [RecoveryModel],
CONVERT(NVARCHAR(25), CASE [compatibility_level]
    WHEN 60 THEN N'60 (SQL Server 6.0)'
    WHEN 65 THEN N'65 (SQL Server 6.5)'
    WHEN 70 THEN N'70 (SQL Server 7.0)'
    WHEN 80 THEN N'80 (SQL Server 2000)'
    WHEN 90 THEN N'90 (SQL Server 2005)'
    WHEN 100 THEN N'100 (SQL Server 2008)'
    WHEN 110 THEN N'110 (SQL Server 2012)'
    WHEN 120 THEN N'120 (SQL Server 2014)'
    WHEN 130 THEN N'130 (SQL Server 2016)'
    WHEN 140 THEN N'140 (SQL Server 2017)'
    WHEN 150 THEN N'150 (SQL Server 2019)'
END) AS [CompatibilityLevel],
--CONVERT(NVARCHAR(20), create_date, 101) + ' ' + CONVERT(NVARCHAR(20), create_date, 108) AS [CreationDate],
create_date AS CreationDate,
lstFullBackupInfo.LastFullDatabaseBackupInDays,
lstFullBackupInfo.LastFullDatabseBackup,
lstDiffBackupInfo.LastDiffDatabaseBackupInDays,
lstDiffBackupInfo.LastDiffDatabseBackup,
lstTLoghBackupInfo.LastTLogDatabaseBackupInDays,
lstTLoghBackupInfo.LastTLogDatabseBackup,
lstRestoreInfo.[LastDatabaseRestoreInDays],
lstRestoreInfo.[LastDatabseRestore],
lstRestoreInfo.server_name AS [RestoredFromServer],
CASE WHEN is_fulltext_enabled = 1 THEN N'Fulltext enabled' ELSE NULL END AS [Fulltext],
CASE WHEN is_auto_close_on = 1 THEN N'autoclose' ELSE NULL END AS [Autoclose],
page_verify_option_desc AS [PageVerifyOption],
CASE WHEN is_read_only = 1 THEN N'read only' ELSE NULL END AS [ReadOnly],
CASE WHEN is_auto_shrink_on = 1 THEN N'autoshrink' ELSE NULL END AS [Autoshrink],
CASE WHEN is_auto_create_stats_on = 1 THEN N'auto create statistics' ELSE NULL END AS [AutoCreateStatistics],
CASE WHEN is_auto_update_stats_on = 1 THEN N'auto update statistics' ELSE NULL END AS [AutoUpdateStatistics],
CASE WHEN is_in_standby = 1 THEN N'standby' ELSE NULL END AS [Standby],
CASE WHEN is_cleanly_shutdown = 1 THEN N'cleanly shutdown' ELSE '' END AS [CleanlyShutdown] 
FROM sys.databases DB
LEFT OUTER JOIN (
    SELECT TOP 1 WITH TIES
    bk.[database_name]
    ,DATEDIFF(DAY, GETDATE(),Backup_finish_date) AS LastFullDatabaseBackupInDays
    ,CONVERT(NVARCHAR(180),CASE TYPE WHEN 'D' THEN 'Full' WHEN 'I' THEN 'Differential' WHEN 'L' THEN 'Transaction log' END
        + ' � ' + LTRIM(ISNULL(STR(ABS(DATEDIFF(DAY, GETDATE(),Backup_finish_date))) + ' days ago', 'NEVER'))
        + ' � ' + CONVERT(VARCHAR(20), backup_start_date, 101) + ' ' + CONVERT(VARCHAR(20), backup_start_date, 108)
        + ' � ' + CONVERT(VARCHAR(20), backup_finish_date, 101) + ' ' + CONVERT(VARCHAR(20), backup_finish_date, 108)
        + ' (' + CAST(DATEDIFF(second, BK.backup_start_date,BK.backup_finish_date) AS VARCHAR(4)) + ' '+ 'seconds)')
        AS LastFullDatabseBackup
    FROM msdb..backupset BK 
    WHERE bk.is_copy_only = 0
		AND bk.type = 'D'
        AND @@SERVERNAME = bk.server_name
    ORDER BY RANK() OVER(PARTITION BY bk.Database_name ORDER BY backup_finish_Date DESC)
) AS lstFullBackupInfo
    ON DB.[Name] = lstFullBackupInfo.[database_name]
LEFT OUTER JOIN (
    SELECT TOP 1 WITH TIES
    bk.[database_name]
    ,DATEDIFF(DAY, GETDATE(),Backup_finish_date) AS LastDiffDatabaseBackupInDays
    ,CONVERT(NVARCHAR(180),CASE TYPE WHEN 'D' THEN 'Full' WHEN 'I' THEN 'Differential' WHEN 'L' THEN 'Transaction log' END
        + ' � ' + LTRIM(ISNULL(STR(ABS(DATEDIFF(DAY, GETDATE(),Backup_finish_date))) + ' days ago', 'NEVER'))
        + ' � ' + CONVERT(VARCHAR(20), backup_start_date, 101) + ' ' + CONVERT(VARCHAR(20), backup_start_date, 108)
        + ' � ' + CONVERT(VARCHAR(20), backup_finish_date, 101) + ' ' + CONVERT(VARCHAR(20), backup_finish_date, 108)
        + ' (' + CAST(DATEDIFF(second, BK.backup_start_date,BK.backup_finish_date) AS VARCHAR(4)) + ' '+ 'seconds)')
        AS LastDiffDatabseBackup
    FROM msdb..backupset BK 
    WHERE bk.is_copy_only = 0
		AND bk.type = 'I'
        AND @@SERVERNAME = bk.server_name
    ORDER BY RANK() OVER(PARTITION BY bk.Database_name ORDER BY backup_finish_Date DESC)
) AS lstDiffBackupInfo
    ON DB.[Name] = lstDiffBackupInfo.[database_name]
LEFT OUTER JOIN (
    SELECT TOP 1 WITH TIES
    bk.[database_name]
    ,DATEDIFF(DAY, GETDATE(),Backup_finish_date) AS LastTLogDatabaseBackupInDays
    ,CONVERT(NVARCHAR(180),CASE TYPE WHEN 'D' THEN 'Full' WHEN 'I' THEN 'Differential' WHEN 'L' THEN 'Transaction log' END
        + ' � ' + LTRIM(ISNULL(STR(ABS(DATEDIFF(DAY, GETDATE(),Backup_finish_date))) + ' days ago', 'NEVER'))
        + ' � ' + CONVERT(VARCHAR(20), backup_start_date, 101) + ' ' + CONVERT(VARCHAR(20), backup_start_date, 108)
        + ' � ' + CONVERT(VARCHAR(20), backup_finish_date, 101) + ' ' + CONVERT(VARCHAR(20), backup_finish_date, 108)
        + ' (' + CAST(DATEDIFF(second, BK.backup_start_date,BK.backup_finish_date) AS VARCHAR(4)) + ' '+ 'seconds)')
        AS LastTLogDatabseBackup
    FROM msdb..backupset BK 
    WHERE bk.is_copy_only = 0
		AND bk.type = 'L'
        AND @@SERVERNAME = bk.server_name
    ORDER BY RANK() OVER(PARTITION BY bk.Database_name ORDER BY backup_finish_Date DESC)
) AS lstTLoghBackupInfo
    ON DB.[Name] = lstTLoghBackupInfo.[database_name]
LEFT OUTER JOIN (
    SELECT TOP 1 WITH TIES
    rh.destination_database_name
    ,bks.server_name
    ,DATEDIFF(DAY, GETDATE(),rh.restore_date) AS [LastDatabaseRestoreInDays]
    ,CONVERT(NVARCHAR(180),'Restored - ' + LTRIM(ISNULL(STR(ABS(DATEDIFF(DAY, GETDATE(),rh.restore_date))) + ' days ago', 'NEVER'))
        + ' � ' + CONVERT(VARCHAR(20), rh.restore_date, 101)
        + ' ' + CONVERT(VARCHAR(20), rh.restore_date, 108) 
        + ' � ' + CONVERT(VARCHAR(20), rh.restore_date, 101)
        + ' ' + CONVERT(VARCHAR(20), restore_date, 108)) AS [LastDatabseRestore]
    FROM msdb..restorehistory AS rh
    INNER JOIN msdb.dbo.backupset AS bks
        ON bks.backup_set_id = rh.backup_set_id 
    --WHERE bk.is_copy_only = 0
        --AND @@SERVERNAME <> bk.server_name
    ORDER BY RANK() OVER(PARTITION BY rh.destination_database_name ORDER BY rh.restore_date DESC)
) AS lstRestoreInfo
    ON DB.[Name] = lstRestoreInfo.destination_database_name
WHERE DB.name NOT IN ('tempdb')
--ORDER BY db.[name]
