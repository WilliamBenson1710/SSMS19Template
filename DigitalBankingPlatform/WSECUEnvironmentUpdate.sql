--:CONNECT OLY-SSISSQL-01D
--GO

USE SSISDB
GO

DECLARE @var SQL_VARIANT = N'OLY-DBPSQL-03S'

EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUAccountManagerPresentation_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUActionsCardauthBatch_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUAuditPresentation_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUCardControlsPresentation_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUConfigPandp_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUCsrPortalPresentation_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUMarketingPresentation_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUMessagingPresentation_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUPayveris_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECURemoteDepositPresentation_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUTransactionsBatch_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUTransfersPresentation_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUUserconfigPandp_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUUserProfilePresentation_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;
EXEC [SSISDB].[catalog].[set_environment_variable_value] @variable_name=N'WSECUVotingPresentation_ServerName', @environment_name=N'Dev_DBSMigrationToNextGen', @folder_name=N'DBSMigrationToNextGen', @value=@var
;