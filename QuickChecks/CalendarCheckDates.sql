DECLARE @CurrentDate DATE
,@StartDate  DATE
,@CutoffDate DATE

DECLARE @CalendarDates AS TABLE(CalDate DATE);
DECLARE @SummaryDatesFromTable AS TABLE(CalDate DATE, RecordCounts INT);

SELECT @CurrentDate = CONVERT(CHAR(10), SYSDATETIME(),121);

SELECT @StartDate = DATEADD(DAY,-180, @CurrentDate);

SELECT @CutoffDate = DATEADD(DAY,-1, @CurrentDate);

--SELECT
--@CurrentDate AS CurrentDate
--, @StartDate AS StartDate
--,@CutoffDate AS CutoffDate

;WITH seq(n) AS 
(
  SELECT 0 UNION ALL SELECT n + 1 FROM seq
  WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
),
d(d) AS 
(
  SELECT DATEADD(DAY, n, @StartDate) FROM seq
)
INSERT INTO @CalendarDates(CalDate)
SELECT d FROM d
ORDER BY d
OPTION (MAXRECURSION 0);

/* Get Sumamry Data from table */
INSERT INTO @SummaryDatesFromTable(CalDate,RecordCounts)
SELECT
[FullDate]
,COUNT(1) AS RC
FROM [PLModelSupport].[dsModels].[personalLoanShare180]
WHERE IsDeleted = 0
GROUP BY [FullDate]
ORDER BY [FullDate] DESC


SELECT
src.CalDate AS CalendarDates
,trgt.CalDate AS SummaryDates
,COALESCE(trgt.RecordCounts,0) AS RecordCounts
FROM @CalendarDates AS src
LEFT OUTER JOIN @SummaryDatesFromTable AS trgt
	ON src.CalDate = trgt.CalDate
WHERE trgt.CalDate IS NULL /* Remark Out to see all data rows */
ORDER BY src.CalDate DESC


