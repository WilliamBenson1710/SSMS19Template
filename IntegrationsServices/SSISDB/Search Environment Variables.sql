SELECT [parameter_id]
,[project_id]
,[object_type]
,[object_name]
,[parameter_name]
,[data_type]
,[required]
,[sensitive]
,[description]
,[design_default_value]
,[default_value]
,[value_type]
,[value_set]
,[referenced_variable_name]
,[validation_status]
,[last_validation_time]
FROM [SSISDB].[catalog].[object_parameters]
WHERE data_type = 'string'
AND CHARINDEX('ConnectionString',[parameter_name]) > 0
--AND CHARINDEX('Provider',[design_default_value]) > 0


SELECT     fldr.name AS FolderName
        ,objp.[referenced_variable_name] AS [EnvironmentVariable]
        , proj.name AS ProjectName
        , COALESCE('Package: ' + pkg.name, 'Project') AS Scope
        , objp.parameter_name COLLATE Latin1_General_CS_AS AS ParameterName
        ,Objp.design_default_value 
        ,Objp.referenced_variable_name
        ,(select top 1 Ev.value as VariableValue from SSISDB.[internal].[environment_variables] EV where ev.name=Objp.referenced_variable_name) as [value]
FROM SSISDB.catalog.folders AS fldr
   INNER JOIN  SSISDB.catalog.projects proj
            ON proj.folder_id = fldr.folder_id
    Left JOIN SSISDB.catalog.object_parameters objp    
        ON objp.project_id = proj.project_id
    LEFT JOIN SSISDB.catalog.packages pkg
        ON objp.object_name = pkg.name
        AND objp.project_id = pkg.project_id
--WHERE proj.name like '%XXX%'
--WHERE fldr.name = 'MoneyGuardNightlyBulkLoad'