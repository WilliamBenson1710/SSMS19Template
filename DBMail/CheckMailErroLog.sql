SELECT er.log_id AS [LogID],
  er.event_type AS [EventType],
  er.log_date AS [LogDate],
  er.description AS [Description],
  er.process_id AS [ProcessID],
  er.mailitem_id AS [MailItemID],
  er.account_id AS [AccountID],
  er.last_mod_date AS [LastModifiedDate],
  er.last_mod_user AS [LastModifiedUser]
FROM msdb.dbo.sysmail_event_log er
ORDER BY [LogDate] DESC