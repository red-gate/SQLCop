IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Fragmented Indexes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Fragmented Indexes]
GO

CREATE PROCEDURE [SQLCop].[test Fragmented Indexes]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	-- http://sqlcop.lessthandot.com
	
	SET NOCOUNT ON
	
	DECLARE @Output VarChar(max)
	SET @Output = ''

	Create Table #Result (ProblemItem VarChar(1000))
	
	If Exists(Select cmptlevel from master.dbo.sysdatabases Where dbid = db_ID() And cmptlevel > 80)
		If Exists(Select 1 From fn_my_permissions(NULL, 'DATABASE') WHERE permission_name = 'VIEW DATABASE STATE')
			Begin
				Insert Into #Result(ProblemItem)
				Exec('
						SELECT	OBJECT_NAME(OBJECT_ID) + ''.'' + s.name As ProblemItem
						FROM	sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, N''LIMITED'') d
								join sysindexes s
									ON	d.OBJECT_ID = s.id
									and d.index_id = s.indid
						Where	avg_fragmentation_in_percent >= 30
								And OBJECT_NAME(OBJECT_ID) + ''.'' + s.name > ''''
								And page_count > 1000
								Order By Object_Name(OBJECT_ID), s.name')
			End
		Else
			Set @Output = 'You do not have VIEW DATABASE STATE permissions within this database'
		Else
			Set @Output = 'Unable to check index fragmentation when compatibility is set to 80 or below'
			  
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'Your index will get fragmented over time if you do a lot of updates or insert and deletes.'
						  + Char(13) + Char(10) 
						  + 'There are two ways to fix fragmentation, one is to reorganize the index and the other is to rebuild the index.'
						  + Char(13) + Char(10) 
						  + 'Reorganize is an online operation while rebuild is not unless you specify ONLINE = ON'
						  + Char(13) + Char(10) 
						  + 'ONLINE = ON will only work on Enterprise editions of SQL Server.'
						  + Char(13) + Char(10)
						  + 'ALTER INDEX indexName ON tableName'
						  + Char(13) + Char(10)
						  + 'REORGANIZE;'
						  + Char(13) + Char(10)
						  + 'or'
						  + Char(13) + Char(10)
						  + 'ALTER INDEX indexName ON tableName'
						  + Char(13) + Char(10)
						  + 'REBUILD;'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End	  
END;