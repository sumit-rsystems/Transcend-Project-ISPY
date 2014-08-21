public with sharing class TrialPatientFormController {
	string trialPatientFrmId;
	public TrialPatientFormController(Apexpages.standardcontroller std){
		System.debug('TrialPatientForm-------'+std.getId());
        trialPatientFrmId = std.getId();
	}
	
	public Pagereference showPatientView(){
		List<TrialPatient__c> trialPatientList = [Select t.Patient_Id__c From TrialPatient__c t where id = :trialPatientFrmId];
		if(!trialPatientList.isEmpty()){
			pagereference pg = new pagereference('/'+trialPatientList[0].Patient_Id__c);
        	pg.setRedirect(true);
        	return pg;
		}
		return null;
	}
}