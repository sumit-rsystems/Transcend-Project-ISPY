public with sharing class LosttoFollowupController {

    public String nextTabName{get;set;}
    public String userName {get;set;}
    public String password {get;set;}
    public String errorMsg {get;set;}
    public String currentTab {get;set;}
    public Boolean isComplete{get; set;}
    
    public Id LTFupFormId {get;set;}
    public Lost_to_Follow_Up__c LFF {get;set;}
    
    public integer irrSiteSNO = 0;
    public integer therapySNO = 0;
     
    public List<SelectOption> sendcertifyresponseOptions {get;set;}
    
    public List<SelectOption> socialsecdeathindexOptions {get;set;}
    public List<SelectOption> sendcertifyregltrOptions {get;set;}
    
    public String trialPatientId = null;
    public String trialPatient {get;set;}
    public boolean openInEditMode {get;set;}
    public boolean isShowEditButton{get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    private List<Lost_to_Follow_Up__c> lstCloneLFF{get;set;}
    private Id clonedCRFId{get;set;}
    public String profileName{get;set;}
    public Boolean isDelete{get;set;}
    public Lost_to_Follow_Up__c pathObj{get;set;}

    public LosttoFollowupController(Apexpages.StandardController std){
        System.debug('LosttoFollowup-------'+std.getId());
        LTFupFormId = std.getId();
        Lost_to_Follow_Up__c LosttoFollowupObj;
        if(LTFupFormId != null)LosttoFollowupObj = [Select l.Root_CRF_Id__c,l.TrialPatient__c From Lost_to_Follow_Up__c l where id =: LTFupFormId];
        
        String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        } 
        
        openInEditMode = false;
        isShowEditButton = false;
        isDelete = false;
        
        if(LosttoFollowupObj != null){
            LTFupFormId = LosttoFollowupObj.id;
            trialPatientId = LosttoFollowupObj.TrialPatient__c;
        }else{
            LTFupFormId = Apexpages.currentPage().getParameters().get('ltfupformId'); 
            trialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
        }
        
        system.debug('__TrialPatientId__'+TrialPatientId);
        if(trialPatientId != null) {
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPatientId];
            if(!lstTrialPatient.IsEmpty()) {
                trialPatientObj = lstTrialPatient[0];
            }
        }
        currentTab = 'criteriaTab';
        isComplete = true;
        
        if ( LFF == null) LFF = new Lost_to_Follow_Up__c();
        
        if(LTFupFormId == null && trialPatientId == null) {
            
            LTFupFormId = std.getId();
            List<Lost_to_Follow_Up__c> lstFollowupForm = [Select l.Root_CRF_Id__c,l.TrialPatient__c, OriginalCRF__c, l.Social_Sec_Death_Index_Research__c, l.Social_Sec_Death_Index_Research_Date__c, l.Send_certified_registered_ltr_to_known__c, l.Send_certified_registered_ltr_Responce__c, l.Send_certified_registered_ltr_DATE__c, l.Name,l.Decision__c, l.Last_contact_before_2_yrs__c, l.Id, l.Date_of_last_contact__c, Status__c, CompletedDate__c, CRF__c 
                From Lost_to_Follow_Up__c l
                where Id =: LTFupFormId
                        order by Effective_Time__c DESC ];      
                        
            if(!lstFollowupForm.isEmpty()) {
                trialPatientId = lstFollowupForm[0].TrialPatient__c;
            }       
        }
        if (  LTFupFormId != null ){
            
            LFF = [Select l.Root_CRF_Id__c,l.TrialPatient__c, OriginalCRF__c, l.Social_Sec_Death_Index_Research__c, l.Social_Sec_Death_Index_Research_Date__c, l.Send_certified_registered_ltr_to_known__c, l.Send_certified_registered_ltr_Responce__c, l.Send_certified_registered_ltr_DATE__c, l.Name,l.Decision__c, l.Last_contact_before_2_yrs__c, l.Id, l.Date_of_last_contact__c, Status__c, CompletedDate__c, CRF__c 
                From Lost_to_Follow_Up__c l
                where Id =: LTFupFormId ];  
            lstCloneLFF = [select Id,Root_CRF_Id__c, Status__c from Lost_to_Follow_Up__c where OriginalCRF__c =:LTFupFormId and Status__c = 'Cloned' ];
            if(!lstCloneLFF.isEmpty()) {
                isShowEditButton = true;
                clonedCRFId = lstCloneLFF[0].Id;
            }           
        }
        
        sendcertifyresponseOptions = new List<Selectoption>();
        sendcertifyresponseOptions.add(new Selectoption('Letter returned unclaimed or marked addressee unknown','Letter returned unclaimed or marked addressee unknown'));
        sendcertifyresponseOptions.add(new Selectoption('No response 1 month after confirmed receipt of letter','No response 1 month after confirmed receipt of letter'));
    
        socialsecdeathindexOptions = new List<Selectoption>();
        socialsecdeathindexOptions.add(new Selectoption('true','Researched Social Security Death Index and found no information for this patient'));
        socialsecdeathindexOptions.add(new Selectoption('false',''));
    
        sendcertifyregltrOptions = new List<Selectoption>();
        sendcertifyregltrOptions.add(new Selectoption('true','Send certified or registered letter to last known address'));
        sendcertifyregltrOptions.add(new Selectoption('false',''));
        
        isComplete = CRFUtilities.isReadOnlyUsr();
        if(LFF != null){
            //String crfId = LFF.CRF__c;
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = LFF.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    currentTab = 'completeTab';
                    isComplete = false; 
                }
            //}
        }
        isDelete();
    }
    public void isDelete(){
        
        System.debug('======LTFupFormId =======' +LTFupFormId );
        if(LTFupFormId != null){
            pathObj = [select Id, Status__c from Lost_to_Follow_Up__c where id =:LTFupFormId ];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======LTFupFormId=======' +LTFupFormId );
    }
    public pagereference redirect(){
            pagereference redirect = new pagereference('/apex/LosttoFollowupFormPdf?id='+LTFupFormId);
           // pagereference redirect = new pagereference('/apex/LosttoFollowupFormPdf?ltfupformId='+LTFupFormId+'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
            redirect.setRedirect(true);
            return redirect;
     }
    
//===========================next used for go to next tab on page===========================================    
    public Pagereference next() {
        String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
        if(nextTabValue != null){
            nextTabName = nextTabValue;
        }
        
            if  ( LFF.Date_of_last_contact__c > system.today()){
                LFF.Date_of_last_contact__c.addError('End Date must be same as or earlier than today'); 
                return null;
            }
            if  ( LFF.Social_Sec_Death_Index_Research_Date__c > system.today()){
                LFF.Social_Sec_Death_Index_Research_Date__c.addError('End Date must be same as or earlier than today'); 
                return null;
            }
            if  ( LFF.Send_certified_registered_ltr_DATE__c > system.today()){
                LFF.Send_certified_registered_ltr_DATE__c.addError('End Date must be same as or earlier than today'); 
                return null;
            }
             //Added by Shruti (DE401)
             try {
             update LFF;
             }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            // Pagereference ref = new Pagereference('/apex/LosttoFollowupForm?id='+LTFupFormId);
             Pagereference ref = new Pagereference('/'+LTFupFormId);
            ref.setRedirect(true);
             return ref;
        }
        //Added by Shruti (DE401)
        
        /*if(currentTab == 'criteriaTab') {
            currentTab = 'attachmentTab';
        } else if(currentTab == 'attachmentTab') {
            currentTab = 'decisionTab';
        } else if(currentTab == 'decisionTab') {
            currentTab = 'completeTab';
        }*/
    
        if(nextTabName == 'saveAndClose') {
//==========================For Save & Close Functionality ====================            
            LFF.First_Save_and_Close__c = true;
            //Added by Shruti (DE401)
             try {
             update LFF;
             }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
             // Pagereference ref = new Pagereference('/apex/LosttoFollowupForm?id='+LTFupFormId);
             Pagereference ref = new Pagereference('/'+LTFupFormId);
            ref.setRedirect(true);
             return ref;
        }
        //Added by Shruti (DE401)            
//=============================================================================            
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
//===========================previous used for go to previous tab on page===========================================    
    //public void previous() {
    public Pagereference previous() { //Added by Shruti (DE401)
        
        if(currentTab == 'completeTab') {
            //currentTab = 'decisionTab';
        //} else if(currentTab == 'decisionTab') {
            currentTab = 'attachmentTab';
        } else if(currentTab == 'attachmentTab') {
            currentTab = 'criteriaTab';
        }
       //Added by Shruti (DE401)
             try {
             update LFF;
             }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            // Pagereference ref = new Pagereference('/apex/LosttoFollowupForm?id='+LTFupFormId);
             Pagereference ref = new Pagereference('/'+LTFupFormId);
            ref.setRedirect(true);
             return ref;
        }
        return null;
        //Added by Shruti (DE401)  
    }
    
//============================insert one blank record in AE CRF=====================================================    
    public Pagereference saveMainCRF() {
                
    if(LTFupFormId == null) {
        LFF.TrialPatient__c = trialPatientId;
            insert LFF;
            LTFupFormId = LFF.Id;
            //Pagereference ref = new Pagereference('/apex/LosttoFollowupForm?ltfupformId='+LTFupFormId+'&trialPat='+trialPatientId);
            Pagereference ref = new Pagereference('/'+LTFupFormId);
            //ref.getParameters().put('nooverride', '1');
            ref.setRedirect(true);
            return ref;
        }   
    else{
        //update LFF;
        return null;
        }
    }
    
//===========================cancelCRF used for delete record in Off Study CRF===========================================   

    public PageReference cancelCRF() {
            //String TrialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
            system.debug('__TrialPatientId__'+TrialPatientId);
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
           /* if(LFF.OriginalCRF__c == null)
                delete LFF;*/
            if( LTFupFormId  != null) {
                    //Added by Shruti (DE401)
             try {
             delete new Lost_to_Follow_Up__c(id=LTFupFormId );
             }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            // Pagereference ref = new Pagereference('/apex/LosttoFollowupForm?id='+LTFupFormId);
             Pagereference ref = new Pagereference('/'+LTFupFormId);
            ref.setRedirect(true);
             return ref;
        }        
        //Added by Shruti (DE401)                        
                }  
                    
            System.debug('-----Deleted---->');
            Pagereference pr = new Pagereference('/');
            if ( trialPatList.size()>0){
             pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
             //pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
            return pr;
            }
             
            //pr = new Pagereference('/apex/TranscendPage?id='+TrialPatientId+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
            pr = new Pagereference('/apex/TranscendPage?id='+TrialPatientId+'&sfdc.override=1');
            return pr;  
    }
    
//===========================Sign And Submit for Site User in AE CRF=========================================== 
    public Pagereference signAndSubmit() {
    
        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
        //completeCrf.customAdhoc(LFF.Id+'', 'submit', 'Site'); 
        
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00065','',LFF.Id+'', 'Site');
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
        //String clonedCRFId = CloneBuilder.cloneMe(LFF.Id, '0', '');
        LFF.Status__c = 'Not Completed';
        update LFF;
        return null;
    }
    
    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstCloneLFF[0].Status__c = 'Not Completed';
            //Added by Shruti (DE401)
             try {
             update lstCloneLFF[0];
             }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
             // Pagereference ref = new Pagereference('/apex/LosttoFollowupForm?id='+LTFupFormId);
             Pagereference ref = new Pagereference('/'+LTFupFormId);
            ref.setRedirect(true);
             return ref;
           }
        //Added by Shruti (DE401)            
        }
        openInEditMode = false;
        currentTab = 'criteriaTab';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/LosttoFollowupForm?ltfupformId='+clonedCRFId+'&trialPat='+trialPatientId);
        ref.setRedirect(true);
        return ref;
    }
}