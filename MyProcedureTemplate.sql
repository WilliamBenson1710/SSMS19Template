USE [YourDatabase]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*************************************************************************************************
*** OBJECT NAME                                                                                ***
**************************************************************************************************

**************************************************************************************************
*** DESCRIPTION                                                                                ***
**************************************************************************************************

**************************************************************************************************
*** CHANGE HISTORY                                                                             ***
**************************************************************************************************

**************************************************************************************************
*** PERFORMANCE HISTORY                                                                        ***
**************************************************************************************************
 
**************************************************************************************************
*** TEST SCRIPT                                                                                ***
**************************************************************************************************

**************************************************************************************************/
CREATE OR ALTER PROCEDURE [].[]
@Debug BIT = 0
AS 

SET NOCOUNT ON;

/* Used for the details of the exception */
DECLARE @ErrMsg NVARCHAR(4000)
, @ErrorMessage NVARCHAR(4000)
, @ErrorSeverity SMALLINT
, @E_DatabaseName VARCHAR(100)
, @E_SchemaName VARCHAR(100)
, @E_ProcedureName VARCHAR(255)
, @E_ErrorLineNumber AS SMALLINT
;

BEGIN TRY
	IF @Debug = 1
	BEGIN
		PRINT '------------ Debug Inoformation ----------------' ;
		--PRINT '@YourVariable: ' + ISNULL(CAST(@YourVariable AS VARCHAR(100)), 'NULL') ;
	END


	IF @Debug = 1
	BEGIN
		PRINT '------------ End Debug Inoformation ----------------' ;
	END

END TRY
BEGIN CATCH

	SELECT @ErrorSeverity = ERROR_SEVERITY()
	, @ErrorMessage = ERROR_MESSAGE()
	, @E_DatabaseName = DB_NAME()
	, @E_SchemaName = OBJECT_SCHEMA_NAME(@@PROCID)
	, @E_ProcedureName = OBJECT_NAME(@@PROCID) 
	, @E_ErrorLineNumber = ERROR_LINE();                   
                
	SET @ErrMsg = @ErrorMessage + ' Occurred at Line_Number: ' + CAST(ERROR_LINE() AS VARCHAR(50)) + ' (Severity ' + CAST(@ErrorSeverity AS VARCHAR) + ')'
	RAISERROR (@ErrMsg, 18, 1) ;

END CATCH