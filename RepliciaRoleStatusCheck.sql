DECLARE @ReplicaRoleCheckType NVARCHAR(25) = 'PRIMARY'

BEGIN
	SET NOCOUNT ON;

	DECLARE @CurrentServerName AS NVARCHAR(250) = @@SERVERNAME
	, @ReplicaServerName AS NVARCHAR(250) = NULL 
	, @IsHadrEnabled AS SQL_VARIANT = 0
	, @ReplicaStatesRoleDesc AS NVARCHAR(250) = NULL
	, @AvailabilityGroupCount AS TINYINT = 0
	, @IsPrimaryReplicaRole AS BIT = 0;

	DECLARE @ErrorMessage NVARCHAR(4000);

	SELECT @IsHadrEnabled = SERVERPROPERTY ('IsHadrEnabled')

	IF @IsHadrEnabled = 0
	BEGIN
		PRINT 'Server: ' + @CurrentServerName + ' - No Hadr Endpoint Enabled.';
		RETURN
	END

	SELECT
	@AvailabilityGroupCount = COUNT(1)
	FROM [sys].[dm_hadr_availability_group_states] AS states
	INNER JOIN [master].[sys].[availability_groups] AS groups
		ON states.group_id = groups.group_id
	WHERE states.primary_replica = @CurrentServerName;

	SELECT
	@ReplicaStatesRoleDesc = ReplicaStates.[role_desc]
	,@ReplicaServerName = UPPER(ReplicaClusterStates.[replica_server_name])
	FROM [sys].[dm_hadr_availability_replica_states] AS ReplicaStates
	INNER JOIN [sys].[dm_hadr_availability_replica_cluster_states] AS ReplicaClusterStates
	ON ReplicaStates.replica_id = ReplicaClusterStates.replica_id
	WHERE ReplicaClusterStates.replica_server_name = @CurrentServerName;

	IF @AvailabilityGroupCount > 0 AND @ReplicaStatesRoleDesc = 'PRIMARY'
	BEGIN
		SELECT @IsPrimaryReplicaRole = 1;
	END

	IF @IsPrimaryReplicaRole = 0
	BEGIN
		PRINT 'Server: ' + @CurrentServerName + ' - Is not in the primary replica role.';
		--SELECT @ErrorMessage = 'The server: ' + @CurrentServerName + ' is not in the primary replica role.';
		--RAISERROR (@ErrorMessage, 18, 1, 0, 0);
	END
	ELSE
	BEGIN
		PRINT 'Server: ' + @CurrentServerName + ' - Is in the primary replica role.';
	END

	SELECT @ReplicaServerName AS ReplicaServerName, @ReplicaStatesRoleDesc AS ReplicaStatesRoleDesc, @IsPrimaryReplicaRole AS IsPrimaryReplicaRole;

END
GO