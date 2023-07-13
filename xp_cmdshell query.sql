DECLARE @chkCMDShell AS SQL_VARIANT
,@Debug AS BIT = 1

SET NOCOUNT ON;

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

SELECT @chkCMDShell = value FROM sys.configurations WHERE name = 'xp_cmdshell';

IF @Debug = 1
BEGIN
	PRINT '------------ Debug Inoformation ----------------' ;
	PRINT '@chkCMDShell: ' + ISNULL(CAST(@chkCMDShell AS VARCHAR(100)), 'NULL') ;
END

IF @chkCMDShell = 0
BEGIN
	
	IF @Debug = 1
	BEGIN
		PRINT '------------ Turning on xp_cmdshell ----------------' ;
	END
	EXEC sp_configure 'xp_cmdshell', 1
	RECONFIGURE;

	SELECT @chkCMDShell = value FROM sys.configurations WHERE name = 'xp_cmdshell';

	IF @Debug = 1
	BEGIN
		PRINT 'Did we turn on xp_cmdshell: ' + ISNULL(CAST(@chkCMDShell AS VARCHAR(100)), 'NULL') ;
	END

END

/*
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
*/

	DECLARE @DatabaseName NVARCHAR(35) = 'wsecudw2symitar'
	,@LocationPathFileName NVARCHAR(100) = '\\oly-nas-01\FICS\joe.txt'
	,@SQLQuery NVARCHAR(4000)
	,@RunSQLCommand BIT = 1
	;

	SELECT @SQLQuery = 'bcp "SELECT TOP 10 * FROM ' + @DatabaseName + '.arcu.ARCUUserCategory " queryout "' + @LocationPathFileName + '" -C -T'

	PRINT '@SQLQuery: ' + ISNULL(CAST(@SQLQuery AS VARCHAR(100)), 'NULL') ;

	IF @RunSQLCommand = 1
	BEGIN
		EXEC xp_cmdshell @SQLQuery;
	END
/*
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
*/
--DECLARE @chkCMDShell AS SQL_VARIANT

SELECT @chkCMDShell = value FROM sys.configurations WHERE name = 'xp_cmdshell'

IF @chkCMDShell = 1
BEGIN
	IF @Debug = 1
	BEGIN
		PRINT '------------ Turning off xp_cmdshell ----------------' ;
	END
	EXEC sp_configure 'xp_cmdshell', 0
	RECONFIGURE;

	SELECT @chkCMDShell = value FROM sys.configurations WHERE name = 'xp_cmdshell';

	IF @Debug = 1
	BEGIN
		PRINT 'Did we turn Off xp_cmdshell: ' + ISNULL(CAST(@chkCMDShell AS VARCHAR(100)), 'NULL') ;
	END
END

EXEC sp_configure 'show advanced options', 0;
RECONFIGURE;
