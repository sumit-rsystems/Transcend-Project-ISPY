trigger AddInstituteValueInPatientBeforeInsert on Patient_Custom__c (before insert) {

	/*String userId = System.Userinfo.getUserId();
	List<InstitutionUser__c> instUser = [select Institution__c from InstitutionUser__c where User__c =:userId];
	List<Account> institute = new List<Account>();
	system.debug('__instUser__'+instUser);
	if(!instUser.isEmpty()){
		institute = [select Name from Account where Id =:instUser[0].Institution__c];
	} 
	*/
	
	/*List<Patient_Custom__c> patientList = [Select p.Screen_Failure_Number__c From Patient_Custom__c p where First_Name__c='Screen' and Last_Name__c like '%Failure%' and Screen_Failure_Number__c != null order by Screen_Failure_Number__c desc limit 1];
	Integer counter = 1;
	if(!patientList.isEmpty()) {
		
		counter = Integer.valueOf((patientList[0].Screen_Failure_Number__c)+1);
	}*/
	
	Set<Id> instituteIdSet = new Set<Id>(); 
	for(Patient_Custom__c pc : Trigger.new) {
		instituteIdSet.add(pc.Institution__c);
	}
	
	List<Account> institute = [select Name, Id from Account where Id IN :instituteIdSet];
	
	for(Patient_Custom__c pc : Trigger.new) {
	//add patient first and last name in Name field	
		/*if(pc.First_Name__c != null) {
			pc.Name = pc.First_Name__c+' '+pc.Last_Name__c;
		} else {
			pc.Name = pc.Last_Name__c;
		}*/
	//add patient Name as "patient with no subject Id" but after registration we'll replace this name with subject Id
		pc.Name = 'Patient with no Subject Id';
		for(Account instituteObj : institute) {
			if(instituteObj.Id == pc.Institution__c) {
				pc.Institute_Text__c = instituteObj.Name;
			}
		}
	}
}