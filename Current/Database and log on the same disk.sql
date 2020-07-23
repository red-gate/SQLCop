IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SQLCop].[test Database and Log files on the same disk]') AND type in (N'P', N'PC'))
DROP PROCEDURE [SQLCop].[test Database and Log files on the same disk]
GO

create procedure [SQLCop].[test Database and Log files on the same disk]
as
begin
    -- Written by Michal Piatek
    -- July 23rd, 2020
	-- Now works with mountpoints

    set nocount on

	declare @Output varchar(max) = '';
	declare @mytable table (id int identity(1,1) not null, content nvarchar(max));


    with [cte]
    as (select distinct
               db_name([volsta].[database_id]) collate Latin1_General_CI_AS_KS_WS [DBName] 
             , [mf].[name]   collate Latin1_General_CI_AS_KS_WS                 as [DBFileName]
             , [mf].[type_desc]     collate Latin1_General_CI_AS_KS_WS           as [Type]
             , [mf].[physical_name]   collate Latin1_General_CI_AS_KS_WS         [PhysicalFileLocation]
             , [volsta].[logical_volume_name] collate Latin1_General_CI_AS_KS_WS as [LogicalName]
             , [volsta].[volume_mount_point]  collate Latin1_General_CI_AS_KS_WS as [Drive]
        from [sys].[master_files]                                                      as [mf]
            cross apply [sys].[dm_os_volume_stats]([mf].[database_id], [mf].[file_id]) as [volsta] )
		
		insert into @mytable
		(
		    [content]
		)
		
		select   ( [a].[DBName] + ' has the file ' +  [a].[DBFilename] + ' which is '  +[a].[Type] 
		   +' on Disk '  +[a].[PhysicalFileLocation] + ' the logical Volume Name is '  + [b].[LogicalName] ) as content
		      from [cte]     as [a] 
        join [cte] as [b]   
            on [a].[DBName] = [b].[DBName] 
    where [a].[LogicalName] = [b].[LogicalName]
          and [a].[Type] <> [b].[Type]
          and [a].[DBName] <> lower('TEMPDB')

	select @output = coalesce(@output +char(10) + char(13) + content, content) from @mytable



		  

		      if @Output > ''
    begin
        set @Output
            = char(13) + char(10) + 'For more information:  '
              + 'https://github.com/red-gate/SQLCop/wiki/Database-and-log-on-same-disk' + char(13) + char(10)
              + char(13) + char(10) + @Output
        exec [tSQLt].[Fail] @Message0=@Output
    end
end;