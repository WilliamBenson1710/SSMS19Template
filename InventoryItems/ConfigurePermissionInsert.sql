DECLARE @PrincipalName sysname = 'WSECU\svcSSISSQLd'
,@PrincipalNameToUse sysname = NULL
,@ServerNameToUse NVARCHAR(50) = 'OLY-EDHSQL-01'
;

IF @PrincipalNameToUse IS NULL
BEGIN
	SELECT @PrincipalNameToUse = @PrincipalName;
END

SELECT
[DatabaseName]
,[PrincipalName]
, @PrincipalNameToUse AS PrincipalNameToUse
,[RolePrincipalName]
,[IsFixedRolePrincipal]
,0 AS [WithExecute]
,1 AS [ViewDefinition]
,1 AS [IsActive]
,UPPER(@@ServerName) AS [ServerName]
,UPPER(@ServerNameToUse)
,'INSERT INTO [DBAUtility].[Config].[UserDatabasePermissions]([DatabaseName],[UserCredentials],[DatabaseRoleName],[IsFixedRole],[WithExcute],[ViewDefinition],[IsActive],[ServerName]) '
	+ 'VALUES (' + CHAR(39) + [DatabaseName] + CHAR(39)
	+ ', ' + CHAR(39) + @PrincipalNameToUse + CHAR(39)
	+ ', ' + CHAR(39) + [RolePrincipalName] + CHAR(39)
	+ ', ' + CONVERT(CHAR(1),[IsFixedRolePrincipal])
	+ ', 0, 1, 1'
	+ ', ' + CHAR(39) + UPPER(@ServerNameToUse) + CHAR(39) + ');'
FROM [SqlServerInventory].[Detail].[DatabaseRoleMembers]
WHERE ServerName = @ServerNameToUse
AND PrincipalName = @PrincipalName
AND RolePrincipalName <> 'db_owner'
AND DatabaseName NOT IN ('Fics_BAK-202111020000','BB-DBS_BAK-20220121_230000','BB-DBS_BAK-20220121_230000','Temenos_bak2','Temenos_BAK3','VoM_BAK','DBPUpgrade','master')
--AND CHARINDEX('WSECU\', PrincipalName) > 0



