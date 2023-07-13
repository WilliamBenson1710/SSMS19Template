SELECT
[name] as DatabaseName
FROM sys.databases
WHERE [name] NOT IN ('tempdb')
AND state_desc = 'ONLINE'

SELECT
@@SERVERNAME AS ServerName
,db_id() AS DatabaseId
,db_name() AS DatabaseName
,principal_id AS PrincipalId
,[name] AS PrincipalName
,[type_desc] AS PrincipalTypeDesc
,[sid] AS PrincipalSid
--,is_disabled AS PrincipalIsDisabled
,create_date AS PrincipalCreateDate
,modify_date AS PrincipalModifyDate
,default_schema_name AS PrincipalDefaultSchemaName
FROM sys.database_principals
WHERE type IN ('S','G','U')
;

select
db_name() dbname,
dp.name principle,
rp.name role
from [sys].[database_role_members] drm
inner join [sys].[database_principals] rp on rp.principal_id = drm.role_principal_id
inner join [sys].[database_principals] dp on dp.principal_id = drm.member_principal_id

SELECT DISTINCT rp.name, 
ObjectType = rp.type_desc, 
PermissionType = pm.class_desc, 
pm.permission_name, 
pm.state_desc, 
	ObjectType = CASE 
	WHEN obj.type_desc IS NULL 
		OR obj.type_desc = 'SYSTEM_TABLE' THEN 
	pm.class_desc 
	ELSE obj.type_desc 
	END, 
s.Name as SchemaName,
[ObjectName] = Isnull(ss.name, Object_name(pm.major_id)) 
FROM   sys.database_principals rp 
INNER JOIN sys.database_permissions pm 
ON pm.grantee_principal_id = rp.principal_id 
LEFT JOIN sys.schemas ss 
ON pm.major_id = ss.schema_id 
LEFT JOIN sys.objects obj 
ON pm.[major_id] = obj.[object_id] 
LEFT JOIN sys.schemas s
ON s.schema_id = obj.schema_id
WHERE rp.name <> 'public'
AND rp.type_desc = 'DATABASE_ROLE' 
AND pm.class_desc <> 'DATABASE' 
ORDER  BY rp.name, 
rp.type_desc, 
pm.class_desc
;
