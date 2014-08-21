trigger TissueSpecimenAfterTrigger on TissueSpecimenDetail__c (after insert, after update) {
	if(trigger.isInsert) {
		SharingManager.shareObjectWithSite(Trigger.new, 'TissueSpecimenDetail__c', 'Site');
		SharingManager.shareObjectWithSite(Trigger.new, 'TissueSpecimenDetail__c', 'Lab');
		/*commented to get characters for other coding
		TaskManager.updateTaskStatusToInProgress('TissueSpecimenDetail__c', trigger.newMap.keySet());
		*/
	}
	//SharingManager.shareObjectWithSite(Trigger.new, 'TissueSpecimenDetail__c', 'Lab Technician');
	//SharingManager.shareObjectWithSite(Trigger.new, 'TissueSpecimenDetail__c', 'Lab Supervisor');
	if(trigger.isUpdate) {
		Set<Id> tissueIds = new Set<Id>();
		for(TissueSpecimenDetail__c tsd: trigger.new) {
			if(tsd.Status__c != 'Approval Not Required') continue;
			tissueIds.add(tsd.Id);
		}
		if(!tissueIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.updateTask(tissueIds, 'TissueSpecimenDetail__c');
			*/
		}
	}
}