public with sharing class ChemoSummaryFormController extends PageControllerBase{
   
    public String userName {get;set;}
    public String password {get;set;}
    public String errorMsg {get;set;}
    public String currentTab {get;set;}
    public String profileName{get;set;}
    public Boolean isDelete{get;set;}
    public String trialPatientId {get;set;}
    public String trialPatient {get;set;}
    public String nextTabName{get;set;}
    public Id chemoSummaryId{get;set;}
    
    public Boolean isComplete{get;set;}
    public boolean openInEditMode {get;set;}
    public boolean isShowEditButton{get;set;}
    private Id clonedCRFId{get;set;}
    public Chemo_Summary_Form__c chemoSummary{get;set;}
    public List<CompletePageWrapper> lstCompletePageWrapper{get;set;}
    private List<Chemo_Summary_Form__c> lstCloneChemoSum{get;set;}
    public TrialPatient__c trialPatientObj{get;set;}
    public Chemo_Summary_Form__c pathObj{get;set;}
   
    private transient List<ChemoSummaryRegimenDetail__c> lstRegDetails = null;
   
    public RegimenAgentController regimenAgentController1 {set;
        get{
            //get the map, then the component controller using the appropriate key
            if(getComponentControllerMap()!=null){
                RegimenAgentController regAgent;
                regAgent = (RegimenAgentController )getComponentControllerMap().get('regAgent1');
                if(regAgent!= null)
                    return regAgent;
            }
            //just in case something goes wrong return something...this can be handled better
            return new RegimenAgentController();
        }
    }
   
    public RegimenAgentController regimenAgentController2 {set;
        get{
            //get the map, then the component controller using the appropriate key
            if(getComponentControllerMap()!=null){
                RegimenAgentController regAgent;
                regAgent = (RegimenAgentController )getComponentControllerMap().get('regAgent2');
                if(regAgent!= null)
                    return regAgent;
            }
            //just in case something goes wrong return something...this can be handled better
            return new RegimenAgentController();
        }
    }
   
    public RegimenAgentController regimenAgentController3 {set;
        get{
            //get the map, then the component controller using the appropriate key
            if(getComponentControllerMap()!=null){
                RegimenAgentController regAgent;
                regAgent = (RegimenAgentController )getComponentControllerMap().get('regAgent3');
                if(regAgent!= null)
                    return regAgent;
            }
            //just in case something goes wrong return something...this can be handled better
            return new RegimenAgentController();
        }
    }
   
    public RegimenAgentController regimenAgentController4 {set;
        get{
            //get the map, then the component controller using the appropriate key
            if(getComponentControllerMap()!=null){
                RegimenAgentController regAgent;
                regAgent = (RegimenAgentController )getComponentControllerMap().get('regAgent4');
                if(regAgent!= null)
                    return regAgent;
            }
            //just in case something goes wrong return something...this can be handled better
            return new RegimenAgentController();
        }
    }
    //Method for Taxane Regimen
    public void callComp1(Id crfId, String regimen) {
        system.debug('regimenAgentController1 : '+regimenAgentController1);
        //system.debug('regimenAgentController1.regimenDetailWrapper.reason : '+regimenAgentController1.regimenDetailWrapper.reason);
        if(!test.isRunningTest()) {
            regimenAgentController1.saveComponent(crfId, regimen);
        } 
    }
    //Method for Anthracycline Regimen
    public void callComp2(Id crfId, String regimen) {
        system.debug('regimenAgentController2: '+regimenAgentController2);
        //system.debug('regimenAgentController2.regimenDetailWrapper.reason : '+regimenAgentController2.regimenDetailWrapper.reason);
        if(!test.isRunningTest()) {
            regimenAgentController2.saveComponent(crfId, regimen);
        } 
    }
    //Method for Investigational Regimen
    public void callComp3(Id crfId, String regimen) {
        system.debug('regimenAgentController3 : '+regimenAgentController3);
        if(!test.isRunningTest()) {
            regimenAgentController3.saveComponent(crfId, regimen);
        } 
    }
    //Method for Other Regimen
    public void callComp4(Id crfId, String regimen) {
        system.debug('regimenAgentController4 : '+regimenAgentController4);
        if(!test.isRunningTest()) {
            regimenAgentController4.saveComponent(crfId, regimen);
        } 
    }
 
    public ChemoSummaryFormController(Apexpages.StandardController std) {
        System.debug('ChemoSummaryForm-------'+std.getId());
        chemoSummaryId = std.getId();
        Chemo_Summary_Form__c ChemoSummaryFormObj;
        if(chemoSummaryId != null)ChemoSummaryFormObj = [Select c.TrialPatient__c,c.TrialPatient__r.Patient_Id__c From Chemo_Summary_Form__c c where id =: chemoSummaryId];
        
        String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        }
        openInEditMode = false;
        isShowEditButton = false;
        isDelete = false;
        
        if(ChemoSummaryFormObj != null){
            trialPatientId = ChemoSummaryFormObj.TrialPatient__c;
            chemoSummaryId = ChemoSummaryFormObj.id;
        }else{
            trialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
            chemoSummaryId = Apexpages.currentPage().getParameters().get('formId');
        }
        
        if(trialPatientId != null) {
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPatientId];
            if(!lstTrialPatient.IsEmpty()) {
                trialPatientObj = lstTrialPatient[0];
            }
        }
        isComplete = true;
        if(chemoSummaryId != null) {
            List<Chemo_Summary_Form__c> lstChemoSummary = [select Root_CRF_Id__c,Status__c, TrialPatient__c,TrialPatient__r.Patient_Id__c,CRF__c, CreatedDate, CreatedBy.FirstName, OriginalCRF__c from Chemo_Summary_Form__c where Id = :chemoSummaryId];
            if(!lstChemoSummary.isEmpty()) {
                chemoSummary = lstChemoSummary[0];
                lstCloneChemoSum = [select Id, Status__c,Root_CRF_Id__c from Chemo_Summary_Form__c where OriginalCRF__c =: chemoSummaryId and Status__c = 'Cloned'];
                if(!lstCloneChemoSum.isEmpty()) {
                    isShowEditButton = true;
                    clonedCRFId = lstCloneChemoSum[0].Id;
                }
            }
        } else {
            chemoSummary = new Chemo_Summary_Form__c();
        }
       
        lstCompletePageWrapper = new List<CompletePageWrapper>();
        lstRegDetails = [Select c.Treatment_End_Reasons__c, c.Other_Reason__c, c.Id, c.First_Date_of_Therapy__c, c.Chemo_Summary_Form__c, c.Chemo_Regimen__c, c.Last_Date_of_Therapy__c, c.Chemo_Regimen__r.Name From ChemoSummaryRegimenDetail__c c where Chemo_Summary_Form__c = :chemoSummaryId];
        for(ChemoSummaryRegimenDetail__c regDetail : lstRegDetails){
           
            CompletePageWrapper completePageWrapper = new CompletePageWrapper();
            if(regDetail.Chemo_Regimen__r.Name != null) {
                completePageWrapper.regimenName = regDetail.Chemo_Regimen__r.Name;
            } else {
                completePageWrapper.regimenName = 'Other Regimen';             
            }
            completePageWrapper.chemoSummaryRegimen = regDetail;
            /*if(regDetail.ChemoSummaryAgentDetails__r != null) {
                completePageWrapper.lstChemoSummaryAgent = regDetail.ChemoSummaryAgentDetails__r;
                if(completePageWrapper.lstChemoSummaryAgent != null && !completePageWrapper.lstChemoSummaryAgent.isEmpty()) {
                    lstCompletePageWrapper.add(completePageWrapper);
                }
            }*/
           
        }
        system.debug('lstCompletePageWrapper : '+lstCompletePageWrapper);
        isComplete = CRFUtilities.isReadOnlyUsr();
        if(chemoSummary != null){
            //String crfId = chemoSummary.CRF__c;
            //System.debug('-----crfId-------->'+crfId);
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = chemoSummary.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    System.debug('-----status-------->'+status);       
                    currentTab = 'lastTab';
                    isComplete = false;
                } else {
                    currentTab = 'firstTab';
                }
            //}
        }
        isDelete();
    }
    public void isDelete(){
        
        System.debug('======chemoSummaryId=======' +chemoSummaryId);
        if(chemoSummaryId != null){
            pathObj = [select Id, Status__c from Chemo_Summary_Form__c where id =:chemoSummaryId];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======chemoSummaryId=======' +chemoSummaryId); 
    }
    public pagereference redirect(){
            pagereference redirect = new pagereference('/apex/ChemoSummaryPdf?id='+chemoSummaryId);
            redirect.setRedirect(true);
            return redirect;
     }  
   
    public Pagereference saveMainCRF() {
        if(chemoSummaryId == null) {
           
            chemoSummary.TrialPatient__c = trialPatientId;
           
            try {
                insert chemoSummary;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                return null;
            }
           
            chemoSummaryId = chemoSummary.Id;
           
            //Pagereference ref = new Pagereference('/apex/ChemoSummaryForm?trialPat='+trialPatientId+'&formId='+chemoSummaryId);
            Pagereference ref = new Pagereference('/'+chemoSummaryId);
           
            ref.setRedirect(true);
            return ref;
           
        } else {
            List<Chemo_Summary_Form__c> lstChemoSummary = [Select c.TrialPatient__c From Chemo_Summary_Form__c c where Id = :chemoSummaryId];
            if(lstChemoSummary.isEmpty()) {
                return new Pagereference('/'+chemoSummaryId);
            }
        }
        return null;
    }
   
    public Pagereference next() {
        String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
        if(nextTabValue != null){
            nextTabName = nextTabValue;
        }
        system.debug('next called');
        if(currentTab == 'firstTab') {
            callComp1(chemoSummary.Id, 'taxane');
            currentTab = 'secondTab';
            system.debug('firstTab****');
        } else if(currentTab == 'secondTab') {
            callComp2(chemoSummary.Id, 'Anthracycline');
            currentTab = 'thirdTab';
            system.debug('secondTab***');
        } else if(currentTab == 'thirdTab') {
            callComp3(chemoSummary.Id, 'Investigational');
            currentTab = 'fourthTab';
            system.debug('thirdTab***');
        } else if(currentTab == 'fourthTab') {
            callComp4(chemoSummary.Id, 'Other');
            currentTab = 'fifthTab';
            system.debug('fourthTab***');
        } else if(currentTab == 'fifthTab') {
            currentTab = 'lastTab';
            system.debug('fifthTab***');
        }
        lstCompletePageWrapper = new List<CompletePageWrapper>();
        List<ChemoSummaryRegimenDetail__c> lstRegDetails = [Select c.Last_Date_of_Therapy__c, c.First_Date_of_Therapy__c, c.Chemo_Summary_Form__c, c.Chemo_Regimen__r.Name, c.Chemo_Regimen__c From ChemoSummaryRegimenDetail__c c where Chemo_Summary_Form__c = :chemoSummary.Id];
        for(ChemoSummaryRegimenDetail__c regDetail : lstRegDetails){
            system.debug('regDetail : '+regDetail);
            CompletePageWrapper completePageWrapper = new CompletePageWrapper();
           
            if(regDetail.Chemo_Regimen__r.Name != null) {
                completePageWrapper.regimenName = regDetail.Chemo_Regimen__r.Name + 'Regimen';
            } else {
                completePageWrapper.regimenName = 'Other Regimen';             
            }
           
            if(completePageWrapper.regimenName == 'Taxane Regimen') {
                completePageWrapper.displayOrder = 1;
            } else if(completePageWrapper.regimenName == 'Anthracycline Regimen') {
                completePageWrapper.displayOrder = 2;
            } else if(completePageWrapper.regimenName == 'Investigational Regimen') {
                completePageWrapper.displayOrder = 3;
            } else {
                completePageWrapper.displayOrder = 4;
            }
            completePageWrapper.chemoSummaryRegimen = regDetail;
            //if(regDetail.ChemoSummaryAgentDetails__r != null) {
                //completePageWrapper.lstChemoSummaryAgent = regDetail.ChemoSummaryAgentDetails__r;
                //if(completePageWrapper.lstChemoSummaryAgent != null && !completePageWrapper.lstChemoSummaryAgent.isEmpty()) {
                //  lstCompletePageWrapper.add(completePageWrapper);
                //}
            //}
           
        }
        system.debug('lstCompletePageWrapper : '+lstCompletePageWrapper);
       
        try {
            update chemoSummary;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
             // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/ChemoSummaryForm?id='+chemoSummaryId);
             Pagereference ref = new Pagereference('/'+chemoSummaryId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
        }
        if(nextTabName == 'saveAndClose') {
//====================== For Save & Close Functionality =================================        
         chemoSummary.First_Save_and_Close__c = true;
         try {
            update chemoSummary;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/ChemoSummaryForm?id='+chemoSummaryId);
            Pagereference ref = new Pagereference('/'+chemoSummaryId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
        }
//=======================================================================================         
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:trialPatientId];
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
   
    //public void previous() {
    public Pagereference previous() { //Added by Shruti (DE401)
       
        if(currentTab == 'lastTab') {
            currentTab = 'fifthTab';
        } else if(currentTab == 'fifthTab') {
            currentTab = 'fourthTab';
        } else if(currentTab == 'fourthTab') {
            currentTab = 'thirdTab';
        } else if(currentTab == 'thirdTab') {
            currentTab = 'secondTab';
        } else if(currentTab == 'secondTab') {
            currentTab = 'firstTab';
        }
       // Added by Shruti (DE401)
       try {
            update chemoSummary;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
            // Pagereference ref = new Pagereference('/apex/ChemoSummaryForm?id='+chemoSummaryId);
            Pagereference ref = new Pagereference('/'+chemoSummaryId);
            ref.setRedirect(true);
             return ref;             
        } 
        return null;
        // Added by Shruti (DE401)
    }
   
    public Pagereference cancelCRF() {
        List<TrialPatient__c> lstTP = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id = :trialPatientId];
        if(!lstTP.isEmpty()) {
            if(trialPatientId != null) {
                List<ChemoSummaryRegimenDetail__c> lstCSRD = [Select c.Id, c.Chemo_Summary_Form__c From ChemoSummaryRegimenDetail__c c where Chemo_Summary_Form__c = :chemoSummary.Id];
                //Set<Id> agentDetailIds = new Set<Id>();
                //for(ChemoSummaryRegimenDetail__c csrd : lstCSRD) {
                //  if(csrd.ChemoSummaryAgentDetails__r != null) {
                //      for(ChemoSummaryAgentDetail__c agentDetail : csrd.ChemoSummaryAgentDetails__r) {
                //          agentDetailIds.add(agentDetail.Id);
                //      }
                //  }
                //}
                //delete [select Id from ChemoSummaryAgentDetail__c where Id IN :agentDetailIds];
               /* if(chemoSummary.OriginalCRF__c == null) {
                    delete lstCSRD;
                    delete chemoSummary;
                }*/
                
                 if( chemoSummaryId != null) {
                    delete lstCSRD;
                    // Added by Shruti (DE401)
       try {
            delete new Chemo_Summary_Form__c(id=chemoSummaryId); 
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
             // Pagereference ref = new Pagereference('/apex/ChemoSummaryForm?id='+chemoSummaryId);
             Pagereference ref = new Pagereference('/'+chemoSummaryId);
            ref.setRedirect(true);
             return ref;             
        }        
        // Added by Shruti (DE401)                       
                }  
                return new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c+'&TrialId='+lstTP[0].Trial_Id__c);
               // return new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c);
            } else {
                return null;
            }
        } else {
            return null;
        }
    }
   
    public Pagereference signAndSubmit() {
       
        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
        //completeCrf.customAdhoc(chemoSummary.Id+'', 'submit', 'Site');
        
       
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('03415','',chemoSummary.Id+'', 'Site');
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
        //String clonedCRFId = CloneBuilder.cloneMe(chemoSummary.Id, '0', '');
        //Pagereference ref = new Pagereference('/apex/ChemoSummaryForm?trialPat='+chemoSummary.TrialPatient__c+'&formId='+clonedCRFId);
        //ref.setRedirect(true);
        //return ref;
        chemoSummary.Status__c = 'Not Completed';
        try {
            update chemoSummary;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            return null;
        }
        return null;
    }
   
    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstCloneChemoSum[0].Status__c = 'Not Completed';
            try {
                update lstCloneChemoSum[0];
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/ChemoSummaryForm?id='+chemoSummaryId);
             Pagereference ref = new Pagereference('/'+chemoSummaryId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
            }
        }
        openInEditMode = false;
        currentTab = 'firstTab';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/ChemoSummaryForm?trialPat='+trialPatientId+'&formId='+clonedCRFId);
        ref.setRedirect(true);
        return ref;
    }
   
   
    public class CompletePageWrapper {
        public String regimenName {get;set;}
        public integer displayOrder {get;set;}
        public ChemoSummaryRegimenDetail__c chemoSummaryRegimen {get;set;}
        //public List<ChemoSummaryAgentDetail__c> lstChemoSummaryAgent {get;set;}
       
       
    }
}