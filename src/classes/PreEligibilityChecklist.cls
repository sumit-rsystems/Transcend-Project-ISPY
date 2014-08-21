public with sharing class PreEligibilityChecklist {
    
    public PreEligibility_Checklist__c preObj {get; set;}
    public String currentTab {get;set;}
    //public String preId;
    public Id preEligibilityId;
    public String errorMsg {get;set;} 
    public String password {get;set;}
    public Boolean patientSign{get;set;}
    public Boolean isComplete{get;set;}
    public String nextTabName{get;set;} 
    private String trialIdValue{get;set;}
    public Trial__c trialObj {get;set;}
    public String profileName{get;set;}   // For Delete //
    public Boolean isDelete{get;set;}     // For Delete //
    public PreEligibility_Checklist__c pathObj{get;set;}  // For Delete //
    public InstitutionUser__c instituteUsreObj{get;set;}
    public String selectedSite{get;set;}
    public List<Selectoption> sites {get;set;}
    public Boolean userAssociatedWithMultipleSites{get;set;}
    private String patientId;
    
    
    public pagereference redirect(){
        pagereference redirect = new pagereference('/apex/PreEligibilityChecklistPdf?id='+preEligibilityId+'&PatientId='+preEligibilityId);
        redirect.setRedirect(true);
        return redirect;
    }
    
    public  PreEligibilityChecklist(Apexpages.standardcontroller controller){
       //-----------------------delete button fuctionlity- start-------------------------
        pathObj = new PreEligibility_Checklist__c();
        instituteUsreObj = new InstitutionUser__c();
        String currentUserId = UserInfo.getUserId();   
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        } 
        sites = new List<Selectoption>();
        
       //-----------------------delete button fuctionlity- end------------------------- 
        isComplete = true;
        userAssociatedWithMultipleSites = false;
        isDelete = false;     // For Delete //
        //preId = controller.getId();
        //preEligibilityId = Apexpages.currentPage().getParameters().get('preEligibilityId');
        preEligibilityId = controller.getId();
        
        if(Apexpages.currentPage().getParameters().keySet().contains('trialId') && Apexpages.currentPage().getParameters().get('trialId') != null) {
            trialIdValue = Apexpages.currentPage().getParameters().get('trialId');
        }
        
        if(Apexpages.currentPage().getParameters().keySet().contains('PatientId') && Apexpages.currentPage().getParameters().get('PatientId') != null) {
            patientId = Apexpages.currentPage().getParameters().get('PatientId');
        }
        
        List<Trial__c> lstTrialObj = [select Name from Trial__c where Id = :trialIdValue];
        if(!lstTrialObj.isEmpty()) {
            trialObj = lstTrialObj[0];
        }
        System.debug('preEligibilityId------------'+preEligibilityId);
        if(preEligibilityId != null){
            preObj = [Select Institution__c, Site__c, Site__r.Name,Trial__r.Name, Trial__c, TrialPatient__c, p.X30_Days_Investigational_Agents__c, p.Status__c, p.RecordTypeId, p.Reason_for_not_signing_screening_consent__c, p.Phase__c, p.Patient_signed_up_for_I_SPY2_screening__c, p.Patient_is_willing_to_have_core_biospy__c, p.Patient_is_willin_to_have_study_MRI__c, p.Patient_is_eligible_to_be_screened_for_t__c, p.Patient_is_18_years_or_older__c, p.Patient__c, p.Other_investigational_agents__c, p.Not_had_prior_RT__c, p.Non_Pregnant_Not_Lactating__c, p.Name, p.Histologically_confirmed_invasive_cancer__c, p.Had_prior_cytotoxic_regimens_anticancer__c, p.Ferromegnatic_Prostheses__c, p.ECOG_Score__c, p.Cytotoxic_Regiments__c, p.CreatedDate, p.CreatedById, p.CompletedDate__c, p.Clinically_radiologically_measurable__c, p.CRF_Id__c From PreEligibility_Checklist__c p where id = : preEligibilityId];
            patientId = preObj.Patient__c;
        } else if(preEligibilityId == null || preEligibilityId == ''){
            preObj = new PreEligibility_Checklist__c();
        }  
        //make sites options
        sites.add(new Selectoption('', 'Select Site'));
        if(preObj.Institution__c != null) {
            List<InstitutionUser__c> userAssociations = [Select i.User__c, i.Trial__c, i.SystemModstamp, i.Site__c, i.Site__r.Name, i.Name, i.Last_Name__c, i.LastModifiedDate, i.LastModifiedById, i.IsDeleted, i.Institution__c,i.Institution__r.Name, i.Id, i.First_Name__c, i.CreatedDate, i.CreatedById From InstitutionUser__c i where Institution__c =: preObj.Institution__c and i.User__c = :Userinfo.getUserId() and Site__r.RecordType.Name = 'Site'];
            system.debug('userAssociations: '+userAssociations);
            //check if user is associated with multiple sites
            if(userAssociations.size()>1) {
                userAssociatedWithMultipleSites = true;
            } else if(!userAssociations.isEmpty()) {
                selectedSite = userAssociations[0].Site__c;
            }
            
            if(userAssociations.size() == 1) {
                instituteUsreObj = userAssociations[0];
            }
            Set<Id> siteIds = new Set<Id>(); //for unique site names
            for(InstitutionUser__c ua : userAssociations) {
                if(!siteIds.contains(ua.Site__c)) {
                    sites.add(new Selectoption(ua.Site__c, ua.Site__r.Name));
                    siteIds.add(ua.Site__c);
                }
            }
        }
        system.debug('sites: '+sites);
        if(preObj.Site__c != null) {
            selectedSite = preObj.Site__c;
        }
        
        isComplete = CRFUtilities.isReadOnlyUsr();
        if(preObj != null){
            System.debug('preObj.Patient__c------------'+preObj.Patient__c);
            //String crfId = preObj.CRF_Id__c;
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = preObj.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    currentTab = 'Complete';
                    isComplete = false; 
                } else {
                    currentTab = 'PreEligibilityChecklist';
                }
            //}
        }
        isDelete();   // For Delete //
    }
    //-----------------------delete button fuctionlity- start-------------------------
    public void isDelete(){
        
        System.debug('====== preEligibilityId=======' + preEligibilityId);
        if( preEligibilityId != null){
            pathObj = [select Id, Status__c from PreEligibility_Checklist__c where id =: preEligibilityId];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======pathObj =======' +pathObj);
    }
    //-----------------------delete button fuctionlity- end --------------------------
    
    public Pagereference insertCRF(){
        //if(preObj != null){
        //    patientId = preObj.Patient__c;
        //}//else{
        //    patientId = Apexpages.currentPage().getParameters().get('PatientId');
        //}
        /*User usr = [Select u.Profile.Name From User u where id =:UserInfo.getUserId()];
        system.debug('--usr.Profile.Name--'+usr.Profile.Name);
        
        if(usr.Profile.Name == 'Custom Read Only User'){ 
                List<PreEligibility_Checklist__c> lstPre = [select id,Patient__c from PreEligibility_Checklist__c where id = :preId];
                Pagereference pr = new Pagereference('/apex/PreEligibilityChecklistReadonlyPage?PatientId='+lstPre[0].Patient__c+'&preEligibilityId='+preId);
                pr.getParameters().put('nooverride', '1');
                pr.setRedirect(true); 
                return pr;
        } */
        
        if(preEligibilityId == null && patientId != null){
            List<Patient_Custom__c> lstPat = [select id,Signed_Screening__c, Institution__c from Patient_Custom__c where id = : patientId];
            preObj = new PreEligibility_Checklist__c();
            preObj.Patient__c = patientId;
            preObj.Trial__c = trialIdValue;            
            preObj.Institution__c = lstPat[0].Institution__c;
            preObj.Patient_signed_up_for_I_SPY2_screening__c = lstPat[0].Signed_Screening__c;
            insert preObj;
            Pagereference pr = new Pagereference('/'+preObj.Id);
            //pr.getParameters().put('nooverride', '1');
            pr.setRedirect(true);
            return pr;
        }
        return null;
    }
    
    public Pagereference customCancel(){
        //preEligibilityId = Apexpages.currentPage().getParameters().get('preEligibilityId');
        List<PreEligibility_Checklist__c> lstPre = [select id, Trial__c,Patient__c from PreEligibility_Checklist__c where id = :preEligibilityId];
      // TissueSpecimenDetail__c tsSpecimenDetail;
                  System.debug('====== preEligibilityId=======' + preEligibilityId);
        if( preEligibilityId != null){
            pathObj = [select Id, Status__c from PreEligibility_Checklist__c where id =: preEligibilityId];
            
            if(pathObj != null && pathObj.Status__c == 'Approval Not Required'){
                    
                      if(profileName !='System Administrator'){
                    //isComplete= false;
                   // currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/PreEligibilityChecklist?id='+preEligibilityId+'&PatientId='+preEligibilityId);
                Pagereference ref = new Pagereference('/'+preEligibilityId);
                ref.setRedirect(true);
                return ref;
             }
             else
                                 {   
                                 delete lstPre;
                                // System.debug('====bloodSpecimen===='+bloodSpecimen);
                                 }
             
             }
             else
                                 {   
                                  delete lstPre;
                                // System.debug('====bloodSpecimen===='+bloodSpecimen);
                                 }
             }
       /* if(!lstPre.isEmpty()){
           //Added by  Shruti (DE401)
        try {  
        delete new PreEligibility_Checklist__c(id=preObj.Id);
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);            
            //Pagereference ref = new Pagereference('/apex/PreEligibilityChecklist?id='+preEligibilityId+'&PatientId='+preEligibilityId);
              Pagereference ref = new Pagereference('/'+preEligibilityId);
            ref.setRedirect(true);
             return ref;            
        }
        // Added by Shruti (DE401)            
        } */
        //String patientId = Apexpages.currentPage().getParameters().get('PatientId');
        System.debug('patientId:'+patientId);
        Pagereference pr = new Pagereference('/'+patientId+'?TrialId='+lstPre[0].Trial__c);
        return pr;
    }
    
    public Pagereference next(){ 
        String nextTabValue = Apexpages.currentPage().getParameters().get('tabNext');
        System.debug('--nextTabValue--'+nextTabValue); 
        System.debug('-------preObj.Patient_is_eligible_to_be_screened_for_t__c------->'+preObj.Patient_is_eligible_to_be_screened_for_t__c);
        if( preEligibilityId != null){
                pathObj = [select Id,TrialPatient__r.Trial_Id__c, Status__c from PreEligibility_Checklist__c where id =: preEligibilityId];
                if(pathObj != null && pathObj.Status__c == 'Approval Not Required'){
                //System.debug('====bloodSpecimen===='+bloodSpecimen);
                //System.debug('====bldSpecimenForm.Status__c===='+bldSpecimenForm.Status__c);
                //System.debug('====bloodSpecimen===='+bloodSpecimen);
                isComplete= false;
                currentTab='CompleteTab';
                // Pagereference ref = new Pagereference('/apex/PreEligibilityChecklist?id='+preEligibilityId+'&PatientId='+preEligibilityId);
                Pagereference ref = new Pagereference('/'+preEligibilityId);
                ref.setRedirect(true);
                return ref;
             }
             }
        if(nextTabValue != null){
            nextTabName = nextTabValue;
        }
        if(preObj.Histologically_confirmed_invasive_cancer__c && preObj.Clinically_radiologically_measurable__c && preObj.Cytotoxic_Regiments__c && preObj.X30_Days_Investigational_Agents__c &&  preObj.Not_had_prior_RT__c && preObj.Patient_is_18_years_or_older__c && preObj.Non_Pregnant_Not_Lactating__c && preObj.Ferromegnatic_Prostheses__c && preObj.Patient_is_willing_to_have_core_biospy__c && preObj.Patient_is_willin_to_have_study_MRI__c && (preObj.ECOG_Score__c == '0-Asymptomatic' || preObj.ECOG_Score__c == '1-Symptomatic but ambulatory')){
            preObj.Patient_is_eligible_to_be_screened_for_t__c = true;
            system.debug('__preObj.Patient_is_eligible_to_be_screened_for_t__c__IF__'+preObj.Patient_is_eligible_to_be_screened_for_t__c);
        } else {
            preObj.Patient_is_eligible_to_be_screened_for_t__c = false;
            preObj.Reason_for_not_signing_screening_consent__c = null;
            system.debug('__preObj.Patient_is_eligible_to_be_screened_for_t__c__else__'+preObj.Patient_is_eligible_to_be_screened_for_t__c);
        }
        
        if(preObj.Patient_is_eligible_to_be_screened_for_t__c == true && preObj.ECOG_Score__c == null){
            preObj.ECOG_Score__c.addError('Please Provide ECOG Score.');
            return null;
        }
        system.debug('__preObj.Patient_is_eligible_to_be_screened_for_t__c__'+preObj.Patient_is_eligible_to_be_screened_for_t__c);
        system.debug('__preObj.Reason_for_not_signing_screening_consent__c__'+preObj.Reason_for_not_signing_screening_consent__c);
        if(preObj.Patient_is_eligible_to_be_screened_for_t__c == true && preObj.Patient_signed_up_for_I_SPY2_screening__c == false && preObj.Reason_for_not_signing_screening_consent__c == null) {
            preObj.Reason_for_not_signing_screening_consent__c.addError('Please give the reason if patient not signing Screening consent form or Uncheck the "Patient signed up for I-SPY2 screening?" checkbox.');
            return null;
        }
        
        if(selectedSite == null){
            preObj.addError('Please select site.');
            return null;
        }
        system.debug('__preObj.Patient_is_eligible_to_be_screened_for_t__c__IF__'+preObj.Patient_is_eligible_to_be_screened_for_t__c);
        //Added by  Shruti (DE401)
        try {  
        preObj.Site__c = selectedSite;
        update preObj;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);            
            Pagereference ref = new Pagereference('/apex/PreEligibilityChecklist?id='+preEligibilityId);
            ref.setRedirect(true);
             return ref;            
        }
        preObj = [Select Institution__c, Site__c, Site__r.Name, Trial__c, TrialPatient__c, p.X30_Days_Investigational_Agents__c, p.Status__c, p.RecordTypeId, p.Reason_for_not_signing_screening_consent__c, p.Phase__c, p.Patient_signed_up_for_I_SPY2_screening__c, p.Patient_is_willing_to_have_core_biospy__c, p.Patient_is_willin_to_have_study_MRI__c, p.Patient_is_eligible_to_be_screened_for_t__c, p.Patient_is_18_years_or_older__c, p.Patient__c, p.Other_investigational_agents__c, p.Not_had_prior_RT__c, p.Non_Pregnant_Not_Lactating__c, p.Name, p.Histologically_confirmed_invasive_cancer__c, p.Had_prior_cytotoxic_regimens_anticancer__c, p.Ferromegnatic_Prostheses__c, p.ECOG_Score__c, p.Cytotoxic_Regiments__c, p.CreatedDate, p.CreatedById, p.CompletedDate__c, p.Clinically_radiologically_measurable__c, p.CRF_Id__c From PreEligibility_Checklist__c p where id = : preEligibilityId];
        // Added by Shruti (DE401)
        if(nextTabName == 'saveAndClose') {
        preobj.First_Save_and_Close__c = true;
            //Added by  Shruti (DE401)
        
        // Added by Shruti (DE401)            
            //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+preObj.Patient__c+'&TrialId='+trialIdValue+'&sfdc.override=1');
            Pagereference pr = new Pagereference('/apex/TranscendPage?id='+preObj.Patient__c+'&TrialId='+preObj.Trial__c);
            pr.setRedirect(true);
            return pr;
        }
        currentTab = nextTabName;
        return null;
    }
    
    // public void previous(){
       public Pagereference previous(){ //Added by Shruti (DE401)
        String tabPrevious = Apexpages.currentPage().getParameters().get('tabPrevious');
        currentTab = tabPrevious;
        //Added by  Shruti (DE401)
       
                 if( preEligibilityId != null){
                    pathObj = [select Id, Status__c from PreEligibility_Checklist__c where id =: preEligibilityId];
                    if(pathObj != null && pathObj.Status__c == 'Approval Not Required'){
                    //System.debug('====bloodSpecimen===='+bloodSpecimen);
                    //System.debug('====bldSpecimenForm.Status__c===='+bldSpecimenForm.Status__c);
                    //System.debug('====bloodSpecimen===='+bloodSpecimen);
                    isComplete= false;
                    currentTab='CompleteTab';
                // Pagereference ref = new Pagereference('/apex/PreEligibilityChecklist?id='+preEligibilityId+'&PatientId='+preEligibilityId);
                Pagereference ref = new Pagereference('/'+preEligibilityId);
                ref.setRedirect(true);
                return ref;
             }
             }
      /*  try {  
        update preObj;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);            
            // Pagereference ref = new Pagereference('/apex/PreEligibilityChecklist?id='+preEligibilityId+'&PatientId='+preEligibilityId);
               Pagereference ref = new Pagereference('/'+preEligibilityId);
            ref.setRedirect(true);
             return ref;            
        }*/
             return null;
        // Added by Shruti (DE401)
    }
    
    /*public Pagereference complete(){
        List<RecordType> lstRecType = [select id,Name from RecordType where SobjectType = 'PreEligibility_Checklist__c' and Name = 'Live'];
        preObj.Status__c = 'Completed';
        preObj.RecordTypeId = lstRecType[0].Id;
        update preObj;
        Pagereference pr = new Pagereference('/'+preObj.Id);
        return pr;
    }*/
    
    public Pagereference signAndSubmit() {
         
        List<RecordType> lstRecType = [select id,Name from RecordType where SobjectType = 'PreEligibility_Checklist__c' and Name = 'Live'];
        preObj.Status__c = 'Completed';
        preObj.CompletedDate__c = System.today();
        preObj.RecordTypeId = lstRecType[0].Id;
        update preObj;
        
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00008','',preObj.Id+'','');
        system.debug('errorMsg :  '+signSubmit.errorMsg);
        errorMsg = signSubmit.errorMsg;
        isDelete= true;  // For Delete //
        msgColor = 'Red';
        system.debug('__preObj.Patient_is_eligible_to_be_screened_for_t__c__IF__'+preObj.Patient_is_eligible_to_be_screened_for_t__c);  
        return ref;
    }
    public String msgColor {get;set;}
    public void resendCode() {
        SignAndSubmitController ctr = new SignAndSubmitController();
        ctr.resendCode();
        errorMsg = 'Code Sent! Please check your Email.';
        msgColor = 'Green';
    }
}