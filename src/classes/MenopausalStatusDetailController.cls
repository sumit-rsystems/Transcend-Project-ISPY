public with sharing class MenopausalStatusDetailController {
    
    public String currentTab {get; set;}
    public Menopausal_Status_Detail__c msd {get;set;}
    public Id menopausalId;
    //public String menoId;
    public String trialPatient{get;set;}
    public String errorMsg {get;set;}
    public String errorMsg1 {get;set;}
    //public List<TrialPatient__c> lstTrialPat {get;set;}  
    private List<Menopausal_Status_Detail__c> lstCloneMeno{get;set;}
    public Boolean unknownValid {get;set;}
    public Boolean onEstrogen {get;set;}
    public Boolean onBilateral {get;set;}
    public Boolean onHysterectomy {get;set;}
    public Boolean isComplete {get;set;}
    public String password {get;set;} 
    public List<SelectOption> bilateraloptions {get;set;}
    public String SelectedBilateralOptions {get;set;}
    public List<SelectOption> hysterectomyOptions {get;set;}
    public String SelectedHysterectomyOptions {get;set;}
    public List<SelectOption> estrogenOptions {get;set;}
    public String SelectedestrogenOptions {get;set;}
    public boolean openInEditMode {get;set;}
    public boolean isShowEditButton {get;set;}
    public String nextTabName{get;set;}
    public String sixMonthsBackDate{get;set;}
    public String twelveMonthsBackDate{get;set;}
    private Id clonedCRFId{get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    public String profileName{get;set;}  // For Delete //
    public Boolean isDelete{get;set;}    // For Delete //
    
    public MenopausalStatusDetailController(Apexpages.standardcontroller controller){
        IsDelete = false;                // For Delete //
        openInEditMode = false;
        isShowEditButton = false;
        clonedCRFId = null;
        
        menopausalId = controller.getId();
        if(menopausalId == null) {
            menopausalId = Apexpages.currentPage().getParameters().get('menopausalId');
        }
        
        if(menopausalId != null) {
            List<Menopausal_Status_Detail__c> msdList = [Select m.TrialPatient__c From Menopausal_Status_Detail__c m where id = :menopausalId];
            if(!msdList.isEmpty()) {
                trialPatient = msdList[0].TrialPatient__c;
            }
            List<TrialPatient__c> lstTrialPat = [select id, Patient_Id__r.Age__c, Trial_Id__r.Name from TrialPatient__c where id = : trialPatient];
            if(!lstTrialPat.isEmpty()) {
                trialPatientObj = lstTrialPat[0];
            }
        } else {
            trialPatient = Apexpages.currentPage().getParameters().get('trialPat');
            List<TrialPatient__c> lstTrialPat = [select id, Patient_Id__r.Age__c, Trial_Id__r.Name from TrialPatient__c where id = : trialPatient];
            if(!lstTrialPat.isEmpty()) {
                trialPatientObj = lstTrialPat[0];
            }
        }
        
        system.debug('__trialPatient__'+trialPatient);
        
        unknownValid = false;
        onEstrogen = true;
        onBilateral = true;
        onHysterectomy = true;
        isComplete = true;
        sixMonthsBackDate = System.today().addMonths(-6).format();
        twelveMonthsBackDate = System.today().addMonths(-12).format();
        
        bilateraloptions = new List<SelectOption>();
        //SelectedBilateralOptions = 'No';
        bilateraloptions.add(new SelectOption('Yes','Yes'));
        bilateraloptions.add(new SelectOption('No','No'));
        hysterectomyOptions = new List<SelectOption>();
        //SelectedHysterectomyOptions = 'No';
        hysterectomyOptions.add(new SelectOption('Yes','Yes'));
        hysterectomyOptions.add(new SelectOption('No','No'));
        estrogenOptions = new List<SelectOption>();
    //  SelectedestrogenOptions = 'No';
        estrogenOptions.add(new SelectOption('Yes','Yes'));
        estrogenOptions.add(new SelectOption('No','No'));
        
        //system.debug('__lstTrialPat__'+[select id,Patient_Id__r.Age__c from TrialPatient__c where id = : trialPatient]);
        //menoId = controller.getId();
        if(menopausalId != null){
            List<Menopausal_Status_Detail__c> lstMeno = [Select m.Root_CRF_Id__c,m.Unknown_Date_but_12_Months_Ago__c,m.CRF_Id__c,m.AgeVal__c, m.Unknown_Date__c, m.Unknown_Date_Snomed__c, m.TrialPatient__c, m.Status__c, m.RPMA_Her2_Snomed__c, m.RPMA_Her2_2_not_done_Snomed__c, m.RPMA_Her2_1_Positive_Snomed__c, m.RPMA_Her2_0_Negative_Snomed__c, m.Phase__c, m.Patient_age__c, m.Patient__c, m.On_Estrogen_Replacement__c, m.On_Estrogen_Replacement_Snomed__c, m.Name, m.Menopausal_Status__c, m.Last_Menstrual_Year__c, m.Last_Menstrual_Month__c, m.Last_Menstrual_Day__c, m.Hysterectomy__c, m.Hysterectomy_Snomed__c, m.Hysterectomy_Date__c, m.Follow_Up_Detail__c, m.Enstrogent_Replacement_Duration_Years__c, m.Enstrogent_Replacement_Duration_Months__c, m.Date_of_Last_Menstrual_Period__c, m.Date_of_Last_Menstrual_Period_Snomed__c, m.CompletedDate__c, m.Bilateral_oophorectomy__c, m.Bilateral_Oophorectomy_Snomed__c, m.Bilateral_Oophorectomy_Date__c From Menopausal_Status_Detail__c m where id = :menopausalId];
            if(!lstMeno.IsEmpty()) {
                msd = lstMeno[0];
            }
        } else {
            msd = new Menopausal_Status_Detail__c();
            //msd.age__c = lstTrialPat[0].Patient_Id__r.Age__c; 
        }
        
        if(msd.Id != null) {
            lstCloneMeno = [select Id, Status__c,Root_CRF_Id__c from Menopausal_Status_Detail__c where OriginalCRF__c =:msd.Id and Status__c = 'Cloned'];
            if(!lstCloneMeno.isEmpty()) {
                isShowEditButton = true;
                clonedCRFId = lstCloneMeno[0].Id;
            }
        }
        
        if(msd.On_Estrogen_Replacement__c){
            onEstrogen = false;
            SelectedestrogenOptions = 'Yes';
        } else {
            onEstrogen = true;
            SelectedestrogenOptions = 'No';
        }
        
        if(msd.Bilateral_oophorectomy__c){
            onBilateral = false;
            SelectedBilateralOptions = 'Yes';
        } else {
            onBilateral = true;
            SelectedBilateralOptions = 'No';
        }
        
        if(msd.Hysterectomy__c){
            onHysterectomy = false;
            SelectedHysterectomyOptions = 'Yes';
        } else {
            onHysterectomy = true;
            SelectedHysterectomyOptions = 'No';
        }
        isComplete = CRFUtilities.isReadOnlyUsr();
        if(msd != null){
            //String crfId = msd.CRF_Id__c;
            //if(crfId != null && crfId != ''){
                //system.debug('__crfId__'+crfId);
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = msd.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    currentTab = 'Complete';
                    isComplete = false; 
                } else {
                    currentTab = 'MenopausalStatus';
                }
            //}
        }
        //-----------------------delete button fuctionlity- start-------------------------
        IsDelete();
        if (IsDelete){
            String currentUserId = UserInfo.getUserId();
            for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
                profileName = u.Profile.Name; 
            } 
        }
        //-----------------------delete button fuctionlity- end --------------------------
        System.debug('isComplete:'+isComplete);
    }
    public pagereference redirect(){
    
        pagereference redirect = new pagereference('/apex/MenopausalStatusDetailPagePdf?menopausalId='+menopausalId+'&trialPat='+Apexpages.currentPage().getparameters().get('TrialPatient'));
        redirect.setRedirect(true);
        return redirect;
    }
    //-----------------------delete button fuctionlity- start-------------------------
     public void isDelete(){
        Menopausal_Status_Detail__c menoSpecimenForm;
        System.debug('====== MeoSpecimenId=======' + msd.Id);
       if(msd.Id!= null){
        menoSpecimenForm = [select Id, Status__c,Root_CRF_Id__c  from Menopausal_Status_Detail__c where id =: msd.Id];
            
            if(menoSpecimenForm.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        } 
     }
    //-----------------------delete button fuctionlity- end -------------------------- 
    
    public Pagereference insertCRF(){
        if(menopausalId != null){
            //List<Menopausal_Status_Detail__c> lstMSD = [select id,TrialPatient__c from Menopausal_Status_Detail__c where id = :menopausalId];
            //Pagereference pr = new Pagereference('/'+menopausalId);
            //pr.getParameters().put('nooverride', '1');
            //pr.setRedirect(true); 
            //return pr;
            return null;
        } else {
            List<Menopausal_Status_Detail__c> lstMSD = [select id,TrialPatient__c from Menopausal_Status_Detail__c where TrialPatient__c =:trialPatient];
            if(!lstMSD.isEmpty()) {
                msd = lstMSD[0]; 
            } else {
                msd = new Menopausal_Status_Detail__c();
                msd.TrialPatient__c = trialPatient;
                //msd.age__c = lstTrialPat[0].Patient_Id__r.Age__c;
                if(trialPatientObj.Patient_Id__r.Age__c > 50){
                    msd.AgeVal__c = 'Age > 50';
                } else {
                    msd.AgeVal__c = 'Age < 50';
                }
                RequiredFieldHandler.fromDataLoader = true;
                insert msd;
                
            }
            //System.debug('-----inserted----->'+msd.age__c);
            Pagereference pr = new Pagereference('/'+msd.Id);
            //pr.getParameters().put('nooverride', '1');
            pr.setRedirect(true);
            return pr;
        }
        return null;
    }
    
    public Pagereference next(){
        String tabNext = Apexpages.currentPage().getParameters().get('tabNext');
        if(tabNext != null) {
            nextTabName = tabNext;
        }
        system.debug('__nextTabName__'+nextTabName);
        system.debug('__currentTab__'+currentTab);
        unknownValid = false;
        if(msd.Unknown_Date__c && msd.Unknown_Date_but_12_Months_Ago__c){
            errorMsg = 'Please select either Unknown date (or) Unknown date, but > 12 months ago.';
            onEstrogen = false;
            unknownValid = true;
        } else if(msd.Bilateral_Oophorectomy_Date__c > System.today()){
            errorMsg = 'Bilateral Oophorectomy Date should be less than or equal to current date.';
            onBilateral = false;
            unknownValid = true;
        } else if(msd.Hysterectomy_Date__c > System.today()){
            errorMsg = 'Hysterectomy Date should be less than or equal to current date.';
            onHysterectomy = false;
            unknownValid = true;
        } else if(msd.Last_Menstrual_Day__c > 31 || msd.Last_Menstrual_Day__c < 1){
            errorMsg = 'Specified attribute is not between the expected values of 1 and 31';
            unknownValid = true;
        } else if(msd.Last_Menstrual_Month__c > 12 || msd.Last_Menstrual_Month__c < 1){
            errorMsg = 'Specified attribute is not between the expected values of 1 and 12';
            unknownValid = true;
        } else if(msd.Last_Menstrual_Year__c < 1000){
            errorMsg = 'Value is less than allowable minimum of 1000';
            unknownValid = true;
        } else if(msd.Last_Menstrual_Year__c > System.today().year()){
            errorMsg = 'Last Menstrual Year should be less than current year.';
            unknownValid = true;
        } else if((msd.Unknown_Date__c && msd.Date_of_Last_Menstrual_Period__c != null) || (msd.Unknown_Date_but_12_Months_Ago__c && msd.Date_of_Last_Menstrual_Period__c != null)){
            errorMsg = 'Please uncheck "Unknown Date" and "Unknown Date but 12 Months Ago" Or remove Last Menstrual Period.';
            unknownValid = true; 
        } else if(msd.Date_of_Last_Menstrual_Period__c > System.today()){
            errorMsg = 'Date of last menstrual period should be less than or equal to the current date.';
            unknownValid = true;
        } else if(msd.Enstrogent_Replacement_Duration_Years__c > System.today().year()){
            errorMsg = 'Enstrogent Replacement Duration Years should be less than current year.';
            unknownValid = true;
        } else {
            msd.Bilateral_oophorectomy__c = false;
            msd.Hysterectomy__c = false;
            msd.On_Estrogen_Replacement__c = false;
            
            if(SelectedBilateralOptions == 'Yes') {
                msd.Bilateral_oophorectomy__c = true;
            }
            if(SelectedHysterectomyOptions == 'Yes') {
                msd.Hysterectomy__c = true;
            }
            if(SelectedestrogenOptions == 'Yes') {
                msd.On_Estrogen_Replacement__c = true;
            }
            System.debug('-----msd.Menopausal_Status__cPage-------->'+msd.Menopausal_Status__c);
            //Added by  Shruti (DE401)
        try {  
        update msd;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);            
            // Pagereference ref = new Pagereference('/apex/MenopausalStatusDetailPage?menopausalId='+menopausalId+'&trialPat='+Apexpages.currentPage().getparameters().get('TrialPatient'));
             Pagereference ref = new Pagereference('/'+menopausalId);
            ref.setRedirect(true);
             return ref;            
        }
        // Added by Shruti (DE401)
                        
            currentTab = nextTabName;
        }
        system.debug('__currentTab__'+currentTab);
        if(nextTabName == 'saveAndClose') {
//=================For Save & Close Functionality ===============================        
            msd.First_Save_and_Close__c = true;            
            //Added by  Shruti (DE401)
        try {  
        update msd;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);            
             //Pagereference ref = new Pagereference('/apex/MenopausalStatusDetailPage?menopausalId='+menopausalId+'&trialPat='+Apexpages.currentPage().getparameters().get('TrialPatient'));
            Pagereference ref = new Pagereference('/'+menopausalId);
            ref.setRedirect(true);
             return ref;            
        }
        // Added by Shruti (DE401)
//===============================================================================
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:trialPatient];
            if(!trialPatList.isEmpty()) {
                //Pagereference pr = new Pagereference('/'+trialPatList[0].Patient_Id__c);//apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
                Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c);
                pr.setRedirect(true);
                return pr;
            }
        }
        return null;
    }
    
    public Pagereference customCancel(){
        //menopausalId = Apexpages.currentPage().getParameters().get('menopausalId');
        List<Menopausal_Status_Detail__c> lstMSD = [select id, OriginalCRF__c,Root_CRF_Id__c from Menopausal_Status_Detail__c where id = :menopausalId];
        if(!lstMSD.isEmpty()){
         /*   if(lstMSD[0].OriginalCRF__c == null) {
                delete lstMSD[0];
        }*/
        // ----------------------------- for delete-------------------------//
        if( menopausalId != null) {
            //Added by  Shruti (DE401)
        try {  
        delete new Menopausal_Status_Detail__c(id=menopausalId);
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);            
            // Pagereference ref = new Pagereference('/apex/MenopausalStatusDetailPage?menopausalId='+menopausalId+'&trialPat='+Apexpages.currentPage().getparameters().get('TrialPatient'));
             Pagereference ref = new Pagereference('/'+menopausalId);
            ref.setRedirect(true);
             return ref;            
        }
        // Added by Shruti (DE401)                
        } 
        //  ----------------------------- for delete ----------------------//
        }
        //trialPatient = Apexpages.currentPage().getParameters().get('TrialPatient');
        system.debug('===trialPatient==='+trialPatient);
        List<TrialPatient__c> lstTriPat = [select id,Patient_Id__c, Trial_Id__c from TrialPatient__c where id = : trialPatient];
        system.debug('===lstTriPat==='+lstTriPat);
        Pagereference pr = new Pagereference('/'+lstTriPat[0].Patient_Id__c+'?TrialId='+lstTriPat[0].Trial_Id__c);
        return pr;
    }
    
    //public void previous(){
       public Pagereference previous(){
        String tabPrevious = Apexpages.currentPage().getParameters().get('tabPrevious');
        unknownValid = false;
        currentTab = tabPrevious;
        //Added by  Shruti (DE401)
        try {  
        update msd;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);            
            // Pagereference ref = new Pagereference('/apex/MenopausalStatusDetailPage?menopausalId='+menopausalId+'&trialPat='+Apexpages.currentPage().getparameters().get('TrialPatient'));
             Pagereference ref = new Pagereference('/'+menopausalId);
            ref.setRedirect(true);
             return ref;            
        }
             return null;
        // Added by Shruti (DE401) 
    }
    
    public Pagereference signAndSubmit() {
        
        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
        //completeCrf.customAdhoc(msd.Id+'', 'submit', 'Site');
        
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00002','',msd.Id+'', 'Site');
        system.debug('errorMsg :  '+signSubmit.errorMsg);
        errorMsg1 = signSubmit.errorMsg;
        msgColor = 'Red';
       /* List<Menopausal_Status_Detail__c> lstMeno1 = [Select m.Unknown_Date_but_12_Months_Ago__c,m.CRF_Id__c,m.AgeVal__c, m.Unknown_Date__c, m.Unknown_Date_Snomed__c, m.TrialPatient__c, m.Status__c, m.RPMA_Her2_Snomed__c, m.RPMA_Her2_2_not_done_Snomed__c, m.RPMA_Her2_1_Positive_Snomed__c, m.RPMA_Her2_0_Negative_Snomed__c, m.Phase__c, m.Patient_age__c, m.Patient__c, m.On_Estrogen_Replacement__c, m.On_Estrogen_Replacement_Snomed__c, m.Name, m.Menopausal_Status__c, m.Last_Menstrual_Year__c, m.Last_Menstrual_Month__c, m.Last_Menstrual_Day__c, m.Hysterectomy__c, m.Hysterectomy_Snomed__c, m.Hysterectomy_Date__c, m.Follow_Up_Detail__c, m.Enstrogent_Replacement_Duration_Years__c, m.Enstrogent_Replacement_Duration_Months__c, m.Date_of_Last_Menstrual_Period__c, m.Date_of_Last_Menstrual_Period_Snomed__c, m.CompletedDate__c, m.Bilateral_oophorectomy__c, m.Bilateral_Oophorectomy_Snomed__c, m.Bilateral_Oophorectomy_Date__c From Menopausal_Status_Detail__c m where id = :menopausalId];
            
        if(msd.Status__c == 'Not Completed')
             {   
               msd.Status__c = 'Approval Pending';
               update msd;
             } */ 
                 
        return ref;
    }
    public String msgColor {get;set;}
    public void resendCode() {
        SignAndSubmitController ctr = new SignAndSubmitController();
        ctr.resendCode();
        errorMsg1 = 'Code Sent! Please check your Email.';
        msgColor = 'Green';
    }
    
    public Pagereference cloneCRF() {
        openInEditMode = true;
        //String clonedCRFId = CloneBuilder.cloneMe(msd.Id, '0', '');
        //Pagereference ref = new Pagereference('/apex/MenopausalStatusDetailPage?trialPat='+msd.TrialPatient__c+'&menopausalId='+clonedCRFId);
        //ref.setRedirect(true);
        //return ref;
        msd.Status__c = 'Not Completed';
        update msd;
        isComplete = true;
        currentTab = 'MenopausalStatus';
        return null;
    }
    
    public Pagereference editCRF() {
        //List<Menopausal_Status_Detail__c> lstCloneMeno = [select Id, Status__c from Menopausal_Status_Detail__c where OriginalCRF__c=:msd.Id and Status__c = 'Cloned'];
        if(isShowEditButton) {
            lstCloneMeno[0].Status__c = 'Not Completed';
            //Added by  Shruti (DE401)
        try {  
        update lstCloneMeno[0];
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);            
            // Pagereference ref = new Pagereference('/apex/MenopausalStatusDetailPage?menopausalId='+menopausalId+'&trialPat='+Apexpages.currentPage().getparameters().get('TrialPatient'));
             Pagereference ref = new Pagereference('/'+menopausalId);
            ref.setRedirect(true);
             return ref;            
        }
        // Added by Shruti (DE401)
            
        }
        
        openInEditMode = false;
        currentTab = 'MenopausalStatus';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/MenopausalStatusDetailPage?trialPat='+msd.TrialPatient__c+'&menopausalId='+clonedCRFId);
        ref.setRedirect(true);
        return ref;
    }
}