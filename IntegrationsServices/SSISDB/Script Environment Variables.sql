DECLARE @CurrentFolderName AS NVARCHAR(128) = N'SQLServerInventory'
, @CurrentEnviromentName AS NVARCHAR(128) = N'Prod_SQLServerInformation'
, @NewFolderName AS NVARCHAR(128) = N'SQLServerInventory'
, @NewEnviromentName AS NVARCHAR(128) = N'Prod_SQLServerInventory'
;

/*
SELECT -- v.[name], v.[type], v.[value]
    Script = 'EXEC [SSISDB].[catalog].[set_object_parameter_value]
        @object_type=20
      , @parameter_name=N''' + CONVERT(NVARCHAR(500), v.name) + '''
      , @object_name=N''SSIS''
      , @folder_name=N''' + @NewFolderName + '''
      , @project_name=''SSIS''
      , @value_type=R
      , @parameter_value=N''' + CONVERT(NVARCHAR(500), v.name) + ''';
'
FROM [SSISDB].[catalog].[environments]          e
JOIN [SSISDB].[catalog].[folders]               f ON f.[folder_id]      = e.[folder_id]
JOIN [SSISDB].[catalog].[environment_variables] v ON e.[environment_id] = v.[environment_id]
WHERE   f.[name] = @CurrentFolderName
    AND e.[name] = @CurrentEnviromentName;
*/
SELECT
f.[name] AS FolderName
,e.[name] AS EnvironmentName
,v.[name] AS EnvironmentVariableName
,v.[type]
,v.[value]
,Script = 'EXEC [SSISDB].[catalog].[create_environment_variable]
@variable_name=''' + CONVERT(NVARCHAR(250), v.name) + '''
,@sensitive=0
,@description=''''
,@environment_name=N''' + @NewEnviromentName + '''
,@folder_name=N''' + @NewFolderName + '''
,@value='+ IIF(v.type = 'String',N'N''' + CONVERT(NVARCHAR(500), v.value) + '''',CONVERT(NVARCHAR(500), v.value))+ '
,@data_type=N''' + v.type + ''';'
FROM [SSISDB].[catalog].[environments] AS e
JOIN [SSISDB].[catalog].[folders] AS f
	ON f.[folder_id] = e.[folder_id]
JOIN [SSISDB].[catalog].[environment_variables] AS v
	ON e.[environment_id] = v.[environment_id]
WHERE f.[name] = @CurrentFolderName
	AND e.[name] = @CurrentEnviromentName;