trigger AgentBeforeInsertUpdateTrigger on Agent__c (before insert, before update) {
	List<Agent__c> lstAgent = Trigger.new;
	integer size = [select count() from Agent__c];
	for(Agent__c agent : lstAgent) {
		if(agent.Display_Order__c == null) {
			agent.Display_Order__c = size + 1;
		}
	}
}