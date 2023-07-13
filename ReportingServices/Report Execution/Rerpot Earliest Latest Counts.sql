SELECT
[ReportFolder],
[ReportName],
[RequestType],
COUNT(*) as [ExecutionCount],
SUM([TimeDataRetrieval] + [TimeProcessing] + [TimeRendering]) as [TotalExecutionTime],
SUM([TimeDataRetrieval] + [TimeProcessing] + [TimeRendering]) / COUNT(*) as [AverageExecutionTime],
SUM([RowCount]) as [TotalRows],
MIN(TimeStart) as [EarliestRequest],
MAX(TimeStart) as [LatestRequest]
FROM (
 SELECT
 c.Name AS ReportName,
 c.[Path],
 REPLACE(SUBSTRING(c.[Path],CHARINDEX('/',c.[Path]), CHARINDEX('/',c.[Path],2)),'/','') AS ReportFolder,
 l.InstanceName,
 l.ReportID,
 l.UserName,
 --l.RequestType,
 CASE WHEN l.[RequestType] = 0 THEN 'Interactive'
 WHEN l.[RequestType] = 1 THEN 'Subscription'
 WHEN l.[RequestType] = 2 THEN 'Refresh Cache'
 ELSE 'Unknown'
 END [RequestType],
 l.Format,
 l.Parameters,
 CONVERT(Date, TimeStart) AS ReportDate,
 l.TimeStart,
 l.TimeEnd,
 l.TimeDataRetrieval,
 l.TimeProcessing,
 l.TimeRendering,
 l.Source,
 l.Status,
 l.ByteCount,
 l.[RowCount],
 1 AS ReportCount
 FROM [ReportServer].[dbo].[ExecutionLogStorage](NOLOCK) AS l
 INNER JOIN [ReportServer].[dbo].[Catalog](NOLOCK) AS c ON l.ReportID = C.ItemID
 WHERE c.Type = 2 -- Only show reports 1=folder, 2=Report, 3=Resource, 4=Linked Report, 5=Data Source
 --ORDER BY l.TimeStart DESC;
) AS tblBase
GROUP BY [ReportFolder],ReportName, RequestType
ORDER BY [ReportFolder],ReportName, RequestType