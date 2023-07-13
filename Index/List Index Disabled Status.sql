select
[tab].[name] as [TableName]
, [idx].[name] as [IndexName]
, case [idx].[is_disabled] when 1 then 'disabled' when 0 then 'enabled' else 'Invalid State' end as [Status]
from
[sys].[tables] as [tab] -- only interested in user tables
inner join [sys].[indexes] as [idx]
on [tab].[object_id] = [idx].[object_id]
where
[tab].[object_id] = object_id('[dsModels].[PersonalLoanShare180]')
order by
[tab].[name]
, [idx].[name];