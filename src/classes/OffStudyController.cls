public with sharing class OffStudyController {

    public String currentTab {get;set;}
    public String password {get;set;}
    public String errorMsg {get;set;}
    private Id offStudyIdValue{get;set;}
    private String trialPatValue{get;set;}
    public Boolean isComplete {get;set;}
    public boolean openInEditMode {get;set;}
    public boolean isShowEditButton{get;set;}
    private Id clonedCRFId{get;set;}
    public String nextTabName{get;set;}
    public Off_Study_Detail__c offStudyObj {get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    private List<Off_Study_Detail__c> lstCloneOff{get;set;}
    public String profileName{get;set;}
    public Boolean isDelete{get;set;}
    public Off_Study_Detail__c pathObj{get;set;}
    
    
    
    public OffStudyController(ApexPages.StandardController controller) {
        System.debug('OffStudy-------'+controller.getId());
        offStudyIdValue = controller.getId();
        Off_Study_Detail__c OffStdObj;
        if(offStudyIdValue != null)OffStdObj = [Select o.TrialPatient__c From Off_Study_Detail__c o where id =: offStudyIdValue];
        
        String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        } 
        openInEditMode = false;
        isDelete = false;
        isShowEditButton = false;
        
        if(OffStdObj != null){
            trialPatValue = OffStdObj.TrialPatient__c;
            offStudyIdValue = OffStdObj.id;
        }else{
            trialPatValue = Apexpages.currentPage().getParameters().get('trialPat');
            offStudyIdValue = Apexpages.currentPage().getParameters().get('offStudyId');
        }
        
        if(trialPatValue != null) {
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPatValue];
            if(!lstTrialPatient.IsEmpty()) {
                trialPatientObj = lstTrialPatient[0];
            }
        }
        isComplete = true;
        if(offStudyIdValue != null) {
            List<Off_Study_Detail__c> offStudyList = [Select o.Root_CRF_Id__c,o.OriginalCRF__c, o.Why_patient_didnt_continue_treatment_arm__c, o.TrialPatient__c, o.Treatment_arm_other_reason__c, o.SystemModstamp, o.Status__c, o.Patient_withdrew_for_specimens__c, o.Patient_did_nt_want_to_complete_core_bio__c, o.Patient_did_nt_continue_on_treatment_arm__c, o.Patient_did_not_want_to_complete_MRI__c, o.Patient_did_not_have_surgery_reason__c, o.Patient_did_not_have_surgery__c, o.Patient_completed_study_per_protocol__c, o.Patient_Died__c, o.OwnerId, o.Name, o.LastModifiedDate, o.LastModifiedById, o.IsDeleted, o.Id, o.Did_patient_withdraw_for_survival__c, o.Date_patient_went_off_study__c, o.CreatedDate, o.CreatedById, o.CompletedDate__c, o.CRF__c From Off_Study_Detail__c o where Id =:offStudyIdValue ];
            if(!offStudyList.isEmpty()) {
                offStudyObj = offStudyList[0];
                lstCloneOff = [select Id, Status__c,Root_CRF_Id__c from Off_Study_Detail__c where OriginalCRF__c =:offStudyIdValue and Status__c = 'Cloned'];
                if(!lstCloneOff.isEmpty()) {
                    isShowEditButton = true;
                    clonedCRFId = lstCloneOff[0].Id;
                }
            }
        }
        //currentTab = 'offStudyTab';
        isComplete = CRFUtilities.isReadOnlyUsr(); 
        if(offStudyObj != null){
            //String crfId = offStudyObj.CRF__c;
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = offStudyObj.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    currentTab = 'CompleteTab';
                    isComplete = false; 
                } else {
                    currentTab = 'offStudyTab';
                }
            //}
        }
        isDelete();
    }
     public void isDelete(){
        
        System.debug('======offStudyIdValue =======' +offStudyIdValue);
        if(offStudyIdValue != null){
            pathObj = [select Id, Status__c,Root_CRF_Id__c from Off_Study_Detail__c where id =:offStudyIdValue];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======offStudyIdValue =======' +offStudyIdValue );
    }
    public pagereference redirect(){
         pagereference redirect = new pagereference('/apex/OffStudyPdf?id='+offStudyIdValue);
         //pagereference redirect = new pagereference('/apex/OffStudyPdf?offStudyId='+offStudyIdValue+'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
       
        redirect.setRedirect(true);
        return redirect;
    }
    
//===========================next used for go to next tab on page===========================================
    public Pagereference next() {
        String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
        system.debug('__nextTabValue__'+nextTabValue);
        
        if(nextTabValue != null) {
            nextTabName = nextTabValue;
        }
        
        if(currentTab == 'offStudyTab') {
            if(offStudyObj.Date_patient_went_off_study__c > system.today()) {
                offStudyObj.Date_patient_went_off_study__c.addError('Future date is not allowed.');
                return null;
            }
            try {
                update offStudyObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                //Added by Shruti (DE401)
               // Pagereference ref = new Pagereference('/apex/OffStudy?id='+offStudyIdValue);
                Pagereference ref = new Pagereference('/'+offStudyIdValue);
                ref.setRedirect(true);
                return ref;
             //Added by Shruti (DE401)
            } 
        }
        
        if(nextTabName == 'saveAndClose') {
 //==========================For Save & Close =========================       
        offStudyObj.First_Save_and_Close__c = true;
           try {
               update offStudyObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                //Added by Shruti (DE401)
               // Pagereference ref = new Pagereference('/apex/OffStudy?id='+offStudyIdValue);
                Pagereference ref = new Pagereference('/'+offStudyIdValue);
                ref.setRedirect(true);
                return ref;
             //Added by Shruti (DE401)
            } 
//=====================================================================           
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:trialPatValue];
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
    
//===========================previous used for go to previous tab on page===========================================
    //public void previous() {
    public Pagereference previous() { //Added by Shruti (DE401)
        system.debug('__currentTab__'+currentTab);
        String prevTabValue = Apexpages.currentPage().getParameters().get('prevTab');
        system.debug('__prevTabValue__'+prevTabValue);
        currentTab = prevTabValue;
          //Added by Shruti (DE401)
          try {
                update offStudyObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                
               // Pagereference ref = new Pagereference('/apex/OffStudy?id='+offStudyIdValue);
                Pagereference ref = new Pagereference('/'+offStudyIdValue);
                ref.setRedirect(true);
                return ref;             
            }
             return null; 
            //Added by Shruti (DE401)  
    }

//============================insert one blank record in AE CRF=====================================================    
    public Pagereference saveCrf() {
        if(offStudyIdValue == null) {
            //offStudyIdValue = Apexpages.currentPage().getParameters().get('id');
            if(offStudyIdValue != null) {
                //Pagereference pr = new Pagereference('/apex/OffStudy?trialPat='+trialPatValue+'&offStudyId='+offStudyIdValue);
                //pr.getParameters().put('nooverride', '1');
                Pagereference pr = new Pagereference('/'+offStudyIdValue);
                pr.setRedirect(true);
                return pr;
            } else {
                offStudyObj = new Off_Study_Detail__c();
                offStudyObj.TrialPatient__c = trialPatValue;
                try {
                    insert offStudyObj;
                }catch (Exception e) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    Apexpages.addMessage(msg);
                    return null;
                }
                //Pagereference pr = new Pagereference('/apex/OffStudy?trialPat='+trialPatValue+'&offStudyId='+offStudyObj.Id);
                //pr.getParameters().put('nooverride', '1');
                Pagereference pr = new Pagereference('/'+offStudyObj.Id);
                pr.setRedirect(true);
                return pr;
            }
        } else {
            return null;
        }
    }

//===========================customCancel used for delete record in Off Study CRF===========================================    
    public Pagereference customCancel() {
        String TrialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
          //trialPatValue  = Apexpages.currentPage().getParameters().get('trialPatValue ');
        system.debug('__TrialPatientId__'+TrialPatientId);
        List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId ];
       /* if(offStudyObj.OriginalCRF__c == null){
            delete offStudyObj;
        }*/
         if( offStudyIdValue  != null) {
                    //Added by Shruti (DE401)
          try {
                delete new Off_Study_Detail__c(id=offStudyIdValue );
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                
                //Pagereference ref = new Pagereference('/apex/OffStudy?id='+offStudyIdValue);
                Pagereference ref = new Pagereference('/'+offStudyIdValue);
                ref.setRedirect(true);
                return ref;             
            }              
            //Added by Shruti (DE401)                        
                }  
        System.debug('-----Deleted---->');
        if(!trialPatList.isEmpty()){
            Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
            //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
            return pr;
        }
        return null;
    }
    
//===========================Sign And Submit for Site User in AE CRF===========================================         
    public Pagereference signAndSubmit() {
        
        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
        //completeCrf.customAdhoc(offStudyObj.Id+'', 'submit', 'Site'); 
        
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00063','',offStudyObj.Id+'', 'Site');
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
        //String clonedCRFId = CloneBuilder.cloneMe(offStudyObj.Id, '0', '');
        offStudyObj.Status__c = 'Not Completed';
        try {
            update offStudyObj;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            return null;
        } 
        return null;
    }
    
    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstCloneOff[0].Status__c = 'Not Completed';
            try {
                update lstCloneOff[0];
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                //Added by Shruti (DE401)
               // Pagereference ref = new Pagereference('/apex/OffStudy?id='+offStudyIdValue);
                Pagereference ref = new Pagereference('/'+offStudyIdValue);
                ref.setRedirect(true);
                return ref;
               //Added by Shruti (DE401)
            } 
        }
        openInEditMode = false;
        currentTab = 'offStudyTab';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/OffStudy?trialPat='+trialPatValue+'&offStudyId='+clonedCRFId);
        ref.setRedirect(true);
        return ref;
    }
}