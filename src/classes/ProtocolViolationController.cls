public with sharing class ProtocolViolationController {
	
    public String userName {get;set;}
    public String password {get;set;}
    public String errorMsg {get;set;}
    public String currentTab {get;set;}
    public Boolean isActionTaken {get;set;}
    public ProtocolViolationDetail__c protocolViolation {get;set;}
    public String trialPatientId = null;
    public String trialPatient {get;set;}
    public Id protocolViolationId {get;set;}
    public Boolean isComplete {get;set;}
    public Boolean isDelete{get;set;}
    public boolean openInEditMode {get;set;}
    public Boolean isShowEditButton{get;set;}
    private Id clonedCRFId{get;set;}
    public String nextTabName{get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    private List<ProtocolViolationDetail__c> lstCloneProtocol{get;set;}
    public String profileName{get;set;}
    public ProtocolViolationDetail__c pathObj{get;set;}
    
    
    public ProtocolViolationController(Apexpages.StandardController std) {
        String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        } 
        openInEditMode = false;
        isShowEditButton = false;
        trialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
        protocolViolationId = Apexpages.currentPage().getParameters().get('formId');
        isActionTaken = false;
        isComplete = true;
        isDelete = false;
        if(protocolViolationId == null) {
            protocolViolationId = std.getId();
        }
        if(protocolViolationId != null) {
            List<ProtocolViolationDetail__c> lstPv = [Select p.Root_CRF_Id__c,p.Status__c, p.Visit_non_complicance__c,p.CRFId__c, p.TrialPatient__c, p.Screening_procedure_required__c, p.Screening_and_on_study_test_lab_done__c, p.Phase__c, p.Patient_withdrawn__c, p.Patient_became_pregnant_prior_to_surgery__c, p.Patient__c, p.Patient_Remains_on_Study__c, p.Other_Violation_Checkbox__c, p.Other_Type_of_Violation__c, p.Other_Action__c, p.Other_Action_Checkbox__c, p.On_study_procedure_required_by_protocol__c, p.Narrative_description__c, p.Medication_non_complicance__c, p.Local_IRB_Notified__c, p.Incorrect_therapy_given_to_patient__c, p.Enrollment_of_ineligeligibleible_patient__c, p.Eligibility_criteria_exception__c, p.DateOfProtocolViolation__c, p.CompletedDate__c From ProtocolViolationDetail__c p where Id = :protocolViolationId];
            if(!lstPv.isEmpty()) {
                protocolViolation = lstPv[0];
                trialPatientId = lstPv[0].TrialPatient__c;
            }
            lstCloneProtocol = [select Id, Status__c,Root_CRF_Id__c from ProtocolViolationDetail__c where OriginalCRF__c =:protocolViolationId and Status__c = 'Cloned'];
            if(!lstCloneProtocol.isEmpty()) {
                isShowEditButton = true;
                clonedCRFId = lstCloneProtocol[0].Id;
            }
            //if(!lstProtoVio.isEmpty()) {
            //  protocolViolation = lstProtoVio[0];
            //}
        } else {
            protocolViolation = new ProtocolViolationDetail__c();
            protocolViolation.TrialPatient__c = trialPatientId;
        }
        
        if(trialPatientId != null) {
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPatientId];
            if(!lstTrialPatient.IsEmpty()) {
                trialPatientObj = lstTrialPatient[0];
            }
        } 
        //currentTab = 'firstTab';
        isComplete = CRFUtilities.isReadOnlyUsr(); 
        if(protocolViolation != null){
            //String protocolViolationId = protocolViolation.CRFId__c;
            //if(protocolViolationId != null && protocolViolationId != ''){
                //String status = CRFUtilities.CRFStatus(protocolViolationId);
                String status = protocolViolation.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    currentTab = 'ThirdTab';
                    isComplete = false; 
                } else {
                    currentTab = 'firstTab';
                }
            //}
        }
        isDelete();
    }
    
      public pagereference redirect(){
    pagereference redirect = new pagereference('/apex/ProtocolViolationFormPdf?formId='+protocolViolationId+'&trialPat='+trialPatientId );
   // pagereference redirect = new pagereference('/apex/ProtocolViolationFormPdf?formId='+protocolViolationId+'&trialPat='+protocolViolationId);
    redirect.setRedirect(true);
    return redirect; 
}

    
    public void isDelete(){
        
        System.debug('======protocolViolationId =======' +protocolViolationId);
        if(protocolViolationId != null){
            pathObj = [select Id, Status__c from ProtocolViolationDetail__c where id =:protocolViolationId ];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======protocolViolationId =======' +protocolViolationId ); 
    }
    
    public Pagereference saveMainCRF() {
        if(protocolViolationId != null ) {
            return null;
        } else {
            protocolViolation = new ProtocolViolationDetail__c();
            protocolViolation.TrialPatient__c = trialPatientId;
            protocolViolation.Patient_Remains_on_Study__c = true;
            try {
                insert protocolViolation;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                return null;
            }
            
            protocolViolationId = protocolViolation.Id;
            
            Pagereference ref = new Pagereference('/'+protocolViolationId);
            //ref.getParameters().put('nooverride', '1');
            ref.setRedirect(false);
            return ref;
        }
    }
    
    public Pagereference next() 
    {
        String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
        errorMsg = '';
        isActionTaken = false;
        if(nextTabValue != null){
            nextTabName = nextTabValue;
        }
        if(!protocolViolation.Patient_Remains_on_Study__c && !protocolViolation.Patient_withdrawn__c && !protocolViolation.Other_Action_Checkbox__c){
            isActionTaken = true;
            errorMsg = 'Please select at-least one Action taken.';
            return null;
        }
        else if(!protocolViolation.Medication_non_complicance__c && !protocolViolation.Visit_non_complicance__c && !protocolViolation.On_study_procedure_required_by_protocol__c &&
                    !protocolViolation.Incorrect_therapy_given_to_patient__c && !protocolViolation.Screening_and_on_study_test_lab_done__c && !protocolViolation.Screening_procedure_required__c && 
                    !protocolViolation.Eligibility_criteria_exception__c && !protocolViolation.Enrollment_of_ineligeligibleible_patient__c && !protocolViolation.Patient_became_pregnant_prior_to_surgery__c &&
                    !protocolViolation.Other_Violation_Checkbox__c) {
            isActionTaken = true;
            errorMsg = 'Please select at-least one Type of Protocol Violation.';
            return null;
        }// Added by kumar
        else if(protocolViolation.DateOfProtocolViolation__c > Date.today()){
            isActionTaken = true;
            errorMsg = 'You have entered a future date.';
            return null;
        }// Added by kumar
        /*else{
            currentTab = nextTabName;
            ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
            completeCrf.customAdhoc(protocolViolation.Id+'', 'submit', 'Site');
        } */  
        try {
            update protocolViolation;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
             // Added by Shruti (DE401)
             //Pagereference ref = new Pagereference('/apex/ProtocolViolationForm?formId='+protocolViolationId+'&trialPat='+trialPatientId);
             Pagereference ref = new Pagereference('/'+protocolViolationId);
             ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
        }
        
            //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
            //completeCrf.customAdhoc(protocolViolation.Id+'', 'submit', 'Site');
            if(nextTabName == 'saveAndClose') {
//================For Save & Close Functionality ======================            
              protocolViolation.First_Save_and_Close__c = true;
                try {
                    update protocolViolation;
                }catch (Exception e) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    Apexpages.addMessage(msg);
                    // Added by Shruti (DE401)
             //Pagereference ref = new Pagereference('/apex/ProtocolViolationForm?formId='+protocolViolationId+'&trialPat='+trialPatientId);
             Pagereference ref = new Pagereference('/'+protocolViolationId);
             ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
                } 
//=====================================================================                
                List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
                if(!trialPatList.isEmpty()) {
                    //Pagereference pr = new Pagereference('/'+trialPatList[0].Patient_Id__c);
                    Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
                    
                    pr.setRedirect(true);
                    return pr; 
                }
            }
        currentTab = nextTabName;
        return null;
    }
    
    //public void previous() {
    public Pagereference previous() { //Added by Shruti (DE401)
        String prevTabValue = Apexpages.currentPage().getParameters().get('prevTab');
        isActionTaken = false;
        currentTab = prevTabValue;
        // Added by Shruti (DE401)
       try {
            update protocolViolation;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);             
            // Pagereference ref = new Pagereference('/apex/ProtocolViolationForm?formId='+protocolViolationId+'&trialPat='+trialPatientId);
             Pagereference ref = new Pagereference('/'+protocolViolationId);
             ref.setRedirect(true);
             return ref;             
        }
             return null;
        // Added by Shruti (DE401) 
    }
    
    public Pagereference cancelCRF() {
        //protocolViolationId = Apexpages.currentPage().getParameters().get('formId');
        if(protocolViolationId != null ){
            List<ProtocolViolationDetail__c> lstProViol = [Select p.Root_CRF_Id__c,p.OriginalCRF__c, p.Visit_non_complicance__c, p.TrialPatient__c,p.TrialPatient__r.Patient_Id__c, TrialPatient__r.Trial_Id__c, p.Screening_procedure_required__c, p.Screening_and_on_study_test_lab_done__c, p.Phase__c, p.Patient_withdrawn__c, p.Patient_became_pregnant_prior_to_surgery__c, p.Patient__c, p.Patient_Remains_on_Study__c, p.Other_Violation_Checkbox__c, p.Other_Type_of_Violation__c, p.Other_Action__c, p.Other_Action_Checkbox__c, p.On_study_procedure_required_by_protocol__c, p.Narrative_description__c, p.Medication_non_complicance__c, p.Local_IRB_Notified__c, p.Incorrect_therapy_given_to_patient__c, p.Enrollment_of_ineligeligibleible_patient__c, p.Eligibility_criteria_exception__c, p.DateOfProtocolViolation__c, p.CompletedDate__c From ProtocolViolationDetail__c p where Id = :protocolViolationId];
            Id patId = lstProViol[0].TrialPatient__r.Patient_Id__c;
            if(!lstProViol.isEmpty()){
             /*   if(lstProViol[0].OriginalCRF__c == null)
                    delete lstProViol[0];*/
            //-------------------------- for delete---------------// 
            if( protocolViolationId!= null) {
                    // Added by Shruti (DE401)
                       try {
                        delete new ProtocolViolationDetail__c(id=protocolViolationId);
                        }catch (Exception e) {
                        Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                        Apexpages.addMessage(msg);             
                         Pagereference ref = new Pagereference('/apex/ProtocolViolationForm?formId='+protocolViolationId+'&trialPat='+trialPatientId);
                         //Pagereference ref = new Pagereference('/'+protocolViolationId);
                         ref.setRedirect(true);
                         return ref;             
                        }             
        // Added by Shruti (DE401)                        
                }  
                
            
            //-------------------------- for delete---------------//       
            }
            Pagereference pr = new Pagereference('/apex/TranscendPage?id='+patId+'&TrialId='+lstProViol[0].TrialPatient__r.Trial_Id__c+'&sfdc.override=1');
            //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+patId+'&sfdc.override=1');
            return pr;
        } else {
            return null;
        }
    }
    
    public Pagereference signAndSubmit() {
        System.debug('------protocolViolation.Id------>'+protocolViolation.Id);
        
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00004','',protocolViolation.Id+'', 'Site');
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
        //String clonedCRFId = CloneBuilder.cloneMe(protocolViolation.Id, '0', '');
        protocolViolation.Status__c = 'Not Completed';
        try {
            update protocolViolation;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            return null;
        }
        return null;
    }
    
    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstCloneProtocol[0].Status__c = 'Not Completed';
            try {
                update lstCloneProtocol[0];
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/ProtocolViolationForm?formId='+protocolViolationId+'&trialPat='+trialPatientId);
             Pagereference ref = new Pagereference('/'+protocolViolationId);
             ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
            }
        }
        openInEditMode = false;
        currentTab = 'firstTab';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/ProtocolViolationForm?trialPat='+trialPatientId+'&formId='+clonedCRFId);
        ref.setRedirect(true);
        return ref;
    }
    
}