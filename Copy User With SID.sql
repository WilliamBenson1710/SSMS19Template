:CONNECT OLY-DBPSQL1-01S
GO
SELECT
@@SERVERNAME AS ServerName
,sp.name
,sp.sid
,N'CREATE LOGIN ['+sp.[name]+'] WITH PASSWORD=0x' + CONVERT(NVARCHAR(MAX), l.password_hash, 2)+N' HASHED, ' + N'SID=0x'+CONVERT(NVARCHAR(MAX), sp.[sid], 2)+N';'
FROM master.sys.server_principals AS sp
INNER JOIN master.sys.sql_logins AS l ON sp.[sid]=l.[sid]
WHERE sp.name='dbpsqluser'
GO