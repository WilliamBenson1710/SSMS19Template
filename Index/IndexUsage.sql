SELECT DB_NAME() AS DatabaseName,
       SCHEMA_NAME(s.schema_id) + '.' + OBJECT_NAME(i.object_id) AS TableName,
       i.name AS IndexName,
       ius.user_seeks AS Seeks,
       ius.user_scans AS Scans,
       ius.user_lookups AS Lookups,
       ius.user_updates AS Updates,
       CASE
           WHEN ps.usedpages > ps.pages THEN
       (ps.usedpages - ps.pages)
           ELSE
               0
       END * 8 / 1024 AS IndexSizeMB,
       ius.last_user_seek AS LastSeek,
       ius.last_user_scan AS LastScan,
       ius.last_user_lookup AS LastLookup,
       ius.last_user_update AS LastUpdate
FROM sys.indexes i
    INNER JOIN sys.dm_db_index_usage_stats ius
        ON ius.index_id = i.index_id
           AND ius.object_id = i.object_id
    INNER JOIN
    (
        SELECT sch.name,
               sch.schema_id,
               o.object_id,
               o.create_date
        FROM sys.schemas sch
            INNER JOIN sys.objects o
                ON o.schema_id = sch.schema_id
    ) s
        ON s.object_id = i.object_id
    LEFT JOIN
    (
        SELECT object_id,
               index_id,
               SUM(used_page_count) AS usedpages,
               SUM(   CASE
                          WHEN (index_id < 2) THEN
                      (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count)
                          ELSE
                              lob_used_page_count + row_overflow_used_page_count
                      END
                  ) AS pages
        FROM sys.dm_db_partition_stats
        GROUP BY object_id,
                 index_id
    ) AS ps
        ON i.object_id = ps.object_id
           AND i.index_id = ps.index_id
WHERE OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1
      --optional parameters
      AND ius.database_id = DB_ID() --only check indexes in current database
      --AND i.type_desc = 'nonclustered' --only check nonclustered indexes
      --AND i.is_primary_key = 0 --do not check primary keys
      --AND i.is_unique_constraint = 0 --do not check unique constraints
	--AND (ius.user_seeks+ius.user_scans+ius.user_lookups) < 1  --only return unused indexes
--AND OBJECT_NAME(i.OBJECT_ID) = 'tableName'--only check indexes on specified table
--AND i.name = 'IX_Your_Index_Name' --only check a specified index
ORDER BY i.name;