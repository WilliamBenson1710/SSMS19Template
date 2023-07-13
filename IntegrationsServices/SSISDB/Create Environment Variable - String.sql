DECLARE @var_name nvarchar(128) = N''
, @var_value sql_variant = N'' --, @var_value sql_variant = N'3'
, @var_type nvarchar(128) = N'string'
, @env_name nvarchar(128) = N''
, @fld_name nvarchar(128) = N''

EXEC [SSISDB].[catalog].[create_environment_variable]
@variable_name=@var_name
, @sensitive=False
, @description=N''
, @environment_name=@env_name
, @folder_name=@fld_name
, @value=@var_value
, @data_type=@var_type
GO