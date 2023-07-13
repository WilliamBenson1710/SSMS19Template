:CONNECT OLY-DBPSQL-03S
GO
SELECT
@@SERVERNAME AS ServerName
,sp.name
,sp.sid
,N'CREATE LOGIN ['+sp.[name]+'] WITH PASSWORD=0x' + CONVERT(nvarchar(max), l.password_hash, 2)+N' HASHED, ' + N'SID=0x'+CONVERT(nvarchar(max), sp.[sid], 2)+N';'
FROM master.sys.server_principals AS sp
INNER JOIN master.sys.sql_logins AS l ON sp.[sid]=l.[sid]
WHERE sp.name='dbpsqluser'
GO

:CONNECT OLY-DBPSQL-04S
GO
SELECT
@@SERVERNAME AS ServerName
,sp.name
,sp.sid
,N'CREATE LOGIN ['+sp.[name]+'] WITH PASSWORD=0x' + CONVERT(nvarchar(max), l.password_hash, 2)+N' HASHED, ' + N'SID=0x'+CONVERT(nvarchar(max), sp.[sid], 2)+N';'
FROM master.sys.server_principals AS sp
INNER JOIN master.sys.sql_logins AS l ON sp.[sid]=l.[sid]
WHERE sp.name='dbpsqluser'
GO

:CONNECT SPO-DBPSQL-01S
GO
SELECT
@@SERVERNAME AS ServerName
,sp.name
,sp.sid
,N'CREATE LOGIN ['+sp.[name]+'] WITH PASSWORD=0x' + CONVERT(nvarchar(max), l.password_hash, 2)+N' HASHED, ' + N'SID=0x'+CONVERT(nvarchar(max), sp.[sid], 2)+N';'
FROM master.sys.server_principals AS sp
INNER JOIN master.sys.sql_logins AS l ON sp.[sid]=l.[sid]
WHERE sp.name='dbpsqluser'
GO
