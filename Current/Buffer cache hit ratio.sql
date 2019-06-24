IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Buffer cache hit ratio]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Buffer cache hit ratio]
GO

CREATE PROCEDURE [SQLCop].[test Buffer cache hit ratio]
AS
BEGIN
	-- Written by George Mastros
	-- February 25, 2012
	
	SET NOCOUNT ON
	
	Declare @Output VarChar(max)
    Set @Output = ''

	If Exists(Select 1 From fn_my_permissions(NULL, 'SERVER') WHERE permission_name = 'VIEW SERVER STATE')
		SELECT	@Output = Convert(DECIMAL(4,1), (a.cntr_value * 1.0 / b.cntr_value) * 100.0)
		FROM	sys.dm_os_performance_counters  a
				JOIN  (
					SELECT cntr_value,OBJECT_NAME
					FROM   sys.dm_os_performance_counters  
					WHERE  counter_name collate SQL_LATIN1_GENERAL_CP1_CI_AI = 'Buffer cache hit ratio base'
							AND OBJECT_NAME collate SQL_LATIN1_GENERAL_CP1_CI_AI like '%Buffer Manager%'
					) b 
					ON  a.OBJECT_NAME = b.OBJECT_NAME
		WHERE	a.counter_name collate SQL_LATIN1_GENERAL_CP1_CI_AI = 'Buffer cache hit ratio'
				AND a.OBJECT_NAME collate SQL_LATIN1_GENERAL_CP1_CI_AI like '%:Buffer Manager%'
				and Convert(DECIMAL(4,1), (a.cntr_value * 1.0 / b.cntr_value) * 100.0) < 95
	Else
		Set @Output = 'You do not have VIEW SERVER STATE permissions within this instance.'
    
	If @Output > '' 
		Begin
			Set @Output = Char(13) + Char(10) 
						  + 'For more information:  '
						  + 'https://github.com/red-gate/SQLCop/wiki/Buffer-cache-hit-ratio'
						  + Char(13) + Char(10) 
						  + Char(13) + Char(10) 
						  + @Output
			EXEC tSQLt.Fail @Output
		End 
END;