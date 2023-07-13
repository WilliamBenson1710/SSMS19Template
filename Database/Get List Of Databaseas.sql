SELECT
*
FROM sys.databases
WHERE [name] NOT IN ('DBAUtility','master','model','msdb','LiteSpeedLocal','tempdb','SSIDB')
ORDER BY [name]