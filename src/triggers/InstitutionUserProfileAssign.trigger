trigger InstitutionUserProfileAssign on InstitutionUser__c (after insert) {
	
	set<Id> instUserIds = new Set<Id>();
	set<id> instUserCalendr = new set<id>();
	//set<Id> instAdminUserIds = new Set<Id>();
	Map<Id, Id> instituteUserMap = new Map<Id, Id>();
	
 	for(InstitutionUser__c instUser : Trigger.new){
 		instUserIds.add(instUser.Id);
 		if(instUser.isInstituteCalender__c == true){
 			instUserCalendr.add(instUser.Id); 
 		}
 		if(instUser.IsInstituteAdmin__c) {
	 		instituteUserMap.put(instUser.User__c, instUser.Institution__c);
 		}
	}
	if(!instituteUserMap.isEmpty()) {
		InstitutionManager.setupUserAsAdmin(instituteUserMap);
	}
	
	if(!instUserIds.isEmpty()) {
		QueueCreation.createGroupMembForUserAssociation(instUserIds);
		//QueueCreation.shareAccount(instUserIds);
	}
	system.debug('----------instUserCalendr--'+instUserCalendr);
	if(!instUserCalendr.isEmpty()){
		PatientCalendarManager.userUpdCalenderProfile(instUserCalendr);
	} 
	
}