trigger InstitutionTrialDccAfterTrigger on InstitutionTrialDcc__c (after insert, after update) {
	Set<Id> dccIds = new Set<Id>();
	for(InstitutionTrialDcc__c itd : Trigger.new) {
		dccIds.add(itd.DCC_Id__c);
	}
	
	List<InstitutionTrialDcc__c> lstInstituteTrialDcc = [select Id, DCC_Id__c, Institution_Id__c from InstitutionTrialDcc__c where DCC_Id__c IN:dccIds];
	
	Set<Id> instIds = new Set<Id>();
	for(InstitutionTrialDcc__c itd : lstInstituteTrialDcc) {
		instIds.add(itd.Institution_Id__c);
	}
	
	map<Id, Account> mapInstitute = new map<Id, Account>([select Id, Inst_Group__c from Account where Id IN:instIds]);
	List<Account> lstDCC = [select Id, Inst_Group__c, (Select AccountId, UserOrGroupId, AccountAccessLevel From Shares where AccountAccessLevel = 'Read') from Account where Id IN:dccIds];
	Set<String> groupNames = new Set<String>();
	for(Account inst : mapInstitute.values()) {
		groupNames.add(inst.Inst_Group__c);
	}
	system.debug('mapInstitute: '+mapInstitute);
	//delete all sharing with DCC
	List<AccountShare> lstDeleteAccountShare = new List<AccountShare>();
	for(Account dcc : lstDCC) {
		if(dcc.Shares.isEmpty()) continue;
		lstDeleteAccountShare.addAll(dcc.Shares);
	}
	
	if(!lstDeleteAccountShare.isEmpty()) {
		delete lstDeleteAccountShare;
	}
	
	//Create DCC sharing according to associated institiute
	List<Group> lstGroup = [select Id, Name from Group where Name IN:groupNames];
	List<AccountShare> lstAccountShare = new List<AccountShare>();
	for(InstitutionTrialDcc__c itd : lstInstituteTrialDcc) {
		for(Account dcc : lstDCC) {
			if(itd.DCC_Id__c != dcc.Id) continue;
			for(Group grp : lstGroup) {
				system.debug('mapInstitute: '+mapInstitute);
				system.debug('itd.Institution_Id__c: '+itd.Institution_Id__c);
				system.debug('mapInstitute.get(itd.Institution_Id__c): '+mapInstitute.get(itd.Institution_Id__c));
				system.debug('mapInstitute.get(itd.Institution_Id__c).Inst_Group__c: '+mapInstitute.get(itd.Institution_Id__c).Inst_Group__c);
				if(mapInstitute.get(itd.Institution_Id__c).Inst_Group__c == grp.Name) {
					AccountShare accShare = new AccountShare();
					accShare.AccountAccessLevel = 'Read';
					accShare.AccountId = dcc.Id;
					accShare.UserOrGroupId = grp.Id;
					accShare.OpportunityAccessLevel = 'Read';
					lstAccountShare.add(accShare);
				}
			}
		}
	}
	
	if(!lstAccountShare.isEmpty()) {
		insert lstAccountShare;
	}
}