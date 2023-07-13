use master

 

EXEC xp_sqllitespeed_version
SELECT * FROM sys.dm_os_cluster_nodes
-- SQL 2017 and above only select cpu_count,hyperthread_ratio,socket_count,cores_per_socket,physical_memory_kb/1024 as memory_mb from master.sys.dm_os_sys_info
EXEC xp_sqllitespeed_licenseinfo 
select @@servername
select @@version