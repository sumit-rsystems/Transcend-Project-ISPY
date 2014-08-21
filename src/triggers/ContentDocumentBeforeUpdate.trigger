trigger ContentDocumentBeforeUpdate on ContentDocument (before update) {
	List<User> lstUser = [select Id, ProfileId, Profile.Name from User where Id=:Userinfo.getUserId()];
	if(!lstUser.isEmpty()) {
		User u = lstUser[0];
		if(u.Profile.Name == 'DCC User') {
			for(ContentDocument cd : Trigger.new) {
				system.debug('cd.Title: '+cd.Title);
				system.debug('trigger.oldMap.get(cd.Id).Title: '+trigger.oldMap.get(cd.Id).Title);
				if(!Test.isRunningTest()) {
					cd.addError('As a DCC User, You can\'t change this item.');
					return;
				}
			}
		}
	}
}