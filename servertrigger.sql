create trigger brute_force_control_logon
on all server 
for LOGON
as 
begin
--bu script kay�t altina ipnin ka� defa brute force yapt�g�n� g�sterir
declare @count as int
select @count=count(*) from AUDIT.dbo.brute_force_attack
where COMPUTERIP=CONNECTIONPROPERTY('client_net_address')
if @count>0
begin
rollback --e�er ssiteme girdiyse bile yap�lan i�lemi geri al demek
end



end


--select CONNECTIONPROPERTY('client_net_address') -- su anda ba�l� olan cihaz�n ipsini verir