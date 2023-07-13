DECLARE @query nvarchar(MAX) = 
N'SELECT
     DB_NAME() AS DatabaseName
    ,CONCAT(QUOTENAME(OBJECT_SCHEMA_NAME(t.object_id)),N''.'', t.name) AS TableName
    ,SUM(rows) AS TableRowCount
FROM sys.tables AS t
JOIN sys.partitions AS p ON p.object_id = t.object_id AND p.index_id IN(0,1)
GROUP BY CONCAT(QUOTENAME(OBJECT_SCHEMA_NAME(t.object_id)),N''.'', t.name)
ORDER BY DatabaseName, TableName';

DECLARE @query_all_databases nvarchar(MAX) = (

    SELECT STRING_AGG(CONCAT(N'USE ', QUOTENAME(d.name), CAST(N';' AS nvarchar(MAX)), @query),N';')
    FROM sys.databases AS d
    LEFT JOIN sys.dm_hadr_database_replica_states AS drs ON drs.database_id = d.database_id
    WHERE
        d.name NOT IN(N'master',N'model',N'tempdb',N'msdb',N'SSISDB')
        AND d.state_desc = 'ONLINE'
        AND COALESCE(drs.is_primary_replica, 1) = 1
);

EXEC sp_executesql @query_all_databases