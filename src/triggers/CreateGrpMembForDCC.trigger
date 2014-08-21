trigger CreateGrpMembForDCC on DCC_User__c (after insert) {
	
	set<String> dccNames = new set<String>();
	set<Id> dccIds = new set<Id>();
	List<GroupMember> lstGm = new List<GroupMember>();
	for(DCC_User__c dc : Trigger.new){
		if(dc.DCC__c != null){
			dccIds.add(dc.DCC__c);
		}
	}
	
	List<Account> lstDCC = [select id,Name,Inst_Group__c from Account where id IN : dccIds];
	
	for(Account acc : lstDCC){
		dccNames.add(acc.Inst_Group__c);
	}
	List<Group> lstGrp = [select Id,Name,Type from Group where Name IN : dccNames and Type IN ('Queue','Regular')];
	for(DCC_User__c dc : Trigger.new){
		for(Account acc : lstDCC){
			for(Group grp : lstGrp){
				if(acc.Inst_Group__c == grp.Name){
					QueueCreation.createGroupMemb(grp.Id, dc.User__c);
				}
			}
		}
	}
}