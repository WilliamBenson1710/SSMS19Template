
DROP TABLE #SpaceUsed;

SELECT
tab.[object_id],
f.name,
SCHEMA_NAME(tab.schema_id) + '.' + tab.name AS [table], 
CAST(SUM(spc.used_pages * 8)/1024.00 AS NUMERIC(36, 2)) AS used_mb,
CAST(SUM(spc.total_pages * 8)/1024.00 AS NUMERIC(36, 2)) AS allocated_mb
--CAST(sum(spc.used_pages * 8)/1024.00 as numeric(36, 2)) - CAST(sum(spc.used_pages * 8)/1024.00 as numeric(36, 2)) AS fREE
INTO #SpaceUsed
FROM sys.tables tab
INNER JOIN sys.indexes ind 
ON tab.object_id = ind.object_id

INNER JOIN sys.filegroups f
ON ind.data_space_id = f.data_space_id

INNER JOIN sys.partitions part 
ON ind.object_id = part.object_id AND ind.index_id = part.index_id

INNER JOIN sys.allocation_units spc
ON part.partition_id = spc.container_id
WHERE f.name = 'PRIMARY'
GROUP BY tab.object_id,f.NAME, SCHEMA_NAME(tab.schema_id) + '.' + tab.name
--ORDER BY SUM(spc.used_pages) DESC




SELECT
--TOP 300
OBJECT_NAME(i.[object_id]) as Name_of_Object,
i.name as Index_Name,
i.type_desc as Index_Type,
f.name as Name_of_Filegroup,
a.type as Object_Type,
f.type,
f.type_desc,
SpaceUsed.used_mb,
SpaceUsed.allocated_mb,
'CREATE CLUSTERED COLUMNSTORE INDEX [' + i.name +'] ON [' + SCHEMA_NAME(a.schema_id) + '].[' + object_name(i.[object_id]) + '] WITH (DROP_EXISTING = ON, COMPRESSION_DELAY = 0, DATA_COMPRESSION = COLUMNSTORE) ON [SECONDARY];'  AS MoveScript
FROM sys.filegroups as f 
INNER JOIN sys.indexes as i 
 ON f.data_space_id = i.data_space_id
INNER JOIN sys.all_objects as a 
 ON i.object_id = a.object_id

 LEFT OUTER JOIN #SpaceUsed AS SpaceUsed
ON i.[object_id] = SpaceUsed.[object_id]

WHERE a.type ='U' -- User defined tables only
--AND object_name(i.[object_id]) ='CurrentLoad_AKC' -- Specific object
--AND SCHEMA_NAME(a.schema_id) <> 'Loader'
AND f.name = 'PRIMARY'

--
--AND SpaceUsed.used_mb < 54926.41
ORDER BY SpaceUsed.allocated_mb



--CREATE CLUSTERED COLUMNSTORE INDEX [DS_AKC_tblFieldAudit_Data_idx_CS] ON [DS_AKC_dbo].[DS_AKC_tblFieldAudit_Data] WITH (DROP_EXISTING = ON, COMPRESSION_DELAY = 0, DATA_COMPRESSION = COLUMNSTORE) ON [SECONDARY];
--CREATE CLUSTERED COLUMNSTORE INDEX [DS_AKC_tblFieldAudit_Data_idx_CS] ON [DS_AKC_dbo].[DS_AKC_tblFieldAudit_Data] WITH (DROP_EXISTING = ON, COMPRESSION_DELAY = 0, DATA_COMPRESSION = COLUMNSTORE) ON [SECONDARY];