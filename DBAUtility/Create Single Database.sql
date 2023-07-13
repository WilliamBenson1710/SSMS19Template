USE master
GO

DECLARE @prDatabaseNameToCreate sysname = 'eStatements'
,@prDefaultDatabaseSizeKB NVARCHAR(100) = '10000KB'
, @prDefaultLogSizeKB NVARCHAR(100) = '10000KB'
, @prIsSimpleRecovery BIT = 1
, @prDebug BIT = 0


EXEC [DBAUtility].[Utilities].[uspCreateDatabaseFromScratch]
@DataBaseName = @prDatabaseNameToCreate
,@DefaultDatabaseSizeKB = @prDefaultDatabaseSizeKB 
,@DefaultLogSizeKB = @prDefaultLogSizeKB
,@IsSimpleRecovery = @prIsSimpleRecovery
,@Debug = @prDebug
;