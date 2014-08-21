trigger LymphNodeBeforeInsertTrigger on Lymph_Nodes__c (before insert) {

	Set<Id> procedureIds = new Set<Id>();
	for(Lymph_Nodes__c l : Trigger.new) {
		procedureIds.add(l.Procedure__c); 
	}
	
	List<Procedure__c> procList = [Select p.Post_Surgery_Summary__c From Procedure__c p where id in :procedureIds];
	for(Lymph_Nodes__c l : Trigger.new) {
		for(Procedure__c proc : procList) {
			if(l.Procedure__c == proc.Id) {
				l.Post_Surgery_Summary__c = proc.Post_Surgery_Summary__c;
				break;
			}
		} 
	}
}