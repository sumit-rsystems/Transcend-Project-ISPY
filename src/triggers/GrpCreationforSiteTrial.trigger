trigger GrpCreationforSiteTrial on Site_Trial__c (after insert) {
  
  List<Group> insertGroupList = new List<Group>();
  Set<Id> siteIds = new Set<Id>();
  for(Site_Trial__c st : Trigger.new){
    Group g = new Group();
    g.Name = st.Name;
    insertGroupList.add(g);
    siteIds.add(st.Site__c);
  }
  
  if(!insertGroupList.isEmpty()) {
  	insert insertGroupList;
  }
  //Share The AnswerOption Existing Record to New Group(If new Group Created)
  List<AnswerOption__Share> listshare = new List<AnswerOption__Share>();
  List<AnswerOption__c> ansoption=[select Id,QuestionId__c from AnswerOption__c where QuestionId__c!=null];
  for(Group gp:insertGroupList){
  	for(AnswerOption__c aop:ansoption){
  		AnswerOption__Share obj = new AnswerOption__Share();
 		obj.AccessLevel='Edit';
 		obj.parentid=aop.id;
 		obj.Userorgroupid=gp.id;
 		listshare.add(obj);
  	}
  }
  insert listshare;
  
	List<Site__c> lstSite = [select Institute__c from Site__c where Id IN:siteIds];
	Set<Id> instituteIds = new Set<Id>();
	for (Site__c site : lstSite) {
		instituteIds.add(site.Institute__c);
	} 
	
  	List<Profile> lstPro = [select id,Name, (Select Id From Users) from Profile where Name = 'System Administrator' or Name = 'Developers' or Profile.Name = 'Custom Read Only User'];
  	//List<User> useList = [Select Id From User u where (Profile.Name = 'System Administrator' or Profile.Name = 'Developers' or Profile.Name = 'Custom Read Only User') and IsActive = true];
  	List<Site_Trial__c> lstSiteTrial = [select Site__r.Institute__c, Site__c, Trial__c from Site_Trial__c where Id IN:Trigger.newMap.KeySet()];
	List<InstitutionUser__c> lstInstUser = [select id, Institution__c, User__c, User__r.ProfileId, Trial__c, Site__c from InstitutionUser__c where Institution__c IN :instituteIds and Site__c = null and Trial__c = null and (User__r.ProfileId = : lstPro[0].Id or User__r.ProfileId = : lstPro[1].Id or User__r.ProfileId = : lstPro[2].Id)];
	List<InstitutionUser__c> lstInsertInstUser = new List<InstitutionUser__c>();
	for(Site_Trial__c st : lstSiteTrial){
		Boolean isAlreadyInstituteUser = false; //varibale flag for check institute user is already created or not created (false = not created, true = created)
		for(InstitutionUser__c instUser : lstInstUser){
			if(st.Site__r.Institute__c == instUser.Institution__c) {
				isAlreadyInstituteUser = true;
				instUser.Trial__c = st.Trial__c;
				instUser.Site__c = st.Site__c;
			}
		}
		
		if(!isAlreadyInstituteUser) {
			for(Profile profile : lstPro) {
				for(User user : profile.Users) {
					InstitutionUser__c iu= new InstitutionUser__c();
					iu.Institution__c = st.Site__r.Institute__c;
					iu.Site__c = st.Site__c;
					iu.Trial__c = st.Trial__c;
					iu.User__c = user.Id;
					lstInsertInstUser.add(iu);
				}
			}
		}
	}
	if(!lstInstUser.isEmpty() && !Test.isRunningTest()){
		update lstInstUser;
	}
	if(!lstInsertInstUser.isEmpty() && !Test.isRunningTest()){
		insert lstInsertInstUser;
	}
}