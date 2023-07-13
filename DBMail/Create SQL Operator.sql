USE [msdb]
GO

DECLARE @EmailAddress nvarchar(100) = N'DataServices@wsecu.org'

IF LEN(@EmailAddress) > 100
BEGIN
	SELECT 1
END

/****** Object:  Operator [SQLDBAs]    Script Date: 11/15/2021 1:21:40 PM ******/
IF  EXISTS (SELECT name FROM msdb.dbo.sysoperators WHERE name = N'SQLDBAs')
BEGIN
	EXEC msdb.dbo.sp_delete_operator @name=N'SQLDBAs'
END

/****** Object:  Operator [SQLDBAs]    Script Date: 11/15/2021 1:21:40 PM ******/
EXEC msdb.dbo.sp_add_operator @name=N'SQLDBAs', 
		@enabled=1, 
		@weekday_pager_start_time=90000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=90000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=90000, 
		@sunday_pager_end_time=180000, 
		@pager_days=0, 
		@email_address=@EmailAddress, 
		@category_name=N'[Uncategorized]'
;