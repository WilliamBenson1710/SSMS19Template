SELECT
'eServices_eStatementEmailListProcessing_EnabledAccounts' AS TableName
,[ProcessDate]
,COUNT(1) AS RecordCount
FROM [InsightsTMP].[dbo].[eServices_eStatementEmailListProcessing_EnabledAccounts]
GROUP BY [ProcessDate]
ORDER BY [ProcessDate] DESC

SELECT
'eServices_eStatementEmailListProcessing_LOC' AS TableName
,[StatementDate]
,[Type]
,COUNT(1) AS RecordCount
FROM [dbo].[eServices_eStatementEmailListProcessing_LOC]
GROUP BY [StatementDate],[Type]
ORDER BY [StatementDate] DESC, [Type]

SELECT
'eServices_eStatementEmailListProcessing_Member' AS TableName
,[StatementDate]
,[Type]
,COUNT(1) AS RecordCount
FROM [dbo].[eServices_eStatementEmailListProcessing_Member]
GROUP BY [StatementDate],[Type]
ORDER BY [StatementDate] DESC, [Type]

SELECT
'eServices_eStatementEmailListProcessing_Mortgage' AS TableName
,[StatementDate]
,[Type]
,COUNT(1) AS RecordCount
FROM [dbo].[eServices_eStatementEmailListProcessing_Mortgage]
GROUP BY [StatementDate],[Type]
ORDER BY [StatementDate] DESC, [Type]

SELECT
'eServices_eStatementEmailListProcessing_VISA' AS TableName
,[StatementDate]
,[Type]
,COUNT(1) AS RecordCount
FROM [dbo].[eServices_eStatementEmailListProcessing_VISA]
GROUP BY [StatementDate],[Type]
ORDER BY [StatementDate] DESC, [Type]


