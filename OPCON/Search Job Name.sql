--SQL13 OpCon
SELECT [OPCONXPS].[dbo].[JMASTER_AUX].[SKDID]
,[OPCONXPS].[dbo].[SNAME].SKDNAME
,[JOBNAME]
,[JAFC]
,[JASEQNO]
,[JAVALUE]
FROM [OPCONXPS].[dbo].[JMASTER_AUX]
INNER JOIN [OPCONXPS].[dbo].[SNAME] ON JMASTER_AUX.SKDID=SNAME.SKDID
WHERE SNAME.SKDNAME LIKE '%000-STMTS%' AND JAFC = 3003