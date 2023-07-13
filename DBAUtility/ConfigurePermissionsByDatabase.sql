DECLARE @DatabaseToUse NVARCHAR(250) = 'BB-DBS_BAK'
,@DebugToUse BIT = 1

EXEC [Utilities].[uspConfigruePermissionsByDatabase]
@DatabaseName = @DatabaseToUse
,@Debug = @DebugToUse