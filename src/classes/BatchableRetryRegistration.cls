global class BatchableRetryRegistration implements Database.Batchable<sObject>,Schedulable,Database.AllowsCallouts {
   
    private Map<Integer, String> pano_product_map = new Map<Integer, String>();
    
    // This will be set from Test Class.
    public String query;
    
    public BatchableRetryRegistration(){ 
        
    }
     
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
            return Database.getQueryLocator('Select CRF_Id__C,CRF_Name__c,IsConsent__c,Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true');
        }else{
            return Database.getQueryLocator(query);
        }
    }
 
    global void execute(Database.BatchableContext BC, List<sObject> scope){
         
        for(sObject sobj:scope){
            Failed_Registration__c fr = (Failed_Registration__c)sobj;
            processFR(fr);
           
            
        }
       
    }
    public void processFR(Failed_Registration__c fr){
        
        if(fr.CRF_Name__c=='Patient Registration Form'){
            retryRegistration(fr.Id,fr.Trial__c,fr.Patient__c,fr.CRF_Id__c);
        }else if(fr.CRF_Name__c=='Tissue Specimen Form' && fr.IsConsent__c==False){
            retryTissueSpecimenSubmission(fr.Id,fr.Trial__c,fr.Patient__c,fr.CRF_Id__c);
        }else if(fr.CRF_Name__c=='Tissue Specimen Form' && fr.IsConsent__c==True){
            retryTissueSpecimenConsentSubmission(fr.Id,fr.Trial__c,fr.Patient__c,fr.CRF_Id__c);
        }
        else if(fr.CRF_Name__c=='Blood Specimen Form'&& fr.IsConsent__c==False){
            retryBloodSpecimenSubmission(fr.Id,fr.Trial__c,fr.Patient__c,fr.CRF_Id__c);
        }
        else if(fr.CRF_Name__c=='Blood Specimen Form'&& fr.IsConsent__c==True){
            retryBloodSpecimenConsentSubmission(fr.Id,fr.Trial__c,fr.Patient__c,fr.CRF_Id__c);
        }else if(fr.CRF_Name__c=='AE Form'){
            retryAdverseEventSubmission(fr.Id,fr.Trial__c,fr.Patient__c,fr.CRF_Id__c);
        }
        /*else if(fr.CRF_Name__c=='Trial Summary Note'){
            retryTrialSummaryNoteSubmission(fr.Id,fr.Trial__c,fr.Patient__c,fr.CRF_Id__c);
        }*/
    }
   
    public void retryRegistration(ID failedRegistrationId, ID trialId, ID patientId, String crfId ){
        
        //as per new service for registration
        List<Registration__c> registrationObjList = [Select Effective_Time__c,Institution__r.Name, Site__r.Id,Site__r.Name, r.Trial__c,Trial__r.Name, r.TrialPatient__c, r.SystemModstamp, r.Surgeon__c, r.Status__c, r.Site__c, r.Screening_Informed_Consent_Date__c, r.SSN__c, r.Registration_Date__c, r.RecordTypeId, r.Radiology_Coordinator__c, r.Radiology_Coordinator_Phone__c, r.Radiology_Coordinator_Fax__c, r.Radiology_Coordinator_Email__c, r.Race__c, r.Phase__c, r.Patient__c, r.Patient_Initials__c, r.Oncologist__c, r.Name, r.Middle_Name__c, r.Last_Name__c, r.LastModifiedDate, r.LastModifiedById, r.LastActivityDate, r.Lab__c, r.IsDeleted, r.Institution__c, r.Initials__c, r.Id, r.ISPY2_Subject_Id__c, r.IRB_Approval_Date__c, r.HIPPA_Consent_Date__c, r.Gender__c, r.First_Name__c, r.Ethnicity__c, r.CreatedDate, r.CreatedById, r.Country_of_birth__c, r.CompletedDate__c, r.Clinical_Coordinator__c, r.Clinical_Coordinator_Phone__c, r.Clinical_Coordinator_Fax__c, r.Clinical_Coordinator_Email__c, r.CRF__c From Registration__c r where Id = :crfId];
         
        if(!registrationObjList.isEmpty()) {
           Registration__c registrationObj = registrationObjList.get(0);
           
       
        
            CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='Registration__c' limit 1]; 
            
            //To fetch admin xml configuration
            List<XML_Configuration__c> xmlPatientList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'Patient_Custom__c'];
            List<XML_Configuration__c> xmlRegistrationList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'Registration__c'];
            Set<String> patientSet = new Set<String>();
            for(XML_Configuration__c x: xmlPatientList){
                patientSet.add(x.Field_API_Name__c);
            }
            Set<String> registrationSet = new Set<String>();
            for(XML_Configuration__c x: xmlRegistrationList){
                registrationSet.add(x.Field_API_Name__c);
            }
            
            ExternalServiceConnector serviceConnector = new ExternalServiceConnector('iHub');
            
            /*cdapackage.CDAGeneratorPort ihub = new cdapackage.CDAGeneratorPort();
            External_Connection_Settings__c iHubEndpoint = External_Connection_Settings__c.getInstance('iHub');
            if (iHubEndpoint !=null){
                ihub.endpoint_x=iHubEndpoint.URL__c;
                ihub.timeout_x=iHubEndpoint.Timeout__c.intValue();
            }
            else{
                ihub.endpoint_x = 'http://ec2-23-20-103-202.compute-1.amazonaws.com:12020/services/CDAGenerator';
                ihub.timeout_x = 120000;
            }*/
            
            cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
            cdapackage.author author = new cdapackage.author();
            cdapackage.patient patient = new cdapackage.patient();
            author.idExtension = UserInfo.getUserName();
        
            clinicalDoc.id=registrationObj.id;
            //clinicalDoc.title = 'Create Participant Registration';
            
            //check if old registration exists for this patient in iHub
            List<Registration__c> oldRegistrationList =[Select id from Registration__c where Patient__c=:patientId /*and Trial__c=:trialId*/ and IsIntegrationSuccess__c = true];
            
            //clinicalDoc.id=registrationObj.id;
            if(oldRegistrationList.isEmpty()){ 
                clinicalDoc.title = 'Create Participant Registration';
            }else{
                clinicalDoc.title = 'Update Participant Registration';
            }
            
            if(registrationObj.Effective_Time__c!=null){
                clinicalDoc.effectiveTime=String.valueOf(registrationObj.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }
            //clinicalDoc.siteIdentifier= registrationObj.Site__r.Name;
            String siteCode = registrationObj.Site__r.Name;
            if(registrationObj.Site__r.Name!=null){
                Integer index1 = registrationObj.Site__r.Name.indexOf('(');
                Integer index2 = registrationObj.Site__r.Name.indexOf(')');
                if(index1>-1 && index2>-1 && index2>index1 ){
                    siteCode = registrationObj.Site__r.Name.substring(index1+1,index2).trim();
                }
                
            }
            clinicalDoc.siteIdentifier= siteCode;
            clinicalDoc.siteIdRoot='2.16.840.1.113883.3.26.1.7';      
            clinicalDoc.studyId=registrationObj.Trial__r.Name ;
            clinicalDoc.studyIdRoot='2.16.840.1.113883.3.26.1.7' ;
            

            List<Patient_Custom__c> patientObjList = [Select  p.Name,p.Birthdate__c, p.Zip__c, p.SSN__c, p.Race__c, p.Middle_Name__c, p.Medical_Record_Number__c, p.Last_Name__c, p.Institution__c, p.Institute_Text__c, p.Initials__c, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.Country_of_Birth__c,(Select ISPY2_Subject_Id__c, trial__c From Registrations__r where trial__c =:registrationObj.Trial__c order by LastModifiedDate desc limit 1)  From Patient_Custom__c p where Id =:registrationObj.Patient__c limit 1];
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
                    Map<String,String> raceMap = new Map<String,String>();
                    raceMap.put('White','2106-3');
                    raceMap.put('Black or African American','2054-5');
                    raceMap.put('American Indian or Alaska Native','1002-5');
                    raceMap.put('Asian','2028-9');
                    raceMap.put('Native Hawaiian or Pacific Islander','2076-8');
                
                    patient.race=patientObj.Race__c;
                    /*
                    if(patientObj.Race__c=='White'){
                        patient.raceCode='2106-3';
                    }else if(patientObj.Race__c=='Black or African American'){
                        patient.raceCode='2054-5';
                    }else if(patientObj.Race__c=='American Indian or Alaska Native'){
                        patient.raceCode='1002-5';
                    }else if(patientObj.Race__c=='Asian'){
                        patient.raceCode='2028-9';
                    }else if(patientObj.Race__c=='Native Hawaiian or Other Pacific Islander'){
                        patient.raceCode='2076-8';
                    }else{
                        patient.raceCode='N/A';
                    }*/
                    patient.raceCode=(raceMap.get(patientObj.Race__c)==null?'N/A':raceMap.get(patientObj.Race__c));
                    
                    if(stringList.size()>1){
                        cdapackage.race[] additionalrace = new cdapackage.race[stringList.size()-1];
                        for(Integer i=1; i<stringList.size();i++){
                            cdapackage.race r = new cdapackage.race();
                            r.raceValue = stringList[i];
                            /*
                            if(r.raceValue=='White'){
                                r.raceCode='2106-3';
                            }else if(r.raceValue=='Black or African American'){
                                r.raceCode='2054-5';
                            }else if(r.raceValue=='American Indian or Alaska Native'){
                                r.raceCode='1002-5';
                            }else if(r.raceValue=='Asian'){
                                r.raceCode='2028-9';
                            }else if(r.raceValue=='Native Hawaiian or Other Pacific Islander'){
                                r.raceCode='2076-8';
                            }else{
                                r.raceCode='N/A';
                            }*/
                            r.raceCode=(raceMap.get(r.raceValue)==null?'N/A':raceMap.get(r.raceValue));
                            additionalrace[i-1] = r;
                        }
                        patient.additionalrace = additionalrace;
                    }
                }
                Map<String,String> ethinicityMap = new Map<String,String>();
                ethinicityMap.put('Not Hispanic or Latino','2186-5');
                ethinicityMap.put('Hispanic or Latino','2135-2');
            
                if(patientSet.contains('Ethnicity__c')) {
                    patient.ethinicity=patientObj.Ethnicity__c;
                    /*
                    if(patientObj.Ethnicity__c=='Not Hispanic or Latino'){
                        patient.ethinicityCode='2186-5';
                    }else if(patientObj.Ethnicity__c=='Hispanic or Latino'){
                        patient.ethinicityCode='2135-2';
                    }else{
                        patient.ethinicityCode='N/A';
                    }*/
                    patient.ethinicityCode=(ethinicityMap.get(patientObj.Ethnicity__c)==null?'N/A':ethinicityMap.get(patientObj.Ethnicity__c));
                }
                
                if(registrationSet.contains('ISPY2_Subject_Id__c')) {
                    clinicalDoc.studySubjectIdentifier=registrationObj.ISPY2_Subject_Id__c ;
                }
                
            }
           
           
            try{
                cdapackage.response res = new cdapackage.response();
                if(Test.isRunningTest()) {
                    res.status = 'SUCCESS';
                    res.description='success message';
                    res.code = 'SUCCESS';
                }else{

                    res = serviceConnector.ihub.submitPatientCDA(clinicalDoc,author,patient,'CDA');
                }
               
                if(res.status=='SUCCESS'){
                    updateFailedRegistration(failedRegistrationId,res.description,'Success',false,res.caXchangeId,res.id);
                }else{
                    updateFailedRegistration(failedRegistrationId,res.description,'Failure',true,res.caXchangeId,res.id);
                }
                
             
                
            }catch(Exception e){
                
                updateFailedRegistration(failedRegistrationId,e.getMessage(),'Failure',true,null,null);
            }
        
        }
    
    }
    private void updateFailedRegistration(Id failedRegistrationId,String message, String status, Boolean retry,String caXchangeId, String returnId){
        List<Failed_Registration__c> frList = [Select Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id,CaXchangeId__c,ReturnId__c From Failed_Registration__c where Id = :failedRegistrationId];
        if(frList.size()>0){
            Failed_Registration__c fr = frList[0];
            
            fr.Last_Error_Message__c = message;
            fr.Number_of_Retry__c = (fr.Number_of_Retry__c+1);
            fr.Last_Status__c=status;
            fr.Last_Run_DateTime__c = System.now();
            fr.Retry__c = retry;
            fr.CaXchangeId__c = caXchangeId;
            fr.ReturnId__c = returnId;
            update fr;
        }
    }
    public void retryTissueSpecimenSubmission(ID failedRegistrationId, ID trialId, ID patientId, String tsId ){
        
        List<TissueSpecimenDetail__c> lstTS = [Select t.TrialPatient__r.Trial_Id__r.Name,t.TrialPatient__r.Subject_Id__c,t.TrialPatient__r.Trial_Id__c,t.TrialPatient__c, t.TrialPatient__r.Patient_Id__c, t.TrialPatient__r.Name, t.Time_Point__c, t.SystemModstamp, t.Status__c, t.RecordTypeId, t.Reason_all_samples_not_collected__c, t.ProcedureDate__c, t.Phase__c, t.Patient__c, t.PatientConsentedStudy__c, t.PatientConsentedOutsideStudy__c, t.OwnerId, t.Other_Reason_not_all_samples_collected__c, t.Other_Guidance_Method__c, t.NumberOfSamplesCollected__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Guidance_Method_s__c, t.Effective_Time__c, t.CreatedById, t.CRFId__c From TissueSpecimenDetail__c t where Id = :tsId];
        if(!lstTS.isEmpty()) {
            TissueSpecimenDetail__c tissueSpecimenForm = lstTS[0]; 
            CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='TissueSpecimenDetail__c' limit 1]; 
            //To fetch admin xml configuration
            List<XML_Configuration__c> xmlPatientList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'Patient_Custom__c'];
            //List<XML_Configuration__c> xmlTissueSpecimenList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'TissueSpecimenDetail__c'];
            Set<String> patientSet = new Set<String>();
            for(XML_Configuration__c x: xmlPatientList){
                patientSet.add(x.Field_API_Name__c);
            }
            //Set<String> tissueSpecimenSet = new Set<String>();
            //for(XML_Configuration__c x: xmlTissueSpecimenList ){
            //    tissueSpecimenSet.add(x.Field_API_Name__c);
            //} 
            TrialPatient__c trialPatientObj;
            List<TrialPatient__c> lstTrialPatient = [select Id, Name, Patient_Id__c, Trial_Id__r.Name,Trial_Id__c,Subject_Id__c ,Site__c,Site__r.Name from TrialPatient__c where Patient_Id__c = :patientId and Trial_Id__c =:trialId];
            if(!lstTrialPatient.isEmpty()){
                trialPatientObj = lstTrialPatient[0];
            }     
            
            ExternalServiceConnector serviceConnector = new ExternalServiceConnector('iHub');
            /*cdapackage.CDAGeneratorPort ihub = new cdapackage.CDAGeneratorPort();
            External_Connection_Settings__c iHubEndpoint = External_Connection_Settings__c.getInstance('iHub');
            if (iHubEndpoint !=null){
                ihub.endpoint_x=iHubEndpoint.URL__c;
                ihub.timeout_x=iHubEndpoint.Timeout__c.intValue();
            }
            else{
                ihub.endpoint_x = 'http://ec2-23-20-103-202.compute-1.amazonaws.com:12020/services/CDAGenerator';
                ihub.timeout_x = 120000;
            }*/
            cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
            cdapackage.author author = new cdapackage.author();
            cdapackage.patient patient = new cdapackage.patient();
            cdapackage.procedure procedure = new cdapackage.procedure();
            cdapackage.guidanceMethod[] guidanceArray;// = new cdapackage.guidanceMethod[]{};
            cdapackage.specimen[] specimenArray;
            String xmlType = 'CDA';
            author.idExtension = UserInfo.getUserName();
            
            clinicalDoc.id=tissueSpecimenForm.id;
            clinicalDoc.title = 'Create Biospecimen';
            if(tissueSpecimenForm.Effective_Time__c!=null){
                clinicalDoc.effectiveTime=String.valueOf(tissueSpecimenForm.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }
            //clinicalDoc.siteIdentifier= trialPatientObj.Site__r.Name;
            String siteCode = trialPatientObj.Site__r.Name;
            if(trialPatientObj.Site__r.Name!=null){
                Integer index1 = trialPatientObj.Site__r.Name.indexOf('(');
                Integer index2 = trialPatientObj.Site__r.Name.indexOf(')');
                if(index1>-1 && index2>-1 && index2>index1 ){
                    siteCode = trialPatientObj.Site__r.Name.substring(index1+1,index2).trim();
                }
            }
            clinicalDoc.siteIdentifier= siteCode;
            clinicalDoc.siteIdRoot='2.16.840.1.113883.3.26.1.7';      
            clinicalDoc.studyId=trialPatientObj.Trial_Id__r.Name ;
            clinicalDoc.studyIdRoot='2.16.840.1.113883.3.26.1.7' ;
            clinicalDoc.studySubjectIdentifier=tissueSpecimenForm.TrialPatient__r.Subject_Id__c;
            
            List<Patient_Custom__c> patientObjList = [Select  p.Name,p.mrn__c,p.Birthdate__c, p.Zip__c, p.SSN__c, p.Race__c, p.Middle_Name__c, p.Medical_Record_Number__c, p.Last_Name__c, p.Institution__c, p.Institute_Text__c, p.Initials__c, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.Country_of_Birth__c From Patient_Custom__c p where Id =:patientId limit 1];
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
                    Map<String,String> raceMap = new Map<String,String>();
                    raceMap.put('White','2106-3');
                    raceMap.put('Black or African American','2054-5');
                    raceMap.put('American Indian or Alaska Native','1002-5');
                    raceMap.put('Asian','2028-9');
                    raceMap.put('Native Hawaiian or Pacific Islander','2076-8');
                    /*
                    if(patientObj.Race__c=='White'){
                        patient.raceCode='2106-3';
                    }else if(patientObj.Race__c=='Black or African American'){
                        patient.raceCode='2054-5';
                    }else if(patientObj.Race__c=='American Indian or Alaska Native'){
                        patient.raceCode='1002-5';
                    }else if(patientObj.Race__c=='Asian'){
                        patient.raceCode='2028-9';
                    }else if(patientObj.Race__c=='Native Hawaiian or Other Pacific Islander'){
                        patient.raceCode='2076-8';
                    }else{
                        patient.raceCode='N/A';
                    }
                    */
                    patient.raceCode=(raceMap.get(patientObj.Race__c)==null?'N/A':raceMap.get(patientObj.Race__c));
                    
                    if(stringList.size()>1){
                        cdapackage.race[] additionalrace = new cdapackage.race[stringList.size()-1];
                        for(Integer i=1; i<stringList.size();i++){
                            cdapackage.race r = new cdapackage.race();
                            r.raceValue = stringList[i];
                            /*
                            if(r.raceValue=='White'){
                                r.raceCode='2106-3';
                            }else if(r.raceValue=='Black or African American'){
                                r.raceCode='2054-5';
                            }else if(r.raceValue=='American Indian or Alaska Native'){
                                r.raceCode='1002-5';
                            }else if(r.raceValue=='Asian'){
                                r.raceCode='2028-9';
                            }else if(r.raceValue=='Native Hawaiian or Other Pacific Islander'){
                                r.raceCode='2076-8';
                            }else{
                                r.raceCode='N/A';
                            }
                            */
                            r.raceCode=(raceMap.get(r.raceValue)==null?'N/A':raceMap.get(r.raceValue));
                            additionalrace[i-1] = r;
                        }
                        patient.additionalrace = additionalrace;
                    }
                }
                Map<String,String> ethinicityMap = new Map<String,String>();
                ethinicityMap.put('Not Hispanic or Latino','2186-5');
                ethinicityMap.put('Hispanic or Latino','2135-2');
                
                if(patientSet.contains('Ethnicity__c')) {
                    patient.ethinicity=patientObj.Ethnicity__c;
                    /*
                    if(patientObj.Ethnicity__c=='Not Hispanic or Latino'){
                        patient.ethinicityCode='2186-5';
                    }else if(patientObj.Ethnicity__c=='Hispanic or Latino'){
                        patient.ethinicityCode='2135-2';
                    }else{
                        patient.ethinicityCode='N/A';
                    }*/
                    patient.ethinicityCode=(ethinicityMap.get(patientObj.Ethnicity__c)==null?'N/A':ethinicityMap.get(patientObj.Ethnicity__c));
                    
                }

                    
                
            }
            
       
            procedure.studyIdentifier=tissueSpecimenForm.TrialPatient__r.Trial_Id__c ;
            procedure.activityStatus='Active';
            procedure.activityStatusCode='55561003';
            //procedure.availableQuantity='1';
            //procedure.initialQuantity='1';
            procedure.barcode='1098';
            //procedure.collectionProtocolShortTitle=tissueSpecimenForm.TrialPatient__r.Trial_Id__r.Name;
            //procedure.collectionProtocolTitle=tissueSpecimenForm.TrialPatient__r.Trial_Id__r.Name;
            //procedure.specimenCharacteristicsSide='Right';
            //procedure.specimenCharacteristicsSideCode='24028007';
            //procedure.specimenCharacteristicsSite='breast';
            //procedure.specimenType='Tissue';
            //procedure.specimenTypeCode='119376003';
            
            procedure.collectionProtocolShortTitle='Needle Core Biopsy';
            procedure.collectionProtocolTitle='Needle Core Biopsy';
            procedure.specimenCharacteristicsSide='Right';
            procedure.specimenCharacteristicsSideCode='24028007';
            procedure.specimenCharacteristicsSite='Not Specified';
            procedure.specimenClass='Tissue';
            procedure.specimenClassCode='119376003';
            
            //procedure.studyCalendarEventTimePoint=tissueSpecimenForm.Time_Point__c;
            if(tissueSpecimenForm.ProcedureDate__c!=null){
                procedure.collectionDate =String.valueOf(tissueSpecimenForm.ProcedureDate__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }
            
            Map<String,String> guidanceMap = new Map<String,String>();
            guidanceMap.put('Ultrasound','16310003');
            guidanceMap.put('MRI','241615005');
            guidanceMap.put('Stereotactic','258172002');
            guidanceMap.put('Mammography','71651007');
            guidanceMap.put('Palpation guided','113011001'); 
                    
            List<String> stringList = tissueSpecimenForm.Guidance_Method_s__c.split('\\;');
            guidanceArray = new cdapackage.guidanceMethod[stringList.size()];
            for(Integer i=0;i<stringList.size();i++) {
                String s = stringList[i];
                cdapackage.guidanceMethod gm = new cdapackage.guidanceMethod();
                
                gm.valueDisplayName=s;
                gm.valueOriginalText=s;
                /*
                if(s=='Ultrasound'){
                    gm.valueCode='16310003';
                }else if(s=='MRI'){
                    gm.valueCode='241615005';
                }else if(s=='Stereotactic'){
                    gm.valueCode='258172002';
                }else if(s=='Mammography'){
                    gm.valueCode='71651007';
                }else if(s=='Palpation'){
                    gm.valueCode='113011001';
                }else{
                    gm.valueCode='N/A';
                }*/
                gm.valueCode=(guidanceMap.get(s)==null?'NA':guidanceMap.get(s));
                if(s=='Other'){
                    gm.valueCode='NA';
                    gm.valueDisplayName=tissueSpecimenForm.Other_Guidance_Method__c;
                    gm.valueOriginalText=tissueSpecimenForm.Other_Guidance_Method__c;
                }
               
                guidanceArray[i] = gm;
            }
            //Retrive all Specimen id for a time point and trial patient id which have been successfully intergated
            Set<String> oldSpecimenIdSet = new Set<String>();
            List<Core_Biopsy_Specimens__c> previousCoreBiopsyList = [Select  c.SpecimenID__c From Core_Biopsy_Specimens__c c where c.SpecimenID__c !=null and c.Is_Integration_Success__c=true and c.TissueSpecimenDetail__c != :tissueSpecimenForm.Id and Shipped__c='Yes' and c.TissueSpecimenDetail__r.Time_Point__c=:tissueSpecimenForm.Time_Point__c and c.TissueSpecimenDetail__r.TrialPatient__c=:trialPatientObj.Id];
            for(Core_Biopsy_Specimens__c b :previousCoreBiopsyList){
                oldSpecimenIdSet.add(b.SpecimenID__c);
            }
        
            Map<String,String> timepointMap = new Map<String,String>();
            timepointMap.put('Pre-treatment','0');
            timepointMap.put('Early Treatment','1');
            timepointMap.put('Inter-Regimen','2');
            timepointMap.put('Pre-Treatment Re-Biopsy','3');
            timepointMap.put('Surgery','4');
            
            List<cdapackage.specimen> specimenUpdateList = new List<cdapackage.specimen>();
            List<cdapackage.specimen> specimenAddList = new List<cdapackage.specimen>();
        
            List<Core_Biopsy_Specimens__c> coreBiopsyList = [Select c.TissueSpecimenDetail__c, c.SystemModstamp, c.SpecimenID__c, c.Shipped__c, c.Reason_samples_not_shipped__c, c.Other_Reason_samples_not_shipped__c, c.Name, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.Effective_Time__c, c.CreatedById, c.Core_Specimen__c From Core_Biopsy_Specimens__c c where TissueSpecimenDetail__c = :tissueSpecimenForm.Id];
            //specimenArray = new cdapackage.specimen[coreBiopsyList.size()];
            for(Integer i=0;I<coreBiopsyList.size();i++){
                Core_Biopsy_Specimens__c specimen = coreBiopsyList[i];
                cdapackage.specimen sp= new cdapackage.specimen();
                sp.specimenID = specimen.SpecimenID__c;
                sp.specimenDisplayName='Frozen Tissue';
                sp.specimenCode = 'N/A';
                sp.availableQuantity='1';
                sp.availableQuantityUnit='g';    
                sp.initialQuantity='1';
                sp.initialQuantityUnit='g';
                
                /*
                if(tissueSpecimenForm.Time_Point__c=='Pre-treatment'){
                    sp.studyCalendarEventTimePoint='0';
                }else if(tissueSpecimenForm.Time_Point__c=='Early Treatment'){
                    sp.studyCalendarEventTimePoint='1';
                }else if(tissueSpecimenForm.Time_Point__c=='Inter-Regimen'){
                    sp.studyCalendarEventTimePoint='2';
                }else if(tissueSpecimenForm.Time_Point__c=='Pre-Treatment Re-Biopsy'){
                    sp.studyCalendarEventTimePoint='3';
                }else if(tissueSpecimenForm.Time_Point__c=='Surgery'){
                    sp.studyCalendarEventTimePoint='4';
                }
                */
                sp.studyCalendarEventTimePoint=timepointMap.get(tissueSpecimenForm.Time_Point__c);
                
                //sp.studyCalendarEventTimePoint;
                sp.studyCalendarEventTimePointUnit='d';
                //specimenArray[i]=sp;
                if(oldSpecimenIdSet.contains(specimen.SpecimenID__c)){
                    specimenUpdateList.add(sp);
                }else{
                    specimenAddList.add(sp);
                }
            }
            
             
            try{
                cdapackage.response res = new cdapackage.response();
                if(Test.isRunningTest()) {
                    res.status = 'SUCCESS';
                    res.description='success message';
                    res.code = 'SUCCESS';
                }else{
                    //res = ihub.submitBioCDA(clinicalDoc,author,patient,procedure,specimenArray, guidanceArray,xmlType);
                    if(!specimenAddList.isEmpty()){
                        specimenArray = new cdapackage.specimen[specimenAddList.size()];
                        for(Integer i=0; i<specimenAddList.size();i++){
                            specimenArray[i]=specimenAddList[i];
                        }
                        clinicalDoc.title = 'Create Biospecimen';
                        res = serviceConnector.ihub.submitBioCDA(clinicalDoc,author,patient,procedure,specimenArray, guidanceArray,xmlType);
                    }
                    
                    if(!specimenUpdateList.isEmpty()){
                        specimenArray = new cdapackage.specimen[specimenUpdateList.size()];
                        for(Integer i=0; i<specimenUpdateList.size();i++){
                            specimenArray[i]=specimenUpdateList[i];
                        }
                        clinicalDoc.title = 'Update Biospecimen';
                        res = serviceConnector.ihub.submitBioCDA(clinicalDoc,author,patient,procedure,specimenArray, guidanceArray,xmlType);
                    }
                    
                }
                
              
                if(res.status=='SUCCESS'){
                    updateFailedRegistration(failedRegistrationId,res.description,'Success',false,res.caXchangeId,res.id);
                    
                    for(Core_Biopsy_Specimens__c biopsy : coreBiopsyList){
                        biopsy.Is_Integration_Success__c =true; 
                        biopsy.Integration_Timestamp__c = System.now(); 
                    }
                    update coreBiopsyList;
            
                }else{
                    updateFailedRegistration(failedRegistrationId,res.description,'Failure',true,res.caXchangeId,res.id);
                }
                
                
            }catch(Exception e){
                
                updateFailedRegistration(failedRegistrationId,e.getMessage(),'Failure',true,null,null);
            }
            
        }
    }
    public void retryTissueSpecimenConsentSubmission(ID failedRegistrationId, ID trialId, ID patientId, String tsId ){
        
        List<TissueSpecimenDetail__c> lstTS = [Select t.CompletedDate__c,t.TrialPatient__r.Trial_Id__r.Name,t.TrialPatient__r.Subject_Id__c,t.TrialPatient__r.Trial_Id__c,t.TrialPatient__c, t.TrialPatient__r.Patient_Id__c, t.TrialPatient__r.Name, t.Time_Point__c, t.SystemModstamp, t.Status__c, t.RecordTypeId, t.Reason_all_samples_not_collected__c, t.ProcedureDate__c, t.Phase__c, t.Patient__c, t.PatientConsentedStudy__c, t.PatientConsentedOutsideStudy__c, t.OwnerId, t.Other_Reason_not_all_samples_collected__c, t.Other_Guidance_Method__c, t.NumberOfSamplesCollected__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Guidance_Method_s__c, t.Effective_Time__c, t.CreatedById, t.CRFId__c From TissueSpecimenDetail__c t where Id = :tsId];
        if(!lstTS.isEmpty()) {
            TissueSpecimenDetail__c tissueSpecimenForm = lstTS[0]; 
            CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='TissueSpecimenDetail__c' limit 1]; 
            //To fetch admin xml configuration
            List<XML_Configuration__c> xmlPatientList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'Patient_Custom__c'];
            //List<XML_Configuration__c> xmlTissueSpecimenList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'TissueSpecimenDetail__c'];
            Set<String> patientSet = new Set<String>();
            for(XML_Configuration__c x: xmlPatientList){
                patientSet.add(x.Field_API_Name__c);
            }
            //Set<String> tissueSpecimenSet = new Set<String>();
            //for(XML_Configuration__c x: xmlTissueSpecimenList ){
            //    tissueSpecimenSet.add(x.Field_API_Name__c);
            //} 
            
            ExternalServiceConnector serviceConnector = new ExternalServiceConnector('iHub');
            /*cdapackage.CDAGeneratorPort ihub = new cdapackage.CDAGeneratorPort();
            External_Connection_Settings__c iHubEndpoint = External_Connection_Settings__c.getInstance('iHub');
            if (iHubEndpoint !=null){
                ihub.endpoint_x=iHubEndpoint.URL__c;
                ihub.timeout_x=iHubEndpoint.Timeout__c.intValue();
            }
            else{
                ihub.endpoint_x = 'http://ec2-23-20-103-202.compute-1.amazonaws.com:12020/services/CDAGenerator';
                ihub.timeout_x = 120000;
            }*/
            cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
            cdapackage.author author = new cdapackage.author();
            cdapackage.patient patient = new cdapackage.patient();
            String xmlType = 'CDA';
            author.idExtension = UserInfo.getUserName();
            
            clinicalDoc.id=tissueSpecimenForm.id;
            clinicalDoc.title = 'Register Consent';
            if(tissueSpecimenForm.Effective_Time__c!=null){
                clinicalDoc.effectiveTime=String.valueOf(tissueSpecimenForm.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }
            
            
            TrialPatient__c trialPatientObj;
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name,Trial_Id__c,Subject_Id__c ,Site__c,Site__r.Name from TrialPatient__c where Patient_Id__c = :patientId and Trial_Id__c =:trialId];
            if(!lstTrialPatient.isEmpty()){
                trialPatientObj = lstTrialPatient[0];
            } 
            //clinicalDoc.siteIdentifier= trialPatientObj.Site__r.Name;
            String siteCode = trialPatientObj.Site__r.Name;
            if(trialPatientObj.Site__r.Name!=null){
                Integer index1 = trialPatientObj.Site__r.Name.indexOf('(');
                Integer index2 = trialPatientObj.Site__r.Name.indexOf(')');
                if(index1>-1 && index2>-1 && index2>index1 ){
                    siteCode = trialPatientObj.Site__r.Name.substring(index1+1,index2).trim();
                }
            }
            clinicalDoc.siteIdentifier= siteCode;
            
            clinicalDoc.siteIdRoot='2.16.840.1.113883.3.26.1.7';      
            clinicalDoc.studyId=trialPatientObj.Trial_Id__r.Name ;
            clinicalDoc.studyIdRoot='2.16.840.1.113883.3.26.1.7' ;
            clinicalDoc.studySubjectIdentifier=trialPatientObj.Subject_Id__c;
            
            List<Patient_Custom__c> patientObjList = [Select  p.Name,p.mrn__c,p.Birthdate__c, p.Zip__c, p.SSN__c, p.Race__c, p.Middle_Name__c, p.Medical_Record_Number__c, p.Last_Name__c, p.Institution__c, p.Institute_Text__c, p.Initials__c, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.Country_of_Birth__c From Patient_Custom__c p where Id =:patientId limit 1];
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
                    
                    Map<String,String> raceMap = new Map<String,String>();
                    raceMap.put('White','2106-3');
                    raceMap.put('Black or African American','2054-5');
                    raceMap.put('American Indian or Alaska Native','1002-5');
                    raceMap.put('Asian','2028-9');
                    raceMap.put('Native Hawaiian or Pacific Islander','2076-8');
                    /*
                    if(patientObj.Race__c=='White'){
                        patient.raceCode='2106-3';
                    }else if(patientObj.Race__c=='Black or African American'){
                        patient.raceCode='2054-5';
                    }else if(patientObj.Race__c=='American Indian or Alaska Native'){
                        patient.raceCode='1002-5';
                    }else if(patientObj.Race__c=='Asian'){
                        patient.raceCode='2028-9';
                    }else if(patientObj.Race__c=='Native Hawaiian or Other Pacific Islander'){
                        patient.raceCode='2076-8';
                    }else{
                        patient.raceCode='N/A';
                    }*/
                    patient.raceCode=(raceMap.get(patientObj.Race__c)==null?'N/A':raceMap.get(patientObj.Race__c));
                    
                    if(stringList.size()>1){
                        cdapackage.race[] additionalrace = new cdapackage.race[stringList.size()-1];
                        for(Integer i=1; i<stringList.size();i++){
                            cdapackage.race r = new cdapackage.race();
                            r.raceValue = stringList[i];
                            /*
                            if(r.raceValue=='White'){
                                r.raceCode='2106-3';
                            }else if(r.raceValue=='Black or African American'){
                                r.raceCode='2054-5';
                            }else if(r.raceValue=='American Indian or Alaska Native'){
                                r.raceCode='1002-5';
                            }else if(r.raceValue=='Asian'){
                                r.raceCode='2028-9';
                            }else if(r.raceValue=='Native Hawaiian or Other Pacific Islander'){
                                r.raceCode='2076-8';
                            }else{
                                r.raceCode='N/A';
                            }*/
                            r.raceCode=(raceMap.get(r.raceValue)==null?'N/A':raceMap.get(r.raceValue));
                            additionalrace[i-1] = r;
                        }
                        patient.additionalrace = additionalrace;
                    }
                }
                
                Map<String,String> ethinicityMap = new Map<String,String>();
                ethinicityMap.put('Not Hispanic or Latino','2186-5');
                ethinicityMap.put('Hispanic or Latino','2135-2');
                
                if(patientSet.contains('Ethnicity__c')) {
                    patient.ethinicity=patientObj.Ethnicity__c;
                    /*
                    if(patientObj.Ethnicity__c=='Not Hispanic or Latino'){
                        patient.ethinicityCode='2186-5';
                    }else if(patientObj.Ethnicity__c=='Hispanic or Latino'){
                        patient.ethinicityCode='2135-2';
                    }else{
                        patient.ethinicityCode='N/A';
                    }*/
                    patient.ethinicityCode=(ethinicityMap.get(patientObj.Ethnicity__c)==null?'N/A':ethinicityMap.get(patientObj.Ethnicity__c));
                }
                
            }
            
               
            
            /*
            Boolean isChangeInConsent = false;
            cdapackage.consent consent = new cdapackage.consent();
            List<TissueSpecimenDetail__c> lstTS2 = [Select t.CompletedDate__c,t.TrialPatient__c, t.TrialPatient__r.Patient_Id__c, t.TrialPatient__r.Name, t.Time_Point__c, t.SystemModstamp, t.Status__c, t.RecordTypeId, t.Reason_all_samples_not_collected__c, t.ProcedureDate__c, t.Phase__c, t.Patient__c, t.PatientConsentedStudy__c, t.PatientConsentedOutsideStudy__c, t.OwnerId, t.Other_Reason_not_all_samples_collected__c, t.Other_Guidance_Method__c, t.NumberOfSamplesCollected__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Guidance_Method_s__c, t.Effective_Time__c, t.CreatedById, t.CRFId__c From TissueSpecimenDetail__c t where Patient__c = :patientId and TrialPatient__c=:tissueSpecimenForm.TrialPatient__c and Time_Point__c=:tissueSpecimenForm.Time_Point__c and Id !=:tissueSpecimenForm.Id order by CompletedDate__c desc ];
            if(lstTS2.size()==0 ){
               
                if(tissueSpecimenForm.PatientConsentedStudy__c==True ||tissueSpecimenForm.PatientConsentedOutsideStudy__c==True){
                    isChangeInConsent = true;
                    consent.consentDateTime=String.valueOf(tissueSpecimenForm.CompletedDate__c);
                    consent.tier1Response=(tissueSpecimenForm.PatientConsentedStudy__c==True?'Yes':'No');
                    consent.tier2Response=(tissueSpecimenForm.PatientConsentedOutsideStudy__c==True?'Yes':'No');
                    consent.tier1ResponseCode=(tissueSpecimenForm.PatientConsentedStudy__c==True?'399174000':'399250008');
                    consent.tier2ResponseCode=(tissueSpecimenForm.PatientConsentedOutsideStudy__c==True?'399174000':'399250008'); 
                }
                
            } else if(lstTS2.size()>0 ){
                
                TissueSpecimenDetail__c ts1 = tissueSpecimenForm;
                TissueSpecimenDetail__c ts2 = lstTS2[0];
                consent.consentDateTime=String.valueOf(ts1.CompletedDate__c);
                if(ts1.PatientConsentedStudy__c==True && ts2.PatientConsentedStudy__c==False){
                    consent.tier1Response='Yes';
                    consent.tier1ResponseCode='399174000';
                    isChangeInConsent = true;
                }else if(ts1.PatientConsentedStudy__c==False && ts2.PatientConsentedStudy__c==True){
                    consent.tier1Response='Withdrawn';
                    consent.tier1ResponseCode='185924006';
                    isChangeInConsent = true;
                }else if(ts1.PatientConsentedStudy__c==False && ts2.PatientConsentedStudy__c==False){
                    consent.tier1Response='No';
                    consent.tier1ResponseCode='399250008';
                }
                
                if(ts1.PatientConsentedOutsideStudy__c==True && ts2.PatientConsentedOutsideStudy__c==False){
                    consent.tier2Response='Yes';
                    consent.tier2ResponseCode='399174000';
                    isChangeInConsent = true;
                }else if(ts1.PatientConsentedOutsideStudy__c==False && ts2.PatientConsentedOutsideStudy__c==True){
                    consent.tier2Response='Withdrawn';
                    consent.tier2ResponseCode='185924006';
                    isChangeInConsent = true;
                }else if(ts1.PatientConsentedOutsideStudy__c==False && ts2.PatientConsentedOutsideStudy__c==False){
                    consent.tier2Response='No';
                    consent.tier2ResponseCode='399250008';
                }
                
            }  */
            
            cdapackage.consent consent = new cdapackage.consent();
            cdapackage.consent[] consentArray = null;
            
            consent.consentDateTime=String.valueOf(tissueSpecimenForm.CreatedDate).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            consent.tier1Response=(tissueSpecimenForm.PatientConsentedStudy__c==True?'Yes':'No');
            consent.tier2Response=(tissueSpecimenForm.PatientConsentedOutsideStudy__c==True?'Yes':'No');
            consent.tier1ResponseCode=(tissueSpecimenForm.PatientConsentedStudy__c==True?'373066001':'373067005');
            consent.tier2ResponseCode=(tissueSpecimenForm.PatientConsentedOutsideStudy__c==True?'373066001':'373067005'); 
                    
            List<Core_Biopsy_Specimens__c> coreBiopsyList = [Select c.TissueSpecimenDetail__c, c.SystemModstamp, c.SpecimenID__c, c.Shipped__c, c.Reason_samples_not_shipped__c, c.Other_Reason_samples_not_shipped__c, c.Name, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.Effective_Time__c, c.CreatedById, c.Core_Specimen__c From Core_Biopsy_Specimens__c c where TissueSpecimenDetail__c = :tsId];
               
             consentArray = new cdapackage.consent[coreBiopsyList.size()]; 
             for(Integer i=0;I<coreBiopsyList.size();i++){
                Core_Biopsy_Specimens__c specimen = coreBiopsyList[i];
                //cdapackage.specimen sp= new cdapackage.specimen();
                cdapackage.consent consent1 = consent.clone();
                consent1.cdmsid = specimen.SpecimenID__c;
            
                consentArray[i]=consent1;
            }
          
            
            //if(isChangeInConsent){
            //List<Core_Biopsy_Specimens__c> coreBiopsyList = [Select c.TissueSpecimenDetail__c, c.SystemModstamp, c.SpecimenID__c, c.Shipped__c, c.Reason_samples_not_shipped__c, c.Other_Reason_samples_not_shipped__c, c.Name, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.Effective_Time__c, c.CreatedById, c.Core_Specimen__c From Core_Biopsy_Specimens__c c where TissueSpecimenDetail__c = :tsId];
            /*
            cdapackage.consent[] consentArray = new cdapackage.consent[coreBiopsyList.size()]; 
             for(Integer i=0;I<coreBiopsyList.size();i++){
                Core_Biopsy_Specimens__c specimen = coreBiopsyList[i];
                //cdapackage.specimen sp= new cdapackage.specimen();
                cdapackage.consent consent1 = consent.clone();
                consent1.cdmsid = specimen.SpecimenID__c;
            
                consentArray[i]=consent1;
            }  */
        
            try{
               
                cdapackage.response res2 = new cdapackage.response();
                if(Test.isRunningTest()) {
                    res2.status = 'SUCCESS';
                    res2.description='success message';
                    res2.code = 'SUCCESS';
                }else{
                    
                   res2 = serviceConnector.ihub.submitConsentCDA(clinicalDoc,author,patient,consentArray ,xmlType);
                   
                }
                
                
                if(res2.status=='SUCCESS'){
                    updateFailedRegistration(failedRegistrationId,res2.description,'Success',false,res2.caXchangeId,res2.id);
                }else{
                    updateFailedRegistration(failedRegistrationId,res2.description,'Failure',true,res2.caXchangeId,res2.id);
                }
                
                
            }catch(Exception e){
                System.debug(e);
                
                updateFailedRegistration(failedRegistrationId,e.getMessage(),'Failure',true,null,null);
            }
            //} 
        }
    }
    public void retryBloodSpecimenSubmission(ID failedRegistrationId, ID trialId, ID patientId, String bsId ){
        
        List<BloodSpecimenForm__c> lstBSF = [Select b.TrialPatient__r.Trial_Id__r.Name,b.TrialPatient__r.Trial_Id__c,b.TrialPatient__r.Subject_Id__c,b.Effective_Time__c,b.TrialPatient__c, b.TrialPatient__r.Name, b.CRF__c,b.TrialPatient__r.Patient_Id__c, b.Time_Point__c, b.Status__c, b.Reason_all_samples_not_collected__c, b.Phase__c, b.Other_Reason_samples_not_shipped__c, b.Name, b.Id, b.Contented_specimen_outside_study__c, b.Consented_to_use_specimen_study__c, b.CompletedDate__c, b.CollectionDate__c, (Select Name, BloodSpecimenForm__c, Shipped__c, Reason_samples_not_shipped__c, Other_Reason_samples_not_shipped__c, Specimen_ID__c From BloodSpecimenInfo__r) From BloodSpecimenForm__c b where Id = :bsId];
        if(!lstBSF.isEmpty()) {
            BloodSpecimenForm__c bloodSpecimen= lstBSF[0];
            
            CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='BloodSpecimenForm__c' limit 1]; 
             //To fetch admin xml configuration
            List<XML_Configuration__c> xmlPatientList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'Patient_Custom__c'];
            //List<XML_Configuration__c> xmlTissueSpecimenList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'BloodSpecimenForm__c'];
            Set<String> patientSet = new Set<String>();
            for(XML_Configuration__c x: xmlPatientList){
                patientSet.add(x.Field_API_Name__c);
            }
            
            ExternalServiceConnector serviceConnector = new ExternalServiceConnector('iHub');
            /*cdapackage.CDAGeneratorPort ihub = new cdapackage.CDAGeneratorPort();
            External_Connection_Settings__c iHubEndpoint = External_Connection_Settings__c.getInstance('iHub');
            if (iHubEndpoint !=null){
                ihub.endpoint_x=iHubEndpoint.URL__c;
                ihub.timeout_x=iHubEndpoint.Timeout__c.intValue();
            }
            //else{
            //    ihub.endpoint_x = 'http://ec2-54-242-110-43.compute-1.amazonaws.com:8080/TranscendForce/services/TranscendForceResource';
            //    ihub.timeout_x = 120000;
            //}*/
            cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
            cdapackage.author author = new cdapackage.author();
            cdapackage.patient patient = new cdapackage.patient();
            cdapackage.procedure procedure = new cdapackage.procedure();
            //cdapackage.guidanceMethod[] guidanceArray;// = new cdapackage.guidanceMethod[]{};
            cdapackage.specimen[] specimenArray;
            
            cdapackage.guidanceMethod[] guidanceArray = new cdapackage.guidanceMethod[1];
            cdapackage.guidanceMethod gm = new cdapackage.guidanceMethod();
            gm.valueDisplayName='Guidance for Breast Core Biopsy';
            gm.valueOriginalText='Guidance for Breast Core Biopsy';
            gm.valueCode='NA';
            guidanceArray[0] = gm;
            
            String xmlType = 'CDA';
            author.idExtension = UserInfo.getUserName();
            
            clinicalDoc.id=bloodSpecimen.id;
            clinicalDoc.title = 'Create Biospecimen';
            //clinicalDoc.effectiveTime=String.valueOf(bloodSpecimen.Effective_Time__c);
            if(bloodSpecimen.Effective_Time__c!=null){
                clinicalDoc.effectiveTime=String.valueOf(bloodSpecimen.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }
            
            //String siteId,studyId,mrn;
            TrialPatient__c trialPatientObj;
            List<TrialPatient__c> lstTrialPatient = [select Id,Name, Patient_Id__c, Trial_Id__r.Name,Trial_Id__c,Subject_Id__c ,Site__c,Site__r.Name from TrialPatient__c where Patient_Id__c = :patientId and Trial_Id__c =:trialId];
            if(!lstTrialPatient.isEmpty()){
                trialPatientObj = lstTrialPatient[0];
            } 
            String siteCode = trialPatientObj.Site__r.Name;
            if(trialPatientObj.Site__r.Name!=null){
                Integer index1 = trialPatientObj.Site__r.Name.indexOf('(');
                Integer index2 = trialPatientObj.Site__r.Name.indexOf(')');
                if(index1>-1 && index2>-1 && index2>index1 ){
                    siteCode = trialPatientObj.Site__r.Name.substring(index1+1,index2).trim();
                }
            }
            clinicalDoc.siteIdentifier= siteCode;
        
            //clinicalDoc.siteIdentifier= trialPatientObj.Site__r.Name;
            clinicalDoc.siteIdRoot='2.16.840.1.113883.3.26.1.7';      
            clinicalDoc.studyId=trialPatientObj.Trial_Id__r.Name ;
            clinicalDoc.studyIdRoot='2.16.840.1.113883.3.26.1.7' ;
            clinicalDoc.studySubjectIdentifier=trialPatientObj.Subject_Id__c;
             
            List<Patient_Custom__c> patientObjList = [Select  p.Name,p.mrn__c,p.Birthdate__c, p.Zip__c, p.SSN__c, p.Race__c, p.Middle_Name__c, p.Medical_Record_Number__c, p.Last_Name__c, p.Institution__c, p.Institute_Text__c, p.Initials__c, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.Country_of_Birth__c From Patient_Custom__c p where Id =:patientId limit 1];
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
                    Map<String,String> raceMap = new Map<String,String>();
                    raceMap.put('White','2106-3');
                    raceMap.put('Black or African American','2054-5');
                    raceMap.put('American Indian or Alaska Native','1002-5');
                    raceMap.put('Asian','2028-9');
                    raceMap.put('Native Hawaiian or Pacific Islander','2076-8');
                
                    patient.race=patientObj.Race__c;
                    /*
                    if(patientObj.Race__c=='White'){
                        patient.raceCode='2106-3';
                    }else if(patientObj.Race__c=='Black or African American'){
                        patient.raceCode='2054-5';
                    }else if(patientObj.Race__c=='American Indian or Alaska Native'){
                        patient.raceCode='1002-5';
                    }else if(patientObj.Race__c=='Asian'){
                        patient.raceCode='2028-9';
                    }else if(patientObj.Race__c=='Native Hawaiian or Other Pacific Islander'){
                        patient.raceCode='2076-8';
                    }else{
                        patient.raceCode='N/A';
                    }*/
                     patient.raceCode=(raceMap.get(patientObj.Race__c)==null?'N/A':raceMap.get(patientObj.Race__c));
                     
                    if(stringList.size()>1){
                        cdapackage.race[] additionalrace = new cdapackage.race[stringList.size()-1];
                        for(Integer i=1; i<stringList.size();i++){
                            cdapackage.race r = new cdapackage.race();
                            r.raceValue = stringList[i];
                            /*
                            if(r.raceValue=='White'){
                                r.raceCode='2106-3';
                            }else if(r.raceValue=='Black or African American'){
                                r.raceCode='2054-5';
                            }else if(r.raceValue=='American Indian or Alaska Native'){
                                r.raceCode='1002-5';
                            }else if(r.raceValue=='Asian'){
                                r.raceCode='2028-9';
                            }else if(r.raceValue=='Native Hawaiian or Other Pacific Islander'){
                                r.raceCode='2076-8';
                            }else{
                                r.raceCode='N/A';
                            }*/
                            r.raceCode=(raceMap.get(r.raceValue)==null?'N/A':raceMap.get(r.raceValue));
                            additionalrace[i-1] = r;
                        }
                        patient.additionalrace = additionalrace;
                    }
                }
                
                Map<String,String> ethinicityMap = new Map<String,String>();
                ethinicityMap.put('Not Hispanic or Latino','2186-5');
                ethinicityMap.put('Hispanic or Latino','2135-2');
            
                if(patientSet.contains('Ethnicity__c')) {
                    patient.ethinicity=patientObj.Ethnicity__c;
                    /*
                    if(patientObj.Ethnicity__c=='Not Hispanic or Latino'){
                        patient.ethinicityCode='2186-5';
                    }else if(patientObj.Ethnicity__c=='Hispanic or Latino'){
                        patient.ethinicityCode='2135-2';
                    }else{
                        patient.ethinicityCode='N/A';
                    }*/
                    patient.ethinicityCode=(ethinicityMap.get(patientObj.Ethnicity__c)==null?'N/A':ethinicityMap.get(patientObj.Ethnicity__c));
                }
                

                
            }
            
            procedure.studyIdentifier=trialPatientObj.Trial_Id__c ;
            procedure.activityStatus='Active';
            procedure.activityStatusCode='55561003';
            //procedure.availableQuantity='1';
            //procedure.initialQuantity='1';
            procedure.barcode='1098';//
            //procedure.collectionProtocolShortTitle=trialPatientObj.Trial_Id__r.Name;
            //procedure.collectionProtocolTitle=trialPatientObj.Trial_Id__r.Name;
            //procedure.specimenCharacteristicsSide='Right';
            //procedure.specimenCharacteristicsSideCode='24028007';
            //procedure.specimenCharacteristicsSite='breast';
            //procedure.specimenType='Serum Specimen';
            //procedure.specimenTypeCode='119364003';
            
            procedure.collectionProtocolShortTitle='Venipuncture';
            procedure.collectionProtocolTitle='Venipuncture';
            procedure.specimenCharacteristicsSide='Not Specified';
            procedure.specimenCharacteristicsSideCode='397206002';
            procedure.specimenCharacteristicsSite='Not Specified';
            procedure.specimenClass='Fluid';
            procedure.specimenClassCode='258442002';
            
            //procedure.studyCalendarEventTimePoint=bloodSpecimen.Time_Point__c;
            if(bloodSpecimen.CollectionDate__c!=null){
                procedure.collectionDate =String.valueOf(bloodSpecimen.CollectionDate__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }
            
            //Retrive all Specimen id for a time point and trial patient id which have been successfully intergated
            Set<String> oldSpecimenIdSet = new Set<String>();
            List<BloodSpecimenInfo__c> previousSpecimenList = [Select b.Specimen_ID__c From BloodSpecimenInfo__c b where b.Specimen_ID__c !=null and b.Is_Integration_Success__c=true and b.BloodSpecimenForm__c !=:bloodSpecimen.Id and Shipped__c='Yes' and b.BloodSpecimenForm__r.Time_Point__c=:bloodSpecimen.Time_Point__c and b.BloodSpecimenForm__r.TrialPatient__c=:trialPatientObj.Id];
            for(BloodSpecimenInfo__c b :previousSpecimenList){
                oldSpecimenIdSet.add(b.Specimen_ID__c);
            }
            
            Map<String,String> timepointMap = new Map<String,String>();
            timepointMap.put('Pre-treatment','0');
            timepointMap.put('Early treatment','1');
            timepointMap.put('Inter-regimen','2');
            timepointMap.put('Pre-Surgery','3');
           
            
            List<BloodSpecimenInfo__c> specimenList = [Select b.pg_bloodspecimeninfo_Id__c, b.Specimen_ID__c, b.Shipped__c, b.Reason_samples_not_shipped__c, b.Other_Reason_samples_not_shipped__c, b.Name, b.Id From BloodSpecimenInfo__c b where b.Specimen_ID__c !=null and b.BloodSpecimenForm__c =:bloodSpecimen.Id];
            
            List<cdapackage.specimen> specimenUpdateList = new List<cdapackage.specimen>();
            List<cdapackage.specimen> specimenAddList = new List<cdapackage.specimen>();
        
            //specimenArray = new cdapackage.specimen[specimenList.size()];
            for(Integer i=0;I<specimenList.size();i++){
                BloodSpecimenInfo__c specimen = specimenList[i];
                cdapackage.specimen sp= new cdapackage.specimen();
                sp.specimenID = specimen.Specimen_ID__c;
                List<String> aList = specimen.Name.split('#');
                String aStr = aList[0];
                sp.specimenDisplayName=aStr;
                if(aStr.contains('Serum')){
                    sp.specimenCode ='119364003';
                    sp.specimenDisplayName ='Serum';
                    sp.availableQuantity='1';  
                }else if(aStr.contains('Plasma')){
                    sp.specimenCode ='119361006';
                    sp.specimenDisplayName ='Plasma'; 
                    sp.availableQuantity='1';
                
                }else if(aStr.contains('Buffy coat')){
                    sp.specimenCode =''; 
                    sp.specimenDisplayName ='Buffy Coat'; 
                    sp.availableQuantity='0.2';
                }
                //sp.availableQuantity='155';
                sp.availableQuantityUnit='mL';    
                sp.initialQuantity='1';
                sp.initialQuantityUnit='mL';
                /*
                if(bloodSpecimen.Time_Point__c=='Pre-treatment'){
                    sp.studyCalendarEventTimePoint='0';
                }else if(bloodSpecimen.Time_Point__c=='Early Treatment'){
                    sp.studyCalendarEventTimePoint='1';
                }else if(bloodSpecimen.Time_Point__c=='Inter-Regimen'){
                    sp.studyCalendarEventTimePoint='2';
                }else if(bloodSpecimen.Time_Point__c=='Pre-Treatment Re-Biopsy'){
                    sp.studyCalendarEventTimePoint='3';
                }else if(bloodSpecimen.Time_Point__c=='Surgery'){
                    sp.studyCalendarEventTimePoint='4';
                }
                
                if(bloodSpecimen2.Time_Point__c=='Pre-treatment'){
                    sp.studyCalendarEventTimePoint='0';
                }else if(bloodSpecimen2.Time_Point__c=='Early treatment'){
                    sp.studyCalendarEventTimePoint='1';
                }else if(bloodSpecimen2.Time_Point__c=='Inter-regimen'){
                    sp.studyCalendarEventTimePoint='2';
                }else if(bloodSpecimen2.Time_Point__c=='Pre-Surgery'){
                    sp.studyCalendarEventTimePoint='3';
                }*/
                sp.studyCalendarEventTimePoint=timepointMap.get(bloodSpecimen.Time_Point__c);
                
                //sp.studyCalendarEventTimePoint;
                sp.studyCalendarEventTimePointUnit='d';
                //specimenArray[i]=sp;
                if(oldSpecimenIdSet.contains(specimen.Specimen_ID__c)){
                    specimenUpdateList.add(sp);
                }else{
                    specimenAddList.add(sp);
                }
            }
            
                    
            try{
                cdapackage.response res = new cdapackage.response();
                if(Test.isRunningTest()) {
                    res.status = 'SUCCESS';
                    res.description='success message';
                    res.code = 'SUCCESS';
                }else{
                    //res = ihub.submitBioCDA(clinicalDoc,author,patient,procedure,specimenArray, guidanceArray,xmlType);
                    if(!specimenAddList.isEmpty()){
                        specimenArray = new cdapackage.specimen[specimenAddList.size()];
                        for(Integer i=0; i<specimenAddList.size();i++){
                            specimenArray[i]=specimenAddList[i];
                        }
                        clinicalDoc.title = 'Create Biospecimen';
                        res = serviceConnector.ihub.submitBioCDA(clinicalDoc,author,patient,procedure,specimenArray, guidanceArray,xmlType);
                    }
                    
                    if(!specimenUpdateList.isEmpty()){
                        specimenArray = new cdapackage.specimen[specimenUpdateList.size()];
                        for(Integer i=0; i<specimenUpdateList.size();i++){
                            specimenArray[i]=specimenUpdateList[i];
                        }
                        clinicalDoc.title = 'Update Biospecimen';
                        res = serviceConnector.ihub.submitBioCDA(clinicalDoc,author,patient,procedure,specimenArray, guidanceArray,xmlType);
                    }
                   
                }
                
                if(res.status=='SUCCESS'){
                    updateFailedRegistration(failedRegistrationId,res.description,'Success',false,res.caXchangeId,res.id);
                    
                    for(BloodSpecimenInfo__c specimen : specimenList){
                        specimen.Is_Integration_Success__c =true;
                        specimen.Integration_Timestamp__c = System.now();       
                    }
                    update specimenList;
            
                }else{
                    updateFailedRegistration(failedRegistrationId,res.description,'Failure',true,res.caXchangeId,res.id);
                }
                
                
                
            }catch(Exception e){
                System.debug(e);
                
                
                updateFailedRegistration(failedRegistrationId,e.getMessage(),'Failure',true,null,null);
                
            }
       }
        
    }
    
    public void retryBloodSpecimenConsentSubmission(ID failedRegistrationId, ID trialId, ID patientId, String bsId ){
        
        List<BloodSpecimenForm__c> lstBSF = [Select b.TrialPatient__r.Trial_Id__r.Name,b.TrialPatient__r.Trial_Id__c,b.TrialPatient__r.Subject_Id__c,b.Effective_Time__c,b.TrialPatient__c, b.TrialPatient__r.Name, b.CRF__c,b.TrialPatient__r.Patient_Id__c, b.Time_Point__c, b.Status__c, b.Reason_all_samples_not_collected__c, b.Phase__c, b.Other_Reason_samples_not_shipped__c, b.Name, b.Id, b.Contented_specimen_outside_study__c, b.Consented_to_use_specimen_study__c, b.CompletedDate__c, b.CollectionDate__c, (Select Name, BloodSpecimenForm__c, Shipped__c, Reason_samples_not_shipped__c, Other_Reason_samples_not_shipped__c, Specimen_ID__c From BloodSpecimenInfo__r) From BloodSpecimenForm__c b where Id = :bsId];
        if(!lstBSF.isEmpty()) {
            BloodSpecimenForm__c bloodSpecimen= lstBSF[0];
            
            CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='BloodSpecimenForm__c' limit 1]; 
             //To fetch admin xml configuration
            List<XML_Configuration__c> xmlPatientList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'Patient_Custom__c'];
            //List<XML_Configuration__c> xmlTissueSpecimenList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'BloodSpecimenForm__c'];
            Set<String> patientSet = new Set<String>();
            for(XML_Configuration__c x: xmlPatientList){
                patientSet.add(x.Field_API_Name__c);
            }
            
            ExternalServiceConnector serviceConnector = new ExternalServiceConnector('iHub');
            /*cdapackage.CDAGeneratorPort ihub = new cdapackage.CDAGeneratorPort();
            External_Connection_Settings__c iHubEndpoint = External_Connection_Settings__c.getInstance('iHub');
            if (iHubEndpoint !=null){
                ihub.endpoint_x=iHubEndpoint.URL__c;
                ihub.timeout_x=iHubEndpoint.Timeout__c.intValue();
            }
            //else{
            //    ihub.endpoint_x = 'http://ec2-23-20-103-202.compute-1.amazonaws.com:12020/services/CDAGenerator';
            //    ihub.timeout_x = 120000;
            //}*/
            cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
            cdapackage.author author = new cdapackage.author();
            cdapackage.patient patient = new cdapackage.patient();
            String xmlType = 'CDA';
            author.idExtension = UserInfo.getUserName();
            
            clinicalDoc.id=bloodSpecimen.id;
            clinicalDoc.title = 'Register Consent';
            if(bloodSpecimen.Effective_Time__c!=null){
                clinicalDoc.effectiveTime=String.valueOf(bloodSpecimen.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }
            
            TrialPatient__c trialPatientObj;
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name,Trial_Id__c,Subject_Id__c ,Site__c,Site__r.Name from TrialPatient__c where Patient_Id__c = :patientId and Trial_Id__c =:trialId];
            if(!lstTrialPatient.isEmpty()){
                trialPatientObj = lstTrialPatient[0];
            } 
            String siteCode = trialPatientObj.Site__r.Name;
            if(trialPatientObj.Site__r.Name!=null){
                Integer index1 = trialPatientObj.Site__r.Name.indexOf('(');
                Integer index2 = trialPatientObj.Site__r.Name.indexOf(')');
                if(index1>-1 && index2>-1 && index2>index1 ){
                    siteCode = trialPatientObj.Site__r.Name.substring(index1+1,index2).trim();
                }
            }
            clinicalDoc.siteIdentifier= siteCode;
            //clinicalDoc.siteIdentifier= trialPatientObj.Site__r.Name;
            clinicalDoc.siteIdRoot='2.16.840.1.113883.3.26.1.7';      
            clinicalDoc.studyId=trialPatientObj.Trial_Id__r.Name ;
            clinicalDoc.studyIdRoot='2.16.840.1.113883.3.26.1.7' ;
            clinicalDoc.studySubjectIdentifier=trialPatientObj.Subject_Id__c;
             
            List<Patient_Custom__c> patientObjList = [Select  p.Name,p.mrn__c,p.Birthdate__c, p.Zip__c, p.SSN__c, p.Race__c, p.Middle_Name__c, p.Medical_Record_Number__c, p.Last_Name__c, p.Institution__c, p.Institute_Text__c, p.Initials__c, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.Country_of_Birth__c From Patient_Custom__c p where Id =:patientId limit 1];
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
                    Map<String,String> raceMap = new Map<String,String>();
                    raceMap.put('White','2106-3');
                    raceMap.put('Black or African American','2054-5');
                    raceMap.put('American Indian or Alaska Native','1002-5');
                    raceMap.put('Asian','2028-9');
                    raceMap.put('Native Hawaiian or Pacific Islander','2076-8');
                
                    patient.race=patientObj.Race__c;
                    /*
                    if(patientObj.Race__c=='White'){
                        patient.raceCode='2106-3';
                    }else if(patientObj.Race__c=='Black or African American'){
                        patient.raceCode='2054-5';
                    }else if(patientObj.Race__c=='American Indian or Alaska Native'){
                        patient.raceCode='1002-5';
                    }else if(patientObj.Race__c=='Asian'){
                        patient.raceCode='2028-9';
                    }else if(patientObj.Race__c=='Native Hawaiian or Other Pacific Islander'){
                        patient.raceCode='2076-8';
                    }else{
                        patient.raceCode='N/A';
                    }*/
                    patient.raceCode=(raceMap.get(patientObj.Race__c)==null?'N/A':raceMap.get(patientObj.Race__c));
                    
                    if(stringList.size()>1){
                        cdapackage.race[] additionalrace = new cdapackage.race[stringList.size()-1];
                        for(Integer i=1; i<stringList.size();i++){
                            cdapackage.race r = new cdapackage.race();
                            r.raceValue = stringList[i];
                            /*
                            if(r.raceValue=='White'){
                                r.raceCode='2106-3';
                            }else if(r.raceValue=='Black or African American'){
                                r.raceCode='2054-5';
                            }else if(r.raceValue=='American Indian or Alaska Native'){
                                r.raceCode='1002-5';
                            }else if(r.raceValue=='Asian'){
                                r.raceCode='2028-9';
                            }else if(r.raceValue=='Native Hawaiian or Other Pacific Islander'){
                                r.raceCode='2076-8';
                            }else{
                                r.raceCode='N/A';
                            }*/
                            r.raceCode=(raceMap.get(r.raceValue)==null?'N/A':raceMap.get(r.raceValue));
                            additionalrace[i-1] = r;
                        }
                        patient.additionalrace = additionalrace;
                    }
                }
                
                Map<String,String> ethinicityMap = new Map<String,String>();
                ethinicityMap.put('Not Hispanic or Latino','2186-5');
                ethinicityMap.put('Hispanic or Latino','2135-2');
            
                if(patientSet.contains('Ethnicity__c')) {
                    patient.ethinicity=patientObj.Ethnicity__c;
                    /*
                    if(patientObj.Ethnicity__c=='Not Hispanic or Latino'){
                        patient.ethinicityCode='2186-5';
                    }else if(patientObj.Ethnicity__c=='Hispanic or Latino'){
                        patient.ethinicityCode='2135-2';
                    }else{
                        patient.ethinicityCode='N/A';
                    }*/
                    patient.ethinicityCode=(ethinicityMap.get(patientObj.Ethnicity__c)==null?'N/A':ethinicityMap.get(patientObj.Ethnicity__c));
                }

            }

            /*
            Boolean isChangeInConsent = false;
            cdapackage.consent consent = new cdapackage.consent();
            //List<TissueSpecimenDetail__c> lstTS = [Select t.CompletedDate__c,t.TrialPatient__c, t.TrialPatient__r.Patient_Id__c, t.TrialPatient__r.Name, t.Time_Point__c, t.SystemModstamp, t.Status__c, t.RecordTypeId, t.Reason_all_samples_not_collected__c, t.ProcedureDate__c, t.Phase__c, t.Patient__c, t.PatientConsentedStudy__c, t.PatientConsentedOutsideStudy__c, t.OwnerId, t.Other_Reason_not_all_samples_collected__c, t.Other_Guidance_Method__c, t.NumberOfSamplesCollected__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Guidance_Method_s__c, t.Effective_Time__c, t.CreatedById, t.CRFId__c From TissueSpecimenDetail__c t where Patient__c = :patientId and TrialPatient__c=:trialPatientId and Time_Point__c=:bloodSpecimen.Time_Point__c  order by CompletedDate__c desc ];
            List<BloodSpecimenForm__c> lstBSF2 = [Select b.Effective_Time__c,b.TrialPatient__c, b.TrialPatient__r.Name, b.CRF__c,b.TrialPatient__r.Patient_Id__c, b.Time_Point__c, b.Status__c, b.Reason_all_samples_not_collected__c, b.Phase__c, b.Other_Reason_samples_not_shipped__c, b.Name, b.Id, b.Contented_specimen_outside_study__c, b.Consented_to_use_specimen_study__c, b.CompletedDate__c, b.CollectionDate__c, (Select Name, BloodSpecimenForm__c, Shipped__c, Reason_samples_not_shipped__c, Other_Reason_samples_not_shipped__c, Specimen_ID__c From BloodSpecimenInfo__r) From BloodSpecimenForm__c b where TrialPatient__c=:bloodSpecimen.TrialPatient__c and Time_Point__c=:bloodSpecimen.Time_Point__c and Id !=:bsId order by CompletedDate__c desc];
                    
            if(lstBSF2.size()==0 ){
                //BloodSpecimenForm__c ts = lstBSF[0];
                BloodSpecimenForm__c ts = bloodSpecimen;
                if(ts.Consented_to_use_specimen_study__c==True ||ts.Contented_specimen_outside_study__c==True){
                    consent.consentDateTime=String.valueOf(ts.CompletedDate__c);
                    consent.tier1Response=(ts.Consented_to_use_specimen_study__c==True?'Yes':'No');
                    consent.tier1ResponseCode=(ts.Consented_to_use_specimen_study__c==True?'399174000':'399250008');
                    consent.tier2Response=(ts.Contented_specimen_outside_study__c==True?'Yes':'No');         
                    consent.tier2ResponseCode=(ts.Contented_specimen_outside_study__c==True?'399174000':'399250008');
                    isChangeInConsent = true;
                }
            } else if(lstBSF2.size()>0 ){
                //BloodSpecimenForm__c ts1 = lstBSF[0];
                BloodSpecimenForm__c ts1 = bloodSpecimen;
                BloodSpecimenForm__c ts2 = lstBSF2[0];
                consent.consentDateTime=String.valueOf(ts1.CompletedDate__c);
                if(ts1.Consented_to_use_specimen_study__c==True && ts2.Consented_to_use_specimen_study__c==False){
                    consent.tier1Response='Yes';
                    consent.tier1ResponseCode='399174000';
                    isChangeInConsent = true;
                }else if(ts1.Consented_to_use_specimen_study__c==False && ts2.Consented_to_use_specimen_study__c==True){
                    consent.tier1Response='Withdrawn';
                    consent.tier1ResponseCode='185924006';
                    isChangeInConsent = true;
                }else if(ts1.Consented_to_use_specimen_study__c==False && ts2.Consented_to_use_specimen_study__c==False){
                    consent.tier1Response='No';
                    consent.tier1ResponseCode='399250008';
                }
                
                if(ts1.Contented_specimen_outside_study__c==True && ts2.Contented_specimen_outside_study__c==False){
                    consent.tier2Response='Yes';
                    consent.tier2ResponseCode='399174000';
                    isChangeInConsent = true;
                }else if(ts1.Contented_specimen_outside_study__c==False && ts2.Contented_specimen_outside_study__c==True){
                    consent.tier2Response='Withdrawn';
                    consent.tier2ResponseCode='185924006';
                    isChangeInConsent = true;
                }else if(ts1.Contented_specimen_outside_study__c==False && ts2.Contented_specimen_outside_study__c==False){
                    consent.tier2Response='No';
                    consent.tier2ResponseCode='399250008';
                }
                
            }*/
            
            cdapackage.consent consent = new cdapackage.consent();
            cdapackage.consent[] consentArray = null;
            
            consent.consentDateTime=String.valueOf(bloodSpecimen.CreatedDate).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            consent.tier1Response=(bloodSpecimen.Consented_to_use_specimen_study__c==True?'Yes':'No');
            consent.tier1ResponseCode=(bloodSpecimen.Consented_to_use_specimen_study__c==True?'373066001':'373067005');
            consent.tier2Response=(bloodSpecimen.Contented_specimen_outside_study__c==True?'Yes':'No');         
            consent.tier2ResponseCode=(bloodSpecimen.Contented_specimen_outside_study__c==True?'373066001':'373067005');  
           
            //if(isChangeInConsent){
                
            List<BloodSpecimenInfo__c> specimenList = [Select b.pg_bloodspecimeninfo_Id__c, b.Specimen_ID__c, b.Shipped__c, b.Reason_samples_not_shipped__c, b.Other_Reason_samples_not_shipped__c, b.Name, b.Id From BloodSpecimenInfo__c b where b.Specimen_ID__c !=null and b.BloodSpecimenForm__c =:bsId];
    
            consentArray = new cdapackage.consent[specimenList.size()]; 
            for(Integer i=0;I<specimenList.size();i++){
                BloodSpecimenInfo__c specimen = specimenList[i];
                cdapackage.consent consent1 = consent.clone();
                consent1.cdmsid = specimen.Specimen_ID__c;
                consentArray[i]=consent1;
            }
            try{
               
                cdapackage.response res = new cdapackage.response();
                if(Test.isRunningTest()) {
                    res.status = 'SUCCESS';
                    res.description='success message';
                    res.code = 'SUCCESS';
                }else{
                    
                   res = serviceConnector.ihub.submitConsentCDA(clinicalDoc,author,patient,consentArray ,xmlType);
                   
                }
                
                if(res.status=='SUCCESS'){
                    updateFailedRegistration(failedRegistrationId,res.description,'Success',false,res.caXchangeId,res.id);
                }else{
                    updateFailedRegistration(failedRegistrationId,res.description,'Failure',true,res.caXchangeId,res.id);
                }
                
                
            }catch(Exception e){
                System.debug(e);
                
                updateFailedRegistration(failedRegistrationId,e.getMessage(),'Failure',true,null,null);
                
            }
            //}
            
        }
        
    }
    public void retryAdverseEventSubmission(ID failedRegistrationId, ID trialId, ID patientId, String rId ){
        
        //CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='AE_Detail__c' limit 1];
        CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='Registration__c' limit 1];
        
        List<AE_Detail__c> lstAEF   = [select a.TrialPatient__r.Subject_Id__c,a.caAERS_report_filed__c, a.Visit_Date__c, a.CompletedDate__c, a.CRF__c, a.TrialPatient__c, a.SystemModstamp, a.Status__c, 
                    a.Patient_Hospitalized__c, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, 
                    a.Effective_Time__c, a.CreatedById, OriginalCRF__c/*, (Select Id, Name, AE_Detail__c, AE_End_Date__c, Attribution__c, 
                    Did_event_required_hospitalization__c, Did_event_result_in_death__c, Did_the_investigator_find_event_unusual__c, 
                    Grade__c, Onset_Date__c, Patient_Complaint__c, Resolved__c, Result_conginental_abnormality_defect__c, 
                    Result_persistent_significant_disability__c, SAE__c, Was_event_life_threatning__c, Symptom_Status__c, Symptom_Masters__c, Toxicity_Master__c,  Toxicity_Status__c   From Toxicities__r)*/
                    From AE_Detail__c a where Id =: rId];
                    
       List<Toxicity__c> allToxicityList= [Select Id, Name, AE_Detail__c, AE_End_Date__c, Attribution__c, 
                    Did_event_required_hospitalization__c, Did_event_result_in_death__c, Did_the_investigator_find_event_unusual__c, 
                    Grade__c, Onset_Date__c, Patient_Complaint__c, Resolved__c, Result_conginental_abnormality_defect__c, 
                    Result_persistent_significant_disability__c, SAE__c, Was_event_life_threatning__c, Symptom_Status__c, Symptom_Masters__c, Toxicity_Master__c,  Toxicity_Status__c   From Toxicity__c where TrialPatient__r.Patient_Id__c=:patientId and TrialPatient__r.Trial_Id__c=:trialId];
        
        
        if(!lstAEF.isEmpty()){
            AE_Detail__c AEObj = lstAEF[0];
            //To fetch admin xml configuration
            List<XML_Configuration__c> xmlPatientList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'Patient_Custom__c'];
            List<XML_Configuration__c> aeList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'AE_Detail__c'];
            Set<String> patientSet = new Set<String>();
            for(XML_Configuration__c x: xmlPatientList){
                patientSet.add(x.Field_API_Name__c);
            }
            Set<String> aeSet = new Set<String>();
            for(XML_Configuration__c x: aeList ){
                aeSet.add(x.Field_API_Name__c);
            }
            
            ExternalServiceConnector serviceConnector = new ExternalServiceConnector('iHub');
            /*cdapackage.CDAGeneratorPort ihub = new cdapackage.CDAGeneratorPort();
            External_Connection_Settings__c iHubEndpoint = External_Connection_Settings__c.getInstance('iHub');
            if (iHubEndpoint !=null){
                ihub.endpoint_x=iHubEndpoint.URL__c;
                ihub.timeout_x=iHubEndpoint.Timeout__c.intValue();
            }
            //else{
            //    ihub.endpoint_x = 'http://ec2-23-20-103-202.compute-1.amazonaws.com:12020/services/CDAGenerator';
            //    ihub.timeout_x = 120000;
            //}*/
            cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
            cdapackage.author author = new cdapackage.author();
            cdapackage.patient patient = new cdapackage.patient();
            cdapackage.procedure procedure = new cdapackage.procedure();
            cdapackage.guidanceMethod[] guidanceArray;// = new cdapackage.guidanceMethod[]{};
            String xmlType = 'CDA';
            author.idExtension = UserInfo.getUserName();
            
            clinicalDoc.id=AEObj.id;
            clinicalDoc.title = 'Create Or Update Adverse Events';
            if(AEObj.Effective_Time__c!=null){
                clinicalDoc.effectiveTime=String.valueOf(AEObj.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }
            
            TrialPatient__c trialPatientObj;
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name,Trial_Id__c,Subject_Id__c ,Site__c,Site__r.Name from TrialPatient__c where Patient_Id__c = :patientId and Trial_Id__c =:trialId];
            if(!lstTrialPatient.isEmpty()){
                trialPatientObj = lstTrialPatient[0];
            } 
            //clinicalDoc.siteIdentifier= trialPatientObj.Site__r.Name;
            String siteCode = trialPatientObj.Site__r.Name;
            if(trialPatientObj.Site__r.Name!=null){
                Integer index1 = trialPatientObj.Site__r.Name.indexOf('(');
                Integer index2 = trialPatientObj.Site__r.Name.indexOf(')');
                if(index1>-1 && index2>-1 && index2>index1 ){
                    siteCode = trialPatientObj.Site__r.Name.substring(index1+1,index2).trim();
                }
            }
            clinicalDoc.siteIdentifier= siteCode;
        
            clinicalDoc.siteIdRoot='2.16.840.1.113883.3.26.1.7';      
            clinicalDoc.studyId=trialPatientObj.Trial_Id__r.Name ;
            clinicalDoc.studyIdRoot='2.16.840.1.113883.3.26.1.7' ;
            clinicalDoc.studySubjectIdentifier=trialPatientObj.Subject_Id__c;
            
            
            List<Patient_Custom__c> patientObjList = [Select  p.Name,p.mrn__c,p.Birthdate__c, p.Zip__c, p.SSN__c, p.Race__c, p.Middle_Name__c, p.Medical_Record_Number__c, p.Last_Name__c, p.Institution__c, p.Institute_Text__c, p.Initials__c, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.Country_of_Birth__c From Patient_Custom__c p where Id =:patientId limit 1];
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
                    Map<String,String> raceMap = new Map<String,String>();
                    raceMap.put('White','2106-3');
                    raceMap.put('Black or African American','2054-5');
                    raceMap.put('American Indian or Alaska Native','1002-5');
                    raceMap.put('Asian','2028-9');
                    raceMap.put('Native Hawaiian or Pacific Islander','2076-8');
                
                    patient.race=patientObj.Race__c;
                    /*
                    if(patientObj.Race__c=='White'){
                        patient.raceCode='2106-3';
                    }else if(patientObj.Race__c=='Black or African American'){
                        patient.raceCode='2054-5';
                    }else if(patientObj.Race__c=='American Indian or Alaska Native'){
                        patient.raceCode='1002-5';
                    }else if(patientObj.Race__c=='Asian'){
                        patient.raceCode='2028-9';
                    }else if(patientObj.Race__c=='Native Hawaiian or Other Pacific Islander'){
                        patient.raceCode='2076-8';
                    }else{
                        patient.raceCode='N/A';
                    }*/
                    patient.raceCode=(raceMap.get(patientObj.Race__c)==null?'N/A':raceMap.get(patientObj.Race__c));
                    
                    if(stringList.size()>1){
                        cdapackage.race[] additionalrace = new cdapackage.race[stringList.size()-1];
                        for(Integer i=1; i<stringList.size();i++){
                            cdapackage.race r = new cdapackage.race();
                            r.raceValue = stringList[i];
                            /*
                            if(r.raceValue=='White'){
                                r.raceCode='2106-3';
                            }else if(r.raceValue=='Black or African American'){
                                r.raceCode='2054-5';
                            }else if(r.raceValue=='American Indian or Alaska Native'){
                                r.raceCode='1002-5';
                            }else if(r.raceValue=='Asian'){
                                r.raceCode='2028-9';
                            }else if(r.raceValue=='Native Hawaiian or Other Pacific Islander'){
                                r.raceCode='2076-8';
                            }else{
                                r.raceCode='N/A';
                            }*/
                            r.raceCode=(raceMap.get(r.raceValue)==null?'N/A':raceMap.get(r.raceValue));
                            additionalrace[i-1] = r;
                        }
                        patient.additionalrace = additionalrace;
                    }
                }
                Map<String,String> ethinicityMap = new Map<String,String>();
                ethinicityMap.put('Not Hispanic or Latino','2186-5');
                ethinicityMap.put('Hispanic or Latino','2135-2');
            
                if(patientSet.contains('Ethnicity__c')) {
                    patient.ethinicity=patientObj.Ethnicity__c;
                    /*
                    if(patientObj.Ethnicity__c=='Not Hispanic or Latino'){
                        patient.ethinicityCode='2186-5';
                    }else if(patientObj.Ethnicity__c=='Hispanic or Latino'){
                        patient.ethinicityCode='2135-2';
                    }else{
                        patient.ethinicityCode='N/A';
                    }*/
                    patient.ethinicityCode=(ethinicityMap.get(patientObj.Ethnicity__c)==null?'N/A':ethinicityMap.get(patientObj.Ethnicity__c));
                }

                    
                
            }
            
            String treatmentArmName;
            List<ArmPatient__c> armPatientList = [Select a.assignedToPatient__c, a.TrialPatient__r.Patient_Id__c, a.TrialPatient__r.Name, a.TrialPatient__c, a.Name, a.Arm_Id__r.Name, a.Arm_Id__c From ArmPatient__c a where TrialPatient__c =:trialPatientObj.Id and assignedToPatient__c = true];
            for(ArmPatient__c armPatientObj : armPatientList) {
                //treatmentArmId = armPatientObj.Arm_Id__c;
                treatmentArmName = armPatientObj.Arm_Id__r.Name;
                break;
            }
            
            Map<String,String> toxicityCodeMap = new Map<String,String>();
            List<CTCAECodeMaster__c> codeMasterList = [Select Toxicity_Master__r.Toxicity_Name__c, Code__c From CTCAECodeMaster__c where Toxicity_Master__r.Toxicity_Name__c !=null];
            for(CTCAECodeMaster__c codeMaster : codeMasterList){
                toxicityCodeMap.put(codeMaster.Toxicity_Master__r.Toxicity_Name__c,codeMaster.Code__c);
            }
            
            Map<String,String> gradeMap = new Map<String,String>();
            gradeMap.put('1','CTCAE Grade 1');
            gradeMap.put('2','CTCAE Grade 2');
            gradeMap.put('3','CTCAE Grade 3');
            gradeMap.put('4','CTCAE Grade 4');
            gradeMap.put('5','CTCAE Grade 5');
            
            Map<String,String> attributionMap = new Map<String,String>();
            attributionMap.put('1 - Unrelated','N/A');
            attributionMap.put('2 - Unlikely','N/A');
            attributionMap.put('3 - Possible','371930009');
            attributionMap.put('4 - Probable','N/A');
            attributionMap.put('5 - Definite','255545003');
            
            //cdapackage.adverseEvent[] adverseEventArray = new cdapackage.adverseEvent[AEObj.Toxicities__r.size()];
            cdapackage.adverseEvent[] adverseEventArray = new cdapackage.adverseEvent[allToxicityList.size()];
            //for(Integer i=0;I< AEObj.Toxicities__r.size();i++){
            for(Integer i=0;I< allToxicityList.size();i++){
                //Toxicity__c tox=AEObj.Toxicities__r[i];
                Toxicity__c tox=allToxicityList[i];
                cdapackage.adverseEvent ae = new cdapackage.adverseEvent();
                
                ae.id= tox.Id;
                
                //if(tox.AE_End_Date__c!=null){
                //    ae.reportingPeriodEndDate=String.valueOf(tox.AE_End_Date__c).replaceAll('-','').replaceAll(' ','');
                //}
                //ae.grade = tox.Grade__c;
                if(tox.Grade__c!=null){
                    String s = tox.Grade__c.split('-')[0].trim();
                    /*
                    if(S=='1'){
                        ae.grade='CTCAE Grade 1';
                    }else if(S=='2'){
                        ae.grade='CTCAE Grade 2';
                    }else if(S=='3'){
                        ae.grade='CTCAE Grade 3';
                    }else if(S=='4'){
                        ae.grade='CTCAE Grade 4';
                    }else if(S=='5'){
                        ae.grade='CTCAE Grade 5';
                    }*/
                    ae.grade=gradeMap.get(s);
                }
                //ae.attribution=tox.Attribution__c;
                if(tox.Attribution__c!=null){
                    ae.attribution=tox.Attribution__c.split('-')[1].trim();
                }
                /*
                if(tox.Attribution__c=='1 - Unrelated'){
                    ae.attributionCode='N/A';
                }else if(tox.Attribution__c=='2 - Unlikely'){
                    ae.attributionCode='N/A';
                }else if(tox.Attribution__c=='3 - Possible'){
                    ae.attributionCode='371930009';
                }else if(tox.Attribution__c=='4 - Probable'){
                    ae.attributionCode='N/A';
                }else if(tox.Attribution__c=='5 - Definite'){
                    ae.attributionCode='255545003';
                }else{
                    ae.attributionCode='';
                }*/
                ae.attributionCode=(attributionMap.get(tox.Attribution__c)==null?'':attributionMap.get(tox.Attribution__c));
               
                
                
                //ae.onsetDate =String.valueOf(tox.Onset_Date__c);
                if(tox.Onset_Date__c!=null){
                    ae.onsetDate=String.valueOf(tox.Onset_Date__c).replaceAll('-','').replaceAll(' ','');
                }
                 
               
                ae.groupid = '36e3e930-7b14-11db-9fe1-0800200c9a66';
                ae.reportingPeriodStartDate = '';
                ae.reportingPeriodEndDate='';
                //ae.resolutionDate ='';
                if(tox.AE_End_Date__c!=null){
                    ae.resolutionDate=String.valueOf(tox.AE_End_Date__c).replaceAll('-','').replaceAll(' ','');
                }else{
                    ae.resolutionDate='';
                }
                
                ae.adversereaction=tox.Name;
                ae.adversereactionCode=toxicityCodeMap.get(tox.Name);
                ae.verbatim=tox.Patient_Complaint__c;
                
                if(tox.Was_event_life_threatning__c){
                    ae.seriousReason='Is life threatening';
                    ae.seriousReasonCode='440181000';
                }else if(tox.Did_event_result_in_death__c){
                    ae.seriousReason='Results in death';
                    ae.seriousReasonCode='405535005';
                }else if(tox.Did_event_required_hospitalization__c){
                    ae.seriousReason='Requires inpatient hospitalization or prolongation of existing hospitalization';
                    ae.seriousReasonCode='308540004';
                }else if(tox.Did_the_investigator_find_event_unusual__c){
                    ae.seriousReason='Unusual event';
                    ae.seriousReasonCode='NA';
                }else if(tox.Result_conginental_abnormality_defect__c){
                    ae.seriousReason='Is a congenital abnormality/birth defect';
                    ae.seriousReasonCode='66091009';
                }else if(tox.Result_persistent_significant_disability__c){
                    ae.seriousReason='Results in persistent or significant incapacity or substantial disruption of the ability to conduct normal life functions';
                    ae.seriousReasonCode='405532008';
                }
                
                //ae.assignedTreatment='TAC12';
               // ae.assignedTreatment=treatmentArmName;
                if(treatmentArmName!=null){
                    ae.assignedTreatment=treatmentArmName;
                }else{
                    ae.assignedTreatment='Screening';
                }
                
                ae.eventtypecode='59037007';
                ae.eventtypename='drug intolerance';
           
                
                adverseEventArray[i] = ae;
            }
            
                    
            try{
                cdapackage.response res = new cdapackage.response();
                if(Test.isRunningTest()) {
                    res.status = 'SUCCESS';
                    res.description='success message';
                    res.code = 'SUCCESS';
                }else{
                    
                   res = serviceConnector.ihub.submitAECDA(clinicalDoc ,author,patient,adverseEventArray ,xmlType );

                }
               
                if(res.status=='SUCCESS'){
                    updateFailedRegistration(failedRegistrationId,res.description,'Success',false,res.caXchangeId,res.id);
                }else{
                    updateFailedRegistration(failedRegistrationId,res.description,'Failure',true,res.caXchangeId,res.id);
                }
                
                
            }catch(Exception e){
                System.debug(e);
                
                updateFailedRegistration(failedRegistrationId,e.getMessage(),'Failure',true,null,null);
                
            }
        }
               
    }
    
    /*
    public void retryTrialSummaryNoteSubmission(ID failedRegistrationId, ID trialId, ID patientId, String rId ){
        //CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='AE_Detail__c']; 
        CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='Registration__c' limit 1]; 
        
        //To fetch admin xml configuration
        List<XML_Configuration__c> xmlPatientList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'Patient_Custom__c'];
        //List<XML_Configuration__c> aeList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'AE_Detail__c'];
        Set<String> patientSet = new Set<String>();
        for(XML_Configuration__c x: xmlPatientList){
            patientSet.add(x.Field_API_Name__c);
        }
        //Set<String> aeSet = new Set<String>();
        //for(XML_Configuration__c x: aeList ){
        //    aeSet.add(x.Field_API_Name__c);
        //} 
       
        
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
        cdapackage.procedure procedure = new cdapackage.procedure();
        cdapackage.guidanceMethod[] guidanceArray;// = new cdapackage.guidanceMethod[]{};
        String xmlType = 'CDA';
        author.idExtension = UserInfo.getUserName();
        
        List<AE_Detail__c> adverseEventObjList = [select a.caAERS_report_filed__c, a.Visit_Date__c, a.CompletedDate__c, a.CRF__c, a.TrialPatient__c, a.SystemModstamp, a.Status__c, 
                    a.Patient_Hospitalized__c, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, 
                    a.Effective_Time__c, a.CreatedById, OriginalCRF__c, (Select Id, Name, AE_Detail__c, AE_End_Date__c, Attribution__c, 
                    Did_event_required_hospitalization__c, Did_event_result_in_death__c, Did_the_investigator_find_event_unusual__c, 
                    Grade__c, Onset_Date__c, Patient_Complaint__c, Resolved__c, Result_conginental_abnormality_defect__c, 
                    Result_persistent_significant_disability__c, SAE__c, Was_event_life_threatning__c, Symptom_Status__c, Symptom_Masters__c, Toxicity_Master__c,  Toxicity_Status__c   From Toxicities__r)
                    From AE_Detail__c a where TrialPatient__c=:rId  order by CreatedDate desc];
       
       
       
        TrialPatient__c trialPatientObj = null;
        //String patientId;
        List<TrialPatient__c> lstTrialPatient = [select Id,Name,Subject_Id__c,Site__c, Patient_Id__c, Trial_Id__c,Trial_Id__r.Name,Site__r.Name  from TrialPatient__c where Id = :rId ];
        if(!lstTrialPatient.IsEmpty()) {
            trialPatientObj = lstTrialPatient[0];
            //patientId = lstTrialPatient[0].Patient_Id__c;
        }
                    
        clinicalDoc.id=trialPatientObj.id;
        clinicalDoc.title = 'Trial Summary Note';
        //if(adverseEventObj.Effective_Time__c!=null){
            clinicalDoc.effectiveTime=String.valueOf(System.today()).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
        //}
        
        String siteCode = trialPatientObj.Site__r.Name;
        if(trialPatientObj.Site__r.Name!=null){
            Integer index1 = trialPatientObj.Site__r.Name.indexOf('(');
            Integer index2 = trialPatientObj.Site__r.Name.indexOf(')');
            if(index1>-1 && index2>-1 && index2>index1 ){
                siteCode = trialPatientObj.Site__r.Name.substring(index1+1,index2).trim();
            }
        }
        clinicalDoc.siteIdentifier= siteCode;
                
        //clinicalDoc.siteIdentifier= trialPatientObj.Site__r.Name;
        clinicalDoc.siteIdRoot='2.16.840.1.113883.3.26.1.7';      
        clinicalDoc.studyId=trialPatientObj.Trial_Id__r.Name ;
        clinicalDoc.studyIdRoot='2.16.840.1.113883.3.26.1.7' ;

        String siteId,studyId,mrn;
        String firstName,lastName;
        
        List<Patient_Custom__c> patientObjList = [Select  p.Name,p.mrn__c,p.Birthdate__c, p.Zip__c, p.SSN__c, p.Race__c, p.Middle_Name__c, p.Medical_Record_Number__c, p.Last_Name__c, p.Institution__c, p.Institute_Text__c, p.Initials__c, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.Country_of_Birth__c From Patient_Custom__c p where Id =:patientId limit 1];
        if(!patientObjList.isEmpty()) {
            Patient_Custom__c patientObj = patientObjList.get(0);
            firstName = patientObj.First_Name__c;
            lastName = patientObj.Last_Name__c;
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
                
                Map<String,String> raceMap = new Map<String,String>();
                raceMap.put('White','2106-3');
                raceMap.put('Black or African American','2054-5');
                raceMap.put('American Indian or Alaska Native','1002-5');
                raceMap.put('Asian','2028-9');
                raceMap.put('Native Hawaiian or Pacific Islander','2076-8');
                
                patient.race=patientObj.Race__c;
                
                patient.raceCode=(raceMap.get(patientObj.Race__c)==null?'N/A':raceMap.get(patientObj.Race__c));
                
                if(stringList.size()>1){
                        cdapackage.race[] additionalrace = new cdapackage.race[stringList.size()-1];
                        for(Integer i=1; i<stringList.size();i++){
                                cdapackage.race r = new cdapackage.race();
                                r.raceValue = stringList[i];
                               
                                r.raceCode=(raceMap.get(r.raceValue)==null?'N/A':raceMap.get(r.raceValue));
                                additionalrace[i-1] = r;
                        }
                        patient.additionalrace = additionalrace;
                }
            }
            
            Map<String,String> ethinicityMap = new Map<String,String>();
            ethinicityMap.put('Not Hispanic or Latino','2186-5');
            ethinicityMap.put('Hispanic or Latino','2135-2');
                
            if(patientSet.contains('Ethnicity__c')) {
                patient.ethinicity=patientObj.Ethnicity__c;
                
                patient.ethinicityCode=(ethinicityMap.get(patientObj.Ethnicity__c)==null?'N/A':ethinicityMap.get(patientObj.Ethnicity__c));
            }
            
            clinicalDoc.studySubjectIdentifier=trialPatientObj.Subject_Id__c;
            mrn=patientObj.Medical_Record_Number__c;
            
        }
        siteId = trialPatientObj.Site__c;
        studyId = trialPatientObj.Trial_Id__c;
        
        
        //if(adverseEventObjList.isEmpty()){
        //      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Adverse Event records not found for the patient '+firstName+' '+lastName+'('+patientId+').');
        //    ApexPages.addMessage(myMsg);
        //    return null;
        //}
        
        String treatmentArmName;
        List<ArmPatient__c> armPatientList = [Select a.assignedToPatient__c, a.TrialPatient__r.Patient_Id__c, a.TrialPatient__r.Name, a.TrialPatient__c, a.Name, a.Arm_Id__r.Name, a.Arm_Id__c From ArmPatient__c a where TrialPatient__c =:rId and assignedToPatient__c = true];
        
        if(!armPatientList.isEmpty()) {
            //treatmentArmId = armPatientObj.Arm_Id__c;
            ArmPatient__c armPatientObj = armPatientList[0];
            treatmentArmName = armPatientObj.Arm_Id__r.Name;
        }else{
            treatmentArmName='';
        }
        
        //if(armPatientList.isEmpty()){
        //      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Treatment Arm not found for the patient '+firstName+' '+lastName+'('+patientId+').');
        //    ApexPages.addMessage(myMsg);
         //   return null;
        //}
        
        Map<String,String> toxicityCodeMap = new Map<String,String>();
        List<CTCAECodeMaster__c> codeMasterList = [Select Toxicity_Master__r.Toxicity_Name__c, Code__c From CTCAECodeMaster__c where Toxicity_Master__r.Toxicity_Name__c !=null];
        for(CTCAECodeMaster__c codeMaster : codeMasterList){
            toxicityCodeMap.put(codeMaster.Toxicity_Master__r.Toxicity_Name__c,codeMaster.Code__c);
        }
        
        //if(codeMasterList.isEmpty()){
        //      ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Code Master List is empty. Cannot proceed..');
        //    ApexPages.addMessage(myMsg);
        //    return null;
        //}
        
        Integer size =0;
        for(AE_Detail__c adverseEventObj : adverseEventObjList){
            size += adverseEventObj.Toxicities__r.size();
        }
        cdapackage.adverseEvent[] adverseEventArray = new cdapackage.adverseEvent[size];
        Integer iCount =0;
        
        Map<String,String> gradeMap = new Map<String,String>();
        gradeMap.put('1','CTCAE Grade 1');
        gradeMap.put('2','CTCAE Grade 2');
        gradeMap.put('3','CTCAE Grade 3');
        gradeMap.put('4','CTCAE Grade 4');
        gradeMap.put('5','CTCAE Grade 5');
        
        Map<String,String> attributionMap = new Map<String,String>();
        attributionMap.put('1 - Unrelated','N/A');
        attributionMap.put('2 - Unlikely','N/A');
        attributionMap.put('3 - Possible','371930009');
        attributionMap.put('4 - Probable','N/A');
        attributionMap.put('5 - Definite','255545003');
       
            
        for(AE_Detail__c adverseEventObj : adverseEventObjList){
            for(Integer i=0;i< adverseEventObj.Toxicities__r.size();i++){
                Toxicity__c tox=adverseEventObj.Toxicities__r[i];
                cdapackage.adverseEvent ae = new cdapackage.adverseEvent();
                
                ae.id= tox.Id;
                
                //if(tox.AE_End_Date__c!=null){
                //    ae.reportingPeriodEndDate=String.valueOf(tox.AE_End_Date__c).replaceAll('-','').replaceAll(' ','');
                //}
                //ae.grade = tox.Grade__c;
                if(tox.Grade__c!=null){
                    String s = tox.Grade__c.split('-')[0].trim();
                    System.debug('Amit Grade ===='+s );
                    
                    ae.grade=gradeMap.get(s);
                }
                
                if(tox.Attribution__c!=null){
                  ae.attribution=tox.Attribution__c.split('-')[1].trim();
                }
                //ae.attribution=tox.Attribution__c;//rollback
                
                ae.attributionCode=(attributionMap.get(tox.Attribution__c)==null?'':attributionMap.get(tox.Attribution__c));
    
                if(tox.Onset_Date__c!=null){
                    ae.onsetDate=String.valueOf(tox.Onset_Date__c).replaceAll('-','').replaceAll(' ','');
                }
                 
               
                ae.groupid = '36e3e930-7b14-11db-9fe1-0800200c9a66';
                ae.reportingPeriodStartDate = '';
                ae.reportingPeriodEndDate='';
                if(tox.AE_End_Date__c!=null){
                    ae.resolutionDate=String.valueOf(tox.AE_End_Date__c).replaceAll('-','').replaceAll(' ','');
                }else{
                    ae.resolutionDate='';
                }
                
                ae.adversereaction=tox.Name;
                //ae.adversereactionCode='405532008';
                ae.adversereactionCode=toxicityCodeMap.get(tox.Name);
                
                ae.verbatim=tox.Patient_Complaint__c;
                
                if(tox.Was_event_life_threatning__c){
                    ae.seriousReason='Is life threatening';
                    ae.seriousReasonCode='440181000';
                }
                 if(tox.Did_event_result_in_death__c){
                    ae.seriousReason='Results in death';
                    ae.seriousReasonCode='405535005';
                }
                 if(tox.Did_event_required_hospitalization__c){
                    ae.seriousReason='Requires inpatient hospitalization or prolongation of existing hospitalization';
                    ae.seriousReasonCode='308540004';
                }
                 if(tox.Did_the_investigator_find_event_unusual__c){
                    ae.seriousReason='Unusual event';
                    ae.seriousReasonCode='N/A';
                }
                 if(tox.Result_conginental_abnormality_defect__c){
                    ae.seriousReason='Is a congenital abnormality/birth defect';
                    ae.seriousReasonCode='66091009';
                }
                 if(tox.Result_persistent_significant_disability__c){
                    ae.seriousReason='Results in persistent or significant incapacity or substantial disruption of the ability to conduct normal life functions';
                    ae.seriousReasonCode='405532008';
                }
                
                //ae.assignedTreatment='TAC1';
                //ae.assignedTreatment='Paclitaxel';
                ae.assignedTreatment=treatmentArmName;
                
               
                
                adverseEventArray[iCount] = ae;
                iCount++;
            }
        }//outer for
        
        
        //String trialId = trialPatientObj.Trial_Id__c;
        
        cdapackage.osPathology osPathology = new cdapackage.osPathology();
        
        List<On_Study_Pathology_Form__c> pathologyFormList = [Select id,Tumor_laterality__c,Is_DCIS_Present__c,Is_LCIS_Present__c,Is_invasive_tumor_present__c,HER2_neu_Marker_Status_Snomed__c,(select Estrogen_Receptor_Status__c,Progesterone_Receptor_Status__c,HER2_neu_Marker__c from Receptors__r) from On_Study_Pathology_Form__c where TrialPatient__c=:rId ];
        if(!pathologyFormList.isEmpty() ){
            On_Study_Pathology_Form__c pf = pathologyFormList[0]; 
            
            osPathology.DCIS_Present=pf.Is_DCIS_Present__c;
            
           
            osPathology.invasive_tumor_present=pf.Is_invasive_tumor_present__c;
            osPathology.laterality=pf.Tumor_laterality__c;
            if(osPathology.laterality=='Left'){
                osPathology.lateralitycode ='7771000';
            }else{
                osPathology.lateralitycode ='24028007';
            }
            osPathology.LCIS_Present=pf.Is_LCIS_Present__c;
            osPathology.LymphNodeStatus='';
             
            
            if(!pf.Receptors__r.isEmpty()){
                osPathology.ERStatus=pf.Receptors__r[0].Estrogen_Receptor_Status__c;
                osPathology.PRStatus=pf.Receptors__r[0].Progesterone_Receptor_Status__c;
                osPathology.HERStatus=pf.Receptors__r[0].HER2_neu_Marker__c;
            }else{

                osPathology.ERStatus='';
                osPathology.PRStatus='';
                osPathology.HERStatus='';
            }
            
        }else{
            osPathology.DCIS_Present='';
            osPathology.invasive_tumor_present='';
            osPathology.laterality='';
            osPathology.lateralitycode ='';
            osPathology.LCIS_Present='';
            osPathology.LymphNodeStatus='';
            osPathology.ERStatus='';
            osPathology.PRStatus='';
            osPathology.HERStatus='';
        }
        
        
       
        
        cdapackage.chemoProcedure chemoProcedure  = new cdapackage.chemoProcedure();
        List<Post_Surgaory_Summary__c> postSurgaorySumList = [Select id,pcr__c,Date_Of_Procedure__c,Is_DCIS_Present__c, Is_invasive_tumor_present__c, Is_LCIS_Present__c,Lymph_node_dissection_done__c,(select Estrogen_Receptor_Status__c,Progesterone_Receptor_Status__c,HER2_neu_Marker__c from Receptors__r),(Select Id,Adjudicated_Stage__c from Staging_Details__r) from Post_Surgaory_Summary__c where TrialPatient__c =:rId];
        
        if(!postSurgaorySumList.isEmpty()){
            Post_Surgaory_Summary__c pss = postSurgaorySumList[0];
            chemoProcedure.DCIS_Present = pss.Is_DCIS_Present__c;
            
            chemoProcedure.invasive_tumor_present = pss.Is_invasive_tumor_present__c;
            chemoProcedure.LCIS_Present=pss.Is_LCIS_Present__c;
            chemoProcedure.LymphNodedissection=pss.Lymph_node_dissection_done__c;
            chemoProcedure.Lymphnodestatus='';
            chemoProcedure.PCR=String.valueOf(pss.pcr__c);
            
            chemoProcedure.RCB='';

            if(pss.Date_Of_Procedure__c!=null){
                chemoProcedure.surgerydate=String.valueOf(pss.Date_Of_Procedure__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }else{
                chemoProcedure.surgerydate='';
            }
            chemoProcedure.surgerytype='';
            if(!pss.Receptors__r.isEmpty()){
                chemoProcedure.ERStatus=pss.Receptors__r[0].Estrogen_Receptor_Status__c;
                chemoProcedure.PRStatus=pss.Receptors__r[0].Progesterone_Receptor_Status__c;
                chemoProcedure.HERStatus=pss.Receptors__r[0].HER2_neu_Marker__c;
            }else{

                chemoProcedure.ERStatus='';
                chemoProcedure.PRStatus='';
                chemoProcedure.HERStatus='';
            }
            
            if(!pss.Staging_Details__r.isEmpty()){
                osPathology.ClinicalStaging=pss.Staging_Details__r[0].Adjudicated_Stage__c;
                osPathology.Adjudicatedstage=pss.Staging_Details__r[0].Adjudicated_Stage__c;
                osPathology.Adjudicatedstagecode='';
                
            }else{

                osPathology.ClinicalStaging='';
                osPathology.Adjudicatedstage='';
                osPathology.Adjudicatedstagecode='';
                
            }
        }else{
            chemoProcedure.DCIS_Present = '';
            
            chemoProcedure.invasive_tumor_present = '';
            chemoProcedure.LCIS_Present='';
            chemoProcedure.LymphNodedissection='';
            chemoProcedure.Lymphnodestatus='';
            chemoProcedure.PCR='';
            
            chemoProcedure.RCB='';
            chemoProcedure.surgerydate='';
            chemoProcedure.surgerytype='';
            chemoProcedure.ERStatus='';
            chemoProcedure.PRStatus='';
            chemoProcedure.HERStatus='';
            osPathology.ClinicalStaging='';
            osPathology.Adjudicatedstage='';
            osPathology.Adjudicatedstagecode='';
        }

        cdapackage.chemoRegimen chemoRegimen = new cdapackage.chemoRegimen();
        List<Chemo_Therapy_Regimen__c> chemoRegimenList = [Select Id, Agent__r.Name, Prescribed_Dose__c, Day__c, Dose_Mod__c from Chemo_Therapy_Regimen__c where Chemo_Treatment__r.TrialPatient__c=:rId];
        if(!chemoRegimenList.isEmpty()){
            Chemo_Therapy_Regimen__c cr = chemoRegimenList[0];
            
            chemoRegimen.dose=String.valueOf(cr.Prescribed_Dose__c);
            chemoRegimen.dosemodifications=String.valueOf(cr.Dose_Mod__c);
            chemoRegimen.drugname=cr.Agent__r.Name;
            
            chemoRegimen.priordose='';
            chemoRegimen.priordrugagent='';
            chemoRegimen.schedule=String.valueOf(cr.Day__c);
            chemoRegimen.treatmentplanname ='';
            
            
        }else{
            chemoRegimen.dose='';
            chemoRegimen.dosemodifications='';
            chemoRegimen.drugname='';
            
            chemoRegimen.priordose='';
            chemoRegimen.priordrugagent='';
            chemoRegimen.schedule='';
            chemoRegimen.treatmentplanname ='';
        }

        
        List<Chemo_Treatment__c> chemoList = [Select id, Cycle_number__c from Chemo_Treatment__c where TrialPatient__c = :rId];
        if(!chemoList.isEmpty()){
            Chemo_Treatment__c chemo = chemoList[0];
            chemoRegimen.cycles=String.valueOf(chemo.Cycle_number__c);
        }else{
            chemoRegimen.cycles='';
        }
        

       
        List<Chemo_Summary_Form__c> chemoSummaryList = [Select id,First_Date_of_Taxane_Therapy__c, First_Date_of_Investigational_Therapy__c, First_Date_of_Anthracycline_Therapy__c,Last_Date_of_Anthracycline_Therapy__c, Last_Date_of_Investigational_Therapy__c, Last_Date_of_Taxane_Therapy__c,InvestigationalRegimenTreatmentEndReason__c,Other_Reason__c from Chemo_Summary_Form__c where TrialPatient__c= :rId];
        if(!chemoSummaryList.isEmpty()) {
            Chemo_Summary_Form__c cs = chemoSummaryList[0];
            //chemoRegimen.startdate=cs.First_Date_of_Taxane_Therapy__c;
            if(cs.First_Date_of_Taxane_Therapy__c!=null){
                chemoRegimen.startdate=String.valueOf(cs.First_Date_of_Taxane_Therapy__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }else{
                chemoRegimen.startdate='';
            }
            
            //chemoRegimen.enddate = cs.Last_Date_of_Taxane_Therapy__c;
            if(cs.Last_Date_of_Taxane_Therapy__c!=null){
                chemoRegimen.enddate=String.valueOf(cs.Last_Date_of_Taxane_Therapy__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            }else{
                chemoRegimen.enddate='';
            }
            
            if(cs.InvestigationalRegimenTreatmentEndReason__c =='Treatment completed per protocol criteria'){
                chemoRegimen.treatmentcomepleted = 'Yes';
            }else{
                chemoRegimen.treatmentcomepleted = 'No';
            }
            //if(cs.InvestigationalRegimenTreatmentEndReason__c !='Treatment completed per protocol criteria'){
            //  chemoRegimen.treatmentendreason =cs.InvestigationalRegimenTreatmentEndReason__c;
            //}else {
            //  chemoRegimen.treatmentendreason =cs.Other_Reason__c;
            //}
            chemoRegimen.treatmentendreason =cs.InvestigationalRegimenTreatmentEndReason__c;
            if(chemoRegimen.treatmentendreason==null && cs.Other_Reason__c!=null){
                chemoRegimen.treatmentendreason =cs.Other_Reason__c;
            }
            if(chemoRegimen.treatmentendreason ==null){
                chemoRegimen.treatmentendreason ='';
            }
        } else{
            chemoRegimen.startdate='';
            chemoRegimen.enddate='';
            chemoRegimen.treatmentcomepleted ='';
            chemoRegimen.treatmentendreason ='';
            
        }

             
        try{
            cdapackage.response res = new cdapackage.response();
            if(Test.isRunningTest()) {
                res.status = 'SUCCESS';
                res.description='success message';
                res.code = 'SUCCESS';
            }else{
                
               System.debug('Amit====clinicalDoc='+clinicalDoc);
               System.debug('Amit====author='+author);
               System.debug('Amit====patient='+patient);
               System.debug('Amit====adverseEventArray='+adverseEventArray);
               System.debug('Amit====osPathology='+osPathology);
               System.debug('Amit====chemoProcedure='+chemoProcedure);
               System.debug('Amit====chemoRegimen='+chemoRegimen);
               System.debug('Amit====xmlType='+xmlType);
                
               res = ihub.submitClinicalTrialCDA(clinicalDoc ,author,patient,adverseEventArray,osPathology,chemoProcedure,chemoRegimen,xmlType );
               // submitClinicalTrialCDA(cdapackage.clinicalDocument arg0,cdapackage.author arg1,cdapackage.patient arg2,cdapackage.adverseEvent[] arg3,cdapackage.osPathology arg4,cdapackage.chemoProcedure arg5,cdapackage.chemoRegimen arg6,String arg7) 
            }
            
            if(res.status=='FAILURE'){
                                
               updateFailedRegistration(failedRegistrationId,res.description,'Failure',true,res.caXchangeId,res.id);
            }else{
                updateFailedRegistration(failedRegistrationId,res.description,'Success',false,res.caXchangeId,res.id);
            }
            
        }catch(Exception e){
            updateFailedRegistration(failedRegistrationId,e.getMessage(),'Failure',true,null,null);
                
        }

    }*/
    
    global void finish(Database.BatchableContext BC){
        
        Schedule_Job_Settings__c jobSetting = Schedule_Job_Settings__c.getInstance('RetryRegistration');
        Integer interval = jobSetting.Interval__c.intValue();
        
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(interval);
        String chron_exp = '' + sysTime.second() +' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        BatchableRetryRegistration batchableRetryRegistration = new BatchableRetryRegistration();
        System.schedule('BatchableRetryRegistration' + sysTime.getTime(),chron_exp, batchableRetryRegistration);
      
    }
    global void execute(SchedulableContext SC) {
        if(!Test.isRunningTest()){      
            Id cronTrigId = SC.getTriggerId();
            System.abortJob(cronTrigId);
        }
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        ID batchProecssedId = Database.executeBatch(job,1);
    }
    
    @isTest public static void test1(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='xyz;White;Black or African American;American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander',Gender__c='Male',Ethnicity__c='Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound';
        tissue.PatientConsentedOutsideStudy__c=True;
        tissue.PatientConsentedStudy__c=True;
        insert tissue;
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 1';
        //Test.startTest();
        
        //job.retryRegistration(fr.Id, t.Id, p.id, reg.Id);
        //job.retryTissueSpecimenSubmission(fr2.Id, t.Id, p.id, tissue.Id);
        //job.retryTissueSpecimenConsentSubmission(fr3.Id, t.Id, p.id, tissue.Id);
        //job.retryBloodSpecimenSubmission(fr4.Id, t.Id, p.id, blood.Id);
        //job.retryBloodSpecimenConsentSubmission(fr5.Id, t.Id, p.id, blood.Id);
        //job.retryAdverseEventSubmission(fr6.Id, t.Id, p.id, ae.Id);
        
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
        
        //ID batchProecssedId = Database.executeBatch(job,1);
        //Test.stopTest();
    }
    
    @isTest public static void test2(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='White;Black or African American;American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander;xyz',Gender__c='Female',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
    /*
    @isTest public static void test3(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='Black or African American;American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander;xyz;White',Gender__c='Female',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
    @isTest public static void test4(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander;xyz;White;Black or African American',Gender__c='Female',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
    @isTest public static void test5(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='Asian;Native Hawaiian or Other Pacific Islander;xyz;White;Black or African American;American Indian or Alaska Native',Gender__c='Female',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
    @isTest public static void test6(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='Native Hawaiian or Other Pacific Islander;xyz;White;Black or African American;American Indian or Alaska Native;Asian',Gender__c='NA',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
    @isTest public static void test7(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='xyz;White;Black or African American;American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander',Gender__c='Female',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }
    @isTest public static void test8(){
        BatchableRetryRegistration job = new BatchableRetryRegistration();
        //Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='xyz;pqr;White;Black or African American;American Indian or Alaska Native;Asian;Native Hawaiian or Other Pacific Islander',Gender__c='NA',Ethnicity__c='Not Hispanic or Latino');
        insert p;
        
        
        Trial__c tri = new Trial__c();
        tri.Name = 'test';
        insert tri;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = tri.Id;
        insert tp;
        
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        Registration__c reg = new Registration__c(); 
        reg.Patient__c = p.Id;
        reg.Registration_Date__c = system.today();
        reg.Trial__c = t.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=reg.Id,CRF_Name__c='Patient Registration Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        
        CRFMaster__c crfmst = new CRFMaster__c();
        crfmst.Object_Name__c ='Registration__c';
        insert crfmst;
        
        XML_Configuration__c xmlConfig = new XML_Configuration__c();
        xmlConfig.Field_API_Name__c ='First_Name__c';
        xmlConfig.CRF_Type__c = crfmst.Id;
        xmlConfig.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig;
        
        XML_Configuration__c xmlConfig2 = new XML_Configuration__c();
        xmlConfig2.Field_API_Name__c ='Last_Name__c';
        xmlConfig2.CRF_Type__c = crfmst.Id;
        xmlConfig2.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig2;
        
        XML_Configuration__c xmlConfig3 = new XML_Configuration__c();
        xmlConfig3.Field_API_Name__c ='SSN__c';
        xmlConfig3.CRF_Type__c = crfmst.Id;
        xmlConfig3.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig3;
        
        XML_Configuration__c xmlConfig4 = new XML_Configuration__c();
        xmlConfig4.Field_API_Name__c ='Race__c';
        xmlConfig4.CRF_Type__c = crfmst.Id;
        xmlConfig4.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig4;
        
        XML_Configuration__c xmlConfig5 = new XML_Configuration__c();
        xmlConfig5.Field_API_Name__c ='Ethnicity__c';
        xmlConfig5.CRF_Type__c = crfmst.Id;
        xmlConfig5.Object_API_Name__c = 'Patient_Custom__c';
        insert xmlConfig5;
        
        XML_Configuration__c xmlConfig6 = new XML_Configuration__c();
        xmlConfig6.Field_API_Name__c ='ISPY2_Subject_Id__c';
        xmlConfig6.CRF_Type__c = crfmst.Id;
        xmlConfig6.Object_API_Name__c = 'Registration__c';
        insert xmlConfig6;
        
        //Select p.Value__c,p.snomed_Code_Name__c, p.Code_Master__r.Name, p.Code_Master__c, p.Code_System__c, p.Code_System_Version__c From Pre_Registration_Snomed_Codes__c p where Patient__c =:patientId and  (Code_Master__r.Name ='Ethn' or Code_Master__r.Name ='Race'
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='TissueSpecimenDetail__c');
        insert crfMaster;
        
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        TissueSpecimenDetail__c tissue = new TissueSpecimenDetail__c();
        tissue.TrialPatient__c=tp.Id;
        tissue.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue.Patient__c = p.Id;
        tissue.NumberOfSamplesCollected__c =1;
        tissue.Effective_Time__c = System.now();
        tissue.CRFId__c = crf.Id;
        tissue.ProcedureDate__c=System.today();
        tissue.Time_Point__c='Pre-treatment';
        tissue.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue.PatientConsentedOutsideStudy__c=False;
        tissue.PatientConsentedStudy__c=False;
        insert tissue;
        
        TissueSpecimenDetail__c tissue2 = new TissueSpecimenDetail__c();
        tissue2.TrialPatient__c=tp.Id;
        tissue2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        tissue2.Patient__c = p.Id;
        tissue2.NumberOfSamplesCollected__c =1;
        tissue2.Effective_Time__c = System.now();
        tissue2.CRFId__c = crf.Id;
        tissue2.ProcedureDate__c=System.today();
        tissue2.Time_Point__c='Pre-treatment';
        tissue2.Guidance_Method_s__c='Ultrasound;MRI;Stereotactic;Mammography;Palpation;';
        tissue2.PatientConsentedOutsideStudy__c=True;
        tissue2.PatientConsentedStudy__c=True;
        insert tissue2;
        
        
        
        Failed_Registration__c fr2 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr2;
        
        Failed_Registration__c fr3 = new Failed_Registration__c(CRF_Id__c=tissue2.Id,CRF_Name__c='Tissue Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr3;
        
        CRFMaster__c crfMaster2 = new CRFMaster__c(Object_Name__c ='BloodSpecimenForm__c');
        insert crfMaster2;
        
        XML_Configuration__c c11 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c11;
        XML_Configuration__c c12 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c12;
        XML_Configuration__c c13 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c13;
        XML_Configuration__c c14 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster2.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c14;
        
        BloodSpecimenForm__c blood= new BloodSpecimenForm__c ();
        blood.TrialPatient__c=tp.Id;
        blood.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood.Effective_Time__c = System.now();
        blood.CRF__c = crf.Id;
        blood.CollectionDate__c=System.today();
        blood.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood.Consented_to_use_specimen_study__c=True;
        blood.Contented_specimen_outside_study__c=True;
        insert blood;
        
        BloodSpecimenForm__c blood2= new BloodSpecimenForm__c ();
        blood2.TrialPatient__c=tp.Id;
        blood2.Status__c='Approval Not Required';
        //tissue.RecordTypeId='';
        //blood.Patient__c = p.Id;
        //blood.NumberOfSamplesCollected__c =1;
        blood2.Effective_Time__c = System.now();
        blood2.CRF__c = crf.Id;
        blood2.CollectionDate__c=System.today();
        blood2.Time_Point__c='Pre-treatment';
        //blood.Guidance_Method_s__c='Ultrasound';
        blood2.Consented_to_use_specimen_study__c=True;
        blood2.Contented_specimen_outside_study__c=True;
        insert blood2;
        
        Failed_Registration__c fr4 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr4;
        
        Failed_Registration__c fr5 = new Failed_Registration__c(CRF_Id__c=blood2.Id,CRF_Name__c='Blood Specimen Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr5;
        
        CRFMaster__c crfMaster3 = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster3;
        
        XML_Configuration__c c21 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c21;
        XML_Configuration__c c22 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c22;
        XML_Configuration__c c23 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c23;
        XML_Configuration__c c24 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster3.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c24;
        
        AE_Detail__c ae = new AE_Detail__c();
        ae.CRF__c=crf.Id;
        ae.Effective_Time__c=System.now();
        ae.TrialPatient__c=tp.Id;
        ae.CompletedDate__c=System.today();
        insert ae;
        
        Toxicity__c tx = new Toxicity__c();
        tx.AE_Detail__c = ae.Id;
        tx.AE_End_Date__c=System.today();
        tx.Effective_Time__c=System.now();
        tx.Onset_Date__c=System.today();
        insert tx;
        
        Failed_Registration__c fr6 = new Failed_Registration__c(CRF_Id__c=ae.Id,CRF_Name__c='AE Form',IsConsent__c=True,Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr6;
        
        job.query='Select CRF_Id__c,CRF_Name__c,IsConsent__c, Trial__c, Retry__c, Patient__c, Number_of_Retry__c, Name, Last_Success_Message__c, Last_Status__c, Last_Run_DateTime__c, Last_Error_Message__c, Id From Failed_Registration__c where Retry__c=true limit 10';
        Test.startTest();
        job.processFR(fr);
        job.processFR(fr2);
        job.processFR(fr3);
        job.processFR(fr4);
        job.processFR(fr5);
        job.processFR(fr6);
        
        
        ID batchProecssedId = Database.executeBatch(job,1);
        Test.stopTest();
    }*/
}