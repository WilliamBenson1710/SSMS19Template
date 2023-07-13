SELECT
t.NAME AS TableName,
MAX(p.rows) AS RowCounts,
(SUM(a.total_pages) * 8) / 1024.0 AS TotalSpaceMB,
(SUM(a.used_pages) * 8) / 1024.0 AS UsedSpaceMB,
(SUM(a.data_pages) * 8) /1024.0 AS DataSpaceMB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
WHERE i.OBJECT_ID > 255
AND i.index_id IN (0,1)
GROUP BY t.NAME
ORDER BY TotalSpaceMB DESC