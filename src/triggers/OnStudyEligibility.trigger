trigger OnStudyEligibility on On_Study_Eligibility_Form__c (before insert,before update) {
  if(Trigger.isUpdate) {

        List<On_Study_Eligibility_Form__c> lstRandToShare = new List<On_Study_Eligibility_Form__c>();
        set<Id> setCrfIds = new set <Id>();
        for(On_Study_Eligibility_Form__c random : Trigger.new) {
			
           if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c) {
            lstRandToShare.add(random);
           }
           if(random.First_Save_and_Close__c && random.Status__c == 'Not Completed') {
	       		setCrfIds.add(random.Id);
           }
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'On_Study_Eligibility_Form__c', 'Site');
       System.debug('setCrfIds-------'+setCrfIds);
       if(!setCrfIds.isEmpty()) {
       		SharingManager.shareAdditionalQuestionWithSite(setCrfIds, 'On_Study_Eligibility_Form__Share');
       }
       }
}