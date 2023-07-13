SELECT
@@SERVERNAME AS ServerName
,sp.principal_id AS PrincipalId
,sp.[name] AS PrincipalName
,sp.[type_desc] AS PrincipalTypeDesc
,sp.[sid] AS PrincipalSid
,sp.is_disabled AS PrincipalIsDisabled
,sp.create_date AS PrincipalCreateDate
,sp.modify_date AS PrincipalModifyDate
,sp.default_database_name AS PrincipalDefaultDatabase
FROM sys.server_principals AS sp

LEFT OUTER JOIN sys.databases AS sysd
ON default_database_name = sysd.name

WHERE sp.type IN ('S','G','U')
AND sysd.database_id IS NULL
