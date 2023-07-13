USE [wsecu_account_manager]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_account_manager]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_account_manager]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_actions_cardauth_batch]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_actions_cardauth_batch]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_actions_cardauth_batch]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_audit_presentation]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_audit_presentation]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_audit_presentation]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_card_controls]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_card_controls]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_card_controls]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_config]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_config]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_config]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_csr_portal_presentation]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_csr_portal_presentation]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_csr_portal_presentation]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_marketing]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_marketing]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_marketing]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_messaging]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_messaging]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_messaging]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_payveris]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_payveris]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_payveris]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_remote_deposit]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_remote_deposit]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_remote_deposit]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_transactions_batch]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_transactions_batch]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_transactions_batch]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_transfers]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_transfers]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_transfers]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_user_profile]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_user_profile]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_user_profile]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_userconfig]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_userconfig]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_userconfig]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_voting]
GO
CREATE USER [WSECULinkedServerUser] FOR LOGIN [WSECULinkedServerUser]
GO
USE [wsecu_voting]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WSECULinkedServerUser]
GO
USE [wsecu_voting]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WSECULinkedServerUser]
GO
