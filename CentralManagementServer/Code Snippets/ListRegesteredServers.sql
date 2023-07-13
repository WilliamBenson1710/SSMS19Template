SELECT
CASE Grps.parent_id WHEN NULL THEN Grps.name
	ELSE (SELECT name FROM msdb.dbo.sysmanagement_shared_server_groups WHERE server_group_id=Grps.parent_id)
END AS [TopLevelGroup]
, CASE Grps.parent_id WHEN NULL THEN 'Unknown'
	ELSE Grps.name
END AS [SecondaryGroup]
, Srv.[name] AS [DisplayName]
, Srv.[server_name] AS [FullyQualifiedName]
, Srv.[description] AS [Description]
FROM msdb.dbo.sysmanagement_shared_registered_servers Srv
LEFT OUTER JOIN msdb.dbo.sysmanagement_shared_server_groups Grps
	ON Srv.server_group_id = Grps.server_group_id