DECLARE @DatabasesToProcess INT = 0
, @DatabaseLoopCounter INT = 1
, @DatabaseNameToCreate sysname = ''
, @SQLStatement NVARCHAR(MAX) = ''
, @ErrorMessage NVARCHAR(4000)
, @CreateDatabase BIT = 1
 ,@CreateDatabaseOverRide BIT = 1
 ,@RunCreateScript BIT = 0
 ,@Debug BIT = 1

/* Used for create database procedure */
DECLARE @prDefaultDatabaseSizeKB NVARCHAR(100) = '10000KB'
, @prDefaultLogSizeKB NVARCHAR(100) = '10000KB'
, @prIsSimpleRecovery BIT = 1
, @prDebug BIT = 0

DECLARE @ListOfDatabase AS TABLE (RecordId INT IDENTITY(1,1), DatabseName sysname NOT NULL)


INSERT INTO @ListOfDatabase(DatabseName)
VALUES
('access_control')
,('action_service')
,('arrangement_manager')
,('audit_service')
,('backbase_identity')

SELECT @DatabasesToProcess = @@ROWCOUNT;

IF @Debug = 1
BEGIN
	PRINT '------------ Debug Inoformation ----------------' ;
	PRINT '@DatabaseLoopCounter: ' + ISNULL(CAST(@DatabaseLoopCounter AS NVARCHAR(250)), 'NULL') ;
	PRINT '@DatabasesToProcess: ' + ISNULL(CAST(@DatabasesToProcess AS NVARCHAR(250)), 'NULL') ;
END

WHILE @DatabaseLoopCounter <= @DatabasesToProcess
BEGIN

	SELECT @DatabaseNameToCreate = DatabseName
	FROM @ListOfDatabase
	WHERE RecordId = @DatabaseLoopCounter

	IF @Debug = 1
	BEGIN
		PRINT '------------ Database Loop Start ----------------' ;
		PRINT '@DatabaseNameToCreate: ' + ISNULL(CAST(@DatabaseNameToCreate AS NVARCHAR(250)), 'NULL') ;
	END

	IF EXISTS(SELECT [name] AS DatabseCount FROM sys.databases WHERE name = @DatabaseNameToCreate)
	BEGIN
		
		IF @CreateDatabaseOverRide = 1
		BEGIN
			EXEC('DROP DATABASE [' + @DatabaseNameToCreate + '];')

			IF @Debug = 1
			BEGIN
				PRINT 'Dropping Database: ' + ISNULL(CAST(@DatabaseNameToCreate AS NVARCHAR(250)), 'NULL') ;
			END
			
			SELECT @CreateDatabase = 1
		END
		ELSE
		BEGIN
				SELECT @ErrorMessage = 'Database already exists: ' + @DatabaseNameToCreate + '.';

				SELECT @CreateDatabase = 0

				RAISERROR (@ErrorMessage, 16, 1, 0, 0) WITH NOWAIT;

				RETURN;
		END
	END

	IF @CreateDatabase = 1	
		BEGIN			
			
			IF @Debug = 1
			BEGIN
				PRINT '------------ Database Create Variables ----------------' ;
				PRINT '@prDefaultDatabaseSizeKB: ' + ISNULL(CAST(@prDefaultDatabaseSizeKB AS NVARCHAR(250)), 'NULL') ;	
				PRINT '@prDefaultLogSizeKB: ' + ISNULL(CAST(@prDefaultLogSizeKB AS NVARCHAR(250)), 'NULL') ;
				PRINT '@prIsSimpleRecovery: ' + ISNULL(CAST(@prIsSimpleRecovery AS NVARCHAR(250)), 'NULL') ;
				PRINT '@prDebug: ' + ISNULL(CAST(@prDebug AS NVARCHAR(250)), 'NULL') ;
			END
			
			SELECT @SQLStatement = 'EXEC [DBAUtility].[Utilities].[uspCreateDatabaseFromScratch]'
				+ '@DataBaseName = ' + CHAR(39) + @DatabaseNameToCreate + CHAR(39) + CHAR(13)
				+ ',@DefaultDatabaseSizeKB = ' + CHAR(39) + @prDefaultDatabaseSizeKB + CHAR(39) + CHAR(13)
				+ ',@DefaultLogSizeKB = ' + CHAR(39) + @prDefaultLogSizeKB + CHAR(39) + CHAR(13)
				+ ',@IsSimpleRecovery = ' + CHAR(39) + CONVERT(CHAR(1),@prIsSimpleRecovery) + CHAR(39) + CHAR(13)
				+ ',@Debug = '  + CHAR(39) + CONVERT(CHAR(1),@prDebug) + CHAR(39) + CHAR(13)
				+ ';'

			IF @Debug = 1
			BEGIN
				PRINT '------------ View SQL Statement ----------------' ;
				PRINT '@SQLStatement: ' + ISNULL(CAST(@SQLStatement AS NVARCHAR(MAX)), 'NULL') ;	
			END

			IF @SQLStatement IS NOT NULL
			BEGIN
				SELECT @RunCreateScript = 1
			END

			IF @RunCreateScript = 1
			BEGIN
				EXEC(@SQLStatement);
			END
		END




	--IF @CreateDatabaseOverRide = 1 AND @DatabaseExists = 1
	--BEGIN
	--	EXEC('DROP DATABASE [' + @DatabaseNameToCreate + '];')
	--END



	SELECT @DatabaseLoopCounter = @DatabaseLoopCounter +1

	PRINT '------------ Database Loop End ------------------' ;
END
