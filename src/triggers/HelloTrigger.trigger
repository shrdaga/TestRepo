trigger HelloTrigger on Account (before insert) {
    for(Account a : Trigger.New) {
        a.Description = 'New description';
		if(a.name=='Acme') {
			a.NumberOfEmployees = 1;
		}
    }   
}