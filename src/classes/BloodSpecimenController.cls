public with sharing class BloodSpecimenController {
        public String errorMsg {get;set;}
        public BloodSpecimenForm__c bloodSpecimen {get;set;}
        public List<SerumSpecimenWrapper> lstSerumSpecimenWrapper {get;set;}
        public List<PlasmaSpecimenWrapper> lstPlasmaSpecimenWrapper {get;set;}
        public List<BuffySpecimenWrapper> lstBuffySpecimenWrapper {get;set;}
        public boolean isReasonAllDisabled {get;set;}
        public boolean isOtherReasonAllDisabled {get;set;}
        public boolean showReasonSec {get;set;}
        public String currentTab {get;set;}
        public String trialPatientId = null;
        public String trialPatientName {get;set;}
        public String patientId {get;set;} 
        public String password {get;set;}
        public integer numberOfSerumCollected = 0;
        public integer numberOfPlasmaCollected = 0;
        public integer numberOfBuffyCollected = 0;
        public Id bloodSpecimenId = null;
        public Boolean isComplete {get;set;}
       // public Boolean isDelete{get;set;}
        public String nextTabName{get;set;}
        public TrialPatient__c trialPatientObj {get;set;}
        //added by amit
        public String radioValue{get;set;}
        public String xmlOutput{get;set;}
        private string isxmlpage {get;set;}
        public String profileName{get;set;} 
       // public BloodSpecimenForm__c pathObj{get;set;}
        public Boolean isDelete{get;set;}   // For Delete //
        
        public void viewXML() {
        
            System.debug('Amit======================witin ViewXML');
            ExternalServiceConnector serviceConnector = new ExternalServiceConnector('iHub');
            
            try{
                cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
                cdapackage.author author = new cdapackage.author();
                cdapackage.patient patient = new cdapackage.patient();
                cdapackage.procedure procedure = new cdapackage.procedure();
                //cdapackage.guidanceMethod[] guidanceArray = new cdapackage.guidanceMethod[]{};
                
                cdapackage.guidanceMethod[] guidanceArray = new cdapackage.guidanceMethod[1];
                cdapackage.guidanceMethod gm = new cdapackage.guidanceMethod();
                gm.valueDisplayName='Guidance for Breast Core Biopsy';
                gm.valueOriginalText='Guidance for Breast Core Biopsy';
                gm.valueCode='NA';
                guidanceArray[0] = gm;
                
                cdapackage.specimen[] specimenArray;
                String xmlType = (radioValue==null? 'CDA' : radioValue);
                author.idExtension = UserInfo.getUserName();
                 
                clinicalDoc.id=bloodSpecimen.id;
                clinicalDoc.title = 'Create Biospecimen';
                if(bloodSpecimen.Effective_Time__c!=null){
                    clinicalDoc.effectiveTime=String.valueOf(bloodSpecimen.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
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
                clinicalDoc.studySubjectIdentifier=trialPatientObj.Subject_Id__c;
                
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
                //procedure.specimenClass='Serum Specimen';
                //procedure.specimenClassCode='119364003';
                
                procedure.collectionProtocolShortTitle='Venipuncture';
                procedure.collectionProtocolTitle='Venipuncture';
                procedure.specimenCharacteristicsSide='Right';
                procedure.specimenCharacteristicsSideCode='24028007';
                procedure.specimenCharacteristicsSite='Not Specified';
                procedure.specimenClass='Fluid';
                procedure.specimenClassCode='258442002';
                //procedure.studyCalendarEventTimePoint=bloodSpecimen.Time_Point__c;
                if(bloodSpecimen.CollectionDate__c!=null){
                    procedure.collectionDate =String.valueOf(bloodSpecimen.CollectionDate__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
                }
                
                List<BloodSpecimenInfo__c> specimenList = [Select b.pg_bloodspecimeninfo_Id__c, b.Specimen_ID__c, b.Shipped__c, b.Reason_samples_not_shipped__c, b.Other_Reason_samples_not_shipped__c, b.Name, b.Id From BloodSpecimenInfo__c b where b.BloodSpecimenForm__c =:bloodSpecimen.Id];
        
                specimenArray = new cdapackage.specimen[specimenList.size()];
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
                        //sp.specimenCode ='258587000'; 
                        //sp.specimenDisplayName ='Buffy coat';
                        sp.specimenCode ='258580003'; 
                        sp.specimenDisplayName ='Whole Blood'; 
                        sp.availableQuantity='0.2';
                    }
                    
                    sp.initialQuantity='1';
                    
                    sp.availableQuantityUnit='mL';    
                    
                    sp.initialQuantityUnit='mL';
                    
                                      
                    if(bloodSpecimen.Time_Point__c=='Pre-treatment'){
                        sp.studyCalendarEventTimePoint='0';
                    }else if(bloodSpecimen.Time_Point__c=='Early treatment'){
                        sp.studyCalendarEventTimePoint='1';
                    }else if(bloodSpecimen.Time_Point__c=='Inter-regimen'){
                        sp.studyCalendarEventTimePoint='2';
                    }else if(bloodSpecimen.Time_Point__c=='Pre-Surgery'){
                        sp.studyCalendarEventTimePoint='3';
                    }
                    //sp.studyCalendarEventTimePoint;
                    sp.studyCalendarEventTimePointUnit='d';
                    
                    specimenArray[i]=sp;
                }
               
                if(Test.isRunningTest()) {
                    xmlOutput= '<xml>Test XML</xml>';
                }else{
                    xmlOutput = serviceConnector.ihub.generateBioCDA(clinicalDoc ,author,patient,procedure,specimenArray,guidanceArray ,xmlType);
                }
                System.debug('xmlOutput='+xmlOutput);
                
                if(xmlOutput!=null){
                    ExternalServiceConnector.viewXML(xmlOutput, bloodSpecimen.Id,'BloodSpecimenXML ');
                    /*Attachment att = new Attachment();
                    att.ContentType = 'application/xml';
                    //att.Body = ref.getContent();
                    //String xml = generateXML();
                    if(xmlOutput == null) {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient Data to Generate XML'));
                        return;
                    }
                    //att.Body = Blob.valueOf(generateXML());
                    att.Body = Blob.valueOf(xmlOutput );
                    att.Name = 'BloodSpecimenXML '+system.today();
                    att.ParentId = bloodSpecimen.Id;
                    insert att;
                    system.debug('--att--'+att);*/
                }
                
            }catch(Exception e){
                System.debug(e);
            }
            System.debug(xmlOutput);
          
          
        }
        //end adedd by amit 
        
        public pagereference redirect(){
            pagereference redirect = new pagereference('/apex/BloodSpecimenFormPdf?id='+bloodSpecimenId);
            redirect.setRedirect(true);
            return redirect;
        }

        public BloodSpecimenController(Apexpages.StandardController std) { 
               // pathObj = new BloodSpecimenForm__c();
                
                //isDelete = false;
                System.debug('BloodSpecimen-------'+std.getId());
                bloodSpecimenId = std.getId();
                BloodSpecimenForm__c bldSpecimenForm;
                if(bloodSpecimenId != null)bldSpecimenForm = [Select b.TrialPatient__c, b.Id From BloodSpecimenForm__c b where id =: bloodSpecimenId];
                //-----------------------delete button fuctionlity- start------------------------- 
                IsDelete = false;
                IsDelete();
                system.debug('outside DELETE' + IsDelete);
                if(IsDelete){
                system.debug('INSIDE DELETE');
                String currentUserId = UserInfo.getUserId();
                for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
                    profileName = u.Profile.Name; 
                }  
                }   
                //-----------------------delete button fuctionlity- start-------------------------
                system.debug('Constructor Called');
                //currentTab = 'BloodIdtab';
                isxmlpage = Apexpages.currentPage().getParameters().get('isxmlpage');
                
                if(bldSpecimenForm != null){
                    trialPatientId = bldSpecimenForm.TrialPatient__c;
                    bloodSpecimenId = bldSpecimenForm.id;                   
                }else{
                    trialPatientId = Apexpages.currentPage().getParameters().get('trialPat'); 
                    bloodSpecimenId = Apexpages.currentPage().getParameters().get('bloodSpecimenId'); 
                }
                system.debug('=====bloodSpecimenIdConstructor===='+bloodSpecimenId);
                List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name,Subject_Id__c,Site__c,Site__r.Name  from TrialPatient__c where Id = :trialPatientId];
                if(!lstTrialPatient.IsEmpty()) {
                        trialPatientName = lstTrialPatient[0].Name;
                        trialPatientObj = lstTrialPatient[0];
                        patientId = lstTrialPatient[0].Patient_Id__c;
                } 
                bloodSpecimen = new BloodSpecimenForm__c();
                isReasonAllDisabled = true;
                isOtherReasonAllDisabled = true;
                isComplete = true;
                lstSerumSpecimenWrapper = new List<SerumSpecimenWrapper>(); 
                for(integer i=1;i<=3;i++) {
                        SerumSpecimenWrapper serumSpecimen = new SerumSpecimenWrapper();
                        serumSpecimen.bloodSpecimenInfo = new BloodSpecimenInfo__c();
                        serumSpecimen.isCollected = false;
                        serumSpecimen.SpecimenNumber = 'Serum Specimen #'+i;
                        serumSpecimen.isShippedDisabled = true;
                        serumSpecimen.isReasonDisabled = true;
                        serumSpecimen.isOtherDisabled = true;
                        lstSerumSpecimenWrapper.add(serumSpecimen);
                }
                
                lstPlasmaSpecimenWrapper = new List<PlasmaSpecimenWrapper>(); 
                for(integer i=1;i<=3;i++) {
                        PlasmaSpecimenWrapper plasmaSpecimen = new PlasmaSpecimenWrapper();
                        plasmaSpecimen.isCollected = false;
                        plasmaSpecimen.bloodSpecimenInfo = new BloodSpecimenInfo__c();
                        plasmaSpecimen.SpecimenNumber = 'Plasma Specimen #'+i;
                        plasmaSpecimen.isShippedDisabled = true;
                        plasmaSpecimen.isReasonDisabled = true;
                        plasmaSpecimen.isOtherDisabled = true;
                        lstPlasmaSpecimenWrapper.add(plasmaSpecimen);
                }
                
                lstBuffySpecimenWrapper = new List<BuffySpecimenWrapper>(); 
                for(integer i=1;i<=2;i++) {
                        BuffySpecimenWrapper buffySpecimen = new BuffySpecimenWrapper();
                        buffySpecimen.bloodSpecimenInfo = new BloodSpecimenInfo__c();
                        buffySpecimen.isCollected = false;
                        buffySpecimen.SpecimenNumber = 'Buffy coat specimen #'+i;
                        buffySpecimen.isShippedDisabled = true;
                        buffySpecimen.isReasonDisabled = true;
                        buffySpecimen.isOtherDisabled = true;
                    lstBuffySpecimenWrapper.add(buffySpecimen);
                }
                
                //bloodSpecimenId = std.getId();
                if(bloodSpecimenId != null) {
                        editBloodSpecimenForm();
                }
                isComplete = CRFUtilities.isReadOnlyUsr(); 
                if(bloodSpecimen != null){
                        //String crfId = bloodSpecimen.CRF__c;
                        //if(crfId != null && crfId != ''){
                            //String status = CRFUtilities.CRFStatus(crfId);
                            String status = bloodSpecimen.Status__c;
                            if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                                    currentTab = 'CompleteTab';
                                    isComplete = false; 
                            } else {
                                    currentTab = 'Blood';
                            }
                        //}
                }
                system.debug('lstSerumSpecimenWrapper : '+lstSerumSpecimenWrapper);
                
             if(isxmlpage != null) {
                List<Attachment> lstAtt = [select Body from Attachment where ParentId = :bloodSpecimen.Id order by CreatedDate DESC];
                if(!lstAtt.isEmpty()) {
                    //xmlOutput = Encodingutil.base64Encode(lstAtt[0].Body);
                    xmlOutput = lstAtt[0].Body.toString();
                    system.debug('--Controller-lstAtt[0].Body.toString--'+lstAtt[0].Body.toString());
                    //IsXMLGenerated = true;  
                } else {
                    //IsXMLGenerated = false;
                }
            }
           // isDelete();
            System.debug('bloodSpecimenId-----const-------'+bloodSpecimenId);
        }
      //-----------------------delete button fuctionlity- start-------------------------  
      public void isDelete(){
        BloodSpecimenForm__c bldSpecimenForm;
        System.debug('====== bloodSpecimenId=======' + bloodSpecimenId );
        if(bloodSpecimenId != null){
        bldSpecimenForm = [select Id, Status__c,Root_CRF_Id__c from BloodSpecimenForm__c where id =: bloodSpecimenId ];
            
            if(bldSpecimenForm.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
        System.debug('======bldSpecimenForm =======' +bldSpecimenForm );
    }
     //-----------------------delete button fuctionlity- end --------------------------
     /*   public void isDelete(){
        
        System.debug('======trialPatientId=======' +trialPatientId);
        if(trialPatientId != null && trialPatientId != ''){
            pathObj = [select Id, Status__c from BloodSpecimenForm__c where id =:trialPatientId];

            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======pathObj =======' +pathObj);
    }*/
        
        public void addSpecimen() {
                lstSerumSpecimenWrapper = new List<SerumSpecimenWrapper>(); 
                for(integer i=1;i<=3;i++) {
                        SerumSpecimenWrapper serumSpecimen = new SerumSpecimenWrapper();
                        serumSpecimen.bloodSpecimenInfo = new BloodSpecimenInfo__c();
                        serumSpecimen.isCollected = false;
                        serumSpecimen.SpecimenNumber = 'Serum Specimen #'+i;
                        serumSpecimen.isShippedDisabled = true;
                        serumSpecimen.isReasonDisabled = true;
                        serumSpecimen.isOtherDisabled = true;
                        lstSerumSpecimenWrapper.add(serumSpecimen);
                }
                
                lstPlasmaSpecimenWrapper = new List<PlasmaSpecimenWrapper>(); 
                for(integer i=1;i<=3;i++) {
                        PlasmaSpecimenWrapper plasmaSpecimen = new PlasmaSpecimenWrapper();
                        plasmaSpecimen.isCollected = false;
                        plasmaSpecimen.bloodSpecimenInfo = new BloodSpecimenInfo__c();
                        plasmaSpecimen.SpecimenNumber = 'Plasma Specimen #'+i;
                        plasmaSpecimen.isShippedDisabled = true;
                        plasmaSpecimen.isReasonDisabled = true;
                        plasmaSpecimen.isOtherDisabled = true;
                        lstPlasmaSpecimenWrapper.add(plasmaSpecimen);
                }
                
                lstBuffySpecimenWrapper = new List<BuffySpecimenWrapper>(); 
                for(integer i=1;i<=2;i++) {
                        BuffySpecimenWrapper buffySpecimen = new BuffySpecimenWrapper();
                        buffySpecimen.bloodSpecimenInfo = new BloodSpecimenInfo__c();
                        buffySpecimen.isCollected = false;
                        buffySpecimen.SpecimenNumber = 'Buffy coat specimen #'+i;
                        buffySpecimen.isShippedDisabled = true;
                        buffySpecimen.isReasonDisabled = true;
                        buffySpecimen.isOtherDisabled = true;
                    lstBuffySpecimenWrapper.add(buffySpecimen);
                }
               
        }
        //===============================For Next tab==========================================================
        public Pagereference next() {
                system.debug('__currentTab__'+currentTab);
                String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
                system.debug('__nextTabValue__'+nextTabValue);
                BloodSpecimenForm__c bldSpecimenForm;
                system.debug('===bloodSpecimenId====='+bloodSpecimenId);
                if(bloodSpecimenId != null){
                bldSpecimenForm = [select Id, Status__c from BloodSpecimenForm__c where id =: bloodSpecimenId ];
                
                if(bldSpecimenForm.Status__c == 'Approval Not Required'){
                System.debug('====bloodSpecimen===='+bloodSpecimen);
                System.debug('====bldSpecimenForm.Status__c===='+bldSpecimenForm.Status__c);
                System.debug('====bloodSpecimen===='+bloodSpecimen);
                isComplete= false;
                currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/BloodSpecimenForm?id='+bloodSpecimenId);
                Pagereference ref = new Pagereference('/'+bloodSpecimenId);
                ref.setRedirect(true);
                return ref;
             }
             }
                if(nextTabValue != null){
                        nextTabName = nextTabValue;
                }
                if(currentTab == 'ConsentTab') {
                           //currentTab = nextTabValue;
                           Pagereference ref = saveCRF(); 
                           system.debug('attachmentTab===='+nextTabValue);
                          // upsert tissueSpecimenForm;
                           //system.debug('tissueSpecimenForm===='+tissueSpecimenForm); 
                 } else if(currentTab == 'Blood') { 
                           Pagereference ref = saveCRF();
                           
                           if(ref == null) {
                                //currentTab = nextTabValue;
                                return null;
                           }
                           showReasonSec = true;   
                           system.debug('ConsentTab===='+nextTabValue);
                 } 
                 
                  if(nextTabName == 'CompleteTab') {   
                           //currentTab = nextTabValue;
                           //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
                           //completeCrf.customAdhoc(bloodSpecimen.Id+'', 'submit', 'Site');
                           bloodSpecimenId = bloodSpecimen.Id;
                           editBloodSpecimenForm();
                           system.debug('CompleteTab===='+nextTabValue);
                
                        /*lstSerumSpecimenWrapper.clear();
                        lstPlasmaSpecimenWrapper.clear();
                        lstBuffySpecimenWrapper.clear();
                        integer SpecimenNumber = 0;
                        List<BloodSpecimenInfo__c> tmpBloodSpeciInfoList = [Select b.pg_bloodspecimeninfo_Id__c, b.SystemModstamp, b.Specimen_ID__c, b.Shipped__c, b.Reason_samples_not_shipped__c, b.OwnerId, b.Other_Reason_samples_not_shipped__c, b.Name, b.LastModifiedDate, b.LastModifiedById, b.IsDeleted, b.Id, b.CreatedDate, b.CreatedById, b.BloodSpecimenForm__c From BloodSpecimenInfo__c b where BloodSpecimenForm__c =:bloodSpecimen.Id order by CreatedDate DESC ];
                        for(BloodSpecimenInfo__c bsi : tmpBloodSpeciInfoList) {
                                if(bsi.Name.contains('Serum Specimen #') && bsi.Shipped__c != null) {
                                        SerumSpecimenWrapper serumSpecimen = new SerumSpecimenWrapper();
                                        serumSpecimen.bloodSpecimenInfo = bsi;
                                        serumSpecimen.isCollected =true;
                                        serumSpecimen.SpecimenNumber = 'Serum Specimen #'+(++SpecimenNumber) ;
                                        serumSpecimen.isShippedDisabled = false;
                                        lstSerumSpecimenWrapper.add(serumSpecimen);
                                }
                                if(bsi.Name.contains('Plasma Specimen #') && bsi.Shipped__c != null) {
                                        PlasmaSpecimenWrapper plasmaSpecimen = new PlasmaSpecimenWrapper();
                                        plasmaSpecimen.bloodSpecimenInfo = bsi;
                                        plasmaSpecimen.isCollected =true;
                                        plasmaSpecimen.SpecimenNumber = 'Plasma Specimen #'+(++SpecimenNumber) ;
                                        plasmaSpecimen.isShippedDisabled = false;
                                        lstPlasmaSpecimenWrapper.add(plasmaSpecimen);
                                } 
                                if(bsi.Name.contains('Buffy coat specimen #') && bsi.Shipped__c != null) {
                                        BuffySpecimenWrapper buffySpecimen = new BuffySpecimenWrapper();
                                        buffySpecimen.bloodSpecimenInfo = bsi;
                                        buffySpecimen.isCollected =true;
                                        buffySpecimen.SpecimenNumber = 'Buffy coat specimen #'+(++SpecimenNumber) ;
                                        buffySpecimen.isShippedDisabled = false;
                                        lstBuffySpecimenWrapper.add(buffySpecimen);
                                }
                        }
                        System.debug('lstSerumSpecimenWrapper : '+lstSerumSpecimenWrapper);
                        System.debug('lstPlasmaSpecimenWrapper : '+lstPlasmaSpecimenWrapper);
                        System.debug('lstBuffySpecimenWrapper : '+lstBuffySpecimenWrapper);*/
                 }
                if(nextTabName == 'saveAndClose') {
                    bloodSpecimen.First_Save_and_Close__c = true;
                    
                        
                            System.debug('====bloodSpecimen===='+bloodSpecimen);
                           
                                 if(bldSpecimenForm.Status__c == 'Approval Not Required'){
                                    System.debug('====bloodSpecimen===='+bloodSpecimen);
                                    System.debug('====bldSpecimenForm.Status__c===='+bldSpecimenForm.Status__c);
                                    System.debug('====bloodSpecimen===='+bloodSpecimen);
                                    isComplete= false;
                                   // Pagereference ref = new Pagereference('/apex/BloodSpecimenForm?id='+bloodSpecimenId);
                                    Pagereference ref = new Pagereference('/'+bloodSpecimenId);
                                    ref.setRedirect(true);
                                    return ref;
                                 }
                                 else
                                 {   
                                 update bloodSpecimen;
                                 System.debug('====bloodSpecimen===='+bloodSpecimen);
                                 }
                            
                            
                      /*  catch (Exception e) {
                            System.debug('====bloodSpecimen===='+bloodSpecimen);
                            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                            Apexpages.addMessage(msg);
                       // Added by Shruti (DE401)
                             // Pagereference ref = new Pagereference('/apex/BloodSpecimenForm?id='+bloodSpecimenId);
                              Pagereference ref = new Pagereference('/'+bloodSpecimenId);
                             
                     // Added by Shruti (DE401)
                        } */
                        List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:trialPatientId];
                        if(!trialPatList.isEmpty()) {
                                Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
                                //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
                                pr.setRedirect(true);
                                return pr;
                        }    
                }
                currentTab = nextTabName;
                return null;    
        }
        public Pagereference customCancel() { 
        List<TrialPatient__c> trialPatList = [select Patient_Id__c,Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
        
        BloodSpecimenForm__c bldSpecimenForm;
                system.debug('===bloodSpecimenId====='+bloodSpecimenId);
                if(bloodSpecimenId != null){
                bldSpecimenForm = [select Id, Status__c from BloodSpecimenForm__c where id =: bloodSpecimenId ];
                
                if(bldSpecimenForm.Status__c == 'Approval Not Required'){
                System.debug('====bloodSpecimen===='+bloodSpecimen);
                System.debug('====bldSpecimenForm.Status__c===='+bldSpecimenForm.Status__c);
                System.debug('====bloodSpecimen===='+bloodSpecimen);
                if(profileName !='System Administrator'){
               // isComplete= false;
               // currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/BloodSpecimenForm?id='+bloodSpecimenId);
                Pagereference ref = new Pagereference('/'+bloodSpecimenId);
                ref.setRedirect(true);
                return ref;
                }
                else
                                 {   
                                 delete bloodSpecimen;
                                 System.debug('====bloodSpecimen===='+bloodSpecimen);
                                 }
             
             }
             else
                                 {   
                                 delete bloodSpecimen;
                                 System.debug('====bloodSpecimen===='+bloodSpecimen);
                                 }
             }
        
        
      /*  if(bloodSpecimen.Id != null) {
                    // Added by Shruti (DE401)
                    try {
                            delete bloodSpecimen;
                        }catch (Exception e) {
                            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                            Apexpages.addMessage(msg);                       
                            // Pagereference ref = new Pagereference('/apex/BloodSpecimenForm?id='+bloodSpecimenId);
                             Pagereference ref = new Pagereference('/'+bloodSpecimenId);
                             ref.setRedirect(true);
                             return ref;
                         }     
                     // Added by Shruti (DE401)                        
                
        }*/
                
              //  System.debug('-----Deleted---->');
                //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
                Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
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
                BloodSpecimenForm__c bldSpecimenForm;
                system.debug('===bloodSpecimenId====='+bloodSpecimenId);
                if(bloodSpecimenId != null){
                bldSpecimenForm = [select Id, Status__c from BloodSpecimenForm__c where id =: bloodSpecimenId ];
                
                if(bldSpecimenForm.Status__c == 'Approval Not Required'){
                System.debug('====bloodSpecimen===='+bloodSpecimen);
                System.debug('====bldSpecimenForm.Status__c===='+bldSpecimenForm.Status__c);
                System.debug('====bloodSpecimen===='+bloodSpecimen);
                isComplete= false;
                currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/BloodSpecimenForm?id='+bloodSpecimenId);
                Pagereference ref = new Pagereference('/'+bloodSpecimenId);
                ref.setRedirect(true);
                return ref;
             }
             }
                 /*   try {
                            update bloodSpecimen;
                        }catch (Exception e) {
                            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                            Apexpages.addMessage(msg);                       
                            // Pagereference ref = new Pagereference('/apex/BloodSpecimenForm?id='+bloodSpecimenId);
                             Pagereference ref = new Pagereference('/'+bloodSpecimenId);
                             ref.setRedirect(true);
                             return ref;
                         }*/
                             return null;     
                     // Added by Shruti (DE401)    
        } 
        
        //===========================Sign And Submit for Site User in AE CRF===========================================                 
        public Pagereference signAndSubmit() {
                //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
                //completeCrf.customAdhoc(bloodSpecimen.Id+'', 'submit', 'Site');
                //submitBloodSpecimen();
                SignAndSubmitController signSubmit = new SignAndSubmitController();
                signSubmit.password = password;
                Pagereference ref = signSubmit.signAndSubmit('00052','',bloodSpecimen.Id+'', 'Site'); 
                system.debug('errorMsg :  '+signSubmit.errorMsg);
                errorMsg = signSubmit.errorMsg;
                msgColor = 'Red';
                //isDelete= true;
                List<BloodSpecimenForm__c> bloodList = [Select Status__c from BloodSpecimenForm__c where id = :bloodSpecimen.Id and Status__c='Approval Not Required'];
                if(!bloodList.isEmpty()){
                    submitBloodSpecimen(bloodSpecimen.Id,trialPatientId, patientId);
                } 
                return ref;
        }
    @future (callout=true)
    private static void submitBloodSpecimen(Id bloodSpecimenFormId,Id trialPatientId, Id patientId){
     
        //CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='BloodSpecimenForm__c' limit 1]; 
        CRFMaster__c crfmst = [Select c.Id From CRFMaster__c c where c.Object_Name__c ='Registration__c' limit 1]; 
        
        
        //To fetch admin xml configuration
        List<XML_Configuration__c> xmlPatientList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'Patient_Custom__c'];
        //List<XML_Configuration__c> xmlTissueSpecimenList = [Select id, Field_API_Name__c from XML_Configuration__c where CRF_Type__c = :crfmst.Id and Object_API_Name__c = 'BloodSpecimenForm__c'];
        Set<String> patientSet = new Set<String>();
        for(XML_Configuration__c x: xmlPatientList){
            patientSet.add(x.Field_API_Name__c);
        }
        //Set<String> tissueSpecimenSet = new Set<String>();
        //for(XML_Configuration__c x: xmlTissueSpecimenList ){
        //    tissueSpecimenSet.add(x.Field_API_Name__c);
        //} 
        TrialPatient__c trialPatientObj = [select Name, Patient_Id__c, Trial_Id__r.Name,Trial_Id__c,Subject_Id__c ,Site__c,Site__r.Name from TrialPatient__c where Id = :trialPatientId];
              
        
        
        ExternalServiceConnector serviceConnector = new ExternalServiceConnector('iHub');
        
        cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
        cdapackage.author author = new cdapackage.author();
        cdapackage.patient patient = new cdapackage.patient();
        cdapackage.procedure procedure = new cdapackage.procedure();
        cdapackage.specimen[] specimenArray;
        
        cdapackage.guidanceMethod[] guidanceArray = new cdapackage.guidanceMethod[1];
        cdapackage.guidanceMethod gm = new cdapackage.guidanceMethod();
        gm.valueDisplayName='Guidance for Breast Core Biopsy';
        gm.valueOriginalText='Guidance for Breast Core Biopsy';
        gm.valueCode='NA';
        guidanceArray[0] = gm;
        
        //String xmlType = (radioValue==null? 'CDA' : radioValue);
        String xmlType = 'CDA';
        author.idExtension = UserInfo.getUserName();
        
        
        
        BloodSpecimenForm__c bloodSpecimen2;
        List<BloodSpecimenForm__c> BSFList = [Select b.Root_CRF_Id__c,b.Effective_Time__c,b.TrialPatient__c, b.TrialPatient__r.Name, b.CRF__c,b.TrialPatient__r.Patient_Id__c, b.Time_Point__c, b.Status__c, b.Reason_all_samples_not_collected__c, b.Phase__c, b.Other_Reason_samples_not_shipped__c, b.Name, b.Id, b.Contented_specimen_outside_study__c, b.Consented_to_use_specimen_study__c, b.CompletedDate__c, b.CollectionDate__c, b.CreatedDate,(Select Name, BloodSpecimenForm__c, Shipped__c, Reason_samples_not_shipped__c, Other_Reason_samples_not_shipped__c, Specimen_ID__c From BloodSpecimenInfo__r) From BloodSpecimenForm__c b where Id = :bloodSpecimenFormId];
        if(!BSFList.isEmpty()) {
            bloodSpecimen2 = BSFList[0]; 
        }
        clinicalDoc.id=bloodSpecimen2.id;
        clinicalDoc.title = 'Create Biospecimen';
        if(bloodSpecimen2.Effective_Time__c!=null){
            clinicalDoc.effectiveTime=String.valueOf(bloodSpecimen2.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
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
        procedure.barcode='1098';//
        //procedure.collectionProtocolShortTitle=trialPatientObj.Trial_Id__r.Name;
        //procedure.collectionProtocolTitle=trialPatientObj.Trial_Id__r.Name;
        procedure.collectionProtocolShortTitle='Venipuncture';
        procedure.collectionProtocolTitle='Venipuncture';
        procedure.specimenCharacteristicsSide='Not Specified';
        procedure.specimenCharacteristicsSideCode='397206002';
        procedure.specimenCharacteristicsSite='Not Specified';
        procedure.specimenClass='Fluid';
        procedure.specimenClassCode='258442002';
        //procedure.studyCalendarEventTimePoint=bloodSpecimen2.Time_Point__c;
        
        //if(bloodSpecimen2.Time_Point__c=='Pre-treatment'){
        //    procedure.studyCalendarEventTimePoint='0';
        //}else if(bloodSpecimen2.Time_Point__c=='Early treatment'){
        //    procedure.studyCalendarEventTimePoint='1';
        //}else if(bloodSpecimen2.Time_Point__c=='Inter-regimen'){
        //    procedure.studyCalendarEventTimePoint='2';
        //}else if(bloodSpecimen2.Time_Point__c=='Pre-Surgery'){
        //    procedure.studyCalendarEventTimePoint='3';
        //}
        
        if(bloodSpecimen2.CollectionDate__c!=null){
            procedure.collectionDate =String.valueOf(bloodSpecimen2.CollectionDate__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
        }
        //Retrive all Specimen id for a time point and trial patient id which have been successfully intergated
        Set<String> oldSpecimenIdSet = new Set<String>();
        List<BloodSpecimenInfo__c> previousSpecimenList = [Select b.Specimen_ID__c From BloodSpecimenInfo__c b where b.Specimen_ID__c !=null and b.Is_Integration_Success__c=true and b.BloodSpecimenForm__c !=:bloodSpecimen2.Id and Shipped__c='Yes' and b.BloodSpecimenForm__r.Time_Point__c=:bloodSpecimen2.Time_Point__c and b.BloodSpecimenForm__r.TrialPatient__c=:trialPatientId];
        for(BloodSpecimenInfo__c b :previousSpecimenList){
            oldSpecimenIdSet.add(b.Specimen_ID__c);
        }
        
        List<BloodSpecimenInfo__c> specimenList = [Select b.pg_bloodspecimeninfo_Id__c, b.Specimen_ID__c, b.Shipped__c, b.Reason_samples_not_shipped__c, b.Other_Reason_samples_not_shipped__c, b.Name, b.Id,b.Is_Integration_Success__c From BloodSpecimenInfo__c b where b.Specimen_ID__c !=null and b.BloodSpecimenForm__c =:bloodSpecimen2.Id and Shipped__c='Yes'];
        
        //Amit specimenArray = new cdapackage.specimen[specimenList.size()];
        List<cdapackage.specimen> specimenUpdateList = new List<cdapackage.specimen>();
        List<cdapackage.specimen> specimenAddList = new List<cdapackage.specimen>();
        
        for(Integer i=0;I<specimenList.size();i++){
            BloodSpecimenInfo__c specimen = specimenList[i];
            cdapackage.specimen sp= new cdapackage.specimen();
            sp.specimenID = specimen.Specimen_ID__c;
            List<String> aList = specimen.Name.split('#');
            String aStr = aList[0];
            //sp.specimenDisplayName=aStr;
            if(aStr.contains('Serum')){
                sp.specimenCode ='119364003';
                sp.specimenDisplayName ='Serum';
                sp.availableQuantity='1'; 

            }else if(aStr.contains('Plasma')){
                sp.specimenCode ='119361006';
                sp.specimenDisplayName ='Plasma'; 
                sp.availableQuantity='1';
                sp.availableQuantity='1';
            }else if(aStr.contains('Buffy coat')){
                sp.specimenCode =''; 
                sp.specimenDisplayName ='Buffy Coat'; 
                sp.availableQuantity='0.2';
            }
            
            sp.initialQuantity='1';
            
            sp.availableQuantityUnit='mL';    
            
            sp.initialQuantityUnit='mL';
            
            if(bloodSpecimen2.Time_Point__c=='Pre-treatment'){
                sp.studyCalendarEventTimePoint='0';
            }else if(bloodSpecimen2.Time_Point__c=='Early treatment'){
                sp.studyCalendarEventTimePoint='1';
            }else if(bloodSpecimen2.Time_Point__c=='Inter-regimen'){
                sp.studyCalendarEventTimePoint='2';
            }else if(bloodSpecimen2.Time_Point__c=='Pre-Surgery'){
                sp.studyCalendarEventTimePoint='3';
            }
            
            //else if(bloodSpecimen2.Time_Point__c=='Surgery'){
            //    sp.studyCalendarEventTimePoint='4';
            //}
            //sp.studyCalendarEventTimePoint;
            sp.studyCalendarEventTimePointUnit='d';
            //AMit specimenArray[i]=sp;
            if(oldSpecimenIdSet.contains(specimen.Specimen_ID__c)){
                specimenUpdateList.add(sp);
            }else{
                specimenAddList.add(sp);
            }
        }
        
        //Boolean isChangeInConsent = false;
        cdapackage.consent consent = new cdapackage.consent();
        cdapackage.consent[] consentArray = null;
        /*
        //List<TissueSpecimenDetail__c> lstTS = [Select t.CompletedDate__c,t.TrialPatient__c, t.TrialPatient__r.Patient_Id__c, t.TrialPatient__r.Name, t.Time_Point__c, t.SystemModstamp, t.Status__c, t.RecordTypeId, t.Reason_all_samples_not_collected__c, t.ProcedureDate__c, t.Phase__c, t.Patient__c, t.PatientConsentedStudy__c, t.PatientConsentedOutsideStudy__c, t.OwnerId, t.Other_Reason_not_all_samples_collected__c, t.Other_Guidance_Method__c, t.NumberOfSamplesCollected__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Guidance_Method_s__c, t.Effective_Time__c, t.CreatedById, t.CRFId__c From TissueSpecimenDetail__c t where Patient__c = :patientId and TrialPatient__c=:trialPatientId and Time_Point__c=:bloodSpecimen.Time_Point__c  order by CompletedDate__c desc ];
        List<BloodSpecimenForm__c> lstBSF = [Select b.Effective_Time__c,b.TrialPatient__c, b.TrialPatient__r.Name, b.CRF__c,b.TrialPatient__r.Patient_Id__c, b.Time_Point__c, b.Status__c, b.Reason_all_samples_not_collected__c, b.Phase__c, b.Other_Reason_samples_not_shipped__c, b.Name, b.Id, b.Contented_specimen_outside_study__c, b.Consented_to_use_specimen_study__c, b.CompletedDate__c, b.CollectionDate__c, (Select Name, BloodSpecimenForm__c, Shipped__c, Reason_samples_not_shipped__c, Other_Reason_samples_not_shipped__c, Specimen_ID__c From BloodSpecimenInfo__r) From BloodSpecimenForm__c b where TrialPatient__c=:trialPatientId and Time_Point__c=:bloodSpecimen2.Time_Point__c  order by CompletedDate__c desc];
                
        if(lstBSF.size()==0 ){
            BloodSpecimenForm__c ts = bloodSpecimen2;
            if(ts.Consented_to_use_specimen_study__c==True ||ts.Contented_specimen_outside_study__c==True){
                consent.consentDateTime=String.valueOf(ts.CreatedDate).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
                consent.tier1Response=(ts.Consented_to_use_specimen_study__c==True?'Yes':'No');
                consent.tier1ResponseCode=(ts.Consented_to_use_specimen_study__c==True?'373066001':'373067005                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ');
                consent.tier2Response=(ts.Contented_specimen_outside_study__c==True?'Yes':'No');         
                consent.tier2ResponseCode=(ts.Contented_specimen_outside_study__c==True?'373066001':'373067005');
                isChangeInConsent = true;
            }
        } else if(lstBSF.size()>0 ){
            BloodSpecimenForm__c ts1 = bloodSpecimen2;
            BloodSpecimenForm__c ts2 = lstBSF[0];
            consent.consentDateTime=String.valueOf(ts1.CreatedDate).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
            if(ts1.Consented_to_use_specimen_study__c==True && ts2.Consented_to_use_specimen_study__c==False){
                consent.tier1Response='Yes';
                consent.tier1ResponseCode='373066001';
                isChangeInConsent = true;
            }else if(ts1.Consented_to_use_specimen_study__c==False && ts2.Consented_to_use_specimen_study__c==True){
                consent.tier1Response='Withdrawn';
                consent.tier1ResponseCode='185924006';
                isChangeInConsent = true;
            }else if(ts1.Consented_to_use_specimen_study__c==False && ts2.Consented_to_use_specimen_study__c==False){
                consent.tier1Response='No';
                consent.tier1ResponseCode='373067005';
            }
            
            if(ts1.Contented_specimen_outside_study__c==True && ts2.Contented_specimen_outside_study__c==False){
                consent.tier2Response='Yes';
                consent.tier2ResponseCode='373066001';
                isChangeInConsent = true;
            }else if(ts1.Contented_specimen_outside_study__c==False && ts2.Contented_specimen_outside_study__c==True){
                consent.tier2Response='Withdrawn';
                consent.tier2ResponseCode='185924006';
                isChangeInConsent = true;
            }else if(ts1.Contented_specimen_outside_study__c==False && ts2.Contented_specimen_outside_study__c==False){
                consent.tier2Response='No';
                consent.tier2ResponseCode='373067005';
            }
            
        }  */
        consent.consentDateTime=String.valueOf(bloodSpecimen2.CreatedDate).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
        consent.tier1Response=(bloodSpecimen2.Consented_to_use_specimen_study__c==True?'Yes':'No');
        consent.tier1ResponseCode=(bloodSpecimen2.Consented_to_use_specimen_study__c==True?'373066001':'373067005');
        consent.tier2Response=(bloodSpecimen2.Contented_specimen_outside_study__c==True?'Yes':'No');         
        consent.tier2ResponseCode=(bloodSpecimen2.Contented_specimen_outside_study__c==True?'373066001':'373067005');
        //if(isChangeInConsent){
             consentArray = new cdapackage.consent[specimenList.size()]; 
             for(Integer i=0;I<specimenList.size();i++){
                BloodSpecimenInfo__c specimen = specimenList[i];
                cdapackage.consent consent1 = consent.clone();
                consent1.cdmsid = specimen.Specimen_ID__c;
                consentArray[i]=consent1;
            }
        //}
        String trialId = trialPatientObj.Trial_Id__c;  
        Boolean isSuccess = false;        
        try{
            cdapackage.response res = new cdapackage.response();
           // system.assert(false,res.Id);
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
                                
                ExternalServiceConnector.populateFailedRegistration('BloodSpecimenForm__c',bloodSpecimen2.Id,false,patientId,trialId,siteId,studyId,res.code,res.description,'Failure','caAERS',mrn,res.caXchangeId,res.id);
                
            }else if(res.status=='SUCCESS'){
                isSuccess = true;
            }
            
        }catch (System.CalloutException e){
        
            String errorCode = '5001';
            
            ExternalServiceConnector.populateFailedRegistration('BloodSpecimenForm__c',bloodSpecimen2.Id,false,patientId,trialId,siteId,studyId,errorCode,'Connection timeout when accessing CDA Service','Failure','caAERS',mrn,null,null);
             
             
        }catch(Exception e){
            System.debug(e);
            
            String errorCode = '5000';
            
            ExternalServiceConnector.populateFailedRegistration('BloodSpecimenForm__c',bloodSpecimen2.Id,false,patientId,trialId,siteId,studyId,errorCode,'Unexpected error','Failure','caAERS',mrn,null,null);
        }
        //if(isChangeInConsent){
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
                                    
                    ExternalServiceConnector.populateFailedRegistration('BloodSpecimenForm__c',bloodSpecimen2.Id,true,patientId,trialId,siteId,studyId,res2.code,res2.description,'Failure','caAERS',mrn,res2.caXchangeId,res2.id);
                    
                }
                
            }catch (System.CalloutException e){
            
                String errorCode = '5001';
                
                ExternalServiceConnector.populateFailedRegistration('BloodSpecimenForm__c',bloodSpecimen2.Id,true,patientId,trialId,siteId,studyId,errorCode,'Connection timeout when accessing CDA Service','Failure','caAERS',mrn,null,null);
                 
                 
            }catch(Exception e){
                System.debug(e);

                String errorCode = '5000';
                
                ExternalServiceConnector.populateFailedRegistration('BloodSpecimenForm__c',bloodSpecimen2.Id,true,patientId,trialId,siteId,studyId,errorCode,'Unexpected error','Failure','caAERS',mrn,null,null);
            }
            
            for(BloodSpecimenInfo__c specimen : specimenList){
                specimen.Is_Integration_Success__c =true;
                specimen.Integration_Timestamp__c = System.now();       
            }
            update specimenList;
            
        }else{
            String errorCode = '5011';
            ExternalServiceConnector.populateFailedRegistration('BloodSpecimenForm__c',bloodSpecimen2.Id,true,patientId,trialId,siteId,studyId,errorCode,'Consent request could not be submitted because preceding Biospecimen request failed','Failure','caAERS',mrn,null,null);
        }
    }

    /*public static void populateFailedRegistration(String crfId,Boolean isConsent,String patientId, String trialId, String siteId,String studyId, String errorCode, String errorMessage, String status,String systemName, String mrn,String caXchangeId, String returnId){
        String CRFName;
        List<CRFMaster__c> crfList = [Select c.CRFType__c From CRFMaster__c c where c.Object_Name__c='BloodSpecimenForm__c'];
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
        
        void editBloodSpecimenForm() {
                List<BloodSpecimenInfo__c> lstBloodSpecimenInfo = new List<BloodSpecimenInfo__c>();
                List<BloodSpecimenForm__c> lstBSF = [Select b.Root_CRF_Id__c,b.Effective_Time__c,b.TrialPatient__c, b.TrialPatient__r.Name, b.CRF__c,b.TrialPatient__r.Patient_Id__c, b.Time_Point__c, b.Status__c, b.Reason_all_samples_not_collected__c, b.Phase__c, b.Other_Reason_samples_not_shipped__c, b.Name, b.Id, b.Contented_specimen_outside_study__c, b.Consented_to_use_specimen_study__c, b.CompletedDate__c, b.CollectionDate__c, (Select Name, BloodSpecimenForm__c, Shipped__c, Reason_samples_not_shipped__c, Other_Reason_samples_not_shipped__c, Specimen_ID__c From BloodSpecimenInfo__r) From BloodSpecimenForm__c b where Id = :bloodSpecimenId];
                if(!lstBSF.isEmpty()) {
                        bloodSpecimen = lstBSF[0];
                        trialPatientId = lstBSF[0].TrialPatient__c;
                        trialPatientName = lstBSF[0].TrialPatient__r.Name;
                        patientId = lstBSF[0].TrialPatient__r.Patient_Id__c;
                        
                        lstBloodSpecimenInfo = lstBSF[0].BloodSpecimenInfo__r;
                
                        lstSerumSpecimenWrapper = new List<SerumSpecimenWrapper>();
                        lstPlasmaSpecimenWrapper = new List<PlasmaSpecimenWrapper>(); 
                        lstBuffySpecimenWrapper = new List<BuffySpecimenWrapper>(); 
                        for(BloodSpecimenInfo__c bsInfo : lstBloodSpecimenInfo) {
                                system.debug('bsInfo.Name : '+bsInfo.Name);
                                
                                if(bsInfo.Name.toUpperCase().contains('SERUM SPECIMEN #')) {
                                        SerumSpecimenWrapper serumSpecimen = new SerumSpecimenWrapper();
                                        serumSpecimen.bloodSpecimenInfo = bsInfo;
                                        serumSpecimen.isCollected = true;
                                        serumSpecimen.SpecimenNumber = bsInfo.Name;
                                        lstSerumSpecimenWrapper.add(serumSpecimen);
                                }
                                
                                if(bsInfo.Name.toUpperCase().contains('PLASMA SPECIMEN #')) {
                                        PlasmaSpecimenWrapper plasmaSpecimen = new PlasmaSpecimenWrapper();
                                        plasmaSpecimen.isCollected = true;
                                        plasmaSpecimen.bloodSpecimenInfo = bsInfo;
                                        plasmaSpecimen.SpecimenNumber = bsInfo.Name;
                                        lstPlasmaSpecimenWrapper.add(plasmaSpecimen);
                                }
                                
                                if(bsInfo.Name.toUpperCase().contains('BUFFY COAT SPECIMEN #')) {
                                        BuffySpecimenWrapper buffySpecimen = new BuffySpecimenWrapper();
                                        buffySpecimen.bloodSpecimenInfo = bsInfo;
                                        buffySpecimen.isCollected = true;
                                        buffySpecimen.SpecimenNumber = bsInfo.Name;
                                        lstBuffySpecimenWrapper.add(buffySpecimen);
                                }
                        }
                        
                        for(SerumSpecimenWrapper ssw : lstSerumSpecimenWrapper) {
                                if(ssw.bloodSpecimenInfo.Shipped__c != null) {
                                        ssw.isShippedDisabled = false;
                                        if(ssw.bloodSpecimenInfo.Shipped__c == 'No') {
                                                ssw.isReasonDisabled = false;
                                                isReasonAllDisabled = false;
                                                if(bloodSpecimen.Reason_all_samples_not_collected__c == 'Other') {
                                                        isOtherReasonAllDisabled = false;
                                                }
                                                if(ssw.bloodSpecimenInfo.Reason_samples_not_shipped__c == 'Other') {
                                                        ssw.isOtherDisabled = false;
                                                } else {
                                                        ssw.isOtherDisabled = true;
                                                }
                                        } else {
                                                ssw.isReasonDisabled = true;
                                                ssw.isOtherDisabled = true;
                                        }
                                } else {
                                        ssw.isCollected = false;
                                        ssw.isShippedDisabled = true;
                                        ssw.isReasonDisabled = true;
                                        ssw.isOtherDisabled = true;
                                }
                                if(!ssw.isCollected) {
                                        isReasonAllDisabled = false;
                                        if(bloodSpecimen.Reason_all_samples_not_collected__c == 'Other') {
                                                isOtherReasonAllDisabled = false;
                                        }
                                }
                        }
                        for(PlasmaSpecimenWrapper psw : lstPlasmaSpecimenWrapper) {
                                if(psw.bloodSpecimenInfo.Shipped__c != null) {
                                        psw.isShippedDisabled = false;
                                        if(psw.bloodSpecimenInfo.Shipped__c == 'No') {
                                                psw.isReasonDisabled = false;
                                                isReasonAllDisabled = false;
                                                if(bloodSpecimen.Reason_all_samples_not_collected__c == 'Other') {
                                                        isOtherReasonAllDisabled = false;
                                                }
                                                if(psw.bloodSpecimenInfo.Reason_samples_not_shipped__c == 'Other') {
                                                        psw.isOtherDisabled = false;
                                                } else {
                                                        psw.isOtherDisabled = true;
                                                }
                                        } else {
                                                psw.isReasonDisabled = true;
                                                psw.isOtherDisabled = true;
                                        }
                                } else {
                                        psw.isCollected = false;
                                        psw.isShippedDisabled = true;
                                        psw.isReasonDisabled = true;
                                        psw.isOtherDisabled = true;
                                }
                        }
                        
                        for(BuffySpecimenWrapper bsw : lstBuffySpecimenWrapper) {
                                if(bsw.bloodSpecimenInfo.Shipped__c != null) {
                                        bsw.isShippedDisabled = false;
                                        if(bsw.bloodSpecimenInfo.Shipped__c == 'No') {
                                                bsw.isReasonDisabled = false;
                                                isReasonAllDisabled = false;
                                                if(bloodSpecimen.Reason_all_samples_not_collected__c == 'Other') {
                                                        isOtherReasonAllDisabled = false;
                                                }
                                                if(bsw.bloodSpecimenInfo.Reason_samples_not_shipped__c == 'Other') {
                                                        bsw.isOtherDisabled = false;
                                                } else {
                                                        bsw.isOtherDisabled = true;
                                                }
                                        } else {
                                                bsw.isReasonDisabled = true;
                                                bsw.isOtherDisabled = true;
                                        }
                                } else {
                                        bsw.isCollected = false;
                                        bsw.isShippedDisabled = true;
                                        bsw.isReasonDisabled = true;
                                        bsw.isOtherDisabled = true;
                                }
                        }
                }
        }
        
        public void addMoreSpecimen() {
                String sample_type = Apexpages.currentPage().getParameters().get('type');
                integer serumSerialNumber = lstSerumSpecimenWrapper.size();
                integer plasmaSerialNumber = lstPlasmaSpecimenWrapper.size();
                integer buffySerialNumber = lstBuffySpecimenWrapper.size();
                if(sample_type == 'serum') {
                        system.debug('lstSerumSpecimenWrapper : '+lstSerumSpecimenWrapper);
                        for(SerumSpecimenWrapper ssw : lstSerumSpecimenWrapper) {
                                if(ssw.bloodSpecimenInfo.Shipped__c != null) {
                                        ssw.isShippedDisabled = false;
                                        if(ssw.bloodSpecimenInfo.Shipped__c == 'No') {
                                                ssw.isReasonDisabled = false;
                                                isReasonAllDisabled = false;
                                                if(bloodSpecimen.Reason_all_samples_not_collected__c == 'Other') {
                                                        isOtherReasonAllDisabled = false;
                                                }
                                                if(ssw.bloodSpecimenInfo.Reason_samples_not_shipped__c == 'Other') {
                                                        ssw.isOtherDisabled = false;
                                                } else {
                                                        ssw.isOtherDisabled = true;
                                                }
                                        } else {
                                                ssw.isReasonDisabled = true;
                                                ssw.isOtherDisabled = true;
                                        }
                                } else {
                                        ssw.isCollected = false;
                                        ssw.isShippedDisabled = true;
                                        ssw.isReasonDisabled = true;
                                        ssw.isOtherDisabled = true;
                                }
                        }
                        SerumSpecimenWrapper serumSpecimen = new SerumSpecimenWrapper();
                        serumSpecimen.isCollected = false;
                        serumSpecimen.SpecimenNumber = 'Serum Specimen #'+(++serumSerialNumber);
                        serumSpecimen.isShippedDisabled = true;
                        serumSpecimen.isReasonDisabled = true;
                        serumSpecimen.isOtherDisabled = true;
                        serumSpecimen.bloodSpecimenInfo = new BloodSpecimenInfo__c();
                        lstSerumSpecimenWrapper.add(serumSpecimen);
                        system.debug('lstSerumSpecimenWrapper : '+lstSerumSpecimenWrapper);
                        
                } else if(sample_type == 'plasma') {
                        for(PlasmaSpecimenWrapper psw : lstPlasmaSpecimenWrapper) {
                                if(psw.bloodSpecimenInfo.Shipped__c != null) {
                                        psw.isShippedDisabled = false;
                                        if(psw.bloodSpecimenInfo.Shipped__c == 'No') {
                                                psw.isReasonDisabled = false;
                                                isReasonAllDisabled = false;
                                                if(bloodSpecimen.Reason_all_samples_not_collected__c == 'Other') {
                                                        isOtherReasonAllDisabled = false;
                                                }
                                                if(psw.bloodSpecimenInfo.Reason_samples_not_shipped__c == 'Other') {
                                                        psw.isOtherDisabled = false;
                                                } else {
                                                        psw.isOtherDisabled = true;
                                                }
                                        } else {
                                                psw.isReasonDisabled = true;
                                                psw.isOtherDisabled = true;
                                        }
                                } else {
                                        psw.isCollected = false;
                                        psw.isShippedDisabled = true;
                                        psw.isReasonDisabled = true;
                                        psw.isOtherDisabled = true;
                                }
                        }
                        PlasmaSpecimenWrapper plasmaSpecimen = new PlasmaSpecimenWrapper();
                        plasmaSpecimen.isCollected = false;
                        plasmaSpecimen.SpecimenNumber = 'Plasma Specimen #'+(++plasmaSerialNumber);
                        plasmaSpecimen.isShippedDisabled = true;
                        plasmaSpecimen.isReasonDisabled = true;
                        plasmaSpecimen.isOtherDisabled = true;
                        plasmaSpecimen.bloodSpecimenInfo = new BloodSpecimenInfo__c();
                        lstPlasmaSpecimenWrapper.add(plasmaSpecimen);
                        
                } else if(sample_type == 'buffy') {
                        for(BuffySpecimenWrapper bsw : lstBuffySpecimenWrapper) {
                                if(bsw.bloodSpecimenInfo.Shipped__c != null) {
                                        bsw.isShippedDisabled = false;
                                        if(bsw.bloodSpecimenInfo.Shipped__c == 'No') {
                                                bsw.isReasonDisabled = false;
                                                isReasonAllDisabled = false;
                                                if(bloodSpecimen.Reason_all_samples_not_collected__c == 'Other') {
                                                        isOtherReasonAllDisabled = false;
                                                }
                                                if(bsw.bloodSpecimenInfo.Reason_samples_not_shipped__c == 'Other') {
                                                        bsw.isOtherDisabled = false;
                                                } else {
                                                        bsw.isOtherDisabled = true;
                                                }
                                        } else {
                                                bsw.isReasonDisabled = true;
                                                bsw.isOtherDisabled = true;
                                        }
                                } else {
                                        bsw.isCollected = false;
                                        bsw.isShippedDisabled = true;
                                        bsw.isReasonDisabled = true;
                                        bsw.isOtherDisabled = true;
                                }
                        }
                        BuffySpecimenWrapper buffySpecimen = new BuffySpecimenWrapper();
                        buffySpecimen.isCollected = false;
                        buffySpecimen.SpecimenNumber = 'Buffy coat specimen #'+(++buffySerialNumber);
                        buffySpecimen.isShippedDisabled = true;
                        buffySpecimen.isReasonDisabled = true;
                        buffySpecimen.isOtherDisabled = true;
                        buffySpecimen.bloodSpecimenInfo = new BloodSpecimenInfo__c();
                        lstBuffySpecimenWrapper.add(buffySpecimen);
                        
                }
                
        }
        
        /** This Method is used to validate the required field like collection date, timepoint etc. 
        *   Here we are also done the coding for enabling and disabling the fields like, if sample are not collected then the reasons
        *   Fields should be enable.
        *   
        *   After validation, we are storing the form data in data base.
        */
        public Pagereference saveCRF() {
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Error: Invalid Data. Review all error messages below to correct your data.')); 
                numberOfSerumCollected = 0;
                numberOfPlasmaCollected = 0;
                numberOfBuffyCollected = 0;
                //Validate Required fields
                boolean isValidated = true;
                if(bloodSpecimen.CollectionDate__c == null) {
                        bloodSpecimen.CollectionDate__c.addError('Please provide Collection Date.');
                        isValidated = false;
                        return null;
                }
                if(bloodSpecimen.CollectionDate__c > System.today()) {
                        bloodSpecimen.CollectionDate__c.addError('Future dates are not allowed.');
                        isValidated = false;
                        return null;
                } 
                if(bloodSpecimen.Time_Point__c == null) {
                        bloodSpecimen.Time_Point__c.addError('Please select Time Point.');
                        isValidated = false;
                        return null;
                }
                
                //Save blood specimen collection details
                if(isValidated) {
                        bloodSpecimen.TrialPatient__c = trialPatientId;
                        upsert bloodSpecimen;
                }
                
                //Enabling and disbling the fields
                
                List<BloodSpecimenInfo__c> lstBloodSpecimenInfo = new List<BloodSpecimenInfo__c>();
                for(SerumSpecimenWrapper ssw : lstSerumSpecimenWrapper) {
                        if(ssw.bloodSpecimenInfo.Shipped__c != null) {
                                ssw.isShippedDisabled = false;
                                if(ssw.bloodSpecimenInfo.Shipped__c == 'No') {
                                        ssw.isReasonDisabled = false;
                                        isReasonAllDisabled = false;
                                        if(bloodSpecimen.Reason_all_samples_not_collected__c == 'Other') {
                                                isOtherReasonAllDisabled = false;
                                        }
                                        if(ssw.bloodSpecimenInfo.Reason_samples_not_shipped__c == 'Other') {
                                                ssw.isOtherDisabled = false;
                                        } else {
                                                ssw.isOtherDisabled = true;
                                        }
                                } else {
                                        ssw.isReasonDisabled = true;
                                        ssw.isOtherDisabled = true;
                                }
                        } else {
                                ssw.isCollected = false;
                                ssw.isShippedDisabled = true;
                                ssw.isReasonDisabled = true;
                                ssw.isOtherDisabled = true;
                        }
                        if(isValidated) {
                                BloodSpecimenInfo__c serumInfo = new BloodSpecimenInfo__c();
                                serumInfo = ssw.bloodSpecimenInfo;
                                system.debug('ssw.bloodSpecimenInfo : '+ssw.bloodSpecimenInfo);
                                serumInfo.Name = ssw.SpecimenNumber;
                                serumInfo.BloodSpecimenForm__c = bloodSpecimen.Id;
                                lstBloodSpecimenInfo.add(serumInfo);
                        }
                        if(ssw.isCollected) {
                                ++numberOfSerumCollected;
                        }
                }
                
                for(PlasmaSpecimenWrapper psw : lstPlasmaSpecimenWrapper) {
                        if(psw.bloodSpecimenInfo.Shipped__c != null) {
                                psw.isShippedDisabled = false;
                                if(psw.bloodSpecimenInfo.Shipped__c == 'No') {
                                        psw.isReasonDisabled = false;
                                        isReasonAllDisabled = false;
                                        if(bloodSpecimen.Reason_all_samples_not_collected__c == 'Other') {
                                                isOtherReasonAllDisabled = false;
                                        }
                                        if(psw.bloodSpecimenInfo.Reason_samples_not_shipped__c == 'Other') {
                                                psw.isOtherDisabled = false;
                                        } else {
                                                psw.isOtherDisabled = true;
                                        }
                                } else {
                                        psw.isReasonDisabled = true;
                                        psw.isOtherDisabled = true;
                                }
                        } else {
                                psw.isCollected = false;
                                psw.isShippedDisabled = true;
                                psw.isReasonDisabled = true;
                                psw.isOtherDisabled = true;
                        }
                        if(isValidated) {
                                BloodSpecimenInfo__c plasmaInfo = new BloodSpecimenInfo__c();
                                plasmaInfo = psw.bloodSpecimenInfo;
                                plasmaInfo.Name = psw.SpecimenNumber;
                                plasmaInfo.BloodSpecimenForm__c = bloodSpecimen.Id;
                                lstBloodSpecimenInfo.add(plasmaInfo);
                        }
                        if(psw.isCollected) {
                                ++numberOfPlasmaCollected;
                        }
                }
                
                for(BuffySpecimenWrapper bsw : lstBuffySpecimenWrapper) {
                        if(bsw.bloodSpecimenInfo.Shipped__c != null) {
                                bsw.isShippedDisabled = false;
                                if(bsw.bloodSpecimenInfo.Shipped__c == 'No') {
                                        bsw.isReasonDisabled = false;
                                        isReasonAllDisabled = false;
                                        if(bloodSpecimen.Reason_all_samples_not_collected__c == 'Other') {
                                                isOtherReasonAllDisabled = false;
                                        }
                                        if(bsw.bloodSpecimenInfo.Reason_samples_not_shipped__c == 'Other') {
                                                bsw.isOtherDisabled = false;
                                        } else {
                                                bsw.isOtherDisabled = true;
                                        }
                                } else {
                                        bsw.isReasonDisabled = true;
                                        bsw.isOtherDisabled = true;
                                }
                        } else {
                                bsw.isCollected = false;
                                bsw.isShippedDisabled = true;
                                bsw.isReasonDisabled = true;
                                bsw.isOtherDisabled = true;
                        }
                        if(isValidated) {
                                BloodSpecimenInfo__c buffyInfo = new BloodSpecimenInfo__c();
                                buffyInfo = bsw.bloodSpecimenInfo;
                                buffyInfo.Name = bsw.SpecimenNumber;
                                buffyInfo.BloodSpecimenForm__c = bloodSpecimen.Id;
                                lstBloodSpecimenInfo.add(buffyInfo);
                        }
                        if(bsw.isCollected) {
                                ++numberOfBuffyCollected;
                        }
                } 
                if(numberOfSerumCollected < 3 && bloodSpecimen.Reason_all_samples_not_collected__c == null) {
                        bloodSpecimen.Reason_all_samples_not_collected__c.addError('Please specify the reason, why all sample are not collected.');
                        isReasonAllDisabled = false;
                        return null;
                } else if(numberOfPlasmaCollected < 3 && bloodSpecimen.Reason_all_samples_not_collected__c == null) {
                        bloodSpecimen.Reason_all_samples_not_collected__c.addError('Please specify the reason, why all sample are not collected.');
                        isReasonAllDisabled = false;
                        return null;
                } else if(numberOfBuffyCollected < 2 && bloodSpecimen.Reason_all_samples_not_collected__c == null) {
                        bloodSpecimen.Reason_all_samples_not_collected__c.addError('Please specify the reason, why all sample are not collected.');
                        isReasonAllDisabled = false;
                        return null;
                }
                if(!isReasonAllDisabled && bloodSpecimen.Reason_all_samples_not_collected__c == null) {
                        bloodSpecimen.Reason_all_samples_not_collected__c.addError('Please specify the reason, why all sample are not collected.');
                        isReasonAllDisabled = false;
                        return null;
                }
                
                if(!isReasonAllDisabled && bloodSpecimen.Reason_all_samples_not_collected__c == 'Other' && bloodSpecimen.Other_Reason_samples_not_shipped__c == null) {
                        bloodSpecimen.Other_Reason_samples_not_shipped__c.addError('Please specify other reason, why all sample are not collected.');
                        isReasonAllDisabled = false;
                        isOtherReasonAllDisabled = false;
                        return null;
                }
                
                if(isValidated) {
                        upsert lstBloodSpecimenInfo;
                        return new Pagereference('/'+bloodSpecimen.Id);
                }
                
                return null;
        }
        
        public Pagereference cancelCRF() {
                system.debug('bloodSpecimen.TrialPatient__c : '+bloodSpecimen.TrialPatient__c);
                List<TrialPatient__c> lstTP = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id = :trialPatientId];
                if(!lstTP.isEmpty()) {
                        /*if(bloodSpecimen.Id != null) {
                                delete [select Id from BloodSpecimenForm__c where Id = :bloodSpecimen.Id];
                                system.debug('bloodSpecimen.Id : '+bloodSpecimen.Id);
                                return new Pagereference('/'+bloodSpecimen.Id);
                        } else {
                                system.debug('lstTP[0].Patient_Id__c : '+lstTP[0].Patient_Id__c);
                                return new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c);
                        }*/
                        system.debug('lstTP[0].Patient_Id__c : '+lstTP[0].Patient_Id__c);
                        //return new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c+'&TrialId='+lstTP[0].Trial_Id__c);
                        return new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c);
                }
                else {
                        return new Pagereference('/'+trialPatientId);
                }
        }
        public Pagereference saveMainCRF() {
                System.debug('bloodSpecimenId-----saveMainCRF-------'+bloodSpecimenId);
                if(bloodSpecimenId == null) {
                        bloodSpecimen.TrialPatient__c = trialPatientId;
                        
                        try {
                            insert bloodSpecimen;
                        }catch (Exception e) {
                            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                            Apexpages.addMessage(msg);
                            return null;
                        }
                
                        bloodSpecimenId = bloodSpecimen.Id;
                        
                        System.debug('bloodSpecimenId------------'+bloodSpecimenId);
                        //Pagereference ref = new Pagereference('/apex/BloodSpecimenForm?trialPat='+trialPatientId+'&bloodSpecimenId='+bloodSpecimenId);
                        Pagereference ref = new Pagereference('/'+bloodSpecimenId);
                
                        ref.setRedirect(true);
                        return ref;
                
                } 
                return null;
        }
        
        public static String calculateSID(String coreSpecimen, String specimenType, String timepoint, String fiveDigitPId) {
                
                system.debug('coreSpecimen : '+coreSpecimen);
                system.debug('specimenType : '+specimenType);
                system.debug('timepoint : '+timepoint);
                system.debug('fiveDigitPId : '+fiveDigitPId);
                
                if(coreSpecimen == null || specimenType == null || timepoint == null || fiveDigitPId == null) {
                        return null;
                }
                if(timepoint == 'Pre-Treatment') {
                        if(specimenType == 'Serum') {
                                return fiveDigitPId + '0' + (Integer.ValueOf(coreSpecimen) + 40);
                        } else if(specimenType == 'Plasma') {
                                return fiveDigitPId + '0' + (Integer.ValueOf(coreSpecimen) + 50);
                        } else if(specimenType == 'Buffy coat') {
                                return fiveDigitPId + '0' + (Integer.ValueOf(coreSpecimen) + 60);
                        } 
                }
                if(timepoint == 'Early Treatment') {
                        if(specimenType == 'Serum') {
                                return fiveDigitPId + '1' + (Integer.ValueOf(coreSpecimen) + 40);
                        } else if(specimenType == 'Plasma') {
                                return fiveDigitPId + '1' + (Integer.ValueOf(coreSpecimen) + 50);
                        } else if(specimenType == 'Buffy coat') {
                                return fiveDigitPId + '1' + (Integer.ValueOf(coreSpecimen) + 60);
                        }
                }
                if(timepoint == 'Inter-Regimen') {
                        if(specimenType == 'Serum') {
                                return fiveDigitPId + '2' + (Integer.ValueOf(coreSpecimen) + 40);
                        } else if(specimenType == 'Plasma') {
                                return fiveDigitPId + '2' + (Integer.ValueOf(coreSpecimen) + 50);
                        } else if(specimenType == 'Buffy coat') {
                                return fiveDigitPId + '2' + (Integer.ValueOf(coreSpecimen) + 60);
                        } 
                }
                if(timepoint == 'Pre-Surgery') {
                        if(specimenType == 'Serum') {
                                return fiveDigitPId + '3' + (Integer.ValueOf(coreSpecimen) + 40);
                        } else if(specimenType == 'Plasma') {
                                return fiveDigitPId + '3' + (Integer.ValueOf(coreSpecimen) + 50);
                        } else if(specimenType == 'Buffy coat') {
                                return fiveDigitPId + '3' + (Integer.ValueOf(coreSpecimen) + 60);
                        } 
                }
                
                return 0+'';    
        }
        
        public class SerumSpecimenWrapper {
                public String SpecimenNumber {get;set;}
                public boolean isCollected {get;set;}
                public boolean isShippedDisabled {get;set;}
                public boolean isReasonDisabled {get;set;}
                public boolean isOtherDisabled {get;set;}
                public BloodSpecimenInfo__c bloodSpecimenInfo {get;set;}
                
        }
        
        public class PlasmaSpecimenWrapper { 
                public String SpecimenNumber {get;set;}
                public boolean isCollected {get;set;}
                public boolean isShippedDisabled {get;set;}
                public boolean isReasonDisabled {get;set;}
                public boolean isOtherDisabled {get;set;}
                public BloodSpecimenInfo__c bloodSpecimenInfo {get;set;}
        }
        
        public class BuffySpecimenWrapper {
                public String SpecimenNumber {get;set;}
                public boolean isCollected {get;set;}
                public boolean isShippedDisabled {get;set;}
                public boolean isReasonDisabled {get;set;}
                public boolean isOtherDisabled {get;set;}
                public BloodSpecimenInfo__c bloodSpecimenInfo {get;set;}
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
        
        //XML_Configuration__c conf1 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'AE_Detail__c');
        //insert conf1;
        
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
        
        
        
        //Select  c.Trial__c, c.TrialPatient__c, c.Site__c, c.Patient__c, c.Name, c.Id, c.Detail__c From CRF__c
        
        CRF__c crf = new CRF__c();
        crf.Trial__c= tri.Id;
        crf.TrialPatient__c = tp.Id;
        crf.Site__c = site1.Id;
        crf.Patient__c = p.Id;
        crf.Detail__c ='Details';
        insert crf;
        
        
        //Select t.TrialPatient__c, t.Status__c, t.RecordTypeId, t.Patient__c, t.NumberOfSamplesCollected__c, t.Name, t.Effective_Time__c, t.CRFId__c From TissueSpecimenDetail__c t
        
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
        insert blood;
        
       
        
        Apexpages.currentPage().getParameters().put('isxmlpage','False');
        ApexPages.currentPage().getParameters().put('trialPat',tp.Id);   
        Apexpages.currentPage().getParameters().put('bloodSpecimenId',blood.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(blood);
        BloodSpecimenController con = new BloodSpecimenController(controller);
        con.bloodSpecimen = blood;
        
        Test.startTest();
        
        //con.submitRegistration();
        con.viewXML();
        BloodSpecimenController.submitBloodSpecimen(blood.Id,tp.Id,p.Id);
        ExternalServiceConnector.populateFailedRegistration('BloodSpecimenForm__c',blood.Id,False,p.id, t.id, site1.Id,null, 'errorCode', 'Error message', 'Failure','System', '123','100','1000');
        Test.stopTest();
    }              
        
}