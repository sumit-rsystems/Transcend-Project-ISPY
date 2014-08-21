trigger PostSurgeryAfterTrigger on Post_Surgaory_Summary__c (after insert, after update) {
	if(Trigger.isUpdate){
		Set<Id> postIds = new Set<Id>();
		set<Id> crfIds = new set<Id>();
		set<Id> trialPatIds = new set<Id>();
		set<Id> pssIdSet = new set<Id>();
		for(Post_Surgaory_Summary__c pss : Trigger.new){
			system.debug('__pss.Status__c__'+pss.Status__c);
			if(pss.Status__c != 'Accepted') continue;
			crfIds.add(pss.CRF__c);
			postIds.add(pss.Id);
			trialPatIds.add(pss.TrialPatient__c);
			if(((pss.Status__c != 'Cloned' && Trigger.oldMap.get(pss.Id).Status__c != 'Cloned')) && ((pss.Status__c == 'Accepted' && Trigger.oldMap.get(pss.Id).Status__c != 'Accepted') || (pss.Status__c == 'Rejected' && Trigger.oldMap.get(pss.Id).Status__c != 'Rejected') || (pss.Status__c == 'Approval Not Required' && Trigger.oldMap.get(pss.Id).Status__c != 'Approval Not Required'))) {
				system.debug('pss.Status__c: '+pss.Status__c+', Trigger.oldMap.get(pss.Id).Status__c: '+Trigger.oldMap.get(pss.Id).Status__c);
				pssIdSet.add(pss.Id);
			}
		}
		system.debug('__trialPatIds__'+trialPatIds);
		if(!trialPatIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.createTaskAfterPostSurgery(trialPatIds);
			*/
		}
		
		if(!pssIdSet.isEmpty()) {
			for(Post_Surgaory_Summary__c currentValue : trigger.new){
				for(Post_Surgaory_Summary__c previousValue : trigger.old){
					if(currentValue.Date_Of_Procedure__c != previousValue.Date_Of_Procedure__c){
						RandomizationXMLBuilder.updatePatientXMLForPCR(pssIdSet);
					}
				}
			}
		}
		
		List<Snomed_Code__c> lstSnomedCode = [select id,CRF__c,Name from Snomed_Code__c where CRF__c IN : crfIds and snomed_Code_Name__c IN ('103338009 | in complete remission |'
										, 'IHTSDO_4583_2', 'IHTSDO_4583_1', 'IHTSDO_4575', '371510003 | proportion of specimen involved by tumour |'
										, '364708003 | sample observable |')];
		if(!lstSnomedCode.isEmpty()) {
			delete lstSnomedCode;
		}
		if(!postIds.isEmpty()) {
			SnomedCTCode.insertSnomedCodesForPostSurgery(postIds);
		}
	}
}