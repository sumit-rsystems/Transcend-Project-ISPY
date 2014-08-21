trigger DeleteToxicityOnAEBeforeDelete on AE_Detail__c (before delete) {
	
	Set<Id> aeIdSet = new Set<Id>();
	for(AE_Detail__c ae: Trigger.old) {
		aeIdSet.add(ae.Id);
	}
	
	List<Toxicity__c> toxicityList = [select Id From Toxicity__c where AE_Detail__c IN :aeIdSet];
	delete toxicityList;
}