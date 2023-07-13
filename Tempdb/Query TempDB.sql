SELECT name
FROM tempdb.sys.tables
WHERE name LIKE '#%';

--First part of the script
SELECT instance_name AS 'Database',
[Data File(s) Size (KB)]/1024 AS [Data file (MB)],
[Log File(s) Size (KB)]/1024 AS [Log file (MB)],
[Log File(s) Used Size (KB)]/1024 AS [Log file space used (MB)]
FROM (SELECT * FROM sys.dm_os_performance_counters
WHERE counter_name IN
('Data File(s) Size (KB)',
'Log File(s) Size (KB)',
'Log File(s) Used Size (KB)')
AND instance_name = 'tempdb') AS A
PIVOT
(MAX(cntr_value) FOR counter_name IN
([Data File(s) Size (KB)],
[LOG File(s) Size (KB)],
[Log File(s) Used Size (KB)])) AS B
GO
--
--Second part of the script
SELECT create_date AS [Creation date],
recovery_model_desc [Recovery model]
FROM sys.databases WHERE name = 'tempdb'
GO

SELECT tb.name AS [Temporary table name],
stt.row_count AS [Number of rows], 
stt.used_page_count * 8 AS [Used space (KB)], 
stt.reserved_page_count * 8 AS [Reserved space (KB)] FROM tempdb.sys.partitions AS prt 
INNER JOIN tempdb.sys.dm_db_partition_stats AS stt 
ON prt.partition_id = stt.partition_id 
AND prt.partition_number = stt.partition_number 
INNER JOIN tempdb.sys.tables AS tb 
ON stt.object_id = tb.object_id 
ORDER BY tb.name



WITH TempResultsCTE
AS
(SELECT s.login_name, s.session_id, tsu.exec_context_id,
CASE WHEN tsu.user_objects_alloc_page_count > tsu.user_objects_dealloc_page_count
THEN (tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count)/128
ELSE 0
END AS user_objects_MB,
CASE WHEN tsu.internal_objects_alloc_page_count > tsu.internal_objects_dealloc_page_count
THEN (tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count)/128
ELSE 0
END AS internal_objects_MB,
er.sql_handle,
er.plan_handle,
er.statement_start_offset,
er.statement_end_offset
FROM sys.dm_exec_requests er INNER JOIN sys.dm_exec_sessions s
ON er.session_id = s.session_id
INNER JOIN sys.dm_db_task_space_usage tsu ON er.session_id = tsu.session_id
WHERE s.is_user_process = 1)
SELECT login_name, session_id, exec_context_id,
user_objects_MB + internal_objects_MB as total_objects_MB,
user_objects_MB, internal_objects_MB,
CONVERT(XML, qp.query_plan) AS query_plan,
SUBSTRING(st.text, (tr.statement_start_offset/2)+1,
((CASE tr.statement_end_offset
WHEN -1 THEN DATALENGTH(st.text)
ELSE tr.statement_end_offset
END - tr.statement_start_offset)/2) + 1) AS statement_text,
st.text AS full_statement_text
FROM TempResultsCTE tr
CROSS APPLY sys.dm_exec_sql_text(tr.sql_handle) st
CROSS APPLY sys.dm_exec_text_query_plan(tr.plan_handle, tr.statement_start_offset, tr.statement_end_offset) qp
WHERE tr.user_objects_MB + tr.internal_objects_MB > 0
ORDER BY tr.user_objects_MB + tr.internal_objects_MB DESC;
WITH IdleTempResultsCTE
AS
(SELECT s.login_name, s.session_id,
CASE WHEN ssu.user_objects_alloc_page_count > ssu.user_objects_dealloc_page_count
THEN (ssu.user_objects_alloc_page_count - ssu.user_objects_dealloc_page_count)/128
ELSE 0
END AS user_objects_MB,
CASE WHEN ssu.internal_objects_alloc_page_count > ssu.internal_objects_dealloc_page_count
THEN (ssu.internal_objects_alloc_page_count - ssu.internal_objects_dealloc_page_count)/128
ELSE 0
END AS internal_objects_MB,
er.sql_handle,
er.plan_handle,
er.statement_start_offset,
er.statement_end_offset
FROM sys.dm_exec_requests er INNER JOIN sys.dm_exec_sessions s ON er.session_id = s.session_id
INNER JOIN sys.dm_db_session_space_usage ssu ON er.session_id = ssu.session_id
WHERE s.is_user_process = 1 AND s.status = 'sleeping')
SELECT login_name, session_id,
user_objects_MB + internal_objects_MB as total_objects_MB,
user_objects_MB, internal_objects_MB,
CONVERT(XML, qp.query_plan) AS query_plan,
SUBSTRING(st.text, (tr.statement_start_offset/2)+1,
((CASE tr.statement_end_offset
WHEN -1 THEN DATALENGTH(st.text)
ELSE tr.statement_end_offset
END - tr.statement_start_offset)/2) + 1) AS statement_text,
st.text AS full_statement_text
FROM IdleTempResultsCTE tr
CROSS APPLY sys.dm_exec_sql_text(tr.sql_handle) st
CROSS APPLY sys.dm_exec_text_query_plan(tr.plan_handle, tr.statement_start_offset, tr.statement_end_offset) qp
WHERE tr.user_objects_MB + tr.internal_objects_MB > 0
ORDER BY tr.user_objects_MB + tr.internal_objects_MB DESC