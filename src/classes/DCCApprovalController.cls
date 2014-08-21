public with sharing class DCCApprovalController {

    public String decisionComments{get;set;}
    public String frameURL{get;set;}
    public String trialPatientId{get;set;}
    public String recordId{get;set;}
    public String objectName{get;set;}
    public String workItemId{get;set;}
    public String msgColor {get;set;}  
    public String password {get;set;} 
    public String decision{get;set;}
    public String errorMsg{get;set;}
    public String signAndSubmitErrorMsg{get;set;}
    public Boolean isApproved{get;set;}
    public Boolean isRejected{get;set;}
    public Boolean isError{get;set;} 
    public Boolean isAlreadyApproved{get;set;}
    public Boolean isAlreadyRejected{get;set;}
    public Boolean isDeleted{get;set;}
    public List<Approval_Request__c> lstApprovalRequest{get;set;}
    public Approval_Request__c approvalReqObj{get;set;}
    
    public DCCApprovalController() {
        trialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
        recordId = Apexpages.currentPage().getParameters().get('recId');
        objectName = Apexpages.currentPage().getParameters().get('object');
        //workItemId = Apexpages.currentPage().getParameters().get('workItemId');
        isApproved = false;
        isRejected = false;
        isError = false;
        isAlreadyApproved = false;
        isAlreadyRejected = false;
        isDeleted = false;
        errorMsg = '';
        approvalReqObj = new Approval_Request__c();
        
        if(trialPatientId != null && recordId != null && objectName != null) {
            List<Sobject> objectList = Database.query('select Status__c from '+objectName+' where Id = \''+recordId+'\'');
            system.debug('__objectList__'+objectList);
        //===========checking record already approved?=================================================================================
            if(!objectList.isEmpty()) {
                system.debug('__objectList[0].get__'+objectList[0].get('Status__c'));
                if(objectList[0].get('Status__c') == 'Approval Pending' || objectList[0].get('Status__c') == 'Rejected' || objectList[0].get('Status__c') == 'Accepted') {
                    if(objectList[0].get('Status__c') == 'Rejected') {
                        isAlreadyRejected = true;
                        isAlreadyApproved = false;
                    }else if(objectList[0].get('Status__c') == 'Accepted'){
                        isAlreadyApproved = true;
                        isAlreadyRejected = false;
                    }
                    lstApprovalRequest = [Select a.Site__r.Name, a.Study__r.Name, Subject_Id__c, a.Record_Id__c, a.Object_Label__c, a.Name, a.CreatedDate, a.Approval_URL__c From Approval_Request__c a where Record_Id__c =:recordId];
                    if(!lstApprovalRequest.isEmpty()) {
                        approvalReqObj = lstApprovalRequest[0];
                    }
                    if(objectName == 'Menopausal_Status_Detail__c') {
                        frameURL = '/apex/MenopausalStatusReadOnly?menopausalId='+recordId+'&TrialPatient='+trialPatientId;
                    } else if(objectName == 'Response_Evaluation_Form__c') {
                        frameURL = '/apex/ResponseEvaluationFormReadOnly?respEvalId='+recordId+'&trialPat='+trialPatientId;
                    } else if(objectName == 'On_Study_Eligibility_Form__c') {
                        frameURL = '/apex/OnStudyEligibilityReadOnly?onStudyEleId='+recordId+'&trialPat='+trialPatientId;
                    } else if(objectName == 'On_Study_Pathology_Form__c') {
                        frameURL = '/apex/OnStudyPathologyReadOnly?PathologyId='+recordId+'&trialPat='+trialPatientId;
                    } else if(objectName == 'Lab_and_Test__c') {
                        frameURL = '/apex/LabAndTestDetailsReadOnly?labAndTestId='+recordId+'&trialPat='+trialPatientId;
                    } else if(objectName == 'BaselineSymptomsForm__c') {
                        frameURL = '/apex/BaselineSymptomsReadOnly?baselineid='+recordId+'&trialPat='+trialPatientId;
                    } else if(objectName == 'ProtocolViolationDetail__c') {
                        frameURL = '/apex/ProtocolViolationReadOnly?formId='+recordId+'&trialPat='+trialPatientId;
                    } else if(objectName == 'AE_Detail__c') {
                        frameURL = '/apex/AdverseEventReadOnly?aeid='+recordId+'&trialPat='+trialPatientId;
                    } else if(objectName == 'Chemo_Treatment__c') {
                        frameURL = '/apex/ChemoTreatmentReadOnly?formId='+recordId+'&trialPat='+trialPatientId;
                    } else if(objectName == 'Chemo_Summary_Form__c') {
                        frameURL = '/apex/ChemoSummaryReadOnly?formId='+recordId+'&trialPat='+trialPatientId;
                    } else if(objectName == 'Post_Surgaory_Summary__c') {
                        frameURL = '/apex/PostSurgerySummaryReadOnly?postid='+recordId+'&trialPat='+trialPatientId;
                    } else if(objectName == 'Off_Study_Detail__c') {
                        frameURL = '/apex/OffStudyReadOnly?offStudyId='+recordId+'&trialPat='+trialPatientId;
                    } else if(objectName == 'MRI_Volume__c') {
                        frameURL = '/apex/MRIVolumeReadOnly?trialPat='+trialPatientId+'&mriId='+recordId;
                    } else if(objectName == 'No_Longer_lost_to_Followup__c') {
                        frameURL = '/apex/NolongerLosttoFollowupFormReadOnly?trialPat='+trialPatientId+'&NLLTFupFormId='+recordId;
                    } else if(objectName == 'Lost_to_Follow_Up__c') {
                        frameURL = '/apex/LosttoFollowupFormReadOnly?trialPat='+trialPatientId+'&ltfupformId='+recordId;
                    } else if(objectName == 'Followup_Form__c') {
                        frameURL = '/apex/FollowupFormReadOnly?trialPat='+trialPatientId+'&fupformId='+recordId;
                    } 
                } 
            } else {
                isError = true;
                isDeleted = true;
                errorMsg = 'This record may be deleted or no longer use. Please check again.';
            }
        }
        system.debug('__frameURL__'+frameURL);
    }
    
    public void approve() {
    	workItemId = getWorkItemId();
    	system.debug('workItemId: '+workItemId);
        if(workItemId != null) {
            ApprovalManager.approveCRF(recordId, workItemId, decisionComments);
            isApproved = true;
            isRejected = false;
            isError = false;
        }
    }
    
    public void reject() {
        system.debug('__decisionComments__'+decisionComments);
        workItemId = getWorkItemId();
        system.debug('workItemId: '+workItemId);
        if(decisionComments != null && decisionComments != '' && workItemId != null) {
            ApprovalManager.rejectCRF(recordId, workItemId, decisionComments);
            isRejected = true;
            isApproved = false;
            isError = false;
        } else {
            isError = true;
            isRejected = false;
            errorMsg = 'Please provide reason of rejection.';
        }
    }
    
    public Pagereference cancel() {
        Pagereference pr = new Pagereference('/apex/DCCApprovalRequestList?sfdc.tabName=01rc00000000E2E');
        pr.setRedirect(true);
        return pr;
    }
    
    public String getWorkItemId(){
    	String processWorkItemId = null;
    	List<ProcessInstanceWorkitem> lstProcessWorkItem = [Select p.ProcessInstance.TargetObjectId, p.ProcessInstanceId, p.OriginalActorId, p.Id, p.CreatedDate, p.ActorId From ProcessInstanceWorkitem p where ProcessInstance.TargetObjectId =:recordId and ProcessInstance.Status='Pending'];
    	if(!lstProcessWorkItem.isEmpty()) {
    		processWorkItemId = lstProcessWorkItem[0].Id;
    	}
    	return processWorkItemId;
    }
    
    public void signAndSubmit() {
        //if(objectName=='AE_Detail__c' && decision == 'approve'){
        //  submitAdverseEvent();
        //}
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Boolean isPass = signSubmit.signAndSubmitForDCC();
        system.debug('errorMsg :  '+signSubmit.errorMsg);
        signAndSubmitErrorMsg = signSubmit.errorMsg;
        msgColor = 'Red';
        if(isPass) {
            if(decision == 'approve') {
                approve();
                if(objectName=='AE_Detail__c'){
                    submitAdverseEvent(recordId, trialPatientId);
                }
            } else if(decision == 'reject') {
                reject();
            } else {
                isError = true;
                errorMsg = 'Please select your decision.';
            }
        }
    }
    
    public void resendCode() {
        SignAndSubmitController ctr = new SignAndSubmitController();
        ctr.resendCode();
        signAndSubmitErrorMsg = 'Code Sent! Please check your Email.';
        msgColor = 'Green';
    }
    
    @future (callout=true)
    private static void submitAdverseEvent(Id recordId, Id trialPatientId){
        
        //CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='AE_Detail__c']; 
        CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='Registration__c']; 
        
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
        
        cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
        cdapackage.author author = new cdapackage.author();
        cdapackage.patient patient = new cdapackage.patient();
        cdapackage.procedure procedure = new cdapackage.procedure();
        cdapackage.guidanceMethod[] guidanceArray;// = new cdapackage.guidanceMethod[]{};
        String xmlType = 'CDA';
        author.idExtension = UserInfo.getUserName();
        
        AE_Detail__c adverseEventObj = [select a.caAERS_report_filed__c, a.Visit_Date__c, a.CompletedDate__c, a.CRF__c, a.TrialPatient__c, a.SystemModstamp, a.Status__c, 
                    a.Patient_Hospitalized__c, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, 
                    a.Effective_Time__c, a.CreatedById, OriginalCRF__c , (Select Id, Name, AE_Detail__c, AE_End_Date__c, Attribution__c, 
                    Did_event_required_hospitalization__c, Did_event_result_in_death__c, Did_the_investigator_find_event_unusual__c, 
                    Grade__c, Onset_Date__c, Patient_Complaint__c, Resolved__c, Result_conginental_abnormality_defect__c, 
                    Result_persistent_significant_disability__c, SAE__c, Was_event_life_threatning__c, Symptom_Status__c, Symptom_Masters__c, Toxicity_Master__c,  Toxicity_Status__c   From Toxicities__r)
                    From AE_Detail__c a where Id =: recordId];
       
       System.debug('Amit adverseEventObj.Toxicities__r.size()='+adverseEventObj.Toxicities__r.size()); 
       //System.debug('Amit adverseEventObj.Toxicities__r[0].Attribution__c='+adverseEventObj.Toxicities__r[0].Attribution__c);
                
       if(adverseEventObj.Toxicities__r.size()==1 && adverseEventObj.Toxicities__r[0].Attribution__c=='0 - Baseline'){
           //do nothing
       }else{
       
                    
       List<Toxicity__c> allToxicityList= [Select Id, Name, AE_Detail__c, AE_End_Date__c, Attribution__c, 
                    Did_event_required_hospitalization__c, Did_event_result_in_death__c, Did_the_investigator_find_event_unusual__c, 
                    Grade__c, Onset_Date__c, Patient_Complaint__c, Resolved__c, Result_conginental_abnormality_defect__c, 
                    Result_persistent_significant_disability__c, SAE__c, Was_event_life_threatning__c, Symptom_Status__c, Symptom_Masters__c, Toxicity_Master__c,  Toxicity_Status__c   From Toxicity__c where TrialPatient__c=:trialPatientId and Attribution__c != '0 - Baseline'];
                    
       
        TrialPatient__c trialPatientObj = null;
        String patientId;
        List<TrialPatient__c> lstTrialPatient = [select Name,Subject_Id__c,Site__c, Patient_Id__c, Trial_Id__c,Trial_Id__r.Name,Site__r.Name  from TrialPatient__c where Id = :trialPatientId];
        if(!lstTrialPatient.IsEmpty()) {
            trialPatientObj = lstTrialPatient[0];
            patientId = lstTrialPatient[0].Patient_Id__c;
        }
                    
        clinicalDoc.id=adverseEventObj.id;
        clinicalDoc.title = 'Create Or Update Adverse Events';
        if(adverseEventObj.Effective_Time__c!=null){
            clinicalDoc.effectiveTime=String.valueOf(adverseEventObj.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
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

        String siteId,studyId,mrn;
        
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
            
            clinicalDoc.studySubjectIdentifier=trialPatientObj.Subject_Id__c;
            mrn=patientObj.Medical_Record_Number__c;
            
        }
        siteId = trialPatientObj.Site__c;
        studyId = trialPatientObj.Trial_Id__c;
        
        String treatmentArmName;
        List<ArmPatient__c> armPatientList = [Select a.assignedToPatient__c, a.TrialPatient__r.Patient_Id__c, a.TrialPatient__r.Name, a.TrialPatient__c, a.Name, a.Arm_Id__r.Name, a.Arm_Id__c From ArmPatient__c a where TrialPatient__c =:trialPatientId and assignedToPatient__c = true];
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
        
        //cdapackage.adverseEvent[] adverseEventArray = new cdapackage.adverseEvent[adverseEventObj.Toxicities__r.size()];
        cdapackage.adverseEvent[] adverseEventArray = new cdapackage.adverseEvent[allToxicityList.size()];
        
        //for(Integer i=0;I< adverseEventObj.Toxicities__r.size();i++){
        for(Integer i=0;I< allToxicityList.size();i++){
            //Toxicity__c tox=adverseEventObj.Toxicities__r[i];
            Toxicity__c tox=allToxicityList[i];
            cdapackage.adverseEvent ae = new cdapackage.adverseEvent();
            
            ae.id= tox.Id;
            
            //if(tox.AE_End_Date__c!=null){
            //    ae.reportingPeriodEndDate=String.valueOf(tox.AE_End_Date__c).replaceAll('-','').replaceAll(' ','');
            //}
            //ae.grade = tox.Grade__c;
            if(tox.Grade__c!=null){
                String s = tox.Grade__c.split('-')[0].trim();
                System.debug('Amit Grade ===='+s );
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
            
            if(tox.Attribution__c!=null){
                ae.attribution=tox.Attribution__c.split('-')[1].trim();
            }
            //ae.attribution=tox.Attribution__c;//rollback
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
            if(ae.attributionCode==''){
              ae.attribution='Unrelated';
            }

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
            
            ae.verbatim=tox.Patient_Complaint__c==null?'':tox.Patient_Complaint__c;
            
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
                //ae.seriousReason='';
                ae.seriousReasonCode='NA';
            }else if(tox.Result_conginental_abnormality_defect__c){
                ae.seriousReason='Is a congenital abnormality/birth defect';
                ae.seriousReasonCode='66091009';
            }else if(tox.Result_persistent_significant_disability__c){
                ae.seriousReason='Results in persistent or significant incapacity or substantial disruption of the ability to conduct normal life functions';
                ae.seriousReasonCode='405532008';
            }else{
              ae.seriousReason='';
                ae.seriousReasonCode='NA';
            }
            
            //ae.assignedTreatment='TAC1';
            //ae.assignedTreatment='Paclitaxel';
            if(treatmentArmName!=null){
                ae.assignedTreatment=treatmentArmName;
            }else{
                ae.assignedTreatment='Screening';
            }
            
           ae.eventtypecode='59037007';
           ae.eventtypename='drug intolerance';
            
            adverseEventArray[i] = ae;
        }
        
        String trialId = trialPatientObj.Trial_Id__c;
                
        try{
            cdapackage.response res = new cdapackage.response();
            if(Test.isRunningTest()) {
                res.status = 'SUCCESS';
                res.description='success message';
                res.code = 'SUCCESS';
            }else{
               res = serviceConnector.ihub.submitAECDA(clinicalDoc ,author,patient,adverseEventArray ,xmlType );
                
            }
            
            if(res.status=='FAILURE'){                
                ExternalServiceConnector.populateFailedRegistration('AE_Detail__c',adverseEventObj.Id,false,patientId,trialId,siteId,studyId,res.code,res.description,'Failure','caAERS',mrn,res.caXchangeId,res.id);
                
            }
            
        }catch (System.CalloutException e){
            System.debug(e);
            String errorCode = '5001';
            
            ExternalServiceConnector.populateFailedRegistration('AE_Detail__c',adverseEventObj.Id,false,patientId,trialId,siteId,studyId,errorCode,'Connection timeout when accessing CDA Service','Failure','caAERS',mrn,null,null);
            
        }catch(Exception e){
            System.debug(e);
            String errorCode = '5000';
            
            ExternalServiceConnector.populateFailedRegistration('AE_Detail__c',adverseEventObj.Id,false,patientId,trialId,siteId,studyId,errorCode,'Unexpected error','Failure','caAERS',mrn,null,null);
        }
      }//if
    }
    

    /*
    public static void populateFailedRegistration(String crfId,String patientId, String trialId, String siteId,String studyId, String errorCode, String errorMessage, String status,String systemName, String mrn,String caXchangeId, String returnId){
        String CRFName;
        List<CRFMaster__c> crfList = [Select c.CRFType__c From CRFMaster__c c where c.Object_Name__c='AE_Detail__c'];
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
        
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=crfId,Patient__c=patientId,Trial__c=trialId,Last_Error_Message__c=errorMessage,Last_Status__c=status,Retry__c=autoRetry,Site__c=siteId,Study_Id__c=studyId,Error_Code__c=errorCode,System_Name__c=systemName,MRN__c=mrn,CRF_Name__c=CRFName,CaXchangeId__c=caXchangeId,ReturnId__c=returnId);
        insert fr;
    }*/
}