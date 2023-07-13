SELECT
OBJECT_NAME(object_id)
, *
FROM sys.data_spaces ds
INNER JOIN sys.allocation_units au
	ON ds.data_space_id = au.data_space_id
INNER JOIN sys.partitions p
ON  au.container_id = 
  CASE 
  WHEN au.type = 2 THEN p.partition_id
  ELSE p.hobt_id 
  END
 WHERE ds.name = 'PRIMARY' --Your file group name