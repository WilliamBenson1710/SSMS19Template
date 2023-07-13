:SETVAR DatabaseName "CreditQuest"
:SETVAR SchemaName "dbo"
:SETVAR TableName "LOG_RECORD"

:CONNECT OLY-SQL-05
GO

USE $(DatabaseName)
GO

SELECT
CONVERT(CHAR(10), D_INSERT,121) AS InsertDate
,COUNT(1) AS RecordCount
FROM $(SchemaName).$(TableName)
GROUP BY CONVERT(CHAR(10), D_INSERT,121)
ORDER BY CONVERT(CHAR(10), D_INSERT,121) DESC
GO