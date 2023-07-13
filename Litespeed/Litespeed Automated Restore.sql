DECLARE @CurrentBackupPath NVARCHAR(1000) = '\\wsecu.int\apps\SQL\sql_backup\OLY-SVSSQL-01\SVSalesMgmt\FULL'
,@RestoreTargetDatabaseName  NVARCHAR(1000) = 'SVSalesMgmt_BAK'
,@SourceServerName NVARCHAR(1000) = 'OLY-SVSSQL-01'
,@SourceDatabseName NVARCHAR(1000) = 'SVSalesMgmt'
,@LitespeedProgressName NVARCHAR(1000) = ''
,@InstanceDefaultDataPath NVARCHAR(1000) = NULL
,@InstanceDefaultLogPath NVARCHAR(1000) = NULL
;

SELECT @InstanceDefaultDataPath = CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(1000))
, @InstanceDefaultLogPath = CAST(SERVERPROPERTY('InstanceDefaultLogPath') AS NVARCHAR(1000));

EXEC master.dbo.xp_restore_automated
@database=@RestoreTargetDatabaseName
, @datafilepath = @InstanceDefaultDataPath
, @logfilepath = @InstanceDefaultLogPath

/* Stripe File #1 */
, @backuppath = @CurrentBackupPath
, @backupextension = 'bak'
, @checksubfolders = 0
/* Stripe File #2 */
, @backuppath = @CurrentBackupPath
, @backupextension = 'bak'
, @checksubfolders = 0
/* Stripe File #3 */
, @backuppath = @CurrentBackupPath
, @backupextension = 'bak'
, @checksubfolders = 0
/* Stripe File #4 */
, @backuppath = @CurrentBackupPath
, @backupextension = 'bak'
, @checksubfolders = 0
/* Stripe File #5 */
, @backuppath = @CurrentBackupPath
, @backupextension = 'bak'
, @checksubfolders = 0
, @sourceserver = @SourceServerName
, @sourcedatabase = @SourceDatabseName
, @backuptype = N'diff'
, @withreplace = 1
, @ReturnDetails = 1
--, @checkdb = 1
--, @checkdbnoindex = 1
--, @checkdbnoinfomessages = 1
, @MAXTRANSFERSIZE = 4194304 
, @BUFFERCOUNT = 75
, @progressname = @LitespeedProgressName
, @with = N'REPLACE'
, @with = N'STATS = 10'