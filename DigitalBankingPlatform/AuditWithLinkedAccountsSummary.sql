USE [bb-dbs]
GO

SELECT
DATEADD(month, DATEDIFF(month, 0, tblBaseData.PacificTimeEventTime), 0) AS EventReportMonth
,COUNT(DISTINCT userid) AS DistinctUserCount
,SUM(SuccessfulLogin) AS SuccessfulLoginCount
,SUM(FailedLogin) AS FailedLoginCount
,SUM(CASE WHEN HasLinkedAccount = 1 THEN 1 ELSE 0 END) AS HasALinkAccountCount
,SUM(ExternalAccountCount) AS ExternalAccountCount
FROM (
SELECT
--TOP 1000
ar.event_description
,ar.event_time
,CONVERT(DATETIME, SWITCHOFFSET(CONVERT(DATETIMEOFFSET,ar.event_time), DATENAME(TZOFFSET, SYSDATETIMEOFFSET()))) PacificTimeEventTime
,ar.userid
,ar.object_type
,ar.event_action
, CASE WHEN ar.event_action = 'Success' THEN 1 ELSE 0 END AS SuccessfulLogin
, CASE WHEN ar.event_action <> 'Success' THEN 1 ELSE 0 END AS FailedLogin
,enu.legal_entity_id
,enu.full_name
,le.le_name
,le.le_type
,wea.member_id
, CASE WHEN wea.member_id IS NOT NULL THEN 1 ELSE 0 END AS HasLinkedAccount
,wea.ExternalAccountCount
FROM [bb-dbs].[wsecu].[audit] AS ar WITH(NOLOCK)

INNER JOIN [bb-dbs].[dbo].[en_user] AS enu WITH(NOLOCK)
ON ar.userid  = enu.external_id

INNER JOIN [bb-dbs].[dbo].[legal_entity] AS le WITH(NOLOCK)
ON enu.legal_entity_id = le.id

--LEFT OUTER JOIN [bb-dbs].[wsecu].[external_account] AS wea WITH(NOLOCK)
LEFT OUTER JOIN (
	SELECT
	member_id
	, COUNT(1) AS ExternalAccountCount
	FROM [bb-dbs].[wsecu].[external_account] WITH(NOLOCK)
	GROUP BY member_id
) AS wea
ON enu.external_id = wea.member_id

WHERE ar.event_time >= '2022-07-26' 
--WHERE CONVERT(DATETIME, SWITCHOFFSET(CONVERT(DATETIMEOFFSET,ar.event_time), DATENAME(TZOFFSET, SYSDATETIMEOFFSET()))) >= '2021-06-01' 
AND ar.category = 'Authentication'
AND ar.userid <> '3b898a3a-f660-4ac7-ae90-7899e51d0a2a'
--ORDER BY ar.event_time DESC
) AS tblBaseData
GROUP BY DATEADD(month, DATEDIFF(month, 0, tblBaseData.PacificTimeEventTime), 0)

ORDER BY DATEADD(month, DATEDIFF(month, 0, tblBaseData.PacificTimeEventTime), 0) DESC