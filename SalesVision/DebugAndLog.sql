--OLY-SVSSQL-01
USE SVSalesMgmt
GO

SELECT
*
FROM dbo.SVErrLog
WHERE [Timestamp] >= '2023-03-22'
ORDER BY [Timestamp] DESC


SELECT
*
FROM SVDebugLog
WHERE [Timestamp] >= '2023-03-22'
ORDER BY SeqNum DESC