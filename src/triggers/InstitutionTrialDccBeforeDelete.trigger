trigger InstitutionTrialDccBeforeDelete on InstitutionTrialDcc__c (before delete) {
	Set<Id> dccIds = new Set<Id>();
	Set<Id> instIds = new Set<Id>();
	for(InstitutionTrialDcc__c itd : Trigger.old) {
		dccIds.add(itd.DCC_Id__c);
		instIds.add(itd.Institution_Id__c);
	}
	
	//List<InstitutionTrialDcc__c> lstInstituteTrialDcc = [select Id, DCC_Id__c, Institution_Id__c from InstitutionTrialDcc__c where Id IN:Trigger.oldMap.keySet()];
	map<Id, Account> mapInstitute = new map<Id, Account>([select Id, Inst_Group__c from Account where Id IN:instIds]);
	List<Account> lstDCC = [select Id, Inst_Group__c, (Select AccountId, UserOrGroupId, AccountAccessLevel From Shares where AccountAccessLevel = 'Read') from Account where Id IN:dccIds];
	Set<String> groupNames = new Set<String>();
	for(Account inst : mapInstitute.values()) {
		groupNames.add(inst.Inst_Group__c);
	}
	system.debug('mapInstitute: '+mapInstitute);
	system.debug('groupNames: '+groupNames);
	List<Group> lstGroup = [select Id, Name from Group where Name IN:groupNames];
	List<AccountShare> lstDeleteAccountShare = new List<AccountShare>();
	for(Account dcc : lstDCC) {
		for(AccountShare ds : dcc.Shares) {
			for(Group grp : lstGroup){
				if(grp.Id == ds.UserOrGroupId){
					lstDeleteAccountShare.add(ds);
				}
			}
		}
	}
	
	if(!lstDeleteAccountShare.isEmpty()){
		delete lstDeleteAccountShare;
	}
}