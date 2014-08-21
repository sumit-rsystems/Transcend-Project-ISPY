public with sharing class MammaPrintNewController {
    public MammaPrintDetail__c MammaObj{get;set;}
    public String selectSpecimenUsed{get;set;}
    public String selectSpecimen{get;set;}
    public List<SelectOption> specimenUsed{get;set;}
    public List<SelectOption> specimenCollDate{get;set;}
    public Boolean isErrorMsg {get;set;}
    public String errorMsg {get;set;}
    public String recordURL {get;set;}
    public String currentTab{get;set;}
    public String password{get;set;}
    public String trialPatientId {get;set;}
    public Id formId {get;set;}
    public Boolean isComplete{get;set;}
    public Boolean isDelete{get;set;}    // For Delete //
    public String nextTabName{get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    public List<MammaPrintDetail__c> lstCompletedForm {get;set;}
    public String profileName{get;set;}   // For Delete //
    public MammaPrintDetail__c pathObj{get;set;}    // For Delete //
    
    public MammaPrintNewController(){
        MammaObj = new MammaPrintDetail__c();
        trialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
    }
    
    
    public pagereference redirect(){
    pagereference redirect = new pagereference('/apex/MammaPrintNewPagePdf?&id='+formId);
    redirect.setRedirect(true);
    return redirect;
}

    public MammaPrintNewController(Apexpages.standardcontroller reg){
        //-----------------------delete button fuctionlity- start-------------------------
        isDelete = false;
        String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){  
            profileName = u.Profile.Name;
        } 
        //-----------------------delete button fuctionlity- end --------------------------   
        System.debug('MammaPrint-------'+reg.getId());
         formId = reg.getId();
         //system.assert(false,formId );
        MammaPrintDetail__c mPrintDetailObj;
        if(formId != null)mPrintDetailObj = [Select m.TrialPatient__c, m.Id From MammaPrintDetail__c m where id =: formId];
        
        MammaObj = new MammaPrintDetail__c();
        isComplete = true;
        specimenUsed = new List<SelectOption>();
        specimenUsed.add(new Selectoption('','--None--'));
        
        if(mPrintDetailObj != null){
            trialPatientId = mPrintDetailObj.TrialPatient__c;
            formId = mPrintDetailObj.id;
        }else{
            trialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
            formId = Apexpages.currentPage().getParameters().get('formId');
        }
        system.debug('trialPatientId : '+trialPatientId);
        
        if(formId != null) {
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPatientId];
            if(!lstTrialPatient.IsEmpty()) {
                trialPatientObj = lstTrialPatient[0];
            }
            List<MammaPrintDetail__c> lstMammaPrint = [select m.CRF__c, m.Id, m.TargetPrint_Her_2_Status__c, m.Tissue_Specimen_Detail__c, m.Specimen_Collection_Dates__c, m.TargetPrint_Her_2_Index__c, m.Status__c, m.Specimen_Used__c, m.Report_Date__c, m.MammaPrint_Risk__c, m.MammaPrint_Index__c, m.H1_H2_status__c, m.TrialPatient__c from MammaPrintDetail__c m where Id = :formId];
            if(!lstMammaPrint.isEmpty()) {
                MammaObj = lstMammaPrint[0];
                specimenUsed = new List<SelectOption>();
                specimenUsed.add(new Selectoption('','--None---'));
                selectSpecimen = MammaObj.Tissue_Specimen_Detail__c;
                trialPatientId = MammaObj.TrialPatient__c;
                system.debug('__MammaObj.Specimen_Used__c__'+MammaObj.Specimen_Used__c);
                collectSpecimenIDs();
                
            }
        } else {
            List<MammaPrintDetail__c> lstMammaPrint = [select m.CRF__c, m.Id, m.TargetPrint_Her_2_Status__c, m.Tissue_Specimen_Detail__c, m.Specimen_Collection_Dates__c, m.TargetPrint_Her_2_Index__c, m.Status__c, m.Specimen_Used__c, m.Report_Date__c, m.MammaPrint_Risk__c, m.MammaPrint_Index__c, m.H1_H2_status__c, m.TrialPatient__c from MammaPrintDetail__c m where TrialPatient__c = :trialPatientId];
            if(!lstMammaPrint.isEmpty()) {
                MammaObj = lstMammaPrint[0];
                specimenUsed = new List<SelectOption>();
                specimenUsed.add(new Selectoption('','--None--'));
                selectSpecimen = MammaObj.Tissue_Specimen_Detail__c;
                trialPatientId = MammaObj.TrialPatient__c;
                system.debug('__MammaObj.Specimen_Used__c__'+MammaObj.Specimen_Used__c);
                collectSpecimenIDs();
                
            }
        }
        isComplete = CRFUtilities.isReadOnlyUsr();
        if(MammaObj != null){
            //String crfId = MammaObj.CRF__c;
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = MammaObj.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected' || status == 'Completed'){
                    currentTab = 'SecondTab';
                    isComplete = false;
                } else {
                    currentTab = 'firstTab';
                }
            //}
        }
        isDelete();    // For Delete //
    }
    //-----------------------delete button fuctionlity- start-------------------------
    public void isDelete(){
       
        System.debug('======formId=======' +formId);
        if(formId != null){
            pathObj = [select Id, Status__c from MammaPrintDetail__c where id =:formId];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======formId=======' +formId ); 
    }
    //-----------------------delete button fuctionlity- start-------------------------
    
    public void collectSpecimenIDs() {
        //system.debug('select Id,Name,status__c, (Select SpecimenID__c From Core_Biopsy_Specimens__r)  from TissueSpecimenDetail__c where Id = '+selectSpecimen);
        //String trialPatientId = Apexpages.currentPage().getParameters().get('CF00Nc0000000Gtkq_lkid');
        //system.debug('select Id,Name,status__c, (Select SpecimenID__c From Core_Biopsy_Specimens__r)  from TissueSpecimenDetail__c where TrialPatient__c ='+trialPatientId);
        system.debug('__selectSpecimen__'+selectSpecimen);
        specimenUsed = new List<SelectOption>();
        specimenUsed.add(new Selectoption('','--None--'));
        
        List<TissueSpecimenDetail__c> lstTissueSpecimen = [select Id,Name,status__c, (Select SpecimenID__c From Core_Biopsy_Specimens__r)  from TissueSpecimenDetail__c where Id = :selectSpecimen];
        system.debug('__lstTissueSpecimen.isEmpty()__'+lstTissueSpecimen.isEmpty());
        if(!lstTissueSpecimen.isEmpty()) {
            system.debug('__lstTissueSpecimen[0].status__c__'+lstTissueSpecimen[0].status__c);
            if(lstTissueSpecimen[0].status__c != 'Not Completed') {
                List<Core_Biopsy_Specimens__c> lstCoreBiopsy = lstTissueSpecimen[0].Core_Biopsy_Specimens__r;
                system.debug('__lstCoreBiopsy__'+lstCoreBiopsy);
                for(Core_Biopsy_Specimens__c coreBiopsy : lstCoreBiopsy) {
                    system.debug('__coreBiopsy.SpecimenID__c__'+coreBiopsy.SpecimenID__c);
                    if(coreBiopsy.SpecimenID__c != null) {
                        specimenUsed.add(new Selectoption(coreBiopsy.SpecimenID__c,coreBiopsy.SpecimenID__c));
                    }
                }
            } else {   
                errorMsg = 'Patients\'s Tissue Specimen CRF Is Not Completed For Phase "Pre-Treatment".';
                isErrorMsg = true;
            }
        } else {
                errorMsg = 'Patients\'s Tissue Specimen CRF Is Not Completed For Phase "Pre-Treatment".';
                isErrorMsg = true;
            }
    }
    
    public Pagereference specimenCollectionDate() {
        specimenCollDate = new List<SelectOption>();
        specimenCollDate.add(new Selectoption('','--None--'));
        system.debug('trialPatientId : '+trialPatientId);
        List<TissueSpecimenDetail__c> lstTissueSpecimen = [select Id,Name,status__c,ProcedureDate__c,Time_Point__c, (Select SpecimenID__c From Core_Biopsy_Specimens__r)  from TissueSpecimenDetail__c where TrialPatient__c = :trialPatientId and Time_Point__c = 'Pre-treatment' and (Status__c != 'Not Completed' and Status__c != null)];
        //List<TissueSpecimenDetail__c> lstTissueSpecimen = [select Id,Name,status__c,ProcedureDate__c,Time_Point__c, (Select SpecimenID__c From Core_Biopsy_Specimens__r)  from TissueSpecimenDetail__c where TrialPatient__c = :trialPatientId];
        system.debug('lstTissueSpecimen : '+lstTissueSpecimen);
        for(TissueSpecimenDetail__c tsd : lstTissueSpecimen) {
            if(lstTissueSpecimen[0].status__c != 'Not Completed' && lstTissueSpecimen[0].status__c != null) {
                system.debug('========lstTissueSpecimen[0]====='+lstTissueSpecimen[0]);
                system.debug('========lstTissueSpecimen[0].ProcedureDate__c====='+lstTissueSpecimen[0].ProcedureDate__c);
                specimenCollDate.add(new Selectoption(lstTissueSpecimen[0].Id,String.valueOf(lstTissueSpecimen[0].ProcedureDate__c)));
            }
        }
        if(lstTissueSpecimen.isEmpty()) {
            errorMsg = 'Patients\'s Tissue Specimen CRF Is Not Completed.';
            isErrorMsg = true;
            List<TrialPatient__c> lstTrialPatient = [Select t.Patient_Id__c From TrialPatient__c t where Id = :trialPatientId];
            if(!lstTrialPatient.isEmpty()) {
                recordURL = '/'+lstTrialPatient[0].Patient_Id__c;
            } else {
                recordURL = '/'+trialPatientId;
            }
            return new Pagereference('/apex/MammaPrintErrorPage');
        }
        
        //formId = Apexpages.currentPage().getParameters().get('formId');
        if(formId == null) {  
            MammaObj = new MammaPrintDetail__c();
            MammaObj.TrialPatient__c = TrialPatientId;
            try {
                insert MammaObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                return null;
            }
            //Pagereference pr = new Pagereference('/apex/MammaPrintNewPage?trialPat='+TrialPatientId +'&formId='+MammaObj.Id);
            Pagereference pr = new Pagereference('/'+MammaObj.Id);
            //pr.getParameters().put('nooverride', '1');       
            pr.setRedirect(true);
            return pr;
        }
        return null;
    }
    
    public Pagereference next(){
        String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
        if(nextTabValue != null){
            nextTabName = nextTabValue;
        }
        system.debug('MammaObj.Report_Date__c > system.today() : '+(MammaObj.Report_Date__c > system.today()));
        if(MammaObj.Report_Date__c > system.today()) {
            MammaObj.Report_Date__c.addError('Future dates are not allowed.');
            return null;
        }
        
        if(MammaObj.MammaPrint_Index__c > 1.0 || MammaObj.MammaPrint_Index__c < -1.0 ) {
            MammaObj.MammaPrint_Index__c.addError('The MammaPrint index value will be a number between -1 and 1.');
            return null;
        }
        if(MammaObj.TargetPrint_Her_2_Index__c  > 1.0 || MammaObj.TargetPrint_Her_2_Index__c  < -1.0 ) {
            MammaObj.TargetPrint_Her_2_Index__c.addError('TargetPrint Her2 index will be a number between -1 and 1.');
            return null;
        }
        MammaObj.TrialPatient__c = trialPatientId;  
        system.debug('selectSpecimen : '+selectSpecimen);
        if(selectSpecimen != null && selectSpecimen != '') {
            MammaObj.Tissue_Specimen_Detail__c = selectSpecimen;
        }
         // Added by Shruti (DE401)
            try {
                upsert MammaObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             // Pagereference ref = new Pagereference('/apex/MammaPrintNewPage?&id='+formId);
                Pagereference ref = new Pagereference('/'+formId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)
        
        List<MammaPrintDetail__c> lstMammaPrint = [select  m.Id,m.CRF__c, m.Tissue_Specimen_Detail__c, m.Specimen_Collection_Dates__c, m.TargetPrint_Her_2_Status__c, m.TargetPrint_Her_2_Index__c, m.Status__c, m.Specimen_Used__c, m.Report_Date__c, m.MammaPrint_Risk__c, m.MammaPrint_Index__c, m.H1_H2_status__c From MammaPrintDetail__c m where Id = :MammaObj.Id];
        if(!lstMammaPrint.isEmpty()) {
            MammaObj = lstMammaPrint[0];
        }    
        //complete();
            
        if(nextTabName == 'saveAndClose') {
//=======================================================For Save & Close Functionality=====================        
           MammaObj.First_Save_and_Close__c = true;
           try {
               update MammaObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                 // Added by Shruti (DE401)
             // Pagereference ref = new Pagereference('/apex/MammaPrintNewPage?&id='+formId);
                Pagereference ref = new Pagereference('/'+formId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
            }
//==========================================================================================================           
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
            if(!trialPatList.isEmpty()) {
                Pagereference ref = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
                //Pagereference ref = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
                List<Profile> lstProfile = [select Name from Profile where Id = :Userinfo.getProfileId()];
                if(!lstProfile.isEmpty()) {
                    if(lstProfile[0].Name == 'Lab User') {
                        ref = new Pagereference('/home/home.jsp');
                    }
                }
                ref.setRedirect(true);
                return ref; 
            }
        }
        currentTab = nextTabName;
        system.debug('MammaObj : '+MammaObj);
        return null;
    }
    
    // public void previous(){
       public Pagereference previous(){ //Added by Shruti (DE401)
        String tabPrevious = Apexpages.currentPage().getParameters().get('tabPrevious');
        currentTab = tabPrevious;
        // Added by Shruti (DE401)
            try {
                update MammaObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             // Pagereference ref = new Pagereference('/apex/MammaPrintNewPage?&id='+formId);
                Pagereference ref = new Pagereference('/'+formId);
            ref.setRedirect(true);
             return ref;             
            }
             return null; 
            // Added by Shruti (DE401)
    }
    
    public Pagereference cancelCRF(){
        List<TrialPatient__c> lstTP = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id = :trialPatientId];
        if(!lstTP.isEmpty()) {
            if(MammaObj != null && MammaObj.Id != null) {
                // Added by Shruti (DE401)
            try {
                delete MammaObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             // Pagereference ref = new Pagereference('/apex/MammaPrintNewPage?&id='+formId);
                Pagereference ref = new Pagereference('/'+formId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)                
            }
            Pagereference ref = new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c+'&TrialId='+lstTP[0].Trial_Id__c);
           // Pagereference ref = new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c);
            List<Profile> lstProfile = [select Name from Profile where Id = :Userinfo.getProfileId()];
            if(!lstProfile.isEmpty()) {
                if(lstProfile[0].Name == 'Lab User') {
                    ref = new Pagereference('/home/home.jsp');
                }
            }
            ref.setRedirect(true);
            return ref; 
            
        }
        return null;
    }
    
    public Pagereference complete() {
        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
        //completeCrf.customAdhoc(MammaObj.Id+'', 'submit', 'Site');
        MammaObj.Status__c = 'Completed';
        try {
            update MammaObj;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            return null;
        }
        
        //TaskManager.updateTask(new Set<Id>{MammaObj.Id}, 'MammaPrintDetail__c');
        Pagereference ref = new Pagereference('/home/home.jsp');
        
        return ref;
    }
    
    public Pagereference signAndSubmit(){
        
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00005','',MammaObj.Id+'', 'Site,Lab');
        system.debug('errorMsg :  '+signSubmit.errorMsg);
        errorMsg = signSubmit.errorMsg;
        msgColor = 'Red';
        isDelete= true;   // For Delete //
        system.debug('isErrorMsg : '+signSubmit.isErrorMsg);
        if(!signSubmit.isErrorMsg) {
            List<Profile> lstProfile = [select Name from Profile where Id = :Userinfo.getProfileId()];
            if(!lstProfile.isEmpty()) {
                if(lstProfile[0].Name == 'Lab User') {
                    ref = new Pagereference('/home/home.jsp');
                }
            }
        }
        return ref;
    }
    public String msgColor {get;set;}
    public void resendCode() {
        SignAndSubmitController ctr = new SignAndSubmitController();
        ctr.resendCode();
        errorMsg = 'Code Sent! Please check your Email.';
        msgColor = 'Green';
    }
    public void getCompletedFormList(){
    lstCompletedForm = [Select m.Id,m.TrialPatient__c, m.Status__c, m.Specimen_Used__c, m.Specimen_Collection_Dates__c,m.Owner.Name, m.OwnerId, m.CompletedDate__c,
                            m.LastModifiedDate From MammaPrintDetail__c m];
    System.debug('ppp==lstCompletedForm='+lstCompletedForm);
    }
    
}