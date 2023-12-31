DROP TABLE IF EXISTS #sp_who2

CREATE TABLE #sp_who2 (SPID INT, Status VARCHAR(255),
Login  VARCHAR(255), HostName  VARCHAR(255),
BlkBy  VARCHAR(255), DBName  VARCHAR(255),
Command VARCHAR(255), CPUTime INT,
DiskIO INT, LastBatch VARCHAR(255),
ProgramName VARCHAR(255), SPID1 INT,
REQUESTID INT);

INSERT INTO #sp_who2 
EXEC sp_who2
SELECT      *
, 'KILL ' + CONVERT(NVARCHAR(100),SPID) + ';'
FROM        #sp_who2
--WHERE Status NOT IN ('sleeping','BACKGROUND')
--WHERE Login = 'dbpsqluser'
ORDER BY    SPID ASC;

