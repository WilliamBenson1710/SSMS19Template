EXEC [Utilities].[uspdsModelsPersonalLoanShare180_CheckDataDates]
@EmailRecipients = 'wbenson@wsecu.org'
,@Debug = 0

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


/*************************************************************************************************
*** OBJECT NAME                                                                                ***
**************************************************************************************************
[Utilities].[uspdsModelsPersonalLoanShare180_CheckDataDates]
**************************************************************************************************
*** DESCRIPTION                                                                                ***
**************************************************************************************************
KIll SPID based on a user id
**************************************************************************************************
*** CHANGE HISTORY                                                                             ***
**************************************************************************************************
2021-11-02: Created by william benson
**************************************************************************************************
*** PERFORMANCE HISTORY                                                                        ***
**************************************************************************************************
 
**************************************************************************************************
*** TEST SCRIPT                                                                                ***
**************************************************************************************************
EXEC [Utilities].[uspdsModelsPersonalLoanShare180_CheckDataDates]
@EmailRecipients = 'wbenson@wsecu.org'
,@Debug = 0

EXEC [Utilities].[uspdsModelsPersonalLoanShare180_CheckDataDates]
@CheckStartDate = '2022-12-01'
,@CheckEndDate = '2023-01-01
,@DaysToGoBack = -180
,@Debug = 1
**************************************************************************************************/
CREATE   PROC [Utilities].[uspdsModelsPersonalLoanShare180_CheckDataDates]
@CheckStartDate AS DATE = NULL
,@CheckEndDate AS DATE = NULL
,@DaysToGoBack AS INT = -180
,@EmailRecipients NVARCHAR(MAX) = 'wbenson@wsecu.org'
,@MailProfile NVARCHAR(250) = 'DBA Team'
,@FailProcess BIT = 1
,@SendEmailNotification BIT = 1
,@Debug BIT = 0

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @CurrentDate AS DATE = NULL
	,@M_ErrorMessage NVARCHAR(250)
	,@Subject AS VARCHAR(250) --Subject of the email
	,@Message AS NVARCHAR(MAX) --Mesage body of the email
	,@SendEmail BIT = 0
	,@ServerType AS VARCHAR(50)
	,@ServerName AS VARCHAR(50)
	,@MailProfileToUse AS NVARCHAR(250)
	,@MissingDatesRowCount INT = 0
	--,@MailProfile NVARCHAR(250) = NULL
	;

	DECLARE @CalendarDates AS TABLE(CalDate DATE);
	DECLARE @MissingSummaryDates AS TABLE(CalDate DATE);
	DECLARE @SummaryDatesFromTable AS TABLE(CalDate DATE, RecordCounts INT);

	SELECT @CurrentDate = CONVERT(CHAR(10), SYSDATETIME(),121);

	--IF ISDATE(@CheckStartDate) = 0
	--BEGIN

	--	PRINT 'ERROR'

	--END

	--IF ISDATE(@CheckEndDate) = 0
	--BEGIN

	--	PRINT 'ERROR'

	--END

	IF @CheckStartDate IS NULL
	BEGIN

		SELECT @CheckStartDate = DATEADD(DAY,@DaysToGoBack, @CurrentDate);

	END

	IF @CheckEndDate IS NULL
	BEGIN

		SELECT @CheckEndDate = DATEADD(DAY,-1, @CurrentDate);;

	END

	SELECT @ServerType = CASE @@SERVERNAME WHEN 'OLY-SQL-04D' THEN 'DEV Server'
		WHEN 'OLY-SQL-04T' THEN 'Test Server'
		WHEN 'OLY-SQL-04S' THEN 'Stage Server'
		WHEN 'OLY-SQL-04' THEN 'Prod Server'
		ELSE @@SERVERNAME
		END
		,@ServerName = @@SERVERNAME

	IF @Debug = 1
	BEGIN
		PRINT '------------ Debug Inoformation ----------------' ;
		PRINT '@CurrentDate: ' + ISNULL(CAST(@CurrentDate AS VARCHAR(100)), 'NULL') ;
		PRINT '@CheckStartDate: ' + ISNULL(CAST(@CheckStartDate AS VARCHAR(100)), 'NULL') ;
		PRINT '@CheckEndDate: ' + ISNULL(CAST(@CheckEndDate AS VARCHAR(100)), 'NULL') ;
	END

	--SELECT @CurrentDate = CONVERT(CHAR(10), SYSDATETIME(),121);
	--SELECT @StartDate = DATEADD(DAY,-180, @CurrentDate);
	--SELECT @CutoffDate = DATEADD(DAY,-1, @CurrentDate);

	;WITH seq(n) AS 
	(
	  SELECT 0 UNION ALL SELECT n + 1 FROM seq
	  WHERE n < DATEDIFF(DAY, @CheckStartDate, @CheckEndDate)
	),
	d(d) AS 
	(
	  SELECT DATEADD(DAY, n, @CheckStartDate) FROM seq
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
	ORDER BY [FullDate] DESC;


	INSERT INTO @MissingSummaryDates(CalDate)
	SELECT
	src.CalDate AS CalendarDates
	--,trgt.CalDate AS SummaryDates
	--,COALESCE(trgt.RecordCounts,0) AS RecordCounts
	FROM @CalendarDates AS src
	LEFT OUTER JOIN @SummaryDatesFromTable AS trgt
		ON src.CalDate = trgt.CalDate
	WHERE trgt.CalDate IS NULL /* Remark Out to see all data rows */
	ORDER BY src.CalDate DESC;

	SELECT @MissingDatesRowCount = @@ROWCOUNT

	IF @MissingDatesRowCount > 0
	BEGIN

		SET @Subject = @ServerType + ' ||  PLModelSupprt - [dsModels].[PersonalLoanShare180] ' + @ServerName ;
            
		SET @Message = '<html>' + '<body style="font: 12px Arial;">'
			+ '<div id="intro2" style="width:670px;">Below is a list of what data maybe missing from the [dsModels].[PersonalLoanShare180] tables in the PLModelSupport Database '
			+ @ServerName + '.' + '<br><br>' ;
            
		SET @Message = @Message + N'<div style="margin-top:10px; margin-left:0px; font:12px Arial">'
			+ N'Please take a moment to review the list of dates below.'
			+ N'</div><div style="margin-top:10px;">'
			+ N'<table border="1" bordercolor=Black cellspacing="0" cellpadding="2" style="font:12px Arial">'
			+ N'<tr style="color:white;font-weight:bold;background-color:black;text-align:center">'
			+ N'<td>Data Date</td>'
			+'</tr>'
			+ CAST((SELECT
					"td/@align" = 'CENTER'
					, td = [CalDate]
					FROM
					@MissingSummaryDates
					ORDER BY [CalDate] DESC
			FOR
					XML PATH('tr')
						, TYPE) AS NVARCHAR(MAX)) + N'</table></div>' ;			

			SET @Message = @Message
				--+ '</div>
				+ '<div id="notchanged" style="margin-top:10px; width:670px;"></div>'
				+ '<div style="margin-top:10px;"> '
				+ '<br>' + 'If you have any questions or concerns regarding this email, please feel free to contact your Database Administrators by hitting the Reply button</div>'
				--+ '<a href="mailto:DELDLDQLAdmins@del.wa.gov?Subject='+ @Subject + '"> the Database Administrators</a>.</div>'
				+ '<div style="margin-top:10px;">Sincerely,</div><div style="margin-top:10px;"></div>'
				+ '<div style="margin-top:10px;">The Database Administration Team</div><div style="margin-top:10px;"></div>'
				+ '</body></html>'
				--+ '<div id="disclaimer" style="margin-top:10px; font-weight:bold;">**** Please do not reply to this email. ****</div></div></div></body></html>' ; 

	END

	IF @Message IS NOT NULL AND @Subject IS NOT NULL AND @EmailRecipients IS NOT NULL
	BEGIN
		SELECT @SendEmail = 1
	END

	IF @SendEmail = 1 AND @SendEmailNotification = 1
	BEGIN

		EXEC [DBAUtility].[Utilities].[uspCheckMailProfileToUse]
		@MailProfileToSearchFor = @MailProfile
		,@ProfileNameToUse = @MailProfileToUse OUTPUT;

		EXEC msdb.dbo.sp_send_dbmail  
		    @profile_name = @MailProfileToUse
		    ,@recipients = @EmailRecipients 
			--,@copy_recipients = @AdditionalRecipientsEmailAddress 
		    ,@subject = @Subject
			,@body = @Message
			,@body_format = 'HTML' 
			,@importance = 'High'
			;

	END




END

GO