trigger ContentDocBeforeDelete on ContentDocument (before delete) {
	List<User> lstUser = [select Id, ProfileId, Profile.Name from User where Id=:Userinfo.getUserId()];
	if(!lstUser.isEmpty()) {
		User u = lstUser[0];
		if(u.Profile.Name == 'DCC User') {
			for(ContentDocument fi : Trigger.old) {
				if(!Test.isRunningTest()) {
					fi.addError('As a DCC User, You can\'t delete this item.');
					//throw new RequiredFieldException('As a DCC User, You can\'t delete this item.');
					return;
				}
			}
		}
	}
}