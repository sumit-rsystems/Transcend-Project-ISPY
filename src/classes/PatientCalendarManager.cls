public with sharing class PatientCalendarManager {
	
	@future (callout = true)
	public static void userUpdCalenderProfile(Set<Id> instUserCalendr) {
		
		Set<id> userId = new Set<id>();
		List<Profile> proflilist = [Select p.Name, p.Id From Profile p];
		List<UserRole> userroleList = [Select u.Name, u.Id From UserRole u];
		
		List<InstitutionUser__c> lstInstUser = [Select i.isInstituteCalender__c, i.User__r.ProfileId, i.User__r.UserRoleId, i.User__r.Id, i.User__c From InstitutionUser__c i where Id IN :instUserCalendr];
		for(InstitutionUser__c userList : lstInstUser){
			userId.add(userList.User__c);
			system.debug('----------userId--'+userId);
		}
		List<user> userListReco = [Select u.ProfileId,u.Profile.Name,u.UserRoleId,u.UserRole.Name From User u where Id IN :userId];
		List<User> updateUserList = new List<User>();
		for(InstitutionUser__c inst : lstInstUser){
			for(User us : userListReco){
				if(inst.User__c == us.id){
					system.debug('--------us.id--'+us.id);
					system.debug('---------us.Profile.Name--'+us.Profile.Name);
					if(us.Profile.Name == 'Institute Level Admin'){
						system.debug('---------us.Profile.Name--'+us.Profile.Name);
						for(Profile prof : proflilist){
							if(prof.Name == 'Institution Admin With Patient Calendar'){
								system.debug('---------prof.id-'+prof.id);
								us.ProfileId = prof.id;
								system.debug('---------us.ProfileId--'+us.ProfileId);
								for(UserRole usrole : userroleList){
									if(usrole.Name == 'Institution Admin With Patient Calendar'){
										system.debug('---------usrole.Name--------------'+usrole.Name);
										system.debug('--------usrole.Id-------------'+usrole.Id);
										us.UserRoleId = usrole.Id; 	
									}
								}
								break;
							}
						}
					}else if(us.Profile.Name == 'Site User'|| us.Profile.Name == 'New User'){
						for(Profile prof : proflilist){
							if(prof.Name == 'Site User With Patient Calendar'){
								system.debug('---------prof.Name-'+prof.Name);
								us.ProfileId = prof.id;
								for(UserRole usrole : userroleList){
									
									if(usrole.Name == 'Site User With Patient Calendar'){
										system.debug('---------usrole.Name--------------'+usrole.Name);
										system.debug('--------usrole.Id-------------'+usrole.Id);
										us.UserRoleId = usrole.Id; 	
									}
								}
								break;
							}
						}
					}
				} 
				system.debug('--------updateUserList-'+updateUserList);
				updateUserList.add(us);
			}
			
		}
		update updateUserList;
		system.debug('-------updateUserList-'+updateUserList); 
	}
}