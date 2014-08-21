public with sharing class OnStudyEligibilityFormsNew extends PageControllerBase {
    
    public transient List<PreEligibility_Checklist__c> lstPre{get;set;}
    private List<On_Study_Eligibility_Form__c> lstCloneEligibility{get;set;}
    public Boolean isSigned{get; set;}
    public On_Study_Eligibility_Form__c ose{get; set;}
    public String TrialPatId {get;set;}
    private String patientId {get;set;}
    public Boolean isErrorMsg {get;set;}
    public String errorMsg1 {get;set;}
    public List<Patient_Custom__c> lstPat;
    public String currentTab {get;set;} 
    public Id onStudyEleId {get;set;}
    public String errorMsg {get;set;}
    public String password {get;set;}
    public Boolean isComplete {get;set;}
    public Boolean isShowEditButton{get;set;}
    private Id clonedCRFId{get;set;}
    public String nextTabName{get;set;}
    private String trailPat{get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    public String profileName{get;set;}
    public Boolean isDelete{get;set;}
    
    public AdditionalQuestionController addQuesController {set;
    get{
        //get the map, then the component controller using the appropriate key
        if(getComponentControllerMap()!=null){
          AdditionalQuestionController addQues;
          addQues = (AdditionalQuestionController )getComponentControllerMap().get('addQues');
          if(addQues!= null)
             return addQues;
        }
        //just in case something goes wrong return something...this can be handled better
        return new AdditionalQuestionController(); 
    }
  }
  public void callAddQuesControllerMethod(Id latId) {
    system.debug('addQuesController : '+addQuesController);
    addQuesController.saveComponent(latId);  
  }
     public pagereference redirect(){
    pagereference redirect = new pagereference('/apex/OnStudyEligibilityFormsNewPdf?id='+onStudyEleId);
    redirect.setRedirect(true);
    return redirect;
}
    public OnStudyEligibilityFormsNew(Apexpages.standardcontroller oselig){
        System.debug('OnStudyEligibilityForm-------'+oselig.getId());
        onStudyEleId = oselig.getId();
        On_Study_Eligibility_Form__c onStdElgbiltyFrmObj;
        if(onStudyEleId != null)onStdElgbiltyFrmObj = [Select o.TrialPatient__c From On_Study_Eligibility_Form__c o where id =: onStudyEleId];
        
        IsDelete = false;
        IsDelete();
        if (IsDelete){
            String currentUserId = UserInfo.getUserId();
            for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
                profileName = u.Profile.Name; 
            }  
         }  
        isShowEditButton = false;
        ose = new On_Study_Eligibility_Form__c();
        //List<Patient_Custom__c> lstPat = new List<Patient_Custom__c>();
        isSigned = false;
        isErrorMsg = false;
        isComplete = true;
        
        if(onStdElgbiltyFrmObj != null){
            trailPat = onStdElgbiltyFrmObj.TrialPatient__c;
            onStudyEleId = onStdElgbiltyFrmObj.id;
        }else{
            trailPat = Apexpages.currentPage().getParameters().get('trialPat');
            onStudyEleId = Apexpages.currentPage().getParameters().get('onStudyEleId');
        }
        if(trailPat != null){
            ose.TrialPatient__c = trailPat;
            List<TrialPatient__c> lstTrailPat = [select id,Patient_Id__c,Site__c,Trial_Id__c, Name, Trial_Id__r.Name from TrialPatient__c where Id = : trailPat];
            if(!lstTrailPat.IsEmpty()) {
                trialPatientObj = lstTrailPat[0];
                patientId = lstTrailPat[0].Patient_Id__c;
                lstPre = [select id,Patient_signed_up_for_I_SPY2_screening__c,Clinically_radiologically_measurable__c,ECOG_Score__c,Ferromegnatic_Prostheses__c,Histologically_confirmed_invasive_cancer__c,Non_Pregnant_Not_Lactating__c,Patient_is_eligible_to_be_screened_for_t__c,X30_Days_Investigational_Agents__c,Patient_is_willing_to_have_core_biospy__c,Cytotoxic_Regiments__c,Not_had_prior_RT__c,Patient_is_18_years_or_older__c,Patient_is_willin_to_have_study_MRI__c,Patient__c from PreEligibility_Checklist__c where Patient__c = : lstTrailPat[0].Patient_Id__c];
                System.debug('lstPre-----------'+lstPre);
            }
            if(!lstPre.isEmpty()) {
                System.debug('------------>'+lstPre[0].Patient_signed_up_for_I_SPY2_screening__c);
                if(lstPre[0].Patient_signed_up_for_I_SPY2_screening__c){
                    isSigned = lstPre[0].Patient_signed_up_for_I_SPY2_screening__c;
                }
            }
            /*lstPat = [select id,Signed_Screening__c from Patient_Custom__c where id = : lstTrailPat[0].Patient_Id__c];
            System.debug('------------>'+lstPat[0].Signed_Screening__c);
            if(lstPat[0].Signed_Screening__c){
                System.debug('------------>'+lstPat[0].Signed_Screening__c);
                isSigned = lstPat[0].Signed_Screening__c;
            }*/
            /*if(!lstPat.isEmpty()){
                lstPre = [select id,Clinically_radiologically_measurable__c,ECOG_Score__c,Ferromegnatic_Prostheses__c,Histologically_confirmed_invasive_cancer__c,Non_Pregnant_Not_Lactating__c,Patient_is_eligible_to_be_screened_for_t__c,X30_Days_Investigational_Agents__c,Patient_is_willing_to_have_core_biospy__c,Cytotoxic_Regiments__c,Not_had_prior_RT__c,Patient_is_18_years_or_older__c,Patient_is_willin_to_have_study_MRI__c,Patient__c from PreEligibility_Checklist__c where Patient__c = : lstPat[0].Id];
            }*/
        }
        if(onStudyEleId != null){
            ose = [Select o.Root_CRF_Id__c,o.OriginalCRF__c, o.Status__c, o.TrialPatient__c,o.CRF__c, o.Total_Bilirubin_within_institutional__c, o.Screening_Memogram_Prior_to_Mass_Detect__c, o.PreEligibility_Checklist__c, o.Platelets_100_000_L__c, o.Patient_is_18_years_or_older__c,o.Other_Reason_for_Cancer_first_detected__c, o.Not_had_a_sentinel_lymph_node__c, o.No_uncontrolled_intercurrent_illness__c,o.No_history_of_allergic_reactions__c,o.No_Uncontrolled_or_Cardiovascular_Diseas__c, o.No_Clinical_Or_Imaging_Evidence__c, o.Name, o.Most_Recent_Date__c, o.Mass_Identification_Date__c, o.Leukocytes_3000_L__c, o.LastModifiedDate, o.LastModifiedById, o.Lab_Values__c, o.Is_willing_to_have_study_core_biopsy__c, o.Is_mass_palpable__c,o.Id,o.How_was_the_cancer_first_detected__c,o.Histologically_confirmed_invasive_cancer__c,o.Creatinine_1_5_x_institutional_ULN__c, o.CompletedDate__c,o.Absolute_Neutrophil_count_1500_L__c, o.AST_SGOT_or_ALT_SGPT_1_5_x_insti__c From On_Study_Eligibility_Form__c o where o.Id = : onStudyEleId];
            lstCloneEligibility = [select Id, Status__c,Root_CRF_Id__c from On_Study_Eligibility_Form__c where OriginalCRF__c =:onStudyEleId and Status__c = 'Cloned'];
            if(!lstCloneEligibility.isEmpty()) {
                isShowEditButton = true;
                clonedCRFId = lstCloneEligibility[0].Id;
           } 
        } else {
            ose = new On_Study_Eligibility_Form__c();
            ose.TrialPatient__c = trailPat;
              
      }
        isComplete = CRFUtilities.isReadOnlyUsr(); 
        if(ose != null){
            //String crfId = ose.CRF__c;
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = ose.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    currentTab = 'Complete';
                    isComplete = false;
                } else {
                    currentTab = 'StudyChecklist';
                }
            //}
        }
    }
    
    public void isDelete(){
        On_Study_Eligibility_Form__c OnstudySpecimenForm;
        System.debug('====== MeoSpecimenId=======' + onStudyEleId);
        if(onStudyEleId!= null){
        OnstudySpecimenForm= [select Id, Status__c from On_Study_Eligibility_Form__c where id =: onStudyEleId];
            
            if(OnstudySpecimenForm.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
     }
    public Pagereference CRFinsert(){
        //trailPat = Apexpages.currentPage().getParameters().get('trialPat');
         
        
        if(onStudyEleId == null){
            ose = new On_Study_Eligibility_Form__c();
            ose.TrialPatient__c = trailPat;
            RequiredFieldHandler.fromDataLoader = true;
            try {
                insert ose;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                return null;
            }
            
            //Pagereference pr = new Pagereference('/apex/OnStudyEligibilityFormsNew?trialPat='+trailPat+'&onStudyEleId='+ose.Id);
            Pagereference pr = new Pagereference('/'+ose.Id);
            //pr.getParameters().put('nooverride', '1');
            pr.setRedirect(true);
            return pr;
        } 
        return null;
    }
    
    public Pagereference next(){
        system.debug('inside next-------');
        String tabNext = Apexpages.currentPage().getParameters().get('tabNext');
        if(tabNext != null) {
            nextTabName = tabNext;
        }
        system.debug('__nextTabName__'+nextTabName);
        system.debug('__currentTab__'+currentTab);
        system.debug('__ose.Screening_Memogram_Prior_to_Mass_Detect__c__'+ose.Screening_Memogram_Prior_to_Mass_Detect__c);
        isErrorMsg = false;
        
        if(currentTab == 'StudyChecklist'){
            lstPre = [select id,Patient_signed_up_for_I_SPY2_screening__c,Clinically_radiologically_measurable__c,ECOG_Score__c,Ferromegnatic_Prostheses__c,Histologically_confirmed_invasive_cancer__c,Non_Pregnant_Not_Lactating__c,Patient_is_eligible_to_be_screened_for_t__c,X30_Days_Investigational_Agents__c,Patient_is_willing_to_have_core_biospy__c,Cytotoxic_Regiments__c,Not_had_prior_RT__c,Patient_is_18_years_or_older__c,Patient_is_willin_to_have_study_MRI__c,Patient__c from PreEligibility_Checklist__c where Patient__c = :patientId];
            if(lstPre != null && !lstPre.isEmpty()){
                System.debug('------Next------>');
                if(isSigned){
                    ose.Clinically_or_radiologically_measurable__c = lstPre[0].Clinically_radiologically_measurable__c;
                    ose.No_ferromagnetic_prostheses__c = lstPre[0].Ferromegnatic_Prostheses__c;
                    ose.Histologically_confirmed_invasive_cancer__c = lstPre[0].Histologically_confirmed_invasive_cancer__c;
                    ose.Non_pregnant_and_non_lactating__c = lstPre[0].Non_Pregnant_Not_Lactating__c;
                    ose.Eligible_to_be_screened_for_the_study__c = lstPre[0].Patient_is_eligible_to_be_screened_for_t__c;
                    ose.Not_had_other_investigational_agents__c = lstPre[0].X30_Days_Investigational_Agents__c;
                    ose.Is_willing_to_have_study_core_biopsy__c = lstPre[0].Patient_is_willing_to_have_core_biospy__c;
                    ose.Not_had_prior_cytotoxic_regimens__c = lstPre[0].Cytotoxic_Regiments__c;
                    ose.Not_had_prior_RT_to_the_ipsilateral__c = lstPre[0].Not_had_prior_RT__c;
                    ose.Patient_is_18_years_or_older__c = lstPre[0].Patient_is_18_years_or_older__c;
                    ose.Patient_is_willing_to_have_study_MRI__c = lstPre[0].Patient_is_willin_to_have_study_MRI__c;
                    ose.ECOG_Score__c = lstPre[0].ECOG_Score__c;
                }
                try {
                    upsert ose;
                }catch (Exception e) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    Apexpages.addMessage(msg);
                    // Added by Shruti (DE401)
             // Pagereference ref = new Pagereference('/apex/OnStudyEligibilityFormsNew?id='+onStudyEleId);
             Pagereference ref = new Pagereference('/'+onStudyEleId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
                }
                callAddQuesControllerMethod(ose.Id);
                Map<Id,Set<Id>> agentQuestionMap = new Map<Id,Set<Id>>();
                List<Agent__c> lstAgent = [Select Id,Name,(Select Id,Question__c,Type__c From QuestionAnswers__r) From Agent__c a]; 
                for(Agent__c agent : lstAgent) {
                    Set<Id> quesIds = new Set<Id>();
                    System.debug('---arm.Name----->'+agent.Name);
                    System.debug('----arm.AdditionalQuestions__r----->'+agent.QuestionAnswers__r.size()); 
                    List<QuestionAnswer__c> lstAddQues = agent.QuestionAnswers__r;
                    for(QuestionAnswer__c addQues : lstAddQues) {
                        if(addQues.Type__c == 'Question'){
                            quesIds.add(addQues.Id);
                        }
                    }
                    agentQuestionMap.put(agent.Id, quesIds);
                }
                Map<Id,String> queAnsMap = new Map<Id,String>(); 
                List<CRFAdditionalQuestion__c> lstCrfAddQue = [select id,CRFId__c,QuestionAnswer__c, Answer__c from CRFAdditionalQuestion__c where CRFId__c = :ose.Id];
                for(CRFAdditionalQuestion__c crfAddQue : lstCrfAddQue){
                    queAnsMap.put(crfAddQue.QuestionAnswer__c,crfAddQue.Answer__c);
                }
                List<Agent_Patient_Eligibility__c> lstAgentPat = new List<Agent_Patient_Eligibility__c>();
                System.debug('----lstAgent----->'+lstAgent.size()); 
                for(Agent__c agent : lstAgent) {
                    integer countTrueFlag = 0;
                    set<Id> setQueIds = agentQuestionMap.get(agent.Id);
                    System.debug('----setQueIds----->'+setQueIds.size()); 
                    for(Id queId : setQueIds){
                        String ans = queAnsMap.get(queId);
                        System.debug('----ans----->'+ans); 
                        if(ans == 'true') {
                            System.debug('----Count----->');
                            ++countTrueFlag;
                        } else {
                            System.debug('----Break----->');
                            break;
                        }
                    }
                    System.debug('-----countTrueFlag------->'+countTrueFlag);
                    System.debug('-----setQueIds.size()------->'+setQueIds.size());
                    if(countTrueFlag == setQueIds.size() && countTrueFlag != 0 && setQueIds.size() != 0) {
                        System.debug('----Same length----->');
                        Agent_Patient_Eligibility__c agentPat = new Agent_Patient_Eligibility__c();
                        agentPat.Agent__c = agent.Id;
                        if(TrialPatId != null && TrialPatId != ''){ 
                            agentPat.TrialPatient__c = TrialPatId;
                        }
                        agentPat.AssignedToPatient__c = false;
                        lstAgentPat.add(agentPat);
                    }
                }
                if(!lstAgentPat.isEmpty()){
                    System.debug('----Inserted---->');
                    insert lstAgentPat;
                }
                //Pagereference pr = new Pagereference('/'+ose.Id);
                //pr.getParameters().put('nooverride', '1'); 
            }
        } else if(currentTab == 'Methodofdetection'){
            Boolean isValid = methodOfDetectionValidation();
            if(!isValid) {
                return null;
            } else {
                try {
                    update ose;
                }catch (Exception e) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    Apexpages.addMessage(msg);
                     // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/OnStudyEligibilityFormsNew?id='+onStudyEleId);
             Pagereference ref = new Pagereference('/'+onStudyEleId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
                }
            }
        } 
        if(nextTabName == 'Complete'){
            lstPre = [select id,Patient_signed_up_for_I_SPY2_screening__c,Clinically_radiologically_measurable__c,ECOG_Score__c,Ferromegnatic_Prostheses__c,Histologically_confirmed_invasive_cancer__c,Non_Pregnant_Not_Lactating__c,Patient_is_eligible_to_be_screened_for_t__c,X30_Days_Investigational_Agents__c,Patient_is_willing_to_have_core_biospy__c,Cytotoxic_Regiments__c,Not_had_prior_RT__c,Patient_is_18_years_or_older__c,Patient_is_willin_to_have_study_MRI__c,Patient__c from PreEligibility_Checklist__c where Patient__c = :patientId];
            callAddQuesControllerMethod(ose.Id);
            //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
            //completeCrf.customAdhoc(ose.Id+'', 'submit', 'Site');
            try {
                update ose;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
             // Pagereference ref = new Pagereference('/apex/OnStudyEligibilityFormsNew?id='+onStudyEleId);
             Pagereference ref = new Pagereference('/'+onStudyEleId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
            }
        } 
        if(nextTabName == 'saveAndClose'){
 //================================== For Save & Close Functionality====================       
         ose.First_Save_and_Close__c = true;
        try {
            update ose;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/OnStudyEligibilityFormsNew?id='+onStudyEleId);
             Pagereference ref = new Pagereference('/'+onStudyEleId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
        }
          
 //=====================================================================================      
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:trailPat];
            if(!trialPatList.isEmpty()) {
                Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
                //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
                pr.setRedirect(true);
                return pr;
            }
        }
        currentTab = nextTabName;
        system.debug('__currentTab__'+currentTab);
        lstPre = [select id,Patient_signed_up_for_I_SPY2_screening__c,Clinically_radiologically_measurable__c,ECOG_Score__c,Ferromegnatic_Prostheses__c,Histologically_confirmed_invasive_cancer__c,Non_Pregnant_Not_Lactating__c,Patient_is_eligible_to_be_screened_for_t__c,X30_Days_Investigational_Agents__c,Patient_is_willing_to_have_core_biospy__c,Cytotoxic_Regiments__c,Not_had_prior_RT__c,Patient_is_18_years_or_older__c,Patient_is_willin_to_have_study_MRI__c,Patient__c from PreEligibility_Checklist__c where Patient__c = :patientId];
        System.debug('lstPre------'+lstPre.size());
        return null;
    }
    
    // public void previous(){
       public Pagereference previous(){
        String tabPrevious = Apexpages.currentPage().getParameters().get('tabPrevious');
        currentTab = tabPrevious;
        lstPre = [select id,Patient_signed_up_for_I_SPY2_screening__c,Clinically_radiologically_measurable__c,ECOG_Score__c,Ferromegnatic_Prostheses__c,Histologically_confirmed_invasive_cancer__c,Non_Pregnant_Not_Lactating__c,Patient_is_eligible_to_be_screened_for_t__c,X30_Days_Investigational_Agents__c,Patient_is_willing_to_have_core_biospy__c,Cytotoxic_Regiments__c,Not_had_prior_RT__c,Patient_is_18_years_or_older__c,Patient_is_willin_to_have_study_MRI__c,Patient__c from PreEligibility_Checklist__c where Patient__c = :patientId];
        // Added by Shruti (DE401)
             try {
                    update ose;
                }catch (Exception e) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    Apexpages.addMessage(msg);                     
            // Pagereference ref = new Pagereference('/apex/OnStudyEligibilityFormsNew?id='+onStudyEleId);
             Pagereference ref = new Pagereference('/'+onStudyEleId);
            ref.setRedirect(true);
             return ref;             
                }
                return null;
              // Added by Shruti (DE401)
    }
    
    public Pagereference customCancel(){
        //String trailPat = Apexpages.currentPage().getParameters().get('trialPat');
        List<TrialPatient__c> lstTrailPat = [select id,Patient_Id__c,Site__c,Trial_Id__c,Name from TrialPatient__c where Id = : trailPat];
        if(ose.Id == null){
            //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+lstTrailPat[0].Patient_Id__c+'&TrialId='+lstTrailPat[0].Trial_Id__c);
            Pagereference pr = new Pagereference('/apex/TranscendPage?id='+lstTrailPat[0].Patient_Id__c);
            return pr;
        } else if(ose.Id != null){
            List<On_Study_Eligibility_Form__c> lstOse = [select id, Root_CRF_Id__c,OriginalCRF__c from On_Study_Eligibility_Form__c where id = : ose.Id];
            if(!lstOse.isEmpty()){
             /*   if(lstOse[0].OriginalCRF__c == null) {
                    delete lstOse[0];*/
                    
               //-------------------------for delete------------------------------//    
                if( ose.Id != null) {
                    // Added by Shruti (DE401)
             try {
                   delete new On_Study_Eligibility_Form__c(id=ose.Id); 
                }catch (Exception e) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    Apexpages.addMessage(msg);                     
            // Pagereference ref = new Pagereference('/apex/OnStudyEligibilityFormsNew?id='+onStudyEleId);
             Pagereference ref = new Pagereference('/'+onStudyEleId);
            ref.setRedirect(true);
             return ref;             
                }
               // return null;
              // Added by Shruti (DE401)                       
                } 
                //-------------------------for delete------------------------------//    
                /* else {
                    lstOse[0].Status__c = 'rejected';
                    update lstOse[0];
                }*/
            }
            Pagereference pr = new Pagereference('/apex/TranscendPage?id='+lstTrailPat[0].Patient_Id__c+'&TrialId='+lstTrailPat[0].Trial_Id__c);
            //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+lstTrailPat[0].Patient_Id__c);
            return pr;
        } else {
            return null;
        }
    }
    
    public Pagereference signAndSubmit() {
        Boolean isValidMethodOfDetection = methodOfDetectionValidation();
        if(!isValidMethodOfDetection) {
            currentTab = 'Methodofdetection';
            return null;
        }
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00009','',ose.Id+'', 'Site');
        system.debug('errorMsg :  '+signSubmit.errorMsg); 
        errorMsg1 = signSubmit.errorMsg;
        msgColor = 'Red';
        return ref;
    }
    public String msgColor {get;set;}
    public void resendCode() {
        SignAndSubmitController ctr = new SignAndSubmitController();
        ctr.resendCode();
        errorMsg1 = 'Code Sent! Please check your Email.';
        msgColor = 'Green';
    }
    //=======================Edit main CRF After rejecting by DCC============================================================
        
    public Pagereference cloneCRF() {
        //String clonedCRFId = CloneBuilder.cloneMe(ose.Id, '0', '');
        ose.Status__c = 'Not Completed';
        try {
            update ose;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            return null;
        }
        isComplete = true;
        return null;
    }
    
    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstCloneEligibility[0].Status__c = 'Not Completed';
            try {
                update lstCloneEligibility[0];
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/OnStudyEligibilityFormsNew?id='+onStudyEleId);
             Pagereference ref = new Pagereference('/'+onStudyEleId);
            ref.setRedirect(true);
             return ref;
               // Added by Shruti (DE401)
            }
        }
        currentTab = 'StudyChecklist';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/OnStudyEligibilityFormsNew?trialPat='+trailPat+'&onStudyEleId='+clonedCRFId);
        ref.setRedirect(true);
        return ref;
    }
    
    private Boolean methodOfDetectionValidation() {
        Boolean isValidFlag = true;
        if((ose.How_was_the_cancer_first_detected__c == 'Screening mammogram' || ose.How_was_the_cancer_first_detected__c == 'Screening MRI') && (ose.Is_mass_palpable__c == null)){
            errorMsg = 'Please select mass palpable.';
            isErrorMsg = true;
            isValidFlag = false;
        }
        else if(ose.How_was_the_cancer_first_detected__c == null){
            errorMsg = 'Please select How was the cancer first detected?';
            ose.How_was_the_cancer_first_detected__c.addError('Please select How was the cancer first detected?');
            isErrorMsg = true;
            isValidFlag = false;
        }
         else if((ose.Screening_Memogram_Prior_to_Mass_Detect__c && ose.Most_Recent_Date__c == null) || (!ose.Screening_Memogram_Prior_to_Mass_Detect__c && ose.Most_Recent_Date__c != null)){
            errorMsg = 'Please provide Most Recent Date for Memogram or check Screening Memogram Prior to Mass Detect.';
            isErrorMsg = true;
            isValidFlag = false;
        } 
        return isValidFlag;
    }
}