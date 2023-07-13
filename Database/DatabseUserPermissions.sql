SELECT DISTINCT
@@SERVERNAME AS ServerName
,db_id() AS DatabaseId
,db_name() AS DatabaseName
,rp.principal_id AS PrincipalId, 
rp.[name] AS PrincipalName, 
rp.[type_desc] AS PrincipalTypeDesc, 
pm.class_desc AS PermissionObjectType, 
pm.state_desc AS PermissionStateDesc,
pm.[permission_name] AS PermissionTypeName, 
CASE WHEN obj.[type_desc] IS NULL OR obj.[type_desc] = 'SYSTEM_TABLE' THEN pm.class_desc 
	ELSE obj.type_desc
END AS ObjectType, 
s.Name as SchemaName,
Isnull(ss.name, Object_name(pm.major_id)) AS [ObjectName]
FROM   sys.database_principals AS rp
INNER JOIN sys.database_permissions AS pm
	ON pm.grantee_principal_id = rp.principal_id
LEFT JOIN sys.schemas AS ss
	ON pm.major_id = ss.schema_id
LEFT JOIN sys.objects AS obj
	ON pm.[major_id] = obj.[object_id]
LEFT JOIN sys.schemas AS s
	ON s.schema_id = obj.schema_id
WHERE rp.name <> 'public'
--ORDER BY rp.name, rp.type_desc, pm.class_desc