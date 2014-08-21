public with sharing class PreEligibilityInfo {

	public PreEligibilityInfo(Apexpages.standardcontroller Pre){
		
	}
	public Pagereference Next(){
		Id patientId = Apexpages.currentPage().getParameters().get('CF00Nc0000000Glkx_lkid');
		List<Patient_Custom__c> lstPat = [select id,Age__c,Signed_Screening__c,Name from Patient_Custom__c where id = :patientId];
		if(lstPat[0].Signed_Screening__c){
			System.debug('/a0a/e?CF00Nc0000000Glkx='+lstPat[0].Name+'&CF00Nc0000000Glkx_lkid='+lstPat[0].Id+'&retURL=%2F'+lstPat[0].Id+'&00Nc0000000Gljf='+lstPat[0].Signed_Screening__c);
			Pagereference pr = new Pagereference('/a0a/e?CF00Nc0000000Glkx='+lstPat[0].Name+'&CF00Nc0000000Glkx_lkid='+lstPat[0].Id+'&retURL=%2F'+lstPat[0].Id+'&00Nc0000000Gljf=1');
			pr.getParameters().put('nooverride', '1');
			return pr;
		} else {
			Pagereference pr = new Pagereference('/a0a/e?CF00Nc0000000Glkx='+lstPat[0].Name+'&CF00Nc0000000Glkx_lkid='+lstPat[0].Id+'&retURL=%2F'+lstPat[0].Id+'&00Nc0000000Gljf=0');
			pr.getParameters().put('nooverride', '1');
			return pr;
		}
	}
}