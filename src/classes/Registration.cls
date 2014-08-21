public with sharing class Registration extends PageControllerBase {
    public Patient_Custom__c patientObj {get;set;}
    public Registration__c registrationObj {get;set;}
    public String password {get;set;}
    public String errorMsg {get;set;}
    public String currentTab{get;set;}
    public String patientId {get;set;}
    private Id regidValue {get;set;}
    public String trialId {get;set;}
    private string isxmlpage {get;set;}
    public String nextTabName{get;set;}
     
    //public string PatientFieldCheck{get;set;}
    //public string RegistrationFieldCheck{get;set;}
    public Boolean firstNmLastNmInitl{get;set;}
    public Boolean RaceEthnicity{get;set;}
    public Boolean SSN{get;set;}
    public Boolean ISPY2SubjectId{get;set;}
    public boolean IsXMLGenerated {get;set;}
    public String xmlOutput {get;set;}
    public String radioValue {get;set;}
    
    //If user belongs to multiple sites, please allow user to select site where he wants to register patient
    //public Boolean userAssociatedWithMultipleInstitutions {get;set;}
    //public Boolean userAssociatedWithMultipleSites {get;set;}
    //public List<Selectoption> institutions {get;set;}
    //public List<Selectoption> sites {get;set;}
    //private Map<Id, List<Selectoption>> instIdSiteIdMap;
    //public String selectedInstitution{get;set;}
    //public InstitutionUser__c instituteUsreObj{get;set;}
   // public String selectedSite{get;set;}
    public Boolean isComplete{get;set;}
    public Trial__c trialObj {get;set;}
    public List<Trial__c> trialList{get;set;}
    public String profileName {get;set;}
    public Boolean isDelete{get;set;}  // For Delete //
        
    public Registration(ApexPages.StandardController controller) {
        System.debug('Registration-------'+controller.getId());
        regidValue = controller.getId();
        System.debug('regidValue: '+regidValue);
        currentTab = 'PatientTab';
        //Boolean isComplete = false;
        isComplete = true;
        IsDelete = false;             // For Delete //
        IsDelete();                   // For Delete //
        
        if(regidValue != null) registrationObj = [Select createdBy.name,Surgeon__r.Name, Surgeon__c, Radiology_Coordinator__r.Name, Radiology_Coordinator__c, Oncologist__r.Name, Oncologist__c, Clinical_Coordinator__r.Name, Clinical_Coordinator__c, OwnerId,Effective_Time__c,Institution__r.Name, Site__r.Id,Site__r.Name, r.Trial__c,r.Trial__r.Name, r.TrialPatient__c, r.SystemModstamp, r.Status__c, r.Site__c, r.Screening_Informed_Consent_Date__c, r.SSN__c, r.Registration_Date__c, r.RecordTypeId, r.Radiology_Coordinator_Phone__c, r.Radiology_Coordinator_Fax__c, r.Radiology_Coordinator_Email__c, r.Race__c, r.Phase__c, r.Patient__c, r.Patient_Initials__c, r.Name, r.Middle_Name__c, r.Last_Name__c, r.LastModifiedDate, r.LastModifiedById, r.LastActivityDate, r.Lab__c, r.IsDeleted, r.Institution__c, r.Initials__c, r.Id, r.ISPY2_Subject_Id__c, r.IRB_Approval_Date__c, r.HIPPA_Consent_Date__c, r.Gender__c, r.First_Name__c, r.Ethnicity__c, r.CreatedDate, r.CreatedById, r.Country_of_birth__c, r.CompletedDate__c, r.Clinical_Coordinator_Phone__c, r.Clinical_Coordinator_Fax__c, r.Clinical_Coordinator_Email__c, r.CRF__c From Registration__c r where id =: regidValue order by LastModifiedDate desc limit 1];
        //-----------------------delete button fuctionlity- start-------------------------
        system.debug('***' + IsDelete);
       if (IsDelete){
       system.debug('inside delete');
       String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        }  }
       //-----------------------delete button fuctionlity- start------------------------- 
        firstNmLastNmInitl = false;
        RaceEthnicity  = false;
        SSN = false;
        ISPY2SubjectId = false;
        
        isxmlpage = Apexpages.currentPage().getParameters().get('isxmlpage');
        
        if(registrationObj != null){
            patientId = registrationObj.Patient__c;
            trialId = registrationObj.Trial__c;
            trialObj = [select Name from Trial__c where Id = :trialId];
            /*selectedInstitution = registrationObj.Institution__c;
            system.debug('__selectedInstitutionRegistration__'+selectedInstitution);
            selectedSite = registrationObj.Site__c;*/
        }else{
            patientId = ApexPages.currentPage().getParameters().get('patientId');
            //regidValue = Apexpages.currentPage().getParameters().get('regid');
            trialId = Apexpages.currentPage().getParameters().get('trial');
            trialObj = [select Name from Trial__c where Id = :trialId];
        }
        
        system.debug('trialObj: '+trialObj);
        list<XML_Configuration__c> lstXMLConfig = [select Id, CRF_Type__c, CRF_Type__r.Object_Name__c, Object_API_Name__c, Field_API_Name__c  From XML_Configuration__c x where Object_API_Name__c IN ('Registration__c','Patient_Custom__c')];
            for(XML_Configuration__c xmlConfObj : lstXMLConfig) {                             
                if(xmlConfObj.Object_API_Name__c == 'Patient_Custom__c') {
                    if((xmlConfObj.Field_API_Name__c == 'First_Name__c') || (xmlConfObj.Field_API_Name__c == 'Last_Name__c') || (xmlConfObj.Field_API_Name__c == 'Initials__c')) {
                        firstNmLastNmInitl = true;
                    } else if(xmlConfObj.Field_API_Name__c == ('Race__c') ||(xmlConfObj.Field_API_Name__c == 'Ethnicity__c'))  {
                        RaceEthnicity = true;
                      } else if(xmlConfObj.Field_API_Name__c == 'SSN__c') {
                        SSN = true;
                      } /*else if(xmlConfObj.Field_API_Name__c == 'Gender__c') {
                        Gender = true;
                      } else if(xmlConfObj.Field_API_Name__c == 'Country_of_Birth__c') {
                        Countryofbirth = true;
                      } else if(xmlConfObj.Field_API_Name__c == ('Medical_Record_Number__c') || (xmlConfObj.Field_API_Name__c =='Institute_Text__c')) {
                        MRNInstitute = true;
                      } else if(xmlConfObj.Field_API_Name__c == 'Zip__c') {
                        Zip = true;
                      }*/
                } else if(xmlConfObj.Object_API_Name__c == 'Registration__c') {
                      if(xmlConfObj.Field_API_Name__c == 'ISPY2_Subject_Id__c') {
                        ISPY2SubjectId = true;
                      }
                        /*if(xmlConfObj.Field_API_Name__c == 'Registration_Date__c') {
                        RegistrationDate = true;
                        system.debug('--xmlConfObj.Field_API_Name__c--'+xmlConfObj.Field_API_Name__c);
                      } else if(xmlConfObj.Field_API_Name__c == 'CreatedById') {
                        StudyCoordinator = true;
                      } else if(xmlConfObj.Field_API_Name__c == 'ACRIN_6693_MRS_Participant__c') {
                        ACRIN6698RepeatScanConsent = true;
                      }  else if(xmlConfObj.Field_API_Name__c == 'Oncologist__c') {
                        Oncologist = true;
                      } else if(xmlConfObj.Field_API_Name__c == 'Surgeon__c') {
                        Surgeon = true;
                      } else if(xmlConfObj.Field_API_Name__c == 'Clinical_Coordinator__c') {
                        ClinicalCoordinator = true;
                      } else if(xmlConfObj.Field_API_Name__c == 'Radiology_Coordinator__c') {
                        RadiologyCoordinator = true;
                      } else if(xmlConfObj.Field_API_Name__c == 'IRB_Approval_Date__c') {
                        IRBApprovalDate = true;
                      } else if(xmlConfObj.Field_API_Name__c == 'Screening_Informed_Consent_Date__c') {
                        ScreeningInformedConsentDate = true;
                      } else if(xmlConfObj.Field_API_Name__c == 'HIPPA_Consent_Date__c') {
                        HIPPAConsentDate = true;
                      }*/
                }
            }  
               
               
        //patientObj = new Patient_Custom__c(); 
        if(regidValue == null){
            registrationObj = new Registration__c();
            currentTab = 'PatientTab';
            //isComplete = true;
            List<TrialPatient__c> lstTrialpatient = [select Id from TrialPatient__c where Trial_Id__c =:trialId and Patient_Id__c =:patientId];
            registrationObj.Patient__c = patientId;
            registrationObj.Trial__c = trialId;
            if(!lstTrialpatient.isEmpty()) {
                registrationObj.TrialPatient__c = lstTrialpatient[0].Id;
            }
        }
        //sites = new List<Selectoption>();
        system.debug('__patientId__'+patientId);
        
        List<Patient_Custom__c> patientObjList = [Select  p.Name, p.Zip__c, p.SSN__c, p.Race__c, p.Middle_Name__c, p.Medical_Record_Number__c, p.Last_Name__c, p.Institution__c, p.Institute_Text__c, p.Initials__c, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.Country_of_Birth__c From Patient_Custom__c p where Id =:patientId limit 1];
        if(!patientObjList.isEmpty()) {
            patientObj = patientObjList.get(0);
            //selectedInstitution = patientObjList[0].Institution__c;
        }
        system.debug('patientObj======'+patientObj.id);
        
        /*if(regidValue != null) {
            List<Registration__c> registrationObjList = [Select Name, CreatedById, ISPY2_Subject_Id__c, r.Surgeon__c, Radiology_Coordinator__c , ACRIN_6693_MRS_Participant__c, r.Screening_Informed_Consent_Date__c, r.Registration_Date__c, r.Radiology_Coordinator_Phone__c, r.Radiology_Coordinator_Fax__c, r.Radiology_Coordinator_Email__c, r.Oncologist__c, r.IRB_Approval_Date__c, r.HIPPA_Consent_Date__c, r.Clinical_Coordinator__c, r.Clinical_Coordinator_Phone__c, r.Clinical_Coordinator_Fax__c, r.Clinical_Coordinator_Email__c From Registration__c r where Id =:regidValue order by LastModifiedDate desc limit 1];
            if(!registrationObjList.isEmpty()) {
                registrationObj = registrationObjList.get(0);
            }
        }*/
        
        /*if(patientId != null && trialId != null) {
            System.debug('regidValue-----------'+regidValue);
            if(regidValue != null){
                List<Registration__c> registrationObjList = [Select createdBy.name,OwnerId,Effective_Time__c,Institution__r.Name, Site__r.Id,Site__r.Name, r.Trial__c,r.Trial__r.Name, r.TrialPatient__c, r.SystemModstamp, r.Surgeon__c, r.Status__c, r.Site__c, r.Screening_Informed_Consent_Date__c, r.SSN__c, r.Registration_Date__c, r.RecordTypeId, r.Radiology_Coordinator__c, r.Radiology_Coordinator_Phone__c, r.Radiology_Coordinator_Fax__c, r.Radiology_Coordinator_Email__c, r.Race__c, r.Phase__c, r.Patient__c, r.Patient_Initials__c, r.Oncologist__c, r.Name, r.Middle_Name__c, r.Last_Name__c, r.LastModifiedDate, r.LastModifiedById, r.LastActivityDate, r.Lab__c, r.IsDeleted, r.Institution__c, r.Initials__c, r.Id, r.ISPY2_Subject_Id__c, r.IRB_Approval_Date__c, r.HIPPA_Consent_Date__c, r.Gender__c, r.First_Name__c, r.Ethnicity__c, r.CreatedDate, r.CreatedById, r.Country_of_birth__c, r.CompletedDate__c, r.Clinical_Coordinator__c, r.Clinical_Coordinator_Phone__c, r.Clinical_Coordinator_Fax__c, r.Clinical_Coordinator_Email__c, r.CRF__c From Registration__c r where Patient__c =:patientId and Registration__c.Trial__c =: trialId order by LastModifiedDate desc limit 1];
                if(!registrationObjList.isEmpty()) {
                    registrationObj = registrationObjList.get(0);
                    selectedInstitution = registrationObj.Institution__c;
                    system.debug('__selectedInstitutionRegistration__'+selectedInstitution);
                    selectedSite = registrationObj.Site__c;
                }
            }
        }*/
        
        /*instIdSiteIdMap = new Map<Id, List<Selectoption>>();
        if(registrationObj.Id == null) {
            List<InstitutionUser__c> userAssociations = [Select i.User__c, i.Trial__c, i.SystemModstamp, i.Site__c, i.Site__r.Name, i.Name, i.Last_Name__c, i.LastModifiedDate, i.LastModifiedById, i.IsDeleted, i.Institution__c,i.Institution__r.Name, i.Id, i.First_Name__c, i.CreatedDate, i.CreatedById From InstitutionUser__c i where i.User__c = :Userinfo.getUserId() and Site__r.RecordType.Name = 'Site'];
            System.debug('__userAssociations__'+userAssociations);
            System.debug('__userAssociations.size__'+userAssociations.size());
            if(userAssociations.size() > 1) {
                userAssociatedWithMultipleSites = true;
                
                Selectoption firstSO;
                //instIdSiteIdMap = new Map<Id, List<Selectoption>>();
                
                Set<Id> countedInstIds = new Set<Id>();
                for(InstitutionUser__c iu : userAssociations) {
                    System.debug('__iu.Institution__c__'+iu.Institution__c);
                    //System.debug('__countedInstIds.add(iu.Institution__c)__'+countedInstIds.add(iu.Institution__c));
                    System.debug('__iu.Institution__r.Name__'+iu.Institution__r.Name);
                    if(iu.Institution__c != null && iu.Institution__r.Name != null) {
                        countedInstIds.add(iu.Institution__c);
                        
                    }
                    List<Selectoption> instSiteOptions = instIdSiteIdMap.get(iu.Institution__c);
                    System.debug('__instSiteOptionsBefore__'+instSiteOptions);
                    if(instSiteOptions == null) {
                        instSiteOptions = new List<Selectoption>();
                        firstSO = new Selectoption('', 'Select Site');
                        instSiteOptions.add(firstSO);
                        instIdSiteIdMap.put(iu.Institution__c, instSiteOptions);
                        System.debug('__instSiteOptions__'+instSiteOptions);
                    }
                    System.debug('__instIdSiteIdMap__'+instIdSiteIdMap);
                    Boolean isSiteAdded = false;
                    for(Selectoption so : instIdSiteIdMap.get(iu.Institution__c)) {
                        system.debug('__so.getValue()__'+so.getValue());
                        if(so.getValue() != '' && so.getValue() == iu.Site__c) {
                            isSiteAdded = true;
                        }
                    }
                    if(iu.Site__c != null && iu.Site__r.Name != null && !isSiteAdded) {
                        Selectoption siteSO = new Selectoption(iu.Site__c, iu.Site__r.Name);
                        instSiteOptions.add(siteSO);
                    }
                }
               
                showSitesForInstitute();
            } else {
                //userAssociatedWithMultipleInstitutions = false;
                userAssociatedWithMultipleSites = false;
                //selectedInstitution = userAssociations[0].Institution__c;
                //system.debug('__selectedInstitutionElse__'+selectedInstitution);
                selectedSite = userAssociations[0].Site__c;
                instituteUsreObj = userAssociations[0];
             }
        }*/
        isComplete = CRFUtilities.isReadOnlyUsr();
        System.debug('isComplete:'+isComplete);
        String crfId = registrationObj.CRF__c;
        System.debug('-----crfId----->'+crfId);
        if(crfId != null && crfId != '') {
            String status = CRFUtilities.CRFStatus(crfId);
            if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected') {
                System.debug('-----status----->'+status);
                currentTab = 'CompleteTab';
                isComplete = false;
            } 
        }
        
        if(isxmlpage != null) {
            List<Attachment> lstAtt = [select Body from Attachment where ParentId = :registrationObj.Id order by CreatedDate DESC];
            if(!lstAtt.isEmpty()) {
                //xmlOutput = Encodingutil.base64Encode(lstAtt[0].Body);
                xmlOutput = lstAtt[0].Body.toString();
                system.debug('--Controller-lstAtt[0].Body.toString--'+lstAtt[0].Body.toString());
                IsXMLGenerated = true;  
            } else {
                IsXMLGenerated = false;
            }
        }
        
        System.debug('isComplete:'+isComplete);
        System.debug('currentTab:'+currentTab);
    }
    
     public pagereference redirect(){
            pagereference redirect = new pagereference('/apex/RegistrationPdf?id='+regidValue);
            redirect.setRedirect(true);
            return redirect;
     }        
       
    //-----------------------delete button fuctionlity- start------------------------- 
    Public void Isdelete(){
    //Id id = ApexPages.currentPage().getParameters().get('id');
    if(regidValue != null){
    Registration__c DeleteVal= [Select Status__c from Registration__c where id=:regidValue order by LastModifiedDate desc limit 1];
    system.debug('####' + DeleteVal);
     system.debug('@@@' + DeleteVal.Status__c);
    if(DeleteVal.Status__c != 'Not Completed'){
    IsDelete= true;
    }
    }
    }
    //-----------------------delete button fuctionlity- start-------------------------
    
    /*public void showSitesForInstitute() {
        //system.debug('__selectedInstitution__'+selectedInstitution);
        system.debug('__instIdSiteIdMap__'+instIdSiteIdMap);
        //String instId = Apexpages.currentPage().getParameters().get('instId');
        sites = instIdSiteIdMap.get(selectedInstitution);
        if(sites != null && sites.size() > 1) {
            userAssociatedWithMultipleSites = true;
        } else {
            userAssociatedWithMultipleSites = false;
        }
    } */
    
    public Pagereference next(){
        String nextTabValue = ApexPages.currentPage().getParameters().get('nextTab');
        if(nextTabValue != null) {
            nextTabName = nextTabValue;
        }
        system.debug('__nextTabValue__'+nextTabValue);
        system.debug('__nextTabName__'+nextTabName);
        system.debug('__currentTab__'+currentTab);
        // TissueSpecimenDetail__c tsSpecimenDetail;
        //System.debug('====== TissueSpecimenFormId=======' + tsSpecimenId );
      
                if(regidValue != null){
                      Registration__c DeleteVal= [Select Trial__c,Status__c from Registration__c where id=:regidValue order by LastModifiedDate desc limit 1];
                    if(DeleteVal.Status__c == 'Approval Not Required'){
                    //System.debug('====bloodSpecimen===='+bloodSpecimen);
                    //System.debug('====bldSpecimenForm.Status__c===='+bldSpecimenForm.Status__c);
                    //System.debug('====bloodSpecimen===='+bloodSpecimen);
                    isComplete= false;
                    currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/Registration?id='+regidValue);
                Pagereference ref = new Pagereference('/'+regidValue);
                ref.setRedirect(true);
                return ref;
             }
             }
        
        
        if(currentTab == 'PatientTab') {
             // Added by Shruti (DE401)
            try {
                update patientObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/Registration?id='+regidValue);
               Pagereference ref = new Pagereference('/'+regidValue);
            ref.setRedirect(true);
             return ref;             
                        
            } 
            // Added by Shruti (DE401)
            
        } else if(currentTab == 'RegistrationTab') {
            
            if(registrationObj.Registration_Date__c > system.today()) {
                registrationObj.Registration_Date__c.addError('Future date is not allowed.');
                return null;
            }
            
            if(registrationObj.IRB_Approval_Date__c > system.today()) {
                registrationObj.IRB_Approval_Date__c.addError('Future date is not allowed.');
                return null;
            }
            
            if(registrationObj.Screening_Informed_Consent_Date__c > system.today()) {
                registrationObj.Screening_Informed_Consent_Date__c.addError('Future date is not allowed.');
                return null;
            }
            
            if(registrationObj.HIPPA_Consent_Date__c > system.today()) {
                registrationObj.HIPPA_Consent_Date__c.addError('Future date is not allowed.');
                return null;
            }
            
            /*if(selectedSite == null){
                registrationObj.addError('Please make sure you have selected site.');
                return null;
            }*/
            
            //registrationObj.Institution__c = selectedInstitution;
            //registrationObj.Site__c = selectedSite;
            //system.debug('__registrationObj.Institution__c__'+registrationObj.Institution__c);
            //system.debug('__registrationObj.Site__c__'+registrationObj.Site__c);
            //if(registrationObj.Id == null ) {
            //  registrationObj.ISPY2_Subject_Id__c = generateISPYSubjectId();
            //}
            //system.debug('ISPY ID : '+registrationObj.ISPY2_Subject_Id__c);
            RequiredFieldHandler.fromDataLoader = true;
            // Added by Shruti (DE401)
            try {
                upsert registrationObj;
                regidValue=registrationObj.id;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/Registration?id='+regidValue);
             Pagereference ref = new Pagereference('/'+regidValue);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)            
            system.debug('__registrationObj.Id__'+registrationObj.Id);
        }
        
        if(nextTabName == 'saveAndClose') {
            RequiredFieldHandler.fromDataLoader = true; //this is for, not to check IRB Approval Date, Screening Informed Consent Date, HIPPA Consent Date validation
          //  if(currentTab == 'RegistrationTab') {
            if(currentTab == 'RegistrationTab' || currentTab == 'CompleteTab') {
                registrationObj.First_Save_and_Close__c = true;
                // Added by Shruti (DE401)
            try {
                upsert registrationObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/Registration?id='+regidValue);
             Pagereference ref = new Pagereference('/'+regidValue);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)                 
            }
            //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+patientObj.Id+'&TrialId='+trialId+'&sfdc.override=1');
            Pagereference pr = new Pagereference('/apex/TranscendPage?id='+patientObj.Id+'&TrialId='+registrationObj.Trial__c);
           
            pr.setRedirect(true);
            return pr;
        }
        currentTab = nextTabName;
        system.debug('__currentTab__'+currentTab);
        return null;
    }
    
    public static String generateISPYSubjectId() {
        List<Integer> lstSubjId = new List<Integer>();
        Set<Integer> setSubjId = new Set<Integer>();
        List<Registration__c> lstRegistration = [Select r.ISPY2_Subject_Id__c, r.Effective_Time__c From Registration__c r where ISPY2_Subject_Id__c != null order by LastModifiedDate desc limit 1];
        for(Registration__c reg : lstRegistration) {
            lstSubjId.add(Integer.valueOf(reg.ISPY2_Subject_Id__c));
            setSubjId.add(Integer.valueOf(reg.ISPY2_Subject_Id__c));
        }
        lstSubjId.sort();
        integer sId = lstSubjId.get(0);
        if(sId == null) {
            sId = 0;
        }
        while(setSubjId.contains(sId)) {
            sId += 1;   
        }
        
        String subjectId = '';
        if(sId != null) {
            subjectId = String.valueOf(sId);
            system.debug('subjectId : '+subjectId);
            if(subjectId.length() == 1) {
                subjectId = '0000'+subjectId;
            } else if(subjectId.length() == 2) {
                subjectId = '000'+subjectId;
            } else if(subjectId.length() == 3) {
                subjectId = '00'+subjectId;
            } else if(subjectId.length() == 4) {
                subjectId = '0'+subjectId;
            }
            system.debug('subjectId : '+subjectId);
        }
        
        
        return subjectId;
    }
    
    // public void previous() {
       public Pagereference previous(){ //Added by Shruti (DE401)
        system.debug('__currentTab__'+currentTab);
        String prevTabValue = Apexpages.currentPage().getParameters().get('prevTab');
        system.debug('__prevTabValue__'+prevTabValue);
        currentTab = prevTabValue;
        //currentTab = nextTabName;
        // Added by Shruti (DE401)
        if(regidValue != null){
                    Registration__c DeleteVal= [Select Status__c from Registration__c where id=:regidValue order by LastModifiedDate desc limit 1];
                    if(DeleteVal.Status__c == 'Approval Not Required'){
                    //System.debug('====bloodSpecimen===='+bloodSpecimen);
                    //System.debug('====bldSpecimenForm.Status__c===='+bldSpecimenForm.Status__c);
                    //System.debug('====bloodSpecimen===='+bloodSpecimen);
                    isComplete= false;
                    currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/Registration?id='+regidValue);
                Pagereference ref = new Pagereference('/'+regidValue);
                ref.setRedirect(true);
                return ref;
             }
             }
        /*    try {
                update patientObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/Registration?id='+regidValue);
             Pagereference ref = new Pagereference('/'+regidValue);
            ref.setRedirect(true);
             return ref;             
            }*/
             return null; 
            // Added by Shruti (DE401)
    }
  
 //===========================customCancel used for delete record in Registration===========================================    
    public Pagereference customCancel() {
    	
        //String patientId = ApexPages.currentPage().getParameters().get('patientId');
        system.debug('__patientId__'+patientId);
     if(regidValue != null){
    Registration__c DeleteVal= [Select Status__c from Registration__c where id=:regidValue order by LastModifiedDate desc limit 1];
    system.debug('####' + DeleteVal);
     system.debug('@@@' + DeleteVal.Status__c);
    if(DeleteVal.Status__c == 'Approval Not Required'){
                    
                      if(profileName !='System Administrator'){
                    //isComplete= false;
                   // currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/Registration?id='+regidValue);
                Pagereference ref = new Pagereference('/'+regidValue);
                ref.setRedirect(true);
                return ref;
             }
             else
                                 {   
                                delete registrationObj;
                                
                                 }
             
             }
             else
                                 {   
                                 delete registrationObj;
                                
                                 }
             }
        
     /*   if(registrationObj.Id != null) {
            try {
                delete registrationObj;
                system.debug('__registrationObj__'+registrationObj);
            } catch(Exception e) {
                system.debug('__Registration Error__'+e);
                //Added by Shruti (DE401)
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/Registration?id='+regidValue);
             Pagereference ref = new Pagereference('/'+regidValue);
            ref.setRedirect(true);
             return ref;
             //Added by Shruti (DE401)  
            }
        }*/
        
        System.debug('-----Deleted---->');
        Pagereference pr = new Pagereference('/apex/TranscendPage?id='+patientId+'&TrialId='+trialId+'&sfdc.override=1');
       // Pagereference pr = new Pagereference('/apex/TranscendPage?id='+patientId+'?TrialId='+trialid);
        return pr;
    }
    
//===========================Sign And Submit for Site User in AE CRF===========================================         
    public Pagereference signAndSubmit() {
                Boolean isValidReg = registrationTabValidation();
                system.debug('__isValidReg__'+isValidReg);
                if(registrationObj.HIPPA_Consent_Date__c == null) {
                    registrationObj.HIPPA_Consent_Date__c.addError('HIPPA Consent Date field is required.');
                    isValidReg = false;
                } 
                
                if(registrationObj.IRB_Approval_Date__c == null) {
                    registrationObj.IRB_Approval_Date__c.addError('IRB Approval Date field is required.');
                    isValidReg = false;
                } 
                
                if(registrationObj.Screening_Informed_Consent_Date__c == null) {
                    registrationObj.Screening_Informed_Consent_Date__c.addError('Screening Informed Consent Date field is required.');
                    isValidReg = false;
                } 
                
                if(!isValidReg) {
                    currentTab = 'RegistrationTab';
                    return null;
                }
                String currentUserId = UserInfo.getUserId();
            for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
            }
            try {
                //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
                //completeCrf.customAdhoc(registrationObj.Id+'', 'submit', ','); 
                //start Amit
               /* String id = Apexpages.currentPage().getParameters().get('id');
                String keyCode  = id.subString(0,3);
                String recordObjectName = '';
                  Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
                  for(Schema.SObjectType objectInstance : gd.values()) {
                    if(objectInstance.getDescribe().getKeyPrefix() == keyCode) {//do your processing with the API name what you want
                      System.debug('Id is related to object: '+ objectInstance.getDescribe().getName());
                      String objectName = objectInstance.getDescribe().getName();
                      List<Sobject> recordData = Database.query('select Id from '+objectName+' where Id = \''+id+'\'');
                      System.debug('data of '+objectName+' : '+recordData);
                      if(!recordData.isEmpty()) {
                        recordObjectName = objectName;
                        break;
                      }
                    }
                  } */
                //string ObjName = 'Registration__c';
                //List<PreEligibility_Checklist__c> checkList = [Select Id, Patient_is_eligible_to_be_screened_for_t__c,Patient_signed_up_for_I_SPY2_screening__c from PreEligibility_Checklist__c where Patient__c=:registrationObj.Patient__c and /*Patient_is_eligible_to_be_screened_for_t__c= True and*/ Patient_signed_up_for_I_SPY2_screening__c=True];
                //if(!checkList.isEmpty()){
                   // submitRegistration();
                   //GenerateCalloutController c = new GenerateCalloutController();
                   //c.submitRegistration(ObjName,registrationObj,patientId,trialId);
                //}
                //end amit
                system.debug('registrationObj : '+registrationObj);
                SignAndSubmitController signSubmit = new SignAndSubmitController();
                signSubmit.password = password;
                Pagereference ref = signSubmit.signAndSubmit('00003','',registrationObj.Id+'', 'Site');
                system.debug('errorMsg :  '+signSubmit.errorMsg);
                errorMsg = signSubmit.errorMsg;
                msgColor = 'Red';
                //if no error in signing and submit, call webservice
                //Start of webservice call out
                if(errorMsg==null || errorMsg.trim().equals('')){
                    //submitRegistration();
                    List<TrialPatient__c> lstTrialPatient = [select Id from TrialPatient__c where Patient_Id__c = :registrationObj.Patient__c and Trial_Id__c = :registrationObj.Trial__c];
                    if(!lstTrialPatient.IsEmpty()) {
                        //caTissueIntegration.createParticipant_FutureCall(registrationObj.TrialPatient__c);
                    }
                }
                 
                //End of webservice call out
                
                
                List<Registration__c> regList = [Select Status__c from Registration__c where id = :registrationObj.Id and Status__c='Approval Not Required'];
                if(!regList.isEmpty()){
                    String ObjName = 'Registration__c';
                    List<PreEligibility_Checklist__c> checkList = [Select Id, Patient_is_eligible_to_be_screened_for_t__c,Patient_signed_up_for_I_SPY2_screening__c from PreEligibility_Checklist__c where Patient__c=:registrationObj.Patient__c and /*Patient_is_eligible_to_be_screened_for_t__c= True and*/ Patient_signed_up_for_I_SPY2_screening__c=True];
                    if(!checkList.isEmpty()){
                       GenerateCalloutController.submitRegistration(ObjName,registrationObj.Id,patientId,trialId);
                    }
                   
                }
                
                return ref;
            } catch (Exception e) {
                system.debug('error: '+e);
                return null;
            }
    }
    
    public String msgColor {get;set;}
    public void resendCode() {
        SignAndSubmitController ctr = new SignAndSubmitController();
        ctr.resendCode();
        errorMsg = 'Code Sent! Please check your Email.';
        msgColor = 'Green';
    }
    
    private Boolean registrationTabValidation() {
        Boolean isValidFlag = true;
        if(registrationObj.Registration_Date__c == null) {
            registrationObj.Registration_Date__c.addError('Please enter Registration Date.');
            isValidFlag = false;
        }
        
        /*if(registrationObj.ACRIN_6693_MRS_Participant__c == null) {
            registrationObj.ACRIN_6693_MRS_Participant__c.addError('Please select ACRIN 6698 protocol question.');
            isValidFlag = false;
        } */
        
        /*if(selectedInstitution == null) {
            registrationObj.addError('Please select institution.');
            isValidFlag = false;
        }*/
        
        /*if(selectedSite == null) {
            registrationObj.addError('Please select site.');
            isValidFlag = false;
        }*/
        return isValidFlag;
    }
    
    //================================Registration XML generation process=============================================================
    public void viewXML() {        
        ExternalServiceConnector.viewXML(generateXML(), registrationObj.Id, 'RegistrationXML ');
    }
    
    public String generateXML() {       
      
     
        ExternalServiceConnector serviceConnector = new ExternalServiceConnector('iHub');
        
        cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
        cdapackage.author author = new cdapackage.author();
        cdapackage.patient patient = new cdapackage.patient();
        String xmlType = (radioValue==null? 'CDA' : radioValue);
        author.idExtension = UserInfo.getUserName();
        
        clinicalDoc.id=registrationObj.id;
        clinicalDoc.title = 'Create Participant Registration';
        if(registrationObj.Effective_Time__c!=null){
            clinicalDoc.effectiveTime=String.valueOf(registrationObj.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
        }
        clinicalDoc.siteIdentifier= registrationObj.Site__r.Name;
        clinicalDoc.siteIdRoot='2.16.840.1.113883.3.26.1.7';      
        clinicalDoc.studyId=registrationObj.Trial__r.Name ;
        clinicalDoc.studyIdRoot='2.16.840.1.113883.3.26.1.7' ;
        
        List<Patient_Custom__c> patientObjList = [Select  p.Name,p.mrn__c,p.Birthdate__c, p.Zip__c, p.SSN__c, p.Race__c, p.Middle_Name__c, p.Medical_Record_Number__c, p.Last_Name__c, p.Institution__c, p.Institute_Text__c, p.Initials__c, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.Country_of_Birth__c From Patient_Custom__c p where Id =:patientId limit 1];
        if(!patientObjList.isEmpty()) {
            Patient_Custom__c patientObj = patientObjList.get(0);
            patient.MRN = patientObj.Medical_Record_Number__c; 
            patient.givenName=patientObj.First_Name__c;
            patient.familyName=patientObj.Last_Name__c;
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
            patient.ethinicity=patientObj.Ethnicity__c;


            if(patientObj.Ethnicity__c=='Not Hispanic or Latino'){
                patient.ethinicityCode='2186-5';
            }else if(patientObj.Ethnicity__c=='Hispanic or Latino'){
                patient.ethinicityCode='2135-2';
            }else{
                patient.ethinicityCode='N/A';
            }
        }
        clinicalDoc.studySubjectIdentifier=registrationObj.ISPY2_Subject_Id__c ;
       
        
        try{
            if(Test.isRunningTest()) {
                xmlOutput= '<xml>Test XML</xml>';
            }else{
                
                xmlOutput = serviceConnector.ihub.generatePatientCDA(clinicalDoc,author,patient,xmlType);
                System.debug('xmlOutput='+xmlOutput);
            }
        }catch(Exception e){
            System.debug(e);
        }
        System.debug(xmlOutput);
        //End of webservice callout
        
        
        return xmlOutput;
    }
        
    public Pagereference downloadXML() {
        //generateXML();
        List<Attachment> lstAtt = [select Body from Attachment where ParentId = :registrationObj.Id order by CreatedDate DESC];
        if(!lstAtt.isEmpty()) {
            xmlOutput = Encodingutil.base64Encode(lstAtt[0].Body);
        }
        Pagereference ref = new Pagereference('/apex/Registration_XML_Page');
        //ref.setRedirect(true);
        return ref;
    }
    @isTest public static void test1(){
        
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='Registration__c');
        insert crfMaster;
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='Asian',Gender__c='Male',Ethnicity__c='Hispanic or Latino');
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
        reg.Trial__c = tri.Id;
        reg.Institution__c = a.Id;
        reg.Site__c = site1.Id;
        reg.IRB_Approval_Date__c = system.today();
        reg.HIPPA_Consent_Date__c = system.today();
        reg.Screening_Informed_Consent_Date__c = system.today();
        reg.Status__c = 'Accepted';
        reg.Effective_Time__c = system.now();
        reg.ISPY2_Subject_Id__c = ''+123;
        insert reg;
        /*
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Name = 'Race';
        insert snomedObject;
        
        Pre_Registration_Snomed_Codes__c preObject = new Pre_Registration_Snomed_Codes__c();
        preObject.Patient__c = p.Id;
        preObject.Code_Master__c = snomedObject.id;
        insert preObject;
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Name = 'Ethn';
        insert snomedObject2;
        
        Pre_Registration_Snomed_Codes__c preObject2 = new Pre_Registration_Snomed_Codes__c();
        preObject2.Patient__c = p.Id;
        preObject2.Code_Master__c = snomedObject2.id;
        insert preObject2;*/
        
        Apexpages.currentPage().getParameters().put('isxmlpage','test');
        ApexPages.currentPage().getParameters().put('patientId',p.Id);   
        Apexpages.currentPage().getParameters().put('trial',tri.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(reg);
        Registration regObj1 = new Registration(controller);
        regObj1.registrationObj = reg;
        
        Test.startTest();
        string ObjName = 'Registration__c';
        //GenerateCalloutController crf = new GenerateCalloutController();
        //crf.submitRegistration(ObjName,reg,p.Id,tri.Id);
        //regObj1.submitRegistration();
        regObj1.generateXML();
        //GenerateCalloutController.populateFailedRegistration(ObjName,reg.Id,p.id, t.id, site1.Id,null, 'errorCode', 'Error message', 'Failure','System', '123','1000','100');
        Test.stopTest();
    }
}