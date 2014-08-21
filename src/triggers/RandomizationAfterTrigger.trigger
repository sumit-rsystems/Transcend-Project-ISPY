trigger RandomizationAfterTrigger on Randomization_Form__c (after insert, after update) {
    if(Trigger.isInsert) {
    	SharingManager.shareObjectWithSite(Trigger.new, 'Randomization_Form__c', 'Site');	
    }
    if(Trigger.isUpdate){
        //Comment to update sharing
        
        set<Id> crfIds = new set<Id>();
        set<Id> ranIds = new set<Id>();
        Set<String> trialPatients = new Set<String>();
        for(Randomization_Form__c ran : Trigger.new){
            trialPatients.add(ran.TrialPatient__c);
            if(ran.Status__c != 'Approval Not Required') continue;
            crfIds.add(ran.CRF__c);
            ranIds.add(ran.Id);
        }
        List<Snomed_Code__c> lstSnomed = [select id,CRF__c,Name from Snomed_Code__c where CRF__c IN : crfIds]; 
        if(!lstSnomed.isEmpty()) {
            delete lstSnomed;
        }
        if(!ranIds.isEmpty()) {
            SnomedCTCode.insertRandomizationCode(ranIds);
        }
        if(!Test.isRunningTest()) {
        	Set<String> approvedRFs = new Set<String>();
        	for(Randomization_Form__c rf : Trigger.new) {
        		if(rf.Status__c == 'Approval Not Required' && Trigger.oldMap.get(rf.Id).Status__c != 'Approval Not Required') {
        			approvedRFs.add(rf.TrialPatient__c);
        		}
        	}
        	if(!approvedRFs.isEmpty()) {
            	RandomizationXMLBuilder.updatePatientXML(approvedRFs);
        	}
        }
    }
    
    //code to set correct phase on patient record
    
    List<Randomization_Form__c> randomizationList = Trigger.new;
	System.debug('randomizationList------'+randomizationList);
	Set<id> trialPatientIdSet = new Set<id>();
	List<Phase_Master__c> phMasterList = [Select p.Name From Phase_Master__c p where Name = 'Treatment'];
	System.debug('phMasterList----------'+phMasterList);
	if(phMasterList.isEmpty())return;
	
	for(Randomization_Form__c rndm : randomizationList){
		if(rndm.TrialPatient__c != null && rndm.Status__c == 'Approval Not Required')trialPatientIdSet.add(rndm.TrialPatient__c);
	}
	List<TrialPatient__c> trialPatientList; 
	if(!trialPatientIdSet.isEmpty()){
		trialPatientList = [Select t.Phase_Master__c, t.Patient_Id__c, t.Name From TrialPatient__c t where id IN :trialPatientIdSet];
		if(!trialPatientList.isEmpty()){
			for(TrialPatient__c tp : trialPatientList){
				tp.Phase_Master__c = phMasterList[0].id;
			}
			System.debug('trialPatientList----------'+trialPatientList.size());
			update trialPatientList;
		}
	}
}