IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID('[SQLCop].[DmOsPerformanceCountersPermissionErrors]') AND TYPE = 'FN')
DROP FUNCTION [SQLCop].[DmOsPerformanceCountersPermissionErrors]
GO

CREATE FUNCTION [SQLCop].[DmOsPerformanceCountersPermissionErrors]()
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @Result VARCHAR(MAX)
    SET @Result = ''

    IF (SERVERPROPERTY('EngineEdition') = 5)
        BEGIN
            IF (DATABASEPROPERTYEX(DB_NAME(), 'Edition') = 'Premium')
                BEGIN
                    IF NOT EXISTS(SELECT 1 FROM sys.fn_my_permissions(NULL, 'DATABASE') WHERE permission_name = 'VIEW DATABASE STATE')
                        SET @Result = 'You do not have VIEW DATABASE STATE permissions for this database.'
                END
            ELSE
                BEGIN
                    IF NOT EXISTS(SELECT 1 FROM sys.fn_my_permissions('sys.dm_os_performance_counters', 'OBJECT') WHERE permission_name = 'EXECUTE')
                        SET @Result = 'You do not have server admin or Azure active directory admin permissions.'
                END
        END
    ELSE
        BEGIN
            IF NOT EXISTS(SELECT 1 FROM sys.fn_my_permissions(NULL, 'SERVER') WHERE permission_name = 'VIEW SERVER STATE')
                SET @Result = 'You do not have VIEW SERVER STATE permissions within this instance.'
        END
    RETURN @Result
END