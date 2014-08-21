trigger LabUserBeforeDelete on LabUser__c (before delete) {
	
	Set<Id> labIds = new Set<Id>();
	Set<Id> userIds = new Set<Id>();
	for(LabUser__c labUser : trigger.old) {
		labIds.add(labUser.Lab__c);
		userIds.add(labUser.User__c);
	}
	
	List<InstitutionUser__c> lstInstUser = [select Site__c, User__c from InstitutionUser__c where 
						Site__c IN :labIds and User__c IN :userIds];
	List<InstitutionUser__c> lstInstUserToBeDeleted = new List<InstitutionUser__c>();
	for(LabUser__c labUser : trigger.old) {
		for(InstitutionUser__c instUser : lstInstUser) {
			if(labUser.Lab__c == instUser.Site__c && labUser.User__c == instUser.User__c) {
				lstInstUserToBeDeleted.add(instUser);
			}
		}
	}
	
	delete lstInstUserToBeDeleted;
}