trigger RegistarionRecShareing on Registration__c (after insert) {
	
	
	//==========================DCC Sharing================================//
	set<Id> instIds = new set<Id>();
	set<Id> trialIds = new set<Id>();
	List<Id> patientIds = new List<Id>();
	set<String> dccNames = new set<String>();
	for(Registration__c reg : Trigger.new){
		instIds.add(reg.Institution__c);
		trialIds.add(reg.Trial__c);
		patientIds.add(reg.Patient__c);
	}
	List<InstitutionTrialDcc__c> lstInstTrialDcc = [select id,DCC_Id__c,DCC_Id__r.Name,Institution_Id__c,Trial_Id__c from InstitutionTrialDcc__c where Institution_Id__c IN : instIds and Trial_Id__c IN : trialIds];
	for(Registration__c reg : Trigger.new){
		for(InstitutionTrialDcc__c instTrialDcc : lstInstTrialDcc){
			if(reg.Institution__c == instTrialDcc.Institution_Id__c && reg.Trial__c == instTrialDcc.Trial_Id__c){
				dccNames.add(instTrialDcc.DCC_Id__r.Name);
			}
		}
	}
	set<Id> lstInstIds = new set<Id>();
	set<String> SiteNames = new set<String>();
	List<InstitutionUser__c> lstInstTrialUser = [select id,Institution__c,Site__c,Site__r.Name,Trial__c,User__c from InstitutionUser__c where Institution__c IN : instIds and Trial__c IN : trialIds];
	for(Registration__c reg : Trigger.new){
		for(InstitutionUser__c insUser : lstInstTrialUser){
			if(reg.Institution__c == insUser.Institution__c && reg.Trial__c == insUser.Trial__c){
				SiteNames.add(insUser.Site__r.Name);
				lstInstIds.add(insUser.Institution__c);
			}
		}
	}
	
	List<Account> lstInst = [select Id,Name from Account where Id IN :lstInstIds];
	set<String> lstNames = new set<String>();
	for(Account acc : lstInst){
		lstNames.add(acc.Name);
	}
	
	List<Group> lstGrp = [select Id,Name,Type from Group where (Name IN : dccNames or Name IN : SiteNames) and Type != 'Queue'];
	List<Group> lstGrp1 = [select Id,Name,Type from Group where Name IN : lstNames and Type = 'Queue'];
	//List<Patient_Custom__c> lstPat = [select id from Patient_Custom__c where Id IN : patientIds];
	System.debug('---------lstGrp--------->'+lstGrp.size());
	System.debug('---------lstGrp--------->'+lstGrp);
	List<Patient_Custom__Share> lstPatShare = new List<Patient_Custom__Share>();
	List<Registration__Share> lstRegShare = new List<Registration__Share>();
	for(Registration__c rec : Trigger.new){
		for(InstitutionTrialDcc__c insTrialDcc : lstInstTrialDcc){
			for(Id pc : patientIds){
				for(Group grp : lstGrp1){
					if(rec.Institution__c == insTrialDcc.Institution_Id__c && rec.Trial__c == insTrialDcc.Trial_Id__c && grp.Name == insTrialDcc.DCC_Id__r.Name){
						System.debug('---------grp.Id--------->'+grp.Id);
						Registration__Share regShare = new Registration__Share();
						regShare.AccessLevel = 'Read';
						regShare.ParentId = rec.Id;
						regShare.UserOrGroupId = grp.Id; 
						lstRegShare.add(regShare);
						
						Patient_Custom__Share patShare = new Patient_Custom__Share();
						patShare.AccessLevel = 'Edit';
						patShare.UserOrGroupId = grp.Id;
						patShare.ParentId = pc;
						lstPatShare.add(patShare);
					}
				}
			}
		}
	}
	if(!lstRegShare.isEmpty()){
		insert lstRegShare;
	}
	if(!lstPatShare.isEmpty()){
		insert lstPatShare;
	}
	//==========================Trial Sharing================================//
	
	
	
	List<Registration__Share> lstTrialRegShare = new List<Registration__Share>();
	for(Registration__c reg : Trigger.new){
		for(InstitutionUser__c instUser : lstInstTrialUser){
			for(Group grp : lstGrp){
				if(reg.Institution__c == instUser.Institution__c && reg.Trial__c == instUser.Trial__c && grp.Name == instUser.Site__r.Name){
					Registration__Share regShare = new Registration__Share();
					regShare.AccessLevel = 'Read';
					regShare.ParentId = reg.Id;
					regShare.UserOrGroupId = grp.Id; 
					lstTrialRegShare.add(regShare);
				}
			}
		}
	}
	if(!lstTrialRegShare.isEmpty()){
		insert lstTrialRegShare;
	}
}