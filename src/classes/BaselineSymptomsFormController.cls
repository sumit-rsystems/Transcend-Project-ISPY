public with sharing class BaselineSymptomsFormController extends PageControllerBase {
    
    public String userId {get;set;}
    public String password {get;set;}
    public String errorMsg {get;set;}
    public String pageError {get;set;}
    public boolean isPageError {get;set;}
    
    public String trialPatientId = null;
    public String trialPatient {get;set;}
    public Id baselineFormId {get;set;}
    public BaselineSymptomsForm__c baselineSymptoms {get;set;}
    public List<AllergyWrapper> lstAllergyWrapper {get;set;} 
    public List<BaselineConditionWrapper> lstConditionWrapper {get;set;}
    
    public List<AllergyDisplayWrapper> lstAllergyDisplayWrapper {get;set;}
    public List<ConditionDisplayWrapper> lstConditionDisplayWrapper {get;set;}
    public List<Toxicity__c> toxicityDisplayList {get;set;}
    private List<BaselineSymptomsForm__c> lstCloneBaseline{get;set;}
    public String lastFeed {get;set;}
    public String currentTab {get;set;}
    public String nextTabName{get;set;}
    private Id clonedCRFId{get;set;}
    public boolean isFirstTab {get;set;}
    public boolean isLastTab {get;set;}
    public boolean isComplete {get;set;}
    public boolean openInEditMode {get;set;}
    public boolean isShowEditButton{get;set;}
    public integer allergySNo = 0;
    public integer conditionSNo = 0;
    public TrialPatient__c trialPatientObj{get;set;}
    public String profileName{get;set;}
    public Boolean isDelete{get;set;}
    public BaselineSymptomsForm__c pathObj{get;set;}
     
    public integer getAllergySNo() {
        return allergySNo;
    }
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
    
    public void callAddToxicityControllerMethod(Id baselineFormId) {
        system.debug('addToxicityCompController : '+addToxicityCompController);
        addToxicityCompController.saveToxicity(baselineFormId);  
    }*/
  
    public BaselineSymptomsFormController(Apexpages.StandardController std) {
        System.debug('BaselineSymptoms-------'+std.getId());
        baselineFormId = std.getId();
        BaselineSymptomsForm__c BaselineSymptomsObj;
        if(baselineFormId != null)BaselineSymptomsObj = [Select b.TrialPatient__c From BaselineSymptomsForm__c b where id =: baselineFormId];
        
        String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        }
        openInEditMode = false;
        isPageError = false;
        isComplete = true; 
        isDelete = false;        
        lstAllergyWrapper = new List<AllergyWrapper>();
        lstConditionWrapper = new List<BaselineConditionWrapper>();
        lstAllergyDisplayWrapper = new List<AllergyDisplayWrapper>();
        
        if(BaselineSymptomsObj != null){
            trialPatientId = BaselineSymptomsObj.TrialPatient__c;
            baselineFormId = BaselineSymptomsObj.id;
        }else{
            trialPatientId = Apexpages.currentPage().getParameters().get('trialPat'); 
            baselineFormId = Apexpages.currentPage().getParameters().get('baselineid');
        }
        
        List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPatientId];
        if(!lstTrialPatient.IsEmpty()) {
            trialPatient = lstTrialPatient[0].Name;
            trialPatientObj = lstTrialPatient[0];
        }
        //baselineSymptoms = new BaselineSymptomsForm__c();
        //baselineFormId = std.getId();
        system.debug('baselineFormId : '+baselineFormId);
        if(baselineFormId != null) {
            editBaselineSymptomsForm();
            lstCloneBaseline = [select Id, Status__c, Root_CRF_Id__c from BaselineSymptomsForm__c where OriginalCRF__c =:baselineFormId and Status__c = 'Cloned'];
            if(!lstCloneBaseline.isEmpty()) {
                isShowEditButton = true;
                clonedCRFId = lstCloneBaseline[0].Id;
            }
        } else {
            baselineSymptoms = new BaselineSymptomsForm__c();
            /*List<BaselineSymptomsForm__c> lstBSF = [select Id from BaselineSymptomsForm__c where TrialPatient__c = :trialPatientId];
            if(!lstBSF.isEmpty()) {
                baselineFormId = lstBSF[0].Id;
            }
            editBaselineSymptomsForm();*/
        }
        isFirstTab = true;
        isLastTab = false;
        isComplete = CRFUtilities.isReadOnlyUsr(); 
        if(baselineSymptoms != null){
            //String crfId = baselineSymptoms.CRF__c;
            //System.debug('-----crfId---->'+crfId);
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = baselineSymptoms.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Rejected'){
                    System.debug('-----status---->'+status);
                    currentTab = 'CompleteTab';
                    lstAllergyDisplayWrapper = getAllergyDisplayWrapperList();
                    toxicityDisplayList = getToxicityDisplayList();
                    lstConditionDisplayWrapper = getlstConditionDisplayWrapperList();
                    /*lstFeeds = [Select b.ParentId, b.ContentFileName, b.ContentDescription, b.Body, b.LinkUrl From BaselineSymptomsForm__Feed b where ParentId = :baselineSymptoms.Id order by CreatedDate DESC];
                    if(!lstFeeds.isEmpty()) {
                        lastFeed = lstFeeds[lstFeeds.size() - 1].Body;
                    } */
                    isComplete = false; 
                } else {
                    currentTab = 'AllergyBaselineTab';
                }
            //}
        }
        isDelete();
        //currentTab = 'AllergyBaselineTab';
    }
    public void isDelete(){
        
        System.debug('======baselineFormId=======' +baselineFormId);
        if(baselineFormId != null){
            pathObj = [select Id, Status__c from BaselineSymptomsForm__c where id =:baselineFormId];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======baselineFormId=======' +baselineFormId);
    }
    public pagereference redirect(){
    pagereference redirect = new pagereference('/apex/BaselineSymptomsPdf?id='+baselineFormId);
    redirect.setRedirect(true);
    return redirect;
}
    
    public Pagereference saveMainCRF() {
        if(baselineFormId == null) {
            baselineSymptoms.TrialPatient__c = trialPatientId;
            baselineSymptoms.Visit_Date__c = system.today();
            system.debug('baselineSymptoms : '+baselineSymptoms);
            upsert baselineSymptoms;
            
            //Pagereference pr = new Pagereference('/apex/BaselineSymptomsForm?trialPat='+trialPatientId+'&baselineid='+baselineSymptoms.Id);
            Pagereference pr = new Pagereference('/'+baselineSymptoms.Id);
            //pr.getParameters().put('nooverride', '1');
            pr.setRedirect(true);
            return pr;
        }
        return null;
    }
    
    public Pagereference next() {
        String nextTabValue = Apexpages.currentPage().getParameters().get('tabNext');
        if(nextTabValue != null) {
            nextTabName = nextTabValue;
        }
        system.debug('---nextTabValue---'+nextTabValue);
        system.debug('---nextTabName---'+nextTabName);
        
        if(baselineSymptoms.Visit_Date__c > System.today()) {
            baselineSymptoms.Visit_Date__c.addError('Future dates are not allowed.');
            return null;
        }
        
        /*if(currentTab == 'AllergyBaselineTab') {
            currentTab = 'BaselineSymptomsTab';
        } else if(currentTab == 'BaselineSymptomsTab') {
            currentTab = 'attachmentTab';           
        }  else if(currentTab == 'attachmentTab') {
            currentTab = 'CompleteTab';
        }*/
        
        if(nextTabName == 'CompleteTab') {
            isFirstTab = false;
            isLastTab = true;
            lstAllergyDisplayWrapper = getAllergyDisplayWrapperList();
            toxicityDisplayList = getToxicityDisplayList();
            lstConditionDisplayWrapper = getlstConditionDisplayWrapperList();
        }
        //Added by  Shruti (DE401)
        try {   
        update baselineSymptoms;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
            // Pagereference ref = new Pagereference('/apex/BaselineSymptomsForm?id='+baselineFormId);
             Pagereference ref = new Pagereference('/'+baselineFormId);
            ref.setRedirect(true);
             return ref;             
        }
        // Added by Shruti (DE401)
        if(nextTabName == 'saveAndClose') {
//==================================For Save & Close Functionality ====================        
           baselineSymptoms.First_Save_and_Close__c = true;
           //Added by  Shruti (DE401)
            try {   
            update baselineSymptoms;
            }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
             // Pagereference ref = new Pagereference('/apex/BaselineSymptomsForm?id='+baselineFormId);
             Pagereference ref = new Pagereference('/'+baselineFormId);
            ref.setRedirect(true);
             return ref;             
        }
        // Added by Shruti (DE401)             
//=====================================================================================            
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
    
    //public void previous() {
    public Pagereference previous() { //Added by Shruti (DE401)
        
        if(currentTab == 'BaselineSymptomsTab') {
            currentTab = 'AllergyBaselineTab';
        } else if(currentTab == 'attachmentTab') {
            currentTab = 'BaselineSymptomsTab';
        } else if(currentTab == 'CompleteTab') {
            currentTab = 'attachmentTab';
        }
        
        if(currentTab == 'AllergyBaselineTab') {
            isFirstTab = true;
            isLastTab = false;
        }
        //Added by  Shruti (DE401)
        try {   
        update baselineSymptoms;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
            // Pagereference ref = new Pagereference('/apex/BaselineSymptomsForm?id='+baselineFormId);
             Pagereference ref = new Pagereference('/'+baselineFormId);
            ref.setRedirect(true);
             return ref;             
        }
             return null;
        // Added by Shruti (DE401)
    }

    List<AllergyDisplayWrapper> getAllergyDisplayWrapperList() {
        lstAllergyDisplayWrapper = new List<AllergyDisplayWrapper>();
        Set<Id> setAllergy = new Set<Id>(); 
        
        for(AllergyWrapper aWrapper : lstAllergyWrapper){
            setAllergy.add(aWrapper.allergy.Allergies__c);
        }
        List<Allergy_Master__c> lstAllergyMaster = [select Name, Description__c from Allergy_Master__c where Id IN : setAllergy];
        Map<Id, String> mapAllergyMaster = new Map<Id, String>();
        for(Allergy_Master__c allergyMaster : lstAllergyMaster) {
            mapAllergyMaster.put(allergyMaster.Id, allergyMaster.Name);
        }
        
        for(AllergyWrapper aWrapper : lstAllergyWrapper) {
            AllergyDisplayWrapper aDisplay = new AllergyDisplayWrapper();
            
            if(aWrapper.allergy.Allergies__c != null) {
                aDisplay.Allergen = mapAllergyMaster.get(aWrapper.allergy.Allergies__c);
            } else if(aWrapper.allergy.Other_Allergy__c != null) {
                aDisplay.Allergen = aWrapper.allergy.Other_Allergy__c;
            } else {
                aDisplay.Allergen = '';
            }
            
              aDisplay.Reaction = '';
            if(aWrapper.allergy.Reactions__c != null) {
                aDisplay.Reaction = aWrapper.allergy.Reactions__c;
	            if(aWrapper.allergy.Reactions__c.contains('Other') &&  aWrapper.allergy.Other_Reactions__c != null) {
	                aDisplay.Reaction = aWrapper.allergy.Reactions__c+':'+aWrapper.allergy.Other_Reactions__c;
	            } 
            } 
            
            
            if(aWrapper.allergy.Severity__c != null) {
                aDisplay.Severity = aWrapper.allergy.Severity__c;
            } else {
                aDisplay.Severity = '';
            }
            
            if(aWrapper.allergy.Year_first_seen__c != null) {
                aDisplay.year = aWrapper.allergy.Year_first_seen__c;
            } else {
                aDisplay.year = '';
            }
            
            lstAllergyDisplayWrapper.add(aDisplay);
        }
        return lstAllergyDisplayWrapper;
    }
    
    List<ConditionDisplayWrapper> getlstConditionDisplayWrapperList() {
        lstConditionDisplayWrapper = new List<ConditionDisplayWrapper>();
        Set<Id> daignosisMasterIds = new Set<Id>();
        for(BaselineConditionWrapper bWrapper : lstConditionWrapper) {
            daignosisMasterIds.add(bWrapper.baselineCondition.Daignosis__c);
        }
        List<Daignosis_Master__c> lstDaignosis = [select Name from Daignosis_Master__c where Id IN :daignosisMasterIds];
        Map<Id, String> mapDaignosisMaster = new Map<Id, String>();
        for(Daignosis_Master__c daignosis : lstDaignosis) {
            mapDaignosisMaster.put(daignosis.Id, daignosis.Name);
        }
        
        for(BaselineConditionWrapper bWrapper : lstConditionWrapper) {
            ConditionDisplayWrapper cDisplay = new ConditionDisplayWrapper();
            
            
            /*if(bWrapper.baselineCondition.Onset_Date__c != null) {
                cDisplay.OnsetDate = String.valueOf(bWrapper.baselineCondition.Onset_Date__c);
            } else {
                cDisplay.OnsetDate = '';
            }*/
            
            if(bWrapper.baselineCondition.Daignosis__c != null) {
                cDisplay.Conditions = mapDaignosisMaster.get(bWrapper.baselineCondition.Daignosis__c);
            } else {
                cDisplay.Conditions = '';
            }
            
            if(bWrapper.baselineCondition.Severity_Grade__c != null) {
                cDisplay.SeverityGrade = bWrapper.baselineCondition.Severity_Grade__c;
            } else {
                cDisplay.SeverityGrade = '';
            }
            
            if(bWrapper.baselineCondition.Attribution__c != null) {
                cDisplay.Attribution = bWrapper.baselineCondition.Attribution__c;
            } else {
                cDisplay.Attribution = '';
            }
            
            if(bWrapper.baselineCondition.Resolved__c != null) {
                cDisplay.Resolved = bWrapper.baselineCondition.Resolved__c;
            } else {
                cDisplay.Resolved = '';
            }
            
            lstConditionDisplayWrapper.add(cDisplay);
        }
        return lstConditionDisplayWrapper;
    }
    
    List<Toxicity__c> getToxicityDisplayList() {
        return toxicityDisplayList = [Select t.TrialPatient__c, t.Toxicity_Status__c, Grade__c, t.Toxicity_Other__c, t.SAE__c, t.Result_conginental_abnormality_defect__c, t.Resolved__c, t.Patient_Complaint__c, t.Onset_Date__c, t.Name, t.Id, t.Baseline_Symptoms_Form__c, t.Attribution__c, t.AE_ID__c, t.AE_End_Date__c, t.Toxicity_Master__r.Toxicity_Name__c From Toxicity__c t where Baseline_Symptoms_Form__c =:baselineFormId]; 
    }
    public pageReference cancelCRF() {
        List<TrialPatient__c> lstTP = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id = :baselineSymptoms.TrialPatient__c];
        if(!lstTP.isEmpty()) {
            if(trialPatientId != null) {
              /*  if(baselineSymptoms.OriginalCRF__c == null) {
                    delete [select Id from Allergy__c where BaselineSymptomsForm__c = :baselineSymptoms.Id];
                    delete [select Id from BaselineCondition__c where BaselineSymptomsForm__c = :baselineSymptoms.Id];
                    delete [select Id from BaselineSymptomsForm__c where Id = :baselineSymptoms.Id];
                }*/
              if( baselineFormId!= null) {
                    //Added by  Shruti (DE401)
        try {   
        delete new BaselineSymptomsForm__c(id=baselineFormId );
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
             // Pagereference ref = new Pagereference('/apex/BaselineSymptomsForm?id='+baselineFormId);
             Pagereference ref = new Pagereference('/'+baselineFormId);
            ref.setRedirect(true);
             return ref;             
        }
        // Added by Shruti (DE401)                        
                }     
                return new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c+'&TrialId='+lstTP[0].Trial_Id__c);
                //return new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c);
            } else {
                return new Pagereference('/'+baselineSymptoms.Id);
            }
        } else {
            return null;
        }
    }
    
    public void editBaselineSymptomsForm() {
        List<BaselineSymptomsForm__c> lsBaselineSymptoms = [Select b.Root_CRF_Id__c,b.Visit_Date__c,b.CRF__c, OriginalCRF__c, CreatedDate, CreatedBy.FirstName, TrialPatient__r.Name, Status__c From BaselineSymptomsForm__c b where Id = :baselineFormId];
        if(!lsBaselineSymptoms.isEmpty()) {
            baselineSymptoms = lsBaselineSymptoms[0];
            trialPatient = lsBaselineSymptoms[0].TrialPatient__r.Name;
        }
        if(baselineFormId != null) {
            lstAllergyWrapper = new List<AllergyWrapper>(); 
            List<Allergy__c> lstAllergy = [Select a.Allergies__r.Name, a.Allergies__c, a.Form_Name__c, a.Year_first_seen__c, a.Severity__c, a.Reactions__c, a.Other_Reactions__c, a.Other_Allergy__c, a.Name, a.Id, a.BaselineSymptomsForm__c, a.Allergy_Type__c From Allergy__c a where BaselineSymptomsForm__c = :baselineFormId and a.Form_Name__c = 'Baseline Symptoms Form(Allergies)' order by Effective_Time__c DESC];
            for(Allergy__c allergy : lstAllergy) {
                AllergyWrapper aWrapper = new AllergyWrapper();
                aWrapper.allergy = allergy;
                aWrapper.isReadOnly = true;
                aWrapper.allergyNumber = String.valueOf(++allergySNo);
                lstAllergyWrapper.add(aWrapper);
            }
            
            lstConditionWrapper = new List<BaselineConditionWrapper>(); 
            List<BaselineCondition__c> lstConditions = [Select b.Severity_Grade__c, b.Resolved__c, b.Name, b.Id, b.Daignosis__r.Name, b.Daignosis__c, b.BaselineSymptomsForm__c, b.Attribution__c, b.DiagnosisType__c, b.OtherDaignosis__c, Onset_Year__c, Onset_Day__c, Onset_Month__c, End_Year__c, End_Month__c, End_Day__c From BaselineCondition__c b where BaselineSymptomsForm__c = :baselineFormId order by Effective_Time__c DESC];
            for(BaselineCondition__c conditions : lstConditions) {
                BaselineConditionWrapper bWrapper = new BaselineConditionWrapper();
                bWrapper.baselineCondition = conditions;
                bWrapper.isReadOnly = true;
                bWrapper.conditionNumber = String.valueOf(++conditionSNo);
                lstConditionWrapper.add(bWrapper);
            }
        }
    }
    
    public void addAllergy() {
        AllergyWrapper aWrapper = new AllergyWrapper();
        aWrapper.allergy = new Allergy__c();
        aWrapper.isReadOnly = false;
        aWrapper.isUpdateVisible = false;
        aWrapper.isOtherAllergy = false;
        aWrapper.allergyNumber = String.valueOf(++allergySNO);
        lstAllergyWrapper.add(aWrapper);
    }
    
    public void changeAllergyType() {
        for(AllergyWrapper aWrapper : lstAllergyWrapper) {
            if(aWrapper.allergyNumber == Apexpages.currentPage().getParameters().get('allergyNumber')) {
                if(aWrapper.allergy.Allergy_Type__c == 'Other')
                    aWrapper.isOtherAllergy = true;
                else
                    aWrapper.isOtherAllergy = false;
            }
        }
    }
    public void saveAllergy() {
        List<Allergy__c> lstAllergy = new List<Allergy__c>();
        for(AllergyWrapper aWrapper : lstAllergyWrapper) {
            aWrapper.isReadOnly = true;
            aWrapper.allergy.BaselineSymptomsForm__c = baselineSymptoms.Id;
            aWrapper.allergy.Form_Name__c = 'Baseline Symptoms Form(Allergies)';
            lstAllergy.add(aWrapper.allergy);
        }
        upsert lstAllergy;
        System.debug('lstAllergy-----'+lstAllergy);
    }
    
    public void updateAllergy() {
        List<Allergy__c> lstAllergy = new List<Allergy__c>();
        for(AllergyWrapper aWrapper : lstAllergyWrapper) {
            if(aWrapper.allergy.Id == Apexpages.currentPage().getParameters().get('recordId')) {
                aWrapper.isReadOnly = true;
                aWrapper.isUpdateVisible = false;
                lstAllergy.add(aWrapper.allergy);
            }
        }
        upsert lstAllergy;
    }
    
    public void editAllergy() {
        for(AllergyWrapper aWrapper : lstAllergyWrapper) {
            if(aWrapper.allergy.Id == Apexpages.currentPage().getParameters().get('recordId')) {
                aWrapper.isReadOnly = false;
                aWrapper.isUpdateVisible = true;
            }
        }
    }
    
    public void cancelAllergy() {
        
        String recordId = Apexpages.currentPage().getParameters().get('recordId');
        system.debug('recordId : '+recordId);
        if(recordId != null && recordId != '') {
            for(AllergyWrapper aWrapper : lstAllergyWrapper) {
                if(aWrapper.allergy.Id == recordId) {
                    aWrapper.isReadOnly = true;
                    aWrapper.isUpdateVisible = false;
                }
            }
            
        } else {
            allergySNO = 0;
            List<AllergyWrapper> lstTempAlWrapper = new List<AllergyWrapper>();
            String cancelIndex = Apexpages.currentPage().getParameters().get('cancelIndex');
            for(AllergyWrapper aWrapper : lstAllergyWrapper) {
                if(aWrapper.allergyNumber != cancelIndex) {
                    AllergyWrapper newALWrapper = new AllergyWrapper();
                    newALWrapper.allergy = aWrapper.allergy;
                    newALWrapper.isReadOnly = aWrapper.isReadOnly;
                    newALWrapper.isUpdateVisible = aWrapper.isUpdateVisible;
                    newALWrapper.allergyNumber = String.valueOf(++allergySNO);
                    lstTempAlWrapper.add(newALWrapper);
                }
            }
            lstAllergyWrapper = new List<AllergyWrapper>();
            lstAllergyWrapper = lstTempAlWrapper;
        }
    }
    
    public void removeAllergy() {
        String recordId = Apexpages.currentPage().getParameters().get('recordId');
        delete [select Id from Allergy__c where Id =:recordId];
        cancelAllergy();
        editBaselineSymptomsForm();
    }
    
    public void addDiagnosis() {
        BaselineConditionWrapper bWrapper = new BaselineConditionWrapper();
        bWrapper.baselineCondition = new BaselineCondition__c();
        bWrapper.baselineCondition.Attribution__c = '0-Baseline';
        bWrapper.isReadOnly = false;
        bWrapper.isUpdateVisible = false;
        bWrapper.isOtherDiagnosis = false;
        bWrapper.conditionNumber = String.valueOf(++conditionSNo);
        lstConditionWrapper.add(bWrapper);
    }
    
    public void changeDiagnosisType() {
        for(BaselineConditionWrapper bWrapper : lstConditionWrapper) {
            if(bWrapper.conditionNumber == Apexpages.currentPage().getParameters().get('conditionNumber')) {
                if(bWrapper.baselineCondition.DiagnosisType__c == 'Other')
                    bWrapper.isOtherDiagnosis = true;
                else
                    bWrapper.isOtherDiagnosis = false;
            }
        }
    }
    
    public void saveDiagnosis() {
        
        List<BaselineCondition__c> lstBaselineCondition = new List<BaselineCondition__c>();
        Set<String> selectedDaignosis = new Set<String>();
        System.debug('lstConditionWrapper------------'+lstConditionWrapper.size());
        for(BaselineConditionWrapper bWrapper : lstConditionWrapper) {
            System.debug('bWrapper.baselineCondition.Daignosis__c------------'+bWrapper.baselineCondition.Daignosis__c);
            if(bWrapper.baselineCondition.Daignosis__c == null) continue;
            boolean isDuplicate = selectedDaignosis.add(bWrapper.baselineCondition.Daignosis__c);
            if(!isDuplicate) {
                pageError = 'You can select a single diagnosis once unless it has been resolved with an end date.';
                for(BaselineConditionWrapper bWrapper1 : lstConditionWrapper) {
                    if(bWrapper1.baselineCondition.Daignosis__c == null) continue;
                    if(bWrapper.baselineCondition.Daignosis__c == bWrapper1.baselineCondition.Daignosis__c) {
                        bWrapper1.isDuplicateRow = true;
                    }
                }
                isPageError = true;
                return;
            } else {
                pageError = '';
                isPageError = false;
                bWrapper.isDuplicateRow = false;
            }
            
            if(bWrapper.baselineCondition.Onset_Year__c != null && bWrapper.baselineCondition.Onset_Month__c != null && bWrapper.baselineCondition.Onset_Day__c != null){
                Date onSetDate = date.newinstance(Integer.valueOf(bWrapper.baselineCondition.Onset_Year__c),Integer.valueOf(bWrapper.baselineCondition.Onset_Month__c),Integer.valueOf(bWrapper.baselineCondition.Onset_Day__c));
                System.debug('onSetDate------------'+onSetDate);
                if(onSetDate > System.today()){
                    pageError = 'On Set Date cannot be future.';
                    isPageError = true;
                    return;
                }
            }
            
            if(bWrapper.baselineCondition.End_Year__c != null && bWrapper.baselineCondition.End_Month__c != null && bWrapper.baselineCondition.End_Day__c != null){
                Date endDate = date.newinstance(Integer.valueOf(bWrapper.baselineCondition.End_Year__c),Integer.valueOf(bWrapper.baselineCondition.End_Month__c),Integer.valueOf(bWrapper.baselineCondition.End_Day__c));
                System.debug('endDate------------'+endDate);
                if(endDate > System.today()){
                    pageError = 'End Date cannot be future.';
                    isPageError = true;
                    return;
                }
            }
        }
        
        for(BaselineConditionWrapper bWrapper : lstConditionWrapper) {
            
            bWrapper.isReadOnly = true;
            bWrapper.baselineCondition.BaselineSymptomsForm__c = baselineSymptoms.Id;
            //bWrapper.baselineCondition.Onset_Date__c = Date.valueOf(bWrapper.onsetDateMonth +'/'+ bWrapper.onsetDateDay +'/'+ bWrapper.onsetDateYear);
            //bWrapper.baselineCondition.Onset_Date__c = date.newinstance(Integer.valueOf(bWrapper.onsetDateYear),Integer.valueOf(bWrapper.onsetDateMonth),Integer.valueOf(bWrapper.onsetDateDay));
            //bWrapper.baselineCondition.End_Date__c = Date.valueOf(bWrapper.endDateMonth +'/'+ bWrapper.endDateDay  +'/'+ bWrapper.endDateYear ); 
            //bWrapper.baselineCondition.End_Date__c = date.newinstance(Integer.valueOf(bWrapper.endDateYear),Integer.valueOf(bWrapper.endDateMonth),Integer.valueOf(bWrapper.endDateDay));
            
            lstBaselineCondition.add(bWrapper.baselineCondition);
        }
        upsert lstBaselineCondition;
    }
    
    public void updateDiagnosis() {
        List<BaselineCondition__c> lstBaselineCondition = new List<BaselineCondition__c>();
        for(BaselineConditionWrapper bWrapper : lstConditionWrapper) {
            if(bWrapper.baselineCondition.Onset_Year__c != null && bWrapper.baselineCondition.Onset_Month__c != null && bWrapper.baselineCondition.Onset_Day__c != null){
                Date onSetDate = date.newinstance(Integer.valueOf(bWrapper.baselineCondition.Onset_Year__c),Integer.valueOf(bWrapper.baselineCondition.Onset_Month__c),Integer.valueOf(bWrapper.baselineCondition.Onset_Day__c));
                System.debug('onSetDate------------'+onSetDate);
                if(onSetDate > System.today()){
                    pageError = 'On Set Date cannot be future.';
                    isPageError = true;
                    return;
                }
            }
            
            if(bWrapper.baselineCondition.End_Year__c != null && bWrapper.baselineCondition.End_Month__c != null && bWrapper.baselineCondition.End_Day__c != null){
                Date endDate = date.newinstance(Integer.valueOf(bWrapper.baselineCondition.End_Year__c),Integer.valueOf(bWrapper.baselineCondition.End_Month__c),Integer.valueOf(bWrapper.baselineCondition.End_Day__c));
                System.debug('endDate------------'+endDate);
                if(endDate > System.today()){
                    pageError = 'End Date cannot be future.';
                    isPageError = true;
                    return;
                }
            }
            
            if(bWrapper.baselineCondition.Id == Apexpages.currentPage().getParameters().get('recordId')) {
                bWrapper.isReadOnly = true;
                bWrapper.isUpdateVisible = false;
                lstBaselineCondition.add(bWrapper.baselineCondition);
            }   
        }
        upsert lstBaselineCondition;
    }
    
    public void editDiagnosis() {
        for(BaselineConditionWrapper bWrapper : lstConditionWrapper) {
            system.debug('RecordId : '+Apexpages.currentPage().getParameters().get('recordId'));
            if(bWrapper.baselineCondition.Id == Apexpages.currentPage().getParameters().get('recordId')) {
                bWrapper.isReadOnly = false;
                bWrapper.isUpdateVisible = true;
            }
        }
    }
    
    public void cancelDiagnosis() {
        
        String recordId = Apexpages.currentPage().getParameters().get('recordId');
        system.debug('recordId : '+recordId);
        if(recordId != null && recordId != '') {
            for(BaselineConditionWrapper bWrapper : lstConditionWrapper) {
                system.debug('RecordId : '+Apexpages.currentPage().getParameters().get('recordId'));
                if(bWrapper.baselineCondition.Id == Apexpages.currentPage().getParameters().get('recordId')) {
                    bWrapper.isReadOnly = true;
                    bWrapper.isUpdateVisible = false;
                }
            }
        } else {
            conditionSNo = 0;
            List<BaselineConditionWrapper> lstTempConWrapper = new List<BaselineConditionWrapper>();
            String cancelIndex = Apexpages.currentPage().getParameters().get('cancelIndex');
            for(BaselineConditionWrapper bWrapper : lstConditionWrapper) {
                if(bWrapper.conditionNumber != cancelIndex) {
                    BaselineConditionWrapper newConWrapper = new BaselineConditionWrapper();
                    newConWrapper.baselineCondition = bWrapper.baselineCondition;
                    newConWrapper.isReadOnly = bWrapper.isReadOnly;
                    newConWrapper.isUpdateVisible = bWrapper.isUpdateVisible;
                    newConWrapper.conditionNumber = String.valueOf(++conditionSNo);
                    lstTempConWrapper.add(newConWrapper);
                }
            }
            lstConditionWrapper = new List<BaselineConditionWrapper>();
            lstConditionWrapper = lstTempConWrapper;
        }
    }
    
    public void removeDiagnosis() {
        String recordId = Apexpages.currentPage().getParameters().get('recordId');
        delete [select Id from BaselineCondition__c where Id =:recordId];
        allergySNO = 0;
        List<AllergyWrapper> lstTempAlWrapper = new List<AllergyWrapper>();
        String cancelIndex = Apexpages.currentPage().getParameters().get('cancelIndex');
        for(AllergyWrapper aWrapper : lstAllergyWrapper) {
            if(aWrapper.allergyNumber != cancelIndex) {
                AllergyWrapper newALWrapper = new AllergyWrapper();
                newALWrapper.allergy = aWrapper.allergy;
                newALWrapper.isReadOnly = aWrapper.isReadOnly;
                newALWrapper.isUpdateVisible = aWrapper.isUpdateVisible;
                newALWrapper.allergyNumber = String.valueOf(++allergySNO);
                lstTempAlWrapper.add(newALWrapper);
            }
        }
        lstAllergyWrapper = new List<AllergyWrapper>();
        lstAllergyWrapper = lstTempAlWrapper;
    }
    
    public Pagereference signAndSubmit() {
        
        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
        //completeCrf.customAdhoc(baselineSymptoms.Id+'', 'submit', 'Site');
       
        
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00056','',baselineSymptoms.Id+'', 'Site');
        system.debug('errorMsg :  '+signSubmit.errorMsg);
        errorMsg = signSubmit.errorMsg;
        msgColor = 'Red';
        isDelete= true;
        return ref;
    }
    public String msgColor {get;set;}
    public void resendCode() {
        SignAndSubmitController ctr = new SignAndSubmitController();
        ctr.resendCode();
        errorMsg = 'Code Sent! Please check your Email.';
        msgColor = 'Green';
    }
    //=======================Edit main CRF After rejecting by DCC============================================================
    
    public Pagereference cloneCRF() {
        openInEditMode = true;
        //String clonedCRFId = CloneBuilder.cloneMe(baselineSymptoms.Id, '0', '');
        baselineSymptoms.Status__c = 'Not Completed';
        update baselineSymptoms;
        return null;
    }
    
    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstCloneBaseline[0].Status__c = 'Not Completed';
            //Added by  Shruti (DE401)
        try {   
        update lstCloneBaseline[0];
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
            // Pagereference ref = new Pagereference('/apex/BaselineSymptomsForm?id='+baselineFormId);
             Pagereference ref = new Pagereference('/'+baselineFormId);
            ref.setRedirect(true);
             return ref;             
        }
        // Added by Shruti (DE401)            
        }
        openInEditMode = false;
        currentTab = 'AllergyBaselineTab';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/BaselineSymptomsForm?trialPat='+trialPatientId+'&baselineid='+clonedCRFId);
        ref.setRedirect(true);
        return ref;
    }
    
    
    public class AllergyWrapper {
        public Allergy__c allergy {get;set;}
        public String allergyNumber {get;set;}
        public boolean isReadOnly {get;set;}
        public boolean isUpdateVisible {get;set;}
        public boolean isOtherAllergy {get;set;}
    }
    
    public class BaselineConditionWrapper {
        public BaselineCondition__c baselineCondition {get;set;}
        public String conditionNumber {get;set;}
        public boolean isReadOnly {get;set;}
        public boolean isUpdateVisible {get;set;}
        public boolean isOtherDiagnosis {get;set;}
        public boolean isDuplicateRow {get;set;}    
        public String onsetDateMonth {get;set;} 
        public String onsetDateDay {get;set;}
        public String onsetDateYear {get;set;}
        public String endDateMonth {get;set;}
        public String endDateDay {get;set;}
        public String endDateYear {get;set;} 
        
        public BaselineConditionWrapper() {
            baselineCondition = new BaselineCondition__c();
            baselineCondition.Attribution__c = '0-Baseline';
        }
    }
    
    public class AllergyDisplayWrapper {
        public String Allergen {get;set;}
        public String Reaction {get;set;}
        public String Severity {get;set;}
        public String year {get;set;}        
    }
    
    public class ConditionDisplayWrapper {
        public String OnsetDate {get;set;}
        public String Conditions {get;set;}
        public String SeverityGrade {get;set;}
        public String Attribution {get;set;}
        public String Resolved {get;set;}
        public String EndDate {get;set;}
    }
    
}