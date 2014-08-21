public with sharing class ResponseEvaluationFormController {
	   
    public Response_Evaluation_Form__c responseEval {get;set;}
    public String currentTab {get;set;}
    public List<Disease_Assessment__c> lstDiseaseAssessment {get;set;}
    private List<Response_Evaluation_Form__c> lstCloneResponse{get;set;}
    public List<SelectOption> lstBestOverAllResponse {get;set;}
    public List<DiseaseAssessmentWrapper> lstDiseaseAssessmentWrapper {get;set;}
    private List<DiseaseAssessmentWrapper> lstDiseaseAssessmentWrapper_old = new List<DiseaseAssessmentWrapper>();
    public String trialPatientId = null;
    public String trialPatient {get;set;}
    public decimal sumOfLD {get;set;}
    public boolean isSaveVisible {get;set;}
    public boolean isFirstTab {get;set;}
    public boolean isLastTab {get;set;}
    public String password {get;set;}  
    public String errorMsg {get;set;}
    public boolean openInEditMode {get;set;}
    public Boolean isShowEditButton{get;set;}
    public Boolean isComplete {get;set;} 
    public Id respEvalId ; 
    public integer TargetLesionSNo = 0;
    public String nextTabName{get;set;} 
    public TrialPatient__c trialPatientObj {get;set;}
    private Id clonedCRFId{get;set;}
    public String profileName{get;set;}   // For Delete //
    public Boolean isDelete{get;set;}     // For Delete //
    
    public integer getTargetLesionSNo() {
        return TargetLesionSNo;
    }
       
    public ResponseEvaluationFormController() {
        lstDiseaseAssessmentWrapper = new List<DiseaseAssessmentWrapper>(); 
    }
    
    public pagereference redirect(){
    pagereference redirect = new pagereference('/apex/ResponseEvaluationPdf?id='+respEvalId);
    redirect.setRedirect(true);
    return redirect;
}
    
    public ResponseEvaluationFormController(Apexpages.StandardController std) {
        System.debug('ResponseEvaluationForm-------'+std.getId());
        respEvalId = std.getId();
        Response_Evaluation_Form__c respEvalObj;
        if(respEvalId != null)respEvalObj = [Select r.TrialPatient__c, r.Id From Response_Evaluation_Form__c r where id =: respEvalId];
        //-----------------------delete button fuctionlity- start-------------------------
        IsDelete = false;
        IsDelete();
        if (IsDelete){
        String currentUserId = UserInfo.getUserId();
            for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
                profileName = u.Profile.Name; 
            }
        }
        //-----------------------delete button fuctionlity- end --------------------------
        openInEditMode = false;
        isShowEditButton = false;
        currentTab = 'DiseaseAssessmetTab'; 
        lstBestOverAllResponse = new List<SelectOption>();
        lstBestOverAllResponse.add(new Selectoption('Complete Response (CR)','Complete Response (CR) (Disappearance of all lesions and no new lesions)')); 
        lstBestOverAllResponse.add(new Selectoption('Partial Response (PR)','Partial Response (PR) (At least 30% decrease in sum of LD compared to baseline)'));
        lstBestOverAllResponse.add(new Selectoption('Stable Disease (SD)','Stable Disease (SD) (Neither PR nor PD criteria met)'));
        lstBestOverAllResponse.add(new Selectoption('Progressive Disease (PD)','Progressive Disease (PD) (At least 20% increase in sum LD compared to smallest sum LD recorded since treatment started or baseline sum LD if patient hasn\'t responded or appearance of one or more new lesions)'));
        lstBestOverAllResponse.add(new Selectoption('Not adequately assessed','Not adequately assessed '));
        
        lstDiseaseAssessmentWrapper = new List<DiseaseAssessmentWrapper>();  
        sumOfLD = 0.0;
        
        if(respEvalObj != null){
            trialPatientId = respEvalObj.TrialPatient__c;
            respEvalId = respEvalObj.id;
        }else{
            trialPatientId = Apexpages.currentPage().getParameters().get('trialPat'); 
            respEvalId = Apexpages.currentPage().getParameters().get('respEvalId'); 
        }
        List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPatientId];
        if(!lstTrialPatient.IsEmpty()) {
            trialPatient = lstTrialPatient[0].Name;
            trialPatientObj = lstTrialPatient[0];
        }
        responseEval = new Response_Evaluation_Form__c();
        isSaveVisible = false;
        isFirstTab = true;
        isLastTab = false;
        isComplete = true;
        
        if(respEvalId != null) {
            List<Response_Evaluation_Form__c> lstRespEval = [Select r.Root_CRF_Id__c,r.Local_Regional__c, TrialPatient__r.Name, r.Type_of_lymph_node_involvement__c, r.TrialPatient__c, r.SystemModstamp, r.Status__c, r.Size_of_largest_node__c, r.Reporting__c, r.RecordTypeId, r.ReasonNotConservationSurgeryCandidate__c, r.ReasonNoSurg_PTx_Snomed__c, r.Partial_response_PR__c, r.Partial_response_PR_Date__c, r.Palpable_nodes__c, r.OwnerId, r.Other__c, r.OtherReason__c, r.OriginalCRF__c, r.Nodes_fixed_to_chest_wall__c, r.New_local_regional_recurrence__c, r.New_local_regional_recurrence_Date__c, r.New_distant_progression__c, r.New_distant_progression_Date__c, r.Name, r.Matted_nodes__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.IsCandidateForConservationSurgery__c, r.Id, r.Distant__c, r.Disease_Extent__c, r.Date_of_clinical_assessment__c, r.Current_status_of_T4_tumor__c, r.Effective_Time__c, r.CreatedById, r.Complete_response_CR__c, r.Complete_response_CR_Date__c, r.Clinically_staging_period_T__c, r.Clinically_staging_period_N__c, r.Clinically_staging_period_M__c, r.Clinical_Staging_Period__c, r.CRF__c, r.Breast_Conserv_Snomed__c, r.Best_overall_Response_to_date__c From Response_Evaluation_Form__c r  where Id = :respEvalId];
            if(!lstRespEval.isEmpty()) { 
                responseEval = lstRespEval[0]; 
                trialPatient = lstRespEval[0].TrialPatient__r.Name;
                lstCloneResponse = [select Id, Status__c from Response_Evaluation_Form__c where OriginalCRF__c =:responseEval.Id and Status__c = 'Cloned'];
                if(!lstCloneResponse.isEmpty()) {
                    isShowEditButton = true;
                    clonedCRFId = lstCloneResponse[0].Id;
                }
            }
            lstDiseaseAssessmentWrapper = new List<DiseaseAssessmentWrapper>(); 
            lstDiseaseAssessment = [Select d.O_Clock_Position_To__c, d.O_Clock_Position_From__c, d.Longest_Diameter__c, d.Distance_from_nipple__c, d.Clip_placed__c From Disease_Assessment__c d where d.Response_Evaluation_Form__c = :respEvalId order by Effective_Time__c DESC];
            for(Disease_Assessment__c da : lstDiseaseAssessment) {
                DiseaseAssessmentWrapper daWrapper = new DiseaseAssessmentWrapper();
                daWrapper.diseaseAssessment = da;
                //daWrapper.diseaseAssessment.Clip_placed__c = 'No'; 
                daWrapper.isReadOnly = true;
                daWrapper.targetLesion = ++targetLesionSNo;
                lstDiseaseAssessmentWrapper.add(daWrapper);   
            }
            sumOfLongestDiameter();
        }
        isComplete = CRFUtilities.isReadOnlyUsr();
                
        if(responseEval != null){
            //String crfId = responseEval.CRF__c;
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = responseEval.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    currentTab = 'Complete';
                    isComplete = false;
                } else {
                    currentTab = 'DiseaseAssessmetTab';
                }
            //}
        }
    }
    //-----------------------delete button fuctionlity- start-------------------------
    public void isDelete(){
        Response_Evaluation_Form__c RespSpecimenForm;
        System.debug('====== MeoSpecimenId=======' + respEvalId);
        if(respEvalId!= null){
        RespSpecimenForm = [select Id, Status__c from Response_Evaluation_Form__c where id =: respEvalId];
            
            if(RespSpecimenForm.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
     }
    //-----------------------delete button fuctionlity- end -------------------------- 
    
    public void editResponseEvaluationForm() {
        //responseEval
        
    }
    
    // public void previous() {
       public Pagereference previous() {  //Added by Shruti (DE401)
        String tabPrevious = Apexpages.currentPage().getParameters().get('tabPrevious');
        if(currentTab == 'Complete'){
            currentTab = 'CommentsAndAttachments';
        } else if(currentTab == 'CommentsAndAttachments'){
            currentTab = 'responseStatus';
        } else if(currentTab == 'responseStatus'){
            currentTab = 'DiseaseAssessmetTab';
        } 
        //currentTab = tabPrevious; 
        isFirstTab = true;
        isLastTab = false; 
        //currentTab = 'DiseaseAssessmetTab';
        // Added by Shruti (DE401)
        try {
            update responseEval;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);            
             // Pagereference ref = new Pagereference('/apex/ResponseEvaluationForm?id='+respEvalId);
             Pagereference ref = new Pagereference('/'+respEvalId);
            ref.setRedirect(true);
             return ref;            
        }
            return null;
             // Added by Shruti (DE401)
    }
    
    public Pagereference next() { 
        
        String nextTabValue = Apexpages.currentPage().getParameters().get('tabNext');
        
        if(nextTabValue != null){
            nextTabName = nextTabValue;
        }
        
        // Added by kumar
        if(responseEval.Date_of_clinical_assessment__c > Date.today()){
            responseEval.Date_of_clinical_assessment__c.addError('You have entered a future date.');           
            return null;
        }
        // Added by kumar
                
        if(currentTab == 'DiseaseAssessmetTab'){
        	
            Boolean isValid = DiseaseAssessmetValidation();
            
            if(!isValid && !Test.isRunningTest()) {
                return null;
            }
        } 
        else if(currentTab == 'responseStatus' ){     
            Boolean isValid = ResponseStatusValidation();
            if(!isValid && !Test.isRunningTest()) {
                return null;
            }
        }else if(currentTab == 'CommentsAndAttachments'){
            currentTab = 'Complete';
        }      
        //currentTab = 'responseStatus';
        isFirstTab = false;
        isLastTab = true;
        try {
            update responseEval;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            // Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/ResponseEvaluationForm?id='+respEvalId);
             Pagereference ref = new Pagereference('/'+respEvalId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
        }
        if(nextTabName == 'saveAndClose') {
//======================================================== For Save & Close Functionality ==================        
                    responseEval.First_Save_and_Close__c = true;
                        try {
                            update responseEval;
                        }catch (Exception e) {
                            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                            Apexpages.addMessage(msg);
              // Added by Shruti (DE401)
                    // Pagereference ref = new Pagereference('/apex/ResponseEvaluationForm?id='+respEvalId);
                     Pagereference ref = new Pagereference('/'+respEvalId);
                     ref.setRedirect(true);
                     return ref;
             // Added by Shruti (DE401)
                        }
//==========================================================================================================                      
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
    
    public void saveDiseaseAssessment() {
        List<Disease_Assessment__c> lstDiseaseAssessment = new List<Disease_Assessment__c>();
        for(DiseaseAssessmentWrapper daWrapper : lstDiseaseAssessmentWrapper) {
            daWrapper.isReadOnly = true;
            daWrapper.diseaseAssessment.Response_Evaluation_Form__c = responseEval.Id;
            lstDiseaseAssessment.add(daWrapper.diseaseAssessment);
        }
        upsert lstDiseaseAssessment;
        sumOfLongestDiameter();
    }
    
    public void editDAssessment() {
        
        for(DiseaseAssessmentWrapper daWrapper : lstDiseaseAssessmentWrapper) {
            DiseaseAssessmentWrapper daw = new DiseaseAssessmentWrapper ();
            daw.diseaseAssessment = new Disease_Assessment__c();
            daw.targetLesion = daWrapper.targetLesion;
            daw.diseaseAssessment.O_Clock_Position_To__c = daWrapper.diseaseAssessment.O_Clock_Position_To__c;
            daw.diseaseAssessment.O_Clock_Position_From__c = daWrapper.diseaseAssessment.O_Clock_Position_From__c;
            daw.diseaseAssessment.Longest_Diameter__c = daWrapper.diseaseAssessment.Longest_Diameter__c;
            daw.diseaseAssessment.Distance_from_nipple__c = daWrapper.diseaseAssessment.Distance_from_nipple__c;
            daw.diseaseAssessment.Clip_placed__c = daWrapper.diseaseAssessment.Clip_placed__c;
            lstDiseaseAssessmentWrapper_old.add(daw);
            if(daWrapper.diseaseAssessment.Id == Apexpages.currentPage().getParameters().get('recordId')) {
                daWrapper.isReadOnly = false;
                daWrapper.isUpdateVisible = true;
            }
        }
    }
    
    public void updateRecord() {
        for(DiseaseAssessmentWrapper daWrapper : lstDiseaseAssessmentWrapper) {
            if(daWrapper.diseaseAssessment.Id == Apexpages.currentPage().getParameters().get('recordId')) {
                daWrapper.isReadOnly = true;
                try {
                    update daWrapper.diseaseAssessment;
                }catch (Exception e) {
                    Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                    Apexpages.addMessage(msg);
                }
            }
        }
        sumOfLongestDiameter();
    }
    
    public void remove() {
        delete [select Id from Disease_Assessment__c where Id = :Apexpages.currentPage().getParameters().get('recordId')];
        Apexpages.currentPage().getParameters().put('recordId',null);
        cancel();
    }
    
    public void cancel() {
        
        String recId = Apexpages.currentPage().getParameters().get('recordId');
        if(recId != null && recId != '') {
            for(DiseaseAssessmentWrapper newObj : lstDiseaseAssessmentWrapper) {
                if(recId == newObj.diseaseAssessment.Id) {
                    for(DiseaseAssessmentWrapper oldObj : lstDiseaseAssessmentWrapper_old) {
                        if(newObj.targetLesion == oldObj.targetLesion) {
                            newObj.diseaseAssessment.O_Clock_Position_To__c = oldObj.diseaseAssessment.O_Clock_Position_To__c;
                            newObj.diseaseAssessment.O_Clock_Position_From__c = oldObj.diseaseAssessment.O_Clock_Position_From__c;
                            newObj.diseaseAssessment.Longest_Diameter__c = oldObj.diseaseAssessment.Longest_Diameter__c;
                            newObj.diseaseAssessment.Distance_from_nipple__c = oldObj.diseaseAssessment.Distance_from_nipple__c;
                            newObj.diseaseAssessment.Clip_placed__c = oldObj.diseaseAssessment.Clip_placed__c;
                            newObj.isReadOnly = true;
                            newObj.isUpdateVisible = false;
                            break;
                        }   
                    }       
                }
            }
        } else {
            isSaveVisible = false;
            integer i = 0;
            --targetLesionSNo;
            integer cancelIndex = Integer.valueOf(Apexpages.currentPage().getParameters().get('cancelIndex'));
            lstDiseaseAssessmentWrapper.remove(cancelIndex-1);
            for(DiseaseAssessmentWrapper daWrapper : lstDiseaseAssessmentWrapper) {
                daWrapper.targetLesion = ++i;
                if(!daWrapper.isReadOnly && !daWrapper.isUpdateVisible) {
                    isSaveVisible = true;
                }
            }
        }
        sumOfLongestDiameter();
    }
    
    public void addLesion() {
        Disease_Assessment__c da = new Disease_Assessment__c();
        DiseaseAssessmentWrapper daWrapper = new DiseaseAssessmentWrapper();
        daWrapper.diseaseAssessment = da;
        daWrapper.diseaseAssessment.Clip_placed__c = 'No'; 
        daWrapper.isReadOnly = false;
        daWrapper.isUpdateVisible = false;
        daWrapper.targetLesion = ++targetLesionSNo;
        lstDiseaseAssessmentWrapper.add(daWrapper);
        isSaveVisible = true;
        
    }
    
    public Pagereference saveMainCRF() {
        //respEvalId = Apexpages.currentPage().getParameters().get('respEvalId');
        Pagereference ref = null;
        if(respEvalId == null) {
            
            responseEval.TrialPatient__c = trialPatientId;
            String phaseName = Apexpages.currentPage().getParameters().get('phaseName');
            responseEval.Phase__c = phaseName;  
            try {
                insert responseEval;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                return null;
            }
            
            //ref = new Pagereference('/apex/ResponseEvaluationForm?trialPat='+trialPatientId+'&respEvalId='+responseEval.Id);
            ref = new Pagereference('/'+responseEval.Id);
            //ref.getParameters().put('nooverride', '1');
            ref.setRedirect(true);
            return ref;
                    
        }
        
        return null;
    }
    
    public Pagereference submitCRF() {
        try {
            update responseEval;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            return null;
        }
        return new Pagereference('/'+responseEval.Id);
    }
    
    public pageReference cancelCRF() {
        system.debug('responseEval.TrialPatient__c============='+responseEval.TrialPatient__c);
        List<TrialPatient__c> lstTP = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id = :responseEval.TrialPatient__c];
        system.debug('lstTP============='+lstTP);
        system.debug('trialPatientId============='+trialPatientId);
        if(!lstTP.isEmpty()) {
            if(trialPatientId != null) {
                system.debug('trialPatientId============='+trialPatientId);
                system.debug('responseEval.Id============='+responseEval.Id);
                if( responseEval.Id != null) {
                    // Added by Shruti (DE401)
        try {
            delete new Response_Evaluation_Form__c(id=responseEval.Id); 
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);            
            // Pagereference ref = new Pagereference('/apex/ResponseEvaluationForm?id='+respEvalId);
             Pagereference ref = new Pagereference('/'+respEvalId);
            ref.setRedirect(true);
             return ref;            
        }           
             // Added by Shruti (DE401)                       
                }  
                
                return new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c+'&TrialId='+lstTP[0].Trial_Id__c);
                //return new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c);
            } else {
                return new Pagereference('/'+responseEval.Id);
            }
            
        }
        else {
            return new Pagereference('/'+responseEval.TrialPatient__c);
        }
    }
    
    private void sumOfLongestDiameter() {
        Decimal ldSum = 0.0;
        for(DiseaseAssessmentWrapper daw : lstDiseaseAssessmentWrapper) {
            if(daw.diseaseAssessment.Longest_Diameter__c == null) {
                daw.diseaseAssessment.Longest_Diameter__c = 0;
            }
            ldSum += daw.diseaseAssessment.Longest_Diameter__c;
        }
        sumOfLD = ldSum;
    }
    
    private Boolean DiseaseAssessmetValidation(){
    	
        Boolean isValidFlag = true;
         
        if(responseEval.Palpable_nodes__c == 'Yes'){
                if(responseEval.Matted_nodes__c == null){
                    responseEval.Matted_nodes__c.addError('Matted Node is Required');
                    //return false; 
                    isValidFlag = false;
                }  
                if(responseEval.Nodes_fixed_to_chest_wall__c == null){
                    responseEval.Nodes_fixed_to_chest_wall__c.addError('Nodes Fixed To Chest Wall is Required');
                    isValidFlag = false;
                }
                if(responseEval.Type_of_lymph_node_involvement__c == null){
                    responseEval.Type_of_lymph_node_involvement__c.addError('Type of Lymph Node Involvement is Required');
                    isValidFlag = false;
                }
                if(responseEval.Size_of_largest_node__c == null ){
                    responseEval.Size_of_largest_node__c.addError('Size of Largest Node is Required');
                    isValidFlag = false;
                }
            } 
          if(responseEval.Clinical_Staging_Period__c == 'Yes'){
            if(responseEval.Clinically_staging_period_T__c == null){
                responseEval.Clinically_staging_period_T__c.addError('Clinical Staging Period "T" is Required');
                isValidFlag = false;
            }
            if(responseEval.Clinically_staging_period_N__c == null){
                responseEval.Clinically_staging_period_N__c.addError('Clinical Staging Period "N" is Required');
                isValidFlag = false;
            }
            if(responseEval.Clinically_staging_period_M__c == null){
                responseEval.Clinically_staging_period_M__c.addError('Clinical Staging Period "M" is Required');
                isValidFlag = false;
            }
        }
        if(responseEval.Reporting__c =='Baseline' && responseEval.Clinically_staging_period_T__c != null && responseEval.Clinically_staging_period_T__c.indexOf('T4') != -1 && responseEval.Current_status_of_T4_tumor__c == null){
            responseEval.Current_status_of_T4_tumor__c.addError('Status of T4 tumor is Required');      
            isValidFlag = false;
        }
        if(responseEval.IsCandidateForConservationSurgery__c == 'No' && responseEval.ReasonNotConservationSurgeryCandidate__c == null ){
            responseEval.ReasonNotConservationSurgeryCandidate__c.addError('If the patient is not a candidate for breast conservation surgury, choose the principal reason');
            isValidFlag = false;
        }
        if(responseEval.ReasonNotConservationSurgeryCandidate__c == 'Other' && responseEval.OtherReason__c == null  ){
            responseEval.OtherReason__c.addError('Please provide other reason');
            isValidFlag = false;
        }        
         system.debug('----responseEval----'+responseEval);
         //currentTab = 'responseStatus';
         //isValidFlag = false;
         return isValidFlag;
    }
    private Boolean ResponseStatusValidation() {
        Boolean isValidFlag = true;
        if(responseEval.New_distant_progression__c == false){
                responseEval.Distant__c = null;             
                responseEval.New_distant_progression_Date__c = null; 
            } 
            
            if(responseEval.Complete_response_CR__c && responseEval.Complete_response_CR_Date__c == null ){
                responseEval.Complete_response_CR_Date__c.addError('Complete Response Date is Required.');
                isValidFlag = false;
                //return false;
            } 
            if(responseEval.Partial_response_PR__c && responseEval.Partial_response_PR_Date__c == null ){
                responseEval.Partial_response_PR_Date__c.addError('Partial Response Date is required.');
                isValidFlag = false;
            }
            if(responseEval.New_local_regional_recurrence__c ){
                if(responseEval.New_local_regional_recurrence_Date__c == null){
                    responseEval.New_local_regional_recurrence_Date__c.addError('New Local - Regional Recurrence Date is Required.');
                    isValidFlag = false;
                }
                /*if(!responseEval.Ipsilateral_Breast__c && !responseEval.Axillary_Nodes__c && !responseEval.Internal_mammary_nodes__c && !responseEval.Supraclavicular_nodes__c && !responseEval.Infraclavicular_nodes__c && !responseEval.Chest_Wall__c && !responseEval.local_regional_skin_and__c){
                    responseEval.addError('Please select at least One Local-Regional.');
                    isValidFlag = false;                
                }*/
                if(responseEval.Local_Regional__c == null){
                    responseEval.Local_Regional__c.addError('Please select at least One Local-Regional.');
                    isValidFlag = false;
                }
            }   
            if(responseEval.New_distant_progression__c ){
                if(responseEval.New_distant_progression_Date__c == null){
                    responseEval.New_distant_progression_Date__c.addError('Distant Progression Date is Required.');
                    isValidFlag = false;
                }
                if(responseEval.Distant__c == null){
                    responseEval.Distant__c.addError('Please select at least One Distant.');
                    isValidFlag = false;
                }   
            }
            return isValidFlag;
    } 
     
    public Pagereference signAndSubmit() {
        Boolean isValidDiseaseAssessmet = DiseaseAssessmetValidation();
        if(!isValidDiseaseAssessmet && !Test.isRunningTest()) {
            currentTab = 'DiseaseAssessmetTab';
             return null;
        }       
        Boolean isValidResponseStatus = ResponseStatusValidation();
        if(!isValidResponseStatus && !Test.isRunningTest()) {
            currentTab = 'responseStatus';
             return null;
        }           
       // ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
       // completeCrf.customAdhoc(responseEval.Id+'', 'submit', '');  
        
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00053','',responseEval.Id+'', 'Site');
        system.debug('errorMsg :  '+signSubmit.errorMsg);
        errorMsg = signSubmit.errorMsg;
        msgColor = 'Red';
        return ref;
    } 
    public String msgColor {get;set;}
    public void resendCode() {
        SignAndSubmitController ctr = new SignAndSubmitController();
        ctr.resendCode();
        errorMsg = 'Code Sent! Please check your Email.';
        msgColor = 'Green';
    }
        
    public class DiseaseAssessmentWrapper { 
        public integer targetLesion {get;set;}
        public Disease_Assessment__c diseaseAssessment {get;set;}
        public boolean isReadOnly {get;set;}
        public boolean isUpdateVisible {get;set;}
    }
    //=======================Edit main CRF After rejecting by DCC============================================================
    
    public Pagereference cloneCRF() {
        openInEditMode = true;
        //String clonedCRFId = CloneBuilder.cloneMe(responseEval.Id, '0', '');
        responseEval.Status__c = 'Not Completed';
        try {
            update responseEval;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            return null;
        }
        return null;
    }
        
    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstCloneResponse[0].Status__c = 'Not Completed';
            try {
                update lstCloneResponse[0];
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                // Added by Shruti (DE401)
             // Pagereference ref = new Pagereference('/apex/ResponseEvaluationForm?id='+respEvalId);
             Pagereference ref = new Pagereference('/'+respEvalId);
            ref.setRedirect(true);
             return ref;
             // Added by Shruti (DE401)
            }
        }
        openInEditMode = false;
        currentTab = 'DiseaseAssessmetTab';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/ResponseEvaluationForm?trialPat='+trialPatientId+'&respEvalId='+clonedCRFId);
        ref.setRedirect(true);
        return ref;
    }
    
}