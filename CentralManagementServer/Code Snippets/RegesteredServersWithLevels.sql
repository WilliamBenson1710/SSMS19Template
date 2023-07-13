SELECT
Lvl1.server_group_id AS ServerGroupId
,Lvl1.[name] AS ServerGroupLevel1
,lvl1svr.[name] AS ServerNameLevel1
,Lvl2.[name] AS ServerGroupLevel2
,lvl2svr.[name] AS ServerNameLevel2
,Lvl3.[name] AS ServerGroupLevel3
,lvl3svr.[name] AS ServerNameLevel3
,Lvl4.[name] AS ServerGroupLevel4
,lvl4svr.[name] AS ServerNameLevel4
FROM msdb.dbo.sysmanagement_shared_server_groups_internal AS Lvl1
LEFT OUTER JOIN msdb.dbo.sysmanagement_shared_registered_servers_internal AS lvl1svr
	ON Lvl1.server_group_id = lvl1svr.server_group_id

LEFT OUTER JOIN msdb.dbo.sysmanagement_shared_server_groups_internal Lvl2
	ON Lvl1.server_group_id = Lvl2.parent_id
LEFT OUTER JOIN msdb.dbo.sysmanagement_shared_registered_servers_internal AS lvl2svr
	ON Lvl2.server_group_id = lvl2svr.server_group_id

LEFT OUTER JOIN msdb.dbo.sysmanagement_shared_server_groups_internal Lvl3
	ON Lvl2.server_group_id = Lvl3.parent_id
LEFT OUTER JOIN msdb.dbo.sysmanagement_shared_registered_servers_internal AS lvl3svr
	ON Lvl3.server_group_id = lvl3svr.server_group_id

LEFT OUTER JOIN msdb.dbo.sysmanagement_shared_server_groups_internal Lvl4
	ON Lvl3.server_group_id = Lvl4.parent_id
LEFT OUTER JOIN msdb.dbo.sysmanagement_shared_registered_servers_internal AS lvl4svr
	ON Lvl4.server_group_id = lvl4svr.server_group_id

WHERE Lvl1.server_group_id = 1