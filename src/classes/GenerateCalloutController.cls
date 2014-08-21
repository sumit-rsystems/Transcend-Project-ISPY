/* This class is used to send the webservice callout for the 
Registration
BloodSpecimenController
TissuespecimenFormcontroller
AdverseEventController
from the method submitRegistration.
The failure if occures is captured in the Failed_Registration__c 
object in method populateFailedRegistration 

Created by Sohit Bhardwaj
Date: 22nd May, 2013
*/


public with sharing Class GenerateCalloutController{
public String radioValue {get;set;}
public String patientId {get;set;}
public String trialId {get;set;}
public Registration__c registrationObj {get;set;}
public String selectedSite{get;set;}
public Boolean isComplete{get;set;}
	
	@future (callout=true)
    public static void submitRegistration(String sharedObjectName,Id registrationObjId,String patientId, String trialId){
        CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c =: sharedObjectName limit 1];                          
        //To fetch admin xml configuration
        List<XML_Configuration__c> xmlPatientList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'Patient_Custom__c'];
        List<XML_Configuration__c> xmlRegistrationList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c =: sharedObjectName];
        Set<String> patientSet = new Set<String>();
        for(XML_Configuration__c x: xmlPatientList){
            patientSet.add(x.Field_API_Name__c);
        }
        Set<String> registrationSet = new Set<String>();
        for(XML_Configuration__c x: xmlRegistrationList){
            registrationSet.add(x.Field_API_Name__c);
        } 
        
        //Webservice callout

        cdapackage.CDAGeneratorPort ihub = new cdapackage.CDAGeneratorPort();
        External_Connection_Settings__c iHubEndpoint = External_Connection_Settings__c.getInstance('iHub');
        if (iHubEndpoint !=null){
            ihub.endpoint_x=iHubEndpoint.URL__c;
            ihub.timeout_x=iHubEndpoint.Timeout__c.intValue();
        }
        if(Test.isRunningTest()){
            ihub.endpoint_x = 'http://ec2-23-20-103-202.compute-1.amazonaws.com:12020/services/CDAGenerator';
            ihub.timeout_x = 120000;
        }
        cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
        cdapackage.author author = new cdapackage.author();
        cdapackage.patient patient = new cdapackage.patient();
        //String xmlType = (radioValue==null? 'CDA' : radioValue);
        String xmlType = 'CDA';
        author.idExtension = UserInfo.getUserName();
        
        List<Registration__c> registrationObjList = [Select Effective_Time__c,Institution__r.Name, Site__r.Id,Site__r.Name, r.Trial__c, r.TrialPatient__c, r.SystemModstamp, r.Surgeon__c
        , r.Status__c, r.Site__c, r.Screening_Informed_Consent_Date__c, r.SSN__c, r.Registration_Date__c, r.RecordTypeId, r.Radiology_Coordinator__c, r.Radiology_Coordinator_Phone__c, r.Radiology_Coordinator_Fax__c
        , r.Radiology_Coordinator_Email__c, r.Race__c, r.Phase__c, r.Patient__c, r.Patient_Initials__c, r.Oncologist__c, r.Name, r.Middle_Name__c, r.Last_Name__c, r.LastModifiedDate, r.LastModifiedById, r.LastActivityDate, r.Lab__c
        , r.IsDeleted, r.Institution__c, r.Initials__c, r.Id, r.ISPY2_Subject_Id__c, r.IRB_Approval_Date__c, r.HIPPA_Consent_Date__c, r.Gender__c, r.First_Name__c, r.Ethnicity__c, r.CreatedDate, r.CreatedById, r.Country_of_birth__c
        , r.CompletedDate__c, r.Clinical_Coordinator__c, r.Clinical_Coordinator_Phone__c, r.Clinical_Coordinator_Fax__c, r.Clinical_Coordinator_Email__c, r.CRF__c,r.Trial__r.Name
         From Registration__c r where Id=:registrationObjId order by LastModifiedDate desc limit 1];
        system.debug('&&&'+ registrationObjList);
        Registration__c registrationObj;    
        if(!registrationObjList.isEmpty()) {
            registrationObj = registrationObjList.get(0);
        }
        
        //check if old registration exists for this patient in iHub
        List<Registration__c> oldRegistrationList =[Select id from Registration__c where Patient__c=:patientId /*and Trial__c=:trialId*/ and IsIntegrationSuccess__c = true];
        
        clinicalDoc.id=registrationObj.id;
        if(oldRegistrationList.isEmpty()){ 
            clinicalDoc.title = 'Create Participant Registration';
        }else{
            clinicalDoc.title = 'Update Participant Registration';
        }
        if(registrationObj.Effective_Time__c!=null){
            clinicalDoc.effectiveTime=String.valueOf(registrationObj.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
        }
        
         
        String siteCode = registrationObj.Site__r.Name;
        if(registrationObj.Site__r.Name!=null){
        	Integer index1 = registrationObj.Site__r.Name.indexOf('(');
        	Integer index2 = registrationObj.Site__r.Name.indexOf(')');
        	if(index1>-1 && index2>-1 && index2>index1 ){
        		siteCode = registrationObj.Site__r.Name.substring(index1+1,index2).trim();
        	}
        	
        }
        clinicalDoc.siteIdentifier= siteCode;
        
        //clinicalDoc.siteIdentifier= registrationObj.Site__r.Name;
        clinicalDoc.siteIdRoot='2.16.840.1.113883.3.26.1.7';      
        clinicalDoc.studyId=registrationObj.Trial__r.Name ;
        clinicalDoc.studyIdRoot='2.16.840.1.113883.3.26.1.7' ;
        
        String mrn;
        
        List<Patient_Custom__c> patientObjList = [Select  p.Name,p.Birthdate__c, p.Zip__c, p.SSN__c, p.Race__c, p.Middle_Name__c
        , p.Medical_Record_Number__c, p.Last_Name__c, p.Institution__c, p.Institute_Text__c, p.Initials__c, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.Country_of_Birth__c,(Select ISPY2_Subject_Id__c, trial__c From Registrations__r where trial__c =:trialId order by LastModifiedDate desc limit 1)  From Patient_Custom__c p where Id =:patientId limit 1];
        if(!patientObjList.isEmpty()) {
            Patient_Custom__c patientObj = patientObjList.get(0);
            patient.MRN = patientObj.Medical_Record_Number__c; 
            if(patientSet.contains('First_Name__c')) {
                patient.givenName=patientObj.First_Name__c;
            }
            if(patientSet.contains('Last_Name__c')) {
                patient.familyName=patientObj.Last_Name__c;
            }
            patient.gender=patientObj.Gender__c;
            if(patientObj.Gender__c=='Female'){
                patient.gendercode='F';
            }else if(patientObj.Gender__c=='Male'){
                patient.gendercode='M';
            }else{
                patient.gendercode='N/A';
            }
            if(patientObj.Birthdate__c!=null){
                patient.doB=String.valueOf(patientObj.Birthdate__c).replaceAll('-','').replaceAll(' ','');
            }
            patient.maritalStatus='UNKNOWN';
            patient.maritalStatuscode='N/A';
            if(patientSet.contains('Race__c')) {
                List<String> stringList = patientObj.Race__c.split('\\;');  
                if(stringList.size()>0 ){
                     patientObj.Race__c = stringList[0];
                }
                patient.race=patientObj.Race__c;
                if(patientObj.Race__c=='White'){
                    patient.raceCode='2106-3';
                }else if(patientObj.Race__c=='Black or African American'){
                    patient.raceCode='2054-5';
                }else if(patientObj.Race__c=='American Indian or Alaska Native'){
                    patient.raceCode='1002-5';
                }else if(patientObj.Race__c=='Asian'){
                    patient.raceCode='2028-9';
                }else if(patientObj.Race__c=='Native Hawaiian or Pacific Islander'){
                    patient.raceCode='2076-8';
                }else{
                    patient.raceCode='N/A';
                }
                
                if(stringList.size()>1){
                    cdapackage.race[] additionalrace = new cdapackage.race[stringList.size()-1];
                    for(Integer i=1; i<stringList.size();i++){
                        cdapackage.race r = new cdapackage.race();
                        r.raceValue = stringList[i];
                        if(r.raceValue=='White'){
                            r.raceCode='2106-3';
                        }else if(r.raceValue=='Black or African American'){
                            r.raceCode='2054-5';
                        }else if(r.raceValue=='American Indian or Alaska Native'){
                            r.raceCode='1002-5';
                        }else if(r.raceValue=='Asian'){
                            r.raceCode='2028-9';
                        }else if(r.raceValue=='Native Hawaiian or Pacific Islander'){
                            r.raceCode='2076-8';
                        }else{
                            r.raceCode='N/A';
                        }
                        additionalrace[i-1] = r;
                    }
                    patient.additionalrace = additionalrace;
                }
            }
            if(patientSet.contains('Ethnicity__c')) {
                patient.ethinicity=patientObj.Ethnicity__c;
                if(patientObj.Ethnicity__c=='Not Hispanic or Latino'){
                    patient.ethinicityCode='2186-5';
                }else if(patientObj.Ethnicity__c=='Hispanic or Latino'){
                    patient.ethinicityCode='2135-2';
                }else{
                    patient.ethinicityCode='N/A';
                }
            }
            mrn=patientObj.Medical_Record_Number__c;
            
        }
       
        
        if(registrationSet.contains('ISPY2_Subject_Id__c')) {
            clinicalDoc.studySubjectIdentifier=registrationObj.ISPY2_Subject_Id__c ;
        }
        String siteId =registrationObj.Site__r.Id;
        String studyId = registrationObj.Trial__c ;

             
        try{
            cdapackage.response res = new cdapackage.response();
            if(Test.isRunningTest()) {
                res.status = 'SUCCESS';
                res.description='success message';
                res.code = 'SUCCESS';
            }else{
                res = ihub.submitPatientCDA(clinicalDoc,author,patient,xmlType);
            }
            System.debug('Amit================'+res.status);
            if(res.status=='SUCCESS'){
                registrationObj.IsIntegrationSuccess__c=True;
                registrationObj.Integration_Timestamp__c=System.now();
                update registrationObj;
                 
            }else if(res.status=='FAILURE'){                
                populateFailedRegistration(sharedObjectName,registrationObj.Id,patientId,trialId,siteId,studyId,res.code,res.description,'Failure','caAERS',mrn,res.caXchangeId,res.id); 
            }
            
        }catch(System.CalloutException e){
            String errorCode = '5001';
            populateFailedRegistration(sharedObjectName,registrationObj.Id,patientId,trialId,siteId,studyId,errorCode,'Connection timeout when accessing CDA Service','Failure','caAERS',mrn,null,null);
        }catch(Exception e){
            System.debug(e);
            String errorCode = '5000';
            populateFailedRegistration(sharedObjectName,registrationObj.Id,patientId,trialId,siteId,studyId,errorCode,'Unexpected error','Failure','caAERS',mrn,null,null);
        }
    
    }

    public static void populateFailedRegistration(string sharedObjectName,String crfId,String patientId, String trialId, String siteId,String studyId, String errorCode, String errorMessage, String status,String systemName, String mrn,String caXchangeId,String returnId){
        String CRFName;
        List<CRFMaster__c> crfList = [Select c.CRFType__c From CRFMaster__c c where c.Object_Name__c=: sharedObjectName];
        if(crfList.size()>0){
            CRFName = crfList[0].CRFType__c;
        }
        Boolean autoRetry = false;
        List<Auto_Retry_Error_Codes__c> codeList = Auto_Retry_Error_Codes__c.getAll().values();
        for(Auto_Retry_Error_Codes__c code : codeList){
            if(code.Error_Code__c==errorCode){
                autoRetry = true;
                break;
            }
        }  
        system.debug('@@TRIAL@@'+ trialId);
        system.debug('@@parent@@'+ patientId);
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=crfId,Patient__c=patientId,Trial__c=trialId,Last_Error_Message__c=errorMessage,Last_Status__c=status,Retry__c=autoRetry,Site__c=siteId,Study_Id__c=studyId,Error_Code__c=errorCode,System_Name__c=systemName,MRN__c=mrn,CRF_Name__c=CRFName,CaXchangeId__c=caXchangeId,ReturnId__c=returnId);
        system.debug('@@FAILED@@'+ fr);
        insert fr;
    }
    //Added by Amit
     public void submitRegistrationForPatientUpdate(String patientId){
     	//check if old registration exists for this patient in iHub
        List<Registration__c> oldRegistrationList =[Select id,Trial__c from Registration__c where Patient__c=:patientId /*and Trial__c=:trialId*/ and IsIntegrationSuccess__c = true limit 1];
        if(!oldRegistrationList.isEmpty()){
        	Registration__c registrationObj = oldRegistrationList[0];
        	String trialId = registrationObj.Trial__c;
        	String sharedObjectName='Registration__c';
        	submitRegistration(sharedObjectName, registrationObj.Id, patientId, trialId);
        }
     }
    
    //End of Add by Amit
}