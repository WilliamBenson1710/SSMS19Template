USE [access_control]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [access_control]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [access_control]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [action_service]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [action_service]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [action_service]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [arrangement_manager]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [arrangement_manager]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [arrangement_manager]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [audit_service]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [audit_service]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [audit_service]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [backbase_identity]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [backbase_identity]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [backbase_identity]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [billpay_integration_payveris_service]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [billpay_integration_payveris_service]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [billpay_integration_payveris_service]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [billpay_integrator]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [billpay_integrator]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [billpay_integrator]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [budget_planner]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [budget_planner]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [budget_planner]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [comments]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [comments]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [comments]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [confirmation]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [confirmation]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [confirmation]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [contact_manager]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [contact_manager]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [contact_manager]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [content_enricher]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [content_enricher]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [content_enricher]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [content_services]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [content_services]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [content_services]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [device_management_service]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [device_management_service]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [device_management_service]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [engagement]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [engagement]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [engagement]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [fido_service]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [fido_service]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [fido_service]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [messages_service]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [messages_service]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [messages_service]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [notifications_service]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [notifications_service]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [notifications_service]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [payment_order_service]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [payment_order_service]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [payment_order_service]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [payveris]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [payveris]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [payveris]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [pocket_tailor]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [pocket_tailor]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [pocket_tailor]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [provisioning]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [provisioning]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [provisioning]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [push_integration_service]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [push_integration_service]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [push_integration_service]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [remote_config]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [remote_config]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [remote_config]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [saving_goal_planner]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [saving_goal_planner]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [saving_goal_planner]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [user_manager]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [user_manager]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [user_manager]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [user_profile_manager]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [user_profile_manager]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [user_profile_manager]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [user_segment]
GO
CREATE USER [BackbaseLinkedServerUser] FOR LOGIN [BackbaseLinkedServerUser]
GO
USE [user_segment]
GO
ALTER ROLE [db_datareader] ADD MEMBER [BackbaseLinkedServerUser]
GO
USE [user_segment]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [BackbaseLinkedServerUser]
GO
