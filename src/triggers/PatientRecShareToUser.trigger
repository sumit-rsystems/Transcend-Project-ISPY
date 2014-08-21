trigger PatientRecShareToUser on Patient_Custom__c (after insert) {
	
	set<Id> lstInstIds = new set<Id>();
	List<Patient_Custom__Share> lstPatShare = new List<Patient_Custom__Share>();
	/*List<InstitutionUser__c> lstInstUser = [select id,Institution__c,Site__r.Name,User__c from InstitutionUser__c where User__c = : UserInfo.getUserId()];
	for(InstitutionUser__c instUser : lstInstUser){
		lstInstIds.add(instUser.Institution__c);
	}*/
	for(Patient_Custom__c pc : Trigger.new){
		lstInstIds.add(pc.Institution__c);
	}
	
	List<Account> lstInst = [select Id,Name,Inst_Group__c from Account where Id IN :lstInstIds];
	set<String> lstNames = new set<String>();
	for(Account acc : lstInst){
		lstNames.add(acc.Inst_Group__c);
	}
	List<Group> lstGrp = [select Id,Name,Type from Group where Name IN : lstNames and Type = 'Regular'];
	
	for(Patient_Custom__c pc : Trigger.new){
		for(Account acc : lstInst){
			if(acc.Id == pc.Institution__c){
				for(Group grp : lstGrp){
					if(acc.Inst_Group__c == grp.Name){
						Patient_Custom__Share patShare = new Patient_Custom__Share();
						patShare.AccessLevel = 'Edit';
						patShare.UserOrGroupId = grp.Id;
						patShare.ParentId = pc.Id;
						lstPatShare.add(patShare);
					}
				}
			}
		}
	}
	if(!lstPatShare.isEmpty()){
		insert lstPatShare;
	}
}