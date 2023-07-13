IF SERVERPROPERTY ('IsHadrEnabled') = 1
BEGIN
    SELECT
        AvailabilityGroup.name AS AvailabilityGroupName,
        ReplicaClusterStates.replica_server_name as ServerName,
        ReplicaStates.role_desc as ReplicaRole,
        Listeners.dns_name as DnsName
    FROM
        sys.availability_groups_cluster AS AvailabilityGroup
    INNER JOIN
        sys.dm_hadr_availability_replica_cluster_states AS ReplicaClusterStates ON ReplicaClusterStates.group_id = AvailabilityGroup.group_id
    INNER JOIN
        sys.dm_hadr_availability_replica_states AS ReplicaStates ON ReplicaStates.replica_id = ReplicaClusterStates.replica_id
    INNER JOIN
        sys.availability_group_listeners AS Listeners ON Listeners.group_id = ReplicaStates.group_id
    ORDER BY
        ReplicaStates.role_desc
END