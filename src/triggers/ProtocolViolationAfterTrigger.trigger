trigger ProtocolViolationAfterTrigger on ProtocolViolationDetail__c (after insert, after update) {
	//SharingManager.shareObjectWithSite(Trigger.new, 'ProtocolViolationDetail__c', 'Site');
	//SharingManager.shareObjectWithSite(Trigger.new, 'ProtocolViolationDetail__c', 'Lab');
	//SharingManager.shareObjectWithSite(Trigger.new, 'ProtocolViolationDetail__c', 'Lab Technician');
	//SharingManager.shareObjectWithSite(Trigger.new, 'ProtocolViolationDetail__c', 'Lab Supervisor');
	if(Trigger.isUpdate) {
		set<Id> originalIds = new set<Id>();
		for(ProtocolViolationDetail__c pvd : Trigger.new){
			if(pvd.Status__c == 'Approval Pending' && Trigger.oldMap.get(pvd.Id).Status__c != 'Approval Pending') {
				if(pvd.OriginalCRF__c != null) {
					originalIds.add(pvd.OriginalCRF__c);
				}
			}
		}
		
	//complete task for rejected crf	
		if(!originalIds.isEmpty()) {
			/*commented to get characters for other coding
			TaskManager.completeTaskOfRejectedCRF(originalIds);
			*/
		}
	}
}