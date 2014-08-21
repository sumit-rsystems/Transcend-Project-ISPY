public with sharing class PatientClass {
	
	public Patient_Custom__c patientObj {get;set;}
	public String rTypeId {get;set;}
	public RecordType rTypeObj {get;set;}
	private Pagereference pageRef {get;set;}
	
	public String retURL {get; set;}
	private String saveNewURL {get; set;}
	private String cancelURL {get; set;}
	private String ent {get; set;}
	private String confirmationToken {get; set;}
	private String accountID {get; set;}
	private String contactID {get; set;}
	public List<Patient_Custom__c> patientList {get;set;}
	public Boolean isNewPatient {get;set;}
	public Boolean isDuplicate {get;set;}
	public Boolean isShowDuplicateScreen {get;set;}
	public Boolean isShowLastScreen {get;set;}
	public Boolean isShowAddError {get;set;}
	public Boolean isShowMRNError {get;set;}
	public String InstIdVal {get; set;}
	
	public PatientClass(ApexPages.StandardController controller) {
		
		isShowDuplicateScreen = false;
		isDuplicate = false;
		isShowAddError = false;
		isShowMRNError = false;
		isNewPatient = false;
		
		String userId = System.Userinfo.getUserId();
		retURL = ApexPages.currentPage().getParameters().get('retURL');
		InstIdVal = ApexPages.currentPage().getParameters().get('instId');
		//User userObj = [select Contact.Site__c, Contact.AccountId, ContactId from User where Id =:userId];
		List<InstitutionUser__c> instUser = [select Institution__c from InstitutionUser__c where User__c =:userId];
		system.debug('__instUser__'+instUser);
		patientObj = new Patient_Custom__c();
		
		if (!instUser.isEmpty()) {
		
			patientObj.Institution__c = instUser[0].Institution__c;
		}
		
		//patientObj.Site__c = userObj.Contact.Site__c;
		
		//patientObj.Institution__c = '001c0000004LJFN';
		//patientObj.Site__c = 'a0bc0000000E9p9';
		
		system.debug('__patientObj__'+patientObj);
		
		//rTypeId = ApexPages.currentPage().getParameters().get('RecordType');
		//rTypeObj = [select Name from RecordType where Id =:rTypeId];
		
		
		//rType = ApexPages.currentPage().getParameters().get('RecordType');
		//cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
		//ent = ApexPages.currentPage().getParameters().get('ent');
		//confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
		//saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
		//accountID = ApexPages.currentPage().getParameters().get('def_account_id');
		//contactID = ApexPages.currentPage().getParameters().get('def_contact_id');
	}
	
	public void checkDuplicate () {
	
		//String fname = patientObj.First_Name__c;
		String lname = patientObj.Last_Name__c;
		//String pname = patientObj.Name;
		
		//List<Patient_Custom__c> patientTmpList;
		
		//System.debug('__fname__'+fname);
		
			System.debug('__lname__'+lname);
			//patientList = [select Id, Gender__c, Name, Birthdate__c, Last_Name__c, First_Name__c from Patient_Custom__c where First_Name__c =:fname and Last_Name__c =:lname];
			patientList = [select Id, Gender__c, Name, Birthdate__c, Last_Name__c, First_Name__c from Patient_Custom__c where Last_Name__c =:lname];
			if(patientList != null && patientList.Size()>0) {
			
				isShowDuplicateScreen = true;
				isDuplicate = true;
			}
			else {
			
				isShowDuplicateScreen = true;
				isDuplicate = false;
			}
		//}
		
	}
	
	public Pagereference addPatient () {
		
		//contactObj.AccountId = '001c00000042YFO'; 
		if (isNewPatient) {
			
			system.debug('__patientObj__'+patientObj);
			//system.debug('__contactObj__'+rTypeId);
			
			//contactObj.RecordTypeId = rTypeId;
			List<Account> institute = [select Name from Account where Id =:patientObj.Institution__c];
			if (!institute.isEmpty()) {
			
				patientObj.Institute_Text__c = institute[0].Name; 
			}
			
			//Site__c siteObj = [select Name from Site__c where Id =:patientObj.Site__c];
			//patientObj.Site_Text__c = siteObj.Name; 
			
			insert patientObj;
			
			System.debug('__patientObj.Id__'+patientObj.Id);
			
			//pageRef = new PageReference('/apex/PatientDetail?pid='+patientObj.Id);
			pageRef = new PageReference('/'+patientObj.Id);
        	pageRef.setRedirect(true);
        	return pageRef;
		}
		else
		{
			isShowAddError = true;
			return null;
		}
		
	}
	
	public Pagereference updatePatient() {
	
		String patientId = ApexPages.currentPage().getParameters().get('patientId');
		
		Patient_Custom__c conObj = [select Institution__c, Birthdate__c, Ethnicity__c, Race__c, Gender__c, First_Name__c, Last_Name__c, Address_Line_1__c, Address_Line_2__c, City__c, Country__c, State__c, Zip__c, Primary_MD__c, Surgeon__c, Medical_Record_Number__c, Study_Registration_Eligibility__c, SSN__c, Country_of_Birth__c From Patient_Custom__c where Id =:patientId];
		
		//Contact updateContactObj = new Contact();
		//updateContactObj.Id = contactId;
		//updateContactObj = contactObj;
		
		//System.debug('__contactObj.AccountId__'+contactObj.AccountId);
		if (patientObj.Institution__c!=null || patientObj.Institution__c!='') {
		
			conObj.Institution__c = patientObj.Institution__c; 
		}
		
		if (patientObj.Country_of_Birth__c!=null && patientObj.Country_of_Birth__c!='') {
		
			conObj.Country_of_Birth__c = patientObj.Country_of_Birth__c; 
		}
		
		if ((patientObj.Study_Registration_Eligibility__c==true && conObj.Study_Registration_Eligibility__c==false) || (patientObj.Study_Registration_Eligibility__c==false && conObj.Study_Registration_Eligibility__c==true)) {
		
			conObj.Study_Registration_Eligibility__c = patientObj.Study_Registration_Eligibility__c; 
		}
		
		if (patientObj.SSN__c!=null && patientObj.SSN__c!='') {
		
			conObj.SSN__c = patientObj.SSN__c; 
		}
		
		if (patientObj.Birthdate__c!=null) {
		
			conObj.Birthdate__c = patientObj.Birthdate__c; 
		}
		
		if (patientObj.Ethnicity__c!=null && patientObj.Ethnicity__c!='') {
		
			conObj.Ethnicity__c = patientObj.Ethnicity__c; 
		}
		
		if (patientObj.Race__c!=null && patientObj.Race__c!='[]' && patientObj.Race__c!='') {
		
			conObj.Race__c = patientObj.Race__c; 
		}
		
		if (patientObj.First_Name__c!='' && patientObj.First_Name__c!=null) {
		
			conObj.First_Name__c = patientObj.First_Name__c; 
		}
		
		if (patientObj.Last_Name__c!='' && patientObj.Last_Name__c!=null) {
		
			conObj.Last_Name__c = patientObj.Last_Name__c; 
		}
		
		if (patientObj.Gender__c!='' && patientObj.Gender__c!=null) {
		
			conObj.Gender__c = patientObj.Gender__c; 
		}
		
		if (patientObj.City__c!='' && patientObj.City__c!=null) {
		
			conObj.City__c = patientObj.City__c; 
		}
		
		if (patientObj.Country__c!='' && patientObj.Country__c!=null) {
		
			conObj.Country__c = patientObj.Country__c; 
		}
		
		if (patientObj.Zip__c!=null) {
		
			conObj.Zip__c = patientObj.Zip__c; 
		}
		
		if (patientObj.State__c!='' && patientObj.State__c!=null) {
		
			conObj.State__c = patientObj.State__c; 
		}
		
		if (patientObj.Primary_MD__c!=null || patientObj.Primary_MD__c!='') {
		
			conObj.Primary_MD__c = patientObj.Primary_MD__c; 
		}
		
		
		if (patientObj.Surgeon__c!=null || patientObj.Surgeon__c!='') {
		
			conObj.Surgeon__c = patientObj.Surgeon__c; 
		}
		
		
		if (patientObj.Medical_Record_Number__c!='' && patientObj.Medical_Record_Number__c!=null) {
		
			conObj.Medical_Record_Number__c = patientObj.Medical_Record_Number__c; 
		}
		
		update conObj;
		
		pageRef = new PageReference('/'+patientId);
        pageRef.setRedirect(true);
        return pageRef;
	}
	
	public PageReference redirectEditPage () {
	
		String patientId = ApexPages.currentPage().getParameters().get('patientId');
		
		//pageRef = new PageReference('/'+patientId+'/e?retURL=%2Fapex%2FPatient%3FretURL%3D%252Fa0f%252Fo&saveURL=%2F'+patientId);
		pageRef = new Pagereference('/apex/PatientAdd?pid='+patientId);
        pageRef.setRedirect(true);
        return pageRef;
	}
	
	public PageReference redirectAddPage () {
	
		//String patientId = ApexPages.currentPage().getParameters().get('patientId');
		//List<RecordType> recordType = [select Id from RecordType where RecordType.Name='AdHoc' and SobjectType='Patient_Custom__c'];
		
		//pageRef = new PageReference('/a0f/e?retURL=%2Fa0f%2Fo&RecordType='+recordType[0].Id+'&ent=01IE0000000RFRC');
		//pageRef = new PageReference('/a0f/e');
		
		//pageRef.getParameters().put('retURL', retURL);
		//pageRef.getParameters().put('RecordType', recordType[0].Id);
		//pageRef.getParameters().put('ent', '01IE0000000RFRC');
		//pageRef.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
		//pageRef.getParameters().put('save_new_url', saveNewURL);
		//pageRef.getParameters().put('nooverride', '1');
		if(patientObj.Last_Name__c == null) 
		{
			patientObj.Last_Name__c = '';
		}
		if(InstIdVal!= null){
			pageRef = new PageReference('/apex/PatientAdd?instId='+InstIdVal+'&lastname='+patientObj.Last_Name__c);
		}
		else{
			pageRef = new PageReference('/apex/PatientAdd?lastname='+patientObj.Last_Name__c);
		}
        pageRef.setRedirect(true);
        return pageRef;
	}
}