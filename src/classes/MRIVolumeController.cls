public with sharing class MRIVolumeController {
    public String currentTab{get;set;}
    public MRI_Volume__c mriObj{get;set;}
    public String TrialPatientId{get;set;}
    public Id mriId{get;set;}
    public String password {get;set;}
    public String errorMsg {get;set;}
    public Boolean isComplete {get;set;}
    public boolean openInEditMode {get;set;}
    public Boolean isShowEditButton{get;set;}
    public String nextTabName{get;set;} 
    public TrialPatient__c trialPatientObj {get;set;}
    private List<MRI_Volume__c> lstCloneMRI{get;set;}
    private Id clonedCRFId{get;set;}
    public String profileName{get;set;}     // For Delete //
    public Boolean isDelete{get;set;}       // For Delete //
    public MRI_Volume__c pathObj{get;set;}  // For Delete //
    
    
    public MRIVolumeController(ApexPages.StandardController controller) {
        System.debug('MRIVolume-------'+controller.getId());
        mriId = controller.getId();
        MRI_Volume__c MRIVolumeObj;
        if(mriId != null)MRIVolumeObj = [Select m.TrialPatient__c, m.Id From MRI_Volume__c m where id =: mriId];
        //-----------------------delete button fuctionlity- start------------------------- 
        IsDelete = false;
        IsDelete();
       // if (IsDelete){
        String currentUserId = UserInfo.getUserId();
            for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
                profileName = u.Profile.Name; 
            }
       // }
       //-----------------------delete button fuctionlity- end -------------------------- 
        openInEditMode = false;
        isShowEditButton = false;
        if(MRIVolumeObj != null){
            TrialPatientId = MRIVolumeObj.TrialPatient__c;
            mriId = MRIVolumeObj.id;
        }else{
            TrialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
            mriId = Apexpages.currentPage().getParameters().get('mriId');
        }
        isComplete = true;
        //currentTab = 'mriTab';
        mriObj = new MRI_Volume__c();
        mriObj.TrialPatient__c = TrialPatientId;
        List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPatientId];
        if(!lstTrialPatient.IsEmpty()) {
            trialPatientObj = lstTrialPatient[0];
        }
        if(mriId != null) {
            List<MRI_Volume__c> mriList = [Select m.Root_CRF_Id__c,m.OriginalCRF__c, m.Was_MRI_Readable__c, m.TrialPatient__c, m.Time_Point__c, m.Status__c, m.Seprate_masses_or_enhancements_reported__c, m.RecordTypeId, m.Phase__c, m.OwnerId, m.Name, m.MRI_Volume_in_cm3__c, m.MRI_Scan_Date__c, m.Longest_Diameter_Of_Index_Lesion_in_cm__c, m.Location_in_O_clock__c, m.Laterality__c, m.LastModifiedDate, m.LastModifiedById, m.Id, m.CreatedDate, m.CreatedById, m.CompletedDate__c, m.CRF__c From MRI_Volume__c m where Id =:mriId];
            if(!mriList.isEmpty()) {
                mriObj = mriList[0];
                lstCloneMRI = [select Id, Status__c,Root_CRF_Id__c from MRI_Volume__c where OriginalCRF__c =:mriObj.Id and Status__c = 'Cloned'];
                if(!lstCloneMRI.isEmpty()) {
                    isShowEditButton = true;
                    clonedCRFId = lstCloneMRI[0].Id;
                }
            }  
        }
        isComplete = CRFUtilities.isReadOnlyUsr();
        
        if(mriObj != null){
            //String crfId = mriObj.CRF__c;
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = mriObj.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    currentTab = 'CompleteTab';
                    isComplete = false; 
                } else {
                    currentTab = 'mriTab';
                }
            //}
        }
    }
    
     public pagereference redirect(){
    pagereference redirect = new pagereference('/apex/MRIVolumePdf?id='+mriId );
    redirect.setRedirect(true);
    return redirect;
}

    //-----------------------delete button fuctionlity- start-------------------------
    public void isDelete(){
        
        System.debug('====== mriId =======' + mriId);
        if(mriId != null){
        pathObj= [select Id, Status__c from MRI_Volume__c where id =: mriId];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
     }
    //-----------------------delete button fuctionlity- end -------------------------- 
    
//===============================For Next tab==========================================================
    public Pagereference next() {
        system.debug('__currentTab__'+currentTab);
        String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
        if(nextTabValue != null){
            nextTabName = nextTabValue;
        }
        system.debug('__nextTabValue__'+nextTabValue);
        system.debug('__nextTabName__'+nextTabName);
        if(currentTab == 'mriTab') {
            if(mriObj.MRI_Scan_Date__c > system.today()) {
                mriObj.MRI_Scan_Date__c.addError('Future date is not allowed.');
                return null;
            }
            
            if(mriObj.Time_Point__c == 'Pre-Treatment' && mriObj.MRI_Volume_in_cm3__c == null) {
                mriObj.MRI_Volume_in_cm3__c.addError('Please enter MRI Volume.');
                return null;
            }
            
            if(mriObj.MRI_Volume_in_cm3__c < 0) {
                mriObj.MRI_Volume_in_cm3__c.addError('MRI Volume should be greater then 0.');
                return null;
            }
              //Added by Shruti (DE401)
              try {
                upsert mriObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             // Pagereference ref = new Pagereference('/apex/MRIVolume?id='+mriId);
             Pagereference ref = new Pagereference('/'+mriId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)
            
        }
            mriObj = [Select m.Root_CRF_Id__c,m.OriginalCRF__c, m.Was_MRI_Readable__c, m.TrialPatient__c, m.Time_Point__c, m.Status__c, m.Seprate_masses_or_enhancements_reported__c, m.RecordTypeId, m.Phase__c, m.OwnerId, m.Name, m.MRI_Volume_in_cm3__c, m.MRI_Scan_Date__c, m.Longest_Diameter_Of_Index_Lesion_in_cm__c, m.Location_in_O_clock__c, m.Laterality__c, m.LastModifiedDate, m.LastModifiedById, m.Id, m.CreatedDate, m.CreatedById, m.CompletedDate__c, m.CRF__c From MRI_Volume__c m where Id =:mriObj.Id];
            system.debug('__mriObjId__'+mriObj.Id);        
        /*if(nextTabName == 'CompleteTab') {
            ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
            completeCrf.customAdhoc(mriObj.Id+'', 'submit', 'Site'); 
        }
        else*/ if(nextTabName == 'saveAndClose')
         {
//===============================For Save & Close Functionality ==========================================================          
       mriObj.First_Save_and_Close__c = true;
                    //Added by Shruti (DE401)
              try {
                update mriObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             // Pagereference ref = new Pagereference('/apex/MRIVolume?id='+mriId);
             Pagereference ref = new Pagereference('/'+mriId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)                    
//========================================================================================================================          
                    
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
    
    
    
//===============================For previous tab========================================================== 
    // public void previous() {
       public Pagereference previous() { //Added by Shruti (DE401)
        system.debug('__currentTab__'+currentTab);
        String prevTabValue = Apexpages.currentPage().getParameters().get('prevTab');
        system.debug('__prevTabValue__'+prevTabValue);
        currentTab = prevTabValue;
        //Added by Shruti (DE401)
              try {
                upsert mriObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
           //  Pagereference ref = new Pagereference('/apex/MRIVolume?id='+mriId);
             Pagereference ref = new Pagereference('/'+mriId);
            ref.setRedirect(true);
             return ref;             
            }
            return null; 
            // Added by Shruti (DE401)
    }
//============================insert one blank record in AE CRF=====================================================
    public Pagereference saveCrf() {
        System.debug('mriId----------'+mriId);
        if(mriId == null) {
            mriObj = new MRI_Volume__c();
            mriObj.TrialPatient__c = TrialPatientId;
            RequiredFieldHandler.fromDataLoader = true;
            insert mriObj;
            //Pagereference pr = new Pagereference('/apex/MRIVolume?trialPat='+TrialPatientId +'&mriId='+mriObj.Id);
            Pagereference pr = new Pagereference('/'+mriObj.Id);
            //pr.getParameters().put('nooverride', '1');       
            pr.setRedirect(true);
            return pr;
        } 
        return null;
    }
//===============================For delete / cencel CRF process==========================================================  
    public Pagereference customCancel() {
        List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
        if(mriObj.Id != null) {
         /*   if(mriObj.OriginalCRF__c == null) {
                delete mriObj;
            }*/
            /*else {
                mriObj.Status__c = 'Rejected';
                update mriObj;
            }*/
         //Added by Shruti (DE401)
              try {
                delete new MRI_Volume__c(id=mriObj.Id);
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/MRIVolume?id='+mriId);
             Pagereference ref = new Pagereference('/'+mriId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)            
                    
        }
        
        System.debug('-----Deleted---->');
        Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
        //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
        pr.setRedirect(true);
        return pr;
    }
    
//===========================Sign And Submit for Site User in AE CRF===========================================         
    public Pagereference signAndSubmit() 
    {
        
        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
        //completeCrf.customAdhoc(mriObj.Id+'', 'submit', 'Site'); 
        
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00007','',mriObj.Id+'', 'Site');
        system.debug('errorMsg :  '+signSubmit.errorMsg);
        errorMsg = signSubmit.errorMsg;
        msgColor = 'Red';
        isDelete= true;    // For Delete //
      
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
        //String clonedCRFId = CloneBuilder.cloneMe(mriObj.Id, '0', '');
        mriObj.Status__c = 'Not Completed';
        isComplete = true;
        update mriObj;
        return null;
    }
    
    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstCloneMRI[0].Status__c = 'Not Completed';
            //Added by Shruti (DE401)
              try {
                update lstCloneMRI[0];
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/MRIVolume?id='+mriId);
             Pagereference ref = new Pagereference('/'+mriId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)            
        }
        
        openInEditMode = false;
        currentTab = 'mriTab';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/MRIVolume?trialPat='+TrialPatientId+'&mriId='+clonedCRFId);
        ref.setRedirect(true);
        return ref;
    }
}