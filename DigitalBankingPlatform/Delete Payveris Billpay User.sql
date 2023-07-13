USE [bb-dbs]
GO

--DECLARE  @ExternalUserId NVARCHAR(250) = '3c15c51a-62a7-4465-8013-f2d5cdf7145e'

DECLARE  @ExternalUserId NVARCHAR(250) = ''
,@UserId INT
,@RunDelete BIT = 0

select
@UserId = Id
FROM WSECU.payveris_billpay_user
where external_user_id = @ExternalUserId

SELECT
Id
,external_user_id
FROM WSECU.payveris_billpay_user
where Id = @UserId
AND external_user_id = @ExternalUserId

IF @RunDelete = 1
BEGIN
	DELETE FROM WSECU.payveris_billpay_user
	WHERE Id = @UserId
	AND external_user_id = @ExternalUserId;
END

SELECT
Id
,external_user_id
FROM WSECU.payveris_billpay_user
where Id = @UserId
AND external_user_id = @ExternalUserId
