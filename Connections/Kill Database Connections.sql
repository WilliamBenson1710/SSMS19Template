USE [master]
GO

---- Kill all current connections

DECLARE @cmdKill VARCHAR(50)

DECLARE killCursor CURSOR FOR
SELECT 'KILL ' + CONVERT(VARCHAR(5), p.spid)
FROM master.dbo.sysprocesses AS p
WHERE p.dbid = DB_ID('LendingSupport')

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