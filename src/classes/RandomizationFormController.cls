public with sharing class RandomizationFormController {
    public String errorMsg {get;set;}
    public String recordURL {get;set;}
    public String trialPatientId {get;set;}
    public String trialPatientName {get;set;}
    public List<RandomizePatient.CRFStatusWrapper> lstCRFStatusWrapper{get;set;}
    public String TrialPatientParameter = 'CF00Nc0000000GwtR'; //Id of TrailPatientField in page
    String h1h2Status = null;
    String erStatus = ''; //Assigned in line 65
    String prStatus = ''; //Assigned in line 65
    String HER2Status = ''; // Assigned in line 86 and 88 
    String MammaPrintRisk = ''; // Assigned in line 119
    String ICH_HER2_Status = '';
    String FISH_HER2_Status = '';
    Integer mp = 4;  // 0-Low, 1-High,2- Quantity not sufficient,3-Quality not sufficient, 4-Not entered By the user
    
    public boolean isAllOSECheckboxesChecked = true;
    public Randomization_Form__c randObj{get;set;}
    public String currentTab{get;set;}
    public String password{get;set;}
    public List<SelectOption> lstSign{get;set;}
    public String Selectedsign{get;set;}
    public List<SelectOption> lstReason{get;set;}
    public Boolean isRandomized {get;set;}
    public String randomizeMessage{get;set;}
    public Boolean isComplete{get;set;}
    public String formId {get;set;}
    public boolean armNOTAssigned {get;set;}
    public String eligibleMessage {get;set;}
    public String nextTabName{get;set;} 
    public TrialPatient__c trialPatientObj {get;set;}
    
    public boolean showAdminData {get;set;}
    
    public RandomizationFormController() { 
  
    }
    
    public RandomizationFormController(Apexpages.standardcontroller reg){
        
        Id profileId = Userinfo.getProfileId();
        List<Profile> profileList = [Select p.Name From Profile p where p.id = :profileId];
        if(!profileList.isEmpty()) {
            showAdminData = profileList[0].Name == 'System Administrator' || profileList[0].Name == 'Trial Administrator' || profileList[0].Name == 'Transcend Admin' || profileList[0].Name == 'Developers';
            System.debug('showAdminData:'+showAdminData);
        }
        
        trialPatientId = Apexpages.currentPage().getParameters().get('trialPat');
        formId = Apexpages.currentPage().getParameters().get('formId');
        system.debug('trialPatientId:'+trialPatientId);
        system.debug('formId:'+formId);
        
        randObj = new Randomization_Form__c();
        Selectedsign = 'true';
        isComplete = true;
        if(trialPatientId != null) {
            List<TrialPatient__c> lstTrialPatient = [select Name, Patient_Id__c, Trial_Id__r.Name  from TrialPatient__c where Id = :trialPatientId];
            if(!lstTrialPatient.IsEmpty()) {
                trialPatientObj = lstTrialPatient[0];
            }
            List<Randomization_Form__c> lstRandomizationFrom = [Select r.Test_Case_Number__c,r.Not_Randomized_Reason__c, r.First_Save_and_Close__c, r.TrialPatient__c, r.Status__c, r.Consent_Signed_Date__c, r.Why_Patient_Not_Signed_Consent_Form__c, r.Randomization_Result__c, r.Other_Reason_Did_Not_Sign_Consent_Form__c, r.Name, r.Id, r.Did_Patient_Sign_Treatment_Consent_Form__c, r.CompletedDate__c, r.CRF__c From Randomization_Form__c r where TrialPatient__c = :trialPatientId];
            if(!lstRandomizationFrom.isEmpty()) {
                randObj = lstRandomizationFrom[0];
                Selectedsign = String.valueOf(randObj.Did_Patient_Sign_Treatment_Consent_Form__c);
                if(randObj.Randomization_Result__c != null && randObj.Randomization_Result__c != 'Not Randomized') {
                    armNOTAssigned = false;
                } else {
                    armNOTAssigned = true;
                }
            }
        }
        
        lstReason = new List<SelectOption>();
        lstReason.add(new SelectOption('Decided not to have neoadjuvant chemotherapy','Decided not to have neoadjuvant chemotherapy'));
        lstReason.add(new SelectOption('Decided not to be treated with a novel agent','Decided not to be treated with a novel agent'));
        lstReason.add(new SelectOption('Patient found to be ineligible for the study','Patient found to be ineligible for the study'));
        lstReason.add(new SelectOption('Patient found to be ineligible because they are MammaPrint Low, ER Positive, HER2 Negative','Patient found to be ineligible because they are MammaPrint Low, ER Positive, HER2 Negative'));
        lstReason.add(new SelectOption('Patient found to be ineligible because inability to complete MammaPrint Test','Patient found to be ineligible because inability to complete MammaPrint Test'));
        lstReason.add(new SelectOption('Patient found to be ineligible because they did not meet other eligibility criteria','Patient found to be ineligible because they did not meet other eligibility criteria'));
        lstReason.add(new SelectOption('Patient found to be ineligible because patient could not complete MRI','Patient found to be ineligible because patient could not complete MRI'));
        lstReason.add(new SelectOption('Patient found to be ineligible because patient could not complete core biopsy','Patient found to be ineligible because patient could not complete core biopsy'));
        lstReason.add(new SelectOption('Other','Other'));
        
        //trialPatientName = Apexpages.currentPage().getParameters().get(TrialPatientParameter);
        //trialPatientId = Apexpages.currentPage().getParameters().get(TrialPatientParameter+'_lkid');
        
        //if(checkPatientEligibilityForRandomization()) {
        /*RandomizePatient.RandomizationEligibilityData red = collectRandomizationEligibilityData(trialPatientId);
        String response = RandomizePatient.checkPatientEligibilityForRandomization(red);
        if(response == 'SUCCESS') {
            isRandomized = true;
            randomizeMessage = 'Patient is eligible to Randomized.';
            List<Randomization_Form__c> lstRandomizationFrom = [Select r.Test_Case_Number__c,r.Not_Randomized_Reason__c,r.First_Save_and_Close__c, r.TrialPatient__c, r.Status__c, r.Consent_Signed_Date__c, r.Why_Patient_Not_Signed_Consent_Form__c, r.Randomization_Result__c, r.Other_Reason_Did_Not_Sign_Consent_Form__c, r.Name, r.Id, r.Did_Patient_Sign_Treatment_Consent_Form__c, r.CompletedDate__c, r.CRF__c From Randomization_Form__c r where TrialPatient__c = :trialPatientId];
            if(!lstRandomizationFrom.isEmpty()) {
                randObj.Randomization_Result__c = lstRandomizationFrom[0].Randomization_Result__c;
                if(randObj.Randomization_Result__c != null && randObj.Randomization_Result__c != 'Not Randomized') {
                    armNOTAssigned = false;
                } else {
                    armNOTAssigned = true;
                }
                isComplete = CRFUtilities.isReadOnlyUsr();  
            }
        } else {
            isRandomized = false;
            Selectedsign = 'false';
            randomizeMessage = 'Patient is not eligible to Randomized.';
            
        }*/
        
        lstSign = new List<SelectOption>();
        
        lstSign.add(new SelectOption('true','Yes'));
        lstSign.add(new SelectOption('false','No - Reason why not:'));
        
        //isRandomized = true;
        //randomizeMessage = 'Patient is eligible to Randomized.';
        
        if(randObj != null){
            String crfId = randObj.CRF__c;
            if(crfId != null && crfId != ''){
                String status = CRFUtilities.CRFStatus(crfId);
                if(status == 'Approval Pending' || status == 'Accepted' || status == 'Approval Not Required' || status == 'Rejected'){
                    currentTab = 'SecondTab';
                    isComplete = false;
                } else {
                    currentTab = 'firstTab';
                }
            }
        }
        System.debug('isComplete:'+isComplete);
        System.debug('isRandomized:'+isRandomized);
    }
    
    private RandomizePatient.RandomizationEligibilityData collectRandomizationEligibilityData(Id trialPatientId) {
        
        RandomizePatient.RandomizationEligibilityData randEleData = new RandomizePatient.RandomizationEligibilityData();
        
        Integer her2TargrtPrint = 2; //-1-Negative, 1-Positive, 2-Other
        lstCRFStatusWrapper = new List<RandomizePatient.CRFStatusWrapper>();
        randEleData.crfStatusList = lstCRFStatusWrapper;
        
        RandomizePatient.CRFStatusWrapper crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        
        system.debug('trialPatientId : '+trialPatientId);
        
        crfStatusWrapper.CRFType = 'MRI Volume Form';
                
        List<MRI_Volume__c> lstMRIVolume = [select Status__c, TrialPatient__c from MRI_Volume__c where TrialPatient__c = :trialPatientId and Time_Point__c = 'Pre-Treatment' order by Effective_Time__c desc limit 1];
        system.debug('lstMRIVolume : '+lstMRIVolume);
        if(!lstMRIVolume.isEmpty()) {
            if(lstMRIVolume[0].Status__c == 'Completed') {
                crfStatusWrapper.IsSubmitted = 'Yes';
            } else if(lstMRIVolume[0].Status__c == 'Approval Pending') {
                crfStatusWrapper.IsSubmitted = 'Yes';
                crfStatusWrapper.IsApproved = 'No';
            } else if(lstMRIVolume[0].Status__c == 'Accepted') {
                crfStatusWrapper.IsSubmitted = 'Yes';
                crfStatusWrapper.IsApproved = 'Yes';
            }
        }
        system.debug('mri:'+crfStatusWrapper.IsSubmitted+':'+crfStatusWrapper.IsApproved);
    
        lstCRFStatusWrapper.add(crfStatusWrapper);
        
        
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'On Study Pathology Form';
        
        //List<On_Study_Pathology_Form__c> lstOnStudyPathology = [Select o.Status__c, o.TrialPatient__c From On_Study_Pathology_Form__c o where TrialPatient__c = :trialPatientId];
        //List<On_Study_Pathology_Form__c> lstOnStudyPathology = [Select o.Status__c, o.TrialPatient__c, (Select Estrogen_Receptor_Status__c, Fish__c, IHC__c, Progesterone_Receptor_Status__c From Receptors__r) From On_Study_Pathology_Form__c o where TrialPatient__c = :trialPatientId order by Effective_Time__c desc limit 1];
        //List<On_Study_Pathology_Form__c> lstOnStudyPathology = [Select o.Status__c, o.TrialPatient__c, (Select Estrogen_Receptor_Status__c, Fish__c, IHC__c, Progesterone_Receptor_Status__c From Receptors__r) From On_Study_Pathology_Form__c o where TrialPatient__c = :trialPatientId and Status__c = 'Accepted' order by Effective_Time__c desc limit 1];
        List<On_Study_Pathology_Form__c> lstOnStudyPathology = [Select o.Status__c, o.TrialPatient__c, (Select Estrogen_Receptor_Status__c, Fish__c, IHC__c, Progesterone_Receptor_Status__c From Receptors__r) From On_Study_Pathology_Form__c o where TrialPatient__c = :trialPatientId order by Effective_Time__c desc limit 1];
        for(On_Study_Pathology_Form__c OSP : lstOnStudyPathology){
            system.debug('OSP.Status__c:'+OSP.Status__c);
            if(OSP.Status__c == 'Completed') {
                crfStatusWrapper.IsSubmitted = 'Yes';
            } else if(OSP.Status__c == 'Accepted') {
                crfStatusWrapper.IsSubmitted = 'Yes';
                crfStatusWrapper.IsApproved = 'Yes';
            } else if(OSP.Status__c == 'Approval Pending') {
                crfStatusWrapper.IsSubmitted = 'Yes';
                crfStatusWrapper.IsApproved = 'No';
            }
            List<Receptors__c> lstReceptors = OSP.Receptors__r;
            if(lstReceptors != null && !lstReceptors.isEmpty()) {
                randEleData.ICH_HER2_Status = lstReceptors[0].IHC__c;
                randEleData.FISH_HER2_Status = lstReceptors[0].Fish__c;
                randEleData.erStatus = lstReceptors[0].Estrogen_Receptor_Status__c;
                randEleData.prStatus = lstReceptors[0].Progesterone_Receptor_Status__c;
            }  
        }
        system.debug('osp:'+crfStatusWrapper.IsSubmitted+':'+crfStatusWrapper.IsApproved);
        lstCRFStatusWrapper.add(crfStatusWrapper);
        
        
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'On Study Eligibility Form';
        
        List<On_Study_Eligibility_Form__c> lstOnStudyEligibility = [select Status__c, TrialPatient__c, No_Clinical_Or_Imaging_Evidence__c, No_Uncontrolled_or_Cardiovascular_Diseas__c, No_history_of_allergic_reactions__c, No_uncontrolled_intercurrent_illness__c, Not_had_a_sentinel_lymph_node__c, Lab_Values__c, Leukocytes_3000_L__c, Absolute_Neutrophil_count_1500_L__c, Platelets_100_000_L__c, Total_Bilirubin_within_institutional__c, AST_SGOT_or_ALT_SGPT_1_5_x_insti__c, Creatinine_1_5_x_institutional_ULN__c from On_Study_Eligibility_Form__c where TrialPatient__c = :trialPatientId and Status__c NOT IN ('Cloned', 'Rejected') order by Effective_Time__c desc limit 1];
        if(!lstOnStudyEligibility.isEmpty()) {
            if(lstOnStudyEligibility[0].Status__c == 'Completed') {
                crfStatusWrapper.IsSubmitted = 'Yes';
            } else if(lstOnStudyEligibility[0].Status__c == 'Approval Pending') {
                crfStatusWrapper.IsSubmitted = 'Yes';
                crfStatusWrapper.IsApproved = 'No';
            } else if(lstOnStudyEligibility[0].Status__c == 'Accepted') {
                crfStatusWrapper.IsSubmitted = 'Yes';
                crfStatusWrapper.IsApproved = 'Yes';
                boolean isAllOSEChecked = false;
                if(lstOnStudyEligibility[0].No_Clinical_Or_Imaging_Evidence__c && 
                    lstOnStudyEligibility[0].No_Uncontrolled_or_Cardiovascular_Diseas__c && 
                    lstOnStudyEligibility[0].No_history_of_allergic_reactions__c && 
                    lstOnStudyEligibility[0].No_uncontrolled_intercurrent_illness__c && 
                    lstOnStudyEligibility[0].Not_had_a_sentinel_lymph_node__c && 
                    lstOnStudyEligibility[0].Lab_Values__c && 
                    lstOnStudyEligibility[0].Leukocytes_3000_L__c && 
                    lstOnStudyEligibility[0].Absolute_Neutrophil_count_1500_L__c && 
                    lstOnStudyEligibility[0].Platelets_100_000_L__c && 
                    lstOnStudyEligibility[0].Total_Bilirubin_within_institutional__c && 
                    lstOnStudyEligibility[0].AST_SGOT_or_ALT_SGPT_1_5_x_insti__c && 
                    lstOnStudyEligibility[0].Creatinine_1_5_x_institutional_ULN__c) {
                    isAllOSEChecked = true;
                    List<CRFAdditionalQuestion__c> lstCRFAddQues = [Select c.QuestionAnswer__r.AnswerType__c, c.QuestionAnswer__c, c.CRFId__c, c.Answer__c From CRFAdditionalQuestion__c c where CRFId__c = :lstOnStudyEligibility[0].Id and c.QuestionAnswer__r.AnswerType__c = 'Boolean'];
                    for(CRFAdditionalQuestion__c crfAddQues : lstCRFAddQues) {
                        if(crfAddQues.Answer__c == 'false') {
                            isAllOSEChecked = false;
                            break;
                        }       
                    }
                }
                
                randEleData.isAllOSECheckboxesChecked = isAllOSEChecked; 
            }
        } 
        system.debug('ose:'+crfStatusWrapper.IsSubmitted+':'+crfStatusWrapper.IsApproved);
        lstCRFStatusWrapper.add(crfStatusWrapper);
        
        
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'MammaPrint Form';
        
        List<MammaPrintDetail__c> lstMammaPrint = [select TargetPrint_Her_2_Status__c,Status__c, TrialPatient__c, MammaPrint_Risk__c, TargetPrint_Her_2_Index__c, H1_H2_status__c  from MammaPrintDetail__c where TrialPatient__c = :trialPatientId order by Effective_Time__c desc limit 1];
        if(!lstMammaPrint.isEmpty()) {
            if(lstMammaPrint[0].Status__c == 'Completed') {
                crfStatusWrapper.IsSubmitted = 'Yes';
            } else {
                crfStatusWrapper.IsSubmitted = 'Yes';
                crfStatusWrapper.IsApproved = 'Approval Not Required';
            }
            randEleData.h1h2Status = lstMammaPrint[0].H1_H2_status__c; 
            if(lstMammaPrint[0].MammaPrint_Risk__c == 'Low risk') {
                randEleData.MammaPrintRisk = '1';
            } else if(lstMammaPrint[0].MammaPrint_Risk__c == 'High risk') {
                randEleData.MammaPrintRisk = '2';
            } else if(lstMammaPrint[0].MammaPrint_Risk__c == 'Quantity not sufficient') {
                randEleData.MammaPrintRisk = 'QtNS';
            } else if(lstMammaPrint[0].MammaPrint_Risk__c == 'Quality not sufficient') {
                randEleData.MammaPrintRisk = 'QlNS';
            }
            //randEleData.MammaPrintRisk = lstMammaPrint[0].MammaPrint_Risk__c;
            randEleData.targetPrintHer2Status = lstMammaPrint[0].TargetPrint_Her_2_Status__c;
        } else {
            crfStatusWrapper.IsApproved = 'Approval Not Required';
        }
        system.debug('mamma:'+crfStatusWrapper.IsSubmitted+':'+crfStatusWrapper.IsApproved);
        lstCRFStatusWrapper.add(crfStatusWrapper);
        //crfStatusWrapper = new CRFStatusWrapper();
        
        return randEleData;
    }
    
    /*private List<RandomizePatient.CRFStatusWrapper> collectCRFStatus() {
        Integer her2TargrtPrint = 2; //-1-Negative, 1-Positive, 2-Other
        
        List<RandomizePatient.CRFStatusWrapper> lstCRFStatusWrapper = new List<RandomizePatient.CRFStatusWrapper>();
        
        system.debug('trialPatientId : '+trialPatientId);
        
        //List<Menopausal_Status_Detail__c> lstMenopausal = [select Status__c, TrialPatient__c from Menopausal_Status_Detail__c where TrialPatient__c = :trialPatientId order by Effective_Time__c desc limit 1];
        //system.debug('lstMenopausal : '+lstMenopausal);
        //crfStatusWrapper.CRFType = 'Menopausal Status Form';
        //if(!lstMenopausal.isEmpty()) {
        //  if(lstMenopausal[0].Status__c == 'Completed') {
        //      CRFStatusWrapper.IsSubmitted = 'Yes';
        //  } else if(lstMenopausal[0].Status__c == 'Approval Pending') {
        //      CRFStatusWrapper.IsSubmitted = 'Yes';
        //  } else if(lstMenopausal[0].Status__c == 'Accepted') {
        //      CRFStatusWrapper.IsSubmitted = 'Yes';
        //      CRFStatusWrapper.IsApproved = 'Yes';
        //  }
        //} 
        
        //lstCRFStatusWrapper.add(CRFStatusWrapper);
        //crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        RandomizePatient.CRFStatusWrapper crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'MRI Volume Form';
                
        List<MRI_Volume__c> lstMRIVolume = [select Status__c, TrialPatient__c from MRI_Volume__c where TrialPatient__c = :trialPatientId and Time_Point__c = 'Pre-Treatment' order by Effective_Time__c desc limit 1];
        system.debug('lstMRIVolume : '+lstMRIVolume);
        if(!lstMRIVolume.isEmpty()) {
            if(lstMRIVolume[0].Status__c == 'Completed') {
                crfStatusWrapper.IsSubmitted = 'Yes';
            } else if(lstMRIVolume[0].Status__c == 'Approval Pending') {
                crfStatusWrapper.IsSubmitted = 'Yes';
            } else if(lstMRIVolume[0].Status__c == 'Accepted') {
                crfStatusWrapper.IsSubmitted = 'Yes';
                crfStatusWrapper.IsApproved = 'Yes';
            }
        }
    
        lstCRFStatusWrapper.add(crfStatusWrapper);
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'On Study Pathology Form';
        
        //List<On_Study_Pathology_Form__c> lstOnStudyPathology = [Select o.Status__c, o.TrialPatient__c From On_Study_Pathology_Form__c o where TrialPatient__c = :trialPatientId];
        //List<On_Study_Pathology_Form__c> lstOnStudyPathology = [Select o.Status__c, o.TrialPatient__c, (Select Estrogen_Receptor_Status__c, Fish__c, IHC__c, Progesterone_Receptor_Status__c From Receptors__r) From On_Study_Pathology_Form__c o where TrialPatient__c = :trialPatientId order by Effective_Time__c desc limit 1];
        List<On_Study_Pathology_Form__c> lstOnStudyPathology = [Select o.Status__c, o.TrialPatient__c, (Select Estrogen_Receptor_Status__c, Fish__c, IHC__c, Progesterone_Receptor_Status__c From Receptors__r) From On_Study_Pathology_Form__c o where TrialPatient__c = :trialPatientId and Status__c = 'Accepted' order by Effective_Time__c desc limit 1];
        for(On_Study_Pathology_Form__c OSP : lstOnStudyPathology){
            if(OSP.Status__c == 'Completed') {
                crfStatusWrapper.IsSubmitted = 'Yes';
            } else if(OSP.Status__c == 'Accepted') {
                crfStatusWrapper.IsSubmitted = 'Yes';
                crfStatusWrapper.IsApproved = 'Yes';
            } else if(OSP.Status__c == 'Approval Pending') {
                crfStatusWrapper.IsSubmitted = 'Yes';
            }
            List<Receptors__c> lstReceptors = OSP.Receptors__r;
            if(lstReceptors != null && !lstReceptors.isEmpty()) {
                
                erStatus = lstReceptors[0].Estrogen_Receptor_Status__c;
                if(erStatus == null) {
                    erStatus = 'Negative';
                }
                ICH_HER2_Status = lstReceptors[0].IHC__c;
                FISH_HER2_Status = lstReceptors[0].Fish__c;
                
                integer ichHer2 = 2; //nither +ve nor -ve then ichHer2 = 2
                integer fishHer2 = 2; //nither +ve nor -ve then fishHer2 = 2
                integer er = 2; //nither +ve nor -ve then er = 2
                
                if (ICH_HER2_Status == 'Positive') {
                    ichHer2 = 1;
                } else if (ICH_HER2_Status == 'Negative') {
                    ichHer2 = 0;
                }
                
                if (FISH_HER2_Status == 'Positive') {
                    fishHer2 = 1;
                } else if (FISH_HER2_Status == 'Negative') {
                    fishHer2 = 0;
                }
                
                //if(her2TargrtPrint == 1 || ichHer2 == 1 || fishHer2 == 1 && (mp == 0 || mp == 1)) {
                if(her2TargrtPrint == 1 || ichHer2 == 1 || fishHer2 == 1) {
                    HER2Status = 'Positive';
                } else {
                    HER2Status = 'Negative';
                }
            }  
        }
        lstCRFStatusWrapper.add(crfStatusWrapper);
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'On Study Eligibility Form';
        
        List<On_Study_Eligibility_Form__c> lstOnStudyEligibility = [select Status__c, TrialPatient__c, No_Clinical_Or_Imaging_Evidence__c, No_Uncontrolled_or_Cardiovascular_Diseas__c, No_history_of_allergic_reactions__c, No_uncontrolled_intercurrent_illness__c, Not_had_a_sentinel_lymph_node__c, Lab_Values__c, Leukocytes_3000_L__c, Absolute_Neutrophil_count_1500_L__c, Platelets_100_000_L__c, Total_Bilirubin_within_institutional__c, AST_SGOT_or_ALT_SGPT_1_5_x_insti__c, Creatinine_1_5_x_institutional_ULN__c from On_Study_Eligibility_Form__c where TrialPatient__c = :trialPatientId and Status__c NOT IN ('Cloned', 'Rejected') order by Effective_Time__c desc limit 1];
        if(!lstOnStudyEligibility.isEmpty()) {
            if(lstOnStudyEligibility[0].Status__c == 'Completed') {
                crfStatusWrapper.IsSubmitted = 'Yes';
            } else if(lstOnStudyEligibility[0].Status__c == 'Approval Pending') {
                crfStatusWrapper.IsSubmitted = 'Yes';
            } else if(lstOnStudyEligibility[0].Status__c == 'Accepted') {
                crfStatusWrapper.IsSubmitted = 'Yes';
                crfStatusWrapper.IsApproved = 'Yes';
                boolean isAllOSEChecked = false;
                if(lstOnStudyEligibility[0].No_Clinical_Or_Imaging_Evidence__c && 
                    lstOnStudyEligibility[0].No_Uncontrolled_or_Cardiovascular_Diseas__c && 
                    lstOnStudyEligibility[0].No_history_of_allergic_reactions__c && 
                    lstOnStudyEligibility[0].No_uncontrolled_intercurrent_illness__c && 
                    lstOnStudyEligibility[0].Not_had_a_sentinel_lymph_node__c && 
                    lstOnStudyEligibility[0].Lab_Values__c && 
                    lstOnStudyEligibility[0].Leukocytes_3000_L__c && 
                    lstOnStudyEligibility[0].Absolute_Neutrophil_count_1500_L__c && 
                    lstOnStudyEligibility[0].Platelets_100_000_L__c && 
                    lstOnStudyEligibility[0].Total_Bilirubin_within_institutional__c && 
                    lstOnStudyEligibility[0].AST_SGOT_or_ALT_SGPT_1_5_x_insti__c && 
                    lstOnStudyEligibility[0].Creatinine_1_5_x_institutional_ULN__c) {
                    isAllOSEChecked = true;
                    //List<CRFAdditionalQuestion__c> lstCRFAddQues = [Select c.QuestionAnswer__r.AnswerType__c, c.QuestionAnswer__c, c.CRFId__c, c.Answer__c From CRFAdditionalQuestion__c c where CRFId__c = :lstOnStudyEligibility[0].Id and c.QuestionAnswer__r.AnswerType__c = 'Boolean'];
                    //for(CRFAdditionalQuestion__c crfAddQues : lstCRFAddQues) {
                    //  if(crfAddQues.Answer__c == 'false') {
                    //      isAllOSEChecked = false;
                    //      break;
                    //  }       
                    //}
                }
                
                isAllOSECheckboxesChecked = isAllOSEChecked; 
            }
        } 
        
        lstCRFStatusWrapper.add(crfStatusWrapper);
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'MammaPrint Form';
        
        List<MammaPrintDetail__c> lstMammaPrint = [select Status__c, TrialPatient__c, MammaPrint_Risk__c, TargetPrint_Her_2_Index__c, H1_H2_status__c  from MammaPrintDetail__c where TrialPatient__c = :trialPatientId order by Effective_Time__c desc limit 1];
        if(!lstMammaPrint.isEmpty()) {
            if(lstMammaPrint[0].Status__c == 'Completed') {
                crfStatusWrapper.IsSubmitted = 'Yes';
            } else {
                crfStatusWrapper.IsSubmitted = 'Yes';
                crfStatusWrapper.IsApproved = 'Approval Not Required';
            }
            h1h2Status = lstMammaPrint[0].H1_H2_status__c; 
            MammaPrintRisk = lstMammaPrint[0].MammaPrint_Risk__c;
            
            if(MammaPrintRisk == 'Low risk') {
                mp = 0;
            } else if(MammaPrintRisk == 'High risk') {
                mp = 1;
            } else if(MammaPrintRisk == 'Quantity not sufficient') {
                mp = 2;
            } else if(MammaPrintRisk == 'Quality not sufficient') {
                mp = 3;
            }
            
            Decimal tpHer2 = 0;
            tpHer2 = lstMammaPrint[0].TargetPrint_Her_2_Index__c;
            if (tpHer2 <= 0.0) {
                her2TargrtPrint = -1;
            }else if (tpHer2 > 0.0 && tpHer2<=1) {
                her2TargrtPrint = 1;
            }else {
                her2TargrtPrint=2;
            }
        } else {
            crfStatusWrapper.IsApproved = 'Approval Not Required';
        }
        
        lstCRFStatusWrapper.add(crfStatusWrapper);
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        return lstCRFStatusWrapper;
    }*/
    
    /*public boolean checkPatientEligibilityForRandomization() {
        //return true;
        lstCRFStatusWrapper = collectCRFStatus();
        system.debug('lstCRFStatusWrapper : '+lstCRFStatusWrapper);
        for(CRFStatusWrapper crfStatus : lstCRFStatusWrapper) {
            //if(crfStatus.CRFType == 'Menopausal Status Form') {
            //  if(crfStatus.IsSubmitted == 'No') {
            //      //return false;
            //  }
            //  if(crfStatus.IsApproved == 'No') {
            //      //return false;
            //  }
            //}
            
            if(crfStatus.CRFType == 'MRI Volume Form') {
                if(crfStatus.IsSubmitted == 'No') {
                    return false;
                }
                if(crfStatus.IsApproved == 'No') {
                    return false;
                }
            }
            
            if(crfStatus.CRFType == 'On Study Eligibility Form') {
                if(crfStatus.IsSubmitted == 'No') {
                    return false;
                }
                if(crfStatus.IsApproved == 'No') {
                    return false;
                }
            }
            
            if(crfStatus.CRFType == 'On Study Pathology Form') {
                if(crfStatus.IsSubmitted == 'No') {
                    return false;
                }
                if(crfStatus.IsApproved == 'No') {
                    return false;
                }
            }
            
            if(crfStatus.CRFType == 'MammaPrint Form') {
                if(crfStatus.IsSubmitted == 'No') {
                    return false;
                }
                if(h1h2Status == 'Undetermined') {
                    eligibleMessage = 'H1 H2 status is Undetermined';
                    return false;
                }
            }
            system.debug('erStatus : '+erStatus);
            system.debug('HER2Status : '+HER2Status);
            system.debug('MammaPrintRisk : '+MammaPrintRisk);
        }
        
        if(erStatus == 'Positive' && HER2Status == 'Negative' && (MammaPrintRisk == 'Low risk' || MammaPrintRisk == 'Quantity not sufficient' || MammaPrintRisk == 'Quality not sufficient')) {
            
            //Not eligible randomize due to MammaPrint Low, ER+ and Her2-
            
            eligibleMessage = '(Because ER Status-'+erStatus+',   HER2 Status-'+HER2Status+',   MammaPrintRisk-'+MammaPrintRisk+')';
            return false;
        } else if(isAllOSECheckboxesChecked != null && !isAllOSECheckboxesChecked) {
            eligibleMessage = '(All Eligibility checklist checkboxes are not checked)';
            return false;
        } else {
            eligibleMessage = '';
        }
            
        return true;
    }*/
    
    public Pagereference newRandomizationForm() {
        Pagereference ref = null;
        
        /*RandomizePatient.RandomizationEligibilityData red = collectRandomizationEligibilityData(trialPatientId);

        if(rdv.isEligible) {
            //ref = new Pagereference('/a17/e?CF00Nc0000000GwtR='+trialPatientName+'&CF00Nc0000000GwtR_lkid='+trialPatientId+'&retURL=%2Fa0gc00000009cWs&sfdc.nooverride=1');
            isRandomized = true;
            callRandomization = true;
            
        } else {
            isRandomized = false;
            lstSign = new List<SelectOption>();
            lstSign.add(new SelectOption('false','No - Reason why not:'));
        }
        ref = new Pagereference('/apex/randomizationform?trialPat'+trialPatientId);
        ref.setRedirect(true);*/
        return ref; 
    }
    
    public pagereference redirect(){
       // pagereference redirect = new pagereference('/apex/RandomizationFormpdf?id='+formId );
       pagereference redirect = new pagereference('/apex/RandomizationFormpdf?id='+formId +'&trialPat='+Apexpages.currentPage().getparameters().get('trialPat'));
        redirect.setRedirect(false);
        return redirect;
    }
    
    public boolean callRandomization {get;set;}
    
    public Pagereference next(){ 
        system.debug('__currentTab__'+currentTab);
        String nextTabValue = Apexpages.currentPage().getParameters().get('nextTab');
        system.debug('__currentTab__'+currentTab);
        Randomization_Form__c randObjj;
                System.debug('====== formId =======' + formId);
                if(formId != null){
                    System.debug('====== formId =======' + formId);
                    randObjj= [select Id, Status__c from  Randomization_Form__c  where id =: formId ];
                    if( randObjj.Status__c == 'Approval Not Required'){
                     System.debug('====== randObjj.Status__c =======' + randObjj.Status__c);
                    //isComplete= false;
                   // currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/RandomizationForm?id='+formId);
                Pagereference ref = new Pagereference('/'+formId);
                ref.setRedirect(true);
                return ref;
             }
             }
             
        
        if(nextTabValue != null) {
            nextTabName = nextTabValue;
        }       
        if(currentTab == 'FirstTab') {
            system.debug('randObj : '+randObj);
            system.debug('herStatus : '+HER2Status);
            if(Selectedsign == 'false' && randObj.Why_Patient_Not_Signed_Consent_Form__c == null) {
                randObj.addError('If patient did not sign treatment consent then please select the Reason.');
                if(randObj.Randomization_Result__c != null && randObj.Randomization_Result__c != 'Not Randomized') {
                    armNOTAssigned = false;
                } else {
                    armNOTAssigned = true;
                }
                return null;
            }
            List<Randomization_Form__c> lstRandomizationFrom = [Select r.Test_Case_Number__c, r.Not_Randomized_Reason__c,r.First_Save_and_Close__c, r.TrialPatient__c, r.Status__c, r.Consent_Signed_Date__c, r.Why_Patient_Not_Signed_Consent_Form__c, r.Randomization_Result__c, r.Other_Reason_Did_Not_Sign_Consent_Form__c, r.Name, r.Id, r.Did_Patient_Sign_Treatment_Consent_Form__c, r.CompletedDate__c, r.CRF__c From Randomization_Form__c r where TrialPatient__c = :trialPatientId];
            if(!lstRandomizationFrom.isEmpty()) {
                randObj.Randomization_Result__c = lstRandomizationFrom[0].Randomization_Result__c;
                randObj.Did_Patient_Sign_Treatment_Consent_Form__c = Boolean.valueOf(Selectedsign);
                if(randObj.Randomization_Result__c != null && randObj.Randomization_Result__c != 'Not Randomized') {
                    armNOTAssigned = false;
                } else {
                    armNOTAssigned = true;
                }
            }
            if(randObj.Randomization_Result__c != null && randObj.Randomization_Result__c != 'Not Randomized') {
                armNOTAssigned = false;
            } else {
                armNOTAssigned = true;
            }
             // Added by Shruti (DE401)
            try {
                upsert randObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/RandomizationForm?id='+formId);
            Pagereference ref = new Pagereference('/'+formId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)
             
        }
        if(nextTabName == 'saveAndClose') {
            randObj.First_Save_and_Close__c = true;
            if(randObj.Randomization_Result__c != null && randObj.Randomization_Result__c != 'Not Randomized') {
                armNOTAssigned = false;
            } else {
                armNOTAssigned = true;
            }
            // Added by Shruti (DE401)
            try {
                upsert randObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
             //Pagereference ref = new Pagereference('/apex/RandomizationForm?id='+formId);
             Pagereference ref = new Pagereference('/'+formId);
            ref.setRedirect(true);
             return ref;             
            } 
            // Added by Shruti (DE401)            
            List<TrialPatient__c> trialPatList = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id =:TrialPatientId];
            if(!trialPatList.isEmpty()) {
                Pagereference pr = new Pagereference('/apex/TranscendPage?id='+trialPatList[0].Patient_Id__c+'&TrialId='+trialPatList[0].Trial_Id__c+'&sfdc.override=1');
                pr.setRedirect(true);
                return pr;
            }
            
        }
        currentTab = nextTabName;
        return null;
    }
    
    // public void previous(){
       public Pagereference previous(){ //Added by Shruti (DE401)
        Randomization_Form__c randObjj;
                System.debug('====== formId =======' + formId);
                if(formId != null){
                    System.debug('====== formId =======' + formId);
                    randObjj= [select Id, Status__c from  Randomization_Form__c  where id =: formId ];
                    if( randObjj.Status__c == 'Approval Not Required'){
                     System.debug('====== randObjj.Status__c =======' + randObjj.Status__c);
                    //isComplete= false;
                   // currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/RandomizationForm?id='+formId);
                Pagereference ref = new Pagereference('/'+formId);
                ref.setRedirect(true);
                return ref;
             }
             }
        if(currentTab == 'SecondTab') {
            currentTab = 'FirstTab';
        }
       // Added by Shruti (DE401)
          /*  try {
                update randObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/RandomizationForm?id='+formId);
            Pagereference ref = new Pagereference('/'+formId);
            ref.setRedirect(true);
             return ref;             
            } */
              return null; 
            // Added by Shruti (DE401) 
    }
    
    public Pagereference saveMainCRF() {
        List<Randomization_Form__c> lstRandomizationFrom = [Select r.Test_Case_Number__c , r.Not_Randomized_Reason__c, r.First_Save_and_Close__c, r.TrialPatient__c,r.TrialPatient__r.Site__r.IsTestSite__c, r.Status__c, r.Consent_Signed_Date__c, r.Why_Patient_Not_Signed_Consent_Form__c, r.Randomization_Result__c, r.Other_Reason_Did_Not_Sign_Consent_Form__c, r.Name, r.Id, r.Did_Patient_Sign_Treatment_Consent_Form__c, r.CompletedDate__c, r.CRF__c From Randomization_Form__c r where TrialPatient__c = :trialPatientId];
        system.debug('formId:'+formId);
        if(formId == null) {
            
            Randomization_Form__c randObj = new Randomization_Form__c();
            //List<Randomization_Form__c> lstRandomizationFrom = [Select r.TrialPatient__c, r.Status__c, r.Consent_Signed_Date__c, r.Why_Patient_Not_Signed_Consent_Form__c, r.Randomization_Result__c, r.Other_Reason_Did_Not_Sign_Consent_Form__c, r.Name, r.Id, r.Did_Patient_Sign_Treatment_Consent_Form__c, r.CompletedDate__c, r.CRF__c From Randomization_Form__c r where TrialPatient__c = :trialPatientId];
            if(!lstRandomizationFrom.isEmpty()) {
                randObj = lstRandomizationFrom[0];
            } else {
                randObj.TrialPatient__c = trialPatientId;
                randObj.Did_Patient_Sign_Treatment_Consent_Form__c = boolean.valueOf(Selectedsign);
                randObj.Consent_Signed_Date__c = system.today();
                insert randObj;
            }
            
            Pagereference ref = new Pagereference('/apex/randomizationform?trialPat='+trialPatientId+'&formId='+randObj.Id);
            
            ref.setRedirect(true);
            system.debug('randObj.Id : '+randObj.Id+'trialPat='+trialPatientId);
            return ref;
            
        } else {
            if(!lstRandomizationFrom.isEmpty() && (lstRandomizationFrom[0].Randomization_Result__c == null 
                || lstRandomizationFrom[0].Randomization_Result__c == '' || lstRandomizationFrom[0].Randomization_Result__c == 'Not Randomized')) {
                
                randObj = lstRandomizationFrom[0];
                RandomizePatient.RandomizationEligibilityData red = collectRandomizationEligibilityData(trialPatientId);
                //RandomizePatient.RandomizationDataValidationOutcome rdv = RandomizePatient.checkPatientEligibilityForRandomization(red);
                //randObj.Test_Case_Number__c = rdv.testCaseNumber;
                //system.debug('rdv:'+rdv);
                //if(rdv.isEligible) {
                //  randomizeMessage = 'Patient is eligible to Randomized.';
                //  eligibleMessage = '';
                //  if(randObj.Randomization_Result__c == null || randObj.Randomization_Result__c == 'Not Randomized') {
                //      system.debug('Calling randomization from new controller');
                RandomizePatient.RandomizationResponseWrapper rrw = randomizePatient(red, randObj.TrialPatient__r.Site__r.IsTestSite__c);
                //  }
                //} else if(!rdv.isEligible){
                //  randObj.Randomization_Result__c = 'Not Randdomized';
                //  randomizeMessage = 'Patient is not eligible to Randomized.';
                //  eligibleMessage = rdv.message;
                //}
                if(rrw.isEligible) {
                    randomizeMessage = 'Patient is eligible to Randomized.';
                } else {
                    randomizeMessage = 'Patient is not eligible to Randomized.';
                    eligibleMessage = rrw.notRandomizedReason;
                }
                randObj = [Select r.Test_Case_Number__c , r.Not_Randomized_Reason__c, r.First_Save_and_Close__c, r.TrialPatient__c,r.TrialPatient__r.Site__r.IsTestSite__c, r.Status__c, r.Consent_Signed_Date__c, r.Why_Patient_Not_Signed_Consent_Form__c, r.Randomization_Result__c, r.Other_Reason_Did_Not_Sign_Consent_Form__c, r.Name, r.Id, r.Did_Patient_Sign_Treatment_Consent_Form__c, r.CompletedDate__c, r.CRF__c From Randomization_Form__c r where TrialPatient__c = :trialPatientId][0];
                system.debug('randomizeMessage:'+randomizeMessage);
                system.debug('eligibleMessage:'+eligibleMessage);
            } else {
                collectRandomizationEligibilityData(trialPatientId);
            }
        }
        return null;
    }
    public Pagereference cancelCRF(){
        
        List<TrialPatient__c> lstTP = [select Patient_Id__c, Trial_Id__c from TrialPatient__c where Id = :trialPatientId];
        if(!lstTP.isEmpty()) {
            // Added by Shruti (DE401)
             Randomization_Form__c randObjj;
                System.debug('====== formId =======' + formId);
                if(formId != null){
                    System.debug('====== formId =======' + formId);
                    randObjj= [select Id, Status__c from  Randomization_Form__c  where id =: formId ];
                    if( randObjj.Status__c == 'Approval Not Required'){
                     System.debug('====== randObjj.Status__c =======' + randObjj.Status__c);
                    //isComplete= false;
                   // currentTab='CompleteTab';
               // Pagereference ref = new Pagereference('/apex/RandomizationForm?id='+formId);
                Pagereference ref = new Pagereference('/'+formId);
                ref.setRedirect(true);
                return ref;
             }
            
             else
                                 {   
                                delete randObj;
                                // System.debug('====bloodSpecimen===='+bloodSpecimen);
                                 }
                                 }
          /*  try {
                delete randObj;
            }catch (Exception e) {
                Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
                Apexpages.addMessage(msg);                 
            // Pagereference ref = new Pagereference('/apex/RandomizationForm?id='+formId);
            Pagereference ref = new Pagereference('/'+formId);
            ref.setRedirect(true);
             return ref;             
            } */
            // Added by Shruti (DE401)            
            return new Pagereference('/apex/TranscendPage?id='+lstTP[0].Patient_Id__c+'&TrialId='+lstTP[0].Trial_Id__c);
        } else {
            errorMsg = 'Error in Cancelling Randomization CRF.';
            return null;
        }
    }
    
    private RandomizePatient.RandomizationResponseWrapper randomizePatient(RandomizePatient.RandomizationEligibilityData red, boolean patientBelongsToTestSite) {
        
        RandomizationXMLBuilder rb = new RandomizationXMLBuilder();
        RandomizePatient.RandomizationResponseWrapper rrw = rb.randomizePatient(red, randObj.TrialPatient__c, patientBelongsToTestSite, false, trialPatientObj.Trial_Id__r.Name);
        
        List<Randomization_Form__c> lstRandomizationFrom = [Select r.Test_Case_Number__c, r.Not_Randomized_Reason__c, r.First_Save_and_Close__c, r.Randomization_Result__c From Randomization_Form__c r where TrialPatient__c = :trialPatientId];
        if(!lstRandomizationFrom.isEmpty()) {
            randObj.Randomization_Result__c = lstRandomizationFrom[0].Randomization_Result__c;
            if(randObj.Randomization_Result__c != null && randObj.Randomization_Result__c != 'Not Randomized') {
                armNOTAssigned = false;
            } else {
                armNOTAssigned = true;
            }
            callRandomization = false;
        }
        return rrw;
    }
    
    public Pagereference signAndSubmit(){
        
        SignAndSubmitController signSubmit = new SignAndSubmitController();
        signSubmit.password = password;
        Pagereference ref = signSubmit.signAndSubmit('00005','',randObj.Id+'', 'Site');
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
}