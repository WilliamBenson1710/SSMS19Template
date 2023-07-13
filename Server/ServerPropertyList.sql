SELECT 
CAST(SERVERPROPERTY('ServerName') AS NVARCHAR(128)) AS [ServerName]
,CAST(@@SERVICENAME AS NVARCHAR(100)) AS [ServiceName]
,CONVERT(NVARCHAR(128), CASE LEFT(CONVERT(NVARCHAR(128), SERVERPROPERTY('ProductVersion')),4) 
   WHEN '8.00' THEN 'SQL Server 2000'
   WHEN '9.00' THEN 'SQL Server 2005'
   WHEN '10.0' THEN 'SQL Server 2008'
   WHEN '10.5' THEN 'SQL Server 2008 R2'
   WHEN '11.0' THEN 'SQL Server 2012'
   WHEN '12.0' THEN 'SQL Server 2014'
   WHEN '13.0' THEN 'SQL Server 2016'
   WHEN '14.0' THEN 'SQL Server 2017'
   WHEN '15.0' THEN 'SQL Server 2019'
   WHEN '16.0' THEN 'SQL Server 2022'
   ELSE 'SQL Server 2022+'
END) AS [SQLVersionBuild]
,CAST(SERVERPROPERTY('Edition')AS NVARCHAR(128)) AS [Edition]
,CAST(@@VERSION AS NVARCHAR(128)) AS SQLVersion
,LTRIM(RTRIM(SUBSTRING(@@Version, CHARINDEX('Windows',@@Version), CHARINDEX('<',@@Version) - CHARINDEX('Windows',@@Version)))) AS OSVersion
,CAST(SERVERPROPERTY('EngineEdition') AS SMALLINT) AS [EngineEdition]             
,CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(128)) AS [ProductVersion]
,CAST(CONNECTIONPROPERTY('client_net_address') AS NVARCHAR(128)) AS [ClientMachineIP]
,CAST(CONNECTIONPROPERTY('local_net_address') AS NVARCHAR(128))  AS [SQLServerIP]
,CAST(CONNECTIONPROPERTY('local_tcp_port') AS SMALLINT) AS [SQLServerPort]
,CASE CAST(SERVERPROPERTY('IsIntegratedSecurityOnly') AS NVARCHAR(128))
	WHEN 1 THEN 'Windows Authentication'
	WHEN 0 THEN 'Windows Authentication'
	ELSE 'N/A'
END AS IsIntegratedSecurityOnly
,CAST(SERVERPROPERTY('IsClustered') AS BIT) AS [IsClustered]
,(SELECT CAST(value_in_use AS SMALLINT) FROM sys.configurations WHERE [name] = 'cost threshold for parallelism') AS CostThresholdForParallelism
,(SELECT CAST(value_in_use AS SMALLINT) FROM sys.configurations WHERE [name] = 'max degree of parallelism') AS MaxDegreeOfParallelism
,CAST(SERVERPROPERTY('InstanceDefaultBackupPath') AS NVARCHAR(128)) AS [InstanceDefaultBackupPath]
,CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(128)) AS [InstanceDefaultDataPath]
,CAST(SERVERPROPERTY('InstanceDefaultLogPath') AS NVARCHAR(128)) AS [InstanceDefaultLogPath]
,(SELECT cpu_count FROM sys.dm_os_sys_info) AS [LogicalCPUCount]
,(SELECT hyperthread_ratio FROM sys.dm_os_sys_info) AS [HyperthreadRatio]
,(SELECT physical_memory_kb FROM sys.dm_os_sys_info) AS [PhysicalMemoryKB]
,(SELECT cntr_value FROM sys.dm_os_performance_counters WHERE counter_name LIKE '%Target Server%') AS TargetServerMemoryKB
,(SELECT cntr_value FROM sys.dm_os_performance_counters WHERE counter_name LIKE '%Total Server%') AS TotalUsedServerMemoryKB
,(SELECT sqlserver_start_time FROM sys.dm_os_sys_info) AS SQLServerStartTime
,(SELECT login_time FROM sys.sysprocesses WHERE program_name LIKE 'SQLAgent - Generic Refresher%') AS SQLServerAgentStartTime
,(SELECT COUNT(1) FROM master.dbo.sysprocesses WHERE program_name = N'SQLAgent - Generic Refresher') AS SQLServerAgentRunning