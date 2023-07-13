USE master  
EXEC sp_detach_db [ETLValidation]
GO

CREATE DATABASE [ETLValidation] ON  
PRIMARY ( NAME = ETLValidation, FILENAME = 'D:\MSSQL\Data\ETLValidation_Primary.mdf')
, FILEGROUP MEMORY_OPTIMIZED_DATA CONTAINS FILESTREAM( NAME = ETLValidation_Mem,FILENAME = 'D:\MSSQL\Data\ETLValidation_Mem')  
LOG ON  ( NAME = ETLValidation_log,FILENAME = 'L:\MSSQL\Logs\ETLValidation_Primary.ldf')  
FOR ATTACH 