public with sharing class NolongLosttoFollowupController {
    
    public String nextTabName{get;set;}
    public String userName {get;set;}
    public String password {get;set;}
    public String errorMsg {get;set;}
    public String currentTab {get;set;}//https:cs14.salesforce.com
    public Boolean isComplete{get; set;}
    
    public Id NLLTFupFormId {get;set;}
    public No_Longer_lost_to_Followup__c NLLFF {get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    private List<No_Longer_lost_to_Followup__c> lstCloneNLLFF{get;set;}
    
    public List<SelectOption> newInfrmOptions {get;set;}
    public List<SelectOption> survivalOptions {get;set;}
    
    public String trialPatientId = null;
    public String trialPatient {get;set;}
    public boolean openInEditMode {get;set;}
    public boolean isShowEditButton{get;set;}
    private Id clonedCRFId{get;set;}
    public String profileName{get;set;}
    public Boolean isDelete{get;set;}
    public No_Longer_lost_to_Followup__c pathObj{get;set;}
        
    public NolongLosttoFollowupController(Apexpages.StandardController std){
        System.debug('NolongLosttoFollowup-------'+std.getId());
        NLLTFupFormId = std.getId();
        No_Longer_lost_to_Followup__c NolongLosttoFollowupForm;
        if(NLLTFupFormId != null)NolongLosttoFollowupForm = [Select n.TrialPatient__c,n.Root_CRF_Id__c From No_Longer_lost_to_Followup__c n where id =: NLLTFupFormId];
        
        
        String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        }
        isShowEditButton = false;
        openInEditMode = false;
        isDelete = false;
        
        if(NolongLosttoFollowupForm != null){
            NLLTFupFormId = NolongLosttoFollowupForm.Id;
            trialPatientId = NolongLosttoFollowupForm.TrialPatient__c;
        }else{
            NLLTFupFormId = Apexpages.currentPage().getParameters().get('NLLTFupFormId'); 
            trialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
        }
        if(trialPatientId != null) {
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPatientId];
            if(!lstTrialPatient.IsEmpty()) {
                trialPatientObj = lstTrialPatient[0];
            }
        }
        currentTab = 'noLongLostFFTab';
        isComplete = true;
         
        if ( NLLFF == null) NLLFF = new No_Longer_lost_to_Followup__c();
        
        if(NLLTFupFormId == null && trialPatientId == null) {
            
            NLLTFupFormId = std.getId();
            List<No_Longer_lost_to_Followup__c> lstFollowupForm = [Select n.Root_CRF_Id__c, n.TrialPatient__c, OriginalCRF__c, n.last_alive_death_date__c, n.Survial_Status__c,  n.Decision__c, n.New_Information__c, n.Name, n.Id , Status__c, CompletedDate__c, CRF__c
                From No_Longer_lost_to_Followup__c n
                where Id =: NLLTFupFormId 
                        order by Effective_Time__c DESC ];      
                        
            if(!lstFollowupForm.isEmpty()) {
                trialPatientId = lstFollowupForm[0].TrialPatient__c;
            }
            
        }
        
        if (  NLLTFupFormId != null ){
            
            NLLFF = [Select n.Root_CRF_Id__c, n.TrialPatient__c, n.last_alive_death_date__c, OriginalCRF__c, n.Survial_Status__c,  n.Decision__c, n.New_Information__c, n.Name, n.Id , Status__c, CompletedDate__c, CRF__c
                   From No_Longer_lost_to_Followup__c n
                    where Id =: NLLTFupFormId ];    
            lstCloneNLLFF = [select Root_CRF_Id__c, Id, Status__c from No_Longer_lost_to_Followup__c where OriginalCRF__c =:NLLTFupFormId and Status__c = 'Cloned'];
            if(!lstCloneNLLFF.isEmpty()) {
                isShowEditButton = true;
                clonedCRFId = lstCloneNLLFF[0].Id;
            }
        }
        
        newInfrmOptions = new List<Selectoption>();
        newInfrmOptions.add(new Selectoption('Survival status only. Patient is no longer lost to survival follow-up','Survival status only. Patient is no longer lost to survival follow-up.'));
        newInfrmOptions.add(new Selectoption('Clinical and survival status. This patient is no longer lost; both survival and clinical follow-up are now available','Clinical and survival status. This patient is no longer lost; both survival and clinical follow-up are now available'));
        
        survivalOptions = new List<Selectoption>();
        survivalOptions.add(new Selectoption('Alive','Alive'));
        survivalOptions.add(new Selectoption('Dead','Dead'));
        
        isComplete = CRFUtilities.isReadOnlyUsr();
        if(NLLFF != null){
            //String crfId = NLLFF.CRF__c;
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = NLLFF.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    currentTab = 'CompleteTab';
                    isComplete = false; 
                } 
            //}
        }
        isDelete();
    }
    public void isDelete(){
        
        System.debug('======NLLTFupFormId=======' +NLLTFupFormId );
        if(NLLTFupFormId != null){
            pathObj = [select Root_CRF_Id__c, Id, Status__c from No_Longer_lost_to_Followup__c where id =:NLLTFupFormId ];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======NLLTFupFormId=======' +NLLTFupFormId);
    }
    public pagereference redirect(){
            pagereference redirect = new pagereference('/apex/NolongerLosttoFollowupFormPdf?id='+NLLTFupFormId);
            redirect.setRedirect(true);
            return redirect;
     }    
    
    public Pagereference next() {
        String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
        if(nextTabValue != null){
            nextTabName = nextTabValue;
        }
        if( NLLFF.last_alive_death_date__c > system.today() || NLLFF.last_alive_death_date__c == null){        
                NLLFF.last_alive_death_date__c.addError('End Date must be same as or earlier than today'); 
                return null;
        }
        try {
            update NLLFF;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
             // Added by Shruti (DE401)
             // Pagereference ref = new Pagereference('/apex/NolongerLosttoFollowupForm?id='+NLLTFupFormId);
             Pagereference ref = new Pagereference('/'+NLLTFupFormId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
        }
           
         
        /*if(currentTab == 'noLongLostFFTab') {
            currentTab = 'attachmentTab';
        } else if(currentTab == 'attachmentTab') {
            currentTab = 'decisionTab';
        } else if(currentTab == 'decisionTab') {
            currentTab = 'completeTab';
        }*/
        if(nextTabName == 'saveAndClose') {
//=========================== For Save & Close FUncitonality =============================               
            NLLFF.First_Save_and_Close__c = true;
            try {
                update NLLFF;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/NolongerLosttoFollowupForm?id='+NLLTFupFormId);
             Pagereference ref = new Pagereference('/'+NLLTFupFormId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
            } 
//========================================================================================            
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
    
        
        if(currentTab == 'completeTab') {
            //currentTab = 'decisionTab';
        //} else if(currentTab == 'decisionTab') {
            currentTab = 'attachmentTab';
        } else if(currentTab == 'attachmentTab') {
            currentTab = 'noLongLostFFTab';
        }
       // Added by Shruti (DE401)
       try {
            update NLLFF;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
            // Pagereference ref = new Pagereference('/apex/NolongerLosttoFollowupForm?id='+NLLTFupFormId);
             Pagereference ref = new Pagereference('/'+NLLTFupFormId);
            ref.setRedirect(true);
             return ref;             
        }
            return null;  
        // Added by Shruti (DE401)
    }
    
        public Pagereference saveMainCRF() {
            
        if(NLLTFupFormId == null) {
            NLLFF.TrialPatient__c = trialPatientId;
            try {
                insert NLLFF;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                return null;
            }
            
            NLLTFupFormId = NLLFF.Id;
            //Pagereference ref = new Pagereference('/apex/NolongerLosttoFollowupForm?NLLTFupFormId='+NLLTFupFormId+'&trialPat='+trialPatientId);
            Pagereference ref = new Pagereference('/'+NLLTFupFormId);
            ref.setRedirect(true);
            return ref;
        } 
        return null;
    }
    
    public PageReference cancelCRF() {
        //String TrialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
            //System.debug('==TrialPatientId=='+TrialPatientId );
            system.debug('trialPatientObj----'+trialPatientObj);
            //List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id = :trialPatientObj.id];
           /* if(NLLFF.OriginalCRF__c == null) {
                System.debug('==TrialPatientId=='+TrialPatientId );
                delete NLLFF;
            }*/
             if( NLLTFupFormId != null) {
                    // Added by Shruti (DE401)
       try {
            delete new No_Longer_lost_to_Followup__c(id=NLLTFupFormId );
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
             // Pagereference ref = new Pagereference('/apex/NolongerLosttoFollowupForm?id='+NLLTFupFormId);
             Pagereference ref = new Pagereference('/'+NLLTFupFormId);
            ref.setRedirect(true);
             return ref;             
        }             
        // Added by Shruti (DE401)
                        
                }  
            System.debug('-----Deleted---->');
            Pagereference pr = new Pagereference('/');
           if ( trialPatList.size()>0){
              System.debug('==TrialPatientId=='+TrialPatientId );
             pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
             //pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
            return pr;
            } 
             System.debug('==TrialPatientId=='+TrialPatientId );
            //pr = new Pagereference('/apex/TranscendPage?id='+TrialPatientId+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
            pr = new Pagereference('/apex/TranscendPage?id='+trialPatientObj.id+'&sfdc.override=1');
            return pr; 
        
    }
    
    
    public Pagereference signAndSubmit() {
        
        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
        //completeCrf.customAdhoc(NLLFF.Id+'', 'submit', 'Site'); 
        
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00066','',NLLFF.Id+'', 'Site');
        system.debug('errorMsg :  '+signSubmit.errorMsg);
        errorMsg = signSubmit.errorMsg;
        isDelete();
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
        //String clonedCRFId = CloneBuilder.cloneMe(NLLFF.Id, '0', '');
        NLLFF.Status__c = 'Not Completed';
        try {
            update NLLFF;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            return null;
        }
        return null;
    }
    
    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstCloneNLLFF[0].Status__c = 'Not Completed';
            try {
                update lstCloneNLLFF[0];
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/NolongerLosttoFollowupForm?id='+NLLTFupFormId);
             Pagereference ref = new Pagereference('/'+NLLTFupFormId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
            }
        }
        openInEditMode = false;
        currentTab = 'noLongLostFFTab';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/NolongerLosttoFollowupForm?NLLTFupFormId='+clonedCRFId+'&trialPat='+trialPatientId);
        ref.setRedirect(true);
        return ref;
    }

}