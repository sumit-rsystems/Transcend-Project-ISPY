trigger SetRecordOwnerGroup on Patient_Custom__c (before insert) {
	System.debug('-----cross Ref---------->');
	Patient_Custom__c patient = Trigger.new[0];
	Id userId = patient.OwnerId;
	System.debug('userId:'+userId);
	List<GroupMember> gmList = [Select g.UserOrGroupId, g.GroupId From GroupMember g where g.UserOrGroupId = :userId];
	System.debug('gmList:'+gmList);
	//patient.Site__c = null;
	//patient.Site_Text__c = '';
	if(!gmList.isEmpty()) {
		System.debug('-----cross Ref---------->');
		GroupMember gm = gmList.get(0);
		System.debug('gm:'+gm);
		//patient.OwnerId = gm.GroupId;
	}
	System.debug('patient.OwnerId:'+patient.OwnerId);
}