--:CONNECT OYL-DBASQL-01
--GO

USE SqlServerInventory
GO

DECLARE @SourceServerName NVARCHAR(500) = 'OLY-DBPSQL-03D'
--, @SourceDatabaseName NVARCHAR(500) = 'bb-dbs'
--, @DestinationServerName NVARCHAR(500) = 'OLY-DBPSQL-02H'
, @DestinationServerName NVARCHAR(500) = 'OLY-DBPSQL-03T'
;

SELECT
dcd.[ServerName]
,dcd.[DatabaseName]
--,dcd.[SchemaName]
--,dcd.[TableName]
,dcd.[SchemaName] + '.' + dcd.[TableName] AS objectName
,dcd.[ColumnName]
,dcddestsvr.ServerName AS DestServerName
,dcddestsvr.DatabaseName AS DestDatabaseName

,dcd.[ColumnDefault]
,dcd.[IsNullable]
,dcd.[DataType] AS SourceDataType
,dcddestsvr.DataType AS DestDataType
,dcd.[CollationName]
,dcd.[CharacterMaximumLength] AS SourceCharacterMaximumLength
,dcddestsvr.[CharacterMaximumLength] AS DestCharacterMaximumLength

,dcd.[NumericPrecision] AS SourceNumericPrecision
,dcd.[NumericSclae] AS SourceNumericScale

,dcddestsvr.[NumericPrecision] AS DestNumericPrecision
,dcddestsvr.[NumericSclae] AS DestNumericScale


--,dcd.[NumericPrecisionRadix]
,dcd.[DatetimePrecision] AS SourceDatetimePrecision
,dcddestsvr.[DatetimePrecision] AS SourceDatetimePrecision

,CASE WHEN dcd.[DataType] IN ('nvarchar','text','varchar','char','nchar') AND (dcd.[DataType] = dcddestsvr.DataType) AND (dcd.[CharacterMaximumLength] = dcddestsvr.[CharacterMaximumLength]) THEN 1
	WHEN dcd.[DataType] IN ('bigint','numeric','tinyint','decimal','int','money') AND (dcd.[DataType] = dcddestsvr.[DataType]) AND (dcd.[NumericPrecision] = dcddestsvr.[NumericPrecision]) AND (dcd.[NumericSclae] = dcddestsvr.[NumericSclae]) THEN 1
	WHEN dcd.[DataType] IN ('datetime','datetime2','date','smalldatetime','datetimeoffset') AND (dcd.[DataType] = dcddestsvr.[DataType]) AND (dcd.[DatetimePrecision] = dcddestsvr.[DatetimePrecision]) THEN 1
	WHEN dcd.[DataType] IN ('bit') AND (dcd.[DataType] = dcddestsvr.[DataType]) THEN 1
	WHEN dcd.[DataType] IN ('uniqueidentifier') AND (dcd.[DataType] = dcddestsvr.[DataType]) THEN 1
	WHEN dcd.[DataType] IN ('varbinary') AND (dcd.[DataType] = dcddestsvr.[DataType]) THEN 1
	ELSE 0
END AS DataTypeMatch

FROM [Detail].[DatabaseColumnDefinitions] AS dcd
LEFT OUTER JOIN (
	SELECT
	[ServerName]
	,[DatabaseName]
	,[SchemaName]
	,[TableName]
	,[ColumnName]
	,[ColumnDefault]
	,[IsNullable]
	,[DataType]
	,[CollationName]
	,[CharacterMaximumLength]
	,[NumericPrecision]
	,[NumericSclae]
	,[NumericPrecisionRadix]
	,[DatetimePrecision]
	FROM [Detail].[DatabaseColumnDefinitions]
	WHERE ServerName = @DestinationServerName
	AND [DatabaseName] NOT IN ('bb-dbs','bb-dbsDEV','DBPDeployFail','bb-dbs2_21')
) AS dcddestsvr
	ON dcddestsvr.DatabaseName = dcd.DatabaseName
	AND dcddestsvr.SchemaName = dcd.SchemaName
	AND dcddestsvr.TableName = dcd.TableName
	AND dcddestsvr.ColumnName = dcd.ColumnName

WHERE dcd.ServerName = @SourceServerName
--AND dcd.DatabaseName = @SourceDatabaseName
--AND dcd.DatabaseName = 'content_services'

AND dcd.DatabaseName NOT IN ('msdb','model','master','tempdb','LiteSpeedLocal','ReportServerTempDB','DBAUtility')

--AND dcd.[DataType]IN ('nvarchar','text','varchar','char')
--AND dcddestsvr.DatabaseName IS NOT NULL

ORDER BY dcd.[ServerName]
,dcd.[DatabaseName]
,dcd.[SchemaName]
,dcd.[TableName]
,dcd.[ColumnName]
