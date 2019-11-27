IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Page life expectancy]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Page life expectancy]
GO

CREATE PROCEDURE [SQLCop].[test Page life expectancy]
AS
BEGIN
    -- Written by George Mastros
    -- February 25, 2012

    SET NOCOUNT ON

    Declare @Output VarChar(max), @PermissionsError VarChar(max)
    Set @Output = ''
    Set @PermissionsError = SQLCop.DmOsPerformanceCountersPermissionErrors()
    
    If (@PermissionsError = '')
        SELECT  @Output = @Output + Convert(VarChar(100), cntr_value) + Char(13) + Char(10)
        FROM    sys.dm_os_performance_counters
        WHERE   counter_name collate SQL_LATIN1_GENERAL_CP1_CI_AI = 'Page life expectancy'
                AND OBJECT_NAME collate SQL_LATIN1_GENERAL_CP1_CI_AI like '%:Buffer Manager%'
                And cntr_value <= 300
    Else
        Set @Output = @PermissionsError

    If @Output > ''
        Begin
            Set @Output = Char(13) + Char(10)
                          + 'For more information:  '
                          + 'https://github.com/red-gate/SQLCop/wiki/Page-life-expectancy'
                          + Char(13) + Char(10)
                          + Char(13) + Char(10)
                          + @Output
            EXEC tSQLt.Fail @Output
        End
END;
