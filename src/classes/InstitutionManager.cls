public with sharing class InstitutionManager {
	public static void setupUserAsAdmin(Map<Id, Id> instituteUserMap) {
		
	//get users for share with institute
		List<User> lstUser = [select UserRoleId from User where Id IN:instituteUserMap.KeySet()];
		Set<Id> instIds = new Set<Id>(instituteUserMap.Values());
		
	//build a map for excluding existing records
		system.debug('__instituteUserMap.KeySet()__'+instituteUserMap.KeySet());
		system.debug('__instIds__'+instIds);
		List<InstitutionUser__c> lstInstUser = [select Site__c, Trial__c, User__c from InstitutionUser__c where Institution__c IN :instIds and User__c IN :instituteUserMap.KeySet()];
		Map<Id, Map<Id, Set<Id>>> userSiteTrialMap = new Map<Id, Map<Id, Set<Id>>>();
		Set<Id> siteIds = new Set<Id>();
		for(InstitutionUser__c iu : lstInstUser) {
			if(!userSiteTrialMap.containsKey(iu.User__c)) {
				userSiteTrialMap.put(iu.User__c, new Map<Id, Set<Id>>());
			}
			system.debug('__userSiteTrialMap.get(iu.User__c)__'+userSiteTrialMap.get(iu.User__c));
			system.debug('__userSiteTrialMap.get(iu.User__c).containsKey(iu.Site__c)__'+userSiteTrialMap.get(iu.User__c).containsKey(iu.Site__c));
			if(userSiteTrialMap.get(iu.User__c).containsKey(iu.Site__c)) {
				userSiteTrialMap.get(iu.User__c).get(iu.Site__c).add(iu.Trial__c);
			} else {
				userSiteTrialMap.get(iu.User__c).put(iu.Site__c, new Set<Id>{iu.Trial__c});
				siteIds.add(iu.Site__c);
			}
		}
		system.debug('__userSiteTrialMap__'+userSiteTrialMap);
	//get all site-trial combination for a particular institute	
		List<Site_Trial__c> lstSiteTrial = [Select s.Trial__c, s.Site__r.Institute__c, s.Site__c From Site_Trial__c s where Site__r.Institute__c IN :instIds and Site__c IN :siteIds];
		system.debug('__lstUser__'+lstUser);
		
	//Share institute record with user
		List<InstitutionTrialDcc__c> lstInstTrialDcc = [select DCC_Id__c, Institution_Id__c from InstitutionTrialDcc__c where Institution_Id__c IN:instIds];
		List<AccountShare> lstInsertAccShare = new List<AccountShare>();
		for(User u: lstUser) {
			//u.UserRoleId = lstURole[0].Id;
			AccountShare accShare = new AccountShare();
			accShare.UserOrGroupId = u.Id;
			accShare.OpportunityAccessLevel = 'Edit';
			accShare.CaseAccessLevel = 'Edit';
			accShare.AccountAccessLevel = 'Edit';
			accShare.AccountId = instituteUserMap.get(u.Id);
			lstInsertAccShare.add(accShare);
			for(InstitutionTrialDcc__c InstTrialDcc : lstInstTrialDcc) {
				if(instituteUserMap.get(u.Id) == InstTrialDcc.Institution_Id__c) {
					AccountShare accShare1 = new AccountShare();
					accShare1.UserOrGroupId = u.Id;
					accShare1.OpportunityAccessLevel = 'Edit';
					accShare1.CaseAccessLevel = 'Edit';
					accShare1.AccountAccessLevel = 'Edit';
					accShare1.AccountId = InstTrialDcc.DCC_Id__c;
					lstInsertAccShare.add(accShare1);
				}
			}
		}
		
		/*if(!lstUser.isEmpty()) {
			update lstUser;
		}*/
		if(!lstInsertAccShare.isEmpty()) {
			insert lstInsertAccShare;
		}
	//insert all site-trial combination for a particular institute with Institute Admin user
		List<InstitutionUser__c> lstInsertInstUser = new List<InstitutionUser__c>();
		for(Id uid : instituteUserMap.KeySet()) {
			for(Site_Trial__c st : lstSiteTrial) {
				system.debug('__instituteUserMap.get(uid)__'+instituteUserMap.get(uid));
				system.debug('__st.Site__r.Institute__c__'+st.Site__r.Institute__c);
				system.debug('__userSiteTrialMap.get(uid)__'+userSiteTrialMap.get(uid));
				system.debug('__userSiteTrialMap.get(uid).get(st.Site__c)__'+userSiteTrialMap.get(uid).get(st.Site__c));
				if(instituteUserMap.get(uid) == st.Site__r.Institute__c && !userSiteTrialMap.get(uid).get(st.Site__c).contains(st.Trial__c)) {
					InstitutionUser__c istuser = new InstitutionUser__c();
					istuser.Institution__c = st.Site__r.Institute__c;
					istuser.Site__c = st.Site__c;
					istuser.Trial__c = st.Trial__c;
					istuser.User__c = uid;
					istuser.IsInstituteAdmin__c = true;
					lstInsertInstUser.add(istuser);
				}
			}
		}
		
		if(!lstInsertInstUser.isEmpty()) {
			insert lstInsertInstUser;
		}
		updateUser(instituteUserMap.KeySet());
	}
	
//update user's role and profile to "Institute Admin"
	@future (callout = true)
	public static void updateUser(Set<Id> userIds) {
		List<UserRole> lstURole = [select Id from UserRole where Name = 'Institution Admin'];
		List<Profile> lstProfile = [select Id from Profile where Name = 'Institute Level Admin'];
		system.debug('__lstURole__'+lstURole);
		system.debug('__lstProfile__'+lstProfile);
	//get users for change role to institute admin
		List<User> lstUser = [select UserRoleId from User where Id IN:userIds];
		if(!lstURole.isEmpty() && !lstProfile.isEmpty()) {
			for(User u: lstUser) {
				u.UserRoleId = lstURole[0].Id;
				u.ProfileId = lstProfile[0].Id;
			}
			
			if(!lstUser.isEmpty() && !Test.isRunningTest()) {
				update lstUser;
			}
		}
	}

//create InstituteUser records for admin profile(i.e. Custom Read Only User, System Administrator, Developers)	
	/*@future (callout = true)
	public static void setupInstituteUserForAdmin(Set<Id> userIds, String event, Map<Id, Id> userProfileOldMap) {
		List<Profile> lstAdminProfile = [select Id from Profile where Name = 'Custom Read Only User' or Name = 'System Administrator' or Name = 'Developers'];
		List<Site_Trial__c> lstSiteTrial = [Select s.Trial__r.Name, s.Trial__c, s.Site__r.Institute__c, s.Site__r.Name, s.Site__c From Site_Trial__c s];
		List<User> lstUser = [select User.ProfileId, Id from User where Id IN:userIds];
 		List<InstitutionUser__c> lstinstuser = new List<InstitutionUser__c>();	//Create Empty List to hold new institution user
		
		if(event == 'Insert') {
        	system.debug('__lstAdminProfile__'+lstAdminProfile);
        	for(User user : lstUser) {
	        //create InstitutionUser record according to site-trial combination for user 
		        for(Profile pro : lstAdminProfile) {
		        	if(user.ProfileId == pro.Id) {
		        		system.debug('__pro.Id__'+pro.Id);
		        		system.debug('__user.ProfileId__'+user.ProfileId);
		        		system.debug('__lstSiteTrial__'+lstSiteTrial);
		        		for(Site_Trial__c st :lstSiteTrial ){
							InstitutionUser__c istuser = new InstitutionUser__c();
							istuser.Institution__c = st.Site__r.Institute__c;
							istuser.Site__c = st.Site__c;
							istuser.Trial__c = st.Trial__c;
							istuser.User__c = user.Id;
							lstinstuser.add(istuser); 
						}
		        	}
		        }
        	}
	        system.debug('__lstinstuser__'+lstinstuser);
        } else if(event == 'Update') {
        	for(User user : lstUser) {
          //create InstitutionUser record according to site-trial combination for user
	        	for(Profile pro : lstAdminProfile) {
	        		if(userProfileOldMap.get(user.Id) != pro.Id && user.ProfileId == pro.Id) {
	        			system.debug('__Updatepro.Id__'+pro.Id);
		        		system.debug('__Updateuser.ProfileId__'+user.ProfileId);
		        		system.debug('__Trigger.oldMap.get(user.Id).ProfileId__'+userProfileOldMap.get(user.Id));
	        			for(Site_Trial__c st :lstSiteTrial ){
							InstitutionUser__c istuser = new InstitutionUser__c();
							istuser.Institution__c = st.Site__r.Institute__c;
							istuser.Site__c = st.Site__c;
							istuser.Trial__c = st.Trial__c;
							istuser.User__c = user.Id;
							lstinstuser.add(istuser); 
						}
	        		}
	        	}
        	}
        	system.debug('__lstinstuser__'+lstinstuser);
        }
        if(!lstinstuser.isEmpty()) {
			insert lstinstuser;
		}
	}*/
}