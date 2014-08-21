public with sharing class MenopausalNew {
	
	public MenopausalNew(Apexpages.standardcontroller msd){
		
	}
	public Pagereference CustomeNew(){
		Id trialPatientId = Apexpages.currentPage().getParameters().get('CF00Nc0000000GqXy_lkid');
		if(trialPatientId != null){
			List<TrialPatient__c> lstTripat = [select id,Name,Patient_Id__c,Trial_Id__c from TrialPatient__c where id = : trialPatientId];
			List<Patient_Custom__c> lstPat = [select id,Age__c,Name from Patient_Custom__c where id = :lstTripat[0].Patient_Id__c];
			if(lstPat[0].Age__c < 50){
				System.debug('----lstPat[0].Age__c---->'+lstPat[0].Age__c);
				Pagereference pr = new Pagereference('/a0k/e?CF00Nc0000000GqXy='+lstTripat[0].Name+'&CF00Nc0000000GqXy_lkid='+lstTripat[0].Id+'&retURL=%2F'+lstTripat[0].Id+'&00Nc0000000GrUb='+lstPat[0].Age__c+'&00Nc0000000GxnK=Age < 50');
				pr.getParameters().put('nooverride', '1');
				return pr;
			} else {
				System.debug('----lstPat[0].Age__c---->'+lstPat[0].Age__c);
				Pagereference pr = new Pagereference('/a0k/e?CF00Nc0000000GqXy='+lstTripat[0].Name+'&CF00Nc0000000GqXy_lkid='+lstTripat[0].Id+'&retURL=%2F'+lstTripat[0].Id+'&00Nc0000000GrUb='+lstPat[0].Age__c+'&00Nc0000000GxnK=Age > 50');
				pr.getParameters().put('nooverride', '1');
				return pr;
			}
		} else {
			Pagereference pr = new Pagereference('/a0k/e?retURL=%2Fa0k%2Fo');
			pr.getParameters().put('nooverride', '1');
			return pr;
		}
	}
}