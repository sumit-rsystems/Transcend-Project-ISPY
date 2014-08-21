trigger DCISBeforeTrigger on DCIS__c (before delete, before insert, before update) {
	//On_Study_Pathology_Form__c	Lookup(On-Study Pathology Form)
	//Post_Surgery_Summary__c	Lookup(Post Surgery Summary)
	List<DCIS__c> DCISList;
	Set<Id> OnStudyPathologyIds = new Set<Id>();
	Set<Id> PostSurgerySummaryIds = new Set<Id>();
	if(Trigger.isInsert || Trigger.isUpdate){
		DCISList = Trigger.new;
	}
	if(Trigger.isDelete){
		DCISList = Trigger.old;
	}
	
	for(DCIS__c d : DCISList) {
		if(d.On_Study_Pathology_Form__c != null){
			OnStudyPathologyIds.add(d.On_Study_Pathology_Form__c);
		}
		else if(d.Post_Surgery_Summary__c != null){
			PostSurgerySummaryIds.add(d.Post_Surgery_Summary__c);
		}
	}
	
	//On_Study_Pathology_Form__c
	if(!OnStudyPathologyIds.isEmpty()){
		Map<Id, On_Study_Pathology_Form__c> mapOnStudyPathology = new Map<Id, On_Study_Pathology_Form__c>([select Id, Status__c from On_Study_Pathology_Form__c where Id IN :OnStudyPathologyIds]);
		for(DCIS__c d : DCISList) {
			if(d.On_Study_Pathology_Form__c == null)continue;
			if(mapOnStudyPathology.get(d.On_Study_Pathology_Form__c) != null && (mapOnStudyPathology.get(d.On_Study_Pathology_Form__c).Status__c == 'Approval Not Required' || mapOnStudyPathology.get(d.On_Study_Pathology_Form__c).Status__c == 'Accepted')){
			}
		}
	}
	
	//Post_Surgery_Summary__c
	if(!PostSurgerySummaryIds.isEmpty()){
		Map<Id, Post_Surgaory_Summary__c> mapPostSurgerySummary = new Map<Id, Post_Surgaory_Summary__c>([select Id, Status__c from Post_Surgaory_Summary__c where Id IN :PostSurgerySummaryIds]);
		for(DCIS__c d : DCISList) {
			if(d.Post_Surgery_Summary__c == null)continue;
			if(mapPostSurgerySummary.get(d.Post_Surgery_Summary__c) != null && (mapPostSurgerySummary.get(d.Post_Surgery_Summary__c).Status__c == 'Approval Not Required' || mapPostSurgerySummary.get(d.Post_Surgery_Summary__c).Status__c == 'Accepted')){
			}
		}
	}
}