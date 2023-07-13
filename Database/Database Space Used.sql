USE [DW_DBP]
GO

select size/128. from sys.database_files where name = 'DW_DBP';
select fileproperty( N'DW_DBP','SpaceUsed')/128.0;

DBCC SHRINKFILE (N'DW_DBP' , 1810955)


select size/128. from sys.database_files where name = 'DW_DBP';
select fileproperty( N'DW_DBP','SpaceUsed')/128.0;
