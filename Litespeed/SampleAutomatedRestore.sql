DECLARE @CurrentBackupPath NVARCHAR(1000) = '\\wsecu.int\apps\SQL\sql_backup\OLY-PRMSQL-01\EFMSupportDemand\FULL\'
,@RestoreTargetDatabaseName  NVARCHAR(1000) = 'EFMSupportDemand'
,@SourceServerName NVARCHAR(1000) = 'OLY-PRMSQL-01'
,@SourceDatabseName NVARCHAR(1000) = 'EFMSupportDemand'
,@CurrentProgressName NVARCHAR(250) = '5e1036df-dd3a-4e32-8155-8c28e4ba069b'
,@InstanceDefaultDataPath NVARCHAR(1000) = NULL
,@InstanceDefaultLogPath NVARCHAR(1000) = NULL
,@CurrentServerName sysname = NULL
,@TestRestoreDryRun TINYINT = 0
;

SELECT @CurrentServerName = @@SERVERNAME;

SELECT @InstanceDefaultDataPath = CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(1000))
, @InstanceDefaultLogPath = CAST(SERVERPROPERTY('InstanceDefaultLogPath') AS NVARCHAR(1000));

IF @CurrentServerName = 'OLY-PRMSQL-02'
BEGIN

	---- Kill all current connections

	DECLARE @cmdKill VARCHAR(50);
	
	DECLARE killCursor CURSOR FOR
	SELECT 'KILL ' + CONVERT(VARCHAR(5), p.spid)
	FROM master.dbo.sysprocesses AS p
	WHERE p.dbid = DB_ID(@RestoreTargetDatabaseName)

	OPEN killCursor
	FETCH killCursor INTO @cmdKill

	WHILE 0 = @@fetch_status
	BEGIN
	EXECUTE (@cmdKill) 
	FETCH killCursor INTO @cmdKill
	END

	CLOSE killCursor
	DEALLOCATE killCursor 

	-----------------------

	EXEC master.dbo.xp_restore_automated @database = @RestoreTargetDatabaseName ,
	@backuppath = @CurrentBackupPath,
	@datafilepath = @InstanceDefaultDataPath,
	@logfilepath = @InstanceDefaultLogPath,
	@backupextension = N'',
	@checksubfolders = 0,
	@sourceserver = @SourceServerName,
	@sourcedatabase = @SourceDatabseName,
	@backuptype = N'diff',
	@affinity = 0,
	@logging = 0,
	@withreplace = 1,
	@DontUseReplication = 1,
	@IncludeAGReplicas = 1,
	@checkdb = 1,
	@checkdbphysicalonly = 1,
	@checkdbnoindex = 1,
	@checkdbnoinfomessages = 1,
	@progressname = @CurrentProgressName,
	@with = N'RECOVERY',
	@with = N'STATS = 10',
	@dryrun = @TestRestoreDryRun

	/**LiteSpeed Data. Do not modify.**/
	/**H4sIAAAAAAAEAIvMLPZLLMksS7U24OVKSSxJTEosTo0vTs1JTS7JzM+LL6ksAEsVpxaVpRZZ+/tE6gYE+QYH+ugaGCE0GFi7uvkGlxYU5BeVuKTmJual8HIBAICioU5aAAAA
	**/

END
ELSE
BEGIN
	PRINT 'Wrong Server'
END