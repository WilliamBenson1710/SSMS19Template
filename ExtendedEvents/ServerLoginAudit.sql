CREATE EVENT SESSION [ServerLoginAudit] ON SERVER 
ADD EVENT sqlserver.connectivity_ring_buffer_recorded(
    ACTION(sqlserver.client_app_name,sqlserver.client_connection_id,sqlserver.client_hostname,sqlserver.context_info,sqlserver.database_id,sqlserver.database_name,sqlserver.is_system,sqlserver.nt_username,sqlserver.server_principal_name,sqlserver.session_id,sqlserver.username)),
ADD EVENT sqlserver.login(SET collect_options_text=(1)
    ACTION(sqlserver.client_app_name,sqlserver.client_connection_id,sqlserver.client_hostname,sqlserver.context_info,sqlserver.database_id,sqlserver.database_name,sqlserver.nt_username,sqlserver.server_instance_name,sqlserver.server_principal_name,sqlserver.username)),
ADD EVENT sqlserver.logout(
    ACTION(sqlserver.client_app_name,sqlserver.client_connection_id,sqlserver.client_hostname,sqlserver.context_info,sqlserver.database_id,sqlserver.database_name,sqlserver.nt_username,sqlserver.server_instance_name,sqlserver.server_principal_name,sqlserver.session_id,sqlserver.username))
ADD TARGET package0.event_file(SET filename=N'F:\ExtendedEvents\ServerLoginAudit\ServerLoginAudit')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=ON)
GO


USE master;
GO
-- Create the Event Session
IF EXISTS
    (
        SELECT
                  *
            FROM  sys.server_event_sessions
            WHERE name = 'ServerLoginAudit'
    )
    DROP EVENT SESSION ServerLoginAudit ON SERVER;
GO
--EXECUTE xp_create_subdir 'D:\audits\Sessions';
--GO
CREATE EVENT SESSION ServerLoginAudit
    ON SERVER
    ADD EVENT sqlserver.login
        (SET
             collect_database_name = (1)
           , collect_options_text = (1)
         ACTION
             (
                 sqlserver.sql_text
               , sqlserver.nt_username
               , sqlserver.server_principal_name
               , sqlserver.client_hostname
               , package0.collect_system_time
               , package0.event_sequence
               , sqlserver.database_id
               , sqlserver.database_name
               , sqlserver.username
               , sqlserver.session_nt_username
               , sqlserver.client_app_name
               , sqlserver.session_id
               , sqlserver.context_info
               , sqlserver.client_connection_id
             )
        )

    ADD TARGET package0.event_file
        (SET filename = N'F:\ExtendedEvents\ServerLoginAudit.xel', max_file_size = (20), max_rollover_files = (2))
    WITH
        (
            STARTUP_STATE = OFF
          , TRACK_CAUSALITY = ON
        );
/* start the session */
ALTER EVENT SESSION ServerLoginAudit ON SERVER STATE = START;
GO