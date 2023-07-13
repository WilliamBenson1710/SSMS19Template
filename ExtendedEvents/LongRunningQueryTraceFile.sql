DECLARE @ExtendedEventSessionName NVARCHAR(256) = 'LongRunning Queries Server'
, @SessionFilePathName NVARCHAR(MAX) = NULL --'D:\ExtendedEvents\LongRunningQueriesServer_0_133094693505170000.xel'
;

IF @SessionFilePathName IS NULL
BEGIN

	SELECT
	@SessionFilePathName = CAST( t.target_data AS XML ).value('(EventFileTarget/File/@name)[1]', 'VARCHAR(MAX)')
	FROM sys.dm_xe_sessions s
	INNER JOIN sys.dm_xe_session_targets t
	ON s.address = t.event_session_address
	WHERE s.NAME = @ExtendedEventSessionName;

END

PRINT @SessionFilePathName;

TRUNCATE TABLE [EventDataETL].[LongRunningQueries];

INSERT INTO [EventDataETL].[LongRunningQueries]
([event_name]
,[package_name]
,[utc_timestamp]
,[client_app_name]
,[client_hostname]
,[duration]
,[cpu]
,[logical_reads]
,[physical_reads]
,[writes]
,[row_count]
,[last_row_count]
,[line_number]
,[offset]
,[offset_end]
,[database_name]
,[nt_username]
,[username]
,[plan_handle]
,[query_hash]
,[query_hash_signed]
,[session_id]
,[statement]
,[sql_text]
,[SessionName]
,[SessionFilePathName]
)
SELECT
n.value('(@name)[1]', 'varchar(50)') AS event_name,
n.value('(@package)[1]', 'varchar(50)') AS package_name,
n.value('(@timestamp)[1]', 'datetime2') AS [utc_timestamp],
n.value('(action[@name="client_app_name"]/value)[1]', 'nvarchar(128)') AS client_app_name,
n.value('(action[@name="client_hostname"]/value)[1]', 'nvarchar(128)') AS client_hostname,
n.value('(data[@name="duration"]/value)[1]', 'bigint') AS duration,
n.value('(data[@name="cpu_time"]/value)[1]', 'bigint') AS cpu,
n.value('(data[@name="logical_reads"]/value)[1]', 'bigint') AS logical_reads,
n.value('(data[@name="physical_reads"]/value)[1]', 'bigint') AS physical_reads,
n.value('(data[@name="writes"]/value)[1]', 'bigint') AS writes,
n.value('(data[@name="row_count"]/value)[1]', 'bigint') AS row_count,
n.value('(data[@name="last_row_count"]/value)[1]', 'bigint') AS last_row_count,
n.value('(data[@name="line_number"]/value)[1]', 'bigint') AS line_number,
n.value('(data[@name="offset"]/value)[1]', 'bigint') AS offset,
n.value('(data[@name="offset_end"]/value)[1]', 'bigint') AS offset_end,
n.value('(action[@name="database_name"]/value)[1]', 'nvarchar(128)') AS database_name,
n.value('(action[@name="nt_username"]/value)[1]', 'nvarchar(128)') AS nt_username,
n.value('(action[@name="username"]/value)[1]', 'nvarchar(128)') AS username,
n.value('(action[@name="plan_handle"]/value)[1]', 'nvarchar(128)') AS plan_handle,
n.value('(action[@name="query_hash"]/value)[1]', 'nvarchar(128)') AS query_hash,
n.value('(action[@name="query_hash_signed"]/value)[1]', 'nvarchar(128)') AS query_hash_signed,
n.value('(action[@name="session_id"]/value)[1]', 'int') AS session_id,
n.value('(data[@name="statement"]/value)[1]', 'nvarchar(max)') AS statement,
n.value('(action[@name="sql_text"]/value)[1]', 'nvarchar(max)') AS sql_text,
@ExtendedEventSessionName AS SessionName,
@SessionFilePathName AS SessionFilePathName
FROM (SELECT CAST(event_data AS XML) AS event_data
FROM sys.fn_xe_file_target_read_file(@SessionFilePathName, NULL, NULL, NULL)) ed
CROSS APPLY ed.event_data.nodes('event') AS q(n)
--WHERE n.value('(action[@name="nt_username"]/value)[1]', 'nvarchar(128)') = 'WSECU\CalebM'

--WSECU\gvcSsisSql02$
--WSECU\gvcEDWSQL$

--(4730 rows affected)
/*
SELECT
CONVERT(CHAR(10), DATEADD(HOUR, -7,[utc_timestamp]), 121) AS DatetimeStamp
,[username]
,[database_name]
,SUM([duration] / 1000000) AS DurationInSeconds
,Utilities.udfFormatTime(SUM([duration] / 1000000), 'S', '%H% Hr %M% Min %S% Sec') TotalDuration
,SUM([cpu] / 1000000) AS CPUDurationInSeconds
,Utilities.udfFormatTime(SUM([cpu] / 1000000), 'S', '%H% Hr %M% Min %S% Sec') AS CPUTotalDuration
,SUM([logical_reads]) AS LogicalReads
,SUM([physical_reads]) AS PysicalReads
,SUM([writes]) AS Writes
,SUM([row_count]) AS [RowCount]
,COUNT(1) AS SQLCount
FROM [DBAUtility].[EventDataETL].[LongRunningQueries]
WHERE [username] NOT IN ('WSECU\gvcSSISSQL02$','WSECU\gvcEDWSQL$','WSECU\adminwillb','WSECU\adminseanb','WSECU\gvcSSISSQL03$')
GROUP BY CONVERT(CHAR(10), DATEADD(HOUR, -7,[utc_timestamp]), 121)
,[username]
,[database_name]

ORDER BY CONVERT(CHAR(10), DATEADD(HOUR, -7,[utc_timestamp]), 121) DESC
,[username]
,[database_name]
*/