trigger LosttoFollowupAfterTrigger on Lost_to_Follow_Up__c (after insert, after update) {
	if(Trigger.isUpdate) {
		set<Id> originalIds = new set<Id>();
		for(Lost_to_Follow_Up__c ltf : Trigger.new){
			if(ltf.Status__c == 'Approval Pending' && Trigger.oldMap.get(ltf.Id).Status__c != 'Approval Pending') {
				if(ltf.OriginalCRF__c != null) {
					originalIds.add(ltf.OriginalCRF__c);
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