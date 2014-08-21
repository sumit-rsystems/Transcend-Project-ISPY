public with sharing class TissueSpecimenFormController {
        public String errorMsg {get;set;}
        public String recordURL {get;set;}
        public String password {get;set;}
        public Boolean isErrorMsg {get;set;}
        public boolean showReasonSec {get;set;}
        public String trialPatientId = '';
        public String trialPatient {get;set;}
        public String patientId {get;set;}
        public String tsId {get;set;}
        List<Core_Biopsy_Specimens__c> lstCoreBiopsy = new List<Core_Biopsy_Specimens__c>();
        public TissueSpecimenDetail__c tissueSpecimenForm {get;set;}
        public List<CoreBiopsyWrapper> lstCoreBiopsyWrapper {get;set;}
        public integer coreBiopsyNumber = 0;
        public String currentTab {get;set;}
        public Boolean isComplete {get;set;}
        public String nextTabName{get;set;}  
        public TrialPatient__c trialPatientObj {get;set;}
        //added by amit
        public String radioValue{get;set;}
        public String xmlOutput{get;set;}
        private string isxmlpage {get;set;}
        public String profileName{get;set;}  // For Delete //
        public Boolean isDelete{get;set;}    // For Delete //
        public Id tsSpecimenId;
        
        public pagereference redirect(){
            pagereference redirect = new pagereference('/apex/TissueSpecimenPdf?id='+tsSpecimenId);
            redirect.setRedirect(true); 
            return redirect;
        }
        
        public void viewXML() {
         
            System.debug('Amit======================witin ViewXML');
            
            try{
                cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
                cdapackage.author author = new cdapackage.author();
                cdapackage.patient patient = new cdapackage.patient();
                cdapackage.procedure procedure = new cdapackage.procedure();
                cdapackage.guidanceMethod[] guidanceArray;// = new cdapackage.guidanceMethod[]{};
                cdapackage.specimen[] specimenArray;
                String xmlType = (radioValue==null? 'CDA' : radioValue);
                
                author.idExtension = UserInfo.getUserName();
                 
                clinicalDoc.id=tissueSpecimenForm.id;
                clinicalDoc.title = 'Create Biospecimen';
                if(tissueSpecimenForm.Effective_Time__c!=null){
                    clinicalDoc.effectiveTime=String.valueOf(tissueSpecimenForm.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
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
                
                
                procedure.studyIdentifier=trialPatientObj.Trial_Id__c ;
                procedure.activityStatus='Active';
                procedure.activityStatusCode='55561003';
                //procedure.availableQuantity='1';
                //procedure.initialQuantity='1';
                procedure.barcode='1098';
                //procedure.collectionProtocolShortTitle=trialPatientObj.Trial_Id__r.Name;
                //procedure.collectionProtocolTitle=trialPatientObj.Trial_Id__r.Name;
                //procedure.specimenCharacteristicsSide='Right';
                //procedure.specimenCharacteristicsSideCode='24028007';
                //procedure.specimenCharacteristicsSite='breast';
                
                procedure.collectionProtocolShortTitle='Needle Core Biopsy';
                procedure.collectionProtocolTitle='Needle Core Biopsy';
                procedure.specimenCharacteristicsSide='Right';
                procedure.specimenCharacteristicsSideCode='24028007';
                procedure.specimenCharacteristicsSite='Not Specified';
                procedure.specimenClass='Tissue';
                procedure.specimenClassCode='119376003';
        
                //procedure.specimenType='Tissue';
                //procedure.specimenTypeCode='119376003';
                //procedure.specimenClass='Tissue';
                //procedure.specimenClassCode='119376003';
                //procedure.studyCalendarEventTimePoint=tissueSpecimenForm.Time_Point__c;
                if(tissueSpecimenForm.ProcedureDate__c!=null){
                    procedure.collectionDate =String.valueOf(tissueSpecimenForm.ProcedureDate__c).replaceAll('-','').replaceAll(' ','');
                }
                
                if(tissueSpecimenForm.Guidance_Method_s__c != null){
                List<String> stringList = tissueSpecimenForm.Guidance_Method_s__c.split('\\;');
                guidanceArray = new cdapackage.guidanceMethod[stringList.size()];
                for(Integer i=0;i<stringList.size();i++) {
                    String s = stringList[i];
                    cdapackage.guidanceMethod gm = new cdapackage.guidanceMethod();
                    
                    gm.valueDisplayName=s;
                    gm.valueOriginalText=s;
                    if(s=='Ultrasound'){
                        gm.valueCode='16310003';
                    }else if(s=='MRI'){
                        gm.valueCode='241615005';
                    }else if(s=='Stereotactic'){
                        gm.valueCode='258172002';
                    }else if(s=='Mammography'){
                        gm.valueCode='71651007';
                    }else if(s=='Palpation guided'){
                        gm.valueCode='113011001';
                    }else{
                        gm.valueCode='N/A';
                    }
                   
                    guidanceArray[i] = gm;
                }
                }
                
                List<Core_Biopsy_Specimens__c> coreBiopsyList = [Select c.TissueSpecimenDetail__c, c.SystemModstamp, c.SpecimenID__c, c.Shipped__c, c.Reason_samples_not_shipped__c, c.Other_Reason_samples_not_shipped__c, c.Name, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.Effective_Time__c, c.CreatedById, c.Core_Specimen__c From Core_Biopsy_Specimens__c c where TissueSpecimenDetail__c = :tissueSpecimenForm.Id and  Shipped__c='Yes'];
                specimenArray = new cdapackage.specimen[coreBiopsyList.size()];
                for(Integer i=0;I<coreBiopsyList.size();i++){
                    Core_Biopsy_Specimens__c specimen = coreBiopsyList[i];
                    cdapackage.specimen sp= new cdapackage.specimen();
                    sp.specimenID = specimen.SpecimenID__c;
                    sp.specimenDisplayName='Frozen Tissue';
                    sp.specimenCode = 'N/A';
                    sp.availableQuantity='1';
                    sp.availableQuantityUnit='mg';    
                    sp.initialQuantity='1';
                    sp.initialQuantityUnit='mg';
                    
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
                    //sp.studyCalendarEventTimePoint;
                    sp.studyCalendarEventTimePointUnit=''; 
                    
                    specimenArray[i]=sp;
                }
                
                ExternalServiceConnector serviceConnector = new ExternalServiceConnector('iHub');
                
                if(Test.isRunningTest()) {
                    xmlOutput= '<xml>Test XML</xml>';
                }else{
                    xmlOutput = serviceConnector.ihub.generateBioCDA(clinicalDoc ,author,patient,procedure,specimenArray,guidanceArray ,xmlType);
                }
                System.debug('xmlOutput='+xmlOutput);
                
                if(xmlOutput!=null){
                    ExternalServiceConnector.viewXML(xmlOutput, tissueSpecimenForm.Id,'TissueSpecimenXML ');
                }
                
            }catch(Exception e){
                System.debug(e);
            }
            System.debug(xmlOutput);
        }
        //end adedd by amit
        
        public integer getcoreBiopsyNumber() {
                return coreBiopsyNumber;
        }
        
        public TissueSpecimenFormController(Apexpages.StandardController std) {
                System.debug('tissueSpecimenForm-------'+std.getId());
                tsSpecimenId = std.getId();
                TissueSpecimenDetail__c tsSpecimenDetail;
                if(tsSpecimenId != null)tsSpecimenDetail = [Select t.TrialPatient__c From TissueSpecimenDetail__c t where id =: tsSpecimenId];
                //-----------------------delete button fuctionlity- start-------------------------
                IsDelete = false;
                IsDelete();
                if(IsDelete){
                String currentUserId = UserInfo.getUserId();
                for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
                    profileName = u.Profile.Name; 
                }  
                }
                //-----------------------delete button fuctionlity- start-------------------------
                //currentTab = 'Core BiopsyTab';
                isxmlpage = Apexpages.currentPage().getParameters().get('isxmlpage');
                if(tsSpecimenDetail != null){
                    trialPatientId = tsSpecimenDetail.TrialPatient__c;
                    tsId = tsSpecimenDetail.id;
                }else{
                    trialPatientId = Apexpages.currentPage().getParameters().get('trialPat'); 
                    tsId = Apexpages.currentPage().getParameters().get('tsId'); 
                }
                System.debug('trialPatientId----------------'+trialPatientId);
                List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name,Trial_Id__c,Subject_Id__c ,Site__c,Site__r.Name from TrialPatient__c where Id = :trialPatientId];
                System.debug('lstTrialPatient----------------'+lstTrialPatient);
                if(!lstTrialPatient.IsEmpty()) {
                        trialPatient = lstTrialPatient[0].Name;
                        trialPatientObj = lstTrialPatient[0];
                        patientId = lstTrialPatient[0].Patient_Id__c;
                }
                showReasonSec = true;
                isComplete = true;
                tissueSpecimenForm = new TissueSpecimenDetail__c();
                lstCoreBiopsyWrapper = new List<CoreBiopsyWrapper>();
                List<TissueSpecimenDetail__c> lstTSD = [Select t.Root_CRF_Id__c,t.TrialPatient__r.Id,t.CRFId__c, t.TrialPatient__c, t.PatientConsentedStudy__c, t.PatientConsentedOutsideStudy__c,t.Effective_Time__c,t.Time_Point__c,t.Guidance_Method_s__c From TissueSpecimenDetail__c t where Id = :tsId order by Effective_Time__c DESC];
                if(!lstTSD.isEmpty()) {
                        tissueSpecimenForm.PatientConsentedStudy__c = lstTSD[0].PatientConsentedStudy__c;
                        tissueSpecimenForm.PatientConsentedOutsideStudy__c = lstTSD[0].PatientConsentedOutsideStudy__c;
                        tsId = lstTSD[0].Id;
                        system.debug('__lstTSD.isEmpty()__'+lstTSD.isEmpty());
                        editTissueSpecimenForm();
                }
                
                if(std.getId() != null) {
                        tsId = std.getId();
                        system.debug('__std.getId()__'+std.getId());
                        //if(tsId != null) {
                                editTissueSpecimenForm();
                        //}
                }
                isComplete = CRFUtilities.isReadOnlyUsr();
                if(tissueSpecimenForm != null){
                        //String crfId = tissueSpecimenForm.CRFId__c;
                        //if(crfId != null && crfId != ''){
                            //String status = CRFUtilities.CRFStatus(crfId);
                            String status = tissueSpecimenForm.Status__c;
                            if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                                    integer coreBiopsyNumber = 0;
                                    /*List<Core_Biopsy_Specimens__c> tmpCoreBiopsyList = [Select c.TissueSpecimenDetail__c, c.SystemModstamp, c.SpecimenID__c, c.Shipped__c, c.Reason_samples_not_shipped__c, c.Other_Reason_samples_not_shipped__c, c.Name, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.Effective_Time__c, c.CreatedById, c.Core_Specimen__c From Core_Biopsy_Specimens__c c where TissueSpecimenDetail__c = :tissueSpecimenForm.Id order by Effective_Time__c DESC];
                                    for(Core_Biopsy_Specimens__c cbs : tmpCoreBiopsyList) {
                                            if(cbs.Shipped__c != null) {
                                                    CoreBiopsyWrapper cbWrapper = new CoreBiopsyWrapper(); 
                                                    cbWrapper.coreBiopsySpecimen = cbs;
                                                    cbWrapper.isCollected = true;
                                                    cbWrapper.coreBiopsyNumber = 'Core Specimen #'+(++coreBiopsyNumber)+' (Frozen)';
                                                    cbWrapper.isShippedDisabled = false;
                                                    lstCoreBiopsyWrapper.add(cbWrapper);
                                            }
                                    }*/
                                    currentTab = 'CompleteTab';
                                    isComplete = false; 
                            } else {
                                    currentTab = 'Core BiopsyTab';
                            }
                        //}
                }
                
                if(isxmlpage != null) {
                    List<Attachment> lstAtt = [select Body from Attachment where ParentId = :tissueSpecimenForm.Id order by CreatedDate DESC];
                    if(!lstAtt.isEmpty()) {
                        //xmlOutput = Encodingutil.base64Encode(lstAtt[0].Body);
                        xmlOutput = lstAtt[0].Body.toString();
                        system.debug('--Controller-lstAtt[0].Body.toString--'+lstAtt[0].Body.toString());
                        //IsXMLGenerated = true;  
                    } else {
                        //IsXMLGenerated = false;
                    }
                }
        }
        
      //-----------------------delete button fuctionlity- start-------------------------
      public void isDelete(){
        TissueSpecimenDetail__c tsSpecimenDetail;
        System.debug('====== TissueSpecimenFormId=======' + tsSpecimenId );
        if(tsSpecimenId != null){
        tsSpecimenDetail = [select Id, Status__c from TissueSpecimenDetail__c  where id =: tsSpecimenId];
            
            if(tsSpecimenId != null && tsSpecimenDetail.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
        System.debug('======tsSpecimenDetail =======' +tsSpecimenDetail );
    }
    //-----------------------delete button fuctionlity- end-------------------------
        //===============================For Next tab==========================================================
        public Pagereference next() { 
                system.debug('__currentTab__'+currentTab);
                String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
                Id trialPat = trialPatientId;//Apexpages.currentPage().getParameters().get('trialPat');
                system.debug('__nextTabValue__'+nextTabValue);
                TissueSpecimenDetail__c tsSpecimenDetail;
                System.debug('====== TissueSpecimenFormId=======' + tsSpecimenId );
                if(tsSpecimenId != null){
                    tsSpecimenDetail = [select Id, Status__c,Root_CRF_Id__c from TissueSpecimenDetail__c  where id =: tsSpecimenId];
                    if(tsSpecimenId != null && tsSpecimenDetail.Status__c == 'Approval Not Required'){
                    //System.debug('====bloodSpecimen===='+bloodSpecimen);
                    //System.debug('====bldSpecimenForm.Status__c===='+bldSpecimenForm.Status__c);
                    //System.debug('====bloodSpecimen===='+bloodSpecimen);
                    isComplete= false;
                    currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/TissueSpecimen?id='+tsSpecimenId);
                Pagereference ref = new Pagereference('/'+tsSpecimenId);
                ref.setRedirect(true);
                return ref;
             }
             }
               
                if(nextTabValue != null){
                        nextTabName = nextTabValue;
                }
                
                if(currentTab == 'Core BiopsyTab'){
                        showReasonSec = true; 
                        system.debug('ConsentTab===='+nextTabValue);
                        if(lstCoreBiopsyWrapper != null) {
                                integer sampleCollected = 0;
                                system.debug('ConsentTabif1===='+nextTabValue);
                                for(CoreBiopsyWrapper cbw : lstCoreBiopsyWrapper) {
                                        if(cbw.isCollected && cbw.coreBiopsySpecimen.Shipped__c == 'Yes') {
                                                ++sampleCollected;
                                                system.debug('ConsentTab=if2==='+nextTabValue);
                                        }
                                }
                                 
                                if(tissueSpecimenForm.ProcedureDate__c == null) {
                                        tissueSpecimenForm.ProcedureDate__c.addError('Please provide Procedure Date.');
                                        return null;
                                } else if(tissueSpecimenForm.ProcedureDate__c > system.today()) {
                                        tissueSpecimenForm.ProcedureDate__c.addError('Future dates are not allowed.');
                                        return null;
                                }
                                
                                if(tissueSpecimenForm.Time_Point__c == 'Pre-Treatment' && sampleCollected < 4 && tissueSpecimenForm.Reason_all_samples_not_collected__c == null) {
                                        showReasonSec = false;
                                        system.debug('====addError===');
                                        tissueSpecimenForm.Reason_all_samples_not_collected__c.addError('Please provide reason "why all samples are not collected?"');
                                        return null;
                                } else if(tissueSpecimenForm.Time_Point__c == 'Early Treatment' && sampleCollected < 4 && tissueSpecimenForm.Reason_all_samples_not_collected__c == null) {
                                        showReasonSec = false;
                                        tissueSpecimenForm.Reason_all_samples_not_collected__c.addError('Please provide reason "why all samples are not collected?"');
                                        system.debug('====addError===2');
                                        return null ;
                                } else if(tissueSpecimenForm.Time_Point__c == 'Inter-Regimen' && sampleCollected < 4 && tissueSpecimenForm.Reason_all_samples_not_collected__c == null) {
                                        showReasonSec = false;
                                        tissueSpecimenForm.Reason_all_samples_not_collected__c.addError('Please provide reason "why all samples are not collected?"');
                                        system.debug('====addError===3');
                                        return null;
                                } else if(tissueSpecimenForm.Time_Point__c == 'Pre-Treatment Re-Biopsy' && sampleCollected < 4 && tissueSpecimenForm.Reason_all_samples_not_collected__c == null) {
                                        showReasonSec = false;
                                        tissueSpecimenForm.Reason_all_samples_not_collected__c.addError('Please provide reason "why all samples are not collected?"');
                                        system.debug('====addError===4');
                                        return null;
                                } else if(tissueSpecimenForm.Time_Point__c == 'Surgery' && sampleCollected < 2 && tissueSpecimenForm.Reason_all_samples_not_collected__c == null) {
                                        showReasonSec = false;
                                        tissueSpecimenForm.Reason_all_samples_not_collected__c.addError('Please provide reason "why all samples are not collected?"');
                                        system.debug('====addError===5');
                                        return null;
                                } else if(tissueSpecimenForm.Time_Point__c == null) {
                                        system.debug('tissueSpecimenForm.Time_Point__c : '+tissueSpecimenForm.Time_Point__c);
                                        tissueSpecimenForm.Time_Point__c.addError('Please Select Time Point.');
                                        system.debug('====addError===6');
                                        return null;
                                }
                                tissueSpecimenForm.TrialPatient__c = trialPatientId;
                                tissueSpecimenForm.status__c = 'Not Completed';
                                tissueSpecimenForm.Phase__c = 'Screening';
                                tissueSpecimenForm.NumberOfSamplesCollected__c = sampleCollected;
                                // Added by Shruti (DE401)
                                try {
                            upsert tissueSpecimenForm;
                        }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             //Pagereference ref = new Pagereference('/apex/TissueSpecimen?id='+tsSpecimenId);
               Pagereference ref = new Pagereference('/'+tsSpecimenId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)                                
                                system.debug('__tissueSpecimenForm__'+tissueSpecimenForm);
                                system.debug('__tissueSpecimenForm.Id__'+tissueSpecimenForm.Id);
                                
                                List<Core_Biopsy_Specimens__c> lstCoreBiopsy = new List<Core_Biopsy_Specimens__c>();
                                for(CoreBiopsyWrapper coreBiopsy : lstCoreBiopsyWrapper) {
                                        system.debug('--coreBiopsy.coreBiopsySpecimen.Shipped__c--'+coreBiopsy.coreBiopsySpecimen.Shipped__c);
                                        if(coreBiopsy.coreBiopsySpecimen.Shipped__c != null) {
                                                coreBiopsy.isShippedDisabled = false;
                                                if(coreBiopsy.coreBiopsySpecimen.Shipped__c == 'No') {
                                                        coreBiopsy.isReasonDisabled = false;
                                                        if(coreBiopsy.coreBiopsySpecimen.Reason_samples_not_shipped__c == 'Other') {
                                                                coreBiopsy.isOtherDisabled = false;
                                                        } else {
                                                                coreBiopsy.isOtherDisabled = true;
                                                        }
                                                        showReasonSec = false;
                                                } else {
                                                        coreBiopsy.isReasonDisabled = true;
                                                        coreBiopsy.isOtherDisabled = true;
                                                } 
                                        } else {
                                                coreBiopsy.isCollected = false;
                                                coreBiopsy.isShippedDisabled = true;
                                                coreBiopsy.isReasonDisabled = true;
                                                coreBiopsy.isOtherDisabled = true;
                                        }
                                        coreBiopsy.coreBiopsySpecimen.TissueSpecimenDetail__c = tissueSpecimenForm.Id;
                                        lstCoreBiopsy.add(coreBiopsy.coreBiopsySpecimen);
                                }
                                 // Added by Shruti (DE401)
            try {
                upsert lstCoreBiopsy;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             //Pagereference ref = new Pagereference('/apex/TissueSpecimen?id='+tsSpecimenId);
               Pagereference ref = new Pagereference('/'+tsSpecimenId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)
                                
                                system.debug('__lstCoreBiopsy__'+lstCoreBiopsy);
                        
                        } else if(tissueSpecimenForm.Time_Point__c == null) {
                                        system.debug('tissueSpecimenForm.Time_Point__c : '+tissueSpecimenForm.Time_Point__c);
                                        tissueSpecimenForm.Time_Point__c.addError('Please Select Time Point.');
                                        system.debug('====addError===7');
                                        return null;    
                        }
                }
                else if(currentTab == 'AttachmentsTab'){
                        //upsert tissueSpecimenForm;
                        system.debug('tissueSpecimenForm===='+tissueSpecimenForm);
                        currentTab = 'Complete'; 
                } 
                if(nextTabName == 'CompleteTab') {
                        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
                        //completeCrf.customAdhoc(tissueSpecimenForm.Id+'', 'submit', 'Site'); 
                        submitTissueSpecimenRecord(tissueSpecimenForm.Id);
                        
                        lstCoreBiopsyWrapper.clear();
                        integer coreBiopsyNumber = 0;
                        List<Core_Biopsy_Specimens__c> tmpCoreBiopsyList = [Select c.TissueSpecimenDetail__c, c.SystemModstamp, c.SpecimenID__c, c.Shipped__c, c.Reason_samples_not_shipped__c, c.Other_Reason_samples_not_shipped__c, c.Name, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.Effective_Time__c, c.CreatedById, c.Core_Specimen__c From Core_Biopsy_Specimens__c c where TissueSpecimenDetail__c = :tissueSpecimenForm.Id order by Effective_Time__c DESC];
                        for(Core_Biopsy_Specimens__c cbs : tmpCoreBiopsyList) {
                                if(cbs.Shipped__c != null) {
                                        CoreBiopsyWrapper cbWrapper = new CoreBiopsyWrapper(); 
                                        cbWrapper.coreBiopsySpecimen = cbs;
                                        cbWrapper.isCollected = true;
                                        cbWrapper.coreBiopsyNumber = 'Core Specimen #'+(++coreBiopsyNumber)+' (Frozen)';
                                        cbWrapper.isShippedDisabled = false;
                                        lstCoreBiopsyWrapper.add(cbWrapper);
                                }
                        }
                }
                // Added by Shruti (DE401)
            try {
                upsert tissueSpecimenForm;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             // Pagereference ref = new Pagereference('/apex/TissueSpecimen?id='+tsSpecimenId);
                Pagereference ref = new Pagereference('/'+tsSpecimenId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)                
                if(nextTabName == 'saveAndClose') {
                  tissueSpecimenForm.First_Save_and_Close__c = true;
                       // Added by Shruti (DE401)
            try {
                upsert tissueSpecimenForm;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             // Pagereference ref = new Pagereference('/apex/TissueSpecimen?id='+tsSpecimenId);
                Pagereference ref = new Pagereference('/'+tsSpecimenId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)                       
                        List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:trialPat];
                        if(!trialPatList.isEmpty()) {
                                Pagereference pr = new Pagereference('/'+trialPatList[0].Patient_Id__c+'?TrialId='+trialPatList[0].Trial_Id__c);
                                pr.setRedirect(true);
                                return pr;
                        }    
                }
                currentTab = nextTabName;
                return null;
        } 
        
        
        //===============================For delete / cencel CRF process==========================================================      
        public Pagereference customCancel() {
                List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
                
                TissueSpecimenDetail__c tsSpecimenDetail;
                System.debug('====== TissueSpecimenFormId=======' + tsSpecimenId );
                if(tsSpecimenId != null){
                    tsSpecimenDetail = [select Id, Status__c from TissueSpecimenDetail__c  where id =: tsSpecimenId];
                    if(tsSpecimenId != null && tsSpecimenDetail.Status__c == 'Approval Not Required'){
                      if(profileName !='System Administrator'){
                    //isComplete= false;
                   // currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/TissueSpecimen?id='+tsSpecimenId);
                Pagereference ref = new Pagereference('/'+tsSpecimenId);
                ref.setRedirect(true);
                return ref;
             }
             else
                                 {   
                                 delete tissueSpecimenForm;
                                // System.debug('====bloodSpecimen===='+bloodSpecimen);
                                 }
             
             }
             else
                                 {   
                                 delete tissueSpecimenForm;
                                // System.debug('====bloodSpecimen===='+bloodSpecimen);
                                 }
             }
             /*   if(tissueSpecimenForm.Id != null) {
                     // Added by Shruti (DE401)
           try {
                
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             //Pagereference ref = new Pagereference('/apex/TissueSpecimen?id='+tsSpecimenId);
               Pagereference ref = new Pagereference('/'+tsSpecimenId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)                        
                }*/
                
                System.debug('-----Deleted---->');
                Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
                //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
                pr.setRedirect(true);
                return pr;
        }
        //===============================For previous tab==========================================================     
        // public void previous() {
           public Pagereference previous() { //Added by Shruti (DE401)
                system.debug('__currentTab__'+currentTab);
                String prevTabValue = Apexpages.currentPage().getParameters().get('prevTab');
                system.debug('__prevTabValue__'+prevTabValue);
                currentTab = prevTabValue;
                // Added by Shruti (DE401)
                TissueSpecimenDetail__c tsSpecimenDetail;
                System.debug('====== TissueSpecimenFormId=======' + tsSpecimenId );
                if(tsSpecimenId != null){
                    tsSpecimenDetail = [select Id, Status__c,Root_CRF_Id__c from TissueSpecimenDetail__c  where id =: tsSpecimenId];
                    if(tsSpecimenId != null && tsSpecimenDetail.Status__c == 'Approval Not Required'){
                    //System.debug('====bloodSpecimen===='+bloodSpecimen);
                    //System.debug('====bldSpecimenForm.Status__c===='+bldSpecimenForm.Status__c);
                    //System.debug('====bloodSpecimen===='+bloodSpecimen);
                    isComplete= false;
                    currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/TissueSpecimen?id='+tsSpecimenId);
                Pagereference ref = new Pagereference('/'+tsSpecimenId);
                ref.setRedirect(true);
                return ref;
             }
             }
                
          /*  try {
                update tissueSpecimenForm;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             // Pagereference ref = new Pagereference('/apex/TissueSpecimen?id='+tsSpecimenId);
                Pagereference ref = new Pagereference('/'+tsSpecimenId);
            ref.setRedirect(true);
             return ref;             
            }*/
             return null; 
            // Added by Shruti (DE401)
        } 
        
        //===========================Sign And Submit for Site User in AE CRF===========================================                 
        public Pagereference signAndSubmit() {
                //submitTissueSpecimen();
                //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
                //completeCrf.customAdhoc(tissueSpecimenForm.Id+'', 'submit', 'Site');
                SignAndSubmitController signSubmit = new SignAndSubmitController();
                signSubmit.password = password;
                Pagereference ref = signSubmit.signAndSubmit('00001','',tissueSpecimenForm.Id+'', 'Site');
                system.debug('errorMsg :  '+signSubmit.errorMsg);
                errorMsg = signSubmit.errorMsg;
                msgColor = 'Red';
                List<TissueSpecimenDetail__c> tissueList = [Select Status__c from TissueSpecimenDetail__c where id = :tissueSpecimenForm.Id and Status__c='Approval Not Required'];
                if(!tissueList.isEmpty()){
                    submitTissueSpecimen(tsId,trialPatientId, patientId);
                }
                return ref;
        }
    
    @future (callout=true)    
    private static void submitTissueSpecimen(Id tsId,Id trialPatientId, Id patientId){
      
        //CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='TissueSpecimenDetail__c' limit 1]; 
        CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='Registration__c' limit 1]; 
        
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
        
        TrialPatient__c trialPatientObj = [select Name, Patient_Id__c, Trial_Id__r.Name,Trial_Id__c,Subject_Id__c ,Site__c,Site__r.Name from TrialPatient__c where Id = :trialPatientId];
        
        
        //else{
        //    ihub.endpoint_x = 'http://ec2-23-20-103-202.compute-1.amazonaws.com:12020/services/CDAGenerator';
        //    ihub.timeout_x = 120000;
        //}
        cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
        cdapackage.author author = new cdapackage.author();
        cdapackage.patient patient = new cdapackage.patient();
        cdapackage.procedure procedure = new cdapackage.procedure();
        cdapackage.specimen[] specimenArray;
        cdapackage.guidanceMethod[] guidanceArray;// = new cdapackage.guidanceMethod[]{};
        //String xmlType = (radioValue==null? 'CDA' : radioValue);
        String xmlType = 'CDA';
        author.idExtension = UserInfo.getUserName();
        TissueSpecimenDetail__c tissueSpecimenForm2;
        List<TissueSpecimenDetail__c> TSList= [Select t.Root_CRF_Id__c,t.CompletedDate__c,t.TrialPatient__c, t.TrialPatient__r.Patient_Id__c, t.TrialPatient__r.Name, t.Time_Point__c, t.SystemModstamp, t.Status__c, t.RecordTypeId, t.Reason_all_samples_not_collected__c, t.ProcedureDate__c, t.Phase__c, t.Patient__c, t.PatientConsentedStudy__c, t.PatientConsentedOutsideStudy__c, t.OwnerId, t.Other_Reason_not_all_samples_collected__c, t.Other_Guidance_Method__c, t.NumberOfSamplesCollected__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Guidance_Method_s__c, t.Effective_Time__c, t.CreatedById, t.CRFId__c, t.CreatedDate From TissueSpecimenDetail__c t where Id = :tsId];
        if(!TSList.isEmpty()) {
            tissueSpecimenForm2 = TSList[0]; 
        }
        
        clinicalDoc.id=tissueSpecimenForm2.id;
        clinicalDoc.title = 'Create Biospecimen';
        if(tissueSpecimenForm2.Effective_Time__c!=null){
            clinicalDoc.effectiveTime=String.valueOf(tissueSpecimenForm2.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
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
            
            //if(tissueSpecimenSet.contains('ISPY2_Subject_Id__c')) {
                clinicalDoc.studySubjectIdentifier=trialPatientObj.Subject_Id__c;
            //}
            
            mrn=patientObj.Medical_Record_Number__c;
            
        }
        siteId = trialPatientObj.Site__c;
        studyId = trialPatientObj.Trial_Id__c;

        procedure.studyIdentifier=trialPatientObj.Trial_Id__c ;
        procedure.activityStatus='Active';
        procedure.activityStatusCode='55561003';
        //procedure.availableQuantity='1';
        //procedure.initialQuantity='1';
        procedure.barcode='1098';
        //procedure.collectionProtocolShortTitle=trialPatientObj.Trial_Id__r.Name;
        //procedure.collectionProtocolTitle=trialPatientObj.Trial_Id__r.Name;
        procedure.collectionProtocolShortTitle='Needle Core Biopsy';
        procedure.collectionProtocolTitle='Needle Core Biopsy';
        procedure.specimenCharacteristicsSide='Right';
        procedure.specimenCharacteristicsSideCode='24028007';
        procedure.specimenCharacteristicsSite='Not Specified';
        procedure.specimenClass='Tissue';
        procedure.specimenClassCode='119376003';
        //procedure.studyCalendarEventTimePoint=tissueSpecimenForm2.Time_Point__c;
        
        //if(tissueSpecimenForm2.Time_Point__c=='Pre-treatment'){
        //    procedure.studyCalendarEventTimePoint='0';
        //}else if(tissueSpecimenForm2.Time_Point__c=='Early Treatment'){
        //    procedure.studyCalendarEventTimePoint='1';
        //}else if(tissueSpecimenForm2.Time_Point__c=='Inter-Regimen'){
        //    procedure.studyCalendarEventTimePoint='2';
        //}else if(tissueSpecimenForm2.Time_Point__c=='Pre-Treatment Re-Biopsy'){
        //    procedure.studyCalendarEventTimePoint='3';
        //}else if(tissueSpecimenForm2.Time_Point__c=='Surgery'){
        //    procedure.studyCalendarEventTimePoint='4';
        //}

        if(tissueSpecimenForm2.ProcedureDate__c!=null){
            procedure.collectionDate =String.valueOf(tissueSpecimenForm2.ProcedureDate__c).replaceAll('-','').replaceAll(' ','');
        }
        
        if(tissueSpecimenForm2.Guidance_Method_s__c != null){
        List<String> stringList = tissueSpecimenForm2.Guidance_Method_s__c.split('\\;');
        guidanceArray = new cdapackage.guidanceMethod[stringList.size()];
        for(Integer i=0;i<stringList.size();i++) {
            String s = stringList[i];
            cdapackage.guidanceMethod gm = new cdapackage.guidanceMethod();
            
            gm.valueDisplayName=s;
            gm.valueOriginalText=s;
            if(s=='Ultrasound'){
                gm.valueCode='16310003';
            }else if(s=='MRI'){
                gm.valueCode='241615005';
            }else if(s=='Stereotactic'){
                gm.valueCode='258172002';
            }else if(s=='Mammography'){
                gm.valueCode='71651007';
            }else if(s=='Palpation guided'){
                gm.valueCode='113011001';
            }else if(s=='Other'){
                gm.valueCode='NA';
                gm.valueDisplayName=tissueSpecimenForm2.Other_Guidance_Method__c;
                gm.valueOriginalText=tissueSpecimenForm2.Other_Guidance_Method__c;
            }else{
                gm.valueCode='NA';
            }
           
            guidanceArray[i] = gm;
        }
        }
        
        //Retrive all Specimen id for a time point and trial patient id which have been successfully intergated
        Set<String> oldSpecimenIdSet = new Set<String>();
        List<Core_Biopsy_Specimens__c> previousCoreBiopsyList = [Select  c.SpecimenID__c From Core_Biopsy_Specimens__c c where c.SpecimenID__c !=null and c.Is_Integration_Success__c=true and c.TissueSpecimenDetail__c != :tissueSpecimenForm2.Id and Shipped__c='Yes' and c.TissueSpecimenDetail__r.Time_Point__c=:tissueSpecimenForm2.Time_Point__c and c.TissueSpecimenDetail__r.TrialPatient__c=:trialPatientId];
        for(Core_Biopsy_Specimens__c b :previousCoreBiopsyList){
            oldSpecimenIdSet.add(b.SpecimenID__c);
        }
        
        List<Core_Biopsy_Specimens__c> coreBiopsyList = [Select c.TissueSpecimenDetail__c, c.SystemModstamp, c.SpecimenID__c, c.Shipped__c, c.Reason_samples_not_shipped__c, c.Other_Reason_samples_not_shipped__c, c.Name, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.Effective_Time__c, c.CreatedById, c.Core_Specimen__c, c.Is_Integration_Success__c From Core_Biopsy_Specimens__c c where TissueSpecimenDetail__c = :tissueSpecimenForm2.Id and Shipped__c='Yes'];
        //Amit specimenArray = new cdapackage.specimen[coreBiopsyList.size()];
        List<cdapackage.specimen> specimenUpdateList = new List<cdapackage.specimen>();
        List<cdapackage.specimen> specimenAddList = new List<cdapackage.specimen>();
        
        for(Integer i=0;I<coreBiopsyList.size();i++){
            Core_Biopsy_Specimens__c specimen = coreBiopsyList[i];
            cdapackage.specimen sp= new cdapackage.specimen();
            sp.specimenID = specimen.SpecimenID__c;
            sp.specimenDisplayName='Frozen Tissue';
            sp.specimenCode = '441479001';
            sp.availableQuantity='1';
            sp.availableQuantityUnit='g';    
            sp.initialQuantity='1';
            sp.initialQuantityUnit='g';
            
            if(tissueSpecimenForm2.Time_Point__c=='Pre-treatment'){
                sp.studyCalendarEventTimePoint='0';
            }else if(tissueSpecimenForm2.Time_Point__c=='Early Treatment'){
                sp.studyCalendarEventTimePoint='1';
            }else if(tissueSpecimenForm2.Time_Point__c=='Inter-Regimen'){
                sp.studyCalendarEventTimePoint='2';
            }else if(tissueSpecimenForm2.Time_Point__c=='Pre-Treatment Re-Biopsy'){
                sp.studyCalendarEventTimePoint='3';
            }else if(tissueSpecimenForm2.Time_Point__c=='Surgery'){
                sp.studyCalendarEventTimePoint='4';
            }
            //sp.studyCalendarEventTimePoint;
            sp.studyCalendarEventTimePointUnit='d';
            //Amit specimenArray[i]=sp;
            if(oldSpecimenIdSet.contains(specimen.SpecimenID__c)){
                specimenUpdateList.add(sp);
            }else{
                specimenAddList.add(sp);
            }
        }                            
        
        //Boolean isChangeInConsent = false;
        cdapackage.consent consent = new cdapackage.consent();
        cdapackage.consent[] consentArray = null;
        /*
        List<TissueSpecimenDetail__c> lstTS = [Select t.CompletedDate__c,t.TrialPatient__c, t.TrialPatient__r.Patient_Id__c, t.TrialPatient__r.Name, t.Time_Point__c, t.SystemModstamp, t.Status__c, t.RecordTypeId, t.Reason_all_samples_not_collected__c, t.ProcedureDate__c, t.Phase__c, t.Patient__c, t.PatientConsentedStudy__c, t.PatientConsentedOutsideStudy__c, t.OwnerId, t.Other_Reason_not_all_samples_collected__c, t.Other_Guidance_Method__c, t.NumberOfSamplesCollected__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Guidance_Method_s__c, t.Effective_Time__c, t.CreatedById, t.CRFId__c From TissueSpecimenDetail__c t where Patient__c = :patientId and TrialPatient__c=:trialPatientId and Time_Point__c=:tissueSpecimenForm2.Time_Point__c  order by CompletedDate__c desc ];
        if(lstTS.size()==0 ){
            
            if(tissueSpecimenForm2.PatientConsentedStudy__c==True ||tissueSpecimenForm2.PatientConsentedOutsideStudy__c==True){
                isChangeInConsent = true;
                consent.consentDateTime=String.valueOf(tissueSpecimenForm2.CreatedDate).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
                consent.tier1Response=(tissueSpecimenForm2.PatientConsentedStudy__c==True?'Yes':'No');
                consent.tier2Response=(tissueSpecimenForm2.PatientConsentedOutsideStudy__c==True?'Yes':'No');
                consent.tier1ResponseCode=(tissueSpecimenForm2.PatientConsentedStudy__c==True?'373066001':'373067005');
                consent.tier2ResponseCode=(tissueSpecimenForm2.PatientConsentedOutsideStudy__c==True?'373066001':'373067005'); 
            }
            
        } else if(lstTS.size()>0 ){
            
            TissueSpecimenDetail__c ts1 = tissueSpecimenForm2;
            TissueSpecimenDetail__c ts2 = lstTS[0];
            consent.consentDateTime=String.valueOf(ts1.CreatedDate).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            if(ts1.PatientConsentedStudy__c==True && ts2.PatientConsentedStudy__c==False){
                consent.tier1Response='Yes';
                consent.tier1ResponseCode='373066001';
                isChangeInConsent = true;
            }else if(ts1.PatientConsentedStudy__c==False && ts2.PatientConsentedStudy__c==True){
                consent.tier1Response='Withdrawn';
                consent.tier1ResponseCode='185924006';
                isChangeInConsent = true;
            }else if(ts1.PatientConsentedStudy__c==False && ts2.PatientConsentedStudy__c==False){
                consent.tier1Response='No';
                consent.tier1ResponseCode='373067005';
            }
            
            if(ts1.PatientConsentedOutsideStudy__c==True && ts2.PatientConsentedOutsideStudy__c==False){
                consent.tier2Response='Yes';
                consent.tier2ResponseCode='373066001';
                isChangeInConsent = true;
            }else if(ts1.PatientConsentedOutsideStudy__c==False && ts2.PatientConsentedOutsideStudy__c==True){
                consent.tier2Response='Withdrawn';
                consent.tier2ResponseCode='185924006';
                isChangeInConsent = true;
            }else if(ts1.PatientConsentedOutsideStudy__c==False && ts2.PatientConsentedOutsideStudy__c==False){
                consent.tier2Response='No';
                consent.tier2ResponseCode='373067005';
            }
            
        } */
        
        //isChangeInConsent = true;
        consent.consentDateTime=String.valueOf(tissueSpecimenForm2.CreatedDate).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
        consent.tier1Response=(tissueSpecimenForm2.PatientConsentedStudy__c==True?'Yes':'No');
        consent.tier2Response=(tissueSpecimenForm2.PatientConsentedOutsideStudy__c==True?'Yes':'No');
        consent.tier1ResponseCode=(tissueSpecimenForm2.PatientConsentedStudy__c==True?'373066001':'373067005');
        consent.tier2ResponseCode=(tissueSpecimenForm2.PatientConsentedOutsideStudy__c==True?'373066001':'373067005'); 
                
        //if(isChangeInConsent){
             consentArray = new cdapackage.consent[coreBiopsyList.size()]; 
             for(Integer i=0;I<coreBiopsyList.size();i++){
                Core_Biopsy_Specimens__c specimen = coreBiopsyList[i];
                //cdapackage.specimen sp= new cdapackage.specimen();
                cdapackage.consent consent1 = consent.clone();
                consent1.cdmsid = specimen.SpecimenID__c;
            
                consentArray[i]=consent1;
            }
       // }
          
        ExternalServiceConnector serviceConnector = new ExternalServiceConnector('iHub');
        String trialId = trialPatientObj.Trial_Id__c;  
        Boolean isSuccess = false;    
         
        try{
            cdapackage.response res = new cdapackage.response();
            if(Test.isRunningTest()) {
                res.status = 'SUCCESS';
                res.description='success message';
                res.code = 'SUCCESS';
            }else{
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
            
            if(res.status=='FAILURE'){
                                
                ExternalServiceConnector.populateFailedRegistration('TissueSpecimenDetail__c',tissueSpecimenForm2.Id,false,patientId,trialId,siteId,studyId,res.code,res.description,'Failure','caAERS',mrn,res.caXchangeId,res.id);
                
            }else if(res.status=='SUCCESS'){
                isSuccess = true;
            }
            
        }catch (System.CalloutException e){
        
            String errorCode = '5001';
            
            ExternalServiceConnector.populateFailedRegistration('TissueSpecimenDetail__c',tissueSpecimenForm2.Id,false,patientId,trialId,siteId,studyId,errorCode,'Connection timeout when accessing CDA Service','Failure','caAERS',mrn,null,null);
             
             
        }catch(Exception e){
            System.debug(e);
            
            String errorCode = '5000';
            
            ExternalServiceConnector.populateFailedRegistration('TissueSpecimenDetail__c',tissueSpecimenForm2.Id,false,patientId,trialId,siteId,studyId,errorCode,'Unexpected error','Failure','caAERS',mrn,null,null);
        }
        
        /*
        catch(Exception e){
            System.debug(e);
            
            String errorCode = '1000';
            
            populateFailedRegistration(tissueSpecimenForm2.Id,false,patientId,trialId,siteId,studyId,errorCode,e.getMessage(),'Failure','caAERS',mrn,null,null);
        }*/
        if(isSuccess){
            
            
            try{
                cdapackage.response res2 = new cdapackage.response();
                if(Test.isRunningTest()) {
                    res2.status = 'SUCCESS';
                    res2.description='success message';
                    res2.code = 'SUCCESS';
                }else{
                   clinicalDoc.title ='Register Consent';
                   res2 = serviceConnector.ihub.submitConsentCDA(clinicalDoc,author,patient,consentArray ,xmlType);
                   
                }
                
                if(res2.status=='FAILURE'){
                                    
                    ExternalServiceConnector.populateFailedRegistration('TissueSpecimenDetail__c',tissueSpecimenForm2.Id,true,patientId,trialId,siteId,studyId,res2.code,res2.description,'Failure','caAERS',mrn,res2.caXchangeId,res2.id);
                    
                }
             }catch (System.CalloutException e){
            
                String errorCode = '5001';
                
                ExternalServiceConnector.populateFailedRegistration('TissueSpecimenDetail__c',tissueSpecimenForm2.Id,true,patientId,trialId,siteId,studyId,errorCode,'Connection timeout when accessing CDA Service','Failure','caAERS',mrn,null,null);
                 
                 
            }catch(Exception e){
                System.debug(e);
                String errorCode = '5000';
                
                //populateFailedRegistration(tissueSpecimenForm2.Id,true,patientId,trialId,siteId,studyId,errorCode,e.getMessage(),'Failure','caAERS',mrn,null,null);
                ExternalServiceConnector.populateFailedRegistration('TissueSpecimenDetail__c',tissueSpecimenForm2.Id,true,patientId,trialId,siteId,studyId,errorCode,'Unexpected error','Failure','caAERS',mrn,null,null);
            }
            
            for(Core_Biopsy_Specimens__c biopsy : coreBiopsyList){
                biopsy.Is_Integration_Success__c =true; 
                biopsy.Integration_Timestamp__c = System.now(); 
            }
            update coreBiopsyList;
            
        }else{
            String errorCode = '5011';
            ExternalServiceConnector.populateFailedRegistration('TissueSpecimenDetail__c',tissueSpecimenForm2.Id,true,patientId,trialId,siteId,studyId,errorCode,'Consent request could not be submitted because preceding Biospecimen request failed','Failure','caAERS',mrn,null,null);
        }
      
        
    }

    /*public static void populateFailedRegistration(String crfId,Boolean isConsent,String patientId, String trialId, String siteId,String studyId, String errorCode, String errorMessage, String status,String systemName, String mrn,String caXchangeId, String returnId){
        String CRFName;
        List<CRFMaster__c> crfList = [Select c.CRFType__c From CRFMaster__c c where c.Object_Name__c='TissueSpecimenDetail__c'];
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
        
        
        Failed_Registration__c fr = new Failed_Registration__c(CRF_Id__c=crfId,IsConsent__c=isConsent,Patient__c=patientId,Trial__c=trialId,Last_Error_Message__c=errorMessage,Last_Status__c=status,Retry__c=autoRetry,Site__c=siteId,Study_Id__c=studyId,Error_Code__c=errorCode,System_Name__c=systemName,MRN__c=mrn,CRF_Name__c=CRFName,CaXchangeId__c=caXchangeId,ReturnId__c=returnId);
        insert fr;
    }*/
        
        public String msgColor {get;set;}
        public void resendCode() {
                SignAndSubmitController ctr = new SignAndSubmitController();
                ctr.resendCode();
                errorMsg = 'Code Sent! Please check your Email.';
                msgColor = 'Green';
        }
        
        public void editTissueSpecimenForm() {
                //responseEval
                List<TissueSpecimenDetail__c> lstTS = [Select t.Root_CRF_Id__c,t.TrialPatient__c, t.TrialPatient__r.Patient_Id__c, t.TrialPatient__r.Name, t.Time_Point__c, t.SystemModstamp, t.Status__c, t.RecordTypeId, t.Reason_all_samples_not_collected__c, t.ProcedureDate__c, t.Phase__c, t.Patient__c, t.PatientConsentedStudy__c, t.PatientConsentedOutsideStudy__c, t.OwnerId, t.Other_Reason_not_all_samples_collected__c, t.Other_Guidance_Method__c, t.NumberOfSamplesCollected__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Guidance_Method_s__c, t.Effective_Time__c, t.CreatedById, t.CRFId__c From TissueSpecimenDetail__c t where Id = :tsId];
                if(!lstTS.isEmpty()) {
                        tissueSpecimenForm = lstTS[0]; 
                        trialPatientId = lstTS[0].TrialPatient__c;
                        trialPatient = lstTS[0].TrialPatient__r.Name;
                        patientId = lstTS[0].TrialPatient__r.Patient_Id__c;
                }
                
                lstCoreBiopsyWrapper = new List<CoreBiopsyWrapper>(); 
                integer coreBiopsyNumber = 0;
                lstCoreBiopsy = [Select c.TissueSpecimenDetail__c, c.SystemModstamp, c.SpecimenID__c, c.Shipped__c, c.Reason_samples_not_shipped__c, c.Other_Reason_samples_not_shipped__c, c.Name, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.Effective_Time__c, c.CreatedById, c.Core_Specimen__c From Core_Biopsy_Specimens__c c where TissueSpecimenDetail__c = :tsId order by Effective_Time__c DESC];
                for(Core_Biopsy_Specimens__c cbs : lstCoreBiopsy) {
                        CoreBiopsyWrapper cbWrapper = new CoreBiopsyWrapper(); 
                        cbWrapper.coreBiopsySpecimen = cbs;
                        cbWrapper.isCollected = true;
                        cbWrapper.coreBiopsyNumber = 'Core Specimen #'+(++coreBiopsyNumber)+' (Frozen)';
                        cbWrapper.isShippedDisabled = false;
                        lstCoreBiopsyWrapper.add(cbWrapper);
                        system.debug('__coreBiopsyNumber__'+coreBiopsyNumber);
                }
                //coreBiopsyNumber = lstCoreBiopsy.Size();
                for(CoreBiopsyWrapper cbw : lstCoreBiopsyWrapper) {
                        if(cbw.coreBiopsySpecimen.Shipped__c != null) {
                                cbw.isShippedDisabled = false;
                                if(cbw.coreBiopsySpecimen.Shipped__c == 'No') {
                                        cbw.isReasonDisabled = false;
                                        if(cbw.coreBiopsySpecimen.Reason_samples_not_shipped__c == 'Other') {
                                                cbw.isOtherDisabled = false;
                                        } else {
                                                cbw.isOtherDisabled = true;
                                        }
                                        showReasonSec = false;
                                } else {
                                        cbw.isReasonDisabled = true;
                                        cbw.isOtherDisabled = true;
                                }
                        } else {
                                cbw.isCollected = false;
                                cbw.isShippedDisabled = true;
                                cbw.isReasonDisabled = true;
                                cbw.isOtherDisabled = true;
                        }
                }
                system.debug('__coreBiopsyNumber__'+coreBiopsyNumber);
        }
        
        public void addSpecimen() {
                system.debug('__coreBiopsyNumber__'+coreBiopsyNumber);
                system.debug('Row : '+Apexpages.currentPage().getParameters().get('row'));
                system.debug('tissueSpecimenForm.Time_Point__c : '+tissueSpecimenForm.Time_Point__c);
                
                if(tissueSpecimenForm.ProcedureDate__c == null) {
                        tissueSpecimenForm.ProcedureDate__c.addError('Please provide Prcedure Date.');
                        return;
                } else if(tissueSpecimenForm.ProcedureDate__c > system.today()) {
                        tissueSpecimenForm.ProcedureDate__c.addError('Future dates are not allowed.');
                        return;
                }
                
                if(tissueSpecimenForm.Time_Point__c == null) {
                        tissueSpecimenForm.Time_Point__c.addError('Please provide Time Point.');
                        return;
                }
                
                integer size = 0;
                if(Apexpages.currentPage().getParameters().get('row') == '1') {
                        system.debug('first__');
                        size = 1;
                        for(CoreBiopsyWrapper cbw : lstCoreBiopsyWrapper) {
                                if(cbw.coreBiopsySpecimen.Shipped__c != null) {
                                        cbw.isShippedDisabled = false;
                                        if(cbw.coreBiopsySpecimen.Shipped__c == 'No') {
                                                cbw.isReasonDisabled = false;
                                                if(cbw.coreBiopsySpecimen.Reason_samples_not_shipped__c == 'Other') {
                                                        cbw.isOtherDisabled = false;
                                                } else {
                                                        cbw.isOtherDisabled = true;
                                                }
                                        } else {
                                                cbw.isReasonDisabled = true;
                                                cbw.isOtherDisabled = true;
                                        }
                                } else {
                                        cbw.isCollected = false;
                                        cbw.isShippedDisabled = true;
                                        cbw.isReasonDisabled = true;
                                        cbw.isOtherDisabled = true;
                                }
                        }
                } else if(tissueSpecimenForm.Time_Point__c == 'Surgery') {
                        system.debug('second__');
                        lstCoreBiopsyWrapper = new List<CoreBiopsyWrapper>();
                        coreBiopsyNumber = 0;
                        size = 2;
                        delete [select Id from Core_Biopsy_Specimens__c where TissueSpecimenDetail__c = :tissueSpecimenForm.Id];
                } else if(tissueSpecimenForm.Time_Point__c == null) {
                        system.debug('third__');
                        lstCoreBiopsyWrapper = new List<CoreBiopsyWrapper>();
                        coreBiopsyNumber = 0;
                        size = 0;
                } else {
                        system.debug('fourth__');
                        lstCoreBiopsyWrapper = new List<CoreBiopsyWrapper>();
                        coreBiopsyNumber = 0;
                        size = 4;
                        delete [select Id from Core_Biopsy_Specimens__c where TissueSpecimenDetail__c = :tissueSpecimenForm.Id];
                }
                
                system.debug('__coreBiopsyNumber__'+coreBiopsyNumber);
                for(integer i=0;i<size;i++) {
                        Core_Biopsy_Specimens__c cbs = new Core_Biopsy_Specimens__c();
                        CoreBiopsyWrapper cbWrapper = new CoreBiopsyWrapper();
                        cbWrapper.isCollected = false;
                        cbWrapper.isShippedDisabled = true;
                        cbWrapper.isReasonDisabled = true;
                        cbWrapper.isOtherDisabled = true;
                        if(tissueSpecimenForm.Time_Point__c == 'Surgery') {
                                cbWrapper.coreBiopsyNumber = 'Specimen #'+(++coreBiopsyNumber)+' (Frozen)';
                        } else {
                                cbWrapper.coreBiopsyNumber = 'Core Specimen #'+(++coreBiopsyNumber)+' (Frozen)';
                        }
                        cbWrapper.coreBiopsySpecimen = cbs;
                        lstCoreBiopsyWrapper.add(cbWrapper);
                }
        }
        
        public Pagereference saveCRF() {
                
                showReasonSec = true;
                if(lstCoreBiopsyWrapper != null) {
                        integer sampleCollected = 0;
                        for(CoreBiopsyWrapper cbw : lstCoreBiopsyWrapper) {
                                if(cbw.isCollected && cbw.coreBiopsySpecimen.Shipped__c == 'Yes') {
                                        ++sampleCollected;
                                }
                        }
                        
                        if(tissueSpecimenForm.ProcedureDate__c == null) {
                                tissueSpecimenForm.ProcedureDate__c.addError('Please provide Prcedure Date.');
                                return null;
                        } else if(tissueSpecimenForm.ProcedureDate__c > system.today()) {
                                tissueSpecimenForm.ProcedureDate__c.addError('Future dates are not allowed.');
                                return null;
                        }
                        
                        if(tissueSpecimenForm.Time_Point__c == 'Pre-Treatment' && sampleCollected < 4 && tissueSpecimenForm.Reason_all_samples_not_collected__c == null) {
                                showReasonSec = false;
                                tissueSpecimenForm.Reason_all_samples_not_collected__c.addError('Please provide reason "why all samples are not collected?"');
                                return null;
                        } else if(tissueSpecimenForm.Time_Point__c == 'Early Treatment' && sampleCollected < 4 && tissueSpecimenForm.Reason_all_samples_not_collected__c == null) {
                                showReasonSec = false;
                                tissueSpecimenForm.Reason_all_samples_not_collected__c.addError('Please provide reason "why all samples are not collected?"');
                                return null;
                        } else if(tissueSpecimenForm.Time_Point__c == 'Inter-Regimen' && sampleCollected < 4 && tissueSpecimenForm.Reason_all_samples_not_collected__c == null) {
                                showReasonSec = false;
                                tissueSpecimenForm.Reason_all_samples_not_collected__c.addError('Please provide reason "why all samples are not collected?"');
                                return null;
                        } else if(tissueSpecimenForm.Time_Point__c == 'Pre-Treatment Re-Biopsy' && sampleCollected < 4 && tissueSpecimenForm.Reason_all_samples_not_collected__c == null) {
                                showReasonSec = false;
                                tissueSpecimenForm.Reason_all_samples_not_collected__c.addError('Please provide reason "why all samples are not collected?"');
                                return null;
                        } else if(tissueSpecimenForm.Time_Point__c == 'Surgery' && sampleCollected < 2 && tissueSpecimenForm.Reason_all_samples_not_collected__c == null) {
                                showReasonSec = false;
                                tissueSpecimenForm.Reason_all_samples_not_collected__c.addError('Please provide reason "why all samples are not collected?"');
                                return null;
                        } else if(tissueSpecimenForm.Time_Point__c == null) {
                                system.debug('tissueSpecimenForm.Time_Point__c : '+tissueSpecimenForm.Time_Point__c);
                                tissueSpecimenForm.Time_Point__c.addError('Please Select Time Point.');
                                return null;
                        }
                        tissueSpecimenForm.TrialPatient__c = trialPatientId;
                        tissueSpecimenForm.status__c = 'Not Completed';
                        tissueSpecimenForm.Phase__c = 'Screening';
                        tissueSpecimenForm.NumberOfSamplesCollected__c = sampleCollected;
                        upsert tissueSpecimenForm;
                        List<Core_Biopsy_Specimens__c> lstCoreBiopsy = new List<Core_Biopsy_Specimens__c>();
                        for(CoreBiopsyWrapper coreBiopsy : lstCoreBiopsyWrapper) {
                                
                                coreBiopsy.coreBiopsySpecimen.TissueSpecimenDetail__c = tissueSpecimenForm.Id;
                                lstCoreBiopsy.add(coreBiopsy.coreBiopsySpecimen);
                        }
                        upsert lstCoreBiopsy;
                } else if(tissueSpecimenForm.Time_Point__c == null) {
                                system.debug('tissueSpecimenForm.Time_Point__c : '+tissueSpecimenForm.Time_Point__c);
                                tissueSpecimenForm.Time_Point__c.addError('Please Select Time Point.');
                                return null;    
                }
                return new Pagereference('/'+tissueSpecimenForm.Id);
        }
        
        public Pagereference cancelCRF() {
                return new Pagereference('/'+patientId);
        }
        
        public Pagereference submitTissueSpecimenRecord(String TissueSpecimenId) {
                Pagereference ref = null;
                isErrorMsg = false;
                //String id = Apexpages.currentPage().getParameters().get('id');
                String id = TissueSpecimenId;
                List<RecordType> lstRecordType = [select Id, Name from RecordType where sObjectType = 'TissueSpecimenDetail__c' and Name = 'Live'];
                List<RecordType> lstAdHocRecordType = [select Id, Name from RecordType where sObjectType = 'TissueSpecimenDetail__c' and Name = 'ADHOC'];
                List<TissueSpecimenDetail__c> lstTissueSpecimenDetail = [Select t.Root_CRF_Id__c,t.RecordTypeId, t.TrialPatient__r.Patient_Id__c, t.TrialPatient__r.Subject_Id__c, t.Time_Point__c, t.Patient__c, t.NumberOfSamplesCollected__c, t.Reason_all_samples_not_collected__c, t.Other_Reason_not_all_samples_collected__c, (Select SpecimenID__c, Core_Specimen__c From Core_Biopsy_Specimens__r) From TissueSpecimenDetail__c t where Id = :id];
                system.debug('__lstTissueSpecimenDetail.size()__'+lstTissueSpecimenDetail.size());
                system.debug('__lstRecordType__'+lstRecordType);
                system.debug('__lstTissueSpecimenDetail[0].RecordTypeId__'+lstTissueSpecimenDetail[0].RecordTypeId);
                system.debug('__lstAdHocRecordType[0].Id__'+lstAdHocRecordType[0].Id);
                if(lstTissueSpecimenDetail != null && lstTissueSpecimenDetail.size() > 0 && lstRecordType != null && lstRecordType.size() > 0 && lstTissueSpecimenDetail[0].RecordTypeId == lstAdHocRecordType[0].Id) {
                        lstTissueSpecimenDetail[0].RecordTypeId = lstRecordType[0].Id;
                        //lstTissueSpecimenDetail[0].Status__c = 'Completed';
                        //lstTissueSpecimenDetail[0].CompletedDate__c = system.today();
                        try {
                                String fiveDigitPId = lstTissueSpecimenDetail[0].TrialPatient__r.Subject_Id__c;
                                /*String PId = lstTissueSpecimenDetail[0].TrialPatient__r.Patient_Id__c;
                                List<Patient_Custom__c> lstPatient = [select Name from Patient_Custom__c where Id = :PId];
                                if(lstPatient != null && lstPatient.size() > 0) { 
                                        fiveDigitPId = lstPatient[0].Name;
                                }*/
                                system.debug('lstTissueSpecimenDetail[0].Time_Point__c : '+lstTissueSpecimenDetail[0].Time_Point__c);
                                lstCoreBiopsy = lstTissueSpecimenDetail[0].Core_Biopsy_Specimens__r;
                                system.debug('NumberOfSamplesCollected__c : '+lstTissueSpecimenDetail[0].NumberOfSamplesCollected__c);
                                
                                if(lstTissueSpecimenDetail[0].Time_Point__c == 'Pre-Treatment' && lstTissueSpecimenDetail[0].NumberOfSamplesCollected__c < 4 && lstTissueSpecimenDetail[0].Reason_all_samples_not_collected__c == null) {
                                        isErrorMsg = true;
                                } else if(lstTissueSpecimenDetail[0].Time_Point__c == 'Early Treatment' && lstTissueSpecimenDetail[0].NumberOfSamplesCollected__c < 4 && lstTissueSpecimenDetail[0].Reason_all_samples_not_collected__c == null) {
                                        isErrorMsg = true;
                                } else if(lstTissueSpecimenDetail[0].Time_Point__c == 'Inter-Regimen' && lstTissueSpecimenDetail[0].NumberOfSamplesCollected__c < 4 && lstTissueSpecimenDetail[0].Reason_all_samples_not_collected__c == null) {
                                        isErrorMsg = true;
                                } else if(lstTissueSpecimenDetail[0].Time_Point__c == 'Pre-Treatment Re-Biopsy' && lstTissueSpecimenDetail[0].NumberOfSamplesCollected__c < 4 && lstTissueSpecimenDetail[0].Reason_all_samples_not_collected__c == null) {
                                        isErrorMsg = true;
                                } else if(lstTissueSpecimenDetail[0].Time_Point__c == 'Surgery' && lstTissueSpecimenDetail[0].NumberOfSamplesCollected__c < 2 && lstTissueSpecimenDetail[0].Reason_all_samples_not_collected__c == null) {
                                        isErrorMsg = true;
                                }
                                if(lstTissueSpecimenDetail[0].Reason_all_samples_not_collected__c == 'Other' && lstTissueSpecimenDetail[0].Other_Reason_not_all_samples_collected__c == null) {
                                        errorMsg = 'Please provide "Other (Reason not all samples collected)"';
                                        recordURL = '/'+lstTissueSpecimenDetail[0].Id;
                                        system.debug('errorMsg : '+errorMsg);
                                        return ref;
                                }
                                if(isErrorMsg) {
                                        errorMsg = 'Please provide "Reason not all samples collected"';
                                        recordURL = '/'+lstTissueSpecimenDetail[0].Id;
                                        system.debug('errorMsg : '+errorMsg);
                                        return ref;
                                }
                                /*integer sidForPreTxReBiopsy = 0;
                                List<Core_Biopsy_Specimens__c> lstCoreBiopsyForPreTx = [Select c.TissueSpecimenDetail__r.TrialPatient__c, c.TissueSpecimenDetail__r.Time_Point__c, c.TissueSpecimenDetail__c From Core_Biopsy_Specimens__c c where TissueSpecimenDetail__r.Time_Point__c = 'Pre-Treatment' and TissueSpecimenDetail__c = :id];
                                if(lstCoreBiopsyForPreTx != null) {
                                        sidForPreTxReBiopsy = lstCoreBiopsyForPreTx.size();
                                }
                                for(Core_Biopsy_Specimens__c cbs : lstCoreBiopsy) {
                                        
                                        if(lstTissueSpecimenDetail[0].Time_Point__c == 'Pre-Treatment') {
                                                cbs.SpecimenID__c = fiveDigitPId + '0' +String.valueOf((Integer.valueOf(cbs.Core_Specimen__c) + 10));
                                        }
                                        if(lstTissueSpecimenDetail[0].Time_Point__c == 'Early Treatment') {
                                                cbs.SpecimenID__c = fiveDigitPId + String.valueOf((Integer.valueOf(cbs.Core_Specimen__c) + 110));
                                        }
                                        if(lstTissueSpecimenDetail[0].Time_Point__c == 'Inter-Regimen') {
                                                cbs.SpecimenID__c = fiveDigitPId + String.valueOf((Integer.valueOf(cbs.Core_Specimen__c) + 210));
                                        }
                                        if(lstTissueSpecimenDetail[0].Time_Point__c == 'Surgery') {
                                                cbs.SpecimenID__c = fiveDigitPId + String.valueOf((Integer.valueOf(cbs.Core_Specimen__c) + 310));
                                        }
                                        if(lstTissueSpecimenDetail[0].Time_Point__c == 'Pre-Treatment Re-Biopsy') {
                                                if(sidForPreTxReBiopsy == 0) {
                                                        cbs.SpecimenID__c = fiveDigitPId + '0' +String.valueOf((Integer.valueOf(cbs.Core_Specimen__c) + 10));
                                                } else {
                                                        cbs.SpecimenID__c = String.valueOf(++sidForPreTxReBiopsy);
                                                }
                                        }       
                                }
                                update lstCoreBiopsy;
                                */
                                //lstTissueSpecimenDetail[0].Status__c = 'Completed';
                                //lstTissueSpecimenDetail[0].CompletedDate__c = system.today();
                                update lstTissueSpecimenDetail[0];
                                ref = new Pagereference('/'+lstTissueSpecimenDetail[0].Id);
                                ref.setRedirect(true);
                        } catch(DmlException e) {
                                errorMsg = 'Please provide "Other (Reason not all samples collected)"';
                                isErrorMsg = true;
                                recordURL = '/'+lstTissueSpecimenDetail[0].Id;
                                system.debug('errorMsg : '+errorMsg);
                        }
                }
                
                return ref;
        }
        
        public static String calculateSID(String coreSpecimen, String timePoint, String fiveDigitPId, Integer preTxSID) {
                system.debug('coreSpecimen : '+coreSpecimen);
                system.debug('timePoint : '+timePoint);
                system.debug('fiveDigitPId : '+fiveDigitPId);
                system.debug('preTxSID : '+preTxSID);
                
                if(coreSpecimen == null || timePoint == null || fiveDigitPId == null || preTxSID == null) {
                        return null;
                }
                if(timePoint == 'Pre-Treatment') {
                        return fiveDigitPId + '0' + (Integer.ValueOf(coreSpecimen) + 10);
                }
                if(timePoint == 'Early Treatment') {
                        return fiveDigitPId + '1' + (Integer.ValueOf(coreSpecimen) + 10);
                }
                if(timePoint == 'Inter-Regimen') {
                        return fiveDigitPId + '2' + (Integer.ValueOf(coreSpecimen) + 10);
                }
                if(timePoint == 'Surgery') {
                        return fiveDigitPId + '3' + (Integer.ValueOf(coreSpecimen) + 10);
                }
                if(timePoint == 'Pre-Treatment Re-Biopsy') {
                        return fiveDigitPId + '0' + (Integer.ValueOf(coreSpecimen) + 10 + preTxSID);
                }
                return 0+'';    
        }
        
        public Pagereference cancelTissueSpecimenRecord() {
                isErrorMsg = false;
                Pagereference ref = new Pagereference('/a0x/o');
                String id = Apexpages.currentPage().getParameters().get('id');
                delete [select Id from TissueSpecimenDetail__c where Id = :id];
                return ref;
        }
        public Pagereference saveMainCRF() {
                
                        if(tsId == null || tsId =='') {
                                tissueSpecimenForm.TrialPatient__c = trialPatientId;
                                RequiredFieldHandler.fromDataLoader = true;
                                insert tissueSpecimenForm;
                                tsId = tissueSpecimenForm.Id;
                        
                                Pagereference ref = new Pagereference('/'+tsId);
                                //Pagereference ref = new Pagereference('/'+tsId);
                        
                                ref.setRedirect(true);
                                return ref;
                        
                        } else {
                                return null;
                        }
                }
        
        public class CoreBiopsyWrapper {
                public boolean isShippedDisabled {get;set;}
                public boolean isCollected {get;set;}
                public String coreBiopsyNumber {get;set;}
                public boolean isReasonDisabled {get;set;}
                public boolean isOtherDisabled {get;set;}
                public Core_Biopsy_Specimens__c coreBiopsySpecimen {get;set;}
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
        
        /*
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
        */
        
        //Select  c.Trial__c, c.TrialPatient__c, c.Site__c, c.Patient__c, c.Name, c.Id, c.Detail__c From CRF__c
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        
        //Select t.TrialPatient__c, t.Status__c, t.RecordTypeId, t.Patient__c, t.NumberOfSamplesCollected__c, t.Name, t.Effective_Time__c, t.CRFId__c From TissueSpecimenDetail__c t
        
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
        insert tissue;
        
        
        Apexpages.currentPage().getParameters().put('isxmlpage','False');  
        ApexPages.currentPage().getParameters().put('trialPat',tp.Id);   
        Apexpages.currentPage().getParameters().put('tsId',tissue.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(tissue);
        TissueSpecimenFormController con = new TissueSpecimenFormController(controller);
        con.tissueSpecimenForm = tissue;
        
        Test.startTest();
        
        //con.submitRegistration();
        con.viewXML();
        TissueSpecimenFormController.submitTissueSpecimen(tissue.Id,tp.Id, p.Id);
        ExternalServiceConnector.populateFailedRegistration('TissueSpecimenDetail__c',tissue.Id,false,p.id, t.id, site1.Id,null, 'errorCode', 'Error message', 'Failure','System', '123','100','1000');
        Test.stopTest();
    }
}