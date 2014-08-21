public with sharing class AdverseEventController extends PageControllerBase {
    
     public  string PatientFieldCheck{get;set;}
     public  String currentTab {get;set;}
     public String password {get;set;}
     public  String errorMsg {get;set;}
     public AE_Detail__c AEObj {get;set;}
     public List<AE_Detail__c> AEList {get;set;}
    public String rId {get;set;}
     public Date LastVisitDate {get;set;}
     public List<BaselineSymptomsForm__c> baselineList {get;set;}
    private List<AE_Detail__c> lstCloneAE{get;set;}
    public List<Allergy__c> allergyList {get;set;}
    public List<BaselineCondition__c> baselineConditionList {get;set;}
    public List<wrapCondition> wrapConditionList {get;set;}
    public List<wrapToxicity> wrapBaselineToxicityList{get;set;}
   public List<wrapToxicity> wrapAEToxicityList{get;set;}
    public Boolean isAllergyShow {get;set;}
    public Boolean isBaselineSymptomShow {get;set;}
    public Boolean isPriorAEShow {get;set;}
    public Boolean isShowEditButton{get;set;}
    public Boolean isbaselineConditionShow {get;set;}
    public String treatmentArmId{get;set;}
    public String treatmentArmName{get;set;}
    public Boolean isCurrentAEShow {get;set;}
    public List<Toxicity__c> toxicityDisplayList{get;set;}
    public boolean openInEditMode {get;set;}   
    public integer conditionSNo = 0;
    public Boolean isComplete{get;set;}
    public String nextTabName{get;set;}
    public String TrialPatientId {get;set;}
    private Id clonedCRFId{get;set;}
    
    
    public boolean visitDate {get;set;}
    public boolean patientHospitalized {get;set;}
    public boolean caAERSReportFiled {get;set;}
    
    public boolean BaseSymptoms {get;set;}
    public boolean BaseEvent {get;set;} //Toxicity
    public boolean BaseGrade {get;set;}    
    public boolean BaseAttribution {get;set;} 
    public boolean BaseSymptomStatus {get;set;}
    public boolean BaseWasEventLifeThreatning {get;set;}
    public boolean BaseToxicityStatus {get;set;}
    public boolean BaseResultDefect {get;set;}
    public boolean BaseResolved {get;set;}
    public boolean BasePatientComplaint {get;set;}
    public boolean BaseDidTheInvestigatorFindEventUnusual {get;set;}
    public boolean BaseDidEventResultInDeath {get;set;}
    public boolean BaseDidEventRequiredHospitalization {get;set;}
    public boolean BaseSAE {get;set;}
    public boolean BaseOnsetDate {get;set;}  
    public boolean BaseEndDate {get;set;}
    
    public boolean AESymptoms {get;set;}
    public boolean AEEvent {get;set;} //Toxicity
    public boolean AEGrade {get;set;}    
    public boolean AEAttribution {get;set;} 
    public boolean AESymptomStatus {get;set;}
    public boolean AEWasEventLifeThreatning {get;set;}
    public boolean AEToxicityStatus {get;set;}
    public boolean AEResultDefect {get;set;}
    public boolean AEResolved {get;set;}
    public boolean AEPatientComplaint {get;set;}
    public boolean AEDidTheInvestigatorFindEventUnusual {get;set;}
    public boolean AEDidEventResultInDeath {get;set;}
    public boolean AEDidEventRequiredHospitalization {get;set;}
    public boolean AESAE {get;set;}
    public boolean AEOnsetDate {get;set;}  
    public boolean AEEndDate {get;set;} 
    private string isxmlpage {get;set;}
    public boolean IsXMLGenerated {get;set;}
    public String xmlOutput {get;set;}
    
    public String radioValue {get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    
    public String patientId {get;set;} 
    public String profileName{get;set;}
    public String AeDetailObjId1{get;set;}
    public Boolean isDelete{get;set;}
    public AE_Detail__c pathObj{get;set;}
    
    public integer getConditionSNo() {
        return conditionSNo;
    }
    
    /*public AddToxicityComponent addToxicityCompController {set;
        get{
            //get the map, then the component controller using the appropriate key
            if(getComponentControllerMap()!=null){
              AddToxicityComponent addToxicity;
              addToxicity = (AddToxicityComponent )getComponentControllerMap().get('addToxicity'); 
              if(addToxicity!= null)
                 return addToxicity;
            }
            //just in case something goes wrong return something...this can be handled better  
            return new AddToxicityComponent(); 
        }
    }
    
    public void callAddToxicityControllerMethod(Id recId) {
        system.debug('addToxicityCompController : '+addToxicityCompController);
        addToxicityCompController.saveToxicity(recId);  
    }
    */
    public AdverseEventController(ApexPages.StandardController controller) {
    	System.Debug('Inside the AdverseEvent Class ---------1');
        
        String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        } 
        visitDate = false;
        patientHospitalized = false;
        caAERSReportFiled = false;
        BaseSymptoms = false;
        BaseEvent = false;
        BaseGrade = false;
        BaseAttribution = false;
        BaseSymptomStatus = false;
        BaseWasEventLifeThreatning = false;
        BaseToxicityStatus = false;
        BaseResultDefect = false;
        BaseResolved = false;
        BasePatientComplaint = false;
        BaseDidTheInvestigatorFindEventUnusual = false;
        BaseDidEventResultInDeath = false;
        BaseDidEventRequiredHospitalization = false;
        BaseSAE = false;
        BaseOnsetDate = false;
        BaseEndDate = false;
        AESymptoms = false;
        AEEvent = false;
        AEGrade = false;
        AEAttribution = false;
        AESymptomStatus = false;
        AEWasEventLifeThreatning = false;
        AEToxicityStatus = false;
        AEResultDefect = false;
        AEResolved = false;
        AEPatientComplaint = false;
        AEDidTheInvestigatorFindEventUnusual = false;
        AEDidEventResultInDeath = false;
        AEDidEventRequiredHospitalization = false;
        AESAE = false;
        AEOnsetDate = false;
        AEEndDate = false; 
        isDelete = false;     
        
        isxmlpage = Apexpages.currentPage().getParameters().get('isxmlpage');
        
        List<XML_Configuration__c> lstXMLConfig = [select Id, CRF_Type__c, CRF_Type__r.Object_Name__c, Object_API_Name__c, Field_API_Name__c  from XML_Configuration__c where Object_API_Name__c IN ('AE_Detail__c','BaselineSymptomsForm__c','Toxicity__c')];
        System.debug('1st XMLConfig Object ----------------------->'+lstXMLConfig);
        
        for(XML_Configuration__c xmlConfig : lstXMLConfig) {
            if(xmlConfig.Field_API_Name__c == 'Visit_Date__c') {
                visitDate = true;
            } else if(xmlConfig.Field_API_Name__c == 'Patient_Hospitalized__c') {
                patientHospitalized = true;
            } else if (xmlConfig.Field_API_Name__c == 'caAERS_report_filed__c') {
                caAERSReportFiled = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Symptom_Masters__c') {
                BaseSymptoms = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Name,Toxicity_Other__c') {
                BaseEvent = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Grade__c') {
                BaseGrade = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Attribution__c') {
                BaseAttribution = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Symptom_Status__c') {
                BaseSymptomStatus = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Was_event_life_threatning__c') {
                BaseWasEventLifeThreatning = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Toxicity_Status__c') {
                BaseToxicityStatus = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Result_conginental_abnormality_defect__c') {
                BaseResultDefect = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Resolved__c') {
                BaseResolved = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Patient_Complaint__c') {
                BasePatientComplaint = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Did_the_investigator_find_event_unusual__c') {
                BaseDidTheInvestigatorFindEventUnusual = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Did_event_result_in_death__c') {
                BaseDidEventResultInDeath = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Did_event_required_hospitalization__c') {
                BaseDidEventRequiredHospitalization = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'SAE__c') {
                BaseSAE = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'Onset_Date__c') {
                BaseOnsetDate = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'BaselineSymptomsForm__c' && xmlConfig.Field_API_Name__c == 'AE_End_Date__c') {
                BaseEndDate = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Symptom_Masters__c') {
                AESymptoms = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Name,Toxicity_Other__c') {
                AEEvent = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Grade__c') {
                AEGrade = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Attribution__c') {
                AEAttribution = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Symptom_Status__c') {
                AESymptomStatus = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Was_event_life_threatning__c') {
                AEWasEventLifeThreatning = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Toxicity_Status__c') {
                AEToxicityStatus = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Result_conginental_abnormality_defect__c') {
                AEResultDefect = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Resolved__c') {
                AEResolved = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Patient_Complaint__c') {
                AEPatientComplaint = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Did_the_investigator_find_event_unusual__c') {
                AEDidTheInvestigatorFindEventUnusual = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Did_event_result_in_death__c') {
                AEDidEventResultInDeath = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Did_event_required_hospitalization__c') {
                AEDidEventRequiredHospitalization = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'SAE__c') {
                AESAE = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'Onset_Date__c') {
                AEOnsetDate = true;
            } else if (xmlConfig.CRF_Type__r.Object_Name__c == 'AE_Detail__c' && xmlConfig.Field_API_Name__c == 'AE_End_Date__c') {
                AEEndDate = true;
            }
        }
        openInEditMode = false;
        
        System.debug('AdverseEvent controller after the XML stuff'+controller.getId());
        rId = controller.getId();
           System.debug('Controller ID which become Patient ID'+controller.getId());
     
        AE_Detail__c AeDetailObj;
        if(rId != null)AeDetailObj = [Select a.TrialPatient__c From AE_Detail__c a where id =: rId];
               System.debug('AEDetail object after running the Trial Patient Object'+AeDetailObj);
     
    
        if(AeDetailObj != null){
            TrialPatientId = AeDetailObj.TrialPatient__c;
            rId = AeDetailObj.id; //this is the Id that appear on the form address bar
        }else{
            TrialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
            rId = Apexpages.currentPage().getParameters().get('aeid');
        }
    
        
        if(TrialPatientId != null) {
            List<TrialPatient__c> lstTrialPatient = [select Name,Subject_Id__c,Site__c, Patient_Id__c, Trial_Id__r.Name,Site__r.Name  from TrialPatient__c where Id = :TrialPatientId];
                  System.debug('Trial pateint List from line 252---------------------->'+lstTrialPatient);
     
            if(!lstTrialPatient.IsEmpty()) {
                trialPatientObj = lstTrialPatient[0];
                patientId = lstTrialPatient[0].Patient_Id__c;
            }
        }
        LastVisitDate = null;
        treatmentArmId = '';
        isAllergyShow = false;
        isCurrentAEShow = false;
        isbaselineConditionShow = false;
        isPriorAEShow = false;
        isBaselineSymptomShow = false;
        isComplete = true;
        isShowEditButton = false;
        wrapConditionList = new List<wrapCondition>();
        wrapBaselineToxicityList = new List<wrapToxicity>();
        toxicityDisplayList = new List<Toxicity__c>();
        wrapAEToxicityList = new List<wrapToxicity>();
        system.debug('__rId__'+rId);
        if(rId!=null) {
            AEObj = [select a.Root_CRF_Id__c,a.CreatedDate, a.caAERS_report_filed__c, a.Visit_Date__c, a.CompletedDate__c, a.CRF__c, a.TrialPatient__c, a.SystemModstamp, a.Status__c, 
                    a.Patient_Hospitalized__c, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, 
                    a.Effective_Time__c, a.CreatedById, OriginalCRF__c From AE_Detail__c a where Id =: rId];
               system.debug('the AEObject that We r getting from the line 277 -------------------->'+AEObj);
           
            lstCloneAE = [select Id, Status__c,Root_CRF_Id__c from AE_Detail__c where OriginalCRF__c =:rId and Status__c = 'Cloned'];
              system.debug('the AEObject that We r getting from the line 279 -------------------->'+lstCloneAE);
           
            if(!lstCloneAE.isEmpty()) {
                isShowEditButton = true;
                clonedCRFId = lstCloneAE[0].Id;
                    system.debug('inside the loop the line 285 -------------------->'+clonedCRFId);
          
            }
            AEList = [select a.Root_CRF_Id__c,a.caAERS_report_filed__c, a.Visit_Date__c, a.TrialPatient__c, a.SystemModstamp, a.Status__c, a.Patient_Hospitalized__c, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, a.Effective_Time__c, a.CreatedById From AE_Detail__c a where TrialPatient__c =: TrialPatientId and Status__c = 'Accepted' order by Effective_Time__c desc];
             system.debug('inside the line for getting AE List 289 -------------------->'+AEList);
          
            if(!AEList.isEmpty()) {
                if(AEList[0].Patient_Hospitalized__c == true && AEList[0].Visit_Date__c != null) {
                    LastVisitDate = AEList[0].Visit_Date__c;
                }
            }

            List<Toxicity__c> toxicityList = [Select t.Did_the_investigator_find_event_unusual__c, t.Symptom_Masters__c, t.Toxicity_Master__c, 
                t.Toxicity_Master__r.Toxicity_Name__c, t.Symptom_Status__c, t.Baseline_Symptoms_Form__r.Status__c, t.AE_Detail__r.Status__c, 
                t.Was_event_life_threatning__c, t.Toxicity_Status__c, t.Toxicity_Other__c, t.SystemModstamp, t.SAE__c, t.Result_persistent_significant_disability__c, 
                t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.OwnerId, t.Onset_Date__c, t.Name, t.LastModifiedDate, 
                t.LastModifiedById, t.IsDeleted, t.Id, t.Grade__c, t.Did_event_result_in_death__c, t.Did_event_required_hospitalization__c, t.CreatedDate, 
                t.CreatedById, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_End_Date__c, t.AE_Detail__c, AE_ID__c From Toxicity__c t 
                where ((Baseline_Symptoms_Form__r.Status__c = 'Accepted' and Baseline_Symptoms_Form__r.TrialPatient__c =: TrialPatientId) 
                or (AE_Detail__r.Status__c = 'Accepted' and AE_Detail__r.TrialPatient__c =: TrialPatientId and AE_Detail__c != :rId and AE_Detail__r.Visit_Date__c<:AEObj.Visit_Date__c)) 
                and Symptom_Status__c = 'Yes'];
              
              
             toxicityDisplayList = [Select t.TrialPatient__c, Toxicity_Agent__c, t.LastModifiedDate,t.Toxicity_Status__c, Grade__c, t.Toxicity_Other__c, t.SAE__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.Onset_Date__c, t.Name, t.Id, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, AE_Detail__c, t.Toxicity_Master__r.Toxicity_Name__c From Toxicity__c t where  AE_Detail__r.TrialPatient__c =: TrialPatientId  ];
   
         
               
                    List<Toxicity__c> toxicityListFinal =new List<Toxicity__c>();
                    Map <Decimal,Toxicity__c> toxicitySet=new Map<Decimal,Toxicity__c>();
                    if(toxicityDisplayList.size()>0){
                      for(Integer i=0;i< toxicityDisplayList.size();i++){
                      	
                      	Toxicity__c toxicity1 =toxicityDisplayList[i];
                      	
                      	system.debug('at line 319');
                      	
                      	
                      	system.debug('Toxicity object from the loop from 1st loop '+toxicity1);
                      	 for(Integer j=1;j< toxicityDisplayList.size();j++){
                      	
                      	Toxicity__c toxicity2 =toxicityDisplayList[j];
                      	system.debug('Toxicity object from the loop is '+toxicity2);
                      	system.debug('Toxicity1 AE_ID is  '+toxicity1.AE_ID__c);
                      	system.debug('Toxicity2 AE_ID is  '+toxicity2.AE_ID__c);
                      	if(toxicity1.AE_ID__c==toxicity2.AE_ID__c){
                      	if(toxicity1.LastModifiedDate>toxicity2.LastModifiedDate){
                      		toxicitySet.put(toxicity1.AE_ID__c,toxicity1);
                      		system.debug('Toxicity Element added in the list is ------> '+toxicity1);
                      	}
                      	
                      	}
                      		
                      	}if(!toxicitySet.containsKey(toxicity1.AE_ID__c)){
                      toxicitySet.put(toxicity1.AE_ID__c,toxicity1);
                      	}
                      	}
           
                      
                      }
                    toxicityListFinal=toxicitySet.values();
                    system.debug('final size of the new list is '+toxicityListFinal.size());
                    
          system.debug('first toxivity list on submit new line 351 -------------------->'+toxicityList.size());
    //toxicityDisplayList = [Select t.TrialPatient__c, Toxicity_Agent__c, t.Toxicity_Status__c, Grade__c, t.Toxicity_Other__c, t.SAE__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.Onset_Date__c, t.Name, t.Id, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, AE_Detail__c, t.Toxicity_Master__r.Toxicity_Name__c From Toxicity__c t where  AE_Detail__r.TrialPatient__c =: TrialPatientId  ];
             system.debug('Toxicity Display List size is line 352 -------------------->'+toxicityDisplayList.size());
         for(Toxicity__c toxicityObj : toxicityListFinal) { 
           //for(Toxicity__c toxicityObj : toxicityListClone) {//code inserted for clonning
           	system.debug('inside the Toxicity Clone loop');
                wrapToxicity wrapToxicityObj = new wrapToxicity();
                
         
        
                wrapToxicityObj.ToxicityObj = toxicityObj;
                wrapToxicityObj.isReadOnly = true;
                if(toxicityObj.AE_Detail__c != null) {
                	//clone code needs to do here 
                	
                    wrapToxicityObj.isAE = true;
                    wrapAEToxicityList.add(wrapToxicityObj);
                    isPriorAEShow = true;
                   
                       system.debug('Wrapping the Toxicity onject in the from of WrapToxicityObject to the ToxicityList and setting the isPriorAE falg to True line number 318 -------------------->'+wrapAEToxicityList);
       
                } else if(toxicityObj.Baseline_Symptoms_Form__c != null) {
                    wrapToxicityObj.isBaseline = true;
                    wrapBaselineToxicityList.add(wrapToxicityObj);
                    isBaselineSymptomShow = true;
                }
            }
            List<ArmPatient__c> armPatientList = [Select a.assignedToPatient__c, a.TrialPatient__r.Patient_Id__c, a.TrialPatient__r.Name, a.TrialPatient__c, a.Name, a.Arm_Id__r.Name, a.Arm_Id__c From ArmPatient__c a where TrialPatient__c =:TrialPatientId and assignedToPatient__c = true];
            system.debug('__armPatientList__'+armPatientList);
            for(ArmPatient__c armPatientObj : armPatientList) {
                treatmentArmId = armPatientObj.Arm_Id__c;
                treatmentArmName = armPatientObj.Arm_Id__r.Name;
                break;
            }
        } else {
            AEObj = new AE_Detail__c();
        }
        isComplete = CRFUtilities.isReadOnlyUsr();
        if(AEObj != null){
        	toxicityDisplayList.clear();
            String status = AEObj.Status__c;
            if(status == 'Approval Pending' || status == 'Accepted'||status == 'Rejected' ){
            	system.debug('inside the Accepted status ');
                  // toxicityDisplayList = [Select t.TrialPatient__c, t.Toxicity_Status__c, Grade__c, t.Toxicity_Other__c, t.SAE__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.Onset_Date__c, t.Name, t.Id, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, AE_Detail__c,t.Toxicity_Master__r.Toxicity_Name__c From Toxicity__c t where ((AE_Detail__c =:AEObj.Id) or (AE_Detail__r.Status__c = 'Accepted' and AE_Detail__r.TrialPatient__c =: TrialPatientId)) and Symptom_Status__c = 'Yes'];
                //Changed query as many events were visible for Manas on complete tab
                //toxicityDisplayList = [Select t.TrialPatient__c, Toxicity_Agent__c, t.Toxicity_Status__c, Grade__c, t.Toxicity_Other__c, t.SAE__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.Onset_Date__c, t.Name, t.Id, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, AE_Detail__c,t.Toxicity_Master__r.Toxicity_Name__c From Toxicity__c t where ((AE_Detail__c =:AEObj.Id) or (AE_Detail__r.Status__c = 'Accepted' and AE_Detail__r.TrialPatient__c =: TrialPatientId)) and Symptom_Status__c = 'Yes'];
               // List<Toxicity__c> toxicityDisplayTempList = [Select t.AE_Detail__r.CreatedDate, t.TrialPatient__c, Toxicity_Agent__c, t.Toxicity_Status__c, Grade__c, t.Toxicity_Other__c, t.SAE__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.Onset_Date__c, t.Name, t.Id, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, AE_Detail__c,t.Toxicity_Master__r.Toxicity_Name__c From Toxicity__c t where ((AE_Detail__c =:AEObj.Id) or (AE_Detail__r.Status__c = 'Accepted' and AE_Detail__r.TrialPatient__c =: TrialPatientId and AE_Detail__r.Visit_Date__c<:AEObj.Visit_Date__c)) and Symptom_Status__c = 'Yes'];
            List<Toxicity__c> toxicityDisplayTempList = [Select t.AE_Detail__r.CreatedDate,t.LastModifiedDate , t.TrialPatient__c, Toxicity_Agent__c, t.Toxicity_Status__c, Grade__c, t.Toxicity_Other__c, t.SAE__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.Onset_Date__c, t.Name, t.Id, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, AE_Detail__c,t.Toxicity_Master__r.Toxicity_Name__c From Toxicity__c t where AE_Detail__r.TrialPatient__c =: TrialPatientId ];
                 system.debug('line 394');
                 List<Toxicity__c> toxicityListFinal =new List<Toxicity__c>();
                    Map <Decimal,Toxicity__c> toxicitySet=new Map<Decimal,Toxicity__c>();
                    if(toxicityDisplayTempList.size()>0){
                      for(Integer i=0;i< toxicityDisplayTempList.size();i++){
                      	
                      	Toxicity__c toxicity1 =toxicityDisplayTempList[i];
                      	
                      	
                      	
                      	
                      	system.debug('Toxicity object from the loop from 1st loop line 406 '+toxicity1);
                      	 for(Integer j=1;j< toxicityDisplayTempList.size();j++){
                      	
                      	Toxicity__c toxicity2 =toxicityDisplayTempList[j];
                      	system.debug('Toxicity object from the loop is '+toxicity2);
                      	system.debug('Toxicity1 AE_ID is  '+toxicity1.AE_ID__c);
                      	system.debug('Toxicity2 AE_ID is  '+toxicity2.AE_ID__c);
                      	if(toxicity1.AE_ID__c==toxicity2.AE_ID__c){
                      	if(toxicity1.LastModifiedDate>toxicity2.LastModifiedDate){
                      		toxicitySet.put(toxicity1.AE_ID__c,toxicity1);
                      		system.debug('Toxicity Element added in the list is line 414------> '+toxicity1);
                      	}
                      	
                      	}
                      		
                      	}if(!toxicitySet.containsKey(toxicity1.AE_ID__c)){
                      toxicitySet.put(toxicity1.AE_ID__c,toxicity1);
                      	}
                      	}
           
                      
                      }
                    toxicityListFinal=toxicitySet.values();
               
               
               
               
                if(!toxicityListFinal.isEmpty()) {
                    isCurrentAEShow = true;
                    system.debug('line 433');
                    
                     
                    for(Toxicity__c t: toxicityListFinal){
                        if(t.AE_Detail__r.CreatedDate <= AEObj.CreatedDate){
                             toxicityDisplayList.add(t);
                        }
                        
                    }
                }
             
                currentTab = 'CompleteTab';
                isComplete = false;
            } else {
                currentTab = 'overviewTab';
               
            //    if(toxicityDisplayList != null && toxicityDisplayList.size() > 0) {
                   // system.debug('clearing toxicityDisplayList');
                   // toxicityDisplayList.clear();
                //}
            }
        }
        if(isxmlpage != null) {
            List<Attachment> lstAtt = [select Body from Attachment where ParentId = :AEObj.Id order by CreatedDate DESC];
            if(!lstAtt.isEmpty()) {
                xmlOutput = lstAtt[0].Body.toString();
                system.debug('--Controller-lstAtt[0].Body.toString--'+lstAtt[0].Body.toString());
                IsXMLGenerated = true;  
            } else {
                IsXMLGenerated = false;
            }
        }
        isDelete();
    }
    public void isDelete(){
        
        System.debug('======rId=======' +rId);
        if(rId != null){
            pathObj = [select Id, Status__c from AE_Detail__c where id =:rId];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======rId =======' +rId);
    }
    public pagereference redirect(){
            pagereference redirect = new pagereference('/apex/AdverseEventPdf?id='+rId);
            redirect.setRedirect(true); 
            return redirect;
        }

//============================insert one blank record in AE CRF=====================================================    
    public Pagereference saveCrf() {
        //String TrialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
        //String aeIdValue = Apexpages.currentPage().getParameters().get('aeid');
        
        if(rId == null) {
            AEObj = new AE_Detail__c();
            AEObj.TrialPatient__c = TrialPatientId;
            AEObj.Visit_Date__c = system.today();
            insert AEObj;
            //Pagereference pr = new Pagereference('/apex/AdverseEvent?trialPat='+TrialPatientId+'&aeid='+AEObj.Id);
            Pagereference pr = new Pagereference('/'+AEObj.Id);
            //pr.getParameters().put('nooverride', '1');
            pr.setRedirect(true);
            return pr;
        } 
        return null;
    }

//============================next function is used for save user entries and move to next Tab============================= 
    public Pagereference next() {
        system.debug('__currentTab__'+currentTab);
        String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
        system.debug('__nextTabValue__'+nextTabValue);
        
        if(nextTabValue != null) {
            nextTabName = nextTabValue;
        }
                                  
        if(currentTab == 'overviewTab') {
            if(AEObj.Visit_Date__c>system.today()) {
                AEObj.Visit_Date__c.addError('Date can\'t be in future.');
                return null;
            }
            //Added By Shruti (DE401)
            try {
            update AEObj;
             }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
            // Pagereference ref = new Pagereference('/apex/AdverseEvent?id='+rId);
            Pagereference ref = new Pagereference('/'+rid);
            ref.setRedirect(true);
             return ref; 
             }
             //Added by Shruti (DE401)
        } 
        
        if(nextTabName == 'AEPage1Tab') {
        	wrapAEToxicityList.clear();
        	wrapBaselineToxicityList.clear();
        }
        
        if(nextTabName == 'AEPage2Tab') {
        	wrapAEToxicityList.clear();
        	wrapBaselineToxicityList.clear();
        }
        
        if(nextTabName == 'overviewTab'){
        	wrapAEToxicityList.clear();
        	wrapBaselineToxicityList.clear();
        	/*List<Toxicity__c> toxicityList = [Select t.Did_the_investigator_find_event_unusual__c, t.Symptom_Masters__c, t.Toxicity_Master__c, 
                t.Toxicity_Master__r.Toxicity_Name__c, t.Symptom_Status__c, t.Baseline_Symptoms_Form__r.Status__c, t.AE_Detail__r.Status__c, 
                t.Was_event_life_threatning__c, t.Toxicity_Status__c, t.Toxicity_Other__c, t.SystemModstamp, t.SAE__c, t.Result_persistent_significant_disability__c, 
                t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.OwnerId, t.Onset_Date__c, t.Name, t.LastModifiedDate, 
                t.LastModifiedById, t.IsDeleted, t.Id, t.Grade__c, t.Did_event_result_in_death__c, t.Did_event_required_hospitalization__c, t.CreatedDate, 
                t.CreatedById, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_End_Date__c, t.AE_Detail__c, AE_ID__c From Toxicity__c t 
                where ((Baseline_Symptoms_Form__r.Status__c = 'Accepted' and Baseline_Symptoms_Form__r.TrialPatient__c =: TrialPatientId) 
                or (AE_Detail__r.Status__c = 'Accepted' and AE_Detail__r.TrialPatient__c =: TrialPatientId and AE_Detail__c != :rId and AE_Detail__r.Visit_Date__c<:AEObj.Visit_Date__c)) 
                and Symptom_Status__c = 'Yes'];*/
           //  List<Toxicity__c> toxicityList = [Select t.AE_Detail__r.CreatedDate, t.TrialPatient__c, Toxicity_Agent__c, t.Toxicity_Status__c, Grade__c, t.Toxicity_Other__c, t.SAE__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.Onset_Date__c, t.Name, t.Id, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, AE_Detail__c,t.Toxicity_Master__r.Toxicity_Name__c From Toxicity__c t where AE_Detail__r.TrialPatient__c =: TrialPatientId ];
              List<Toxicity__c>  toxicityDisplayList = [Select t.TrialPatient__c, Toxicity_Agent__c, t.LastModifiedDate,t.Toxicity_Status__c, Grade__c, t.Toxicity_Other__c, t.SAE__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.Onset_Date__c, t.Name, t.Id, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, AE_Detail__c, t.Toxicity_Master__r.Toxicity_Name__c From Toxicity__c t where  AE_Detail__r.TrialPatient__c =: TrialPatientId  ];
   
         
               
                    List<Toxicity__c> toxicityListFinal =new List<Toxicity__c>();
                    Map <Decimal,Toxicity__c> toxicitySet=new Map<Decimal,Toxicity__c>();
                  //   for(Integer i=0;i< toxicityDisplayList.size();i++){
                     //	Toxicity__c toxicity1 =toxicityList[i];
                   //system.debug('All the IDs of the Toxicity list is '+toxicity1.AE_ID__c);
                    // }
                    system.debug('inside the overivew tab ---> Accepted form --->line 571');
                    if(toxicityDisplayList.size()>0){
                      for(Integer i=0;i< toxicityDisplayList.size();i++){
                      	
                      	Toxicity__c toxicity1 =toxicityDisplayList[i];
                      	
                      	
                      	
                      	
                      	system.debug('Toxicity object from the loop from 1st loop '+toxicity1);
                      	 for(Integer j=1;j< toxicityDisplayList.size();j++){
                      	
                      	Toxicity__c toxicity2 =toxicityDisplayList[j];
                      	system.debug('Toxicity object from the loop is '+toxicity2);
                      	system.debug('Toxicity1 AE_ID is  '+toxicity1.AE_ID__c);
                      	system.debug('Toxicity2 AE_ID is  '+toxicity2.AE_ID__c);
                      	if(toxicity1.AE_ID__c==toxicity2.AE_ID__c){
                      	if(toxicity1.LastModifiedDate>toxicity2.LastModifiedDate){
                      		toxicitySet.put(toxicity1.AE_ID__c,toxicity1);
                      		system.debug('Toxicity Element added in the list is ------> '+toxicity1);
                      	}
                      	
                      	}
                      		
                      	}if(!toxicitySet.containsKey(toxicity1.AE_ID__c)){
                      toxicitySet.put(toxicity1.AE_ID__c,toxicity1);
                      	}
                      	}
           
                      
                      }
                      toxicityListFinal.clear();
                    toxicityListFinal=toxicitySet.values();
      
            for(Toxicity__c toxicityObj : toxicityListFinal) {
                wrapToxicity wrapToxicityObj = new wrapToxicity();
                wrapToxicityObj.ToxicityObj = toxicityObj;
                wrapToxicityObj.isReadOnly = true;
                if(toxicityObj.AE_Detail__c != null) {
                    wrapToxicityObj.isAE = true;
                    wrapAEToxicityList.add(wrapToxicityObj);
                    isPriorAEShow = true;
                } else if(toxicityObj.Baseline_Symptoms_Form__c != null) {
                    wrapToxicityObj.isBaseline = true;
                    wrapBaselineToxicityList.add(wrapToxicityObj);
                    isBaselineSymptomShow = true;
                }
            }
        }
        
        if(nextTabName == 'CompleteTab') {
        	system.debug('line 617');
            //String TrialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
            //toxicityDisplayList = [Select t.TrialPatient__c, Toxicity_Agent__c, t.Toxicity_Status__c, Grade__c, t.Toxicity_Other__c, t.SAE__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.Onset_Date__c, t.Name, t.Id, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, AE_Detail__c, t.Toxicity_Master__r.Toxicity_Name__c From Toxicity__c t where ((AE_Detail__c =:AEObj.Id) or (AE_Detail__r.Status__c = 'Accepted' and AE_Detail__r.TrialPatient__c =: TrialPatientId and AE_Detail__r.Visit_Date__c<:AEObj.Visit_Date__c)) and Symptom_Status__c = 'Yes'];
             toxicityDisplayList = [Select t.TrialPatient__c, Toxicity_Agent__c, t.Toxicity_Status__c, Grade__c, t.Toxicity_Other__c, t.SAE__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.Onset_Date__c, t.Name, t.Id, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, AE_Detail__c, t.Toxicity_Master__r.Toxicity_Name__c From Toxicity__c t where  AE_Detail__r.TrialPatient__c =: TrialPatientId  ];
            if(!toxicityDisplayList.isEmpty()) {
                isCurrentAEShow = true;
            }
        } else if(nextTabName == 'saveAndClose') {
//=============================For Save & Close Functionality =========================        
          AEobj.First_Save_and_Close__c = true;
            //Added By Shruti (DE401)
            try {
            update AEobj;
             }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
            // Pagereference ref = new Pagereference('/apex/AdverseEvent?id='+rId);
            Pagereference ref = new Pagereference('/'+rid);
            ref.setRedirect(true);
             return ref; 
             }
             //Added by Shruti (DE401)             
//======================================================================================             
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
            if(!trialPatList.isEmpty()) {
                Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
               // Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
                pr.setRedirect(true);
                return pr;
            }
        }
        currentTab = nextTabName;
        return null;
    }
    
    // public void previous() {
    public Pagereference previous() { //Added by Shruti (DE401)
        system.debug('__currentTab__'+currentTab);
        String prevTabValue = Apexpages.currentPage().getParameters().get('prevTab');
        system.debug('__prevTabValue__'+prevTabValue);
        currentTab = prevTabValue;
       //Added By Shruti (DE401)
            try {
            update AEObj;
             }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
            // Pagereference ref = new Pagereference('/apex/AdverseEvent?id='+rId);
            Pagereference ref = new Pagereference('/'+rid);
            ref.setRedirect(true);
             return ref; 
             }
             return null;
             //Added by Shruti (DE401) 
    }

//===========================customCancel used for delete record in AE CRF===========================================   
    public Pagereference customCancel() {
        //String TrialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
        
        system.debug('__TrialPatientId__'+TrialPatientId);
        List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
       /* if(AEObj.OriginalCRF__c == null) {
            delete AEObj;
        }*/
        if( AEObj.id != null) {
                     //Added By Shruti (DE401)
            try {
            delete new AE_Detail__c(id=AEObj.id );
             }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
             // Pagereference ref = new Pagereference('/apex/AdverseEvent?id='+rId);
             Pagereference ref = new Pagereference('/'+rid);
            ref.setRedirect(true);
             return ref; 
             }
             //Added by Shruti (DE401)                        
                }  
                
        
        System.debug('-----Deleted---->');
        Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
        //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
        return pr;
    }

//===========================Sign And Submit for Site User in AE CRF===========================================         
    public void signAndSubmit() {
        
        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
        //completeCrf.customAdhoc(AEObj.Id+'', 'submit', 'Site'); 
        //submitAdverseEvent();
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00057','',AEObj.Id+'','Site');
        //system.debug('ref:'+ref);
        system.debug('errorMsg :  '+signSubmit.errorMsg);
        
        errorMsg = signSubmit.errorMsg;
        msgColor = 'Red';
        isDelete= true;
        //return ref;
    }
    /*
     private void submitAdverseEvent(){
        
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
       
        
        cdapackage.CDAGeneratorPort ihub = new cdapackage.CDAGeneratorPort();
        External_Connection_Settings__c iHubEndpoint = External_Connection_Settings__c.getInstance('iHub');
        if (iHubEndpoint !=null){
            ihub.endpoint_x=iHubEndpoint.URL__c;
            ihub.timeout_x=iHubEndpoint.Timeout__c.intValue();
        }
        else{
            ihub.endpoint_x = 'http://ec2-54-242-110-43.compute-1.amazonaws.com:8080/TranscendForce/services/TranscendForceResource';
            ihub.timeout_x = 120000;
        }
        cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
        cdapackage.author author = new cdapackage.author();
        cdapackage.patient patient = new cdapackage.patient();
        cdapackage.procedure procedure = new cdapackage.procedure();
        cdapackage.guidanceMethod[] guidanceArray;// = new cdapackage.guidanceMethod[]{};
        String xmlType = (radioValue==null? 'CDA' : radioValue);
        author.idExtension = UserInfo.getUserName();
        
        AE_Detail__c adverseEventObj = [select a.caAERS_report_filed__c, a.Visit_Date__c, a.CompletedDate__c, a.CRF__c, a.TrialPatient__c, a.SystemModstamp, a.Status__c, 
                    a.Patient_Hospitalized__c, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, 
                    a.Effective_Time__c, a.CreatedById, OriginalCRF__c, (Select Id, Name, AE_Detail__c, AE_End_Date__c, Attribution__c, 
                    Did_event_required_hospitalization__c, Did_event_result_in_death__c, Did_the_investigator_find_event_unusual__c, 
                    Grade__c, Onset_Date__c, Patient_Complaint__c, Resolved__c, Result_conginental_abnormality_defect__c, 
                    Result_persistent_significant_disability__c, SAE__c, Was_event_life_threatning__c, Symptom_Status__c, Symptom_Masters__c, Toxicity_Master__c,  Toxicity_Status__c   From Toxicities__r)
                    From AE_Detail__c a where Id =: AEObj.id];
                    
        clinicalDoc.id=adverseEventObj.id;
        clinicalDoc.title = 'Create Or Update Adverse Events';
        //clinicalDoc.effectiveTime=String.valueOf(adverseEventObj.Effective_Time__c);
        if(adverseEventObj.Effective_Time__c!=null){
            clinicalDoc.effectiveTime=String.valueOf(adverseEventObj.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
        }
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
            //patient.gendercode=patientObj.
            //patient.doB=String.valueOf(patientObj.Birthdate__c);
            if(patientObj.Birthdate__c!=null){
                patient.doB=String.valueOf(patientObj.Birthdate__c).replaceAll('-','').replaceAll(' ','');
            }
            //patient.maritalStatus=patientObj.
            //patient.maritalStatuscode=patientObj.
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
                }else if(patientObj.Race__c=='Native Hawaiian or Other Pacific Islander'){
                    patient.raceCode='2076-8';
                }else{
                    patient.raceCode='N/A';
                }
            }
            if(patientSet.contains('Ethnicity__c')) {
                patient.ethinicity=patientObj.Ethnicity__c;
                //patient.raceCode=patientObj.
                //patient.ethinicityCode=patientObj.
                if(patientObj.Ethnicity__c=='Not Hispanic or Latino'){
                    patient.ethinicityCode='2186-5';
                }else if(patientObj.Ethnicity__c=='Hispanic or Latino'){
                    patient.ethinicityCode='2135-2';
                }else{
                    patient.ethinicityCode='N/A';
                }
            }
            
            //procedure.siteIdentifier= patientObj.Institution__c;
            clinicalDoc.siteIdentifier= patientObj.Institution__c;
            
            //if(tissueSpecimenSet.contains('ISPY2_Subject_Id__c')) {
                clinicalDoc.studySubjectIdentifier=trialPatientObj.Subject_Id__c;
            //}
            
            mrn=patientObj.Medical_Record_Number__c;
            
        }
        siteId = trialPatientObj.Site__c;
        studyId = trialPatientObj.Subject_Id__c;
        
        //clinicalDoc.siteIdentifier= trialPatientObj.Site__r.Name;
        //clinicalDoc.siteIdRoot=registrationObj.Site__r.Name;      
        //clinicalDoc.studyId=trialPatientObj.Subject_Id__c ;
        //clinicalDoc.studyIdRoot=trialPatientObj.Subject_Id__c ;
       
       
        clinicalDoc.siteIdentifier= '7100';
        clinicalDoc.siteIdRoot='7100';
        clinicalDoc.studyId='7000' ;
        clinicalDoc.studyIdRoot='7000' ;
        
        cdapackage.adverseEvent[] adverseEventArray = new cdapackage.adverseEvent[adverseEventObj.Toxicities__r.size()];
        for(Integer i=0;I< adverseEventObj.Toxicities__r.size();i++){
            Toxicity__c tox=adverseEventObj.Toxicities__r[i];
            cdapackage.adverseEvent ae = new cdapackage.adverseEvent();
            
            ae.id= tox.Id;
            //ae.reportingPeriodEndDate=String.valueOf(tox.AE_End_Date__c);
            if(tox.AE_End_Date__c!=null){
                ae.reportingPeriodEndDate=String.valueOf(tox.AE_End_Date__c).replaceAll('-','').replaceAll(' ','');
            }
            ae.grade = tox.Grade__c;
            ae.attribution=tox.Attribution__c;
            if(tox.Attribution__c=='Unrelated'){
                ae.attributionCode='N/A';
            }else if(tox.Attribution__c=='Unlikely'){
                ae.attributionCode='N/A';
            }else if(tox.Attribution__c=='Possible'){
                ae.attributionCode='371930009';
            }else if(tox.Attribution__c=='Probable'){
                ae.attributionCode='N/A';
            }else if(tox.Attribution__c=='Definite'){
                ae.attributionCode='255545003';
            }
           
            
            
            //ae.onsetDate =String.valueOf(tox.Onset_Date__c);
            if(tox.Onset_Date__c!=null){
                ae.onsetDate=String.valueOf(tox.Onset_Date__c).replaceAll('-','').replaceAll(' ','');
            }
             
           
            ae.groupid = '';
            ae.reportingPeriodStartDate = '';
            //ae.resolutionDate ='';
            if(tox.AE_End_Date__c!=null){
                ae.resolutionDate=String.valueOf(tox.AE_End_Date__c).replaceAll('-','').replaceAll(' ','');
            }
            
            ae.adversereaction=tox.Name;
            ae.adversereactionCode='';
            ae.verbatim='10001367';
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
                ae.seriousReasonCode='N/A';
            }else if(tox.Result_conginental_abnormality_defect__c){
                ae.seriousReason='Is a congenital abnormality/birth defect';
                ae.seriousReasonCode='66091009';
            }else if(tox.Result_persistent_significant_disability__c){
                ae.seriousReason='Results in persistent or significant incapacity or substantial disruption of the ability to conduct normal life functions';
                ae.seriousReasonCode='405532008';
            }
            
            ae.assignedTreatment='TAC12';
           
            
            adverseEventArray[i] = ae;
        }
        
        String trialId = trialPatientObj.Trial_Id__c;
                
        try{
            //resourceTranscendforceCom.response_element res = new resourceTranscendforceCom.response_element();
            cdapackage.response res = new cdapackage.response();
            if(Test.isRunningTest()) {
                res.status = 'SUCCESS';
                res.description='success message';
                res.code = 'SUCCESS';
            }else{
                //resourceTranscendforceCom.patient_element patientElm = new resourceTranscendforceCom.patient_element();
                //patientElm.institution = institution;
                //patientElm.patientDetail = patientDetail;
                //res = ihub.submitRegistration(institution, patientDetail);
               res = ihub.submitAECDA(clinicalDoc ,author,patient,adverseEventArray ,xmlType );
                
                //System.debug('status='+res.status);
                //System.debug('description='+res.description);
                //System.debug('code='+res.code);
                //if(isChangeInConsent){
                //    String res2 = ihub.submitConsentCDA(clinicalDoc,author,patient,consent ,xmlType);
                //}
            }
            
            if(res.status=='FAILURE'){
                //Failed_Registration__c fr = new Failed_Registration__c(Patient__c=patientId,Trial__c=trialId,Last_Error_Message__c=res.message,Last_Status__c='Failure',Retry__c=True);
                //insert fr;
                //String errorCode = res.code;
                                
                populateFailedRegistration(adverseEventObj.Id,patientId,trialId,siteId,studyId,res.code,res.description,'Failure','caAERS',mrn,res.caXchangeId,res.id);
                
            }
            
        }catch(Exception e){
            System.debug(e);
            
            //Failed_Registration__c fr = new Failed_Registration__c(Patient__c=patientId,Trial__c=trialId,Last_Error_Message__c=e.getMessage(),Last_Status__c='Failure',Retry__c=True);
            //insert fr;
            String errorCode = '1000';
            
            populateFailedRegistration(adverseEventObj.Id,patientId,trialId,siteId,studyId,errorCode,e.getMessage(),'Failure','caAERS',mrn,null,null);
        }
       
    }

    public void populateFailedRegistration(String crfId,String patientId, String trialId, String siteId,String studyId, String errorCode, String errorMessage, String status,String systemName, String mrn,String caXchangeId, String returnId){
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
    }
    */
    public String msgColor {get;set;}
    public void resendCode() {
        SignAndSubmitController ctr = new SignAndSubmitController();
        ctr.resendCode();
        errorMsg = 'Code Sent! Please check your Email.';
        msgColor = 'Green';
    }
   List<wrapToxicity> wrapToxicityPreviousList = new List<wrapToxicity>(); 
//===========================open Baseline Condition/symptoms in edit mode============================================================  
    public void editCondition() {
        String recordIdValue = Apexpages.currentPage().getParameters().get('recordId');
        String typeValue = Apexpages.currentPage().getParameters().get('type');
        String formValue = Apexpages.currentPage().getParameters().get('form');
        
        system.debug('__recordIdValue__'+recordIdValue);
        system.debug('__typeValue__'+typeValue);
            system.debug('__formValue__'+formValue);
        if(recordIdValue != null) {
            /*if(typeValue == 'condition') {
                for(wrapCondition wrapConditionObj : wrapConditionList) {
                    if(wrapConditionObj.baselineConditionObj.Id == recordIdValue) {
                        wrapConditionObj.isEditOnly = true;
                        wrapConditionObj.isReadOnly = false;
                    }
                }
            } */
            if(typeValue == 'toxicity') {
                List<wrapToxicity> wrapToxicityList = new List<wrapToxicity>(); 
                if(formValue == 'baseline') {
                    wrapToxicityList = wrapBaselineToxicityList;
                } else if(formValue == 'AE') {
                    wrapToxicityList = wrapAEToxicityList;
                    System.Debug('Inside the Edit of the Toxicity component from AdverseEventController.cls');
                    
                    
                }
                
             //  List<wrapToxicity> wrapToxicityPreviousList = new List<wrapToxicity>(); 
                for(wrapToxicity wrapToxicityObj : wrapToxicityList) {
                    if(wrapToxicityObj.ToxicityObj.Id == recordIdValue) {
                        wrapToxicityObj.isEditOnly = true;
                        wrapToxicityObj.isReadOnly = false;
                        wrapToxicityPreviousList.add(wrapToxicityObj);
                        system.debug('Prior to editing the value of the attribgute is '+wrapToxicityObj.ToxicityObj.Attribution__c);
                        system.debug('Prior to editing the value of the Resolved  is '+wrapToxicityObj.ToxicityObj.Resolved__c);
                         system.debug('Prior to editing the value of the SAE  is '+wrapToxicityObj.ToxicityObj.SAE__c);
                         system.debug('Prior to editing the value of End Date is '+wrapToxicityObj.ToxicityObj.AE_End_Date__c);
                         system.debug('Prior to editing the value of  AE_Detail__C is '+wrapToxicityObj.ToxicityObj.AE_Detail__c);
                         system.debug('Prior to editing the value of the Toxicity_Status__c is  '+wrapToxicityObj.ToxicityObj.Toxicity_Status__c);
                    }
                }system.debug('Size of the Prior List containg the older values '+wrapToxicityPreviousList.size());
            }
        }
    }

//===========================update Baseline Condition/symptoms============================================================ 
    public void updateCondition() {
    	
    	system.debug('updating the Toxicity from the overview tab line no: 898');
        String recordIdValue = Apexpages.currentPage().getParameters().get('recordId');
        String typeValue = Apexpages.currentPage().getParameters().get('type');
        String formValue = Apexpages.currentPage().getParameters().get('form');
         String pageId = Apexpages.currentPage().getParameters().get('id');
        system.debug('RecordId value of the Toxicity to be added __recordIdValue__'+recordIdValue);
        system.debug('Type of the record to be added__typeValue__'+typeValue);
         system.debug('Form value is ----------------->'+formValue);
          system.debug('Page Id value is  ----------------->'+pageId);
          List<Toxicity__c> toxicity = [Select t.LastModifiedDate,t.Toxicity_Master__c,t.AE_End_Date__c,t.Onset_Date__c,t.Result_conginental_abnormality_defect__c,t.Id, t.Name,t.AE_ID__c,t.SAE__c,t.AE_Detail__c,t.Toxicity_Status__c,t.Attribution__c,t.Resolved__c From Toxicity__c t where t.Id =: recordIdValue];
  Toxicity__c wrapToxicityObj12 ;
   for(Toxicity__c wrapToxicityObj1 : toxicity) {
   wrapToxicityObj12=wrapToxicityObj1;
     system.debug('Prior to updating the value of the attribgute is '+wrapToxicityObj1.Attribution__c);
                        system.debug('Prior to updating  the value of the Resolved  is '+wrapToxicityObj1.Resolved__c);
                         system.debug('Prior to updating the value of the SAE  is '+wrapToxicityObj1.SAE__c);
                                system.debug('Prior to editing the value of the end date  is '+wrapToxicityObj1.AE_End_Date__c);
                                 system.debug('Prior to editing the value of the status is '+wrapToxicityObj1.Toxicity_Status__c);
                                    system.debug('Prior to editing the value of  AE_Detail__C is '+wrapToxicityObj1.AE_Detail__c);
   }
        if(recordIdValue != null) {
            if(typeValue == 'condition') {
                /*List<BaselineCondition__c> updateConditionList = new List<BaselineCondition__c>(); 
                for(wrapCondition wrapConditionObj : wrapConditionList) {
                    if(wrapConditionObj.baselineConditionObj.Id == recordIdValue) {
                        if(wrapConditionObj.baselineConditionObj.End_Date__c < wrapConditionObj.baselineConditionObj.Onset_Date__c) {
                            wrapConditionObj.baselineConditionObj.End_Date__c.addError('End date can\'t be less than Onset date');
                            return;
                        } else if(wrapConditionObj.baselineConditionObj.End_Date__c > system.today()) {
                            wrapConditionObj.baselineConditionObj.End_Date__c.addError('End date can\'t be in future.');
                            return;
                        }
                        updateConditionList.add(wrapConditionObj.baselineConditionObj);
                        wrapConditionObj.isEditOnly = false;
                        wrapConditionObj.isReadOnly = true;
                    }
                }
                
                if(!updateConditionList.isEmpty()) {
                    update updateConditionList;
                }*/
            } else if(typeValue == 'toxicity') {
                List<wrapToxicity> wrapToxicityList = new List<wrapToxicity>(); 
                if(formValue == 'baseline') {
                    wrapToxicityList = wrapBaselineToxicityList;
                } else if(formValue == 'AE') {
                       wrapToxicityList = wrapAEToxicityList;
                     System.Debug('Inside the Update  of the Toxicity component from AdverseEventController.cls');
                    
                }
                system.debug('inside the line number 934');
                List<Toxicity__c> updateToxicityList = new List<Toxicity__c>(); 
                system.debug('size of the list is ---line 1099'+wrapToxicityList.size());
                for(wrapToxicity wrapToxicityObj : wrapToxicityList) {
                
                	system.debug('Value coming from the wrapToxicityList to check ToxicityId'+wrapToxicityObj.ToxicityObj.Id);
                    if(wrapToxicityObj.ToxicityObj.Id == recordIdValue) {
                    	system.debug('inside the condition at line 939');
                    	system.debug('record Id--->'+recordIdValue);
                    		system.debug('Wrap Toxicity Id Value--->'+wrapToxicityObj.ToxicityObj.Id);
                    	//code started from here 	
                      Toxicity__c demo =wrapToxicityObj.ToxicityObj;
                    
                      
                      system.debug('Toxcicity Object that we r getting before the clone is ------------->'+wrapToxicityObj12);
                       Toxicity__c demoClone=wrapToxicityObj12.clone(false,true);
                       system.debug('Toxicity object after the clone is  ------------->'+demoClone);
                        demoClone.AE_ID__c=wrapToxicityObj.ToxicityObj.AE_ID__c;
                        demoClone.Attribution__c=wrapToxicityObj.ToxicityObj.Attribution__c;
                         demoClone.Resolved__c=wrapToxicityObj.ToxicityObj.Resolved__c;
                         demoClone.SAE__c=wrapToxicityObj.ToxicityObj.SAE__c;
                         demoClone.AE_End_Date__c=wrapToxicityObj.ToxicityObj.AE_End_Date__c;
                         demoClone.Toxicity_Status__c='cloned';
                         //demoClone.AE_Detail__c=pageId;
                         
                        system.debug('Last moduified datof the Clone toxicity is '+demoClone.LastModifiedDate);
                      insert demoClone;
                        for(wrapToxicity wrapToxicityPreviousObj : wrapToxicityPreviousList) { 
                        	system.debug('Toxiicty object in the Previous list'+wrapToxicityPreviousObj);
                           demo.Attribution__c=wrapToxicityPreviousObj.ToxicityObj.Attribution__c;
                              demo.Resolved__c=wrapToxicityPreviousObj.ToxicityObj.Resolved__c;
                                demo.SAE__c=wrapToxicityPreviousObj.ToxicityObj.SAE__c;
                                  demo.AE_End_Date__c=wrapToxicityPreviousObj.ToxicityObj.AE_End_Date__c;
                              
                                 demo.Id=wrapToxicityPreviousObj.ToxicityObj.Id;
                                              }
                                             
                  system.debug('Demo Toxicity inserted');     
                  
                       //delete wrapToxicityObj.ToxicityObj;
                        //system.debug('Original  Toxicity deleted ');    
                        system.debug('Original Toxcicity Object that we r getting is ------------->'+demo);
                         system.debug('Toxicity object after the insertion into the DB  ------------->'+demoClone);
                     
                       //code cloning end 
                        if(wrapToxicityObj.ToxicityObj.AE_End_Date__c < wrapToxicityObj.ToxicityObj.Onset_Date__c) {
                            wrapToxicityObj.ToxicityObj.AE_End_Date__c.addError('End date can\'t be less than Onset date');
                            return;
                        } else if(wrapToxicityObj.ToxicityObj.AE_End_Date__c > system.today()) {
                            wrapToxicityObj.ToxicityObj.AE_End_Date__c.addError('End date can\'t be in future.');
                            return;
                        }
                    	system.debug('inside the clone method ------------------->967');
                    	
                    	 //original code commented starts
                        //updateToxicityList.add(wrapToxicityObj.ToxicityObj);
                        //original code commented ends
                           updateToxicityList.add(demoClone);
                       
                       
                       //Clone code end 
                        system.debug('After Updated Toxicity List after ------------------->'+updateToxicityList);
                        wrapToxicityObj.isEditOnly = false;
                        wrapToxicityObj.isReadOnly = true;
                    }
                    
                }
                
                if(!updateToxicityList.isEmpty()) {
                    update updateToxicityList;
                     
                }
            }
        }
    }

//===========================cancel update of Baseline Condition/symptoms============================================================       
    public void updateCancelCondition() {
    	system.debug('Inisde the updateCancelCondition function line no 957');
        String recordIdValue = Apexpages.currentPage().getParameters().get('recordId');
        String typeValue = Apexpages.currentPage().getParameters().get('type');
        String formValue = Apexpages.currentPage().getParameters().get('form');
        system.debug('__recordIdValue__'+recordIdValue);
        system.debug('__typeValue__'+typeValue);
        
        
        if(recordIdValue != null) {
            if(typeValue == 'condition') {
                /*List<BaselineCondition__c> baselineConditionTmpList = [Select b.Daignosis__r.Name, b.Daignosis__c, b.BaselineSymptomsForm__r.TrialPatient__c, b.BaselineSymptomsForm__c, Name, Severity_Grade__c, Attribution__c, Onset_Date__c, Resolved__c, End_Date__c From BaselineCondition__c b where Id =: recordIdValue];
                for(wrapCondition wrapConditionObj : wrapConditionList) {
                    if(wrapConditionObj.baselineConditionObj.Id == recordIdValue) {
                        for(BaselineCondition__c ConditionTmpObj : baselineConditionTmpList) {
                            wrapConditionObj.baselineConditionObj = ConditionTmpObj; 
                        }
                        wrapConditionObj.isEditOnly = false;
                        wrapConditionObj.isReadOnly = true;
                    }
                }*/
            } else if(typeValue == 'toxicity') {
                List<wrapToxicity> wrapToxicityList = new List<wrapToxicity>(); 
                if(formValue == 'baseline') {
                    wrapToxicityList = wrapBaselineToxicityList;
                } else if(formValue == 'AE') {
                    wrapToxicityList = wrapAEToxicityList;
                }
                List<Toxicity__c> ToxicityTmpList = [Select t.Toxicity_Master__r.Toxicity_Name__c,t.Baseline_Symptoms_Form__r.Status__c, AE_ID__c, t.AE_Detail__r.Status__c, t.Was_event_life_threatning__c, t.Toxicity_Status__c, t.Toxicity_Other__c, t.SystemModstamp, t.SAE__c, t.Result_persistent_significant_disability__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.OwnerId, t.Onset_Date__c, t.Name, t.LastModifiedDate, t.LastModifiedById, t.IsDeleted, t.Id, t.Grade__c, t.Did_event_result_in_death__c, t.Did_event_required_hospitalization__c, t.CreatedDate, t.CreatedById, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_End_Date__c, t.AE_Detail__c From Toxicity__c t where Id =: recordIdValue];
                for(wrapToxicity wrapToxicityObj : wrapToxicityList) {
                    if(wrapToxicityObj.ToxicityObj.Id == recordIdValue) {
                        for(Toxicity__c ToxicityTmpObj : ToxicityTmpList) {
                            wrapToxicityObj.ToxicityObj = ToxicityTmpObj; 
                        }
                        wrapToxicityObj.isEditOnly = false;
                        wrapToxicityObj.isReadOnly = true;
                    }
                }
            }
        }
    }
    
    public void viewXML() {
        Attachment att = new Attachment();
        att.ContentType = 'application/xml';
        //att.Body = ref.getContent();
        att.Body = Blob.valueOf(generateXML());
        att.Name = 'AdverseEventXML '+system.today();
        att.ParentId = AEObj.Id;
        insert att;
        system.debug('--att--'+att);
    }
    
    public String generateXML() {
       
        
        IsXMLGenerated = true;
       
        //Start added by amit
        System.debug('Amit======================witin ViewXML');
        cdapackage.CDAGeneratorPort ihub = new cdapackage.CDAGeneratorPort();
        External_Connection_Settings__c iHubEndpoint = External_Connection_Settings__c.getInstance('iHub');
        if (iHubEndpoint !=null){
            ihub.endpoint_x=iHubEndpoint.URL__c;
            ihub.timeout_x=iHubEndpoint.Timeout__c.intValue();
        }
        else{
            ihub.endpoint_x = 'http://ec2-23-20-103-202.compute-1.amazonaws.com:12020/services/CDAGenerator';
            ihub.timeout_x = 120000;
        }
        cdapackage.clinicalDocument clinicalDoc = new cdapackage.clinicalDocument();
        cdapackage.author author = new cdapackage.author();
        cdapackage.patient patient = new cdapackage.patient();
        //cdapackage.procedure procedure = new cdapackage.procedure();
        //cdapackage.adverseEvent[] adverseEventArray = new cdapackage.adverseEvent[]{};
        String xmlType = (radioValue==null? 'CDA' : radioValue);
        
        author.idExtension = UserInfo.getUserName();
        
        clinicalDoc.id=AEObj.id;
        clinicalDoc.title = 'Create Or Update Adverse Events';
        //clinicalDoc.effectiveTime=String.valueOf(AEObj.Effective_Time__c);
        if(AEObj.Effective_Time__c!=null){
            clinicalDoc.effectiveTime=String.valueOf(AEObj.Effective_Time__c).replaceAll('-','').replaceAll(':','').replaceAll(' ','');
        }
        clinicalDoc.siteIdentifier= trialPatientObj.Site__r.Name;
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
            
            //patient.gendercode=patientObj.
            //patient.doB=String.valueOf(patientObj.Birthdate__c);
            if(patientObj.Birthdate__c!=null){
                patient.doB=String.valueOf(patientObj.Birthdate__c).replaceAll('-','').replaceAll(' ','');
            }
            //patient.maritalStatus=patientObj.
            //patient.maritalStatuscode=patientObj.
            patient.maritalStatus='UNKNOWN';
            patient.maritalStatuscode='N/A';
            //patient.race=patientObj.Race__c;
            
            
            //patient.race=patientObj.Race__c;
            List<String> stringList = patientObj.Race__c.split('\\;');  
            if(stringList.size()>0 ){
                 patientObj.Race__c = stringList[0];
            }
            
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
            //patient.raceCode=patientObj.
            //patient.ethinicityCode=patientObj.
            if(patientObj.Ethnicity__c=='Not Hispanic or Latino'){
                patient.ethinicityCode='2186-5';
            }else if(patientObj.Ethnicity__c=='Hispanic or Latino'){
                patient.ethinicityCode='2135-2';
            }else{
                patient.ethinicityCode='N/A';
            }
            
            
            //clinicalDoc.siteIdentifier= patientObj.Institution__c;
        
        }
        
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
      
        clinicalDoc.studySubjectIdentifier=trialPatientObj.Subject_Id__c;
        
        List<Toxicity__c> toxicityList = [Select Id, Name, AE_Detail__c, AE_End_Date__c, Attribution__c, 
                    Did_event_required_hospitalization__c, Did_event_result_in_death__c, Did_the_investigator_find_event_unusual__c, 
                    Grade__c, Onset_Date__c, Patient_Complaint__c, Resolved__c, Result_conginental_abnormality_defect__c, 
                    Result_persistent_significant_disability__c, SAE__c, Was_event_life_threatning__c, Symptom_Status__c, Symptom_Masters__c, Toxicity_Master__c,  Toxicity_Status__c   From Toxicity__c where ae_detail__c = :AEObj.Id];
        cdapackage.adverseEvent[] adverseEventArray = new cdapackage.adverseEvent[toxicityList.size()];
        for(Integer i=0;I< toxicityList.size();i++){
            Toxicity__c tox=toxicityList[i];
            cdapackage.adverseEvent ae = new cdapackage.adverseEvent();
            
            ae.id= tox.Id;
            ae.reportingPeriodEndDate=String.valueOf(tox.AE_End_Date__c);
            ae.grade = tox.Grade__c;
            ae.attribution=tox.Attribution__c;
            if(tox.Attribution__c=='Unrelated'){
                ae.attributionCode='N/A';
            }else if(tox.Attribution__c=='Unlikely'){
                ae.attributionCode='N/A';
            }else if(tox.Attribution__c=='Possible'){
                ae.attributionCode='371930009';
            }else if(tox.Attribution__c=='Probable'){
                ae.attributionCode='N/A';
            }else if(tox.Attribution__c=='Definite'){
                ae.attributionCode='255545003';
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
                //ae.resolutionDate=String.valueOf(tox.Onset_Date__c).replaceAll('-','').replaceAll(' ','');
                ae.resolutionDate='';
            }
            
            ae.adversereaction=tox.Name;
            //ae.adversereactionCode='405532008';
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
                ae.seriousReasonCode='N/A';
            }else if(tox.Result_conginental_abnormality_defect__c){
                ae.seriousReason='Is a congenital abnormality/birth defect';
                ae.seriousReasonCode='66091009';
            }else if(tox.Result_persistent_significant_disability__c){
                ae.seriousReason='Results in persistent or significant incapacity or substantial disruption of the ability to conduct normal life functions';
                ae.seriousReasonCode='405532008';
            }
            
            //ae.assignedTreatment='TAC1';
            //ae.assignedTreatment='Paclitaxel';
            //ae.assignedTreatment=treatmentArmName;
            if(treatmentArmName!=null){
                ae.assignedTreatment=treatmentArmName;
            }else{
                ae.assignedTreatment='Screening';
            }
            ae.eventtypecode='59037007';
            ae.eventtypename='drug intolerance';
            
            adverseEventArray[i] = ae;
        }
       
        if(Test.isRunningTest()) {
            xmlOutput= '<xml>Test XML</xml>';
        }else{
            //xmlOutput = ihub.generateBioCDA(clinicalDoc ,author,patient,procedure,guidanceArray ,xmlType);
            xmlOutput = ihub.generateAECDA(clinicalDoc ,author,patient,adverseEventArray ,xmlType ); 

        }
        
        //End added by Amit
      
        return xmlOutput;
        
       
    }
    
    public Pagereference downloadXML() {
        //generateXML();
        List<Attachment> lstAtt = [select Body from Attachment where ParentId = :AEObj.Id order by CreatedDate DESC];
        if(!lstAtt.isEmpty()) {
            xmlOutput = Encodingutil.base64Encode(lstAtt[0].Body);
        }
        Pagereference ref = new Pagereference('/apex/AE_XML_Page');
        //ref.setRedirect(true);
        return ref;
    }
    
    /*public void deleteCondition() {
    
        String recordIdValue = Apexpages.currentPage().getParameters().get('recordId');
        Integer serialNumberValue = Integer.valueOf(Apexpages.currentPage().getParameters().get('serialNumber'));
        system.debug('__recordIdValue__'+recordIdValue);
        delete [select Id from BaselineCondition__c where Id =:recordIdValue];
        wrapConditionList.remove(serialNumberValue--);
    }*/

//=======================Edit main CRF After rejecting by DCC============================================================
    public Pagereference cloneCRF() {
        openInEditMode = true;
        //String clonedCRFId = CloneBuilder.cloneMe(AEObj.Id, '0', '');
        //Pagereference ref = new Pagereference('/apex/AdverseEvent?trialPat='+AEObj.TrialPatient__c+'&aeid='+clonedCRFId);
        //ref.setRedirect(true);
        AEObj.Status__c = 'Not Completed';
        update AEObj;
        return null;
    }
    
    public Pagereference editCRF() {
        if(isShowEditButton) {
        	system.debug('Click on the Edit button on the Toxicity List line number 1276');
            lstCloneAE[0].Status__c = 'Not Completed';
            //Added By Shruti (DE401)
            try {
            update lstCloneAE[0];
             }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
             // Pagereference ref = new Pagereference('/apex/AdverseEvent?id='+rId);
                 Pagereference ref = new Pagereference('/'+rid);
            ref.setRedirect(true);
             return ref; 
             }
             //Added by Shruti (DE401)            
        }
        openInEditMode = false;
        currentTab = 'overviewTab';
        isComplete = true;
        Pagereference pr = new Pagereference('/apex/AdverseEvent?trialPat='+TrialPatientId+'&aeid='+clonedCRFId);
        pr.setRedirect(true);
        return pr;
    }
    
//=======================wrapper class for Baseline Condition============================================================
    public class wrapCondition {
        public BaselineCondition__c baselineConditionObj {get;set;}
        public Boolean isReadOnly {get;set;}
        public Boolean isEditOnly {get;set;}
        public String conditionNumber {get;set;}
        public wrapCondition() {
            isReadOnly = false;
            isEditOnly = false;
        }
    }

//=======================wrapper class for Toxicity============================================================ 
    public class wrapToxicity {
        public Toxicity__c ToxicityObj {get;set;}
        public boolean isBaseline{get;set;}
        public boolean isAE{get;set;}
        public Boolean isReadOnly {get;set;}
        public Boolean isEditOnly {get;set;}
        public wrapToxicity() {
            isReadOnly = false;
            isEditOnly = false;
            isBaseline = false;
            isAE = false;
        }
    }
  
        @isTest public static void test1(){
        CRFMaster__c crfMaster = new CRFMaster__c(Object_Name__c ='AE_Detail__c');
        insert crfMaster;
        XML_Configuration__c c1 = new XML_Configuration__c(Field_API_Name__c='First_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c1;
        XML_Configuration__c c2 = new XML_Configuration__c(Field_API_Name__c='Last_Name__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c2;
        XML_Configuration__c c3 = new XML_Configuration__c(Field_API_Name__c='Race__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c3;
        XML_Configuration__c c4 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'Patient_Custom__c');
        insert c4;
        
        XML_Configuration__c conf1 = new XML_Configuration__c(Field_API_Name__c='Ethnicity__c',CRF_Type__c = crfMaster.Id,Object_API_Name__c = 'AE_Detail__c');
        insert conf1;
        
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
        /*
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
        */
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
        
       
        
        Apexpages.currentPage().getParameters().put('isxmlpage','False');
        ApexPages.currentPage().getParameters().put('trialPat',tp.Id);   
        Apexpages.currentPage().getParameters().put('aeid',ae.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(ae);
        AdverseEventController con = new AdverseEventController(controller);
        con.AEObj = [select a.caAERS_report_filed__c, a.Visit_Date__c, a.CompletedDate__c, a.CRF__c, a.TrialPatient__c, a.SystemModstamp, a.Status__c, 
                    a.Patient_Hospitalized__c, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, 
                    a.Effective_Time__c, a.CreatedById, (Select Id, Name, AE_Detail__c, AE_End_Date__c, Attribution__c, 
                    Did_event_required_hospitalization__c, Did_event_result_in_death__c, Did_the_investigator_find_event_unusual__c, 
                    Grade__c, Onset_Date__c, Patient_Complaint__c, Resolved__c, Result_conginental_abnormality_defect__c, 
                    Result_persistent_significant_disability__c, SAE__c, Was_event_life_threatning__c, Symptom_Status__c, Symptom_Masters__c, AE_ID__c, Toxicity_Master__c, Toxicity_Master__r.Toxicity_Name__c,  Toxicity_Status__c From Toxicities__r)
                    From AE_Detail__c a where Id=:ae.Id];
        
        Test.startTest();
        
        //con.submitRegistration();
        con.viewXML();
        //con.submitAdverseEvent();
        //con.populateFailedRegistration(ae.Id,p.id, t.id, site1.Id,null, 'errorCode', 'Error message', 'Failure','System', '123','100','1000');
        Test.stopTest();
    }        
}