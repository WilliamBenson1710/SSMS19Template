USE [master]
GO

DECLARE @DataBaseName sysname = 'user_profile_manager'
,@IsSimpleRecovery BIT = 1
, @Debug BIT = 1

BEGIN

	SET NOCOUNT ON;

	DECLARE @QuoteDataBaseName sysname
	,@InstanceDefaultDataPath NVARCHAR(250)
	,@InstanceDefaultLogPath NVARCHAR(250)
	,@DataFileName NVARCHAR(250)
	,@LogFileName NVARCHAR(250)
	,@SQLCreateDatabaseScript NVARCHAR(MAX)
	,@SQLFileStreamScript NVARCHAR(MAX)
	;

	IF @Debug = 1
	BEGIN
		PRINT '------------ Debug Inoformation ----------------' ;
	END

	--IF (@DataBaseName LIKE '%[^0-9A-Z]%')
	--	BEGIN
	--		RAISERROR('Invalid Characters in Name, %s',16,1,@DataBaseName)
	--	END
	--ELSE
	--    BEGIN
	--		SET @QuoteDataBaseName = QUOTENAME(@DataBaseName)
	--    END

	SELECT @QuoteDataBaseName = QUOTENAME(@DataBaseName);

	SELECT @InstanceDefaultDataPath = CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(1000))
	, @InstanceDefaultLogPath = CAST(SERVERPROPERTY('InstanceDefaultLogPath') AS NVARCHAR(1000));

	/****** Object:  Database [WSECU_VOTING_PRESENTATION]    Script Date: 3/14/2022 11:38:10 AM ******/
	IF EXISTS (SELECT name FROM sys.databases WHERE name = @DataBaseName)
	BEGIN
		IF @Debug = 1
		BEGIN
			PRINT '------------ Begin Dropping Datbase ----------------' ;
		END

		EXEC('DROP DATABASE ' +  @QuoteDataBaseName + ';')
	END

	SELECT @InstanceDefaultDataPath = CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(250))
	, @InstanceDefaultLogPath = CAST(SERVERPROPERTY('InstanceDefaultLogPath') AS NVARCHAR(250));

	SELECT @DataFileName = @InstanceDefaultDataPath + @DataBaseName + '.mdf'
	, @LogFileName = @InstanceDefaultLogPath + @DataBaseName + '_log.ldf'

	IF @Debug = 1
	BEGIN
		PRINT '------------ Debug Inoformation ----------------' ;
		PRINT '@DataBaseName: ' + ISNULL(CAST(@DataBaseName AS NVARCHAR(250)), 'NULL') ;
		PRINT '@QuoteDataBaseName: ' + ISNULL(CAST(@QuoteDataBaseName AS NVARCHAR(250)), 'NULL') ;
		PRINT '@InstanceDefaultDataPath: ' + ISNULL(CAST(@InstanceDefaultDataPath AS NVARCHAR(250)), 'NULL') ;
		PRINT '@InstanceDefaultLogPath: ' + ISNULL(CAST(@InstanceDefaultLogPath AS NVARCHAR(250)), 'NULL') ;
		PRINT '@DataFileName: ' + ISNULL(CAST(@DataFileName AS NVARCHAR(250)), 'NULL') ;
		PRINT '@LogFileName: ' + ISNULL(CAST(@LogFileName AS NVARCHAR(250)), 'NULL') ;
	END

	SELECT @SQLCreateDatabaseScript = 'CREATE DATABASE ' + @QuoteDataBaseName + CHAR(13)
		+ 'CONTAINMENT = NONE' + CHAR(13)
		+ 'ON PRIMARY' + CHAR(13)
		+ '(NAME = N' + CHAR(39) + @DataBaseName + CHAR(39) + ', FILENAME = N' + CHAR(39) + @DataFileName + CHAR(39) + ', SIZE = 500000KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB)' + CHAR(13)
		+ 'LOG ON' + CHAR(13)
		+ '(NAME = N' + CHAR(39) + @LogFileName + '_log' + CHAR(39) + ', FILENAME = N' + CHAR(39) + @LogFileName + CHAR(39) + ', SIZE = 500000KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB)' + CHAR(13)
		+ 'COLLATE SQL_Latin1_General_CP1_CI_AS'

	IF @Debug = 1
	BEGIN
		PRINT '@SQLCreateDatabaseScript: ' + ISNULL(CAST(@SQLCreateDatabaseScript AS NVARCHAR(MAX)), 'NULL') ;
	END


	IF @SQLCreateDatabaseScript IS NOT NULL
	BEGIN
		IF @Debug = 1
		BEGIN
			PRINT '------------ Begin Creating Datbase ----------------' ;
		END

		EXEC(@SQLCreateDatabaseScript);
	END

	IF EXISTS (SELECT name FROM sys.databases WHERE name = @DataBaseName)
	BEGIN
		IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
		BEGIN

			SELECT @SQLFileStreamScript = 'EXEC' + @QuoteDataBaseName + '.[dbo].[sp_fulltext_database] @action = ' + CHAR(39) + 'ENABLE' + CHAR(39)

			IF @Debug = 1
			BEGIN
				PRINT '@SQLFileStreamScript: ' + ISNULL(CAST(@SQLFileStreamScript AS NVARCHAR(MAX)), 'NULL') ;
			END
				
			IF @Debug = 1
			BEGIN
				PRINT '------------ Begin FileStream  ----------------' ;
			END

			EXEC(@SQLFileStreamScript);
		END

		IF @Debug = 1
		BEGIN
			PRINT '------------ Begin Databse Alters  ----------------' ;
		END

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET ANSI_NULL_DEFAULT OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET ANSI_NULLS OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET ANSI_PADDING OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET ANSI_WARNINGS OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET ARITHABORT OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET AUTO_CLOSE OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET AUTO_SHRINK OFF ;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET AUTO_UPDATE_STATISTICS ON;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET CURSOR_CLOSE_ON_COMMIT OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET CURSOR_DEFAULT  GLOBAL;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + 'SET CONCAT_NULL_YIELDS_NULL OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET NUMERIC_ROUNDABORT OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET QUOTED_IDENTIFIER OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET RECURSIVE_TRIGGERS OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET  ENABLE_BROKER;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET AUTO_UPDATE_STATISTICS_ASYNC OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET DATE_CORRELATION_OPTIMIZATION OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET TRUSTWORTHY OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET ALLOW_SNAPSHOT_ISOLATION OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET PARAMETERIZATION SIMPLE;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET READ_COMMITTED_SNAPSHOT OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET HONOR_BROKER_PRIORITY OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET RECOVERY FULL;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET  MULTI_USER;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET PAGE_VERIFY CHECKSUM;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET DB_CHAINING OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF );');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET TARGET_RECOVERY_TIME = 60 SECONDS;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET DELAYED_DURABILITY = DISABLED;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET QUERY_STORE = OFF;');

		EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET  READ_WRITE;');



		IF @Debug = 1
		BEGIN
			PRINT '------------ Change Database Owner ----------------' ;
		END

		EXEC('ALTER AUTHORIZATION ON DATABASE::' + @QuoteDataBaseName + ' TO [sa]')

		IF @Debug = 1
		BEGIN
			PRINT '@IsSimpleRecovery: ' + ISNULL(CAST(@IsSimpleRecovery AS NVARCHAR(MAX)), 'NULL') ;
		END

		IF @IsSimpleRecovery = 1
		BEGIN
			IF @Debug = 1
			BEGIN
				PRINT '------------ Changing Recorvery to Simple ----------------' ;
			END

			EXEC('ALTER DATABASE ' + @QuoteDataBaseName + ' SET RECOVERY SIMPLE WITH NO_WAIT;')
		END

	END

	IF @Debug = 1
	BEGIN
		PRINT '------------ End Debug Inoformation ----------------' ;
	END

END