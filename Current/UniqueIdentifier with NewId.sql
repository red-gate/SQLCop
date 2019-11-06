IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test UniqueIdentifier with NewId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test UniqueIdentifier with NewId]
GO

CREATE PROCEDURE [SQLCop].[test UniqueIdentifier with NewId]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012

	SET NOCOUNT ON

	DECLARE @Output VarChar(max)
	SET @Output = ''

	SELECT  @Output = @Output + so.name + '.' + col.name + Char(13) + Char(10)
	FROM    sysobjects so
			INNER JOIN sysindexes sind
				ON so.id=sind.id
			INNER JOIN sysindexkeys sik
				ON sind.id=sik.id
				AND sind.indid=sik.indid
			INNER JOIN syscolumns col
				ON col.id=sik.id
				AND col.colid=sik.colid
			INNER JOIN systypes
				ON col.xtype = systypes.xtype
			INNER JOIN syscomments
				ON col.cdefault = syscomments.id
	WHERE	sind.Status & 16 = 16
			AND systypes.name = 'uniqueidentifier'
			AND keyno = 1
			AND sind.OrigFillFactor = 0
			AND syscomments.TEXT COLLATE SQL_LATIN1_GENERAL_CP1_CI_AI Like '%newid%'
			and so.name <> 'tSQLt'
	ORDER BY so.name, sik.keyno

	If @Output > ''
		Begin
			Set @Output = Char(13) + Char(10)
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Uniqueidentifier-with-NewId'
						  + Char(13) + Char(10)
						  + Char(13) + Char(10)
						  + @Output
			EXEC tSQLt.Fail @Output
		End
END;