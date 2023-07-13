USE [DBPFail]
GO

SELECT [id]
      ,[alert_date]
	
	  ,FORMAT( alert_date, 'dd/MM/yyyy hh:mm:ss', 'en-US' ) AS 'Date'  
      ,[alert_name]
      ,[delivery_method]
      ,[user_id]
      ,[recipe_specification_name]
      ,[alert_text]
      --,[service_agreement_id]
  FROM [dbo].[action_events_history]
  WHERE --alert_name ='Successful Sign-in'
  --and 
  alert_date >= '12-7-21'
 -- and user_id = 'e353f8cd-fdf5-42b0-8a1b-55f043505dce'
--and user_id = '7f18860a-1e08-433c-bc41-87794b3c38a7'

  ORDER BY alert_date DESC

GO


select * From action_recipe ar
JOIN en_user eu
on ar.user_id = eu.external_id

;with ctemult as (
select  getutcdate()RanAt,alert_name,alert_text,[delivery_method],[user_id]
--,datepart(HOUR,alert_date )HOURs,datepart(MINUTE,alert_date )MINUTEs
,FORMAT( alert_date, 'dd/MM/yyyy hh:mm:ss', 'en-US' ) AS 'Date'  
, cast(alert_date as date) alertDate
,destination
,COUNT( User_ID) NumUsers

,max(alert_date) LastAlert
from action_events_history aeh
join action_event_destinations aed
ON aeh.id = aed.action_event_history_id
--join en_user eu
--on aeh.user_id = eu.external_id
where alert_date >= '12/7/2021 00:00:00'
--and alert_name ='Card Authorizations'
--and full_name = 'bashpersonal'
--and delivery_method = 'SMS'
--and alert_text like '%AMAZ%'
group by alert_name,alert_text,[delivery_method],[user_id],cast(alert_date as date),FORMAT( alert_date, 'dd/MM/yyyy hh:mm:ss', 'en-US' ) ,destination
having COUNT( User_ID) > 2
--order by NumUsers desc
)
select M.*,ar.*
from ctemult m
JOIN action_recipe ar
on m.user_id = ar.user_id
where specification_id in (12,13)
and destination = 'BENNY2748@GMAIL.COM'
order by ar.user_id,specification_id

select FORMAT( alert_date, 'MM/dd/yyyy hh:mm:ss', 'en-US' )
,LEAD(FORMAT( alert_date, 'MM/dd/yyyy hh:mm:ss', 'en-US' ), 1,0) OVER (ORDER BY FORMAT( alert_date, 'MM/dd/yyyy hh:mm:ss', 'en-US' )) AS NextAlertTime 
,DATEDIFF(MINUTE,FORMAT( alert_date, 'MM/dd/yyyy hh:mm:ss', 'en-US' ),LEAD(FORMAT( alert_date, 'MM/dd/yyyy hh:mm:ss', 'en-US' ), 1,0) OVER (ORDER BY FORMAT( alert_date, 'MM/dd/yyyy hh:mm:ss', 'en-US' )))
from action_events_history aeh
join action_event_destinations aed
ON aeh.id = aed.action_event_history_id
--join en_user eu
--on aeh.user_id = eu.external_id
where alert_date >= '12/7/2021 00:00:00'
GROUP BY FORMAT( alert_date, 'MM/dd/yyyy hh:mm:ss', 'en-US' )
order by FORMAT( alert_date, 'MM/dd/yyyy hh:mm:ss', 'en-US' )


select FORMAT( alert_date, 'MM/dd/yyyy hh:mm', 'en-US' )
--,LEAD(FORMAT( alert_date, 'MM/dd/yyyy hh:mm', 'en-US' ), 1,0) OVER (ORDER BY FORMAT( alert_date, 'MM/dd/yyyy hh:mm', 'en-US' )) AS NextAlertTime 
--,DATEDIFF(MINUTE,FORMAT( alert_date, 'MM/dd/yyyy hh:mm', 'en-US' ),LEAD(FORMAT( alert_date, 'MM/dd/yyyy hh:mm', 'en-US' ), 1,0) OVER (ORDER BY FORMAT( alert_date, 'MM/dd/yyyy hh:mm', 'en-US' )))
,alert_name
,user_id
,alert_text
,destination
,count( alert_text) Alerts
,count(distinct aed.destination) Destinations
from action_events_history aeh
join action_event_destinations aed
ON aeh.id = aed.action_event_history_id
--join en_user eu
--on aeh.user_id = eu.external_id
where alert_date >= '12/8/2021 00:00:00'
and (user_id = '5816a7a8-94de-4e60-84fb-e285e04b8022'
or user_id = '2bff74a4-bd70-4543-871a-9a6e17ddcd54'
or user_id = '0ff60404-ed1f-46af-8860-898aa16bca87'
)
GROUP BY FORMAT( alert_date, 'MM/dd/yyyy hh:mm', 'en-US' ),alert_name,user_id,alert_text,destination
--HAVING count( alert_text) != count( distinct aed.destination)
order by FORMAT( alert_date, 'MM/dd/yyyy hh:mm', 'en-US' ) desc

;with ctealerts as (
select alert_date
,dateadd(hour,-8,alert_date) pst
--,aed.destination
--,aeh.alert_name
,COUNT(distinct destination) DistinctDestination--  OVER (PARTITION BY alert_date) alertCount
,COUNT(distinct alert_name) distinctAlertName
,LEAD(alert_date, 1,0) OVER (ORDER BY alert_date) AS NextAlertTime 
,DATEDIFF(MINUTE,alert_date,LEAD(alert_date) OVER (ORDER BY alert_date)) minutesbetweenalerts
from action_events_history aeh
left join action_event_destinations aed
ON aeh.id = aed.action_event_history_id
--join en_user eu
--on aeh.user_id = eu.external_id
where alert_date >= '12/7/2021 00:00:00'
GROUP BY alert_date--,alert_name
,aed.destination
--order by alert_date
)
select * from ctealerts
where minutesbetweenalerts > 1
cteData as (
select *
from action_events_history aeh
join action_event_destinations aed
ON aeh.id = aed.action_event_history_id
where user_id = 'a5b57e12-14ed-410b-9c07-eaf09eba1ffa'
and alert_date >= '12/1/2021 00:00:00'
order by id
--JOIN ctemult m
--on aeh.alert_text = m.alert_text
--and m.alert_name = aeh.alert_name
where  aeh.alert_date >= '8/15/2021 05:00:00'
and alert_name ='Card Authorizations'
)
select user_id,eu.Full_name,COUNT(distinct d.Alert_text) 
from ctemult M
JOIN cteData d
ON M.alert_text = d.alert_text
JOIN en_user eu
on d.user_id = eu.external_id

group by user_id


