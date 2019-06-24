IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Columns with image data type]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Columns with image data type]
GO

CREATE PROCEDURE [SQLCop].[test Columns with image data type]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
	SET @Output = ''

	SELECT  @Output = @Output + SCHEMA_NAME(o.uid) + '.' + o.Name + '.' + col.name
	from    syscolumns col         
			Inner Join sysobjects o
				On col.id = o.id         
			inner join systypes           
	 			On col.xtype = systypes.xtype 
	Where   o.type = 'U'         
			And ObjectProperty(o.id, N'IsMSShipped') = 0         
			And systypes.name In ('image') 
			And SCHEMA_NAME(o.uid) <> 'tSQLt'
	Order By SCHEMA_NAME(o.uid),o.Name, col.Name
			
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Columns-with-image-data-type' 
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End
	    
END;