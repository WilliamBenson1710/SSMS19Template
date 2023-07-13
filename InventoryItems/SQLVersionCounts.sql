SELECT 
[SQLVersionBuild]
,SUM(CASE WHEN CHARINDEX('Standard',[Edition]) > 0 THEN 1 ELSE 0 END) AS StandardEdition
,SUM(CASE WHEN CHARINDEX('Enterprise',[Edition]) > 0 THEN 1 ELSE 0 END) AS EnterpriseEdition
,COUNT(1) AS ServerCount
--FROM [SqlServerInventory].[Detail].[SQLServerProperties]
FROM [SqlServerInventory].DetailView.vwSQLServerProperties
WHERE ServerInfoIsActive = 1
AND EnvironmentIsProduction = 1
GROUP BY [SQLVersionBuild]

ORDER BY [SQLVersionBuild]