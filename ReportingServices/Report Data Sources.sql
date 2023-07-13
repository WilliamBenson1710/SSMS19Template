SELECT CATALOG.NAME
    ,CATALOG.[Path]
    ,DataSource.NAME datasource
    ,CATALOG.[Description]
    ,Created.UserName AS CreatedByUser
    ,CATALOG.[CreationDate]
    ,Modified.UserName AS ModifiedByUser
    ,CATALOG.[ModifiedDate]
FROM [dbo].[Catalog]
LEFT JOIN (
    SELECT [UserID]
        ,[UserName]
    FROM [dbo].[Users]
    ) AS Created ON CATALOG.CreatedByID = Created.UserID
LEFT JOIN (
    SELECT [UserID]
        ,[UserName]
    FROM [dbo].[Users]
    ) AS Modified ON CATALOG.ModifiedByID = Modified.UserID
left outer JOIN DataSource ON CATALOG.ItemID = DataSource.ItemID
LEFT outer JOIN CATALOG cat1 ON DataSource.Link = cat1.ItemID
WHERE CATALOG.[Type] = 2 
ORDER BY CATALOG.[ModifiedDate] desc, [Path] 
    ,NAME