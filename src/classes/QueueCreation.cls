public with sharing class QueueCreation {
	@future (callout=true)
	public static void createGroup(Set<String> names) {
		
		/*Group g1 = new Group();
        g1.Name = name;
        insert g1;*/
		for(String name : names) {
			Group g = new Group();
			g.Name = name;
			g.Type='Queue';
			insert g;
			system.debug('-----Queue Created--------->');
			
			QueueSobject q = new QueueSobject();
			q.QueueId = g.Id;
			q.SobjectType = 'Menopausal_Status_Detail__c';
			
			if(!test.isRunningTest()){
				insert q;
			}
			
			QueueSobject q1 = new QueueSobject();
			q1.QueueId = g.Id;
			q1.SobjectType = 'MRI_Volume__c';
			
			if(!test.isRunningTest()){
				insert q1;
			}
			
			QueueSobject q2 = new QueueSobject();
			q2.QueueId = g.Id;
			q2.SobjectType = 'TissueSpecimenDetail__c';
			
			if(!test.isRunningTest()){
				insert q2;
			}
			
			QueueSobject q3 = new QueueSobject();
			q3.QueueId = g.Id;
			q3.SobjectType = 'Registration__c';
			
			if(!test.isRunningTest()){
				insert q3;
			}
			
			QueueSobject q4 = new QueueSobject();
			q4.QueueId = g.Id;
			q4.SobjectType = 'On_Study_Eligibility_Form__c';
			
			if(!test.isRunningTest()){
				insert q4;
			}
			
			QueueSobject q5 = new QueueSobject();
			q5.QueueId = g.Id;
			q5.SobjectType = 'MammaPrintDetail__c';
			
			if(!test.isRunningTest()){
				insert q5;
			}
			
			QueueSobject q6 = new QueueSobject();
			q6.QueueId = g.Id;
			q6.SobjectType = 'ProtocolViolationDetail__c';
			
			if(!test.isRunningTest()){
				insert q6;
			}
			
			QueueSobject q7 = new QueueSobject();
			q7.QueueId = g.Id;
			q7.SobjectType = 'On_Study_Pathology_Form__c';
			
			if(!test.isRunningTest()){
				insert q7;
			}
		}
	}
	
	@future (callout=true)
	public static void createGroupMembForUserAssociation(Set<Id> instUserIds) {
		
		set<Id> lstSiteId = new set<Id>();
		set<Id> lstTrialId = new set<Id>();
		set<Id> lstUserId = new set<Id>();
		set<Id> lstInstId = new set<Id>();
		List<InstitutionUser__c> lstInstUser = [select Id,Institution__c,Site__c,Trial__c,User__c,User__r.Profile.Name from InstitutionUser__c where Id IN :instUserIds];
	 	for(InstitutionUser__c instUser : lstInstUser){
	 		lstInstId.add(instUser.Institution__c);
			lstSiteId.add(instUser.Site__c);
			lstTrialId.add(instUser.Trial__c);
			lstUserId.add(instUser.User__c);
		}
		lstInstUser = [select Id,Institution__c,Site__c,Trial__c,User__c,User__r.Profile.Name from InstitutionUser__c where Institution__c IN :lstInstId and Site__c IN :lstSiteId and Trial__c IN :lstTrialId];
		List<Account> lstInst = [select Id,Name,Inst_Group__c from Account where Id IN :lstInstId];
		
		set<String> lstNames = new set<String>();
		for(Account acc : lstInst){
			lstNames.add(acc.Inst_Group__c);
		}
		//List<Group> lstGrp1 = [select Id,Name,Type from Group where Name IN : lstNames and Type = 'Regular'];
		map<Id, Group> mapGrp1 = new map<Id, Group>([select Id,Name,Type from Group where Name IN : lstNames and Type = 'Regular']);
	//delete all group members from institute group before creating	
		delete [select Id from GroupMember where GroupId IN :mapGrp1.keySet()];
	
		
		List<Site_Trial__c> lstSiteTrial = [select id,Site__c,Trial__c,Name from Site_Trial__c where Site__c IN : lstSiteId and Trial__c IN : lstTrialId];
		
		set<String> siteGrpName = new set<String>();
		for(Site_Trial__c st : lstSiteTrial){
			siteGrpName.add(st.Name);
		}
		
		//List<Group> lstGrp = [select id,Name from Group where Name IN : siteGrpName and Type = 'Regular'];
		map<Id, Group> mapGrp = new map<Id, Group>([select id,Name from Group where Name IN : siteGrpName and Type = 'Regular']);
	//delete all group members from site user group before creating	
		delete [select Id from GroupMember where GroupId IN :mapGrp.keySet()];
	
	//building set for lab users	
		List<InstitutionUser__c> lstInstLabUser = [select Id, Institution__c, Institution__r.Inst_Group__c, Site__c, Trial__c, User__c from InstitutionUser__c where Institution__c IN :lstInstId and User__r.Profile.Name NOT IN ('System Administrator', 'Developers', 'Custom Read Only User')];
		set<Id> setLabUserIds = new set<Id>();
		for(InstitutionUser__c iu : lstInstLabUser) {
			setLabUserIds.add(iu.User__c);
		}
		
		List<User> lstAdminUser = [Select Id, u.Profile.Name From User u where Profile.Name IN ('System Administrator', 'Developers', 'Custom Read Only User') and IsActive = true];
		List<User> lstLabSiteUser = [Select Id, u.Profile.Name From User u where Id IN :setLabUserIds and IsActive = true];
		System.debug('lstLabSiteUser : '+lstLabSiteUser);	
	
	//create group member for admin user and lab users	
		List<GroupMember> lstGroupMember = new List<GroupMember>();
		for(Group grp : mapGrp1.values()){
			for(User u : lstAdminUser){
				GroupMember gm1 = new GroupMember();
				gm1.UserOrGroupId = u.Id;
				gm1.GroupId = grp.Id;
				lstGroupMember.add(gm1);
			}
			
			for(InstitutionUser__c iu : lstInstLabUser) {
				for(User u : lstLabSiteUser){
					if(u.Id == iu.User__c && iu.Institution__r.Inst_Group__c == grp.Name) {
						GroupMember gm2 = new GroupMember();
						gm2.UserOrGroupId = u.Id;
						gm2.GroupId = grp.Id;
						lstGroupMember.add(gm2);
					}
				}
			}
		}
	
	//Now create Group members for site user
		for(InstitutionUser__c instUser : lstInstUser){
			for(Site_Trial__c st : lstSiteTrial){
				for(Group grp : mapGrp.values()){
					if(instUser.Site__c == st.Site__c && instUser.Trial__c == st.Trial__c && grp.Name == st.Name && (instUser.User__r.Profile.Name == 'Site User' || instUser.User__r.Profile.Name == 'Lab User')){
						system.debug('instUser.User__r.Profile.Name: '+instUser.User__r.Profile.Name);
						GroupMember gm1 = new GroupMember();
						gm1.UserOrGroupId = instUser.User__c;
						gm1.GroupId = grp.Id;
						lstGroupMember.add(gm1);
						//QueueCreation.createGroupMemb(grp.Id, instUser.User__c); 
					}
				}
			}
			/*for(Account acc : lstInst){
				if(acc.Id == instUser.Institution__c){
					for(Group grp : mapGrp1.values()){
						if(grp.Name == acc.Inst_Group__c){
							GroupMember gm2 = new GroupMember();
							gm2.UserOrGroupId = instUser.User__c;
							gm2.GroupId = grp.Id;
							lstGroupMember.add(gm2);
						}
					}
				}
			}*/
		}
		if(!Test.isRunningTest()){
			insert lstGroupMember;
		}
		
		set<Id> userId = new set<Id>();
		List<User> lstSiteUserProf = new List<User>();
		for(InstitutionUser__c insUser : lstInstUser){
			userId.add(insUser.User__c);
		}
		List<Profile> lstProNew = [select id,Name from Profile where Name = 'New User'];
		List<Profile> lstProSite = [select id,Name from Profile where Name = 'Site User'];
		List<User> lstUser = [select Id,ProfileId from User where ProfileId = :lstProNew[0].Id];
		List<User> lstUserUpdate = new List<User>();  
		for(User user : lstUser){
			
			system.debug('----------------test---------');
			user.ProfileId = lstProSite[0].Id;
			
			system.debug('---------------lstProSite[0].Id-------'+lstProSite[0].Id);
			
			lstUserUpdate.add(user);
			system.debug('--------------lstUserUpdate-------'+lstUserUpdate);
		}
		if(!lstUserUpdate.isEmpty()){
			update lstUserUpdate;
			system.debug('--------------lstUserUpdate-------'+lstUserUpdate);
		}
	}
	
	/*@future (callout=true)
	public static void shareAccount(Set<Id> instUserIds) {
		set<Id> lstInstId = new set<Id>();
		List<InstitutionUser__c> lstInstUser = [select Id,Institution__c,Site__c,Trial__c,User__c from InstitutionUser__c where Id IN :instUserIds];
	 	for(InstitutionUser__c instUser : lstInstUser){
	 		lstInstId.add(instUser.Institution__c);
		}
	//delete previous sharing	
		//delete [select Id from AccountShare where AccountId IN :lstInstId and AccountAccessLevel != 'All'];
		
		List<Account> lstInst = [select Id,Name,Inst_Group__c from Account where Id IN :lstInstId];
		
		set<String> lstNames = new set<String>();
		for(Account acc : lstInst){
			lstNames.add(acc.Inst_Group__c);
		}
		List<Group> lstGrp1 = [select Id,Name,Type from Group where Name IN : lstNames and Type = 'Regular'];
		
		List<AccountShare> lstAccountShare = new List<AccountShare>();
		for(InstitutionUser__c instUser : lstInstUser){
			for(Account acc : lstInst){
				if(acc.Id == instUser.Institution__c){
					for(Group grp : lstGrp1){
						if(grp.Name == acc.Inst_Group__c){
						//Share account(Institute) records with site user's group	
							AccountShare accShare = new AccountShare();
							accShare.AccountAccessLevel = 'Read';
							accShare.AccountId = instUser.Institution__c;
							accShare.UserOrGroupId = grp.Id;
							accShare.OpportunityAccessLevel = 'Read';
							lstAccountShare.add(accShare);
						}
					}
				}
			}
		}
		
		if(!lstAccountShare.isEmpty()) {
			insert lstAccountShare;
		}
		
	}*/
	
	@future (callout=true)
	public static void createGroupMemb(Id grpId, Id user) {
		
		GroupMember gm = new GroupMember();
		gm.UserOrGroupId = user;
		gm.GroupId = grpId;
		insert gm;
	}
	
	@future (callout=true)
	public static void updateUserProf(Id ProfId, Id userId) {
		List<User> lstUserUpdate = new List<User>();  
		List<User> lstUser = [select Id,ProfileId from User where Id = :userId];
		for(User user : lstUser){
			user.ProfileId = ProfId;
			lstUserUpdate.add(user);
		}
		if(!lstUserUpdate.isEmpty()){
			update lstUserUpdate;
		}
	}
}