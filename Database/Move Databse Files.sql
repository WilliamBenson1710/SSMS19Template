DECLARE --D:\MSSQL\Data\
@RowsFileTypeDescToMove NVARCHAR(50) = 'ROWS'
,@RowsNewDriveLetter NVARCHAR(50) = 'D:'
,@RowsNewFilePath NVARCHAR(50) = '\MSSQL\Data\'
,@RowsNewDriveLetterFullPath NVARCHAR(100) = NULL

DECLARE --L:\MSSQL\Log\
@LogFileTypeDescToMove NVARCHAR(50) = 'LOG'
,@LogNewDriveLetter NVARCHAR(50) = 'L:'
,@LogNewFilePath NVARCHAR(50) = '\MSSQL\Log\'
,@LogNewDriveLetterFullPath NVARCHAR(100) = NULL


SELECT @RowsNewDriveLetterFullPath = @RowsNewDriveLetter + @RowsNewFilePath
, @LogNewDriveLetterFullPath = @LogNewDriveLetter + @LogNewFilePath

SELECT  @RowsNewDriveLetterFullPath AS RowsNewDriveLetterFullPath
,@LogNewDriveLetterFullPath AS LogNewDriveLetterFullPath

SELECT
sdb.name AS DatabseName
,smf.name AS FileName
,smf.type_desc
,smf.physical_name
,REVERSE(smf.physical_name) AS ReversedPhysicalNname
,REVERSE(SUBSTRING(REVERSE(smf.physical_name), 1, CHARINDEX('\',REVERSE(smf.physical_name)) - 1)) AS FileExt
,@RowsNewDriveLetterFullPath AS RowsNewDriveLetterFullPath
,@RowsNewDriveLetterFullPath AS RowsNewDriveLetterFullPath
, CASE WHEN smf.type_desc = 'ROWS' THEN 'ALTER DATABASE [' + sdb.name + ']' + CHAR(13) + 'MODIFY FILE (NAME = [' + smf.name + '], FILENAME = ' + CHAR(39) + @RowsNewDriveLetterFullPath + REVERSE(SUBSTRING(REVERSE(smf.physical_name), 1, CHARINDEX('\',REVERSE(smf.physical_name)) - 1)) + CHAR(39) +');' + CHAR(13)	+ 'GO'
	WHEN smf.type_desc = 'LOG' THEN 'ALTER DATABASE [' + sdb.name + ']' + CHAR(13) + 'MODIFY FILE (NAME = [' + smf.name + '], FILENAME = ' + CHAR(39) + @LogNewDriveLetterFullPath + REVERSE(SUBSTRING(REVERSE(smf.physical_name), 1, CHARINDEX('\',REVERSE(smf.physical_name)) - 1)) + CHAR(39) +');' + CHAR(13)	+ 'GO'	
	ELSE NULL
END AS AlterScriptToRun_One
/* Used for Database Files Not TempDB */
/*
, CASE WHEN smf.type_desc = 'ROWS' THEN 'ALTER DATABASE [' + sdb.name + ']' + CHAR(13) + 'MODIFY FILE (NAME = [' + smf.name + '], FILENAME = ' + CHAR(39) + @RowsNewDriveLetterFullPath + smf.name +  REVERSE(SUBSTRING(REVERSE(smf.physical_name), 1, CHARINDEX('\',REVERSE(smf.physical_name)) - 1)) + CHAR(39) +');' + CHAR(13)	+ 'GO'
	WHEN smf.type_desc = 'LOG' THEN 'ALTER DATABASE [' + sdb.name + ']' + CHAR(13) + 'MODIFY FILE (NAME = [' + smf.name + '], FILENAME = ' + CHAR(39) + @LogNewDriveLetterFullPath + smf.name +  REVERSE(SUBSTRING(REVERSE(smf.physical_name), 1, CHARINDEX('\',REVERSE(smf.physical_name)) - 1)) + CHAR(39) +');' + CHAR(13)	+ 'GO'	
	ELSE NULL
END AS AlterScriptToRun_Two
*/
FROM sys.master_files as smf
INNER JOIN sys.databases as sdb
ON smf.database_id = sdb.database_id
WHERE smf.type_desc = @LogFileTypeDescToMove
--AND sdb.name NOT in ('SSISDB','master','tempdb','msdb','model')
AND sdb.name NOT IN ('tempdb')
--AND smf.type_desc = 'LOG'
AND CHARINDEX('L:\',smf.physical_name) = 0
ORDER BY smf.name
