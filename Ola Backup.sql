EXEC [dbo].[DatabaseBackup]
@Databases = 'ALL_DATABASES'
,@Directory = '\\wsecu.int\apps\SQL\sql_backup'
,@BackupType = 'FULL'
--,@NumberOfFiles = 1
,@Compress = 'Y'
,@DirectoryStructure = '{ServerName}{DirectorySeparator}{DatabaseName}{DirectorySeparator}FULL_{Partial}_{CopyOnly}'
,@FileName = '{DatabaseName}_{BackupType}_{Partial}_{CopyOnly}_{Year}{Month}{Day}_{Hour}{Minute}{Second}_{FileNumber}.{FileExtension}'
,@MaxTransferSize = 2097152
,@BufferCount = 30
,@LogToTable = 'Y'
,@Execute = 'Y'
;