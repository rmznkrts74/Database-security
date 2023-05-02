EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'profilename',  
    @recipients = 'yourmail@gmail.com',
    @body = 'test',  
    @subject = 'Automated Success Message' ;  