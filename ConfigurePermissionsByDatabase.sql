--Add Users and Permissions - ConfigruePermissionsByDatabase

DECLARE @DatabaseToUse NVARCHAR(250) = 'openidmv_bak'
,@DebugToUse BIT = 0

EXEC [Utilities].[uspConfigruePermissionsByDatabase]
@DatabaseName = @DatabaseToUse
,@Debug = @DebugToUse