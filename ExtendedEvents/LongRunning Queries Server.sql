CREATE EVENT SESSION [LongRunningQueriesServer] ON SERVER 
ADD EVENT sqlserver.sql_statement_completed(SET collect_statement=(1)
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_id,sqlserver.database_name,sqlserver.execution_plan_guid,sqlserver.nt_username,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_hash_signed,sqlserver.session_id,sqlserver.session_nt_username,sqlserver.sql_text,sqlserver.username)
    WHERE ([package0].[greater_than_equal_int64]([duration],(1000000)) AND [sqlserver].[not_equal_i_sql_unicode_string]([sqlserver].[session_nt_user],N'WSECU\gvc%')))
ADD TARGET package0.event_file(SET filename=N'R:\ExtendedEvents\LongRunningQueriesServer\LongRunningQueriesServer',max_file_size=(100),max_rollover_files=(10))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=NO_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=ON)
GO


