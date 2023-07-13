USE [DBAUtility]
GO

/****** Object:  UserDefinedFunction [Utilities].[fnGetDatabaseList]    Script Date: 1/17/2023 8:41:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- User Defined Function

/*************************************************************************************************
*** OBJECT NAME                                                                                ***
**************************************************************************************************
[Utilities].[fnGetCalendarDatesRange]
**************************************************************************************************
*** DESCRIPTION                                                                                ***
**************************************************************************************************

**************************************************************************************************
*** CHANGE HISTORY                                                                             ***
**************************************************************************************************
2023-01-17 - Created by william.benson
**************************************************************************************************
*** PERFORMANCE HISTORY                                                                        ***
**************************************************************************************************
**************************************************************************************************
*** TEST SCRIPT                                                                                ***
**************************************************************************************************

SELECT
CalendarDateRange
FROM [Utilities].[fnGetCalendarDatesRange]('2022-01-01A','2023-01-01')
;
**************************************************************************************************/
CREATE OR ALTER FUNCTION [Utilities].[fnGetCalendarDatesRange]
(@CalendarStartDate AS DATE
,@CalendarEndDate AS DATE)

RETURNS @Result TABLE
(CalendarDateRange DATE)

AS

BEGIN
	
	;WITH seq(n) AS 
	(
	  SELECT 0 UNION ALL SELECT n + 1 FROM seq
	  WHERE n < DATEDIFF(DAY, @CalendarStartDate, @CalendarEndDate)
	),
	d(d) AS 
	(
	  SELECT DATEADD(DAY, n, @CalendarStartDate) FROM seq
	)
	INSERT INTO @Result
	(
	    CalendarDateRange
	)
	SELECT d FROM d
	ORDER BY d
	OPTION (MAXRECURSION 0);


	RETURN

END
GO


