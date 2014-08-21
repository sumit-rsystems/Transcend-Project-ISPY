trigger TaskOnAfterTrigger on Task (after update) {
	Set<String> taskGrpIds = new Set<String>();
	for(Task tsk : Trigger.new) {
		system.debug('__tsk.Id__'+tsk.Id);
		if(tsk.Status == 'Completed' && Trigger.oldMap.get(tsk.Id).Status != 'Completed' && tsk.Group_Id__c != null) {
			taskGrpIds.add(tsk.Group_Id__c);
		}
	}
	system.debug('__Trigger.newMap.keySet()__'+Trigger.newMap.keySet());
	if(!taskGrpIds.isEmpty()) {
		List<Task> lstUpdateTask = [select ActivityDate, Object_Label__c, Object_Name__c, CRF_Form_Id__c, Subject, Type, WhatId, Status, Schedule_Event_Date__c,Trial_Id__c from Task where Status != 'Completed' and Group_Id__c IN :taskGrpIds and Id NOT IN :Trigger.newMap.keySet()];
		system.debug('__lstUpdateTask__'+lstUpdateTask);
		for(Task tsk : lstUpdateTask) {
			system.debug('__tsk.Id__'+tsk.Id);
			tsk.Status = 'Completed';
		}
		
		if(!lstUpdateTask.isEmpty()) {
			update lstUpdateTask;
		}
	}
}