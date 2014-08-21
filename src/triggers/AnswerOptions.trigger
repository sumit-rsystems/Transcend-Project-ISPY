trigger AnswerOptions on AnswerOption__c (after insert) {
	List<AnswerOption__c> anslist=new List<AnswerOption__c>();
	for(AnswerOption__c aop : Trigger.new){
		if(aop.QuestionId__c!=null) {
			anslist.add(aop);
		}
	}
	
	if(!anslist.isEmpty()){
		SharingManager.shareAnswerOptionsWithSite(anslist);
	}
}