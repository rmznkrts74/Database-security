create trigger brute_force_control_logon
on all server 
for LOGON
as 
begin
--bu script kayýt aloýnan ipnin kaç defa brute force yaptýgýný gösterir
declare @count as int
select @count=count(*) from AUDIT.dbo.brute_force_attack
where COMPUTERIP=CONNECTIONPROPERTY('client_net_address')
if @count>0
begin
rollback --eðer ssiteme girdiyse bile yapýlan iþlemi geri al demek
end



end


--select CONNECTIONPROPERTY('client_net_address') -- su anda baðlý olan cihazýn ipsini verir