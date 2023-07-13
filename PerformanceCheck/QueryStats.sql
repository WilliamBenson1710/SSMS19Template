SELECT TOP 100
       OBJECT_SCHEMA_NAME(qt.objectid, dbid) + '.' + OBJECT_NAME(qt.objectid, qt.dbid) AS ObjectName,
       SUBSTRING(   qt.text,
                    (qs.statement_start_offset / 2) + 1,
                    ((CASE statement_end_offset
                          WHEN -1 THEN
                              DATALENGTH(qt.text)
                          ELSE
                              qs.statement_end_offset
                      END - qs.statement_start_offset
                     ) / 2
                    ) + 1
                ) AS StatementText,
       ---- Query within the proc
       qt.text AS TextData,
       ---- The SQL Text that was executed
       qs.total_physical_reads AS DiskReads,
       ---- The worst reads, disk reads
       qs.total_logical_reads AS MemoryReads,
       ---- Logical Reads are memory reads
       qs.execution_count AS Executions,
       ---- the counts of the query being executed since reboot
       qs.total_worker_time / 1000 AS TotalCPUTime_ms,
       ---- The CPU time that the query consumes
       qs.total_worker_time / (1000 * qs.execution_count) AS AverageCPUTime_ms,
       ---- the Average CPU Time for the query
       qs.total_elapsed_time / (1000 * qs.execution_count) AS AvgDiskWaitAndCPUTime_ms,
       ---- the average duration to execute the plan - CPU and Disk
       qs.max_logical_writes AS MemoryWrites,
       qs.creation_time AS DateCached,
       DB_NAME(qt.dbid) AS DatabaseName,
       qs.last_execution_time AS LastExecutionTime
FROM sys.dm_exec_query_stats AS qs
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt

--WHERE DB_Name(qt.dbid) = 'DW_FICS_Red'
WHERE CHARINDEX('[DS_Symitar]', qt.text) > 0
      AND CHARINDEX('convert', qt.text) > 0
----connect and give your db name here (cross db works fine in on-premises and not works on Azure)
--ORDER BY qs.total_worker_time DESC 
---- (Most CPU usage = Worst performing CPU bound queries)
--ORDER BY qs.total_worker_time/qs.execution_count DESC 
---- highest average CPU usage
--ORDER BY qs.total_elapsed_time/(1000*qs.execution_count) DESC 
---- highest average w/ wait time
ORDER BY qs.total_worker_time / (1000 * qs.execution_count) DESC;
---- (Memory Reads = Worst performing I/O bound queries)