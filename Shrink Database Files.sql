USE [xxxxx]
GO

/*
This script is used to shrink a database file in
increments until it reaches a target free space limit.
Run this script in the database with the file to be shrunk.
1. Set @DBFileName to the name of database file to shrink.
2. Set @TargetFreeMB to the desired file free space in MB after shrink.
3. Set @ShrinkIncrementMB to the increment to shrink file by in MB
4. Run the script
*/

DECLARE @DBFileName sysname = 'xxxxx' /* Set Name of Database file to shrink */
, @TargetFreeMB INT = 50000 /* Set Desired file free space in MB after shrink */
, @ShrinkIncrementMB INT = 2000 /* Set Increment to shrink file by in MB */
, @ShowFinalResults BIT = 0
, @Debug INT = 0

BEGIN	
	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @SQLStatement varchar(8000)
		, @InitalSizeMB DECIMAL(18,5)
		, @InitalUsedMB DECIMAL(18,5)
		, @CurrentSizeMB DECIMAL(18,5)
		, @CurrentUsedMB DECIMAL(18,5)
		, @FinalTargetedDatabaseSize AS DECIMAL(18,5)
		, @NextShrinkSize INT
		, @RaiseErrorNoWaitMessage NVARCHAR(4000);

		/* Used for the details of the exception */
		DECLARE @ErrMsg NVARCHAR(4000)
		, @ErrorMessage NVARCHAR(4000)
		, @ErrorSeverity SMALLINT
		, @E_DatabaseName VARCHAR(100)
		, @E_SchemaName VARCHAR(100)
		, @E_ProcedureName VARCHAR(255)
		, @E_ErrorLineNumber AS SMALLINT;

		/* Show Size, Space Used, Unused Space, and Name of all database files */
		IF @Debug = 1
		BEGIN
			SELECT
			[FileSizeMB] = convert(numeric(10,2),round(a.size/128.,2)),
			[UsedSpaceMB]= convert(numeric(10,2),round(fileproperty( a.name,'SpaceUsed')/128.,2)) ,
			[UnusedSpaceMB]= convert(numeric(10,2),round((a.size-fileproperty( a.name,'SpaceUsed'))/128.,2)) ,
			[DBFileName]= a.[name]
			FROM sys.database_files AS a;
		END

		/*  Get current file size in MB */
		SELECT @InitalSizeMB = size/128. FROM sys.database_files WHERE [name] = @DBFileName;

		/* Get current space used in MB */
		SELECT @InitalUsedMB = fileproperty( @DBFileName,'SpaceUsed')/128.0;

		SELECT
		@FinalTargetedDatabaseSize = @InitalUsedMB + @TargetFreeMB + @ShrinkIncrementMB
		,@CurrentSizeMB = @InitalSizeMB
		,@CurrentUsedMB = @InitalUsedMB;

		IF @Debug = 1
		BEGIN
			PRINT '/----------------------- Debug Info ----------------------------------/'
			PRINT '@InitalSizeMB: ' + ISNULL(CAST(@InitalSizeMB AS VARCHAR(100)), 'NULL');
			PRINT '@InitalUsedMB: ' + ISNULL(CAST(@InitalUsedMB AS VARCHAR(100)), 'NULL');
			PRINT '@TargetFreeMB: ' + ISNULL(CAST(@TargetFreeMB AS VARCHAR(100)), 'NULL');
			PRINT '@CurrentSizeMB: ' + ISNULL(CAST(@CurrentSizeMB AS VARCHAR(100)), 'NULL');
			PRINT '@CurrentUsedMB: ' + ISNULL(CAST(@CurrentUsedMB AS VARCHAR(100)), 'NULL');
			PRINT '@ShrinkIncrementMB: ' + ISNULL(CAST(@ShrinkIncrementMB AS VARCHAR(100)), 'NULL');
			PRINT '@FinalTargetedDatabaseSize: ' + ISNULL(CAST(@FinalTargetedDatabaseSize AS VARCHAR(100)), 'NULL');
		END

		SELECT @RaiseErrorNoWaitMessage =  '[Shrink Starting Point] - [InitalSizeMB:' + CONVERT(NVARCHAR(500),@InitalSizeMB) + '] - [InitalUsedMB:' + CONVERT(NVARCHAR(500),@InitalUsedMB) + '] - [FinalTargetedDatabaseSizeMB:' + CONVERT(NVARCHAR(500),@FinalTargetedDatabaseSize) + ']';
		RAISERROR (@RaiseErrorNoWaitMessage, 0, 1) WITH NOWAIT;

		/* Loop until file at desired size */
		WHILE  @CurrentSizeMB > @FinalTargetedDatabaseSize
		BEGIN 
			
			SELECT @NextShrinkSize = @CurrentSizeMB - @ShrinkIncrementMB;
			
			SELECT @SQLStatement = 'DBCC SHRINKFILE (N' + CHAR(39) + @DBFileName + CHAR(39) + ', ' + convert(NVARCHAR(500),@NextShrinkSize) +') WITH NO_INFOMSGS';
 
			IF @Debug = 1
				BEGIN
					PRINT '[Starting] - ' + @SQLStatement + ' at ' + convert(varchar(30),getdate(),121);
				END 
		
			BEGIN TRY		
				--EXEC (@SQLStatement);

				SELECT @RaiseErrorNoWaitMessage = '[Completed] - ' + @SQLStatement + ' at ' + convert(varchar(30),getdate(),121);
				RAISERROR (@RaiseErrorNoWaitMessage, 0, 1) WITH NOWAIT;
			END TRY
			BEGIN CATCH
				SELECT @ErrorSeverity = ERROR_SEVERITY()
				, @ErrorMessage = ERROR_MESSAGE()
				, @E_DatabaseName = DB_NAME()
				, @E_SchemaName = OBJECT_SCHEMA_NAME(@@PROCID)
				, @E_ProcedureName = OBJECT_NAME(@@PROCID) 
				, @E_ErrorLineNumber = ERROR_LINE();
				
				SELECT @ErrMsg = @ErrorMessage + ' Occurred at Line_Number: ' + CAST(ERROR_LINE() AS VARCHAR(50)) + ' (Severity ' + CAST(@ErrorSeverity AS VARCHAR) + ')';

				RAISERROR (@ErrMsg, 18, 1);
						
				RETURN;
			END CATCH
 
			/* Get current file size in MB */
			select @CurrentSizeMB = size/128. from sys.database_files where name = @DBFileName;
 
			/* Get current space used in MB */
			select @CurrentUsedMB = fileproperty( @DBFileName,'SpaceUsed')/128.0;

			IF @Debug = 1
			BEGIN
				PRINT '@CurrentSizeMB: ' + ISNULL(CAST(@CurrentSizeMB AS VARCHAR(100)), 'NULL');
				PRINT '@CurrentUsedMB: ' + ISNULL(CAST(@CurrentUsedMB AS VARCHAR(100)), 'NULL');
			END
		END

		IF @Debug = 1 OR @ShowFinalResults = 1
		BEGIN	
			PRINT 'DatabaseFileName: ' + ISNULL(CAST(@DBFileName AS VARCHAR(100)), 'NULL') ;
			PRINT 'EndFileSizeMB: ' + ISNULL(CAST(@CurrentSizeMB AS VARCHAR(100)), 'NULL') ;
			PRINT 'EndUsedSpaceMB: ' + ISNULL(CAST(@CurrentUsedMB AS VARCHAR(100)), 'NULL') ;
			SELECT [EndFileSize] = @CurrentSizeMB, [EndUsedSpace] = @CurrentUsedMB, [DBFileName] = @DBFileName;
		END

		SELECT @RaiseErrorNoWaitMessage =  '[Shrink Complete] - [CurrentSizeMB:' + CONVERT(NVARCHAR(500),@CurrentSizeMB) + '] - [CurrentUsedMB:' + CONVERT(NVARCHAR(500),@CurrentUsedMB) + ']';
		RAISERROR (@RaiseErrorNoWaitMessage, 0, 1) WITH NOWAIT;
	END TRY
	BEGIN CATCH
		SELECT @ErrorSeverity = ERROR_SEVERITY()
		, @ErrorMessage = ERROR_MESSAGE()
		, @E_DatabaseName = DB_NAME()
		, @E_SchemaName = OBJECT_SCHEMA_NAME(@@PROCID)
		, @E_ProcedureName = OBJECT_NAME(@@PROCID) 
		, @E_ErrorLineNumber = ERROR_LINE();

		SELECT @ErrMsg = @ErrorMessage + ' Occurred at Line_Number: ' + CAST(ERROR_LINE() AS VARCHAR(50)) + ' (Severity ' + CAST(@ErrorSeverity AS VARCHAR) + ')';

		RAISERROR (@ErrMsg, 18, 1);
	END CATCH
END