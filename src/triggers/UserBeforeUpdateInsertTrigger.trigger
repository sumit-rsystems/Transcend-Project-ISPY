trigger UserBeforeUpdateInsertTrigger on User (before insert, before update) {
	List<User> lstUser = Trigger.new;
	List<Profile> lstProfile = [select Id from Profile where Name IN ('Site User', 'Developers', 'Lab Supervisor', 'DCC User', 'Lab Technician', 'Lab User', 'Institute Level Admin', 'System Administrator')];
	for(User user : lstUser) {
		for(Profile Prof: lstProfile) {
			if(user.ProfileId != Prof.Id) continue;
			if(user.SecurityCode__c != null && user.SecurityCode__c != '') continue;
			String password = PasswordManager.generatePassword();
			user.SecurityCode__c = password;
		}
	}
}