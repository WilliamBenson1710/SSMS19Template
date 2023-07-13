DECLARE @dirPath nvarchar(500) = '\\wsecu.int\apps\SQL\sql_backup\OLY-SQLSSIS-01\InsightsSSIS\FULL' 

DECLARE @tblgetfileList TABLE
(FileName nvarchar(500)
,depth int
,isFile int)

INSERT INTO @tblgetfileList
EXEC xp_DirTree @dirPath,0,1

SELECT FileName from @tblgetfileList where isFile=1