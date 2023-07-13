SELECT
   	Cat.[Name],
   	Rep.[ScheduleId],
   	Own.UserName,
   	ISNULL(REPLACE(Sub.[Description],'send e-mail to ',''),' ') AS Recipients,
   	Sub.[LastStatus],
   	Cat.[Path],
   	Sub.[LastRunTime]
FROM
   	dbo.[Subscriptions] Sub WITH (NOLOCK)
INNER JOIN
   	dbo.[Catalog] Cat WITH (NOLOCK) ON Sub.[Report_OID] = Cat.[ItemID]
INNER JOIN
   	dbo.[ReportSchedule] Rep WITH (NOLOCK) ON (cat.[ItemID] = Rep.[ReportID] AND Sub.[SubscriptionID] =Rep.[SubscriptionID])
INNER JOIN
   	dbo.[Users] Own WITH (NOLOCK) ON Sub.[OwnerID] = Own.[UserID]
--WHERE
--Sub.[LastStatus] NOT LIKE '%was written%' --File Share subscription
--AND Sub.[LastStatus] NOT LIKE '%pending%' --Subscription in progress. No result yet
--AND Sub.[LastStatus] NOT LIKE '%mail sent%' --Mail sent successfully.
--AND Sub.[LastStatus] NOT LIKE '%New Subscription%' --New Sub. Not been executed yet
--AND Sub.[LastStatus] NOT LIKE '%been saved%' --File Share subscription
--AND Sub.[LastStatus] NOT LIKE '% 0 errors.' --Data Driven subscription
--AND Sub.[LastStatus] NOT LIKE '%succeeded%' --Success! Used in cache refreshes
--AND Sub.[LastStatus] NOT LIKE '%successfully saved%' --File Share subscription
--AND Sub.[LastStatus] NOT LIKE '%New Cache%' --New cache refresh plan
-- AND Sub.[LastRunTime] > GETDATE()-
--WHERE Sub.SubscriptionID IN('b56657f2-96de-4754-b79f-2b9953a7e3ec','f36fb235-dc57-49ab-b538-22c928f7ef69','881ef9f9-a7ea-47be-ab22-92b28d241775','d2ab6826-ee83-4acb-8859-637942db162d','4eb8d4c4-93de-40f6-b2ec-506cc5ecbfdb')
--WHERE Own.UserName = 'WSECU\breannah'
ORDER BY Cat.Name