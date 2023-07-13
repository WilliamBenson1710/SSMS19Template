DECLARE @var_name nvarchar(128) = N'IsDeletedRecord'
, @var_value int = N'3' --, @var_value sql_variant = N'3'
, @var_type nvarchar(128) = N'Int32'
, @env_name nvarchar(128) = N'Dev_SQLServerInfo'
, @fld_name nvarchar(128) = N'SQLServerInformation'

EXEC [SSISDB].[catalog].[create_environment_variable]
@variable_name=@var_name
, @sensitive=False
, @description=N''
, @environment_name=@env_name
, @folder_name=@fld_name
, @value= @var_value
, @data_type=@var_type
GO