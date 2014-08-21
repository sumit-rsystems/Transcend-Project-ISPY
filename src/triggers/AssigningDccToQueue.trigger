trigger AssigningDccToQueue on Account (after insert, after update) {
	
	List<RecordType> recType = [select id,Name,SobjectType from RecordType where SobjectType = 'Account' and Name IN ('DCC', 'DCC Safety Group')];
	List<Group> lstGrp = new List<Group>();
	Set<String> gnames = new Set<String>();
	for(Account acc : Trigger.new){
		if(Trigger.isInsert) {
			Group g = new Group();
	        g.Name = acc.Inst_Group__c;
	        insert g;
	        lstGrp.add(g);
			for(RecordType rt : recType) {
				if(acc.RecordTypeId == rt.Id) {
					gnames.add(acc.Inst_Group__c);
					break;
				}
			}
		} else if(Trigger.isUpdate) {
			
			for(RecordType rt : recType) {
				if(acc.RecordTypeId == rt.Id && acc.RecordTypeId != Trigger.oldMap.get(acc.Id).RecordTypeId) {
					gnames.add(acc.Inst_Group__c);
					break;
				}
			}
		}
	}
	QueueCreation.createGroup(gnames);
	
	if(Trigger.isInsert) {
		List<AccountShare> lstAccountShare = new List<AccountShare>();
		for(Account acc : Trigger.new){
			for(Group grp : lstGrp) {
				if(grp.Name == acc.Inst_Group__c) {
					AccountShare accShare = new AccountShare();
					accShare.AccountAccessLevel = 'Read';
					accShare.AccountId = acc.Id;
					accShare.UserOrGroupId = grp.Id;
					accShare.OpportunityAccessLevel = 'Read';
					lstAccountShare.add(accShare);
				}
			}
		}
		
		if(!lstAccountShare.isEmpty()) {
			insert lstAccountShare;
		}
	}
}