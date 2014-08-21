trigger DeleteGroupMemberForDCC on DCC_User__c (before delete) {
	//collect Ids from Dcc User obejct
	set<Id> dccIds = new set<Id>();
	set<Id> dccUserIds = new set<Id>();
	for(DCC_User__c dc : Trigger.old){
		if(dc.DCC__c != null){
			dccIds.add(dc.DCC__c);
		}
		if(dc.User__c != null){
			dccUserIds.add(dc.User__c);
		}
	}
	
	List<Account> lstDCC = [select id,Name,Inst_Group__c from Account where id IN : dccIds];
	
	//collect group names from Dcc (Account) obejct
	set<String> dccNames = new set<String>();
	for(Account acc : lstDCC){
		dccNames.add(acc.Inst_Group__c);
	}
	
	Map<Id, Group> mapGrp = new Map<Id, Group>([select Id,Name,Type from Group where Name IN : dccNames and Type IN ('Queue','Regular')]);
	List<GroupMember> lstGM = [select Id, UserOrGroupId from GroupMember where GroupId IN :mapGrp.keySet()];
	
	//prepare group member's list to delete
	List<GroupMember> lstDeleteGM = new List<GroupMember>();
	for(DCC_User__c dc : Trigger.old){
		for(GroupMember gm : lstGM) {
			if(dc.User__c == gm.UserOrGroupId) {
				lstDeleteGM.add(gm);
			}
		}
	}
	//delete group members
	if(!lstDeleteGM.isEmpty()) {
		delete lstDeleteGM;
	}
}