SELECT distinct
@@SERVERNAME as ServerName
, UserName as LoginName
, UserType as LoginType
, DatabaseUserName
, Role
, PermissionType
, PermissionState
, DatabaseName = db_name()
, ObjectName  -- can be an object or the entire database
, ObjectType
, ColumnName
--  , item -- used to check consistencies in each subquery
FROM (
SELECT 
    UserName = princ.name,
    UserType = CASE princ.type
                    WHEN 'S' THEN 'SQL'
                    WHEN 'U' THEN 'Windows'
                    WHEN 'G' THEN 'Windows Group'
                    WHEN 'R' THEN 'Database Role'
                    ELSE princ.type 
                END,  
    DatabaseUserName = princ.name,       
    Role = princ.name,      
    PermissionType = perm.permission_name,       
    PermissionState = perm.state_desc,       
    ObjectType = obj.type_desc,
    ObjectName = coalesce(OBJECT_NAME(perm.major_id), db_name()),
    ColumnName = col.name,
    1 as item
FROM   
    sys.database_principals princ  
LEFT JOIN sys.login_token ulogin on princ.sid = ulogin.sid
LEFT JOIN sys.database_permissions perm ON perm.grantee_principal_id = princ.principal_id
LEFT JOIN sys.columns col ON col.object_id = perm.major_id AND col.column_id = perm.minor_id
LEFT JOIN sys.objects obj ON perm.major_id = obj.object_id
WHERE perm.permission_name <> 'CONNECT'
UNION
SELECT 
    UserName =  memberprinc.name ,
    UserType = CASE memberprinc.type
                    WHEN 'S' THEN 'SQL'
                    WHEN 'U' THEN 'Windows'
                    WHEN 'G' THEN 'Windows Group'
                    WHEN 'R' THEN 'Database Role'
                    else memberprinc.type 
                END, 
    DatabaseUserName = memberprinc.name,   
    Role = roleprinc.name,      
    PermissionType = perm.permission_name,       
    PermissionState = perm.state_desc,       
    ObjectType = obj.type_desc,
    ObjectName = db_name(),
    ColumnName = col.name,
    2 as item
FROM   
    sys.database_role_members members
INNER JOIN sys.database_principals roleprinc ON roleprinc.principal_id = members.role_principal_id
INNER JOIN sys.database_principals memberprinc ON memberprinc.principal_id = members.member_principal_id
LEFT JOIN sys.login_token ulogin on memberprinc.sid = ulogin.sid
LEFT JOIN sys.database_permissions perm ON perm.grantee_principal_id = roleprinc.principal_id
LEFT JOIN sys.columns col on col.object_id = perm.major_id AND col.column_id = perm.minor_id
LEFT JOIN sys.objects obj ON perm.major_id = obj.object_id
UNION
SELECT 
    UserName = roleprinc.name,
    UserType = 
    CASE roleprinc.type
                    WHEN 'S' THEN 'SQL'
                    WHEN 'U' THEN 'Windows'
                    WHEN 'G' THEN 'Windows Group'
                    WHEN 'R' THEN 'Database Role'
                    ELSE roleprinc.type 
                END,  
    DatabaseUserName = roleprinc.name,
    Role = roleprinc.name,      
    PermissionType = perm.permission_name,       
    PermissionState = perm.state_desc,       
    ObjectType = obj.type_desc,
    ObjectName = coalesce(OBJECT_NAME(perm.major_id), db_name()),
    ColumnName = col.name,
    3 as item
FROM   
    sys.database_principals roleprinc 
LEFT JOIN sys.database_permissions perm ON perm.grantee_principal_id = roleprinc.principal_id
LEFT JOIN sys.columns col on col.object_id = perm.major_id AND col.column_id = perm.minor_id                   
LEFT JOIN sys.objects obj ON obj.object_id = perm.major_id
UNION
SELECT
    UserName = princ.name collate Latin1_General_CI_AS,
    UserType = CASE princ.type
                    WHEN 'S' THEN 'SQL'
                    WHEN 'U' THEN 'Windows'
                    WHEN 'G' THEN 'Windows Group'
                    WHEN 'R' THEN 'Database Role'
                    ELSE princ.type 
                END ,  
    DatabaseUserName = princ.name collate Latin1_General_CI_AS,
    Role =  CASE
                WHEN logins.sysadmin = 1 THEN 'sysadmin'
                WHEN logins.securityadmin = 1 THEN 'securityadmin'
                WHEN logins.serveradmin = 1 THEN 'serveradmin'
                WHEN logins.setupadmin = 1 THEN 'setupadmin'
                WHEN logins.processadmin = 1 THEN 'processadmin'
                WHEN logins.diskadmin = 1 THEN 'diskadmin'
                WHEN logins.dbcreator = 1 THEN 'dbcreator'
                WHEN logins.bulkadmin = 1 THEN 'bulkadmin'
                ELSE 'Public'
            END,
    PermissionType  = perm.permission_name,
    PermissionState = 'GRANT',
    ObjectType      = NULL,
    ObjectName      = princ.default_database_name,
    ColumnName      = NULL,
    4 as item
FROM sys.server_principals princ 
INNER JOIN sys.syslogins logins ON princ.sid = logins.sid 
LEFT JOIN sys.database_permissions perm ON perm.grantee_principal_id = princ.principal_id
WHERE princ.type  <> 'R' AND princ.name NOT LIKE '##%'
) P  
where (Role <> 'Public' or ObjectName = db_name())
ORDER BY
P.DatabaseUserName,
P.ObjectName,
P.ColumnName,
P.PermissionType,
P.PermissionState,
P.ObjectType



