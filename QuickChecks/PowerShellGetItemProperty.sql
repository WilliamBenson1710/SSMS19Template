EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

DECLARE @SQLSatement NVARCHAR(4000)
,@DirectoryFullFileName NVARCHAR(4000) = '\\wsecu.int\apps\SQL\sql_backup\OLY-BANCSQL-01\WSECU_Core\FULL_COPY_ONLY\WSECU_Core_FULL_COPY_ONLY_20230104_112200_4.bak'  

SELECT @SQLSatement = 'powershell.exe -c "Get-ItemProperty ' + CHAR(34) + @DirectoryFullFileName + CHAR(34) + ' | SELECT FullName,BaseName,name,CreationTime,LastWriteTime | foreach{$_.FullName +''|''+$_.BaseName +''/''+ $_.Name+''@''+$_.CreationTime.ToString(''MM/dd/yyyy hh:mm:ss'') + ''#''+$_.LastWriteTime.ToString(''MM/dd/yyyy hh:mm:ss'')}"';

SELECT @SQLSatement

SELECT value FROM sys.configurations WHERE name = 'xp_cmdshell'

EXEC sp_configure 'xp_cmdshell', 1
RECONFIGURE;

EXEC xp_cmdshell @SQLSatement


EXEC sp_configure 'xp_cmdshell', 0
RECONFIGURE;