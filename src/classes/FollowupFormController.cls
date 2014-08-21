public with sharing class FollowupFormController {
        
    public String userName {get;set;}
    public String password {get;set;}
    public String errorMsg {get;set;}
    public String currentTab {get;set;}
    public Boolean isComplete{get; set;}
    public Id FupFormId {get;set;}
    public Followup_Form__c FF {get;set;}
        
    public List<TherapyWrapper> THRWrapperList {get;set;}
    public List<IrrdSiteWrapper> IRSWrapperList {get;set;}
     
    public integer irrSiteSNO = 0;
    public integer therapySNO = 0;
        
    public List<SelectOption> survivalStatusOptions {get;set;}
    public List<SelectOption> recurrenceProgressOptions {get;set;}
    public List<SelectOption> progressionLocalOptions {get;set;}
    public List<SelectOption> progressionDistantOptions {get;set;}
    public List<SelectOption> menopausalStatusOptions {get;set;}
    
    public String trialPat = null;
    public String trialPatient {get;set;}
    
    public String Age {get;set;}
    public boolean openInEditMode {get;set;}
    public String Menopaus {get;set;}
    
    public boolean dispAlive {get;set;}
    public boolean dispDeath {get;set;}
    public boolean displayProgTab {get;set;}
    public boolean displayRadiTab {get;set;}
    public boolean displayLongTab {get;set;}
    public boolean locprog {get;set;}
    public boolean distprog {get;set;}
//  public boolean locdistprog {get;set;}
    public boolean qlocprog {get;set;}
    public boolean qdistprog {get;set;}
    public boolean rule1 {get;set;}
    public boolean rule2 {get;set;}
    public boolean rule3 {get;set;}
    public boolean rule4 {get;set;}
    public boolean isShowEditButton{get;set;}
    public TrialPatient__c trialPatientObj {get;set;}
    public Patient_Custom__c PC;
    public Date NPLPDate;
    public Date NPDPDate;
    public String nextTabName{get;set;}
    private List<Followup_Form__c> lstCloneFollow{get;set;}
    private Id clonedCRFId{get;set;}
    public String profileName{get;set;}
    public Boolean isDelete{get;set;}
    public Followup_Form__c pathObj{get;set;}
    
        
    public FollowupFormController(Apexpages.StandardController std) {
        System.debug('FollowupForm-------'+std.getId());
        FupFormId = std.getId();
        Followup_Form__c FollowupFormObj;
        if(FupFormId != null)FollowupFormObj = [Select f.TrialPatient__c From Followup_Form__c f where id =: FupFormId];
        
        String currentUserId = UserInfo.getUserId();
        for(User u :[Select  Profile.Name , ProfileId, Id, Name From User where id =:currentUserId]){            
            profileName = u.Profile.Name; 
        } 
        openInEditMode = false;
        isDelete = false;
        isShowEditButton = false;
        currentTab = 'survstatTab';
        isComplete = true;
        nextTabName = null;
        
        if(FollowupFormObj != null){
            FupFormId = FollowupFormObj.id;
            trialPat = FollowupFormObj.TrialPatient__c;
        }else{
            FupFormId = Apexpages.currentPage().getParameters().get('fupformId'); 
            trialPat = Apexpages.currentPage().getParameters().get('trialPat');
        }
        
        if(trialPat != null) {
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPat];
            if(!lstTrialPatient.IsEmpty()) {
                trialPatientObj = lstTrialPatient[0];
            }
        }
        
        if (FF ==null ) FF = new Followup_Form__c();
                
        if(FupFormId == null && trialPat == null) {
            
            FupFormId = std.getId();
            List<Followup_Form__c> lstFollowupForm = [Select  f.Root_CRF_Id__c,f.test_radio_button_del__c, f.patient_have_a_menstrual_period__c, f.patient_diagnosed_local_progression__c, f.patient_diagnosed_distant_progression__c, f.age_50__c, f.Treatment_s_for_new__c, f.Total_dose_cGy_AP__c, f.Total_FX__c, f.Therapies_received__c, f.SystemModstamp, f.Survival_Status__c, f.Surgery__c, f.Surgery_Details__c, f.Start_Date__c, f.Sites_of_New_Progression__c, f.Sign_Submit__c, f.Recurrence_progression_information__c, f.Radiation_Therapy__c, f.Radiation_Therapy_Start_Date__c, f.Radiation_Therapy_End_Date__c, f.Radiation_Therapy_Details__c, f.Print_CRF_Form_after_Saving__c, f.Premenopausal_6_months__c, f.Postmenopausal_12_months__c, f.Perimenopausal_6_12months__c, f.Patient_received_adjuvant_therapy__c, f.Patient_doc_clinial_assessment__c, f.Patient_diagnose_with_new__c, f.Patient_Age_AP__c, f.OwnerId, f.Other__c, f.On_Estrogen_Replacement__c, f.On_Estrogen_Replacement_Years__c, f.On_Estrogen_Replacement_Months__c, f.Notice_of_Progression__c, f.New_Cancer__c, f.Name, f.Menopausal_status__c, f.Lost_to_Follow_Up__c, f.Long_Term_Therapy_for_primary_Trial__c, f.Local_progression_Date__c, f.Local__c, f.LastModifiedDate, f.LastModifiedById, f.LastActivityDate, f.IsDeleted, f.Id, f.Hysterectomy__c, f.Hysterectomy_Date__c, f.Hormone_Therapy__c, f.Hormone_Therapy_Details__c, f.End_Date__c, f.Dose_per_FX_cGy__c, f.Distant_progression_Date__c, f.Distant__c, f.Description__c, f.Describe_Cause_of_Death__c, f.Death_Details__c, f.Date_of_Last_Menstrual_period__c, f.Date_of_Last_Menstrual_period_UKData__c, f.Date_of_Last_Menstrual_period_UKData12M__c, f.Date__c, f.Effective_Time__c, f.CreatedById, f.Consent_for_follow_up_withdrawn__c, f.Comment__c, f.Clinical_assessment_Date__c, f.Chemotherapy__c, f.Chemotherapy_Details__c, f.Causeof_Death__c, f.Cause_of_Death__c, f.Bilateral_oophorectomy__c, f.Bilateral_oophorectomy_Date__c, f.Alive__c, f.Abv_Catg_not_Aplicable_age_50__c, Status__c, CompletedDate__c, CRF__c, CRF__r.Patient__c, TrialPatient__c,  
                        (Select Total_dose_cGy_AP__c,  Site__c, 
                        Name, Laterality__c, Id, Followup_Form__c, Dose_per_FX_cGy__c, CreatedDate, Total_FX__c From Irradiated_Sites__r ),
                        (Select Therapy__c, Start_Date_Date_Performed__c, Name, Id, Followup_Form__c, End_Date__c, Detail__c, CreatedDate From Therapy_Receiveds__r)
                        From Followup_Form__c f
                        where Id =: FupFormId
                        order by Effective_Time__c DESC ];      
                        
            if(!lstFollowupForm.isEmpty()) {
                trialPat = lstFollowupForm[0].TrialPatient__c;
            }
        }
                    
        if ( IRSWrapperList == null) IRSWrapperList = new List<IrrdSiteWrapper>{};
        if ( THRWrapperList == null) THRWrapperList = new List<TherapyWrapper>{};
            
        if ( FupFormId != null){
            FF = [Select  f.Root_CRF_Id__c,f.test_radio_button_del__c, f.patient_have_a_menstrual_period__c, f.patient_diagnosed_local_progression__c, f.patient_diagnosed_distant_progression__c, f.age_50__c, f.Treatment_s_for_new__c, f.Total_dose_cGy_AP__c, f.Total_FX__c, f.Therapies_received__c, f.SystemModstamp, f.Survival_Status__c, f.Surgery__c, f.Surgery_Details__c, f.Start_Date__c, f.Sites_of_New_Progression__c, f.Sign_Submit__c, f.Recurrence_progression_information__c, f.Radiation_Therapy__c, f.Radiation_Therapy_Start_Date__c, f.Radiation_Therapy_End_Date__c, f.Radiation_Therapy_Details__c, f.Print_CRF_Form_after_Saving__c, f.Premenopausal_6_months__c, f.Postmenopausal_12_months__c, f.Perimenopausal_6_12months__c, f.Patient_received_adjuvant_therapy__c, f.Patient_doc_clinial_assessment__c, f.Patient_diagnose_with_new__c, f.Patient_Age_AP__c, f.OwnerId, f.Other__c, f.On_Estrogen_Replacement__c, f.On_Estrogen_Replacement_Years__c, f.On_Estrogen_Replacement_Months__c, f.Notice_of_Progression__c, f.New_Cancer__c, f.Name, f.Menopausal_status__c, f.Lost_to_Follow_Up__c, f.Long_Term_Therapy_for_primary_Trial__c, f.Local_progression_Date__c, f.Local__c, f.LastModifiedDate, f.LastModifiedById, f.LastActivityDate, f.IsDeleted, f.Id, f.Hysterectomy__c, f.Hysterectomy_Date__c, f.Hormone_Therapy__c, f.Hormone_Therapy_Details__c, f.End_Date__c, f.Dose_per_FX_cGy__c, f.Distant_progression_Date__c, f.Distant__c, f.Description__c, f.Describe_Cause_of_Death__c, f.Death_Details__c, f.Date_of_Last_Menstrual_period__c, f.Date_of_Last_Menstrual_period_UKData__c, f.Date_of_Last_Menstrual_period_UKData12M__c, f.Date__c, f.Effective_Time__c, f.CreatedById, f.Consent_for_follow_up_withdrawn__c, f.Comment__c, f.Clinical_assessment_Date__c, f.Chemotherapy__c, f.Chemotherapy_Details__c, f.Causeof_Death__c, f.Cause_of_Death__c, f.Bilateral_oophorectomy__c, f.Bilateral_oophorectomy_Date__c, f.Alive__c, f.Abv_Catg_not_Aplicable_age_50__c, Status__c, CompletedDate__c, CRF__c, CRF__r.Patient__c, TrialPatient__c, OriginalCRF__c, 
            (Select Total_dose_cGy_AP__c, Site__c, 
                Name, Laterality__c, Id, Followup_Form__c, Dose_per_FX_cGy__c, CreatedDate , Total_FX__c From Irradiated_Sites__r ),
                  (Select Therapy__c, Start_Date_Date_Performed__c, Name, Id, Followup_Form__c, End_Date__c, Detail__c, CreatedDate From Therapy_Receiveds__r)
                   From Followup_Form__c f
                where Id =: FupFormId limit 1]  ;
                system.debug ( ' FF: '+ FF);
            lstCloneFollow = [select Id, Status__c from Followup_Form__c where OriginalCRF__c =:FupFormId and Status__c = 'Cloned'];
            if(!lstCloneFollow.isEmpty()) {
                isShowEditButton = true;
                clonedCRFId = lstCloneFollow[0].Id;
            }   
                
            PC = [Select p.Name, p.Last_Name__c, p.First_Name__c, p.Birthdate__c, p.Age__c 
                  From Patient_Custom__c p
                  where Id =: FF.CRF__r.Patient__c limit 1 ];
            Age = String.valueOf(PC.Age__c);
                                        
                
            irrSiteSNO = 0;
            List<Irradiated_Site__c> irsl = FF.Irradiated_Sites__r;     
            if ( irsl.size() > 0){
                for ( Irradiated_Site__c irs : irsl ){
                    IrrdSiteWrapper newIrswrapper  =  new IrrdSiteWrapper();
                    newIrswrapper.IRDSite = irs;
                    newIrswrapper.isReadOnly = true;
                    newIrswrapper.isUpdateVisible = false;
                    newIrswrapper.sno = String.valueOf(++irrSiteSNO);
                    IRSWrapperList.add(newIrswrapper );
                }
            }
                
            therapySNO = 0;     
            List<Therapy_Received__c> thrl = FF.Therapy_Receiveds__r;
            if ( thrl.size() > 0){
                for (Therapy_Received__c thr : thrl ){
                    TherapyWrapper newThywrapper  =  new TherapyWrapper();
                    newThywrapper.THRecvd = thr;
                    newThywrapper.isReadOnly = true;
                    newThywrapper.isUpdateVisible = false;
                    newThywrapper.sno = String.valueOf(++therapySNO);
                    THRWrapperList.add(newThywrapper );
                }
            }
                
        }   
        
        // FupFormId != null
        survivalStatusOptions = new List<Selectoption>();
        survivalStatusOptions.add(new Selectoption('Alive','Alive'));
        survivalStatusOptions.add(new Selectoption('Dead','Dead'));
        survivalStatusOptions.add(new Selectoption('Lost to Follow-up','Lost to Follow-up'));
        survivalStatusOptions.add(new Selectoption('Consent for Followup withdrawn','Consent for Followup withdrawn'));
        
        recurrenceProgressOptions = new List<Selectoption>();
        recurrenceProgressOptions.add(new Selectoption('Clinical Exam','Clinical Exam'));
        recurrenceProgressOptions.add(new Selectoption('Radiographic','Radiographic'));
        recurrenceProgressOptions.add(new Selectoption('Histologic','Histologic'));
        recurrenceProgressOptions.add(new Selectoption('Patient Self Report only','Patient Self Report only'));
        
        progressionDistantOptions = new List<Selectoption>();
        progressionDistantOptions.add(new Selectoption('Contralateral Breast','Contralateral Breast'));
        progressionDistantOptions.add(new Selectoption('Distant Lymph Nodes','Distant Lymph Nodes'));
        progressionDistantOptions.add(new Selectoption('Pleura','Pleura'));
        progressionDistantOptions.add(new Selectoption('Lung','Lung'));
        progressionDistantOptions.add(new Selectoption('Liver','Liver'));
        progressionDistantOptions.add(new Selectoption('Distant skin and SubcutaneousTissue','Distant skin and SubcutaneousTissue'));
        progressionDistantOptions.add(new Selectoption('Bone','Bone'));
        progressionDistantOptions.add(new Selectoption('Bone marrow','Bone marrow'));
        progressionDistantOptions.add(new Selectoption('Brain CNS','Brain CNS'));
        progressionDistantOptions.add(new Selectoption('Other','Other'));
                
        progressionLocalOptions = new List<Selectoption>();
        progressionLocalOptions.add( new Selectoption('Ipsilateral Breast','Ipsilateral Breast') );
        progressionLocalOptions.add( new Selectoption('Axillary Nodes','Axillary Nodes') );
        progressionLocalOptions.add( new Selectoption('Internal Mammary Nodes','Internal Mammary Nodes') );
        progressionLocalOptions.add( new Selectoption('Supraclavicular Nodes','Supraclavicular Nodes') );
        progressionLocalOptions.add( new Selectoption('Infraclavicular Nodes','Infraclavicular Nodes') );
        progressionLocalOptions.add( new Selectoption('Chest Wall','Chest Wall') );
        progressionLocalOptions.add( new Selectoption('Local regional Skin and SubcutaneousTissue','Local-regional Skin and Subcutaneous Tissue') );
        
        menopausalStatusOptions = new List<Selectoption>();
        menopausalStatusOptions.add( new Selectoption('Premenopausal(<6 months since LMP AND no prior bilateral ovariectomy AND not an estrogen replacement','Premenopausal(<6 months)') );
        menopausalStatusOptions.add( new Selectoption('Perimenopausal(6-12 months since LMP AND no priorbilateral ovariectomy AND not an estrogen replacement','Perimenopausal(6-12 months)') );
        menopausalStatusOptions.add( new Selectoption('Postmenopausal(prior bilateral ovariectomy OR >12 months since LMP AND no prior hysterectomy)','Postmenopausal(prior bilateral ovariectomy OR >12 months)') );
        menopausalStatusOptions.add( new Selectoption('Above categories not applicable AND Age < 50','Above categories not applicable AND Age < 50') );
        menopausalStatusOptions.add( new Selectoption('Above categories not applicable AND Age > 50','Above categories not applicable AND Age > 50') );

        isComplete = CRFUtilities.isReadOnlyUsr();      
        if(FF != null){
            //String crfId = FF.CRF__c;
            //if(crfId != null && crfId != ''){
                //String status = CRFUtilities.CRFStatus(crfId);
                String status = FF.Status__c;
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    currentTab = 'completeTab';
                    isComplete = false; 
                } 
            //}
        }
        
        //boolean for display Survival status
        dispAlive = false;
        dispDeath = false;
        if(FF.Survival_Status__c == 'Alive') {
            dispAlive = true;
        }
        if(FF.Survival_Status__c == 'Dead') {
            dispDeath = true;
        }
        
        //Rules for Displaying Tabs 
        displayProgTab = true;      
        displayRadiTab = true;
        displayLongTab = true;
                    
        //for displaying questions
        qlocprog = true;
        qdistprog = true;
        
        //for next/prev buttons
        locprog = false;
        distprog = false;
        rule4 =false;
        
        //  locdistprog = false;
            
        if (FF != null ){
            String PatientId  = FF.CRF__r.Patient__c ;
            List <Followup_Form__c> PastFollowupForms = [Select  f.test_radio_button_del__c, f.patient_have_a_menstrual_period__c, f.patient_diagnosed_local_progression__c, f.patient_diagnosed_distant_progression__c, f.age_50__c, f.Treatment_s_for_new__c, f.Total_dose_cGy_AP__c, f.Total_FX__c, f.Therapies_received__c, f.SystemModstamp, f.Survival_Status__c, f.Surgery__c, f.Surgery_Details__c, f.Start_Date__c, f.Sites_of_New_Progression__c, f.Sign_Submit__c, f.Recurrence_progression_information__c, f.Radiation_Therapy__c, f.Radiation_Therapy_Start_Date__c, f.Radiation_Therapy_End_Date__c, f.Radiation_Therapy_Details__c, f.Print_CRF_Form_after_Saving__c, f.Premenopausal_6_months__c, f.Postmenopausal_12_months__c, f.Perimenopausal_6_12months__c, f.Patient_received_adjuvant_therapy__c, f.Patient_doc_clinial_assessment__c, f.Patient_diagnose_with_new__c, f.Patient_Age_AP__c, f.OwnerId, f.Other__c, f.On_Estrogen_Replacement__c, f.On_Estrogen_Replacement_Years__c, f.On_Estrogen_Replacement_Months__c, f.Notice_of_Progression__c, f.New_Cancer__c, f.Name, f.Menopausal_status__c, f.Lost_to_Follow_Up__c, f.Long_Term_Therapy_for_primary_Trial__c, f.Local_progression_Date__c, f.Local__c, f.LastModifiedDate, f.LastModifiedById, f.LastActivityDate, f.IsDeleted, f.Id, f.Hysterectomy__c, f.Hysterectomy_Date__c, f.Hormone_Therapy__c, f.Hormone_Therapy_Details__c, f.End_Date__c, f.Dose_per_FX_cGy__c, f.Distant_progression_Date__c, f.Distant__c, f.Description__c, f.Describe_Cause_of_Death__c, f.Death_Details__c, f.Date_of_Last_Menstrual_period__c, f.Date_of_Last_Menstrual_period_UKData__c, f.Date_of_Last_Menstrual_period_UKData12M__c, f.Date__c, f.Effective_Time__c, f.CreatedById, f.Consent_for_follow_up_withdrawn__c, f.Comment__c, f.Clinical_assessment_Date__c, f.Chemotherapy__c, f.Chemotherapy_Details__c, f.Causeof_Death__c, f.Cause_of_Death__c, f.Bilateral_oophorectomy__c, f.Bilateral_oophorectomy_Date__c, f.Alive__c, f.Abv_Catg_not_Aplicable_age_50__c, Status__c, CompletedDate__c, CRF__c, CRF__r.Patient__c, TrialPatient__c,  
                                                        (Select Total_dose_cGy_AP__c,  Site__c, 
                                                        Name, Laterality__c, Id, Followup_Form__c, Dose_per_FX_cGy__c, CreatedDate, Total_FX__c From Irradiated_Sites__r ),
                                                        (Select Therapy__c, Start_Date_Date_Performed__c, Name, Id, Followup_Form__c, End_Date__c, Detail__c, CreatedDate From Therapy_Receiveds__r)
                                                        From Followup_Form__c f
                                                        where CRF__r.Patient__c =: PatientId and id!=:FupFormId and CreatedDate<=:FF.CreatedDate and status__c = 'Accepted'
                                                        order by Effective_Time__c DESC ];  
            if ( PastFollowupForms.size() > 1 ){
                    boolean rule1 = false;
                    boolean rule2 = false;
                    boolean rule3 = false;
                                                                        
                    for  (Followup_Form__c PastFF : PastFollowupForms){
                        system.debug( '__PastFF.Menopausal_status__c__'+PastFF.Menopausal_status__c);
                    if (( NPLPDate == null ) || (NPLPDate < PastFF.Local_progression_Date__c)) NPLPDate = PastFF.Local_progression_Date__c;
                    if((NPDPDate == null) || (NPDPDate < PastFF.Distant_progression_Date__c)) NPDPDate = PastFF.Distant_progression_Date__c;
                        
                        // rule 1a
                         if (rule1 == false  &&  rule2 == false && PastFF.patient_diagnosed_local_progression__c == true && PastFF.patient_diagnosed_distant_progression__c == false) {
                            //tab display
                            displayProgTab = true;
                            displayLongTab = true;
                            displayRadiTab = true;
                            //question display
                            qlocprog = false;
                            qdistprog = true;
                            // prev/ next
                            locprog = true;
                            distprog = false;
                            //locdistprog = false;
                            rule2 = true;
                        }
                        
                        // rule 1b
                        else if ( rule1 == false && rule3 == false &&
                        PastFF.patient_diagnosed_local_progression__c == false && PastFF.patient_diagnosed_distant_progression__c == true) {
                            //tab display
                            displayProgTab = true;
                            displayLongTab = false;
                            displayRadiTab = false;
                            //question display
                            qlocprog = true;
                            qdistprog = false;
                            // prev/ next
                            locprog = false;
                            distprog = true;
                            //locdistprog = false;
                            rule3 = true;
                        }
                        
                        // rule 1               
                        if ((PastFF.patient_diagnosed_local_progression__c == true && PastFF.patient_diagnosed_distant_progression__c == true) ||
                            (rule2 == true  && rule3 == true)) {
                            //tab display
                            displayProgTab = false;
                            displayLongTab = false;
                            displayRadiTab = false; 
                            //question display
                            qlocprog = false;   
                            qdistprog = false;  
                            // prev/ next
                            locprog = true;
                            distprog = true;
                            //locdistprog = true;
                            rule1 = true;
                            break;
                        }
                        
                        system.debug( 'rule1 :'+ rule1  +  'rule2 :'+ rule2  + 'rule3 :'+ rule3  );
                        system.debug( 'PastFF :'+ PastFF   );
                        //system.debug( '__PastFF.Menopausal_status__c__'+PastFF.Menopausal_status__c);
                        //rule 4
                        Menopaus = 'Postmenopausal(prior bilateral ovariectomy OR >12 months since LMP AND no prior hysterectomy)';
                        if(PastFF.Menopausal_status__c == Menopaus){
                            rule4 = true;
                        }
                        system.debug( '__rule4__'+rule4);
            }
        }
        
        system.debug( 'displayProgTab:'+ displayProgTab +  ' displayLongTab : ' + displayLongTab + ' displayRadiTab: '
                     + ' locprog: ' + locprog + 'distprog: ' + distprog );
        }
        isDelete();
    }
     public void isDelete(){
        
        System.debug('======FupFormId =======' +FupFormId);
        if(FupFormId != null){
            pathObj = [select Id, Status__c from Followup_Form__c where id =:FupFormId ];
            
            if(pathObj != null && pathObj.Status__c != 'Not Completed'){
                isDelete = true;    
            }
        }
            
        System.debug('======FupFormId=======' +FupFormId);
    }
    public pagereference redirect(){
              pagereference redirect = new pagereference('/apex/FollowupPdf?id='+FupFormId);
            //pagereference redirect = new pagereference('/apex/FollowupPdf?fupformId='+FupFormId+'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
            redirect.setRedirect(true);
            return redirect;
     }
        
    public class IrrdSiteWrapper {
        public Irradiated_Site__c IRDSite {get;set;}
        public String sno {get;set;}
        public boolean isUpdateVisible {get;set;}
        public boolean isReadOnly {get;set;}
        public IrrdSiteWrapper() {
            IRDSite = new Irradiated_Site__c();
        }
    }
    
    public class TherapyWrapper {
        public Therapy_Received__c THRecvd {get;set;}
        public String sno {get;set;}
        public boolean isUpdateVisible {get;set;}
        public boolean isReadOnly {get;set;}
        public TherapyWrapper() {
            THRecvd = new Therapy_Received__c();
        }
    }
    
    public String[] recurrenceProgressChoice { 
        get {
            String[] selected = new List<String>();
            List<SelectOption> sos = this.recurrenceProgressOptions;
            for(SelectOption s : sos) {
                if ( FF.Recurrence_progression_information__c != null){
                    if (FF.Recurrence_progression_information__c.contains(s.getValue()))
                        selected.add(s.getValue());
                }
            }
            return selected;
        } 
        public set {
            String selectedConcat = '';
            for(String s : value) {
                if (selectedConcat == '') selectedConcat += s;
                else selectedConcat += ';' + s;
            }
            FF.Recurrence_progression_information__c = selectedConcat;
            //  upsert FF;
        }
    } 
        
    public String[] progressionLocalChoice { 
        get {
            String[] selected = new List<String>();
            List<SelectOption> sos = this.progressionLocalOptions;
            for(SelectOption s : sos) {
                if ( FF.Local__c != null){
                   if (FF.Local__c.contains(s.getValue()))
                      selected.add(s.getValue());
                }
            }
            return selected;
        }
        public set {
            String selectedConcat = '';
            for(String s : value) {
                if (selectedConcat == '') selectedConcat += s;
                else selectedConcat += ';' + s;
            }
            FF.Local__c = selectedConcat;
            //  upsert FF;
        }
    } 
        
    public String[] progressionDistantChoice { 
        get {
            String[] selected = new List<String>();
            List<SelectOption> sos = this.progressionDistantOptions;
            for(SelectOption s : sos) {
                if ( FF.Distant__c != null){
                    if (FF.Distant__c.contains(s.getValue()))
                         selected.add(s.getValue());
                }
            }
            return selected;
        } 
        public set {
            String selectedConcat = '';
            for(String s : value) {
                    if (selectedConcat == '') selectedConcat += s;
                    else selectedConcat += ';' + s;
            }
            FF.Distant__c = selectedConcat;
        }
    } 
        
    public String[] menopausalStatusChoice { 
        get {
            String[] selected = new List<String>();
            List<SelectOption> sos = this.menopausalStatusOptions;
            for(SelectOption s : sos) {
                if ( FF.Menopausal_status__c != null){
                    if (FF.Menopausal_status__c.contains(s.getValue()))
                          selected.add(s.getValue());
                }
            }
            return selected;
        } 
        public set {
            String selectedConcat = '';
            for(String s : value) {
                if (selectedConcat == '') selectedConcat += s;
                else selectedConcat += ';' + s;
            }
            FF.Menopausal_status__c = selectedConcat;
        }
    } 
        
    public Pagereference saveMainCRF() {
    
        if(FupFormId == null) {
            FF.TrialPatient__c = trialPat;
            try {
                insert FF;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                return null;
            }
            
        
            FupFormId = FF.Id;
        
            //Pagereference ref = new Pagereference('/apex/FollowupForm?trialPat='+trialPat+'&fupformId='+FupFormId);
            Pagereference ref = new Pagereference('/'+FupFormId);
            
            ref.setRedirect(true);
            return ref;
        
        } else {
            return null;
        }
    }
    
    public PageReference cancelCRF() {
        //String TrialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
        //system.debug('__TrialPatientId__'+TrialPatientId);
        //List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
        system.debug('trialPatientObj-------'+trialPatientObj.id);
        List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id = :trialPatientObj.id];
       /* if(FF.OriginalCRF__c == null) {
            delete FF;
        }*/
         if( FupFormId   != null) {
                    //Added by Shruti (DE401)
       try {
            delete new Followup_Form__c(id=FupFormId );
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);            
            //Pagereference ref = new Pagereference('/apex/FollowupForm?id='+FupFormId);
            Pagereference ref = new Pagereference('/'+FupFormId);
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
             
       // pr = new Pagereference('/apex/TranscendPage?id='+trialPatientObj.id+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
        pr = new Pagereference('/apex/TranscendPage?id='+trialPatientObj.id+'&sfdc.override=1');
        return pr; 
    }
        
//===========================next used for go to next tab on page===========================================    
    public Pagereference next() {
        if  ( FF.Start_Date__c  > FF.End_Date__c ) { 
            FF.End_Date__c.addError('End Date must be later than start date'); 
            return null;
        }
        if  ( FF.End_Date__c > system.today()){
            FF.End_Date__c.addError('End Date must be same as or earlier than today'); 
            return null;
        }
        if  ( FF.Clinical_assessment_Date__c > system.today()){
            FF.Clinical_assessment_Date__c.addError('Date must be same as or earlier than today'); 
            return null;
        }
        if  ( FF.Date__c > system.today()){
            FF.Date__c.addError('Date must be same as or earlier than today'); 
            return null;
        }
        if  ( FF.Local_progression_Date__c > system.today()){
            FF.Local_progression_Date__c.addError('Date must be same as or earlier than today'); 
            return null;
        }
        if  ( FF.Local_progression_Date__c < NPLPDate){
            FF.Local_progression_Date__c.addError('Date must be later than recent Followup Form'); 
            return null;
        }
        if  ( FF.Distant_progression_Date__c > system.today()){
            FF.Distant_progression_Date__c.addError('Date must be same as or earlier than today'); 
            return null;
        }
        if  ( FF.Distant_progression_Date__c < NPDPDate){
            FF.Distant_progression_Date__c.addError('Date must be later than recent Followup Form'); 
            return null;
        }
        if  (FF.Radiation_Therapy_Start_Date__c > FF.Radiation_Therapy_End_Date__c) { 
            FF.Radiation_Therapy_End_Date__c.addError('Date must be later than start date'); 
            return null;
        }
        if  ( FF.Radiation_Therapy_End_Date__c > system.today()){
            FF.Radiation_Therapy_End_Date__c.addError('Date must be same as or earlier than today'); 
            return null;
        }
        if  ( FF.Date_of_Last_Menstrual_period__c > system.today()){
            FF.Date_of_Last_Menstrual_period__c.addError('Date must be same as or earlier than today'); 
            return null;
        }
        if  ( FF.Bilateral_oophorectomy_Date__c > system.today()){
            FF.Bilateral_oophorectomy_Date__c.addError('Date must be same as or earlier than today'); 
            return null;
        }
        if  ( FF.Hysterectomy_Date__c > system.today()){
            FF.Hysterectomy_Date__c.addError('Date must be same as or earlier than today'); 
            return null;
        }           
        if(currentTab == 'MPStatusTab'){
            integer agev = Integer.valueOf(PC.Age__c);
            boolean condition6 = false;
            boolean condition7 = false;
            boolean condition8 = false;              
            
            Date MPDate = FF.Date_of_Last_Menstrual_period__c; 
            //  System.debug('agev>'+agev + 'condition6>'+condition6+ 'condition7>'+condition7+ 'condition8>'+condition8);
            FF.Menopausal_status__c ='';
            system.debug('__MPDate__'+MPDate);
            if (MPDate != null){
                system.debug('__MPDate.daysBetween(system.today())__'+MPDate.daysBetween(system.today()));
                //Condition 6
                if ( (MPDate.daysBetween(system.today()) < 183 ) && (FF.On_Estrogen_Replacement__c == false)
                     && ( FF.Bilateral_oophorectomy__c == false) ){
                        FF.Menopausal_status__c = 'Premenopausal(<6 months since LMP AND no prior bilateral ovariectomy AND not an estrogen replacement';
                        condition6 = true;
                }
                //Condition 7    
                else if  ( (MPDate.daysBetween(system.today()) > 183 ) && (MPDate.daysBetween(system.today()) < 365 )
                   && (FF.On_Estrogen_Replacement__c == false)  && ( FF.Bilateral_oophorectomy__c == false) ) { 
                        FF.Menopausal_status__c = 'Perimenopausal(6-12 months since LMP AND no priorbilateral ovariectomy AND not an estrogen replacement';
                    condition7 = true;
                }
                //Condition 8                    
                else if  ( (MPDate.daysBetween(system.today()) > 183 ) && (MPDate.daysBetween(system.today()) >= 365 )
                  && (FF.Hysterectomy__c == false)  && ( FF.Bilateral_oophorectomy__c == true) ) {  
                        FF.Menopausal_status__c = 'Postmenopausal(prior bilateral ovariectomy OR >12 months since LMP AND no prior hysterectomy)';
                        condition8 = true;
                }
            }
            //      System.debug('agev>'+agev + 'condition6>'+condition6+ 'condition7>'+condition7+ 'condition8>'+condition8);
        
            if((condition6 == false) && (condition7 == false) && (condition8 == false) && (agev < 50)) {
                FF.Menopausal_status__c = 'Above categories not applicable AND Age < 50';
            }
            else if((condition6 == false) && (condition7 == false) && (condition8 == false) && (agev > 50)) {
                FF.Menopausal_status__c = 'Above categories not applicable AND Age > 50';
            }                      
            
        }
        System.debug('FF>'+FF);
        try {
            update FF;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            //Added by Shruti (DE401)
           // Pagereference ref = new Pagereference('/apex/FollowupForm?id='+FupFormId);
            Pagereference ref = new Pagereference('/'+FupFormId);
            ref.setRedirect(true);
            return ref;
            //Added by Shruti (DE401)
        }
                
        system.debug ( 'current tab:'+currentTab );
        system.debug ( '__nextTabName__'+nextTabName);
        
        Boolean tabChangedDueToRule = false;
        if ( (locprog == true)  &&   (distprog == true)){
            system.debug ( '__rule4__'+rule4);
            if(nextTabName != null && nextTabName != '') {
                if(rule4 == true && nextTabName == 'MPStatusTab') {
                    currentTab = 'attachmentTab';
                    tabChangedDueToRule = true;
                }
            } else {
        
                if(currentTab == 'survstatTab'){
                    if(rule4 == true) {
                        currentTab = 'attachmentTab';
                    } else if (rule4 == false) {    
                        currentTab = 'MPStatusTab';
                    }   
                } else if(currentTab == 'MPStatusTab') {
                    currentTab = 'attachmentTab';
                } else if(currentTab == 'attachmentTab') {
                    currentTab = 'completeTab';
                }
            }
        }
            
        else if ( (locprog == true)  &&   (distprog == false)){
            if(nextTabName != null && nextTabName != '') {
                if(rule4 == true && nextTabName == 'MPStatusTab'){
                    currentTab = 'attachmentTab';
                    tabChangedDueToRule = true;
                }
            } else {
                if(currentTab == 'survstatTab') {
                    currentTab = 'noticeProgTab';
                } else if(currentTab == 'noticeProgTab') {
                    currentTab = 'radiTherapyTab';
                } else if(currentTab == 'radiTherapyTab') {
                    currentTab = 'ltTherapyTab';
                } else if(currentTab == 'ltTherapyTab') {
                    if(rule4 == true){
                        currentTab = 'attachmentTab';
                    } else if (rule4 == false) {    
                        currentTab = 'MPStatusTab';
                    }   
                } else if(currentTab == 'MPStatusTab') {
                    currentTab = 'attachmentTab';
                } else if(currentTab == 'attachmentTab') {
                    currentTab = 'completeTab';
                }
            }
        }
        
        else if ( (locprog == false)  &&   (distprog == true)){
            if(nextTabName != null && nextTabName != '') {
                if(rule4 == true && nextTabName == 'MPStatusTab') {
                    currentTab = 'attachmentTab';
                    tabChangedDueToRule = true;
                }
            } else {
                if(currentTab == 'survstatTab') {
                    currentTab = 'noticeProgTab';
                } else if(currentTab == 'noticeProgTab') {
                    if(rule4 == true) {
                        currentTab = 'attachmentTab';
                    } else if (rule4 == false) {    
                        currentTab = 'MPStatusTab';
                    }   
                } else if(currentTab == 'MPStatusTab') {
                    currentTab = 'attachmentTab';
                } else if(currentTab == 'attachmentTab') {
                    currentTab = 'completeTab';
                }
            }
        }
        
        else if((locprog == false)  &&   (distprog == false)) {
            if(nextTabName != null && nextTabName != '') {
                if(rule4 == true && nextTabName == 'MPStatusTab') {
                    currentTab = 'attachmentTab';
                    tabChangedDueToRule = true;
                } 
            } else {
                if(currentTab == 'survstatTab') {
                    currentTab = 'noticeProgTab';
                } else if(currentTab == 'noticeProgTab') {
                    currentTab = 'radiTherapyTab';
                } else if(currentTab == 'radiTherapyTab') {
                    currentTab = 'ltTherapyTab';
                } else if(currentTab == 'ltTherapyTab') {
                    if(rule4 == true) {
                        currentTab = 'attachmentTab';
                    } else if (rule4 == false) {    
                        currentTab = 'MPStatusTab';
                    }   
                } else if(currentTab == 'MPStatusTab') {
                    currentTab = 'attachmentTab';
                } else if(currentTab == 'attachmentTab') {
                    currentTab = 'completeTab';
                }
            }
        }
    
        String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
        system.debug('__nextTabValue__'+nextTabValue);
        if(nextTabValue == 'saveAndClose') {
//=====================Save & Close Functionality ================================        
          FF.First_Save_and_Close__c = true;
            try {
                update FF;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                //Added by Shruti (DE401)
            // Pagereference ref = new Pagereference('/apex/FollowupForm?id='+FupFormId);
            Pagereference ref = new Pagereference('/'+FupFormId);
            ref.setRedirect(true);
            return ref;
            //Added by Shruti (DE401)
            }
//================================================================================            
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:trialPat];
            if(!trialPatList.isEmpty()) {
                Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
                //Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&sfdc.override=1');
                pr.setRedirect(true);
                return pr;
            }
        }
        
        if(!tabChangedDueToRule && nextTabName != null && nextTabName != '') {
            currentTab = nextTabName;
        }
        nextTabName = null;
        system.debug ( '__current tab__'+currentTab );
        return null;
    }
    
//===========================previous used for go to previous tab on page===========================================    
        
    //public void previous() {    
    public Pagereference previous() { //Added by Shruti (DE401)
        system.debug ( 'current tab:'+currentTab );
        
        if ( (locprog == true)  &&   (distprog == true)){
            if(currentTab == 'completeTab') {
                currentTab = 'attachmentTab';
            } else if(currentTab == 'attachmentTab') {
                if(rule4 == true) {
                    currentTab = 'survstatTab';
                } else if (rule4 == false) {    
                    currentTab = 'MPStatusTab';
                }   
            } else if(currentTab == 'MPStatusTab') {
                currentTab = 'survstatTab';
            }
        }
        
        else if ( (locprog == true)  &&   (distprog == false)){
            if(currentTab == 'completeTab') {
                currentTab = 'attachmentTab';
            } else if(currentTab == 'attachmentTab') {
                if(rule4 == true) {
                    currentTab = 'ltTherapyTab';
                } else if (rule4 == false) {    
                    currentTab = 'MPStatusTab';
                }   
            } else if(currentTab == 'MPStatusTab') {
                currentTab = 'ltTherapyTab';
            } else if(currentTab == 'ltTherapyTab') {
                currentTab = 'radiTherapyTab';
            } else if(currentTab == 'radiTherapyTab') {
                currentTab = 'noticeProgTab';
            } else if(currentTab == 'noticeProgTab') {
                currentTab = 'survstatTab';
            }
        }
        
        else if ( (locprog == false)  &&   (distprog == true)){
            if(currentTab == 'completeTab') {
                currentTab = 'attachmentTab';
            } else if(currentTab == 'attachmentTab') {
                if(rule4 == true) {
                    currentTab = 'noticeProgTab';
                } else if (rule4 == false) {    
                    currentTab = 'MPStatusTab';
                }   
            } else if(currentTab == 'MPStatusTab') {
                currentTab = 'noticeProgTab';
            } else if(currentTab == 'noticeProgTab') {
                currentTab = 'survstatTab';
            }   
        }
        
        else if((locprog == false)  &&   (distprog == false)) {
            if(currentTab == 'completeTab') {
                currentTab = 'attachmentTab';
            } else if(currentTab == 'attachmentTab') {
                if(rule4 == true) {
                    currentTab = 'ltTherapyTab';
                } else if (rule4 == false) {    
                    currentTab = 'MPStatusTab';
                }
            } else if(currentTab == 'MPStatusTab') {
                currentTab = 'ltTherapyTab';
            } else if(currentTab == 'ltTherapyTab') {
                currentTab = 'radiTherapyTab';
            } else if(currentTab == 'radiTherapyTab') {
                currentTab = 'noticeProgTab';
            } else if(currentTab == 'noticeProgTab') {
                currentTab = 'survstatTab';
            }   
        }
       //Added by Shruti (DE401)
       try {
            update FF;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);            
            //Pagereference ref = new Pagereference('/apex/FollowupForm?id='+FupFormId);
            Pagereference ref = new Pagereference('/'+FupFormId);
            ref.setRedirect(true);
            return ref;            
        } 
        return null;
        //Added by Shruti (DE401)
    }
//===========================Sign And Submit for Site User in AE CRF===========================================
 
    public Pagereference signAndSubmit() {
    
        //ChangeAdhocToLiveController completeCrf = new ChangeAdhocToLiveController();
        //completeCrf.customAdhoc(FF.Id+'', 'submit', 'Site'); 
        
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00064','',FF.Id+'' , 'Site');
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
    public void addTherapyReceived() {

        TherapyWrapper THRWrapper = new TherapyWrapper();
        THRWrapper.isReadOnly = false;
        THRWrapper.isUpdateVisible = false;
        THRWrapper.isUpdateVisible = false;
        THRWrapper.sno = String.valueOf(++therapySNO);
        THRWrapperList.add(THRWrapper );
    
        system.debug('TherapyWrapper THRWrapper : '+THRWrapper);
    }
    public void editTherapyReceived() {
            
        for ( TherapyWrapper THRWrapper : THRWrapperList ){
            THRWrapper.isReadOnly = false;
            THRWrapper.isUpdateVisible = true;
                
            system.debug('TherapyWrapper THRWrapper : '+THRWrapper);
        }
        
    }

    public void updateTherapyReceived() {

        List<Therapy_Received__c> THRecvdList = new List<Therapy_Received__c>{};
            
        for ( TherapyWrapper THRWrapper : THRWrapperList ){
            if (THRWrapper.THRecvd.Start_Date_Date_Performed__c > system.today()){
                THRWrapper.THRecvd.Start_Date_Date_Performed__c.addError('Start date cannot be future date');
                return;
            }
            
            if (THRWrapper.THRecvd.Start_Date_Date_Performed__c > THRWrapper.THRecvd.End_Date__c){
                THRWrapper.THRecvd.End_Date__c.addError('End Date must be later than start date');
                return;
            }
            
            THRWrapper.isReadOnly = true;
            THRWrapper.isUpdateVisible = false;
        //  if ( THRWrapper.THRecvd.Followup_Form__c == null)  THRWrapper.THRecvd.Followup_Form__c = FupFormId;
            THRecvdList.add(THRWrapper.THRecvd);
            system.debug('TherapyWrapper THRWrapper : '+THRWrapper);
        }
        if ( THRecvdList.size()>0 )
        try {
        upsert THRecvdList;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
             return ;
        }
    }


    public void saveTherapyReceived() {
    
        List<Therapy_Received__c> THRecvdList = new List<Therapy_Received__c>{};
        
        for ( TherapyWrapper THRWrapper : THRWrapperList ){
            if (THRWrapper.THRecvd.Start_Date_Date_Performed__c > system.today()){
                THRWrapper.THRecvd.Start_Date_Date_Performed__c.addError('Start date cannot be future date');
                return;
            }
            
            if (THRWrapper.THRecvd.Start_Date_Date_Performed__c > THRWrapper.THRecvd.End_Date__c){
                THRWrapper.THRecvd.End_Date__c.addError('End Date must be later than start date');
                return;
            }
            if  ( THRWrapper.THRecvd.End_Date__c > system.today()){
                THRWrapper.THRecvd.End_Date__c.addError('End Date must be same as or earlier than today'); 
                return;
            }
            
            THRWrapper.isReadOnly = true;
            //THRWrapper.isUpdateVisible = false;
            THRWrapper.THRecvd.Followup_Form__c = FupFormId;
            THRecvdList.add(THRWrapper.THRecvd);
            system.debug('TherapyWrapper THRWrapper : '+THRWrapper);
        }
        
        try {
        upsert THRecvdList;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
             return ;
        }
    }
    
    public void cancelTherapyReceived() {
    
        String recordId = Apexpages.currentPage().getParameters().get('recordId');
        system.debug('recordId : '+recordId);   
        if(recordId != null && recordId != '') {
            for(TherapyWrapper THRWrapper : THRWrapperList) {
                if(THRWrapper.THRecvd.Id == recordId) {
                    THRWrapper.isReadOnly = true;
                    THRWrapper.isUpdateVisible = false;
                }
            }
        } else {
            therapySNO = 0;
            List<TherapyWrapper> lstTempThWrapper = new List<TherapyWrapper>();
            String cancelIndex = Apexpages.currentPage().getParameters().get('cancelIndex');
            for(TherapyWrapper THRWrapper : THRWrapperList) {
                if(THRWrapper.sno != cancelIndex) {
                    TherapyWrapper newTHRWrapper = new TherapyWrapper();
                    newTHRWrapper.THRecvd = THRWrapper.THRecvd;
                    newTHRWrapper.isReadOnly = THRWrapper.isReadOnly;
                    newTHRWrapper.isUpdateVisible = THRWrapper.isUpdateVisible;
                    newTHRWrapper.sno = String.valueOf(++therapySNO);
                    lstTempThWrapper.add(newTHRWrapper);
                }
            }
            THRWrapperList = new List<TherapyWrapper>();
            THRWrapperList = lstTempThWrapper;
        }
    }
    public void removeTherapyReceived() {
    
        String recordId = Apexpages.currentPage().getParameters().get('recordId');
        system.debug('recordId : '+recordId);
        if(recordId != null && recordId != ''){
            delete [select Id from Therapy_Received__c where Id =:recordId];
        }
    
        therapySNO = 0;
        List<TherapyWrapper> lstTempThWrapper = new List<TherapyWrapper>();
        String cancelIndex = Apexpages.currentPage().getParameters().get('cancelIndex');
        for(TherapyWrapper THRWrapper : THRWrapperList) {
            if(THRWrapper.sno != cancelIndex) {
                TherapyWrapper newTHRWrapper = new TherapyWrapper();
                newTHRWrapper.THRecvd = THRWrapper.THRecvd;
                newTHRWrapper.isReadOnly = THRWrapper.isReadOnly;
                newTHRWrapper.isUpdateVisible = THRWrapper.isUpdateVisible;
                newTHRWrapper.sno = String.valueOf(++therapySNO);
                lstTempThWrapper.add(newTHRWrapper);
            }
            THRWrapperList = new List<TherapyWrapper>();
            THRWrapperList = lstTempThWrapper;
        }
    }

    public void addIrradiatedSite() {
    
        IrrdSiteWrapper IRSWrapper = new IrrdSiteWrapper();
    
        IRSWrapper.isReadOnly = false;
        IRSWrapper.isUpdateVisible = false;
        
        IRSWrapperList.add(IRSWrapper);
        system.debug('IrrdSiteWrapper IRSWrapper : '+IRSWrapper);
    }
    
    public void editIrradiatedSite() {
                
        for ( IrrdSiteWrapper IRSWrapper : IRSWrapperList ){
            if ( IRSWrapper.IRDSite.Dose_per_FX_cGy__c != null && IRSWrapper.IRDSite.Total_FX__c != null )
            IRSWrapper.IRDSite.Total_dose_cGy_AP__c = IRSWrapper.IRDSite.Dose_per_FX_cGy__c * IRSWrapper.IRDSite.Total_FX__c;   
            IRSWrapper.isReadOnly = false;
            IRSWrapper.isUpdateVisible = true;
                
            system.debug('IrrdSiteWrapper IRSWrapper : '+IRSWrapper);
        }
    }

    public void updateIrradiatedSite() {

        List<Irradiated_Site__c> IrrdSiteList = new List<Irradiated_Site__c>{};
        
        for ( IrrdSiteWrapper IRSWrapper : IRSWrapperList ){
        if ( IRSWrapper.IRDSite.Dose_per_FX_cGy__c != null && IRSWrapper.IRDSite.Total_FX__c != null )  
        IRSWrapper.IRDSite.Total_dose_cGy_AP__c = IRSWrapper.IRDSite.Dose_per_FX_cGy__c * IRSWrapper.IRDSite.Total_FX__c;
        IRSWrapper.isReadOnly = true;
        IRSWrapper.isUpdateVisible = false;
    //  if (IRSWrapper.IRDSite.Followup_Form__c == null ) IRSWrapper.IRDSite.Followup_Form__c = FupFormId;
        IrrdSiteList.add(IRSWrapper.IRDSite);
        system.debug('IrrdSiteWrapper IRSWrapper : '+IRSWrapper);
        }
    
    upsert IrrdSiteList;
    }

    public void saveIrradiatedSite() {
    
        List<Irradiated_Site__c> IrrdSiteList = new List<Irradiated_Site__c>{};
    
        for ( IrrdSiteWrapper IRSWrapper : IRSWrapperList ){
            if ( IRSWrapper.IRDSite.Dose_per_FX_cGy__c != null && IRSWrapper.IRDSite.Total_FX__c != null )
            IRSWrapper.IRDSite.Total_dose_cGy_AP__c = IRSWrapper.IRDSite.Dose_per_FX_cGy__c * IRSWrapper.IRDSite.Total_FX__c;
            IRSWrapper.isReadOnly = true;
            //IRSWrapper.isUpdateVisible = false;
            IRSWrapper.IRDSite.Followup_Form__c = FupFormId;
            IrrdSiteList.add(IRSWrapper.IRDSite);
            system.debug('IrrdSiteWrapper IRSWrapper : '+IRSWrapper);
        }
        upsert IrrdSiteList;
    }
    public void cancelIrradiatedSite() {
        
        String recordId = Apexpages.currentPage().getParameters().get('recordId');
        system.debug('recordId : '+recordId);   
        if(recordId != null && recordId != '') {
            for(IrrdSiteWrapper IRSWrapper : IRSWrapperList) {
                if(IRSWrapper.IRDSite.Id == recordId) {
                    IRSWrapper.isReadOnly = true;
                    IRSWrapper.isUpdateVisible = false;
                }
            }
        
        } else {
            therapySNO = 0;
            List<IrrdSiteWrapper> lstTempThWrapper = new List<IrrdSiteWrapper>();
            String cancelIndex = Apexpages.currentPage().getParameters().get('cancelIndex');
            for(IrrdSiteWrapper IRSWrapper : IRSWrapperList) {
                if(IRSWrapper.sno != cancelIndex) {
                    IrrdSiteWrapper newIRSWrapper = new IrrdSiteWrapper();
                    newIRSWrapper.IRDSite = IRSWrapper.IRDSite;
                    newIRSWrapper.isReadOnly = IRSWrapper.isReadOnly;
                    newIRSWrapper.isUpdateVisible = IRSWrapper.isUpdateVisible;
                    newIRSWrapper.sno = String.valueOf(++therapySNO);
                    lstTempThWrapper.add(newIRSWrapper);
                }
            }
            IRSWrapperList = new List<IrrdSiteWrapper>();
            IRSWrapperList = lstTempThWrapper;
        }
    }

    public void removeIrradiatedSite() {
        String recordId = Apexpages.currentPage().getParameters().get('recordId');
        system.debug('recordId : '+recordId);
        if(recordId != null && recordId != ''){
            delete [select Id from Irradiated_Site__c where Id =:recordId];
        }
        therapySNO = 0;
        List<IrrdSiteWrapper> lstTempThWrapper = new List<IrrdSiteWrapper>();
        String cancelIndex = Apexpages.currentPage().getParameters().get('cancelIndex');
        for(IrrdSiteWrapper IRSWrapper : IRSWrapperList) {
            if(IRSWrapper.sno != cancelIndex) {
                IrrdSiteWrapper newIRSWrapper = new IrrdSiteWrapper();
                newIRSWrapper.IRDSite = IRSWrapper.IRDSite;
                newIRSWrapper.isReadOnly = IRSWrapper.isReadOnly;
                newIRSWrapper.isUpdateVisible = IRSWrapper.isUpdateVisible;
                newIRSWrapper.sno = String.valueOf(++therapySNO);
                lstTempThWrapper.add(newIRSWrapper);
            }
            IRSWrapperList = new List<IrrdSiteWrapper>();
            IRSWrapperList = lstTempThWrapper;
        }
    }

    public PageReference attachPdf (){
    
        PageReference pdfPage = Page.followupformpdf;
        pdfPage.getParameters().put('fupformId', FupFormId);
        pdfPage.getParameters().put('trialPat', trialPat);
        Blob pdfBlob = pdfPage.getContent();
   
        Attachment a = new Attachment(parentId = FupFormId, name= 'FollowupForm.pdf', body = pdfBlob);
        insert a;
      
        Pagereference ref = new Pagereference('/apex/FollowupForm?trialPat='+trialPat+'&fupformId='+FupFormId);
        ref.setRedirect(true);
        return ref;
            
    }
//=======================Edit main CRF After rejecting by DCC============================================================

    public Pagereference cloneCRF() {
        openInEditMode = true;
        //String clonedCRFId = CloneBuilder.cloneMe(FF.Id, '0', '');
        FF.Status__c = 'Not Completed';
        try {
            update FF;
        }catch (Exception e) {
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            Apexpages.addMessage(msg);
            return null;
        }
        return null;
    }

    public Pagereference editCRF() {
        if(isShowEditButton) {
            lstCloneFollow[0].Status__c = 'Not Completed';
            try {
                update lstCloneFollow[0];
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);
                //Added by Shruti (DE401)
            //Pagereference ref = new Pagereference('/apex/FollowupForm?id='+FupFormId);
            Pagereference ref = new Pagereference('/'+FupFormId);
            ref.setRedirect(true);
            return ref;
            //Added by Shruti (DE401)
            }
        }
        openInEditMode = false;
        currentTab = 'survstatTab';
        isComplete = true;
        Pagereference ref = new Pagereference('/apex/FollowupForm?trialPat='+trialPat+'&fupformId='+clonedCRFId);
        ref.setRedirect(true);
        return ref;
    }
}