USE msdb
GO

SELECT
fld.name AS FolderName
,fld.description
,fld.created_by_name
--,proj.folder_id
,proj.deployed_by_name
,proj.name AS ProjectName
--,pkg.[project_id]
,pkg.[name] AS PackageName
,msdbpk.JobName
,jbhs.LastJobRunDateTime
,msdbpk.JobEnabled
FROM [SSISDB].[catalog].[packages] AS pkg
INNER JOIN [SSISDB].[catalog].[projects] AS proj
	ON proj.project_id = pkg.project_id
INNER JOIN [SSISDB].[catalog].[folders] AS fld
	ON fld.folder_id = proj.folder_id
LEFT OUTER JOIN (
	SELECT
	jbst.job_id
	,jb.[name] AS JobName
	,jb.enabled AS JobEnabled
	,REVERSE(SUBSTRING(REVERSE(jbst.command),CHARINDEX('xstd',REVERSE(jbst.command)),CHARINDEX('\',REVERSE(jbst.command), CHARINDEX('xstd',REVERSE(jbst.command))) - CHARINDEX('xstd',REVERSE(jbst.command)))) AS SSISPackageName
	FROM msdb.dbo.sysjobsteps AS jbst
	INNER JOIN msdb.dbo.sysjobs AS jb
	ON jb.job_id = jbst.job_id
	WHERE jbst.subsystem = 'SSIS'
	AND CHARINDEX('.dtsx',jbst.command) > 0
) AS msdbpk
	ON msdbpk.SSISPackageName = pkg.[name]
LEFT OUTER JOIN  (
	SELECT
	sjh.job_id
	,CASE WHEN sjh.run_date > 0 THEN dbo.agent_datetime(sjh.run_date, sjh.run_time)
		ELSE NULL
	END AS LastJobRunDateTime
	FROM msdb.dbo.sysjobhistory AS sjh
	INNER JOIN (SELECT @@SERVERNAME AS [server_name], [job_id], MAX([Instance_Id]) AS InstanceId FROM msdb.dbo.sysjobhistory WHERE [step_id] = 0 GROUP BY [job_id]
	) AS sjhm
		ON sjh.job_id = sjhm.job_id
		AND sjh.instance_id = sjhm.InstanceId
) AS jbhs
	ON  msdbpk.job_id = jbhs.job_id
WHERE fld.name NOT IN ('ETLValidator','EDW_Loader')
AND fld.DESCRIPTION NOT IN ('Moved to OLY-SSISSQL-03','Moved to OLY-SSISSQL-02')
--AND fld.created_by_name IN ('WSECU\AdminPiotr') --,'','')
ORDER BY fld.[name]
,fld.created_by_name
,proj.[name]
,pkg.[name]

--ORDER BY jbhs.LastJobRunDateTime DESC