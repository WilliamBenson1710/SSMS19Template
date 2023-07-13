USE msdb
GO

--https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/database-mail-views-transact-sql?view=sql-server-ver15

SELECT
*
FROM sysmail_allitems
ORDER by send_request_date DESC