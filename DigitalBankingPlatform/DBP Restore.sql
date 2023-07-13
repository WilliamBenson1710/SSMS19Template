USE [master]

IF @@SERVERNAME = 'OLY-DBPSQL-02H'
BEGIN

---- Kill all current connections

DECLARE @cmdKill VARCHAR(50)

DECLARE killCursor CURSOR FOR
SELECT 'KILL ' + CONVERT(VARCHAR(5), p.spid)
FROM master.dbo.sysprocesses AS p
WHERE p.dbid = DB_ID('bb-dbs')

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

BACKUP LOG [bb-dbs] TO  DISK = N'\\wsecu.int\apps\SQL\sql_backup\bb-dbs_LogBackup_2022-11-07_08-53-47.bak' WITH NOFORMAT, NOINIT,  NAME = N'bb-dbs_LogBackup_2022-11-07_08-53-47', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5

RESTORE DATABASE [bb-dbs] FROM  DISK = N'\\wsecu.int\apps\SQL\sql_backup\OLY-DBPSQL-02\bb-dbs\FULL\bb-dbs_FULL_20221105_233001_1.bak'
,  DISK = N'\\wsecu.int\apps\SQL\sql_backup\OLY-DBPSQL-02\bb-dbs\FULL\bb-dbs_FULL_20221105_233001_2.bak'
,  DISK = N'\\wsecu.int\apps\SQL\sql_backup\OLY-DBPSQL-02\bb-dbs\FULL\bb-dbs_FULL_20221105_233001_3.bak'
,  DISK = N'\\wsecu.int\apps\SQL\sql_backup\OLY-DBPSQL-02\bb-dbs\FULL\bb-dbs_FULL_20221105_233001_4.bak'
,  DISK = N'\\wsecu.int\apps\SQL\sql_backup\OLY-DBPSQL-02\bb-dbs\FULL\bb-dbs_FULL_20221105_233001_5.bak'
,  DISK = N'\\wsecu.int\apps\SQL\sql_backup\OLY-DBPSQL-02\bb-dbs\FULL\bb-dbs_FULL_20221105_233001_6.bak'
,  DISK = N'\\wsecu.int\apps\SQL\sql_backup\OLY-DBPSQL-02\bb-dbs\FULL\bb-dbs_FULL_20221105_233001_7.bak'
,  DISK = N'\\wsecu.int\apps\SQL\sql_backup\OLY-DBPSQL-02\bb-dbs\FULL\bb-dbs_FULL_20221105_233001_8.bak'
WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 5
END
GO


