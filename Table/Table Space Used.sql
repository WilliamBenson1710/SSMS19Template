SELECT
@@SERVERNAME AS ServerName
,DB_ID() AS DatabaseId
,systbl.[object_id]
,SCHEMA_NAME(systbl.[schema_id]) AS SchemaName
,systbl.[NAME] AS TableName
,sysindx.[NAME] AS IndexName
,sysindx.[index_id] AS IndexId
,sysindx.[type_desc] AS IndexTypeDesc
,sysindx.[is_primary_key] AS IndexIsPrimaryKey
,sysindx.is_padded AS IndexIsPadded
,sysindx.fill_factor AS IndexFillFactor
,sysprt.[ROWS] AS PartitionRows
,sysallunt.total_pages
,sysallunt.used_pages
,sysallunt.data_pages
,(sysallunt.total_pages) * 8 / 1024.0 as TotalSpaceMB
,(sysallunt.used_pages) * 8 / 1024.0 as UsedSpaceMB
,(sysallunt.data_pages) * 8 /1024.0 AS DataSpaceMB
--,sysindx.*
--,sysprt.*
--,sysallunt.*
FROM sys.tables AS systbl
INNER JOIN sys.indexes AS sysindx
	ON systbl.[object_id] = sysindx.[object_id]
INNER JOIN sys.partitions AS sysprt
	ON sysindx.[object_id] = sysprt.[object_id] 
	AND sysindx.index_id = sysprt.index_id
INNER JOIN sys.allocation_units AS sysallunt 
	ON sysprt.[partition_id] = sysallunt.container_id
WHERE systbl.name = 'audit_event_data' --audit_record'