;WITH XMLNAMESPACES  -- XML namespace def must be the first in with clause.
     (DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2006/03/reportdatasource'
             ,'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner'
      AS rd)
 ,SDS AS
     (SELECT SDS.name AS SharedDsName
            ,SDS.[Path]
            ,CONVERT(xml, CONVERT(varbinary(max), content)) AS DEF
      FROM dbo.[Catalog] AS SDS
      WHERE SDS.Type = 5)     -- 5 = Shared Datasource
    
 SELECT CON.[Path]
       ,CON.SharedDsName
       ,CON.ConnString
	   --,CON.DataProvider
 FROM
     (SELECT SDS.[Path]
            ,SDS.SharedDsName
            ,DSN.value('ConnectString[1]', 'varchar(150)') AS ConnString
			--,DSN.value('DataProvider', 'varchar(150)') AS DataProvider
      FROM SDS
           CROSS APPLY 
           SDS.DEF.nodes('/DataSourceDefinition') AS R(DSN)
      ) AS CON
 -- Optional filter:
 -- WHERE CON.ConnString LIKE '%Initial Catalog%=%TFS%'
 ORDER BY CON.[Path]
         ,CON.SharedDsName;

	/*	 - List datasets with command text for all SSRS reports 
;WITH  
 XMLNAMESPACES 
     (DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2008/01/reportdefinition' 
             ,'http://schemas.microsoft.com/sqlserver/reporting/reportdesigner' 
      AS rd) 
,DEF AS 
    (SELECT RPT.ReportPath 
           ,R.RptNode.value('(./Query/DataSourceName)[1]', 'nvarchar(425)') AS DataSourceName 
           ,R.RptNode.value('@Name[1]', 'nvarchar(425)') AS DataSetName 
           ,REPLACE(REPLACE(LTRIM((R.RptNode.value('(./Query/CommandText)[1]', 'nvarchar(4000)')))  
                    ,'&gt;', '>') 
                    ,'&lt;', '<') 
            AS CommandText 
     FROM (SELECT RPT.Path AS ReportPath 
                 ,RPT.name AS ReportName 
                 ,CONVERT(xml, CONVERT(varbinary(max), RPT.content)) AS contentXML 
           FROM ReportServer.dbo.[Catalog] AS RPT 
           WHERE RPT.Type = 2  -- 2 = Reports 
         ) AS RPT 
     CROSS APPLY RPT.contentXML.nodes('/Report/DataSets/DataSet') AS R(RptNode) 
    ) 
SELECT DEF.ReportPath 
      ,DEF.DataSourceName 
      ,DEF.DataSetName 
      ,DEF.CommandText 
FROM DEF 
-- Optional filter: 
-- WHERE DEF.CommandText LIKE '%/[Team System/]%' -- MDX query against TFS cube 
ORDER BY DEF.ReportPath 
        ,DEF.DataSourceName 
        ,DEF.DataSetName
		*/