alter proc BRUTE_FORCE_DETECTION
as
CREATE TABLE #LOG(LOGDATE DATETIME, PROCESSINFO VARCHAR(100),TEXT VARCHAR(MAX))
--TRUNCATE TABLE #LOG
INSERT INTO #LOG exec XP_readerrorLOG  
--SELECT * FROM #LOG WHERE TEXT LIKE 'login failed%' AND logdate>=DATEADD(MINUTE,-3,GETDATE());--it take log which before 3 minutes
--select getdate(),DATEADD(MINUTE,-3,GETDATE())-- it take a time of now

declare @seq as int
declare @IP as varchar(20)
declare @count as int
declare @begdate as datetime
declare @enddate as datetime
declare @msg as varchar(max)=''
declare @text as varchar(max)=''

select @count=count(*),@begdate=min(LOGDATE),@enddate=max(logdate), @text=TEXT
from #LOG WHERE TEXT LIKE 'login failed%' AND logdate>=DATEADD(MINUTE,-3,GETDATE())
group by text having count(logdate)>100 --en az kaç tane hatalý þifre denemesi bizim icin tehlikedir
select @seq = seq from master.dbo.SplitWithSeq(@text,' ')
where items='[CLIENT:'
select @IP=items from master.dbo.SplitWithSeq(@text,' ')
where seq=@seq+1
set @IP=Replace(@IP,']','')
set @msg='Your system is under attack! A machine with ip: '
set @msg=@msg + @IP
set @msg=@msg + ' has tried ' + CONVERT(varchar,@count)+' wrong password between '
set @msg=@msg + CONVERT(varchar,@begdate,108)+' and ' + CONVERT(varchar,@enddate,108)
select @msg
if @count>100
begin
insert into AUDIT.dbo.brute_force_attack([ComputerIP], [Date_], [Begdate], [Endate], [Count_])
values(@IP,GETDATE(),@begdate,@enddate,@count);

EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'sqlmail1',  
    @recipients = 'mysqlserver11@gmail.com',
    @body = @msg,  
    @subject = 'Brute Force Attack Detected' ;  
end
	drop Table #LOG