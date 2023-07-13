/* https://learn.microsoft.com/en-us/sql/t-sql/functions/databasepropertyex-transact-sql?view=sql-server-ver16 */

DECLARE @DatabaseName AS sysname = 'DBAUtility'

SELECT
@@ServerName AS ServerName,
@DatabaseName AS [DatabaseName],
DATABASEPROPERTYEX(@DatabaseName, 'IsAutoShrink') AS [Auto Shrink],
DATABASEPROPERTYEX(@DatabaseName, 'IsAutoUpdateStatistics') AS [Auto stats],
DATABASEPROPERTYEX(@DatabaseName, 'IsAutoClose') AS [Auto Close],
DATABASEPROPERTYEX(@DatabaseName, 'IsAutoCreateStatistics') AS [Auto Create Stats],
DATABASEPROPERTYEX(@DatabaseName, 'IsAutoCreateStatisticsIncremental') AS [Auto Create StatsIncremental],
DATABASEPROPERTYEX(@DatabaseName, 'Recovery') AS [Version],
DATABASEPROPERTYEX(@DatabaseName,  'IsFulltextEnabled') AS [FullText],
DATABASEPROPERTYEX(@DatabaseName, 'Version') AS [Version],
DATABASEPROPERTYEX(@DatabaseName, 'Status') AS [Status],
DATABASEPROPERTYEX(@DatabaseName, 'UserAccess') AS [User access],
DATABASEPROPERTYEX(@DatabaseName, 'Updateability') AS [Updateability]
Go