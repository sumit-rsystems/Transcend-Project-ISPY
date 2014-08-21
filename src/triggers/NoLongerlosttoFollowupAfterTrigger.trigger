trigger NoLongerlosttoFollowupAfterTrigger on No_Longer_lost_to_Followup__c (after insert, after update) {
	if(Trigger.isUpdate) {
		set<Id> originalIds = new set<Id>();
		for(No_Longer_lost_to_Followup__c llf : Trigger.new){
			if(llf.Status__c == 'Approval Pending' && Trigger.oldMap.get(llf.Id).Status__c != 'Approval Pending') {
				if(llf.OriginalCRF__c != null) {
					originalIds.add(llf.OriginalCRF__c);
				}
			}
		}
		
	//complete task for rejected crf	
		/*commented to get characters for other coding
		if(!originalIds.isEmpty()) {
			TaskManager.completeTaskOfRejectedCRF(originalIds);
		}
		*/
	}
}