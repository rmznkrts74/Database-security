USE [master]
GO
/****** Object:  UserDefinedFunction [dbo].[SplitWithSeq]    Script Date: 30.08.2019 15:33:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[SplitWithSeq](@String varchar(MAX), @Delimiter char(1))     
returns @temptable TABLE (items varchar(MAX), seq int)     
as     
begin     
	declare @i int
	set @i = 0
	declare @idx int     
	declare @slice varchar(MAX)     
    
	select @idx = 1     
		if len(@String)<1 or @String is null  return     
    
	while @idx!= 0     
	begin     
		set @i = @i + 1
		set @idx = charindex(@Delimiter,@String)     
		if @idx!=0     
			set @slice = left(@String,@idx - 1)     
		else     
			set @slice = @String     
		
		if(len(@slice)>0)
			insert into @temptable(items,seq) values(@slice,@i)     

		set @String = right(@String,len(@String) - @idx)     
		if len(@String) = 0 break     
	end 
return     
end

