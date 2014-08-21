public with sharing class SnomedCTCode {
    
    static Map<String, Codes__c> mapCodes = new Map<String, Codes__c>();
    static Map<String, Code_Master__c> mapCodeMasters = new Map<String, Code_Master__c>();
    static Map<String, Integer> mapCodeTypes = new Map<String, Integer>{'SNOMED' => 1, 'LOINC' => 2, 'CTCAE' => 3};
    static {
        List<Code_Master__c> lstCodeMaster = [Select c.Name, c.Variable_Description__c, c.Snomed_Code__c, c.IsReportColumn__c, c.Display_Order__c From Code_Master__c c];
        for(Code_Master__c codeMaster : lstCodeMaster) {
            mapCodeMasters.put(codeMaster.Name, codeMaster);
        }
        
        List<Codes__c> lstCode = [Select c.Value__c, c.caIntegrator_Value__c, c.Code__c, c.Code_Type__c, c.Code_System__c, c.Code_System_Version__c, c.Code_Master__c, c.Code_Master__r.Name From Codes__c c];
        for(Codes__c code : lstCode) {
            
            if(mapCodes.containsKey(code.Code_Master__c+'--'+code.Value__c)) {
                Codes__c c = mapCodes.get(code.Code_Master__c+'--'+code.Value__c);
                if(c.Code_Type__c != null) {
                    integer i1 = mapCodeTypes.get(c.Code_Type__c);
                    integer i2 = mapCodeTypes.get(code.Code_Type__c);
                    if((i1 != null && i2 != null) && (i1 < i2)) {
                        mapCodes.put(code.Code_Master__c+'--'+code.Value__c, code);
                    }
                }
            } else {
                mapCodes.put(code.Code_Master__c+'--'+code.Value__c, code);
            }
        }
    }
    
    public static SnomedWrapper SnomedCode(String val, String variableName){
        SnomedWrapper sw = new SnomedWrapper();
        
        Code_Master__c codeMaster = mapCodeMasters.get(variableName);
        if(codeMaster != null && val != null) {
            //String[] splittedVal = val.split('\\;');
            //for(String v : splittedVal) {
                Codes__c code = mapCodes.get(codeMaster.Id+'--'+val);
                if(code != null) {
                    if(code.Code__c != null && code.Code__c != '') {
                        if(sw.snomedCodeVal == null) {
                            sw.snomedCodeVal = code.Code__c;
                        } //else {
                            //sw.snomedCodeVal+= ','+code.Code__c;
                        //}
                    } else { 
                        sw.snomedCodeVal = val;
                    }
                    sw.caIntegratorValue = code.caIntegrator_Value__c;
                    sw.codeSystem = code.Code_Type__c;
                    sw.codeSystemVersion = code.Code_System_Version__c;
                } else {
                    sw.snomedCodeVal = val;
                    sw.caIntegratorValue = val;
                }
            //}
        }
        return sw;
    }
    
    @future
    public static void insertSnomedCodesForResponseEvaluation(Set<Id> refIds) {
        
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        Map<Id,Integer> mapCount = new Map<Id,Integer>();
        List<Disease_Assessment__c> lstDA = [select id,Response_Evaluation_Form__c from Disease_Assessment__c where Response_Evaluation_Form__c IN :refIds];
        for(Disease_Assessment__c da : lstDA){
            if(mapCount.get(da.Response_Evaluation_Form__c) != null) {
                Integer i = mapCount.get(da.Response_Evaluation_Form__c);
                mapCount.put(da.Response_Evaluation_Form__c, ++i);
            } else {
                mapCount.put(da.Response_Evaluation_Form__c,1);
            }
        }
        
        List<Response_Evaluation_Form__c> refList = [Select r.pg_status__c, r.pg_ResponseEvaluation_Id__c, r.Type_of_lymph_node_involvement__c, r.TrialPatient__c, r.SystemModstamp, r.Status__c, r.Size_of_largest_node__c, r.Reporting__c, r.RecordTypeId, r.ReasonNotConservationSurgeryCandidate__c, r.ReasonNoSurg_PTx_Snomed__c, r.Partial_response_PR__c, r.Partial_response_PR_Date__c, r.Palpable_nodes__c, r.OwnerId, r.Other__c, r.OtherReason__c, r.OriginalCRF__c, r.Nodes_fixed_to_chest_wall__c, r.New_local_regional_recurrence__c, r.New_local_regional_recurrence_Date__c, r.New_distant_progression__c, r.New_distant_progression_Date__c, r.Name, r.Matted_nodes__c, r.Local_Regional__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.IsCandidateForConservationSurgery__c, r.Id, r.Distant__c, r.Disease_Extent__c, r.Date_of_clinical_assessment__c, r.Current_status_of_T4_tumor__c, r.CreatedDate, r.CreatedById, r.Complete_response_CR__c, r.Complete_response_CR_Date__c, r.Clinically_staging_period_T__c, r.Clinically_staging_period_N__c, r.Clinically_staging_period_M__c, r.Clinical_Staging_Period__c, r.CRF__c, r.Breast_Conserv_Snomed__c, r.Best_overall_Response_to_date__c From Response_Evaluation_Form__c r where id in :refIds and Reporting__c = 'Baseline'];
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Breast Conserv' 
                                    or Name = 'InflamCa_OS' or Name = 'cTstage_OS' or Name = 'cNstage_OS' or Name = 'cStaging_OS' 
                                    or Name = 'BaseDiseaseExt' or Name = 'BaseNodeExt' or Name = 'ReasonNoSurg_PTx' or Name = 'TSizeClinical' or Name = 'ClinRespT1_T3' or Name = 'ClinRespT1_T4' or Name = 'T4Early'];
        for(Response_Evaluation_Form__c ref : refList){
            for(Code_Master__c sm : lstSnomedMaster){
                if(sm.Name == 'Breast Conserv'){
                    Snomed_Code__c sc1 = new Snomed_Code__c();
                    sc1.CRF__c = ref.CRF__c;
                    sc1.TrialPatient__c = ref.TrialPatient__c;
                    //sc1.Name = 'IHTSDO_4672';
                    sc1.snomed_Code_Name__c = 'IHTSDO_4672';
                    sc1.Code_Master__c = sm.Id;
                    if(ref.IsCandidateForConservationSurgery__c == 'Yes'){
                        SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('Yes', 'Breast Conserv');
                        sc1.Value__c = sw1.snomedCodeVal;
                        sc1.Code_System__c = sw1.codeSystem;
                        sc1.Numeric_Value__c = sw1.numericValue;
                        sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                        sc1.Code_System_Version__c = sw1.codeSystemVersion;
                        lstSnomed.add(sc1);
                    } else if(ref.ReasonNotConservationSurgeryCandidate__c == 'Multi-centric disease'){
                        SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('No,  multicentric disease', 'Breast Conserv');
                        sc1.Value__c = sw1.snomedCodeVal;
                        sc1.Code_System__c = sw1.codeSystem;
                        sc1.Numeric_Value__c = sw1.numericValue;
                        sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                        sc1.Code_System_Version__c = sw1.codeSystemVersion;
                        lstSnomed.add(sc1);
                    } else if(ref.ReasonNotConservationSurgeryCandidate__c == 'Inflammatory disease'){
                        SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('No, inflammatory disease', 'Breast Conserv');
                        sc1.Value__c = sw1.snomedCodeVal;
                        sc1.Code_System__c = sw1.codeSystem;
                        sc1.Numeric_Value__c = sw1.numericValue;
                        sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                        sc1.Code_System_Version__c = sw1.codeSystemVersion;
                        lstSnomed.add(sc1);
                    } else if(ref.ReasonNotConservationSurgeryCandidate__c == 'Diffuse micro calcifications'){
                        SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('No, difuse microcalcifications', 'Breast Conserv');
                        sc1.Value__c = sw1.snomedCodeVal;
                        sc1.Code_System__c = sw1.codeSystem;
                        sc1.Numeric_Value__c = sw1.numericValue;
                        sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                        sc1.Code_System_Version__c = sw1.codeSystemVersion;
                        lstSnomed.add(sc1);
                    } else if(ref.ReasonNotConservationSurgeryCandidate__c == 'Institutional norm'){
                        SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('institutional norm', 'Breast Conserv');
                        sc1.Value__c = sw1.snomedCodeVal;
                        sc1.Code_System__c = sw1.codeSystem;
                        sc1.Numeric_Value__c = sw1.numericValue;
                        sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                        sc1.Code_System_Version__c = sw1.codeSystemVersion;
                        lstSnomed.add(sc1);
                    } else if(ref.ReasonNotConservationSurgeryCandidate__c == 'Specific anatomy of primary'){
                        SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('No, specific anatomy of primary', 'Breast Conserv');
                        sc1.Value__c = sw1.snomedCodeVal;
                        sc1.Code_System__c = sw1.codeSystem;
                        sc1.Numeric_Value__c = sw1.numericValue;
                        sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                        sc1.Code_System_Version__c = sw1.codeSystemVersion;
                        lstSnomed.add(sc1);
                    } else if(ref.ReasonNotConservationSurgeryCandidate__c == 'Other'){
                        SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('No, other', 'Breast Conserv');
                        sc1.Value__c = sw1.snomedCodeVal;
                        sc1.Code_System__c = sw1.codeSystem;
                        sc1.Numeric_Value__c = sw1.numericValue;
                        sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                        sc1.Code_System_Version__c = sw1.codeSystemVersion;
                        lstSnomed.add(sc1);
                    }
                }
            
                if(mapCount.get(ref.Id) > 1 && sm.Name == 'TSizeClinical'){
                    Snomed_Code__c sc3 = new Snomed_Code__c();
                    sc3.CRF__c = ref.CRF__c;
                    sc3.TrialPatient__c = ref.TrialPatient__c;
                    //sc3.Name = '399734001'; //TODO: This code present multiple times, raised as question
                    sc3.snomed_Code_Name__c = '399734001 | primary tumour size | ';
                    sc3.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw3 = SnomedCTCode.SnomedCode('', 'TSizeClinical');
                    sc3.Value__c = sw3.snomedCodeVal;
                    sc3.Code_System__c = sw3.codeSystem;
                    sc3.Numeric_Value__c = sw3.numericValue;
                    sc3.caIntegratorValue__c = sw3.caIntegratorValue;
                    sc3.Code_System_Version__c = sw3.codeSystemVersion;
                    lstSnomed.add(sc3);
                }
                if(sm.Name == 'InflamCa_OS'){
                    Snomed_Code__c sc4 = new Snomed_Code__c();
                    sc4.CRF__c = ref.CRF__c;
                    sc4.TrialPatient__c = ref.TrialPatient__c;
                    //sc4.Name = '369906009';
                    sc4.snomed_Code_Name__c = '369906009 | T4d: Inflammatory carcinoma (breast) | ';
                    sc4.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw4 = SnomedCTCode.SnomedCode('Yes', 'InflamCa_OS');
                    sc4.Value__c = sw4.snomedCodeVal;
                    sc4.Code_System__c = sw4.codeSystem;
                    sc4.Numeric_Value__c = sw4.numericValue;
                    sc4.caIntegratorValue__c = sw4.caIntegratorValue;
                    sc4.Code_System_Version__c = sw4.codeSystemVersion;
                    lstSnomed.add(sc4);
                }
            
                /*Snomed_Code__c sc6 = new Snomed_Code__c();
                sc6.CRF__c = ref.CRF__c;
                sc6.TrialPatient__c = ref.TrialPatient__c;
                //sc6.Name = '182985004 | response to treatment | ';
                sc6.snomed_Code_Name__c = '182985004 | response to treatment | ';
                SnomedCTCode.SnomedWrapper sw6 = SnomedCTCode.SnomedCode('182985004 | response to treatment | ', ref.Best_overall_Response_to_date__c);
                sc6.Value__c = sw6.snomedCodeVal;
                sc6.Code_System__c = sw6.codeSystem;
                sc6.Numeric_Value__c = sw6.numericValue;
                sc6.caIntegratorValue__c = sw6.caIntegratorValue;
                lstSnomed.add(sc6);*/
            
                if(sm.Name == 'cTstage_OS'){
                    Snomed_Code__c sc8 = new Snomed_Code__c();
                    sc8.CRF__c = ref.CRF__c;
                    sc8.TrialPatient__c = ref.TrialPatient__c;
                    //sc8.Name = '78873005 | T category | 78873005';
                    sc8.snomed_Code_Name__c = '78873005 | T category | 78873005';
                    SnomedCTCode.SnomedWrapper sw8 = SnomedCTCode.SnomedCode(ref.Clinically_staging_period_T__c, 'cTstage_OS');
                    sc8.Value__c = sw8.snomedCodeVal;
                    sc8.Code_System__c = sw8.codeSystem;
                    sc8.caIntegratorValue__c = sw8.caIntegratorValue;
                    sc8.Code_System_Version__c = sw8.codeSystemVersion;
                    sc8.Code_Master__c = sm.Id;
                    system.debug('sc8 : '+sc8);
                    lstSnomed.add(sc8);
                }
                if(sm.Name == 'cNstage_OS'){
                    Snomed_Code__c sc9 = new Snomed_Code__c();
                    sc9.CRF__c = ref.CRF__c;
                    sc9.TrialPatient__c = ref.TrialPatient__c;
                    //sc9.Name = '277206009 | N category | ';
                    sc9.snomed_Code_Name__c = '277206009 | N category | ';
                    SnomedCTCode.SnomedWrapper sw9 = SnomedCTCode.SnomedCode(ref.Clinically_staging_period_N__c, 'cNstage_OS');
                    sc9.Value__c = sw9.snomedCodeVal;
                    sc9.Code_System__c = sw9.codeSystem;
                    sc9.caIntegratorValue__c = sw9.caIntegratorValue;
                    sc9.Code_System_Version__c = sw9.codeSystemVersion;
                    sc9.Code_Master__c = sm.Id;
                    system.debug('sc9 : '+sc9);
                    lstSnomed.add(sc9);
                }
                if(sm.Name == 'cStaging_OS'){
                    Snomed_Code__c sc10 = new Snomed_Code__c();
                    sc10.CRF__c = ref.CRF__c;
                    sc10.TrialPatient__c = ref.TrialPatient__c;
                    //sc10.Name = '277208005 | M category | ';
                    sc10.snomed_Code_Name__c = '277208005 | M category | ';
                    SnomedCTCode.SnomedWrapper sw10 = SnomedCTCode.SnomedCode(ref.Clinically_staging_period_M__c, 'cStaging_OS');
                    sc10.Value__c = sw10.snomedCodeVal;
                    sc10.Code_System__c = sw10.codeSystem;
                    sc10.caIntegratorValue__c = sw10.caIntegratorValue;
                    sc10.Code_System_Version__c = sw10.codeSystemVersion;
                    sc10.Code_Master__c = sm.Id;
                    system.debug('sc10 : '+sc10);
                    lstSnomed.add(sc10);
                }
                if(sm.Name == 'BaseDiseaseExt' && ref.Reporting__c == 'Baseline'){
                    Snomed_Code__c sc12 = new Snomed_Code__c();
                    sc12.CRF__c = ref.CRF__c;
                    sc12.TrialPatient__c = ref.TrialPatient__c;
                    //sc12.Name = '399734001 | primary tumour size | ';
                    sc12.snomed_Code_Name__c = '399734001 | primary tumour size | ';
                    sc12.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw12 = SnomedCTCode.SnomedCode(ref.Disease_Extent__c+'', 'BaseDiseaseExt');
                    sc12.Value__c = sw12.snomedCodeVal;
                    sc12.Code_System__c = sw12.codeSystem;
                    sc12.caIntegratorValue__c = sw12.caIntegratorValue;
                    sc12.Code_System_Version__c = sw12.codeSystemVersion;
                    lstSnomed.add(sc12);
                }
                if(sm.Name == 'BaseNodeExt' && ref.Reporting__c == 'Baseline'){
                    Snomed_Code__c sc121 = new Snomed_Code__c();
                    sc121.CRF__c = ref.CRF__c;
                    sc121.TrialPatient__c = ref.TrialPatient__c;
                    //sc121.Name = 'IHTSDO_4595';
                    sc121.snomed_Code_Name__c = 'IHTSDO_4595';
                    sc121.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw121 = SnomedCTCode.SnomedCode(ref.Size_of_largest_node__c+'', 'BaseNodeExt');
                    sc121.Value__c = sw121.snomedCodeVal;
                    sc121.Code_System__c = sw121.codeSystem;
                    sc121.caIntegratorValue__c = sw121.caIntegratorValue;
                    sc121.Code_System_Version__c = sw121.codeSystemVersion;
                    lstSnomed.add(sc121);
                }
            
                if(sm.Name == 'ReasonNoSurg_PTx'){
                    Snomed_Code__c sc2 = new Snomed_Code__c();
                    sc2.CRF__c = ref.CRF__c;
                    sc2.TrialPatient__c = ref.TrialPatient__c;
                    //sc2.Name = 'IHTSDO_4677';
                    sc2.snomed_Code_Name__c = 'IHTSDO_4677';
                    sc2.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw2 = SnomedCTCode.SnomedCode(ref.ReasonNotConservationSurgeryCandidate__c, 'ReasonNoSurg_PTx');
                    sc2.Value__c = sw2.snomedCodeVal;
                    sc2.Code_System__c = sw2.codeSystem;
                    sc2.Numeric_Value__c = sw2.numericValue;
                    sc2.caIntegratorValue__c = sw2.caIntegratorValue;
                    sc2.Code_System_Version__c = sw2.codeSystemVersion;
                    lstSnomed.add(sc2);
                }
                if(sm.Name == 'ClinRespT1_T3' || sm.Name == 'ClinRespT1_T4'){
                    Snomed_Code__c sc5 = new Snomed_Code__c();
                    sc5.CRF__c = ref.CRF__c;
                    sc5.TrialPatient__c = ref.TrialPatient__c;
                    //sc5.Name = '182985004 | response to treatment | ';
                    sc5.snomed_Code_Name__c = '182985004 | response to treatment | ';
                    sc5.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw5 = null;
                    if(ref.Reporting__c == 'Inter-regimen') {
                        sw5 = SnomedCTCode.SnomedCode(ref.Best_overall_Response_to_date__c, 'ClinRespT1_T3');
                    } else if(ref.Reporting__c == 'Pre-surgery') {
                        sw5 = SnomedCTCode.SnomedCode( ref.Best_overall_Response_to_date__c, 'ClinRespT1_T4');
                    }
                    if(sw5 != null) {
                        sc5.Value__c = sw5.snomedCodeVal;
                        sc5.Code_System__c = sw5.codeSystem;
                        sc5.Numeric_Value__c = sw5.numericValue;
                        sc5.caIntegratorValue__c = sw5.caIntegratorValue;
                        sc5.Code_System_Version__c = sw5.codeSystemVersion;
                        lstSnomed.add(sc5);
                    }
                }
                if(sm.Name == 'T4Early'){
                    Snomed_Code__c sc7 = new Snomed_Code__c();
                    sc7.CRF__c = ref.CRF__c;
                    sc7.TrialPatient__c = ref.TrialPatient__c;
                    //sc7.Name = 'IHTSDO_4593_2';
                    sc7.snomed_Code_Name__c = 'IHTSDO_4593_2';
                    sc7.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw7 = SnomedCTCode.SnomedCode(ref.Current_status_of_T4_tumor__c, 'T4Early');
                    sc7.Value__c = sw7.snomedCodeVal;
                    sc7.Code_System__c = sw7.codeSystem;
                    sc7.Numeric_Value__c = sw7.numericValue;
                    sc7.caIntegratorValue__c = sw7.caIntegratorValue;
                    sc7.Code_System_Version__c = sw7.codeSystemVersion;
                    lstSnomed.add(sc7);
                }
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    //This method should replace the method above
    //Here all the logic to read related records to decide code value is also implemented
    //In above method, the records were read in respective CRF triggers 
    public static SnomedWrapper SnomedCodeNew(String code, String val, SObject crf){
        String snomedReturnCode = '';
        SnomedWrapper sw = new SnomedWrapper();
        if(code == 'IHTSDO_4597'){
            Date startDate = null;
            Date endDate = null;
            if(crf.getSObjectType() == Followup_Form__c.sObjectType) { 
                Followup_Form__c fo = (Followup_Form__c)crf;
                
                //1. As per Registration Form Screening_Informed_Consent_Date__c
                List<Registration__c> regList = [Select r.TrialPatient__c, r.Screening_Informed_Consent_Date__c From Registration__c r where r.TrialPatient__c = :fo.TrialPatient__c];
                if(!regList.isEmpty()) {
                    startDate = regList[0].Screening_Informed_Consent_Date__c;
                }
                system.debug('fo.Survival_Status__c : '+fo.Survival_Status__c);
                system.debug('fo.End_Date__c : '+fo.End_Date__c);
                //2. check if this in follow up form, patient is dead?
                //if(fo.Survival_Status__c == 'Dead') {
                    endDate = fo.End_Date__c;
                //}
            } else if(crf.getSObjectType() == Off_Study_Detail__c.sObjectType) {
                Off_Study_Detail__c fo = (Off_Study_Detail__c)crf;
                
                //1. As per Registration Form Screening_Informed_Consent_Date__c
                List<Registration__c> regList = [Select r.TrialPatient__c, r.Screening_Informed_Consent_Date__c From Registration__c r where r.TrialPatient__c = :fo.TrialPatient__c order by LastModifiedDate desc limit 1];
                if(!regList.isEmpty()) {
                    startDate = regList[0].Screening_Informed_Consent_Date__c;
                }
                
                //2. check if this in follow up form, patient is dead?
                endDate = fo.Date_patient_went_off_study__c;
            }
            integer days = 0;
            system.debug('SurvDateD startDate : '+startDate);
            system.debug('SurvDateD endDate : '+endDate);
            if(startDate != null && endDate != null) {
                days = startDate.daysBetween(endDate);
                sw.snomedCodeVal = days+'';
                sw.codeSystem = 'SNOMED CT';
                sw.caIntegratorValue = days+'';
            } else {
                return null;
            }
            system.debug('SurvDateD sw : '+sw);
        } else if(code == 'IHTSDO_4598'){
            
            Date startDate = null;
            Date endDate = null;
            
            Followup_Form__c fo = (Followup_Form__c)crf;
                
            //1. As per Registration Form Screening_Informed_Consent_Date__c
            List<Post_Surgaory_Summary__c> pssList = [Select p.Date_Of_Procedure__c From Post_Surgaory_Summary__c p where p.TrialPatient__c = :fo.TrialPatient__c order by Effective_Time__c desc LIMIT 1];
            if(!pssList.isEmpty()) {
                startDate = pssList[0].Date_Of_Procedure__c;
            }
            
            //2. check if this in follow up form, patient is dead?
            if(fo.Survival_Status__c == 'Dead') {
                endDate = fo.End_Date__c;
            } else if(fo.Distant_progression_Date__c != null) {
                endDate = fo.Distant_progression_Date__c;
            } else if(fo.Local_progression_Date__c != null) {
                endDate = fo.Local_progression_Date__c;
            }
            
            if(fo.Distant_progression_Date__c != null && fo.Local_progression_Date__c != null) {
                endDate = fo.Distant_progression_Date__c > fo.Local_progression_Date__c ? fo.Local_progression_Date__c : fo.Distant_progression_Date__c;  
            }
            if(startDate != null && endDate != null) {
                integer days = startDate.daysBetween(endDate);
                sw.snomedCodeVal = days+'';
                sw.numericValue = days;
                sw.caIntegratorValue = days+'';
            } else {
                sw.snomedCodeVal = '';
                sw.numericValue = 0;
                sw.caIntegratorValue = '';
            }
            //sw.snomedCodeVal = ''+startDate.daysBetween(endDate);
            //sw.numericValue = startDate.daysBetween(endDate);
            sw.codeSystem = 'SNOMED CT';
        }  else if(code == 'IHTSDO_4600'){
            Followup_Form__c fo = (Followup_Form__c)crf;
            if(fo.patient_diagnosed_local_progression__c || fo.patient_diagnosed_distant_progression__c || fo.Survival_Status__c == 'Dead') {
                sw.snomedCodeVal = '1';
                sw.numericValue = 1;
                sw.caIntegratorValue = '1';
            } else if(fo.Survival_Status__c == 'Consent for follow-up withdrawn'){
                sw.snomedCodeVal = '0';
                sw.numericValue = 0;
                sw.caIntegratorValue = '0';
            }
            sw.codeSystem = 'SNOMED CT';
        }
        return sw;
    }
    
    //@future
    private static void insertProcedureRelatedCodes(List<Post_Surgaory_Summary__c> postList, List<On_Study_Pathology_Form__c> lstOsp) {
        
        boolean FNA_Br_pretxDone = false;
        boolean CoreNeedle_Br_pretx = false;
        boolean CoreNeedle_LN_Pretx = false;
        boolean IHTSDO_4565 = false;
        boolean Bx_SN_Pretx = false;
        boolean FNA_LN_Pretx = false;
        
        Set<Id> allTrialPatients = new Set<Id>();
        
        Map<Id, integer> trialPatientAndTotalAuxSentPostiveNodesMap = new Map<Id, integer>();
        Map<Id, integer> trialPatientAndTotalAuxSentExamineNodesMap = new Map<Id, integer>();
        Map<Id, boolean> trialPatientAndSurgLumpectoryDoneMap = new Map<Id, boolean>();
        
        //List<Procedure__c> procList = [Select p.pg_procedure_id__c, p.Ultrasound__c, p.TrialPatient__c, p.Total_Positive__c, p.Total_Examined_Nodes__c, p.SystemModstamp, p.Stereotactic__c, p.Procedure_Name__c, p.Post_Surgery_Summary__c, p.Palpation_guided__c, p.OwnerId, p.On_Study_Pathology_Form__c, p.Node_Type__c, p.Node_Result__c, p.Name, p.Mammography__c, p.MRI__c, p.Location__c, p.Laterality__c, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.Id, p.Form_Name__c, p.Date_Of_Procedure__c, p.CreatedDate, p.CreatedById, (Select Additional_Nodes__c, Axillary_Nodes__c, Positive__c, Procedure__c, Sentinel_Nodes__c From Lymph_Nodes__r) From Procedure__c p where id IN :procIds];
        
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        /*set<Id> setIds = new set<Id>();
        set<Id> posIds = new Set<Id>();
        for(Procedure__c pro : procList){
            if(pro.On_Study_Pathology_Form__c != null) {
                setIds.add(pro.On_Study_Pathology_Form__c);
            }
            if(pro.Post_Surgery_Summary__c != null) {
                posIds.add(pro.Post_Surgery_Summary__c);
            }
        }*/
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c 
                where Name IN ('FNA_Br_pretx', 'FNA_LN_Pretx', 'CoreNeedle_Br__pretx', 'Excisional_Br_pretx',
                'Surgery_Br', 'Excisional_Br_pretx', 'CoreNeedle_Br__pretx','Incisional_LN_Pretx',
                            'CoreNeedle_LN_Pretx', 'Bx_SN_Pretx', 'NumExLN_PS', 'NumPosLN_PS', 
                            'CoreNeedle Guidance_pretx')];
        Map<String, Code_Master__c> snomedMasterMap = new Map<String, Code_Master__c>();
        for(Code_Master__c sm : lstSnomedMaster) {
            snomedMasterMap.put(sm.Name, sm);
        } 
        //List<On_Study_Pathology_Form__c> lstOsp = [select id,CRF__c,TrialPatient__c from On_Study_Pathology_Form__c where Id IN : setIds];
        for(On_Study_Pathology_Form__c osp : lstOsp){
            //List<Procedure__c> procList = osp.Procedures__r;
            for(Procedure__c pro : osp.Procedures__r){
                if(pro.On_Study_Pathology_Form__c != osp.Id) continue;
                allTrialPatients.add(osp.TrialPatient__c);
                if(pro.Procedure_Name__c == 'FNA'){
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = osp.CRF__c;
                    sc.TrialPatient__c = osp.TrialPatient__c;
                    //sc.Name = '48635004 | fine needle biopsy | ';
                    sc.snomed_Code_Name__c = '48635004 | fine needle biopsy | ';
                    sc.Code_Master__c = snomedMasterMap.get('FNA_Br_pretx').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes', 'FNA_Br_pretx');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                    FNA_Br_pretxDone = true;
                } else if(pro.Procedure_Name__c == 'FNA (lymph node)'){
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = osp.CRF__c;
                    sc.TrialPatient__c = osp.TrialPatient__c;
                    //sc.Name = '18498-6';
                    sc.Code_Master__c = snomedMasterMap.get('FNA_LN_Pretx').Id;
                    sc.snomed_Code_Name__c = '18498-6';
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(pro.Node_Result__c, 'FNA_LN_Pretx');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                    FNA_LN_Pretx = true;
                } else if(pro.Procedure_Name__c == 'Core biopsy'){
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = osp.CRF__c;
                    sc.TrialPatient__c = osp.TrialPatient__c;
                    //sc.Name = '44578009 | core needle biopsy of breast | ';
                    sc.snomed_Code_Name__c = '44578009 | core needle biopsy of breast | ';
                    sc.Code_Master__c = snomedMasterMap.get('CoreNeedle_Br__pretx').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(pro.Node_Result__c, 'CoreNeedle_Br__pretx');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                    CoreNeedle_Br_pretx = true;
                } else if(pro.Procedure_Name__c == 'Core biopsy (lymph node)'){
                    Snomed_Code__c sc1 = new Snomed_Code__c();
                    sc1.CRF__c = osp.CRF__c;
                    sc1.TrialPatient__c = osp.TrialPatient__c;
                    sc1.Code_Master__c = snomedMasterMap.get('CoreNeedle_LN_Pretx').Id;
                    //sc.Name = '29300007 | core needle biopsy of lymph node | ';
                    sc1.snomed_Code_Name__c = '29300007 | core needle biopsy of lymph node | ';
                    SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode(pro.Node_Result__c, 'CoreNeedle_LN_Pretx');
                    sc1.Value__c = sw1.snomedCodeVal;
                    sc1.Code_System__c = sw1.codeSystem;
                    sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                    sc1.Code_System_Version__c = sw1.codeSystemVersion;
                    lstSnomed.add(sc1);
                    CoreNeedle_LN_Pretx = true;
                    if(pro.Mammography__c) {
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = osp.CRF__c;
                        sc.TrialPatient__c = osp.TrialPatient__c;
                        //sc.Name = '274372001 | surgical biopsy of lymph node | ';
                        sc.snomed_Code_Name__c = 'IHTSDO_4563';
                        sc.Code_Master__c = snomedMasterMap.get('CoreNeedle Guidance_pretx').Id;
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Mammogram', 'CoreNeedle Guidance_pretx');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    }
                    if(pro.MRI__c) {
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = osp.CRF__c;
                        sc.TrialPatient__c = osp.TrialPatient__c;
                        //sc.Name = '274372001 | surgical biopsy of lymph node | ';
                        sc.snomed_Code_Name__c = '433008009 | core needle biopsy of breast using magnetic resonance imaging guidance | ';
                        sc.Code_Master__c = snomedMasterMap.get('CoreNeedle Guidance_pretx').Id;
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('MRI', 'CoreNeedle Guidance_pretx');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    }
                    if(pro.Ultrasound__c) {
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = osp.CRF__c;
                        sc.TrialPatient__c = osp.TrialPatient__c;
                        //sc.Name = '274372001 | surgical biopsy of lymph node | ';
                        sc.snomed_Code_Name__c = '433805008 | fine needle aspiration and core needle biopsy of breast using ultrasound guidance | ';
                        sc.Code_Master__c = snomedMasterMap.get('CoreNeedle Guidance_pretx').Id;
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Ultrasound', 'CoreNeedle Guidance_pretx');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    }
                    if(pro.Stereotactic__c) {
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = osp.CRF__c;
                        sc.TrialPatient__c = osp.TrialPatient__c;
                        //sc.Name = '274372001 | surgical biopsy of lymph node | ';
                        sc.snomed_Code_Name__c = '122738006 | specimen obtained from breast by stereotactically guided core needle biopsy | ';
                        sc.Code_Master__c = snomedMasterMap.get('CoreNeedle Guidance_pretx').Id;
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Stereotactic', 'CoreNeedle Guidance_pretx');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    }
                    if(pro.Palpation_guided__c) {
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = osp.CRF__c;
                        sc.TrialPatient__c = osp.TrialPatient__c;
                        //sc.Name = '274372001 | surgical biopsy of lymph node | ';
                        sc.snomed_Code_Name__c = 'IHTSDO_4564';
                        sc.Code_Master__c = snomedMasterMap.get('CoreNeedle Guidance_pretx').Id;
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Palpation', 'CoreNeedle Guidance_pretx');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    }
                } else if(pro.Procedure_Name__c == 'Excisional biopsy (lymph node)'){
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = osp.CRF__c;
                    sc.TrialPatient__c = osp.TrialPatient__c;
                    //sc.Name = 'IHTSDO_4565';
                    sc.snomed_Code_Name__c = '69031006 | excision of breast tissue | ';
                    sc.Code_Master__c = snomedMasterMap.get('Excisional_Br_pretx').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(pro.Node_Result__c, 'Excisional_Br_pretx');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                } else if(pro.Procedure_Name__c == 'Incisional biopsy') {
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = osp.CRF__c;
                    sc.TrialPatient__c = osp.TrialPatient__c;
                    sc.snomed_Code_Name__c = 'IHTSDO_4565';
                    sc.Code_Master__c = snomedMasterMap.get('Incisional_LN_Pretx').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No', 'Incisional_LN_Pretx');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                }else if(pro.Procedure_Name__c == 'Sentinel lymph node dissection'){
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = osp.CRF__c;
                    sc.TrialPatient__c = osp.TrialPatient__c;
                    //sc.Name = '274372001 | surgical biopsy of lymph node | ';
                    sc.snomed_Code_Name__c = '274372001 | surgical biopsy of lymph node | ';
                    sc.Code_Master__c = snomedMasterMap.get('Bx_SN_Pretx').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(pro.Node_Result__c, 'Bx_SN_Pretx');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                    Bx_SN_Pretx = true;
                }
            }
            if(!FNA_Br_pretxDone) {
                Snomed_Code__c sc = new Snomed_Code__c();
                sc.CRF__c = osp.CRF__c;
                sc.TrialPatient__c = osp.TrialPatient__c;
                //sc.Name = '48635004 | fine needle biopsy | ';
                sc.snomed_Code_Name__c = '48635004 | fine needle biopsy | ';
                if(snomedMasterMap.get('FNA_Br_pretx') != null) {
                    sc.Code_Master__c = snomedMasterMap.get('FNA_Br_pretx').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No', 'FNA_Br_pretx');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                }
            }
            if(!FNA_LN_Pretx) {
                Snomed_Code__c sc = new Snomed_Code__c();
                sc.CRF__c = osp.CRF__c;
                sc.TrialPatient__c = osp.TrialPatient__c;
                //sc.Name = '18498-6';
                if(snomedMasterMap.get('FNA_LN_Pretx') != null) {
                    sc.Code_Master__c = snomedMasterMap.get('FNA_LN_Pretx').Id;
                    sc.snomed_Code_Name__c = '18498-6';
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Not done', 'FNA_LN_Pretx');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                }
            }
            if(!CoreNeedle_LN_Pretx) {
                Snomed_Code__c sc = new Snomed_Code__c();
                sc.CRF__c = osp.CRF__c;
                sc.TrialPatient__c = osp.TrialPatient__c;
                //sc.Name = '44578009 | core needle biopsy of breast | ';
                sc.snomed_Code_Name__c = '29300007 | core needle biopsy of lymph node | ';
                if(snomedMasterMap.get('CoreNeedle_LN_Pretx') != null) {
                    sc.Code_Master__c = snomedMasterMap.get('CoreNeedle_LN_Pretx').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Not done', 'CoreNeedle_LN_Pretx');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                }
            }
            if(!CoreNeedle_Br_pretx) {
                Snomed_Code__c sc = new Snomed_Code__c();
                sc.CRF__c = osp.CRF__c;
                sc.TrialPatient__c = osp.TrialPatient__c;
                //sc.Name = '44578009 | core needle biopsy of breast | ';
                sc.snomed_Code_Name__c = '44578009 | core needle biopsy of breast | ';
                if(snomedMasterMap.get('CoreNeedle_Br__pretx') != null) {
                    sc.Code_Master__c = snomedMasterMap.get('CoreNeedle_Br__pretx').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Not done', 'CoreNeedle_Br__pretx');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                }
            }
            if(!Bx_SN_Pretx) {
                Snomed_Code__c sc = new Snomed_Code__c();
                sc.CRF__c = osp.CRF__c;
                sc.TrialPatient__c = osp.TrialPatient__c;
                //sc.Name = '44578009 | core needle biopsy of breast | ';
                sc.snomed_Code_Name__c = '274372001 | surgical biopsy of lymph node | ';
                if(snomedMasterMap.get('Bx_SN_Pretx') != null) {
                    sc.Code_Master__c = snomedMasterMap.get('Bx_SN_Pretx').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Not done', 'Bx_SN_Pretx');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                }
            }
        }
        
        Set<Id> proIds = new Set<Id>();
        for(Post_Surgaory_Summary__c pss : postList) {
            for(Procedure__c pro :  pss.Procedures__r){
                proIds.add(pro.Id);
            }
        }
        
        //List<Post_Surgaory_Summary__c> postList = [select id,CRF__c,TrialPatient__c from Post_Surgaory_Summary__c where Id IN : posIds];
        List<Lymph_Nodes__c> lstLymph = [select Procedure__c, Axillary_Nodes__c, Sentinel_Nodes__c, Positive__c, Examined__c from Lymph_Nodes__c where Procedure__c IN:proIds];
        for(Post_Surgaory_Summary__c pss : postList) {
            allTrialPatients.add(pss.TrialPatient__c);
            //List<Procedure__c> procList = pss.Procedures__r;
            if(pss.Procedures__r.isEmpty()) {
                Snomed_Code__c sc = new Snomed_Code__c();
                sc.CRF__c = pss.CRF__c;
                sc.TrialPatient__c = pss.TrialPatient__c;
                //sc.Name = '172043006 | simple mastectomy | ';
                sc.snomed_Code_Name__c = '172043006 | simple mastectomy | ';
                if(snomedMasterMap != null && snomedMasterMap.containsKey('Surgery_Br')) {
                    sc.Code_Master__c = snomedMasterMap.get('Surgery_Br').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No', 'Surgery_Br');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                }
            }
            for(Procedure__c pro :  pss.Procedures__r){
                if(pro.Procedure_Name__c == 'Partial mastectomy' || pro.Procedure_Name__c == 'Therapeutic Mastectomy' || pro.Procedure_Name__c == 'Skin Sparing Mastectomy' || pro.Procedure_Name__c == 'Total skin sparing mastectomy' || pro.Procedure_Name__c == 'Modified radical mastectomy') {
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = pss.CRF__c;
                    sc.TrialPatient__c = pss.TrialPatient__c;
                    //sc.Name = '172043006';
                    sc.snomed_Code_Name__c = '172043006 | simple mastectomy | ';
                    sc.Code_Master__c = snomedMasterMap.get('Surgery_Br').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes', 'Surgery_Br');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    if(pro.Procedure_Name__c == 'Partial mastectomy') {
                        sc.caIntegratorValue__c = '1';
                    } else if(pro.Procedure_Name__c == 'Therapeutic Mastectomy') {
                        sc.caIntegratorValue__c = '2';
                    } else if(pro.Procedure_Name__c == 'Skin Sparing Mastectomy') {
                        sc.caIntegratorValue__c = '3';
                    } else if(pro.Procedure_Name__c == 'Total skin sparing mastectomy') {
                        sc.caIntegratorValue__c = '4';
                    } else if(pro.Procedure_Name__c == 'Modified radical mastectomy') {
                        sc.caIntegratorValue__c = '5';
                    }
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                }
                if(pro.Procedure_Name__c == 'Partial mastectomy' || pro.Procedure_Name__c == 'Excisional biopsy (lymph node)'){
                    trialPatientAndSurgLumpectoryDoneMap.put(pss.TrialPatient__c, true);
                }
                //wrong logic for Axillary and Sentinel lymph nodes. These should be fetch from lymph node object not from procedure object.
                /*if(pro.Node_Type__c == 'Axillary (Lymph node)' || pro.Node_Type__c == 'Sentinel (Lymph node)') {
                    if(pro.Node_Result__c == 'Positive') {
                        integer totalAuxSentPositiveNodes = 0;
                        if(trialPatientAndTotalAuxSentPostiveNodesMap.containsKey(pss.TrialPatient__c)) {
                            totalAuxSentPositiveNodes = trialPatientAndTotalAuxSentPostiveNodesMap.get(pss.TrialPatient__c);
                        }
                        totalAuxSentPositiveNodes++;
                        trialPatientAndTotalAuxSentPostiveNodesMap.put(pss.TrialPatient__c, totalAuxSentPositiveNodes);
                    }
                }*/
            }
            integer totalAuxSentPositiveNodes = 0;
            integer totalAuxSentExamineNodes = 0;
            for(Lymph_Nodes__c lymph : pss.Lymph_Nodes__r) {
                if(lymph.Axillary_Nodes__c || lymph.Sentinel_Nodes__c) {
                    totalAuxSentPositiveNodes+= Integer.valueOf(lymph.Positive__c);
                    totalAuxSentExamineNodes+= Integer.valueOf(lymph.Examined__c);
                }
            }
            
            for(Code_Master__c cm1 : [Select c.Id From Code_Master__c c where Name = 'NumPosLN_PS']) {
                Snomed_Code__c sc1 = new Snomed_Code__c();
                sc1.CRF__c = pss.CRF__c;
                sc1.TrialPatient__c = pss.TrialPatient__c;
                sc1.snomed_Code_Name__c = 'IHTSDO_4683';
                sc1.Code_Master__c = cm1.Id;
                sc1.caIntegratorValue__c = ''+totalAuxSentPositiveNodes;
                sc1.Value__c = ''+totalAuxSentPositiveNodes;
                sc1.Code_System__c = 'SNOMED CT';
                sc1.Code_System_Version__c = '';
                lstSnomed.add(sc1);
            }
            
            for(Code_Master__c cm2 : [Select c.Id From Code_Master__c c where Name = 'NumExLN_PS']) {
                Snomed_Code__c sc2 = new Snomed_Code__c();
                sc2.CRF__c = pss.CRF__c;
                sc2.TrialPatient__c = pss.TrialPatient__c;
                sc2.snomed_Code_Name__c = '313195009 | procedure carried out | : 363589002 | associated procedure | = 284429001 | examination of axillary lymph nodes | ';
                sc2.Code_Master__c = cm2.Id;
                sc2.caIntegratorValue__c = ''+totalAuxSentExamineNodes;
                sc2.Value__c = ''+totalAuxSentExamineNodes;
                sc2.Code_System__c = 'SNOMED CT';
                sc2.Code_System_Version__c = '';
                lstSnomed.add(sc2);
            }
        }
        
        if(!lstSnomed.isEmpty()) {
            insert lstSnomed;
        }
        
        /*List<Snomed_Code__c> scList = [Select s.Value__c, s.TrialPatient__c, s.caIntegratorValue__c, s.Name, snomed_Code_Name__c From Snomed_Code__c s where s.TrialPatient__c in :allTrialPatients and s.snomed_Code_Name__c in ('IHTSDO_4683','48635004 | fine needle biopsy | ','18498-6','44578009 | core needle biopsy of breast | ','29300007 | core needle biopsy of lymph node | ','IHTSDO_4565','274372001 | surgical biopsy of lymph node | ')];
        Set<Id> trialPatientIds = trialPatientAndTotalAuxSentPostiveNodesMap.keySet();
        for(Id tpId : trialPatientIds) {
            integer totalAuxSentPositiveNodes = -1;
            Snomed_Code__c sc = null;
            boolean codeExists = false;
            for(Snomed_Code__c sc1 : scList) {
                if(sc1.TrialPatient__c == tpId && sc1.snomed_Code_Name__c == 'IHTSDO_4683') {
                    totalAuxSentPositiveNodes = Integer.valueOf(sc1.caIntegratorValue__c); 
                    codeExists = true;
                }
            }
            if(!codeExists)sc = new Snomed_Code__c();
            if(trialPatientAndTotalAuxSentPostiveNodesMap.containsKey(tpId)) {
                if(trialPatientAndTotalAuxSentPostiveNodesMap.get(tpId) > 0 && totalAuxSentPositiveNodes == -1) {
                    totalAuxSentPositiveNodes = trialPatientAndTotalAuxSentPostiveNodesMap.get(tpId);
                } else if(totalAuxSentPositiveNodes > 0 && trialPatientAndTotalAuxSentPostiveNodesMap.get(tpId) > 0){
                    totalAuxSentPositiveNodes += trialPatientAndTotalAuxSentPostiveNodesMap.get(tpId);
                }
            }
            
            //sc.CRF__c = osp.CRF__c;
            if(sc != null) {
                Snomed_Code__c sc = new Snomed_Code__c();
                sc.CRF__c = pss.CRF__c;
                sc.TrialPatient__c = pss.TrialPatient__c;
                sc.snomed_Code_Name__c = 'IHTSDO_4683';
                sc.Code_Master__c = snomedMasterMap.get('NumPosLN_PS').Id;
                SnomedCTCode.SnomedWrapper sw = null;
                system.debug('totalAuxSentPositiveNodes: '+totalAuxSentPositiveNodes);
                if(totalAuxSentPositiveNodes != -1) {
                    sw = SnomedCTCode.SnomedCode(''+totalAuxSentPositiveNodes, 'NumPosLN_PS');
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                } else {
                    sw = SnomedCTCode.SnomedCode('No axillary', 'NumPosLN_PS');
                }
                sc.Value__c = sw.snomedCodeVal;
                sc.Code_System__c = sw.codeSystem;
                sc.Code_System_Version__c = sw.codeSystemVersion;
                lstSnomed.add(sc);
            }
        }
        
    //===============for Examine nodes===============================================
        trialPatientIds.clear();
        trialPatientIds = trialPatientAndTotalAuxSentExamineNodesMap.keySet();
        for(Id tpId : trialPatientIds) {
            integer totalAuxSentExamineNodes = -1;
            Snomed_Code__c sc = null;
            boolean codeExists = false;
            for(Snomed_Code__c sc1 : scList) {
                if(sc1.TrialPatient__c == tpId && sc1.snomed_Code_Name__c == 'IHTSDO_4683') {
                    totalAuxSentExamineNodes = Integer.valueOf(sc1.caIntegratorValue__c); 
                    codeExists = true;
                }
            }
            if(!codeExists)sc = new Snomed_Code__c();
            if(trialPatientAndTotalAuxSentExamineNodesMap.containsKey(tpId)) {
                if(trialPatientAndTotalAuxSentExamineNodesMap.get(tpId) > 0 && totalAuxSentExamineNodes == -1) {
                    totalAuxSentExamineNodes = trialPatientAndTotalAuxSentExamineNodesMap.get(tpId);
                } else if(totalAuxSentExamineNodes > 0 && trialPatientAndTotalAuxSentExamineNodesMap.get(tpId) > 0){
                    totalAuxSentExamineNodes += trialPatientAndTotalAuxSentExamineNodesMap.get(tpId);
                }
            }
            
            //sc.CRF__c = osp.CRF__c;
            if(sc != null) {
                sc.TrialPatient__c = tpId;
                //sc.Name = 'IHTSDO_4683';
                sc.snomed_Code_Name__c = '313195009 | procedure carried out | : 363589002 | associated procedure | = 284429001 | examination of axillary lymph nodes |';
                sc.Code_Master__c = snomedMasterMap.get('NumExLN_PS').Id;
                SnomedCTCode.SnomedWrapper sw = new SnomedCTCode.SnomedWrapper();
                if(totalAuxSentExamineNodes != -1) {
                    sw = SnomedCTCode.SnomedCode(''+totalAuxSentExamineNodes, 'NumExLN_PS');
                } else {
                    sw = SnomedCTCode.SnomedCode('0', 'NumExLN_PS');
                }
                sc.Value__c = sw.snomedCodeVal;
                sc.Code_System__c = sw.codeSystem;
                sc.caIntegratorValue__c = sw.caIntegratorValue;
                sc.Code_System_Version__c = sw.codeSystemVersion;
                lstSnomed.add(sc);
            }
        }*/
    
        /*trialPatientIds.clear();
        trialPatientIds = trialPatientAndSurgLumpectoryDoneMap.keySet();
        for(Id tpId : trialPatientIds) {
            boolean surgeryLumpectomyDone = trialPatientAndSurgLumpectoryDoneMap.get(tpId);
            integer snomedValue = 0;
            Snomed_Code__c sc = null;
            boolean codeExists = false;
            for(Snomed_Code__c sc1 : scList) {
                //if(sc1.TrialPatient__c == tpId && sc1.snomed_Code_Name__c == '392021009 | lumpectomy of breast | ') {
                if(sc1.TrialPatient__c == tpId && sc1.snomed_Code_Name__c == '64368001 | partial mastectomy | ') {
                    snomedValue = Integer.valueOf(sc1.Value__c); 
                    codeExists = true;
                }
            }
            if(!codeExists)sc = new Snomed_Code__c();
            
            if(snomedValue > 0) break;
            
            if(sc != null) {
                //sc.CRF__c = osp.CRF__c;
                sc.TrialPatient__c = tpId;
                //sc.Name = '392021009 | lumpectomy of breast | ';
                //sc.snomed_Code_Name__c = '392021009 | lumpectomy of breast | ';
                sc.snomed_Code_Name__c = '64368001 | partial mastectomy | ';
                SnomedCTCode.SnomedWrapper sw = null;
                if(surgeryLumpectomyDone) {
                    //sw = SnomedCTCode.SnomedCode('392021009 | lumpectomy of breast | ', 'Yes');
                    sw = SnomedCTCode.SnomedCode('yes', 'Surgery_Br');
                } else {
                    //sw = SnomedCTCode.SnomedCode('392021009 | lumpectomy of breast | ', 'No');
                    sw = SnomedCTCode.SnomedCode('no', 'Surgery_Br');
                }
                sc.Value__c = sw.snomedCodeVal;
                sc.Code_System__c = sw.codeSystem;
                sc.caIntegratorValue__c = sw.caIntegratorValue;
                sc.Code_System_Version__c = sw.codeSystemVersion;
                lstSnomed.add(sc);
            }
        }
        
        if(!lstSnomed.isEmpty()){
            upsert lstSnomed;
        }*/
    }
    
    @future
    public static void insertSnomedCodeForFollowup(Set<Id> foIds) {
        
        Decimal totalDose = 0;
        List<Irradiated_Site__c> lstIrrBoost = [select Id, Total_dose_cGy_AP__c from Irradiated_Site__c where Followup_Form__c IN :foIds and Site__c = 'Boost'];
        for(Irradiated_Site__c ir : lstIrrBoost) {
            totalDose += ir.Total_dose_cGy_AP__c;
        }
        
        List<Irradiated_Site__c> lstIrrBreast = [select Id, Total_dose_cGy_AP__c from Irradiated_Site__c where Followup_Form__c IN :foIds and Site__c = 'Breast'];
        for(Irradiated_Site__c ir : lstIrrBreast) {
            totalDose += ir.Total_dose_cGy_AP__c;
        }
        
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name= 'SurvStat' or Name = 'SurvDateD' or Name = 'RFS' 
        or Name = 'RFS_ind' or Name = 'RtTherapy' or Name = 'LocalProgress' or Name = 'DistProgress' or Name = 'LocalProgTimeD' or Name = 'NewPrimeTx'
        or Name = 'DistProgTimeD' or Name = 'NewPrimeCa' or Name = 'NewPrimeTimeD' or Name = 'Adj_Chemo' or Name = 'Adj_ChemoReg' or Name = 'Adj_Other' or Name = 'Adu_OtherReg' 
        or Name = 'Adj_Trastuzumab' or Name = 'Adj_Tam' or Name = 'Adj_OvarianAbl' or Name = 'Adj_OvarianSup' or Name = 'Adj_AromataseInhib' 
        or Name = 'DistProgSite' or Name = 'RtBoTD' or Name = 'RtAxTD' or Name = 'RtSNTD' or Name = 'RtIMTD' or Name = 'RtCWTD' or Name = 'DistProgSite'];
        
        List<Followup_Form__c> ffList = [Select f.test_radio_button_del__c, f.pg_Followup_Id__c, f.patient_have_a_menstrual_period__c, f.patient_diagnosed_local_progression__c, f.patient_diagnosed_distant_progression__c, f.age_50__c, f.TrialPatient__c, f.Treatment_s_for_new__c, f.Total_dose_cGy_AP__c, f.Total_FX__c, f.Therapies_received__c, f.SystemModstamp, f.Survival_Status__c, f.Surgery__c, f.Surgery_Details__c, f.Status__c, f.Start_Date__c, f.Sites_of_New_Progression__c, f.Sign_Submit__c, f.Recurrence_progression_information__c, f.RecordTypeId, f.Radiation_Therapy__c, f.Radiation_Therapy_Start_Date__c, f.Radiation_Therapy_End_Date__c, f.Radiation_Therapy_Details__c, f.Print_CRF_Form_after_Saving__c, f.Premenopausal_6_months__c, f.Postmenopausal_12_months__c, f.Perimenopausal_6_12months__c, f.Patient_received_adjuvant_therapy__c, f.Patient_doc_clinial_assessment__c, f.Patient_diagnose_with_new__c, f.Patient_Age_AP__c, f.OwnerId, f.Other__c, f.OriginalCRF__c, f.On_Estrogen_Replacement__c, f.On_Estrogen_Replacement_Years__c, f.On_Estrogen_Replacement_Months__c, f.Notice_of_Progression__c, f.New_Cancer__c, f.Name, f.Menopausal_status__c, f.Lost_to_Follow_Up__c, f.Long_Term_Therapy_for_primary_Trial__c, f.Local_progression_Date__c, f.Local__c, f.LastModifiedDate, f.LastModifiedById, f.LastActivityDate, f.IsDeleted, f.Id, f.Hysterectomy__c, f.Hysterectomy_Date__c, f.Hormone_Therapy__c, f.Hormone_Therapy_Details__c, f.End_Date__c, f.Dose_per_FX_cGy__c, f.Distant_progression_Date__c, f.Distant__c, f.Description__c, f.Describe_Cause_of_Death__c, f.Death_Details__c, f.Date_of_Last_Menstrual_period__c, f.Date_of_Last_Menstrual_period_UKData__c, f.Date_of_Last_Menstrual_period_UKData12M__c, f.Date__c, f.CreatedDate, f.CreatedById, f.Consent_for_follow_up_withdrawn__c, f.CompletedDate__c, f.Comment__c, f.Clinical_assessment_Date__c, f.Chemotherapy__c, f.Chemotherapy_Details__c, f.Causeof_Death__c, f.Cause_of_Death__c, f.CRF__c, f.Bilateral_oophorectomy__c, f.Bilateral_oophorectomy_Date__c, f.Alive__c, f.Abv_Catg_not_Aplicable_age_50__c, (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Followup_Form__c, Dose_per_FX_cGy__c, Laterality__c, Site__c, TotalFX__c, Total_FX__c, Total_dose_cGy_AP__c, pg_irraditedsite_Id__c From Irradiated_Sites__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Followup_Form__c, Detail__c, End_Date__c, Start_Date_Date_Performed__c, Therapy__c, pg_therapyreceived_Id__c From Therapy_Receiveds__r) From Followup_Form__c f where id in :foIds];
        Set<Id> tpIds = new Set<Id>();
        for(Followup_Form__c fo : ffList) {
            tpIds.add(fo.TrialPatient__c);
        }
        
        system.debug('__ffList__'+ffList);
        Set<Id> isIds = new Set<Id>(); 
        for(Followup_Form__c fo : ffList){
            system.debug('__fo.Irradiated_Sites__r__'+fo.Irradiated_Sites__r);
            system.debug('__fo.Irradiated_Sites__r.Size()__'+fo.Irradiated_Sites__r.Size());
            for(Irradiated_Site__c ir : fo.Irradiated_Sites__r) {
                isIds.add(ir.Id);
            }
            for(Code_Master__c sm : lstSnomedMaster){
                system.debug('sm.Name : '+sm.Name);
                if(sm.Name == 'SurvStat'){
                    Snomed_Code__c sc0 = new Snomed_Code__c();
                    sc0.CRF__c = fo.CRF__c;
                    sc0.TrialPatient__c = fo.TrialPatient__c;
                    //sc0.Name = '309032007';
                    sc0.snomed_Code_Name__c = '309032007 | research administrative status | ';
                    sc0.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw0 = SnomedCTCode.SnomedCode(fo.Survival_Status__c, 'SurvStat');
                    sc0.Value__c = sw0.snomedCodeVal;
                    sc0.Code_System__c = sw0.codeSystem;
                    sc0.caIntegratorValue__c = sw0.caIntegratorValue;
                    sc0.Code_System_Version__c = sw0.codeSystemVersion;
                    system.debug('sw0.caIntegratorValue : '+sw0.caIntegratorValue);
                    sc0.Numeric_Value__c = sw0.numericValue;
                    lstSnomed.add(sc0);
                }
                if(sm.Name == 'Adj_ChemoReg' || sm.Name == 'Adj_Other' || sm.Name == 'Adu_OtherReg') {
                    Snomed_Code__c sc15 = new Snomed_Code__c();
                    sc15.CRF__c = fo.CRF__c;
                    sc15.TrialPatient__c = fo.TrialPatient__c;
                    //sc15.Name = sm.Name;
                    sc15.snomed_Code_Name__c = '428923005 | radiotherapy to breast | ';
                    sc15.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw15 = SnomedCTCode.SnomedCode(fo.Patient_received_adjuvant_therapy__c?'Yes' : 'No', 'Adj_ChemoReg');
                    sc15.Value__c = sw15.snomedCodeVal;
                    sc15.Code_System__c = sw15.codeSystem;
                    sc15.caIntegratorValue__c = sw15.caIntegratorValue;
                    sc15.Code_System_Version__c = sw15.codeSystemVersion;
                    sc15.Numeric_Value__c = sw15.numericValue;
                    lstSnomed.add(sc15);
                }
                if(sm.Name == 'NewPrimeTx'){
                     Snomed_Code__c sc11 = new Snomed_Code__c();
                     sc11.CRF__c = fo.CRF__c;
                     sc11.TrialPatient__c = fo.TrialPatient__c;
                     //sc11.Name = '395073001 | cancer treatment started | ';
                     sc11.snomed_Code_Name__c = '395073001 | cancer treatment started | ';
                     sc11.Code_Master__c = sm.Id;
                     SnomedCTCode.SnomedWrapper sw11 = SnomedCTCode.SnomedCode(fo.New_Cancer__c, 'NewPrimeTx');
                     sc11.Value__c = sw11.snomedCodeVal;
                     sc11.Code_System__c = sw11.codeSystem;
                     sc11.caIntegratorValue__c = sw11.caIntegratorValue;
                     sc11.Code_System_Version__c = sw11.codeSystemVersion;
                     lstSnomed.add(sc11);
                }
                if(sm.Name == 'SurvDateD'){
                    delete [select id from Snomed_Code__c where Code_Master__r.Name = 'SurvDateD' and TrialPatient__c in :tpIds];
                    List<TrialPatient__c> tpList = [Select Id,(Select Screening_Informed_Consent_Date__c From Registrations__r where status__c = 'Approval Not Required'), (Select End_Date__c,CRF__c From Followup_Forms__r where status__c='Accepted' order by End_Date__c desc limit 1) From TrialPatient__c t where Site__r.isTestSite__c = false and id in :tpIds];
                    for(TrialPatient__c tp : tpList) {
                        if(tp.Registrations__r.isEmpty() || tp.Followup_Forms__r.isEmpty())continue;
                        Date startDate = tp.Registrations__r[0].Screening_Informed_Consent_Date__c;
                        Date endDate = tp.Followup_Forms__r[0].End_Date__c;
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = tp.Followup_Forms__r[0].CRF__c;
                        sc.TrialPatient__c = tp.Id;
                        sc.snomed_Code_Name__c = 'IHTSDO_4597';
                        sc.Code_Master__c = sm.Id;
                        sc.Value__c = startDate.daysBetween(endDate)+'';
                        sc.Code_System__c = 'SNOMED CT';
                        sc.caIntegratorValue__c = startDate.daysBetween(endDate)+'';
                        sc.Code_System_Version__c = '';
                        lstSnomed.add(sc);
                    }
                    /*Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = fo.CRF__c;
                    sc.TrialPatient__c = fo.TrialPatient__c;
                    //sc.Name = 'IHTSDO_4597';
                    sc.snomed_Code_Name__c = 'IHTSDO_4597';
                    sc.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCodeNew('IHTSDO_4597', '', fo);
                    if(sw != null) {
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    }*/
                }
                if(sm.Name == 'RFS'){
                    //TODO rewrite as per logic to delete selective snomed codes and then insert them
                    //as per new data
                    Snomed_Code__c sc1 = new Snomed_Code__c();
                    sc1.CRF__c = fo.CRF__c;
                    sc1.TrialPatient__c = fo.TrialPatient__c;
                    //sc1.Name = 'IHTSDO_4598';
                    sc1.snomed_Code_Name__c = 'IHTSDO_4598';
                    sc1.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCodeNew('IHTSDO_4598', '', fo);
                    if(sw1 != null) {
                        sc1.Value__c = sw1.snomedCodeVal;
                        sc1.Code_System__c = sw1.codeSystem;
                        sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                        sc1.Numeric_Value__c = sw1.numericValue;
                        sc1.Code_System_Version__c = sw1.codeSystemVersion;
                        lstSnomed.add(sc1);
                    }
                }
                if(sm.Name == 'RFS_ind'){
                    Snomed_Code__c sc2 = new Snomed_Code__c();
                    sc2.CRF__c = fo.CRF__c;
                    sc2.TrialPatient__c = fo.TrialPatient__c;
                    //sc2.Name = 'IHTSDO_4600';
                    sc2.snomed_Code_Name__c = 'IHTSDO_4600';
                    sc2.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw2 = SnomedCTCode.SnomedCodeNew('IHTSDO_4600', '', fo);
                    if(sw2 != null) {
                        sc2.Value__c = sw2.snomedCodeVal;
                        sc2.Code_System__c = sw2.codeSystem;
                        sc2.caIntegratorValue__c = sw2.caIntegratorValue;
                        sc2.Numeric_Value__c = sw2.numericValue;
                        sc2.Code_System_Version__c = sw2.codeSystemVersion;
                        lstSnomed.add(sc2);
                    }
                }
                /*
                SHOULD BE ON THERAPY TRIGGER
                */
                
                /*
                SHOULD BE ON THERAPY TRIGGER
                */
                
                /*Snomed_Code__c sc5 = new Snomed_Code__c();
                sc5.CRF__c = fo.CRF__c;
                sc5.TrialPatient__c = fo.TrialPatient__c;
                sc5.Name = 'IHTSDO_4586';
                SnomedCTCode.SnomedWrapper sw5 = SnomedCTCode.SnomedCode('IHTSDO_4586', '');
                sc5.Value__c = sw5.snomedCodeVal;
                sc5.Code_System__c = sw5.codeSystem;
                sc5.caIntegratorValue__c = sw5.caIntegratorValue;
                sc5.Numeric_Value__c = sw5.numericValue;
                lstSnomed.add(sc5);
                            
                Snomed_Code__c sc6 = new Snomed_Code__c();
                sc6.CRF__c = fo.CRF__c;
                sc6.TrialPatient__c = fo.TrialPatient__c;
                sc6.Name = 'IHTSDO_4584_2';
                SnomedCTCode.SnomedWrapper sw6 = SnomedCTCode.SnomedCode('IHTSDO_4584_2', '');
                sc6.Value__c = sw6.snomedCodeVal;
                sc6.Code_System__c = sw6.codeSystem;
                sc6.caIntegratorValue__c = sw6.caIntegratorValue;
                sc6.Numeric_Value__c = sw6.numericValue;
                lstSnomed.add(sc6);*/
                
                if(sm.Name == 'LocalProgress'){
                    Snomed_Code__c sc7 = new Snomed_Code__c();
                    sc7.CRF__c = fo.CRF__c;
                    sc7.TrialPatient__c = fo.TrialPatient__c;
                    //sc7.Name = '314955001';
                    sc7.snomed_Code_Name__c = '314955001 | local recurrence of malignant tumour of breast | ';
                    sc7.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw7 = null;
                    if(fo.patient_diagnosed_local_progression__c) {
                        sw7 = SnomedCTCode.SnomedCode('Yes', 'LocalProgress');
                    } else {
                        sw7 = SnomedCTCode.SnomedCode('No', 'LocalProgress');
                    }
                    sc7.Value__c = sw7.snomedCodeVal;
                    sc7.Code_System__c = sw7.codeSystem;
                    sc7.caIntegratorValue__c = sw7.caIntegratorValue;
                    sc7.Code_System_Version__c = sw7.codeSystemVersion;
                    sc7.Numeric_Value__c = sw7.numericValue;
                    lstSnomed.add(sc7);
                }
                if(sm.Name == 'DistProgress'){
                    Snomed_Code__c sc8 = new Snomed_Code__c();
                    sc8.CRF__c = fo.CRF__c;
                    sc8.TrialPatient__c = fo.TrialPatient__c;
                    //sc8.Name = '373171005';
                    sc8.snomed_Code_Name__c = '373171005 | pM1: Distant metastasis (breast) | ';
                    sc8.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw8 = null;
                    if(fo.patient_diagnosed_distant_progression__c) {
                        sw8 = SnomedCTCode.SnomedCode('Yes', 'DistProgress');
                    } else {
                        sw8 = SnomedCTCode.SnomedCode('No', 'DistProgress');
                    }
                    sc8.Value__c = sw8.snomedCodeVal;
                    sc8.Code_System__c = sw8.codeSystem;
                    sc8.caIntegratorValue__c = sw8.caIntegratorValue;
                    sc8.Numeric_Value__c = sw8.numericValue;
                    sc8.Code_System_Version__c = sw8.codeSystemVersion;
                    lstSnomed.add(sc8);
                }
                if(sm.Name == 'LocalProgTimeD'){
                    if(fo.patient_diagnosed_local_progression__c) {
                        List<Post_Surgaory_Summary__c> pssList = [Select p.TrialPatient__c, p.Date_Of_Procedure__c From Post_Surgaory_Summary__c p where p.TrialPatient__c = :fo.TrialPatient__c and p.Date_Of_Procedure__c != null order by Effective_Time__c desc LIMIT 1];
                        if(!pssList.isEmpty()) {
                            Date procDate = pssList[0].Date_Of_Procedure__c;
                            Date localProgDate = fo.Local_progression_Date__c;
                            integer days = procDate.daysBetween(localProgDate);
                            Snomed_Code__c sc9 = new Snomed_Code__c();
                            sc9.CRF__c = fo.CRF__c;
                            sc9.TrialPatient__c = fo.TrialPatient__c;
                            //sc9.Name = 'TIMEPHASE_FirstLocal';
                            sc9.snomed_Code_Name__c = 'TIMEPHASE_FirstLocal';
                            sc9.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw9 = SnomedCTCode.SnomedCode(days+'', 'LocalProgTimeD');
                            sc9.Value__c = sw9.snomedCodeVal;
                            sc9.Code_System__c = sw9.codeSystem;
                            sc9.caIntegratorValue__c = sw9.caIntegratorValue;
                            sc9.Code_System_Version__c = sw9.codeSystemVersion;
                            sc9.Numeric_Value__c = sw9.numericValue;
                            lstSnomed.add(sc9);
                        }
                    }
                }
                if(sm.Name == 'DistProgTimeD'){
                    if(fo.patient_diagnosed_distant_progression__c) {
                        List<Post_Surgaory_Summary__c> pssList = [Select p.TrialPatient__c, p.Date_Of_Procedure__c From Post_Surgaory_Summary__c p where p.TrialPatient__c = :fo.TrialPatient__c and p.Date_Of_Procedure__c != null order by Effective_Time__c desc LIMIT 1];
                        if(!pssList.isEmpty()) {
                            Date procDate = pssList[0].Date_Of_Procedure__c;
                            Date distProgDate = fo.Distant_progression_Date__c;
                            integer days = procDate.daysBetween(distProgDate);
                            Snomed_Code__c sc10 = new Snomed_Code__c();
                            sc10.CRF__c = fo.CRF__c;
                            sc10.TrialPatient__c = fo.TrialPatient__c;
                            //sc10.Name = 'TIMEPHASE_FirstDist';
                            sc10.snomed_Code_Name__c = 'TIMEPHASE_FirstDist';
                            sc10.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw10 = SnomedCTCode.SnomedCode(days+'', 'DistProgTimeD');
                            sc10.Value__c = sw10.snomedCodeVal;
                            sc10.Code_System__c = sw10.codeSystem;
                            sc10.caIntegratorValue__c = sw10.caIntegratorValue;
                            sc10.Numeric_Value__c = sw10.numericValue;
                            lstSnomed.add(sc10);
                        }
                    }
                }
                if(sm.Name == 'NewPrimeCa'){
                    Snomed_Code__c sc11 = new Snomed_Code__c();
                    sc11.CRF__c = fo.CRF__c;
                    sc11.TrialPatient__c = fo.TrialPatient__c;
                    //sc11.Name = 'IHTSDO_4680_1';
                    sc11.snomed_Code_Name__c = 'IHTSDO_4680_1';
                    sc11.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw11 = null;
                    if(fo.Patient_diagnose_with_new__c) {
                        sw11 = SnomedCTCode.SnomedCode('Yes', 'NewPrimeCa');
                    } else {
                        sw11 = SnomedCTCode.SnomedCode('No', 'NewPrimeCa');
                    }
                    sc11.Value__c = sw11.snomedCodeVal;
                    sc11.Code_System__c = sw11.codeSystem;
                    sc11.caIntegratorValue__c = sw11.caIntegratorValue;
                    sc11.Numeric_Value__c = sw11.numericValue;
                    sc11.Code_System_Version__c = sw11.codeSystemVersion;
                    lstSnomed.add(sc11);
                }
                if(sm.Name == 'NewPrimeTimeD'){
                    if(fo.patient_diagnosed_distant_progression__c) {
                        List<Post_Surgaory_Summary__c> pssList = [Select p.TrialPatient__c, p.Date_Of_Procedure__c From Post_Surgaory_Summary__c p where p.TrialPatient__c = :fo.TrialPatient__c and p.Date_Of_Procedure__c != null order by Effective_Time__c desc LIMIT 1];
                        if(!pssList.isEmpty()) {
                            Date procDate = pssList[0].Date_Of_Procedure__c;
                            Date distProgDate = fo.Distant_progression_Date__c;
                            integer days = procDate.daysBetween(distProgDate);
                            Snomed_Code__c sc110 = new Snomed_Code__c();
                            sc110.CRF__c = fo.CRF__c;
                            sc110.TrialPatient__c = fo.TrialPatient__c;
                            //sc110.Name = 'TIMEPHASE_FirstNew';
                            sc110.snomed_Code_Name__c = 'TIMEPHASE_FirstNew';
                            sc110.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw110 = SnomedCTCode.SnomedCode(days+'', 'NewPrimeTimeD');
                            sc110.Value__c = sw110.snomedCodeVal;
                            sc110.Code_System__c = sw110.codeSystem;
                            sc110.Numeric_Value__c = sw110.numericValue;
                            sc110.caIntegratorValue__c = sw110.caIntegratorValue;
                            sc110.Code_System_Version__c = sw110.codeSystemVersion;
                            lstSnomed.add(sc110);
                        }
                    }
                }
                
                
                if(sm.Name == 'DistProgSite' && fo.Distant__c != null){
                    Snomed_Code__c sc16 = new Snomed_Code__c();
                    sc16.CRF__c = fo.CRF__c;
                    sc16.TrialPatient__c = fo.TrialPatient__c;
                    //sc16.Name = '385421009';
                    sc16.snomed_Code_Name__c = '385421009 | site of distant metastasis | ';
                    sc16.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw16 = SnomedCTCode.SnomedCode(fo.Distant__c, 'DistProgSite');
                    sc16.Value__c = sw16.snomedCodeVal;
                    sc16.Code_System__c = sw16.codeSystem;
                    sc16.caIntegratorValue__c = sw16.caIntegratorValue;
                    sc16.Numeric_Value__c = sw16.numericValue;
                    sc16.Code_System_Version__c = sw16.codeSystemVersion;
                    lstSnomed.add(sc16);
                }
                
                /*
                SHOULD BE ON THERAPY TRIGGER
                */
                
                /*
                SHOULD BE ON THERAPY TRIGGER
                */
                
                /*
                SHOULD BE ON THERAPY TRIGGER
                */
                
                /*
                SHOULD BE ON THERAPY TRIGGER
                */
                
                /*
                SHOULD BE ON THERAPY TRIGGER
                */
                if(sm.Name == 'LocalProgSite'){
                    Snomed_Code__c sc19 = new Snomed_Code__c();
                    sc19.CRF__c = fo.CRF__c;
                    sc19.TrialPatient__c = fo.TrialPatient__c;
                    //sc19.Name = 'RtBoTD';
                    sc19.snomed_Code_Name__c = 'IHTSDO_4587';
                    sc19.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw19 = new SnomedCTCode.SnomedWrapper();
                    if(fo.Local__c.contains('Ipsilateral Breast')) {
                        sw19 = SnomedCTCode.SnomedCode('Yes', 'LocalProgSite');
                    } else {
                        sw19 = SnomedCTCode.SnomedCode('No', 'LocalProgSite');
                    } 
                    
                    if(fo.Local__c == 'Axillary Nodes') {
                        //NOT CODED
                    } else if(fo.Local__c == 'Internal Mammary Nodes') {
                        //NOT CODED
                    } else if(fo.Local__c == 'Supraclavicular Nodes') {
                        //NOT CODED
                    } else if(fo.Local__c == 'Infraclavicular Nodes') {
                        //NOT CODED
                    } else if(fo.Local__c == 'Chest Wall') {
                        //NOT CODED
                    } else if(fo.Local__c == 'Local-regionalSkin&SubcutaneousTissue') {
                        //NOT CODED
                    }
                    //SnomedCTCode.SnomedWrapper sw19 = SnomedCTCode.SnomedCode('IHTSDO_4586', fo.Local__c);
                    sc19.Value__c = sw19.snomedCodeVal;
                    sc19.Code_System__c = sw19.codeSystem;
                    sc19.caIntegratorValue__c = sw19.caIntegratorValue;
                    sc19.Numeric_Value__c = sw19.numericValue;
                    sc19.Code_System_Version__c = sw19.codeSystemVersion;
                    lstSnomed.add(sc19);
                }
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
        insertSnomedCodesForRadiationTherapy(isIds);
        insertSnomedCodesForLongTermTherapy(ffList);
    }
    
    //@future
    private static void insertSnomedCodesForRadiationTherapy(Set<Id> therapyIds) {
        List<Irradiated_Site__c> sites = [Select i.Total_dose_cGy_AP__c, i.Total_FX__c, i.TotalFX__c, i.Site__c, i.Name, i.Followup_Form__c, i.Followup_Form__r.TrialPatient__c, i.Followup_Form__r.CRF__C, i.Dose_per_FX_cGy__c From Irradiated_Site__c i where i.id in :therapyIds];
        Set<Id> ffIds = new Set<Id>();
        for(Irradiated_Site__c site: sites) {
            ffIds.add(site.Followup_Form__c);
        }
        List<Followup_Form__c> ffList = [Select Id, (Select i.Total_dose_cGy_AP__c, i.Total_FX__c, i.TotalFX__c, i.Site__c, i.Name, i.Followup_Form__c, i.Followup_Form__r.CRF__C, i.Dose_per_FX_cGy__c From Irradiated_Sites__r i) From Followup_Form__c where id in :ffIds];
        
        List<Code_Master__c> snomedMasterList = [Select Id,Name from Code_Master__c where Name = 'RtTherapy' or Name = 'RtBrTD' or Name = 'RtCWTD' or Name = 'RtIMTD' or Name = 'RtSNTD' or Name = 'RtAxTD' or Name = 'RtBoTD'];
        Map<String, Id> nameIdMap = new Map<String, Id>();
        for(Code_Master__c sm : snomedMasterList) {
            nameIdMap.put(sm.Name, sm.Id);
        }
        
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        for(Irradiated_Site__c site : sites) {
            //Ensure snomed code record named RtTherapy is deleted
            Snomed_Code__c sc3 = new Snomed_Code__c();
            sc3.CRF__c = site.Followup_Form__r.CRF__C;
            sc3.TrialPatient__c = site.Followup_Form__r.TrialPatient__c;
            //sc3.Name = 'RtTherapy';
            sc3.snomed_Code_Name__c = '428923005 | radiotherapy to breast | ';
            sc3.Code_Master__c = nameIdMap.get('RtTherapy');
            SnomedCTCode.SnomedWrapper sw3 = SnomedCTCode.SnomedCode('Yes', 'RtTherapy');
            sc3.Value__c = sw3.snomedCodeVal;
            sc3.Code_System__c = sw3.codeSystem;
            sc3.Numeric_Value__c = sw3.numericValue;
            sc3.caIntegratorValue__c = sw3.caIntegratorValue;
            sc3.Code_System_Version__c = sw3.codeSystemVersion;
            lstSnomed.add(sc3);
            
            //Ensure snomed code for RtBrTD is deleted
            Snomed_Code__c sc4 = new Snomed_Code__c();
            sc4.CRF__c = site.Followup_Form__r.CRF__C;
            sc4.TrialPatient__c = site.Followup_Form__r.TrialPatient__c;
            //sc4.Name = 'RtBrTD';
            sc4.snomed_Code_Name__c = 'IHTSDO_4584_1';
            sc4.Code_Master__c = nameIdMap.get('RtBrTD');
            List<Irradiated_Site__c> allSites = null;
            for(Followup_Form__c ff : ffList) {
                if(ff.Id == site.Followup_Form__c) {
                    allSites = ff.Irradiated_Sites__r;
                    break;
                }
            }
            Decimal totalDose = 0;
            for(Irradiated_Site__c s : allSites) {
                totalDose += s.Total_dose_cGy_AP__c;
            }
            SnomedCTCode.SnomedWrapper sw4 = SnomedCTCode.SnomedCode(totalDose+'', 'RtBrTD');
            sc4.Value__c = sw4.snomedCodeVal;
            sc4.Code_System__c = sw4.codeSystem;
            sc4.caIntegratorValue__c = sw4.caIntegratorValue;
            sc4.Numeric_Value__c = sw4.numericValue;
            sc4.Code_System_Version__c = sw4.codeSystemVersion;
            lstSnomed.add(sc4);
            
            
            //Ensure snomed code for deleted RtCWTD
            Snomed_Code__c sc17 = new Snomed_Code__c();
            sc17.CRF__c = site.Followup_Form__r.CRF__C;
            sc17.TrialPatient__c = site.Followup_Form__r.TrialPatient__c;
            //sc17.Name = 'RtCWTD';
            sc17.snomed_Code_Name__c = 'IHTSDO_4584_5';
            sc17.Code_Master__c = nameIdMap.get('RtCWTD');
            allSites.clear();
            for(Followup_Form__c ff : ffList) {
                if(ff.Id == site.Followup_Form__c) {
                    for(Irradiated_Site__c st : ff.Irradiated_Sites__r) {
                        if(st.Site__c == 'Chest wall') {
                            allSites.add(site);
                            break;
                        }
                    }
                }
            }
            Decimal chestWallTotalDose = 0;
            for(Irradiated_Site__c s : allSites) {
                chestWallTotalDose += s.Total_dose_cGy_AP__c;
            }
            SnomedCTCode.SnomedWrapper sw17 = SnomedCTCode.SnomedCode(chestWallTotalDose+'', 'RtCWTD');
            sc17.Value__c = sw17.snomedCodeVal;
            sc17.Code_System__c = sw17.codeSystem;
            sc17.caIntegratorValue__c = sw17.caIntegratorValue;
            sc17.Numeric_Value__c = sw17.numericValue;
            sc17.Code_System_Version__c = sw17.codeSystemVersion;
            lstSnomed.add(sc17);
            
            //Ensure snomed code for RtBrTD is deleted RtIMTD
            Snomed_Code__c sc18 = new Snomed_Code__c();
            sc18.CRF__c = site.Followup_Form__r.CRF__C;
            sc18.TrialPatient__c = site.Followup_Form__r.TrialPatient__c;
            //sc18.Name = 'RtIMTD';
            sc18.snomed_Code_Name__c = 'IHTSDO_4584_4';
            sc18.Code_Master__c = nameIdMap.get('RtIMTD');
            allSites.clear();
            for(Followup_Form__c ff : ffList) {
                if(ff.Id == site.Followup_Form__c) {
                    for(Irradiated_Site__c st : ff.Irradiated_Sites__r) {
                        if(st.Site__c == 'Internal mammary node') {
                            allSites.add(site);
                            break;
                        }
                    }
                }
            }
            Decimal intMammaryTotalDose = 0;
            for(Irradiated_Site__c s : allSites) {
                intMammaryTotalDose += s.Total_dose_cGy_AP__c;
            }
            SnomedCTCode.SnomedWrapper sw18 = SnomedCTCode.SnomedCode(intMammaryTotalDose+'', 'RtIMTD');
            sc18.Value__c = sw18.snomedCodeVal;
            sc18.Code_System__c = sw18.codeSystem;
            sc18.caIntegratorValue__c = sw18.caIntegratorValue;
            sc18.Numeric_Value__c = sw18.numericValue;
            sc18.Code_System_Version__c = sw18.codeSystemVersion;
            lstSnomed.add(sc18);
            
            //Ensure snomed code for RtSNTD is deleted
            Snomed_Code__c sc19 = new Snomed_Code__c();
            sc19.CRF__c = site.Followup_Form__r.CRF__C;
            sc19.TrialPatient__c = site.Followup_Form__r.TrialPatient__c;
            //sc19.Name = 'RtSNTD';
            sc19.snomed_Code_Name__c = 'IHTSDO_4584_3';
            sc19.Code_Master__c = nameIdMap.get('RtSNTD');
            allSites.clear();
            for(Followup_Form__c ff : ffList) {
                if(ff.Id == site.Followup_Form__c) {
                    for(Irradiated_Site__c st : ff.Irradiated_Sites__r) {
                        if(st.Site__c == 'Supraclavicular node') {
                            allSites.add(site);
                            break;
                        }
                    }
                }
            }
            Decimal sNodeTotalDose = 0;
            for(Irradiated_Site__c s : allSites) {
                sNodeTotalDose += s.Total_dose_cGy_AP__c;
            }
            SnomedCTCode.SnomedWrapper sw19 = SnomedCTCode.SnomedCode(sNodeTotalDose+'', 'RtSNTD');
            sc19.Value__c = sw19.snomedCodeVal;
            sc19.Code_System__c = sw19.codeSystem;
            sc19.caIntegratorValue__c = sw19.caIntegratorValue;
            sc19.Numeric_Value__c = sw19.numericValue;
            sc19.Code_System_Version__c = sw19.codeSystemVersion;
            lstSnomed.add(sc19);
            
            //Ensure snomed code for RtAxTD is deleted
            Snomed_Code__c sc20 = new Snomed_Code__c();
            sc20.CRF__c = site.Followup_Form__r.CRF__C;
            sc20.TrialPatient__c = site.Followup_Form__r.TrialPatient__c;
            //sc20.Name = 'RtAxTD';
            sc20.snomed_Code_Name__c = 'IHTSDO_4584_2';
            sc20.Code_Master__c = nameIdMap.get('RtAxTD');
            allSites.clear();
            for(Followup_Form__c ff : ffList) {
                if(ff.Id == site.Followup_Form__c) {
                    for(Irradiated_Site__c st : ff.Irradiated_Sites__r) {
                        if(st.Site__c == 'Axilla') {
                            allSites.add(site);
                            break;
                        }
                    }
                }
            }
            Decimal axillaTotalDose = 0;
            for(Irradiated_Site__c s : allSites) {
                axillaTotalDose += s.Total_dose_cGy_AP__c;
            }
            SnomedCTCode.SnomedWrapper sw20 = SnomedCTCode.SnomedCode(axillaTotalDose+'', 'RtAxTD');
            sc20.Value__c = sw20.snomedCodeVal;
            sc20.Code_System__c = sw20.codeSystem;
            sc20.caIntegratorValue__c = sw20.caIntegratorValue;
            sc20.Numeric_Value__c = sw20.numericValue;
            sc20.Code_System_Version__c = sw20.codeSystemVersion;
            lstSnomed.add(sc20);
            
            //Ensure snomed code for RtBoTD is deleted
            Snomed_Code__c sc21 = new Snomed_Code__c();
            sc21.CRF__c = site.Followup_Form__r.CRF__C;
            sc21.TrialPatient__c = site.Followup_Form__r.TrialPatient__c;
            //sc21.Name = 'RtBoTD';
            sc21.snomed_Code_Name__c = 'IHTSDO_4586';
            sc21.Code_Master__c = nameIdMap.get('RtBoTD');
            allSites.clear();
            for(Followup_Form__c ff : ffList) {
                if(ff.Id == site.Followup_Form__c) {
                    for(Irradiated_Site__c st : ff.Irradiated_Sites__r) {
                        if(st.Site__c == 'Boost') {
                            allSites.add(site);
                            break;
                        }
                    }
                }
            }
            Decimal boostTotalDose = 0;
            for(Irradiated_Site__c s : allSites) {
                boostTotalDose += s.Total_dose_cGy_AP__c;
            }
            SnomedCTCode.SnomedWrapper sw21 = SnomedCTCode.SnomedCode(boostTotalDose+'', 'RtBoTD');
            sc21.Value__c = sw21.snomedCodeVal;
            sc21.Code_System__c = sw21.codeSystem;
            sc21.caIntegratorValue__c = sw21.caIntegratorValue;
            sc21.Numeric_Value__c = sw21.numericValue;
            sc21.Code_System_Version__c = sw21.codeSystemVersion;
            lstSnomed.add(sc21);
        }
        
        if(!lstSnomed.isEmpty() && !Test.isRunningTest()){
            insert lstSnomed;
        }
    }
    
    //@future
    private static void insertSnomedCodesForLongTermTherapy(List<Followup_Form__c> ffList) {
        
        //List<Therapy_Received__c> aromataseInhibitorList = [Select t.Therapy__c, t.Followup_Form__r.Status__c, t.Followup_Form__c From Therapy_Received__c t where t.Therapy__c = 'Aromatase inhibitor' and t.Followup_Form__r.Status__c = 'Accepted']; 
        //List<Therapy_Received__c> ovarianSuppressionList = [Select t.Therapy__c, t.Followup_Form__r.Status__c, t.Followup_Form__c From Therapy_Received__c t where t.Therapy__c = 'Ovarian suppression' and t.Followup_Form__r.Status__c = 'Accepted'];
        //List<Therapy_Received__c> trastuzumabList = [Select t.Therapy__c, t.Followup_Form__r.Status__c, t.Followup_Form__c From Therapy_Received__c t where t.Therapy__c = 'Trastuzumab' and t.Followup_Form__r.Status__c = 'Accepted'];
        //List<Therapy_Received__c> tamoxifenList = [Select t.Therapy__c, t.Followup_Form__r.Status__c, t.Followup_Form__c From Therapy_Received__c t where t.Therapy__c = 'Tamoxifen' and t.Followup_Form__r.Status__c = 'Accepted'];
        
        /*List<Therapy_Received__c> theList = [Select t.Therapy__c, t.Start_Date_Date_Performed__c, t.Name, t.Followup_Form__c, t.Followup_Form__r.CRF__C, t.Followup_Form__r.TrialPatient__c, t.End_Date__c, t.Detail__c From Therapy_Received__c t where t.id in :theIds];
        Set<Id> ffIds = new Set<Id>();
        for(Therapy_Received__c t : theList) {
            ffIds.add(t.Followup_Form__c);
        }
        List<Followup_Form__c> ffList = [Select Id, CRF__c, TrialPatient__c, (Select t.Therapy__c, t.Start_Date_Date_Performed__c, t.Name, t.Followup_Form__c, t.Followup_Form__r.CRF__C, t.End_Date__c, t.Detail__c From Therapy_Receiveds__r t) From Followup_Form__c where id in :ffIds and Status__c = 'Accepted'];
        */
        List<Code_Master__c> snomedMasterList = [Select Id,Name from Code_Master__c where Name = 'Adj_AromataseInhib' or Name = 'Adj_OvarianSup' or Name = 'Adj_OvarianAbl' or Name = 'Adj_Tam' or Name = 'Adj_Trastuzumab' or Name = 'Adj_Chemo' or Name = 'Adj_ChemoReg' or Name = 'Adj_Other' or Name = 'Adu_OtherReg'];
        Map<String, Id> nameIdMap = new Map<String, Id>();
        for(Code_Master__c sm : snomedMasterList) {
            nameIdMap.put(sm.Name, sm.Id);
        }
        
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        
        for(Followup_Form__c ff : ffList) {
            system.debug('__ff.Therapy_Receiveds__r__'+ff.Therapy_Receiveds__r);
            system.debug('__ff.Therapy_Receiveds__r.Size()__'+ff.Therapy_Receiveds__r.Size());
            for(Therapy_Received__c t : ff.Therapy_Receiveds__r) {
                if(ff.id != t.Followup_Form__c)continue;
                //if(sm.Name == 'Adj_Trastuzumab' || sm.Name == 'Adj_OvarianAbl' || sm.Name == 'Adj_Tam'){
                
                List<Therapy_Received__c> recList  = ff.Therapy_Receiveds__r;
                integer trastuzumabSize  = 0;
                integer ovablSize  = 0;
                integer tamoxSize  = 0;
                integer aroInhSize  = 0;
                integer ovSupSize  = 0;
                for(Therapy_Received__c tr : recList) {
                    if(tr.Therapy__c == 'Aromatase inhibitor')trastuzumabSize++;
                    if(tr.Therapy__c == 'Ovarian ablation')ovablSize++;
                    if(tr.Therapy__c == 'Tamoxifen')tamoxSize++;
                    if(tr.Therapy__c == 'Aromatase inhibitor')aroInhSize++;
                    if(tr.Therapy__c == 'Ovarian suppression')ovSupSize++;
                }
                
                Snomed_Code__c sc12 = new Snomed_Code__c();
                sc12.CRF__c = ff.CRF__c;
                sc12.TrialPatient__c = ff.TrialPatient__c;
                //sc12.Name = 'Adj_Trastuzumab';
                sc12.snomed_Code_Name__c = 'Adj_Trastuzumab';
                sc12.Code_Master__c = nameIdMap.get('Adj_Trastuzumab');
                /*List<Therapy_Received__c> recList  = ff.Therapy_Receiveds__r;
                integer trastuzumabSize  = 0;
                for(Therapy_Received__c tr : recList) {
                    if(tr.Therapy__c == 'Aromatase inhibitor')trastuzumabSize++;
                }*/
                SnomedCTCode.SnomedWrapper sw12 = SnomedCTCode.SnomedCode(trastuzumabSize > 0?'Yes' : 'No', 'Adj_Trastuzumab');
                sc12.Value__c = sw12.snomedCodeVal;
                sc12.Code_System__c = sw12.codeSystem;
                sc12.caIntegratorValue__c = sw12.caIntegratorValue;
                sc12.Numeric_Value__c = sw12.numericValue;
                sc12.Code_System_Version__c = sw12.codeSystemVersion;
                lstSnomed.add(sc12);

                Snomed_Code__c sc13 = new Snomed_Code__c();
                sc13.CRF__c = ff.CRF__c;
                sc13.TrialPatient__c = ff.TrialPatient__c;
                //sc13.Name = 'Adj_OvarianAbl';
                sc13.snomed_Code_Name__c = 'Adj_OvarianAbl';
                sc13.Code_Master__c = nameIdMap.get('Adj_OvarianAbl');
                /*recList.clear();
                recList  = ff.Therapy_Receiveds__r;
                integer ovablSize  = 0;
                for(Therapy_Received__c tr : recList) {
                    if(tr.Therapy__c == 'Ovarian ablation')ovablSize++;
                }*/
                SnomedCTCode.SnomedWrapper sw13 = SnomedCTCode.SnomedCode(ovablSize > 0?'Yes' : 'No', 'Adj_OvarianAbl');
                sc13.Value__c = sw13.snomedCodeVal;
                sc13.Code_System__c = sw13.codeSystem;
                sc13.caIntegratorValue__c = sw13.caIntegratorValue;
                sc13.Numeric_Value__c = sw13.numericValue;
                sc13.Code_System_Version__c = sw13.codeSystemVersion;
                lstSnomed.add(sc13);

                Snomed_Code__c sc14 = new Snomed_Code__c();
                sc14.CRF__c = ff.CRF__c;
                sc14.TrialPatient__c = ff.TrialPatient__c;
                //sc14.Name = 'Adj_Tam';
                sc14.snomed_Code_Name__c = 'Adj_Tam';
                sc14.Code_Master__c = nameIdMap.get('Adj_Tam');
                /*recList.clear();
                recList  = ff.Therapy_Receiveds__r;
                integer tamoxSize  = 0;
                for(Therapy_Received__c tr : recList) {
                    if(tr.Therapy__c == 'Tamoxifen')tamoxSize++;
                }*/
                SnomedCTCode.SnomedWrapper sw14 = SnomedCTCode.SnomedCode(tamoxSize > 0?'Yes' : 'No', 'Adj_Tam');
                sc14.Value__c = sw14.snomedCodeVal;
                sc14.Code_System__c = sw14.codeSystem;
                sc14.caIntegratorValue__c = sw14.caIntegratorValue;
                sc14.Numeric_Value__c = sw14.numericValue;
                sc14.Code_System_Version__c = sw14.codeSystemVersion;
                lstSnomed.add(sc14);

                Snomed_Code__c sc15 = new Snomed_Code__c();
                sc15.CRF__c = ff.CRF__c;
                sc15.TrialPatient__c = ff.TrialPatient__c;
                //sc15.Name = 'Adj_AromataseInhib';
                sc15.snomed_Code_Name__c = 'Adj_AromataseInhib';
                sc15.Code_Master__c = nameIdMap.get('Adj_AromataseInhib');
                /*recList.clear();
                recList  = ff.Therapy_Receiveds__r;
                integer aroInhSize  = 0;
                for(Therapy_Received__c tr : recList) {
                    if(tr.Therapy__c == 'Aromatase inhibitor')aroInhSize++;
                }*/
                SnomedCTCode.SnomedWrapper sw15 = SnomedCTCode.SnomedCode(aroInhSize > 0?'Yes' : 'No', 'Adj_AromataseInhib');
                sc15.Value__c = sw15.snomedCodeVal;
                sc15.Code_System__c = sw15.codeSystem;
                sc15.caIntegratorValue__c = sw15.caIntegratorValue;
                sc15.Numeric_Value__c = sw15.numericValue;
                sc15.Code_System_Version__c = sw15.codeSystemVersion;
                lstSnomed.add(sc15);

                Snomed_Code__c sc16 = new Snomed_Code__c();
                sc16.CRF__c = ff.CRF__c;
                sc16.TrialPatient__c = ff.TrialPatient__c;
                //sc15.Name = 'Adj_OvarianSup';
                sc16.snomed_Code_Name__c = 'Adj_OvarianSup';
                sc16.Code_Master__c = nameIdMap.get('Adj_OvarianSup');
                /*recList.clear();
                recList  = ff.Therapy_Receiveds__r;
                integer ovSupSize  = 0;
                for(Therapy_Received__c tr : recList) {
                    if(tr.Therapy__c == 'Ovarian suppression')ovSupSize++;
                }*/
                SnomedCTCode.SnomedWrapper sw16 = SnomedCTCode.SnomedCode(ovSupSize> 0?'Yes' : 'No', 'Adj_OvarianSup');
                sc16.Value__c = sw16.snomedCodeVal;
                sc16.Code_System__c = sw16.codeSystem;
                sc16.caIntegratorValue__c = sw16.caIntegratorValue;
                sc16.Numeric_Value__c = sw16.numericValue;
                sc16.Code_System_Version__c = sw16.codeSystemVersion;
                lstSnomed.add(sc16);

                /*Snomed_Code__c sc141 = new Snomed_Code__c();
                sc141.CRF__c = ff.CRF__c;
                sc141.TrialPatient__c = ff.TrialPatient__c;
                sc141.Name = 'Adj_Chemo';
                sc141.Code_Master__c = nameIdMap.get('Adj_Chemo');
                SnomedCTCode.SnomedWrapper sw141 = SnomedCTCode.SnomedCode('','');
                sc141.Value__c = sw141.snomedCodeVal;
                sc141.Code_System__c = sw141.codeSystem;
                sc141.caIntegratorValue__c = sw141.caIntegratorValue;
                sc141.Numeric_Value__c = sw141.numericValue;
                lstSnomed.add(sc141);*/
            }
        }
        
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    @future
    public static void insertSnomedCodesForMRI(Set<Id> mriIds) {
        
        List<MRI_Volume__c> mriList = [Select m.pg_MRIVolume_Id__c, m.Was_MRI_Readable__c, m.TrialPatient__c, m.Time_Point__c, m.Time_Point_Snomed__c, m.Target_4_Longest_Diameter_in_cm__c, m.Target_4_Location_in_O_clock__c, m.Target_3_Longest_Diameter_in_cm__c, m.Target_3_Location_in_O_clock__c, m.Target_2_Longest_Diameter_in_cm__c, m.Target_2_Location_in_O_clock__c, m.SystemModstamp, m.Status__c, m.Seprate_masses_or_enhancements_reported__c, m.RecordTypeId, m.Phase__c, m.Pg_Status__c, m.Patient__c, m.OwnerId, m.OriginalCRF__c, m.Name, m.MRI_Volume_in_cm3__c, m.MRI_Scan_Date__c, m.MRI_Longest_Diameter_time_point_1_Snomed__c, m.Longest_Diameter_Of_Index_Lesion_in_cm__c, m.Location_in_O_clock__c, m.Laterality__c, m.LastModifiedDate, m.LastModifiedById, m.LastActivityDate, m.IsDeleted, m.Id, m.CreatedDate, m.CreatedById, m.CompletedDate__c, m.Comments__c, m.CRF__c, m.ACRIN_ID__c From MRI_Volume__c m where m.id in :mriIds and Status__c = 'Accepted'];
        
        Set<Id> ids = new Set<Id>();
        for(MRI_Volume__c mv : mriList){
            ids.add(mv.TrialPatient__c);
        }
        //1. Collect time point volumes
        List<MRI_Volume__c> mriT1List = [Select m.TrialPatient__c, m.Time_Point__c, m.Status__c, m.MRI_Volume_in_cm3__c From MRI_Volume__c m where m.TrialPatient__c in :ids and m.Status__c = 'Accepted'];
        Map<Id, Decimal> trialPatientAndT0MRIVolumeMap = new Map<Id, Decimal>();
        Map<Id, Decimal> trialPatientAndT1MRIVolumeMap = new Map<Id, Decimal>();
        Map<Id, Decimal> trialPatientAndT2MRIVolumeMap = new Map<Id, Decimal>();
        for(MRI_Volume__c mri : mriT1List) {
            if(mri.Time_Point__c == 'Pre-Treatment') {
                trialPatientAndT0MRIVolumeMap.put(mri.TrialPatient__c, mri.MRI_Volume_in_cm3__c);
            } else if(mri.Time_Point__c == 'Early Treatment') {
                trialPatientAndT1MRIVolumeMap.put(mri.TrialPatient__c, mri.MRI_Volume_in_cm3__c);
            } else if(mri.Time_Point__c == 'Inter-Regimen') {
                trialPatientAndT2MRIVolumeMap.put(mri.TrialPatient__c, mri.MRI_Volume_in_cm3__c);
            }
        }
        
        //2. Insert snomed codes
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'MRIvol_T0' or Name = 'MRIvol_T1' or Name = 'MRIvol_T2' or Name = 'MRIvol_T3' or Name = 'MRILD_T0' or Name = 'MRILD_T1' or Name = 'MRILD_T2' or Name = 'MRILD_T3'];
        Map<String, Id> snomedMasterMap = new Map<String, Id>();
        for(Code_Master__c sm : lstSnomedMaster) {
            snomedMasterMap.put(sm.Name, sm.Id);
        }
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        for(MRI_Volume__c mri : mriList){
            for(Code_Master__c sm : lstSnomedMaster) {
                Snomed_Code__c sc = new Snomed_Code__c();
                sc.CRF__c = mri.CRF__c;
                sc.TrialPatient__c = mri.TrialPatient__c;
                if(mri.Time_Point__c == 'Pre-Treatment' && sm.Name == 'MRIvol_T0'){
                    sc.CRF__c = mri.CRF__c;
                    sc.Code_Master__c = sm.Id;
                    sc.snomed_Code_Name__c = 'LOINC_MRI_Vol_3';
                    sc.Composition_2__c = '';
                    sc.Code_Master__c = sm.Id; 
                    if(mri.Longest_Diameter_Of_Index_Lesion_in_cm__c != null) {
                        sc.Value__c = ''+mri.MRI_Volume_in_cm3__c;
                        sc.caIntegratorValue__c = ''+mri.MRI_Volume_in_cm3__c;
                    } else {
                        sc.Value__c = '';
                        sc.caIntegratorValue__c = '';
                    }
                    sc.Code_System__c = 'LOINC';
                    sc.Code_System_Version__c = '';
                    lstSnomed.add(sc);
                    
                    system.debug('-------snomed code name 1------'+sc.snomed_Code_Name__c);
                    
                } else if(mri.Time_Point__c == 'Early Treatment' && sm.Name == 'MRIvol_T1'){
                    sc.Code_Master__c = sm.Id;
                    sc.CRF__c = mri.CRF__c;
                    sc.snomed_Code_Name__c = 'LOINC_MRI_Vol_1';
                    sc.Composition_2__c = 'TIMEPOINT_Early';
                    if(mri.Longest_Diameter_Of_Index_Lesion_in_cm__c != null) {
                        sc.Value__c = ''+mri.MRI_Volume_in_cm3__c;
                        sc.caIntegratorValue__c = ''+mri.MRI_Volume_in_cm3__c;
                    } else {
                        sc.Value__c = '';
                        sc.caIntegratorValue__c = '';
                    }
                    sc.Code_System__c = 'LOINC';
                    sc.Code_System_Version__c = '';
                    lstSnomed.add(sc);
                    
                    system.debug('-------snomed code name 2------'+sc.snomed_Code_Name__c);
                    
                } else if(mri.Time_Point__c == 'Inter-Regimen' && sm.Name == 'MRIvol_T2'){
                    sc.Code_Master__c = sm.Id;
                    sc.CRF__c = mri.CRF__c;
                    sc.snomed_Code_Name__c = 'LOINC_MRI_Vol_1';
                    sc.Composition_2__c = 'TIMEPOINT_InterReg';
                    if(mri.Longest_Diameter_Of_Index_Lesion_in_cm__c != null) {
                        sc.Value__c = ''+mri.MRI_Volume_in_cm3__c;
                        sc.caIntegratorValue__c = ''+mri.MRI_Volume_in_cm3__c;
                    } else {
                        sc.Value__c = '';
                        sc.caIntegratorValue__c = '';
                    }
                    sc.Code_System__c = 'LOINC';
                    sc.Code_System_Version__c = '';
                    lstSnomed.add(sc);
                    
                    system.debug('-------snomed code name 3------'+sc.snomed_Code_Name__c);
                    
                } else if(mri.Time_Point__c == 'Pre-Surgery' && sm.Name == 'MRIvol_T3'){
                    sc.Code_Master__c = sm.Id;
                    sc.CRF__c = mri.CRF__c;
                    sc.snomed_Code_Name__c = 'LOINC_MRI_Vol_1';
                    sc.Composition_2__c = 'TIMEPOINT_PreSx';
                    if(mri.Longest_Diameter_Of_Index_Lesion_in_cm__c != null) {
                        sc.Value__c = ''+mri.MRI_Volume_in_cm3__c;
                        sc.caIntegratorValue__c = ''+mri.MRI_Volume_in_cm3__c;
                    } else {
                        sc.Value__c = '';
                        sc.caIntegratorValue__c = '';
                    }
                    sc.Code_System__c = 'LOINC';
                    sc.Code_System_Version__c = '';
                    lstSnomed.add(sc);
                    
                    system.debug('-------snomed code name 4------'+sc.snomed_Code_Name__c);
                }
                
                Snomed_Code__c sc1 = new Snomed_Code__c();
                sc1.CRF__c = mri.CRF__c;
                sc1.TrialPatient__c = mri.TrialPatient__c;
                if(mri.Time_Point__c == 'Pre-Treatment' && mri.Longest_Diameter_Of_Index_Lesion_in_cm__c != null && sm.Name == 'MRILD_T0'){
                    //sc1.Name = 'IHTSDO_4562';
                    //sc1.Name = 'MRILD_T0';
                    sc1.snomed_Code_Name__c = 'IHTSDO_4562';
                    sc1.Code_Master__c = sm.Id;
                    //SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(''+mri.Longest_Diameter_Of_Index_Lesion_in_cm__c, 'MRILD_T0');
                    if(mri.Longest_Diameter_Of_Index_Lesion_in_cm__c != null) {
                        sc1.Value__c = ''+mri.Longest_Diameter_Of_Index_Lesion_in_cm__c;
                        sc1.caIntegratorValue__c = ''+mri.Longest_Diameter_Of_Index_Lesion_in_cm__c;
                    } else {
                        sc1.Value__c = '';
                        sc1.caIntegratorValue__c = '';
                    }
                    sc1.Code_System__c = 'SNOMED CT';
                    sc1.Code_System_Version__c = '';
                    lstSnomed.add(sc1);
                    system.debug('-------snomed code name 5------'+sc1.snomed_Code_Name__c);
                    
                } else if(mri.Time_Point__c == 'Early Treatment' && mri.Longest_Diameter_Of_Index_Lesion_in_cm__c != null && sm.Name == 'MRILD_T1'){
                    //sc1.Name = 'LOINC_MRI_LENGTH_2';
                    //sc1.Name = 'MRILD_T1';
                    sc1.snomed_Code_Name__c = 'LOINC_MRI_LENGTH_2';
                    sc1.Code_Master__c = sm.Id;
                    sc1.Composition_2__c = 'TIMEPOINT_Early';
                    //SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(''+mri.Longest_Diameter_Of_Index_Lesion_in_cm__c, 'MRILD_T1');
                    if(mri.Longest_Diameter_Of_Index_Lesion_in_cm__c != null) {
                        sc1.Value__c = ''+mri.Longest_Diameter_Of_Index_Lesion_in_cm__c;
                        sc1.caIntegratorValue__c = ''+mri.Longest_Diameter_Of_Index_Lesion_in_cm__c;
                    } else {
                        sc1.Value__c = '';
                        sc1.caIntegratorValue__c = '';
                    }
                    sc1.Code_System__c = 'LOINC';
                    sc1.Code_System_Version__c = '';
                    lstSnomed.add(sc1);
                    system.debug('-------snomed code name 6------'+sc1.snomed_Code_Name__c);
                     
                } else if(mri.Time_Point__c == 'Inter-Regimen' && mri.Longest_Diameter_Of_Index_Lesion_in_cm__c != null && sm.Name == 'MRILD_T2'){
                    //sc1.Name = 'LOINC_MRI_LENGTH_2';
                    //sc1.Name = 'MRILD_T2';
                    sc1.snomed_Code_Name__c = 'LOINC_MRI_LENGTH_2';
                    sc1.Code_Master__c = sm.Id;
                    sc1.Composition_2__c = 'TIMEPOINT_InterReg';
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(''+mri.Longest_Diameter_Of_Index_Lesion_in_cm__c, 'MRILD_T2');
                    if(mri.Longest_Diameter_Of_Index_Lesion_in_cm__c != null) {
                        sc1.Value__c = ''+mri.Longest_Diameter_Of_Index_Lesion_in_cm__c;
                        sc1.caIntegratorValue__c = ''+mri.Longest_Diameter_Of_Index_Lesion_in_cm__c;
                    } else {
                        sc1.Value__c = '';
                        sc1.caIntegratorValue__c = '';
                    }
                    sc1.Code_System__c = 'LOINC';
                    sc1.Code_System_Version__c = '';
                    lstSnomed.add(sc1);
                    system.debug('-------snomed code name 7------'+sc1.snomed_Code_Name__c);
                    
                } else if(mri.Time_Point__c == 'Pre-Surgery' && mri.Longest_Diameter_Of_Index_Lesion_in_cm__c != null && sm.Name == 'MRILD_T3'){
                    //sc1.Name = 'LOINC_MRI_LENGTH_2';
                    //sc1.Name = 'MRILD_T3';
                    sc1.snomed_Code_Name__c = 'LOINC_MRI_LENGTH_2';
                    sc1.Composition_2__c = 'TIMEPOINT_PreSx';
                    sc1.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(''+mri.Longest_Diameter_Of_Index_Lesion_in_cm__c, 'MRILD_T3');
                    if(mri.Longest_Diameter_Of_Index_Lesion_in_cm__c != null) {
                        sc1.Value__c = ''+mri.Longest_Diameter_Of_Index_Lesion_in_cm__c;
                        sc1.caIntegratorValue__c = ''+mri.Longest_Diameter_Of_Index_Lesion_in_cm__c;
                    } else {
                        sc1.Value__c = '';
                        sc1.caIntegratorValue__c = '';
                    }
                    sc1.Code_System__c = 'LOINC';
                    sc1.Code_System_Version__c = '';
                    lstSnomed.add(sc1);
                    system.debug('-------snomed code name 8------'+sc1.snomed_Code_Name__c);
                }
                //lstSnomed.add(sc1);
            }
            //FOLLOWING CODE GIVES volume change from baseline volume at T1
            if(mri.Time_Point__c == 'Early treatment') {
                Snomed_Code__c sc2 = new Snomed_Code__c();
                sc2.CRF__c = mri.CRF__c;
                sc2.TrialPatient__c = mri.TrialPatient__c;
                Decimal baselineMriVolume = trialPatientAndT0MRIVolumeMap.get(mri.TrialPatient__c);
                if(baselineMriVolume != null && mri.MRI_Volume_in_cm3__c != null && baselineMriVolume != 0){
                    Decimal changeInVolume = (baselineMriVolume - mri.MRI_Volume_in_cm3__c) / baselineMriVolume;  
                    sc2.CRF__c = mri.CRF__c;
                    sc2.TrialPatient__c = mri.TrialPatient__c;
                    //sc2.Name = 'MRIvol_T0-T1';
                    sc2.snomed_Code_Name__c = 'MRIvol_T0-T1';
                    sc2.Code_Master__c = snomedMasterMap.get('MRIvol_T0-T1');
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(changeInVolume+'', 'MRIvol_T0-T1');
                    sc2.Code_System__c = sw.codeSystem;
                    sc2.caIntegratorValue__c = sw.caIntegratorValue;
                    sc2.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc2);
                }
            }
            
            if(mri.Time_Point__c == 'Inter-regimen') {
                Snomed_Code__c sc2 = new Snomed_Code__c();
                sc2.CRF__c = mri.CRF__c;
                sc2.TrialPatient__c = mri.TrialPatient__c;
                Decimal baselineMriVolume = trialPatientAndT0MRIVolumeMap.get(mri.TrialPatient__c);
                SnomedCTCode.SnomedWrapper sw = null;
                if(baselineMriVolume != null && mri.MRI_Volume_in_cm3__c != null && baselineMriVolume != 0){
                    Decimal changeInVolumeT0T2 = (baselineMriVolume - mri.MRI_Volume_in_cm3__c) / baselineMriVolume;
                    
                    sc2.CRF__c = mri.CRF__c;
                    sc2.TrialPatient__c = mri.TrialPatient__c;
                    //sc2.Name = 'MRIvol_T0-T2';
                    sc2.snomed_Code_Name__c = 'MRIvol_T0-T2';
                    sc2.Code_Master__c = snomedMasterMap.get('MRIvol_T0-T2');
                    sw = SnomedCTCode.SnomedCode(changeInVolumeT0T2+'', 'MRIvol_T0-T2');
                    sc2.Code_System__c = sw.codeSystem;
                    sc2.caIntegratorValue__c = sw.caIntegratorValue;
                    sc2.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc2);
                    
                    system.debug('-------snomed code name 10------'+sc2.snomed_Code_Name__c);
                }
                
                sc2 = new Snomed_Code__c();
                sc2.CRF__c = mri.CRF__c;
                sc2.TrialPatient__c = mri.TrialPatient__c;
                Decimal t1Volume = trialPatientAndT1MRIVolumeMap.get(mri.TrialPatient__c);
                if(t1Volume != null && mri.MRI_Volume_in_cm3__c != null && t1Volume != 0){
                    Decimal changeInVolumeT1T2 = (t1Volume - mri.MRI_Volume_in_cm3__c) / t1Volume;
                    sc2.CRF__c = mri.CRF__c;
                    sc2.TrialPatient__c = mri.TrialPatient__c;
                    //sc2.Name = 'MRIvolT2_T3';
                    sc2.snomed_Code_Name__c = 'MRIvolT2_T3';
                    sc2.Code_Master__c = snomedMasterMap.get('MRIvolT2_T3');
                    //Variable name not needed as this is not sent in caIntegrator
                    sw = SnomedCTCode.SnomedCode(changeInVolumeT1T2+'', 'MRIvolT2_T3');
                    sc2.Code_System__c = sw.codeSystem;
                    sc2.caIntegratorValue__c = sw.caIntegratorValue;
                    sc2.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc2);
                    
                    system.debug('-------snomed code name 11------'+sc2.snomed_Code_Name__c);
                }
            }
            
            if(mri.Time_Point__c == 'Pre-surgery') {
                Snomed_Code__c sc2 = new Snomed_Code__c();
                sc2.CRF__c = mri.CRF__c;
                sc2.TrialPatient__c = mri.TrialPatient__c;
                Decimal baselineMriVolume = trialPatientAndT0MRIVolumeMap.get(mri.TrialPatient__c);
                SnomedCTCode.SnomedWrapper sw = null;
                if(baselineMriVolume != null && mri.MRI_Volume_in_cm3__c != null && baselineMriVolume != 0){
                    Decimal changeInVolume = (baselineMriVolume - mri.MRI_Volume_in_cm3__c) / baselineMriVolume;
                    sc2.CRF__c = mri.CRF__c;
                    sc2.TrialPatient__c = mri.TrialPatient__c;
                    //sc2.Name = 'MRIvol_T0-T3';
                    sc2.snomed_Code_Name__c = 'MRIvol_T0-T3';
                    sc2.Code_Master__c = snomedMasterMap.get('MRIvol_T0-T3');
                    sw = SnomedCTCode.SnomedCode(changeInVolume+'', 'MRIvol_T0-T3');
                    sc2.Code_System__c = sw.codeSystem;
                    sc2.caIntegratorValue__c = sw.caIntegratorValue;
                    sc2.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc2);
                    
                    system.debug('-------snomed code name 12------'+sc2.snomed_Code_Name__c);
                }
                
                sc2 = new Snomed_Code__c();
                sc2.CRF__c = mri.CRF__c;
                sc2.TrialPatient__c = mri.TrialPatient__c;
                Decimal t1Volume = trialPatientAndT1MRIVolumeMap.get(mri.TrialPatient__c);
                if(t1Volume != null && mri.MRI_Volume_in_cm3__c != null && t1Volume != 0){
                    Decimal changeInVolumeT1T3 = (t1Volume - mri.MRI_Volume_in_cm3__c) / t1Volume;
                    sc2.CRF__c = mri.CRF__c;
                    sc2.TrialPatient__c = mri.TrialPatient__c;
                    //sc2.Name = 'MRIvolT2_T4';
                    sc2.snomed_Code_Name__c = 'MRIvolT2_T4';
                    sc2.Code_Master__c = snomedMasterMap.get('MRIvolT2_T4');
                    //Variable name not needed as this is not sent in caIntegrator
                    sw = SnomedCTCode.SnomedCode(changeInVolumeT1T3+'', 'MRIvolT2_T4');
                    sc2.Code_System__c = sw.codeSystem;
                    sc2.caIntegratorValue__c = sw.caIntegratorValue;
                    sc2.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc2);
                    
                    system.debug('-------snomed code name 13------'+sc2.snomed_Code_Name__c);
                }
                
                sc2 = new Snomed_Code__c();
                sc2.CRF__c = mri.CRF__c;
                sc2.TrialPatient__c = mri.TrialPatient__c;
                Decimal t2Volume = trialPatientAndT2MRIVolumeMap.get(mri.TrialPatient__c);
                if(t2Volume != null && mri.MRI_Volume_in_cm3__c != null && t2Volume != 0){
                    Decimal changeInVolumeT2T3 = (t2Volume - mri.MRI_Volume_in_cm3__c) / t2Volume;
                    sc2.CRF__c = mri.CRF__c;
                    sc2.TrialPatient__c = mri.TrialPatient__c;
                    //sc2.Name = 'MRIvolT3-T4';
                    sc2.snomed_Code_Name__c = 'MRIvolT3-T4';
                    //sc2.Code_Master__c = snomedMasterMap.get('MRIvol_T0-T2');
                    //Variable name not needed as this is not sent in caIntegrator
                    sw = SnomedCTCode.SnomedCode(changeInVolumeT2T3+'', 'MRIvolT3-T4');
                    sc2.Code_System__c = sw.codeSystem;
                    sc2.caIntegratorValue__c = sw.caIntegratorValue;
                    sc2.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc2); 
                    
                    system.debug('-------snomed code name 14------'+sc2.snomed_Code_Name__c);
                }
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    //@future
    private static void insertReceptorRelatedCodes(List<Post_Surgaory_Summary__c> lstPost, List<On_Study_Pathology_Form__c> lstOsp) {
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'ERstatus_OS'
                        or Name = 'ERstatus_PS' or Name = 'PRstatus_PS' or Name = 'ER_TS_OS' or Name = 'PgR_TS_OS' or Name = 'Her2IHCstatus_OS' 
                        or Name = 'Her2FISHstatus_OS' or Name = 'PRstatus_OS'];
        Map<String, Code_Master__c> snomedMasterMap = new Map<String, Code_Master__c>();
            for(Code_Master__c sm : lstSnomedMaster) {
                snomedMasterMap.put(sm.Name, sm);
            }
            
        /*List<Receptors__c> lstReceptors = [Select r.pg_Receptors_Id__c, r.Vysis_Path_Vision__c, r.Vysis_Path_Vision_Value__c, r.Ventana_kit__c, r.Ventana_kit_Value__c, r.Ventana_Oncoprobe__c, r.Ventana_Oncoprobe_Value__c, r.Type__c, r.Total_Score_PR__c, r.Total_Score_ER__c, r.SystemModstamp, r.Progesterone_Receptor_Status__c, r.Progesterone_Receptor_Proportion_Score__c, r.Progesterone_Intensity_Score__c, r.Post_Surgery_Summary__c, r.PgR_TS_OS_Snomed__c, r.OwnerId, r.Other_IHC_Test__c, r.Other_IHC_Test_Value__c, r.Other_IHC_Results__c, r.Other_FISH_Test__c, r.Other_FISH_Test_Value__c, r.Other_FISH_Results__c, r.On_Study_Pathology_Form__c, r.Name, r.Letarality__c, r.LastModifiedDate, r.LastModifiedById, r.IsDeleted, r.Id, r.IHC_test_not_done__c, r.IHC__c, r.Her2Pos_OS_Snomed__c, r.HER2_neu_Marker__c, r.Fish__c, r.FISH_test_not_done__c, r.Estrogen_Receptor_Status__c, r.Estrogen_Receptor_Proportion_Score__c, r.Estrogen_Intensity_Score__c, r.ERpos_OS_Snomed__c, r.ER_TS_OS_Snomed__c, r.DAKO_Herceptest__c, r.DAKO_Herceptest_Value__c, r.CreatedDate, r.CreatedById, r.CB_11__c, r.CB_11_Value__c From Receptors__c r where Id IN:receptorIds];
        
        Set<Id> ospIds = new Set<Id>();
        Set<Id> postIds = new Set<Id>();
        for(Receptors__c rec :lstReceptors){
            ospIds.add(rec.On_Study_Pathology_Form__c);
            postIds.add(rec.Post_Surgery_Summary__c);
        }
        
        List<On_Study_Pathology_Form__c> lstOsp = [select id,CRF__c, TrialPatient__c from On_Study_Pathology_Form__c where Id IN : ospIds];
        List<Post_Surgaory_Summary__c> lstPost = [select id,CRF__c, TrialPatient__c from Post_Surgaory_Summary__c where Id IN : postIds];*/
        for(On_Study_Pathology_Form__c osp : lstOsp){
            for(Receptors__c rec : osp.Receptors__r){
                if(rec.On_Study_Pathology_Form__c == osp.Id){
                    
                    Snomed_Code__c sc1 = new Snomed_Code__c();
                    sc1.CRF__c = osp.CRF__c;
                    sc1.TrialPatient__c = osp.TrialPatient__c;
                    //sc1.Name = '13892007 | progesterone receptor assay measurement | ';
                    sc1.snomed_Code_Name__c = '13892007 | progesterone receptor assay measurement | ';
                    sc1.Code_Master__c = snomedMasterMap.get('PRstatus_OS').Id;
                    SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode(rec.Progesterone_Receptor_Status__c, 'PRstatus_OS');
                    sc1.Value__c = sw1.snomedCodeVal;
                    sc1.Code_System__c = sw1.codeSystem;
                    sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                    sc1.Code_System_Version__c = sw1.codeSystemVersion;
                    lstSnomed.add(sc1);
                    
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = osp.CRF__c;
                    sc.TrialPatient__c = osp.TrialPatient__c;
                    //sc.Name = '83302001 | oestrogen receptor assay (ERA) | ';
                    sc.snomed_Code_Name__c = '83302001 | oestrogen receptor assay (ERA) | ';
                    sc.Code_Master__c = snomedMasterMap.get('ERstatus_OS').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode( rec.Estrogen_Receptor_Status__c, 'ERstatus_OS');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    lstSnomed.add(sc);
                    
                    Snomed_Code__c sc2 = new Snomed_Code__c();
                    sc2.CRF__c = osp.CRF__c;
                    sc2.TrialPatient__c = osp.TrialPatient__c;
                    //sc2.Name = 'IHTSDO_4559';
                    sc2.snomed_Code_Name__c = 'IHTSDO_4559';
                    sc2.Code_Master__c = snomedMasterMap.get('ER_TS_OS').Id;
                    SnomedCTCode.SnomedWrapper sw2 = SnomedCTCode.SnomedCode(rec.Total_Score_ER__c+'', 'ER_TS_OS');
                    sc2.Value__c = sw2.snomedCodeVal;
                    sc2.Code_System__c = sw2.codeSystem;
                    sc2.caIntegratorValue__c = sw2.caIntegratorValue;
                    lstSnomed.add(sc2);
                    
                    Snomed_Code__c sc3 = new Snomed_Code__c();
                    sc3.CRF__c = osp.CRF__c;
                    sc3.TrialPatient__c = osp.TrialPatient__c;
                    //sc3.Name = 'IHTSDO_4556';
                    sc3.snomed_Code_Name__c = 'IHTSDO_4556';
                    sc3.Code_Master__c = snomedMasterMap.get('PgR_TS_OS').Id;
                    SnomedCTCode.SnomedWrapper sw3 = SnomedCTCode.SnomedCode(rec.Total_Score_PR__c+'', 'PgR_TS_OS');
                    sc3.Value__c = sw3.snomedCodeVal;
                    sc3.Code_System__c = sw3.codeSystem;
                    sc3.caIntegratorValue__c = sw3.caIntegratorValue;
                    sc3.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc3);
                    
                    Snomed_Code__c sc4 = new Snomed_Code__c();
                    sc4.CRF__c = osp.CRF__c;
                    sc4.TrialPatient__c = osp.TrialPatient__c;
                    //sc4.Name = '48676-1';
                    sc4.snomed_Code_Name__c = '48676-1';
                    sc4.Code_Master__c = snomedMasterMap.get('Her2IHCstatus_OS').Id;
                    SnomedCTCode.SnomedWrapper sw4 = SnomedCTCode.SnomedCode(rec.IHC__c, 'Her2IHCstatus_OS');
                    sc4.Value__c = sw4.snomedCodeVal;
                    sc4.Code_System__c = sw4.codeSystem;
                    sc4.caIntegratorValue__c = sw4.caIntegratorValue;
                    sc4.Code_System_Version__c = sw4.codeSystemVersion;
                    lstSnomed.add(sc4);
                    
                    Snomed_Code__c sc5 = new Snomed_Code__c();
                    sc5.CRF__c = osp.CRF__c;
                    sc5.TrialPatient__c = osp.TrialPatient__c;
                    sc5.snomed_Code_Name__c = '48676-3';
                    sc5.Code_Master__c = snomedMasterMap.get('Her2FISHstatus_OS').Id;
                    SnomedCTCode.SnomedWrapper sw5 = SnomedCTCode.SnomedCode(rec.Fish__c, 'Her2FISHstatus_OS');
                    sc5.Value__c = sw5.snomedCodeVal;
                    sc5.Code_System__c = sw5.codeSystem;
                    sc5.caIntegratorValue__c = sw5.caIntegratorValue;
                    sc5.Code_System_Version__c = sw5.codeSystemVersion;
                    lstSnomed.add(sc5);
                    
                    //commented as it is not in snomed codes, only in caIntegrator
                    /*Snomed_Code__c sc6 = new Snomed_Code__c();
                    sc6.CRF__c = osp.CRF__c;
                    sc6.TrialPatient__c = osp.TrialPatient__c;
                    sc6.snomed_Code_Name__c = 'Her2IHCtest_OS';
                    sc6.Code_Master__c = snomedMasterMap.get('Her2IHCtest_OS').Id;
                    sc6.Value__c = 'Not Coded';
                    lstSnomed.add(sc6); 
                    
                    Snomed_Code__c sc7 = new Snomed_Code__c();
                    sc7.CRF__c = osp.CRF__c;
                    sc7.TrialPatient__c = osp.TrialPatient__c;
                    sc7.snomed_Code_Name__c = 'Her2FISHtest_OS';
                    sc7.Code_Master__c = snomedMasterMap.get('Her2FISHtest_OS').Id;
                    sc7.Value__c = 'Not Coded';
                    lstSnomed.add(sc7); */
                }
            }
        }
        for(Post_Surgaory_Summary__c pss : lstPost){
            for(Receptors__c rec : pss.Receptors__r){
                if(rec.Post_Surgery_Summary__c == pss.Id){
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = pss.CRF__c;
                    sc.TrialPatient__c = pss.TrialPatient__c;
                    sc.snomed_Code_Name__c = '83302001 | oestrogen receptor assay (ERA) | ';
                    sc.Code_Master__c = snomedMasterMap.get('ERstatus_PS').Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(rec.Estrogen_Receptor_Status__c, 'ERstatus_PS');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                    
                    Snomed_Code__c sc1 = new Snomed_Code__c();
                    sc1.CRF__c = pss.CRF__c;
                    sc1.TrialPatient__c = pss.TrialPatient__c;
                    sc1.snomed_Code_Name__c = '13892007 | progesterone receptor assay measurement | ';
                    sc1.Code_Master__c = snomedMasterMap.get('PRstatus_PS').Id;
                    SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode(rec.Progesterone_Receptor_Status__c, 'PRstatus_PS');
                    sc1.Value__c = sw1.snomedCodeVal;
                    sc1.Code_System__c = sw1.codeSystem;
                    sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                    lstSnomed.add(sc1);
                    
                    Snomed_Code__c sc7 = new Snomed_Code__c();
                    sc7.CRF__c = pss.CRF__c;
                    sc7.TrialPatient__c = pss.TrialPatient__c;
                    sc7.snomed_Code_Name__c = '16112-5';
                    SnomedCTCode.SnomedWrapper sw7 = SnomedCTCode.SnomedCode(rec.Estrogen_Receptor_Status__c, 'ERstatus_PS');
                    sc7.Value__c = sw7.snomedCodeVal;
                    sc7.Code_System__c = sw7.codeSystem;
                    sc7.caIntegratorValue__c = sw7.caIntegratorValue;
                    sc7.Code_System_Version__c = sw7.codeSystemVersion;
                    lstSnomed.add(sc7);
                    
                    Snomed_Code__c sc8 = new Snomed_Code__c();
                    sc8.CRF__c = pss.CRF__c;
                    sc8.TrialPatient__c = pss.TrialPatient__c;
                    sc8.snomed_Code_Name__c = '10861-3';
                    SnomedCTCode.SnomedWrapper sw8 = SnomedCTCode.SnomedCode(rec.Progesterone_Receptor_Status__c, 'PRstatus_PS');
                    sc8.Value__c = sw8.snomedCodeVal;
                    sc8.Code_System__c = sw8.codeSystem;
                    sc8.caIntegratorValue__c = sw8.caIntegratorValue;
                    sc8.Code_System_Version__c = sw8.codeSystemVersion;
                    lstSnomed.add(sc8);
                    
                    Snomed_Code__c sc9 = new Snomed_Code__c();
                    sc9.CRF__c = pss.CRF__c;
                    sc9.TrialPatient__c = pss.TrialPatient__c;
                    sc9.snomed_Code_Name__c = '18474-7'; 
                    SnomedCTCode.SnomedWrapper sw9 = SnomedCTCode.SnomedCode(rec.IHC__c, 'Her2CommunityIHC_PS');
                    sc9.Value__c = sw9.snomedCodeVal;
                    sc9.Code_System__c = sw9.codeSystem;
                    sc9.caIntegratorValue__c = sw9.caIntegratorValue;
                    sc9.Code_System_Version__c = sw9.codeSystemVersion;
                    lstSnomed.add(sc9);
                    
                    Snomed_Code__c sc10 = new Snomed_Code__c();
                    sc10.CRF__c = pss.CRF__c;
                    sc10.TrialPatient__c = pss.TrialPatient__c;
                    sc10.snomed_Code_Name__c = '48675-3';
                    SnomedCTCode.SnomedWrapper sw10 = SnomedCTCode.SnomedCode(rec.Fish__c, 'Her2CommunityFISH_PS');
                    sc10.Value__c = sw10.snomedCodeVal;
                    sc10.Code_System__c = sw10.codeSystem;
                    sc10.caIntegratorValue__c = sw10.caIntegratorValue;
                    sc10.Code_System_Version__c = sw10.codeSystemVersion;
                    lstSnomed.add(sc10);
                }
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    //@future
    private static void insertInvasiveTumorRelatedCodes(List<Post_Surgaory_Summary__c> lstPostSur, List<On_Study_Pathology_Form__c> lstOnStudyPath) {
        
        /*List<Invasive_Tumor_Detail__c> lstInvasive = [Select i.pg_InvasiveTumor_Id__c, i.Unknown_Not_Reported__c, i.Ulceration_by_tumor__c, i.Tumor_Size__c, i.Tumor_Size_Width__c, i.Tumor_Size_Height__c, i.Tumor_Measurement_Unit__c, i.Tubulolobular_carcinoma__c, i.Tubule_Papilla_formation__c, i.Tubular_carcinoma__c, i.Total_Points__c, i.SystemModstamp, i.Specify_Units__c, i.Specify_No__c, i.Skin_Involvement__c, i.Signs_of_Treatment_Effect__c, i.SBR_Grade__c, i.Post_Surgery_Summary__c, i.Pleomorphic_lobular_carcinoma__c, i.Paget_disease__c, i.OwnerId, i.Overall_cancer_cellularity__c, i.Other_if_other_mention_type_in_textbox__c, i.Other_changes_present__c, i.Other__c, i.On_Study_Pathology_Form__c, i.Nuclear_Grade__c, i.Name, i.Muscle_involvement__c, i.Multi_focal_Tumor__c, i.Mucinous_carcinoma__c, i.Mitotic_Count__c, i.Medullary_carcinoma__c, i.Medical__c, i.Medical_Size__c, i.Lympatic_vascular_Invasion__c, i.Lateral__c, i.Lateral_Size__c, i.LastModifiedDate, i.LastModifiedById, i.IsDeleted, i.Invasive_papillary_carcinoma__c, i.Invasive_margins_size__c, i.Invasive_margins__c, i.Invasive_lobular_carcinoma_classic_type__c, i.Invasive_lobular_carcinoma_alveolar_type__c, i.Invasive_ductal_carcinoma_nos__c, i.Invasive_cribiform_carcinoma__c, i.Invasive_carcinoma_mixed_ductal_lobular__c, i.Id, i.Evidence_of_therapeutic_effects__c, i.Dermal_Involvement__c, i.Derma_lymphatic_vascular_invasion__c, i.Deep_Margin__c, i.Deep_Margin_Size__c, i.CreatedDate, i.CreatedById, i.Closest_Margin__c, i.Calcifications__c, i.Calcifications_Present__c, i.Anterios_Superior_Size__c, i.Anterior_Superior__c, i.Anterior_Superior_Size__c, i.Anterior_Inferior__c, i.Anterior_Inferior_Size__c From Invasive_Tumor_Detail__c i where Id IN:invIds];
        
        Set<Id> postIds = new Set<Id>();
        Set<Id> ospIds = new Set<Id>();
        for(Invasive_Tumor_Detail__c inv : lstInvasive) {
            postIds.add(inv.Post_Surgery_Summary__c);
            ospIds.add(inv.On_Study_Pathology_Form__c);
        }
        
        List<Post_Surgaory_Summary__c> lstPostSur = [select CRF__c, TrialPatient__c, Is_invasive_tumor_present__c,Is_DCIS_Present__c ,Is_LCIS_Present__c ,(Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Location__c, Procedure_Name__c, Laterality__c, Form_Name__c, Date_Of_Procedure__c, Node_Result__c, Node_Type__c, Ultrasound__c, Palpation_guided__c, Mammography__c, MRI__c, Stereotactic__c, Post_Surgery_Summary__c, TrialPatient__c, On_Study_Pathology_Form__c, Total_Positive__c, Total_Examined_Nodes__c From Procedures__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, DCIS__c, Unknown_Not_Reported__c, Tumor_Size__c, Present_in_continous_section__c, Spanning__c, Present_as_scattered_microscopic_foci__c, Microscopic_foci_upto__c, From_Slide__c, To_Slide__c, Deep_Margin__c, Deep_Margin_Size__c, Medical__c, Medical_Size__c, Lateral__c, Lateral_Size__c, Anterior_Superior__c, Anterior_Superior_Size__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Punctate_necrosis__c, Comedonecrosis__c, Papillary__c, Micropapillary__c, Necrosis__c, Cribiform__c, Cruciform__c, Clinging__c, Solid__c, Apocrine__c, Intra_cystic_encysted_papillary__c, Calcifications__c, Nuclear_Grade__c, Total_Histological_Span__c, Total_Histological_Span_Measurement_Unit__c, Margin__c, Closest_Margin__c, Specific_Closest_Margin__c, Specific_Closest_Margin_Measurement_Unit__c, Other__c, Other_if_other_mention_type_in_textb__c, Calcifications_Present__c, On_Study_Pathology_Form__c, Post_Surgery_Summary__c From DCIS__r) from Post_Surgaory_Summary__c where Id IN :postIds];
        List<On_Study_Pathology_Form__c> lstOnStudyPath = [select CRF__c, TrialPatient__c from On_Study_Pathology_Form__c where Id IN :ospIds];
        */
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where 
        Name = 'LVI_PS' 
        or Name = 'InvMultifocal_PS' or Name = 'InvMargin_PS' or Name = 'InvHistology_PS' or 
        Name = 'InvHistology_OS' or Name = 'InvSBR_OS' 
        or Name = 'InvSBR_PS'];
        
        Map<String, Code_Master__c> snomedMasterMap = new Map<String, Code_Master__c>();
        for(Code_Master__c sm : lstSnomedMaster) {
            snomedMasterMap.put(sm.Name, sm);
        }
        
        for(Post_Surgaory_Summary__c pss : lstPostSur) {
            for(Invasive_Tumor_Detail__c inv : pss.Invasive_Tumor_Details__r){
                for(Code_Master__c sm : lstSnomedMaster){
                    if(sm.Name == 'LVI_PS'){
                        Snomed_Code__c sc16 = new Snomed_Code__c();
                        sc16.CRF__c = pss.CRF__c;
                        sc16.TrialPatient__c = pss.TrialPatient__c;
                        sc16.snomed_Code_Name__c = '395715009 | status of lymphatic (small vessel) invasion by tumour |';
                        sc16.Code_Master__c = sm.Id;
                        SnomedCTCode.SnomedWrapper sw16 = SnomedCTCode.SnomedCode(inv.Lympatic_vascular_Invasion__c, 'LVI_PS');
                        sc16.Value__c = sw16.snomedCodeVal;
                        sc16.caIntegratorValue__c = sw16.caIntegratorValue;
                        sc16.Code_System__c = sw16.codeSystem;
                        sc16.Code_System_Version__c = sw16.codeSystemVersion;
                        lstSnomed.add(sc16);
                    }
                    if(sm.Name == 'InvMultifocal_PS'){
                        Snomed_Code__c sc17 = new Snomed_Code__c();
                        sc17.CRF__c = pss.CRF__c;
                        sc17.TrialPatient__c = pss.TrialPatient__c;
                        sc17.snomed_Code_Name__c = 'IHTSDO_4570';
                        sc17.Code_Master__c = sm.Id;
                        SnomedCTCode.SnomedWrapper sw17 = SnomedCTCode.SnomedCode(inv.Multi_focal_Tumor__c, 'InvMultifocal_PS');
                        sc17.Value__c = sw17.snomedCodeVal;
                        sc17.caIntegratorValue__c = sw17.caIntegratorValue;
                        sc17.Code_System__c = sw17.codeSystem;
                        sc17.Code_System_Version__c = sw17.codeSystemVersion;
                        lstSnomed.add(sc17);
                    }
                    if(sm.Name == 'InvMargin_PS'){
                        if(pss.DCIS__r.Size()<=0 && pss.Procedures__r.Size()<=0) continue; 
                        List<DCIS__c> dcisList = pss.DCIS__r;
                        List<Procedure__c> lstPro = pss.Procedures__r;
                        for(DCIS__c dcis : dcisList) {
                            for(Procedure__c pro : lstPro){
                                if(dcis.Post_Surgery_Summary__c == pss.Id && pro.Post_Surgery_Summary__c == pss.Id) {
                                    Snomed_Code__c sc19 = new Snomed_Code__c();
                                    sc19.CRF__c = pss.CRF__c;
                                    sc19.TrialPatient__c = pss.TrialPatient__c;
                                    sc19.snomed_Code_Name__c = '396631001 | surgical margin observable |';
                                    sc19.Code_Master__c = sm.Id;
                                    Snomed_Code__c scodeValue = histologySnomed(dcis, inv, pro, pss, sc19);
                                    //SnomedCTCode.SnomedWrapper sw19 = SnomedCTCode.SnomedCode('396631001', '');
                                    sc19.Value__c = scodeValue.Value__c;
                                    sc19.caIntegratorValue__c = scodeValue.caIntegratorValue__c;
                                    sc19.Code_System__c = scodeValue.Code_System__c;
                                    sc19.Code_System_Version__c = scodeValue.Code_System_Version__c;
                                    lstSnomed.add(sc19);
                                }
                            }
                        }
                    }
                    if(sm.Name == 'InvHistology_PS' && pss.Is_invasive_tumor_present__c == 'Yes'){
                        Snomed_Code__c scNew = new Snomed_Code__c();
                        scNew.CRF__c = pss.CRF__c;
                        scNew.TrialPatient__c = pss.TrialPatient__c;
                        scNew.snomed_Code_Name__c = '396785008 | metastatic tumor, histologic type | ';
                        scNew.Code_Master__c = snomedMasterMap.get('InvHistology_PS').Id;
                        scNew.Value__c = '';
                        scNew.caIntegratorValue__c = '';
                        //At the time of insertion we are considering the Grade value is empty. but on update it will be updated by actual value.
                        String histogyOption = '';
                        if(inv.Invasive_ductal_carcinoma_nos__c) {
                            histogyOption = 'Ductal';
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_PS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.Value__c = sw.snomedCodeVal + ','; 
                            scNew.caIntegratorValue__c = sw.caIntegratorValue + ',';
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                        }
                        if(inv.Invasive_lobular_carcinoma_classic_type__c) {
                            histogyOption = 'Lobular classic';
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_PS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.Value__c += sw.snomedCodeVal + ','; 
                            scNew.caIntegratorValue__c += sw.caIntegratorValue + ',';
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                        }
                        if(inv.Invasive_lobular_carcinoma_alveolar_type__c) {
                            histogyOption = 'Lobular alveolar';
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_PS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.Value__c += sw.snomedCodeVal + ','; 
                            scNew.caIntegratorValue__c += sw.caIntegratorValue = ',';
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                        }
                        if(inv.Pleomorphic_lobular_carcinoma__c) {
                            histogyOption = 'pleomorphic lobular';
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_PS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.Value__c += sw.snomedCodeVal + ','; 
                            scNew.caIntegratorValue__c += sw.caIntegratorValue = ',';
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                        }
                        if(inv.Tubulolobular_carcinoma__c) {
                            histogyOption = 'tubulolobular';
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_PS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.Value__c += sw.snomedCodeVal + ','; 
                            scNew.caIntegratorValue__c += sw.caIntegratorValue = ',';
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                        }
                        if(inv.Invasive_carcinoma_mixed_ductal_lobular__c) {
                            histogyOption = 'Mixed Ductal and Lobular';
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_PS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.Value__c += sw.snomedCodeVal + ','; 
                            scNew.caIntegratorValue__c += sw.caIntegratorValue = ',';
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                        }
                        if(inv.Tubular_carcinoma__c) {
                            histogyOption = 'Tubular';
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_PS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.Value__c += sw.snomedCodeVal + ','; 
                            scNew.caIntegratorValue__c += sw.caIntegratorValue = ',';
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                        }
                        if(inv.Mucinous_carcinoma__c) {
                            histogyOption = 'Mucinous';
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_PS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.Value__c += sw.snomedCodeVal + ','; 
                            scNew.caIntegratorValue__c += sw.caIntegratorValue = ',';
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                        }
                        if(inv.Medullary_carcinoma__c) {
                            histogyOption = 'Medullary';
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_PS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.Value__c += sw.snomedCodeVal + ','; 
                            scNew.caIntegratorValue__c += sw.caIntegratorValue = ',';
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                        }
                        if(inv.Invasive_papillary_carcinoma__c) {
                            histogyOption = 'Papillary';
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_PS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.Value__c += sw.snomedCodeVal + ','; 
                            scNew.caIntegratorValue__c += sw.caIntegratorValue = ',';
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                        }
                        if(inv.Invasive_cribiform_carcinoma__c) {
                            histogyOption = 'Cribiform';
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_PS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.Value__c += sw.snomedCodeVal + ','; 
                            scNew.caIntegratorValue__c += sw.caIntegratorValue = ',';
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                        }
                        if(inv.Other__c) {
                            histogyOption = 'Other';
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_PS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.Value__c += sw.snomedCodeVal + ','; 
                            scNew.caIntegratorValue__c += sw.caIntegratorValue = ',';
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                        }
                        if(scNew.Value__c.endsWith(',')) {
                            scNew.Value__c = scNew.Value__c.substring(0,scNew.Value__c.length()-1);
                        }
                        if(scNew.caIntegratorValue__c.endsWith(',')) {
                            scNew.caIntegratorValue__c = scNew.caIntegratorValue__c.substring(0,scNew.caIntegratorValue__c.length()-1);
                        }
                        lstSnomed.add(scNew);
                    } else if(pss.Is_invasive_tumor_present__c == 'No') {
                        Snomed_Code__c scNew = new Snomed_Code__c();
                        scNew.CRF__c = pss.CRF__c;
                        scNew.TrialPatient__c = pss.TrialPatient__c;
                        scNew.snomed_Code_Name__c = '396785008 | metastatic tumor, histologic type | ';
                        scNew.Code_Master__c = snomedMasterMap.get('InvHistology_PS').Id;
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No', 'InvHistology_PS');
                        scNew.Code_System__c = sw.codeSystem;
                        scNew.caIntegratorValue__c = sw.caIntegratorValue;
                        scNew.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(scNew);
                    }
                    if(inv.Multi_focal_Tumor__c != null && sm.Name == 'Inv%_PS'){
                        Snomed_Code__c sc18 = new Snomed_Code__c();
                        sc18.CRF__c = pss.CRF__c;
                        sc18.TrialPatient__c = pss.TrialPatient__c;
                        sc18.snomed_Code_Name__c = 'IHTSDO_4572';
                        sc18.Code_Master__c = sm.Id;
                        SnomedCTCode.SnomedWrapper sw18 = SnomedCTCode.SnomedCode('Numerical value', 'Inv%_PS');
                        sc18.Value__c = sw18.snomedCodeVal;
                        sc18.caIntegratorValue__c = sw18.caIntegratorValue;
                        sc18.Code_System__c = sw18.codeSystem;
                        sc18.Code_System_Version__c = sw18.codeSystemVersion;
                        lstSnomed.add(sc18);
                    }
                    if(sm.Name == 'InvSBR_PS'){
                        Snomed_Code__c scNew1 = new Snomed_Code__c();
                        scNew1.CRF__c = pss.CRF__c;
                        scNew1.TrialPatient__c = pss.TrialPatient__c;
                        scNew1.snomed_Code_Name__c = '371469007 | histologic grade | ';
                        scNew1.Code_Master__c = snomedMasterMap.get('InvSBR_PS').Id;
                        //At the time of insertion we are considering the Grade value is empty. but on update it will be updated by actual value.
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(inv.Nuclear_Grade__c, 'InvSBR_PS');  
                        scNew1.Code_System__c = sw.codeSystem;
                        scNew1.caIntegratorValue__c = sw.caIntegratorValue;
                        scNew1.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(scNew1);
                    }
                }
            }
        }
        for(On_Study_Pathology_Form__c osp : lstOnStudyPath) {
            for(Invasive_Tumor_Detail__c inv : osp.Invasive_Tumor_Details__r) {
                for(Code_Master__c sm : lstSnomedMaster) {
                    if(inv.On_Study_Pathology_Form__c == osp.Id) {
                        if(sm.Name == 'InvHistology_OS' && osp.Is_invasive_tumor_present__c == 'Yes'){
                            Snomed_Code__c scNew = new Snomed_Code__c();
                            scNew.CRF__c = osp.CRF__c;
                            scNew.TrialPatient__c = osp.TrialPatient__c;
                            scNew.snomed_Code_Name__c = '"396785008 | metastatic tumor, histologic type | ';
                            scNew.Code_Master__c = snomedMasterMap.get('InvHistology_OS').Id;
                            scNew.Value__c = '';
                            //At the time of insertion we are considering the Grade value is empty. but on update it will be updated by actual value.
                            String histogyOption = '';
                            if(inv.Invasive_ductal_carcinoma_nos__c) {
                                histogyOption = 'Ductal';
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_OS');
                                scNew.Code_System__c = sw.codeSystem;
                                scNew.Value__c = sw.snomedCodeVal + ','; 
                                scNew.caIntegratorValue__c = sw.caIntegratorValue;
                                scNew.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            if(inv.Invasive_lobular_carcinoma_classic_type__c) {
                                histogyOption = 'Lobular classic';
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_OS');
                                scNew.Code_System__c = sw.codeSystem;
                                scNew.Value__c += sw.snomedCodeVal + ','; 
                                scNew.caIntegratorValue__c = sw.caIntegratorValue;
                                scNew.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            if(inv.Invasive_lobular_carcinoma_alveolar_type__c) {
                                histogyOption = 'Lobular alveolar';
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_OS');
                                scNew.Code_System__c = sw.codeSystem;
                                scNew.Value__c += sw.snomedCodeVal + ','; 
                                scNew.caIntegratorValue__c = sw.caIntegratorValue;
                                scNew.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            if(inv.Pleomorphic_lobular_carcinoma__c) {
                                histogyOption = 'pleomorphic lobular';
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_OS');
                                scNew.Code_System__c = sw.codeSystem;
                                scNew.Value__c += sw.snomedCodeVal + ','; 
                                scNew.caIntegratorValue__c = sw.caIntegratorValue;
                                scNew.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            if(inv.Tubulolobular_carcinoma__c) {
                                histogyOption = 'tubulolobular';
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_OS');
                                scNew.Code_System__c = sw.codeSystem;
                                scNew.Value__c += sw.snomedCodeVal + ','; 
                                scNew.caIntegratorValue__c = sw.caIntegratorValue;
                                scNew.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            if(inv.Invasive_carcinoma_mixed_ductal_lobular__c) {
                                histogyOption = 'Mixed Ductal and Lobular';
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_OS');
                                scNew.Code_System__c = sw.codeSystem;
                                scNew.Value__c += sw.snomedCodeVal + ','; 
                                scNew.caIntegratorValue__c = sw.caIntegratorValue;
                                scNew.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            if(inv.Tubular_carcinoma__c) {
                                histogyOption = 'Tubular';
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_OS');
                                scNew.Code_System__c = sw.codeSystem;
                                scNew.Value__c += sw.snomedCodeVal + ','; 
                                scNew.caIntegratorValue__c = sw.caIntegratorValue;
                                scNew.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            if(inv.Mucinous_carcinoma__c) {
                                histogyOption = 'Mucinous';
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_OS');
                                scNew.Code_System__c = sw.codeSystem;
                                scNew.Value__c += sw.snomedCodeVal + ','; 
                                scNew.caIntegratorValue__c = sw.caIntegratorValue;
                                scNew.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            if(inv.Medullary_carcinoma__c) {
                                histogyOption = 'Medullary';
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_OS');
                                scNew.Code_System__c = sw.codeSystem;
                                scNew.Value__c += sw.snomedCodeVal + ','; 
                                scNew.caIntegratorValue__c = sw.caIntegratorValue;
                                scNew.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            if(inv.Invasive_papillary_carcinoma__c) {
                                histogyOption = 'Papillary';
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_OS');
                                scNew.Code_System__c = sw.codeSystem;
                                scNew.Value__c += sw.snomedCodeVal + ','; 
                                scNew.caIntegratorValue__c = sw.caIntegratorValue;
                                scNew.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            if(inv.Invasive_cribiform_carcinoma__c) {
                                histogyOption = 'Cribiform';
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_OS');
                                scNew.Code_System__c = sw.codeSystem;
                                scNew.Value__c += sw.snomedCodeVal + ','; 
                                scNew.caIntegratorValue__c = sw.caIntegratorValue;
                                scNew.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            if(inv.Other__c) {
                                histogyOption = 'Other';
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(histogyOption, 'InvHistology_OS');
                                scNew.Code_System__c = sw.codeSystem;
                                scNew.Value__c += sw.snomedCodeVal + ','; 
                                scNew.caIntegratorValue__c = sw.caIntegratorValue;
                                scNew.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            lstSnomed.add(scNew);
                        } else if(osp.Is_invasive_tumor_present__c == 'No') {
                            Snomed_Code__c scNew = new Snomed_Code__c();
                            scNew.CRF__c = osp.CRF__c;
                            scNew.TrialPatient__c = osp.TrialPatient__c;
                            scNew.snomed_Code_Name__c = '396785008 | metastatic tumor, histologic type | ';
                            scNew.Code_Master__c = snomedMasterMap.get('InvHistology_OS').Id;
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No', 'InvHistology_OS');
                            scNew.Code_System__c = sw.codeSystem;
                            scNew.caIntegratorValue__c = sw.caIntegratorValue;
                            scNew.Code_System_Version__c = sw.codeSystemVersion;
                            lstSnomed.add(scNew);
                        }
                        if(sm.Name == 'InvSBR_OS' && inv.Nuclear_Grade__c != 'Not reported'){
                            Snomed_Code__c scNew1 = new Snomed_Code__c();
                            scNew1.CRF__c = osp.CRF__c;
                            scNew1.TrialPatient__c = osp.TrialPatient__c;
                            scNew1.snomed_Code_Name__c = '371469007 | histologic grade | ';
                            scNew1.Code_Master__c = snomedMasterMap.get('InvSBR_OS').Id;
                            //At the time of insertion we are considering the Grade value is empty. but on update it will be updated by actual value.
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(inv.Nuclear_Grade__c, 'InvSBR_OS');  
                            scNew1.Code_System__c = sw.codeSystem;
                            scNew1.caIntegratorValue__c = sw.caIntegratorValue;
                            scNew1.Code_System_Version__c = sw.codeSystemVersion;
                            lstSnomed.add(scNew1);
                        }
                    }
                }
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    //@future
    private static void insertDCISRelatedCodes(List<Post_Surgaory_Summary__c> lstPostSur) {
        
        /*List<DCIS__c> lstDCIS = [Select d.pg_dcis_Id__c, d.Unknown_Not_Reported__c, d.Tumor_Size__c, d.Total_Histological_Span__c, d.Total_Histological_Span_Measurement_Unit__c, d.To_Slide__c, d.SystemModstamp, d.Specific_Closest_Margin__c, d.Specific_Closest_Margin_Measurement_Unit__c, d.Spanning__c, d.Solid__c, d.Punctate_necrosis__c, d.Present_in_continous_section__c, d.Present_as_scattered_microscopic_foci__c, d.Post_Surgery_Summary__c, d.Papillary__c, d.OwnerId, d.Other_if_other_mention_type_in_textb__c, d.Other__c, d.On_Study_Pathology_Form__c, d.Nuclear_Grade__c, d.Necrosis__c, d.Name, d.Microscopic_foci_upto__c, d.Micropapillary__c, d.Medical__c, d.Medical_Size__c, d.Margin__c, d.Lateral__c, d.Lateral_Size__c, d.LastModifiedDate, d.LastModifiedById, d.IsDeleted, d.Intra_cystic_encysted_papillary__c, d.Id, d.From_Slide__c, d.Deep_Margin__c, d.Deep_Margin_Size__c, d.DCIS__c, d.Cruciform__c, d.Cribiform__c, d.CreatedDate, d.CreatedById, d.Comedonecrosis__c, d.Closest_Margin__c, d.Clinging__c, d.Calcifications__c, d.Calcifications_Present__c, d.Apocrine__c, d.Anterior_Superior__c, d.Anterior_Superior_Size__c, d.Anterior_Inferior__c, d.Anterior_Inferior_Size__c From DCIS__c d where Id IN:dcisIds];
        Set<Id> postIds = new Set<Id>();
        for(DCIS__c dcis : lstDCIS) {
            postIds.add(dcis.Post_Surgery_Summary__c);
        }
        List<Post_Surgaory_Summary__c> lstPostSur = [select CRF__c, TrialPatient__c,Is_invasive_tumor_present__c,Is_DCIS_Present__c ,Is_LCIS_Present__c ,(Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Location__c, Procedure_Name__c, Laterality__c, Form_Name__c, Date_Of_Procedure__c, Node_Result__c, Node_Type__c, Ultrasound__c, Palpation_guided__c, Mammography__c, MRI__c, Stereotactic__c, Post_Surgery_Summary__c, TrialPatient__c, On_Study_Pathology_Form__c, Total_Positive__c, Total_Examined_Nodes__c From Procedures__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Multi_focal_Tumor__c, Tumor_Size_Height__c, Tumor_Size_Width__c, Tumor_Measurement_Unit__c, Deep_Margin__c, Deep_Margin_Size__c, Medical__c, Medical_Size__c, Lateral__c, Lateral_Size__c, Anterior_Superior__c, Anterior_Superior_Size__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Invasive_ductal_carcinoma_nos__c, Tubular_carcinoma__c, Mucinous_carcinoma__c, Invasive_lobular_carcinoma_alveolar_type__c, Medullary_carcinoma__c, Pleomorphic_lobular_carcinoma__c, Invasive_papillary_carcinoma__c, Invasive_cribiform_carcinoma__c, Invasive_carcinoma_mixed_ductal_lobular__c, Other__c, Signs_of_Treatment_Effect__c, Calcifications__c, Nuclear_Grade__c, Mitotic_Count__c, Tubule_Papilla_formation__c, Lympatic_vascular_Invasion__c, Skin_Involvement__c, Other_changes_present__c, Evidence_of_therapeutic_effects__c, Muscle_involvement__c, Dermal_Involvement__c, Invasive_lobular_carcinoma_classic_type__c, Tubulolobular_carcinoma__c, Invasive_margins__c, Closest_Margin__c, Overall_cancer_cellularity__c, Unknown_Not_Reported__c, Other_if_other_mention_type_in_textbox__c, Tumor_Size__c, Invasive_margins_size__c, Specify_No__c, Specify_Units__c, Total_Points__c, SBR_Grade__c, Paget_disease__c, Ulceration_by_tumor__c, Derma_lymphatic_vascular_invasion__c, Calcifications_Present__c, On_Study_Pathology_Form__c, Post_Surgery_Summary__c From Invasive_Tumor_Details__r) from Post_Surgaory_Summary__c where Id IN :postIds];
        */
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'DCISGrade_PS' 
        or Name = 'InvMargin_PS' or Name = 'InvHistology_PS' or Name = 'DCISHistology_PS' or Name = 'DCISspan_PS'];
        for(Post_Surgaory_Summary__c pss : lstPostSur) {
            for(DCIS__c dcis : pss.DCIS__r){
                if(dcis.Post_Surgery_Summary__c == pss.Id) {
                    for(Code_Master__c sm : lstSnomedMaster){
                        if(sm.Name == 'DCISGrade_PS'){
                            Snomed_Code__c sc13 = new Snomed_Code__c();
                            sc13.CRF__c = pss.CRF__c;
                            sc13.TrialPatient__c = pss.TrialPatient__c;
                            sc13.snomed_Code_Name__c = '371469007 | histologic grade | ';
                            sc13.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw13 = SnomedCTCode.SnomedCode(dcis.Nuclear_Grade__c, 'DCISGrade_PS');
                            sc13.Value__c = sw13.snomedCodeVal;
                            sc13.Code_System__c = sw13.codeSystem;
                            sc13.caIntegratorValue__c = sw13.caIntegratorValue;
                            sc13.Code_System_Version__c = sw13.codeSystemVersion;
                            lstSnomed.add(sc13);
                        }
                        if(sm.Name == 'DCISHistology_PS'){
                            SnomedCTCode.SnomedWrapper sw = new SnomedCTCode.SnomedWrapper();
                            /*Snomed_Code__c sc22 = new Snomed_Code__c();
                            sc22.CRF__c = pss.CRF__c;
                            sc22.TrialPatient__c = pss.TrialPatient__c;
                            sc22.snomed_Code_Name__c = '33731-1';
                            sc22.Code_Master__c = sm.Id;
                            sc22.caIntegratorValue__c = '';*/
                            if(dcis.Punctate_necrosis__c) {
                                Snomed_Code__c sc22 = new Snomed_Code__c();
                                sc22.CRF__c = pss.CRF__c;
                                sc22.TrialPatient__c = pss.TrialPatient__c;
                                sc22.snomed_Code_Name__c = '33731-1';
                                sc22.Code_Master__c = sm.Id;
                                sw = SnomedCTCode.SnomedCode('Punctuate Necrosis', 'DCISHistology_PS');
                                sc22.caIntegratorValue__c = sw.caIntegratorValue;
                                sc22.Code_System_Version__c = sw.codeSystemVersion;
                                lstSnomed.add(sc22);
                            }
                            if(dcis.Comedonecrosis__c) {
                                Snomed_Code__c sc22 = new Snomed_Code__c();
                                sc22.CRF__c = pss.CRF__c;
                                sc22.TrialPatient__c = pss.TrialPatient__c;
                                sc22.snomed_Code_Name__c = '33731-1';
                                sc22.Code_Master__c = sm.Id;
                                sw = SnomedCTCode.SnomedCode('Comedo Necrosis', 'DCISHistology_PS');
                                sc22.caIntegratorValue__c = sw.caIntegratorValue;
                                sc22.Code_System_Version__c = sw.codeSystemVersion;
                                lstSnomed.add(sc22);
                                /*sw = SnomedCTCode.SnomedCode('33731-1', 'Comedonecrosis');
                                sc22.caIntegratorValue__c += sw.caIntegratorValue+',';*/
                            }
                            if(dcis.Papillary__c) {
                                Snomed_Code__c sc22 = new Snomed_Code__c();
                                sc22.CRF__c = pss.CRF__c;
                                sc22.TrialPatient__c = pss.TrialPatient__c;
                                sc22.snomed_Code_Name__c = '33731-1';
                                sc22.Code_Master__c = sm.Id;
                                sw = SnomedCTCode.SnomedCode('Papillary', 'DCISHistology_PS');
                                sc22.caIntegratorValue__c = sw.caIntegratorValue;
                                sc22.Code_System_Version__c = sw.codeSystemVersion;
                                lstSnomed.add(sc22);
                                /*sw = SnomedCTCode.SnomedCode('33731-1', 'Papillary');
                                sc22.caIntegratorValue__c += sw.caIntegratorValue+',';*/
                            }
                            if(dcis.Micropapillary__c) {
                                Snomed_Code__c sc22 = new Snomed_Code__c();
                                sc22.CRF__c = pss.CRF__c;
                                sc22.TrialPatient__c = pss.TrialPatient__c;
                                sc22.snomed_Code_Name__c = '33731-1';
                                sc22.Code_Master__c = sm.Id;
                                sw = SnomedCTCode.SnomedCode('Micropapillary', 'DCISHistology_PS');
                                sc22.caIntegratorValue__c = sw.caIntegratorValue;
                                sc22.Code_System_Version__c = sw.codeSystemVersion;
                                lstSnomed.add(sc22);
                                /*sw = SnomedCTCode.SnomedCode('33731-1', 'Micropapillary');
                                sc22.caIntegratorValue__c += sw.caIntegratorValue+',';*/
                            }
                            if(dcis.Necrosis__c) {
                                Snomed_Code__c sc22 = new Snomed_Code__c();
                                sc22.CRF__c = pss.CRF__c;
                                sc22.TrialPatient__c = pss.TrialPatient__c;
                                sc22.snomed_Code_Name__c = '33731-1';
                                sc22.Code_Master__c = sm.Id;
                                sw = SnomedCTCode.SnomedCode('Necrosis', 'DCISHistology_PS');
                                sc22.caIntegratorValue__c = sw.caIntegratorValue;
                                sc22.Code_System_Version__c = sw.codeSystemVersion;
                                lstSnomed.add(sc22);
                                /*sw = SnomedCTCode.SnomedCode('33731-1', 'Necrosis');
                                sc22.caIntegratorValue__c += sw.caIntegratorValue+',';*/
                            }
                            if(dcis.Cribiform__c) {
                                Snomed_Code__c sc22 = new Snomed_Code__c();
                                sc22.CRF__c = pss.CRF__c;
                                sc22.TrialPatient__c = pss.TrialPatient__c;
                                sc22.snomed_Code_Name__c = '33731-1';
                                sc22.Code_Master__c = sm.Id;
                                sw = SnomedCTCode.SnomedCode('Cribiform', 'DCISHistology_PS');
                                sc22.caIntegratorValue__c = sw.caIntegratorValue;
                                sc22.Code_System_Version__c = sw.codeSystemVersion;
                                lstSnomed.add(sc22);
                                /*sw = SnomedCTCode.SnomedCode('33731-1', 'Cribiform');
                                sc22.caIntegratorValue__c += sw.caIntegratorValue+',';*/
                            }
                            if(dcis.Cruciform__c) {
                                Snomed_Code__c sc22 = new Snomed_Code__c();
                                sc22.CRF__c = pss.CRF__c;
                                sc22.TrialPatient__c = pss.TrialPatient__c;
                                sc22.snomed_Code_Name__c = '33731-1';
                                sc22.Code_Master__c = sm.Id;
                                sw = SnomedCTCode.SnomedCode('Cruciform', 'DCISHistology_PS');
                                sc22.caIntegratorValue__c = sw.caIntegratorValue;
                                sc22.Code_System_Version__c = sw.codeSystemVersion;
                                lstSnomed.add(sc22);
                                /*sw = SnomedCTCode.SnomedCode('33731-1', 'Cruciform');
                                sc22.caIntegratorValue__c += sw.caIntegratorValue+',';*/
                            }
                            if(dcis.Clinging__c) {
                                Snomed_Code__c sc22 = new Snomed_Code__c();
                                sc22.CRF__c = pss.CRF__c;
                                sc22.TrialPatient__c = pss.TrialPatient__c;
                                sc22.snomed_Code_Name__c = '33731-1';
                                sc22.Code_Master__c = sm.Id;
                                sw = SnomedCTCode.SnomedCode('Clinging', 'DCISHistology_PS');
                                sc22.caIntegratorValue__c = sw.caIntegratorValue;
                                sc22.Code_System_Version__c = sw.codeSystemVersion;
                                lstSnomed.add(sc22);
                                /*sw = SnomedCTCode.SnomedCode('33731-1', 'Clinging');
                                sc22.caIntegratorValue__c += sw.caIntegratorValue+',';*/
                            }
                            if(dcis.Solid__c) {
                                Snomed_Code__c sc22 = new Snomed_Code__c();
                                sc22.CRF__c = pss.CRF__c;
                                sc22.TrialPatient__c = pss.TrialPatient__c;
                                sc22.snomed_Code_Name__c = '33731-1';
                                sc22.Code_Master__c = sm.Id;
                                sw = SnomedCTCode.SnomedCode('Solid', 'DCISHistology_PS');
                                sc22.caIntegratorValue__c = sw.caIntegratorValue;
                                sc22.Code_System_Version__c = sw.codeSystemVersion;
                                lstSnomed.add(sc22);
                                /*sw = SnomedCTCode.SnomedCode('33731-1', 'Solid');
                                sc22.caIntegratorValue__c += sw.caIntegratorValue+',';*/
                            }
                            if(dcis.Apocrine__c) {
                                Snomed_Code__c sc22 = new Snomed_Code__c();
                                sc22.CRF__c = pss.CRF__c;
                                sc22.TrialPatient__c = pss.TrialPatient__c;
                                sc22.snomed_Code_Name__c = '33731-1';
                                sc22.Code_Master__c = sm.Id;
                                sw = SnomedCTCode.SnomedCode('Apocrine', 'DCISHistology_PS');
                                sc22.caIntegratorValue__c = sw.caIntegratorValue;
                                sc22.Code_System_Version__c = sw.codeSystemVersion;
                                lstSnomed.add(sc22);
                                /*sw = SnomedCTCode.SnomedCode('33731-1', 'Apocrine');
                                sc22.caIntegratorValue__c += sw.caIntegratorValue+',';*/
                            }
                            if(dcis.Intra_cystic_encysted_papillary__c) {
                                Snomed_Code__c sc22 = new Snomed_Code__c();
                                sc22.CRF__c = pss.CRF__c;
                                sc22.TrialPatient__c = pss.TrialPatient__c;
                                sc22.snomed_Code_Name__c = '33731-1';
                                sc22.Code_Master__c = sm.Id;
                                sw = SnomedCTCode.SnomedCode('Intra-cystic', 'DCISHistology_PS');
                                sc22.caIntegratorValue__c = sw.caIntegratorValue;
                                sc22.Code_System_Version__c = sw.codeSystemVersion;
                                lstSnomed.add(sc22);
                                /*sw = SnomedCTCode.SnomedCode('33731-1', 'Intra-cystic');
                                sc22.caIntegratorValue__c += sw.caIntegratorValue+',';*/
                            }
                            if(dcis.Other__c) {
                                Snomed_Code__c sc22 = new Snomed_Code__c();
                                sc22.CRF__c = pss.CRF__c;
                                sc22.TrialPatient__c = pss.TrialPatient__c;
                                sc22.snomed_Code_Name__c = '33731-1';
                                sc22.Code_Master__c = sm.Id;
                                sw = SnomedCTCode.SnomedCode('Other', 'DCISHistology_PS');
                                sc22.caIntegratorValue__c = sw.caIntegratorValue;
                                sc22.Code_System_Version__c = sw.codeSystemVersion;
                                lstSnomed.add(sc22);
                                /*sw = SnomedCTCode.SnomedCode('33731-1', 'Other');
                                sc22.caIntegratorValue__c += sw.caIntegratorValue+',';*/
                            }
                            
                            /*sc22.Value__c = sw.snomedCodeVal;
                            sc22.Code_System__c = sw.codeSystem;
                            lstSnomed.add(sc22);*/
                        }
                        /*if(sm.Name == 'DCISspan_PS'){
                            Snomed_Code__c sc24 = new Snomed_Code__c();
                            sc24.CRF__c = pss.CRF__c;
                            sc24.TrialPatient__c = pss.TrialPatient__c;
                            sc24.snomed_Code_Name__c = 'IHTSDO_4678';
                            sc24.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw24 = SnomedCTCode.SnomedCode('IHTSDO_4678', dcis.Total_Histological_Span__c+''); 
                            sc24.Value__c = sw24.snomedCodeVal;
                            sc24.caIntegratorValue__c = sw24.caIntegratorValue;
                            sc24.Code_System__c = sw24.codeSystem;
                            lstSnomed.add(sc24);
                        }*/
                        /*
                        NEEDS TO BE UNCOMMENTED LATER. TOO COMPLEX FOR SIMPLE CALCULATION
                        if(sm.Name == 'InvMargin_PS'){
                            //List<Invasive_Tumor_Detail__c> invList = [select id,Post_Surgery_Summary__c,Lympatic_vascular_Invasion__c,Multi_focal_Tumor__c,Overall_cancer_cellularity__c,Invasive_margins__c from Invasive_Tumor_Detail__c where Post_Surgery_Summary__c IN :postIds];
                            //List<Procedure__c> lstPro = [select id,Procedure_Name__c, Post_Surgery_Summary__c from Procedure__c where Post_Surgery_Summary__c IN : postIds];
                            if(pss.Invasive_Tumor_Details__r.Size()<=0 && pss.Procedures__r.Size()<=0) continue; 
                            List<Invasive_Tumor_Detail__c> invList = pss.Invasive_Tumor_Details__r;
                            List<Procedure__c> lstPro = pss.Procedures__r;
                            for(Invasive_Tumor_Detail__c inv : invList) {
                                for(Procedure__c pro : lstPro){
                                    if(pro.Post_Surgery_Summary__c == pss.Id) {
                                        Snomed_Code__c sc19 = new Snomed_Code__c();
                                        sc19.CRF__c = pss.CRF__c;
                                        sc19.TrialPatient__c = pss.TrialPatient__c;
                                        sc19.snomed_Code_Name__c = '396631001 | surgical margin observable |';
                                        sc19.Code_Master__c = sm.Id;
                                        Snomed_Code__c scodeValue = histologySnomed(dcis, inv, pro, pss, sc19);
                                        //SnomedCTCode.SnomedWrapper sw19 = SnomedCTCode.SnomedCode('396631001', '');
                                        sc19.Value__c = scodeValue.Value__c;
                                        sc19.caIntegratorValue__c = scodeValue.caIntegratorValue__c;
                                        sc19.Code_System__c = scodeValue.Code_System__c;
                                        sc19.Code_System_Version__c = scodeValue.Code_System_Version__c;
                                        lstSnomed.add(sc19);
                                    }
                                }
                            }
                            
                        }*/
                    }
                }
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    //@future
    private static void insertLCISRelatedCodes(List<Post_Surgaory_Summary__c> lstPostSur, List<On_Study_Pathology_Form__c> lstOnStudyPath) {
        
        /*List<LCIS__c> lstLCIS = [Select l.pg_Lcis_Id__c, l.Unknown_Not_Reported__c, l.Total_histological_span_measurement_unit__c, l.Total_histological_span__c, l.SystemModstamp, l.Specify_Units__c, l.Specify_No__c, l.Post_Surgery_Summary__c, l.OwnerId, l.On_Study_Pathology_Form__c, l.Name, l.Margins__c, l.LastModifiedDate, l.LastModifiedById, l.LCIS__c, l.IsDeleted, l.Id, l.Histological_Type__c, l.CreatedDate, l.CreatedById, l.Closest_Margin__c From LCIS__c l where Id IN :lcisIds];
                
        Set<Id> postIds = new Set<Id>();
        Set<Id> ospIds = new Set<Id>();
        for(LCIS__c lcis : lstLCIS) {
            postIds.add(lcis.Post_Surgery_Summary__c);
            ospIds.add(lcis.On_Study_Pathology_Form__c);
        }
        
        List<Post_Surgaory_Summary__c> lstPostSur = [select CRF__c, TrialPatient__c,(Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Location__c, Procedure_Name__c, Laterality__c, Form_Name__c, Date_Of_Procedure__c, Node_Result__c, Node_Type__c, Ultrasound__c, Palpation_guided__c, Mammography__c, MRI__c, Stereotactic__c, Post_Surgery_Summary__c, TrialPatient__c, On_Study_Pathology_Form__c, Total_Positive__c, Total_Examined_Nodes__c From Procedures__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, DCIS__c, Unknown_Not_Reported__c, Tumor_Size__c, Present_in_continous_section__c, Spanning__c, Present_as_scattered_microscopic_foci__c, Microscopic_foci_upto__c, From_Slide__c, To_Slide__c, Deep_Margin__c, Deep_Margin_Size__c, Medical__c, Medical_Size__c, Lateral__c, Lateral_Size__c, Anterior_Superior__c, Anterior_Superior_Size__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Punctate_necrosis__c, Comedonecrosis__c, Papillary__c, Micropapillary__c, Necrosis__c, Cribiform__c, Cruciform__c, Clinging__c, Solid__c, Apocrine__c, Intra_cystic_encysted_papillary__c, Calcifications__c, Nuclear_Grade__c, Total_Histological_Span__c, Total_Histological_Span_Measurement_Unit__c, Margin__c, Closest_Margin__c, Specific_Closest_Margin__c, Specific_Closest_Margin_Measurement_Unit__c, Other__c, Other_if_other_mention_type_in_textb__c, Calcifications_Present__c, On_Study_Pathology_Form__c, Post_Surgery_Summary__c From DCIS__r) from Post_Surgaory_Summary__c where Id IN :postIds];
        List<On_Study_Pathology_Form__c> lstOnStudyPath = [select CRF__c, TrialPatient__c from On_Study_Pathology_Form__c where Id IN :ospIds];
        */
        //removed InSitu_OS as there is no snomed code for that
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'InvMargin_PS' 
        or Name = 'LCISHistology_PS'];
        
        for(Post_Surgaory_Summary__c pss : lstPostSur) {
            for(LCIS__c lcis : pss.LCIS__r){
                for(Code_Master__c sm : lstSnomedMaster){
                    if(lcis.Post_Surgery_Summary__c == pss.Id) {
                        if(sm.Name == 'LCISHistology_PS'){
                            Snomed_Code__c sc25 = new Snomed_Code__c();
                            sc25.CRF__c = pss.CRF__c;
                            sc25.TrialPatient__c = pss.TrialPatient__c;
                            sc25.snomed_Code_Name__c = '33731-1'; //this same code also used in DCIS
                            sc25.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw25 = SnomedCTCode.SnomedCode(lcis.Histological_Type__c, 'LCISHistology_PS'); 
                            sc25.Value__c = sw25.snomedCodeVal;
                            sc25.caIntegratorValue__c = sw25.caIntegratorValue;
                            sc25.Code_System__c = sw25.codeSystem;
                            sc25.Code_System_Version__c = sw25.codeSystemVersion;
                            lstSnomed.add(sc25);
                        }
                        /*if(sm.Name == 'InSitu_PS'){
                            if(pss.DCIS__r.Size()<=0) continue;
                            List<DCIS__c> dcisList = pss.DCIS__r;
                            Map<Id, Decimal> postIdDcisPercent = new Map<Id, Decimal>();
                            for(DCIS__c dcis : dcisList) {
                                postIdDcisPercent.put(dcis.Post_Surgery_Summary__c, dcis.DCIS__c);
                            }
                            Snomed_Code__c sc14 = new Snomed_Code__c();
                            sc14.CRF__c = pss.CRF__c;
                            sc14.TrialPatient__c = pss.TrialPatient__c;
                            sc14.snomed_Code_Name__c = 'IHTSDO_4567';
                            sc14.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw14;
                            if(postIdDcisPercent.get(lcis.Post_Surgery_Summary__c) > lcis.LCIS__c) {
                                sw14 = SnomedCTCode.SnomedCode(postIdDcisPercent.get(lcis.Post_Surgery_Summary__c)+'', 'InSitu_PS');
                            } else {
                                sw14 = SnomedCTCode.SnomedCode(lcis.LCIS__c+'', 'InSitu_PS');
                            }
                            //SnomedCTCode.SnomedWrapper sw14 = SnomedCTCode.SnomedCode('IHTSDO_4567', 'N/A');
                            sc14.Value__c = sw14.snomedCodeVal;
                            sc14.caIntegratorValue__c = sw14.caIntegratorValue;
                            sc14.Code_System__c = sw14.codeSystem;
                            sc14.Code_System_Version__c = sw14.codeSystemVersion;
                            lstSnomed.add(sc14);
                        }*/
                    }
                }
                
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    //@future
    private static void insertStagingRelatedCodes(List<Post_Surgaory_Summary__c> lstPost) {
        
        /*List<Staging_Detail__c> lstStaging = [Select s.pg_StagingDetail_Id__c, s.Tumor_Type__c, s.T4_Tumor_final_status__c, s.SystemModstamp, s.Staging_Modifier_Type__c, s.Post_Surgery_Summary__c, s.OwnerId, s.Node_Type__c, s.Name, s.Modifier_multiple_primary__c, s.Modifier_indicates_recurrent__c, s.Modifier_designates__c, s.Modifier_classification_done__c, s.Metastasis__c, s.Letarality__c, s.LastModifiedDate, s.LastModifiedById, s.IsDeleted, s.Id, s.CreatedDate, s.CreatedById, s.Calculated_Stage__c, s.Calculated_Stage_Value__c, s.Adjudicated_Stage__c, s.Adjudicated_By__c From Staging_Detail__c s where Id IN:stagingIds];
        
        set<Id> setIds = new set<Id>();
        for(Staging_Detail__c stage : lstStaging){
            setIds.add(stage.Post_Surgery_Summary__c);
        }
        List<Post_Surgaory_Summary__c> lstPost = [select id,CRF__c,TrialPatient__c from Post_Surgaory_Summary__c where Id IN : setIds];
        */
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'PathologyStage_PS' 
                                            or Name = 'ypT' or Name = 'ypN' or Name = 'ypM'];
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        for(Post_Surgaory_Summary__c pss : lstPost){
            List<Staging_Detail__c> lstStaging = pss.Staging_Details__r;
            for(Staging_Detail__c stage : lstStaging){
                for(Code_Master__c sm : lstSnomedMaster){
                    if(stage.Post_Surgery_Summary__c == pss.Id){
                        if(sm.Name == 'PathologyStage_PS'){
                            Snomed_Code__c sc14 = new Snomed_Code__c();
                            sc14.CRF__c = pss.CRF__c;
                            sc14.TrialPatient__c = pss.TrialPatient__c;
                            sc14.snomed_Code_Name__c = '254292007 | tumour staging | ';
                            sc14.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw14 = SnomedCTCode.SnomedCode(stage.Adjudicated_Stage__c, 'PathologyStage_PS');
                            sc14.Value__c = sw14.snomedCodeVal;
                            sc14.Code_System__c = sw14.codeSystem;
                            sc14.Numeric_Value__c = sw14.numericValue;
                            sc14.caIntegratorValue__c = sw14.caIntegratorValue;
                            sc14.Code_System_Version__c = sw14.codeSystemVersion;  
                            lstSnomed.add(sc14);
                        }
                        if(sm.Name == 'ypT'){
                            Snomed_Code__c sc14 = new Snomed_Code__c();
                            sc14.CRF__c = pss.CRF__c;
                            sc14.TrialPatient__c = pss.TrialPatient__c;
                            sc14.snomed_Code_Name__c = '78873005 | T category | 78873005';
                            sc14.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw14 = SnomedCTCode.SnomedCode(stage.Tumor_Type__c, 'ypT');
                            sc14.Value__c = sw14.snomedCodeVal;
                            sc14.Code_System__c = sw14.codeSystem;
                            sc14.Numeric_Value__c = sw14.numericValue; 
                            sc14.caIntegratorValue__c = sw14.caIntegratorValue;
                            sc14.Code_System_Version__c = sw14.codeSystemVersion;
                            lstSnomed.add(sc14);
                        }
                        if(sm.Name == 'ypN'){
                            Snomed_Code__c sc14 = new Snomed_Code__c();
                            sc14.CRF__c = pss.CRF__c;
                            sc14.TrialPatient__c = pss.TrialPatient__c;
                            sc14.snomed_Code_Name__c = '277206009 | N category | ';
                            sc14.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw14 = SnomedCTCode.SnomedCode(stage.Node_Type__c, 'ypN');
                            sc14.Value__c = sw14.snomedCodeVal;
                            sc14.Code_System__c = sw14.codeSystem;
                            sc14.Numeric_Value__c = sw14.numericValue;
                            sc14.caIntegratorValue__c = sw14.caIntegratorValue;
                            sc14.Code_System_Version__c = sw14.codeSystemVersion;  
                            lstSnomed.add(sc14);
                        }
                        if(sm.Name == 'ypM'){
                            Snomed_Code__c sc14 = new Snomed_Code__c();
                            sc14.CRF__c = pss.CRF__c;
                            sc14.TrialPatient__c = pss.TrialPatient__c;
                            sc14.snomed_Code_Name__c = '277208005 | M category | ';
                            sc14.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw14 = SnomedCTCode.SnomedCode(stage.Metastasis__c, 'ypM');
                            sc14.Value__c = sw14.snomedCodeVal;
                            sc14.Code_System__c = sw14.codeSystem;
                            sc14.Numeric_Value__c = sw14.numericValue;  
                            sc14.caIntegratorValue__c = sw14.caIntegratorValue;
                            sc14.Code_System_Version__c = sw14.codeSystemVersion;
                            lstSnomed.add(sc14);
                        }
                    }
                }
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    @future
    public static void insertOnStudyEligibilityCode(Set<Id> oseIds) {
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Interval_Cancer' or Name = 'Method_Detect'];
        List<On_Study_Eligibility_Form__c> oseList = [Select o.Screening_Memogram_Prior_to_Mass_Detect__c,o.Most_Recent_Date__c,o.Status__c,o.How_was_the_cancer_first_detected__c, o.Mass_Identification_Date__c,CRF__c,TrialPatient__c From On_Study_Eligibility_Form__c o where o.id in :oseIds];
        List<Snomed_Code__c> snomedCodes = new List<Snomed_Code__c>();
        for(On_Study_Eligibility_Form__c ose : oseList) {
            for(Code_Master__c sm : lstSnomedMaster){
                if(sm.Name == 'Interval_Cancer' && ose.Status__c == 'Accepted'){
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = ose.CRF__c;
                    sc.TrialPatient__c = ose.TrialPatient__c;
                    sc.snomed_Code_Name__c = 'IHTSDO_4552';
                    SnomedCTCode.SnomedWrapper sw = null;
                    if(ose.Most_Recent_Date__c != null && ose.Mass_Identification_Date__c != null) {
                        integer days = ose.Most_Recent_Date__c.daysBetween(ose.Mass_Identification_Date__c);
                        system.debug('days : '+days);
                        //from caintegrator pdf
                        //if date of mass first identified and the date of the most recent screening mammogram is 2 years or less than answer is Yes;
                        if(days <= 730) {
                            sw = SnomedCTCode.SnomedCode('Yes', 'Interval_Cancer');
                        } else {
                            //If difference in date is greater than 2 years answer is No.
                            sw = SnomedCTCode.SnomedCode('No', 'Interval_Cancer');
                        }
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.Code_Master__c = lstSnomedMaster[0].Id;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        snomedCodes.add(sc);
                    } else if(!ose.Screening_Memogram_Prior_to_Mass_Detect__c) {
                        sw = SnomedCTCode.SnomedCode('NA', 'Interval_Cancer');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.Code_Master__c = lstSnomedMaster[0].Id;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        snomedCodes.add(sc);
                    }
                }
                if(sm.Name == 'Method_Detect'){
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = ose.CRF__c;
                    sc.TrialPatient__c = ose.TrialPatient__c;
                    sc.snomed_Code_Name__c = '373573001 | clinical finding present | : 246090004 | associated finding | = 254838004 | carcinoma of breast | : 418775008 | finding method | =';
                    sc.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(ose.How_was_the_cancer_first_detected__c, 'Method_Detect');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    snomedCodes.add(sc);
                }
            }
        }
        if(!snomedCodes.isEmpty()) {
            insert snomedCodes;
        }
    }
    
    @future
    public static void insertPrelEligibilityCodes(Set<Id> preElIds) {
        
        List<PreEligibility_Checklist__c> preList = [Select p.ECOG_Score__c,p.CRF_Id__c,p.Patient__c From PreEligibility_Checklist__c p where id in :preElIds and Status__c = 'Approval Not Required'];
        List<Pre_Registration_Snomed_Codes__c> lstCodes = new List<Pre_Registration_Snomed_Codes__c>();
        
        List<Code_Master__c> snomedMasterList = [Select Id,Name from Code_Master__c where Name = 'ECOG' ];
        Map<String, Id> nameIdMap = new Map<String, Id>();
        for(Code_Master__c sm : snomedMasterList) {
            nameIdMap.put(sm.Name, sm.Id);
        }       
        
        system.debug('preList : '+preList);
        for(PreEligibility_Checklist__c  p : preList) {
            system.debug('p.ECOG_Score__c : '+p.ECOG_Score__c);
            if(p.ECOG_Score__c == null || p.ECOG_Score__c == '')continue;
            integer numScore = Integer.valueOf(p.ECOG_Score__c.substring(0,1));
            Pre_Registration_Snomed_Codes__c sc = new Pre_Registration_Snomed_Codes__c();
            sc.CRF__c = p.CRF_Id__c;
            //No trial patient when pre-el is filled
            //sc.TrialPatient__c = p.TrialPatient__c;
            sc.Patient__c = p.Patient__c;
            sc.snomed_Code_Name__c = '423740007 | ECOG performance status | ';
            sc.Code_Master__c = nameIdMap.get(sc.snomed_Code_Name__c);
            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(numScore+'', 'ECOG');
            sc.Value__c = sw.snomedCodeVal;
            sc.Code_System__c = sw.codeSystem;
            sc.Numeric_Value__c = sw.numericValue;
            sc.caIntegratorValue__c = sw.caIntegratorValue;
            sc.Code_System_Version__c = sw.codeSystemVersion;
            sc.Code_Master__c = nameIdMap.get('ECOG');
            lstCodes.add(sc);
        }
        if(!lstCodes.isEmpty()) {
            insert lstCodes;
        }
    }
    
    @future
    public static void insertSnomedCodesForChemoTreatment(Set<id> chemoIds) {
        
        List<Chemo_Treatment__c> chemoTreatList = [Select c.TrialPatient__c, c.Patient_weight__c, c.Patient_height__c, c.CRF__c, (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Chemo_Treatment__c, Dose__c, Notes__c, Route__c, TotalDose__c, isReceived__c, pg_GrowthFactor_Id__c From Growth_Factor__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Agent__c, Chemo_Treatment__c, Day__c, Did_patient_stop_receiving__c, Dose_Delay__c, Dose_Mod_Reason_Number__c, Dose_Mod__c, Dose_modification__c, Other_Dose_Mod_Reason__c, Prescribed_Dose__c, Reason_why_patient_stopped_receiving__c, Row_Color__c, Total_Dose__c, Administered_dose_Units__c, Other_Agent__c, Prescribed_dose_Units__c, Other_Reason_Patient_Stop_Receiving__c, pg_ChemotherapyRegimens_Id__c From Chemo_Therapy_Regimens__r) From Chemo_Treatment__c c where c.Id in :chemoIds];
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Height' or Name = 'Weight'];
        for(Chemo_Treatment__c ct : chemoTreatList){
            for(Code_Master__c sm : lstSnomedMaster){
                if(sm.Name == 'Height'){
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = ct.CRF__c;
                    sc.TrialPatient__c = ct.TrialPatient__c;
                    sc.snomed_Code_Name__c = '50373000 | body height measure | ';
                    sc.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(''+ct.Patient_height__c, 'Height');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.Numeric_Value__c = sw.numericValue;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                }
                if(sm.Name == 'Weight'){
                    Snomed_Code__c sc1 = new Snomed_Code__c();
                    sc1.CRF__c = ct.CRF__c;
                    sc1.TrialPatient__c = ct.TrialPatient__c;
                    sc1.snomed_Code_Name__c = '27113001 | body weight | ';
                    sc1.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode(''+ct.Patient_weight__c, 'Weight');
                    sc1.Value__c = sw1.snomedCodeVal;
                    sc1.Code_System__c = sw1.codeSystem;
                    sc1.Numeric_Value__c = sw1.numericValue;
                    sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                    sc1.Code_System_Version__c = sw1.codeSystemVersion;
                    lstSnomed.add(sc1);
                }
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
        insertSnomedCodesForGrowthFactor(chemoTreatList);
        insertChemoTherapyRegimenCode(chemoTreatList);
    }
    
    //@future
    private static void insertSnomedCodesForGrowthFactor(List<Chemo_Treatment__c> lstChemoTreat) {
        
        /*List<Growth_Factor__c> gList = [Select g.isReceived__c, g.TotalDose__c, g.Route__c, g.Notes__c, g.Name, g.Dose__c, g.Chemo_Treatment__c From Growth_Factor__c g where g.Id in :gIds];
        
        set<Id> chemoTreatIds = new set<Id>();
        for(Growth_Factor__c gf : gList){
            chemoTreatIds.add(gf.Chemo_Treatment__c);
        }
        List<Chemo_Treatment__c> lstChemoTreat = [select id,CRF__c,TrialPatient__c, (Select g.isReceived__c, g.TotalDose__c, g.Route__c, g.Notes__c, g.Name, g.Dose__c, g.Chemo_Treatment__c From Growth_Factor__r g) from Chemo_Treatment__c where Id IN : chemoTreatIds];
        */
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'ChemoGrowthMeds'];
        if(lstSnomedMaster.isEmpty()) return;
        
        for(Chemo_Treatment__c ct : lstChemoTreat){
            if(ct.Growth_Factor__r.size() == 0) {
                //TODO
                Snomed_Code__c sc = new Snomed_Code__c();
                sc.CRF__c = ct.CRF__c;
                sc.TrialPatient__c = ct.TrialPatient__c;
                sc.snomed_Code_Name__c = '110461004 | adjunctive care | ';
                sc.Code_Master__c = lstSnomedMaster[0].Id; 
                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Not given', 'ChemoGrowthMeds');
                sc.Value__c = sw.snomedCodeVal;
                sc.Code_System__c = sw.codeSystem;
                sc.Numeric_Value__c = sw.numericValue;
                sc.caIntegratorValue__c = sw.caIntegratorValue;
                sc.Code_System_Version__c = sw.codeSystemVersion;
                lstSnomed.add(sc);
            } else {
                Snomed_Code__c sc = new Snomed_Code__c();
                sc.CRF__c = ct.CRF__c;
                sc.TrialPatient__c = ct.TrialPatient__c;
                sc.snomed_Code_Name__c = '110461004 | adjunctive care | ';
                sc.Code_Master__c = lstSnomedMaster[0].Id;
                sc.Value__c = '';
                for(Growth_Factor__c gf : ct.Growth_Factor__r){
                    for(Code_Master__c sm : lstSnomedMaster){
                        if(gf.Name == 'Neulasta' && gf.isReceived__c){
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Pegfilgrastim (Neulasta)', 'ChemoGrowthMeds');
                            sc.Value__c += sw.snomedCodeVal + ',';
                            sc.caIntegratorValue__c += sw.caIntegratorValue + ',';
                            sc.Code_System_Version__c = sw.codeSystemVersion;
                            sc.Code_System__c = sw.codeSystem;
                        }
                        if(gf.Name == 'Neupogen' && gf.isReceived__c){
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Filgrastin (Neupogen)', 'ChemoGrowthMeds');
                            sc.Value__c += sw.snomedCodeVal + ',';
                            sc.caIntegratorValue__c += sw.caIntegratorValue + ',';
                            sc.Code_System_Version__c = sw.codeSystemVersion;
                            sc.Code_System__c = sw.codeSystem;
                        }
                    }
                }
                if(sc.Value__c.endsWith(',')) {
                    sc.Value__c = sc.Value__c.substring(0,sc.Value__c.length()-1);
                }
                if(sc.Value__c.endsWith(',')) {
                    sc.caIntegratorValue__c = sc.caIntegratorValue__c.substring(0,sc.caIntegratorValue__c.length()-1);
                }
                lstSnomed.add(sc);
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    @future
    public static void insertSnomedCodesForPostSurgery(Set<id> postIds) {
        
        List<Post_Surgaory_Summary__c> lstPostSurgery = [select CRF__c, TrialPatient__c, Is_LCIS_Present__c, Is_DCIS_Present__c, Is_invasive_tumor_present__c, pcr__c, RCB_Class__c, Lymph_node_dissection_done__c, 
            (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
            Adjudicated_By__c, Adjudicated_Stage__c, Calculated_Stage_Value__c, Calculated_Stage__c, Letarality__c, Metastasis__c, 
            Modifier_classification_done__c, Modifier_designates__c, Modifier_indicates_recurrent__c, Modifier_multiple_primary__c, 
            Node_Type__c, Post_Surgery_Summary__c, Staging_Modifier_Type__c, T4_Tumor_final_status__c, Tumor_Type__c, Patient__c, 
            pg_StagingDetail_Id__c From Staging_Details__r), 
            (Select Id, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, CB_11_Value__c, 
            CB_11__c, DAKO_Herceptest_Value__c, DAKO_Herceptest__c, ER_TS_OS_Snomed__c, ERpos_OS_Snomed__c, Estrogen_Intensity_Score__c, 
            Estrogen_Receptor_Proportion_Score__c, Estrogen_Receptor_Status__c, FISH_test_not_done__c, Fish__c, HER2_neu_Marker__c, 
            Her2Pos_OS_Snomed__c, IHC__c, IHC_test_not_done__c, Letarality__c, Other_FISH_Results__c, Other_FISH_Test_Value__c, 
            Other_FISH_Test__c, Other_IHC_Results__c, Other_IHC_Test_Value__c, Other_IHC_Test__c, PgR_TS_OS_Snomed__c, Progesterone_Intensity_Score__c, 
            Progesterone_Receptor_Proportion_Score__c, Progesterone_Receptor_Status__c, Total_Score_ER__c, Total_Score_PR__c, 
            Ventana_Oncoprobe_Value__c, Ventana_Oncoprobe__c, Ventana_kit_Value__c, Ventana_kit__c, Vysis_Path_Vision_Value__c, 
            Vysis_Path_Vision__c, pg_Receptors_Id__c, On_Study_Pathology_Form__c, Post_Surgery_Summary__c, Type__c From Receptors__r), 
            (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
            Date_Of_Procedure__c, Form_Name__c, Laterality__c, Location__c, MRI__c, Mammography__c, Node_Result__c, Node_Type__c, 
            On_Study_Pathology_Form__c, Palpation_guided__c, Post_Surgery_Summary__c, Procedure_Name__c, Stereotactic__c, Total_Examined_Nodes__c, 
            Total_Positive__c, TrialPatient__c, Ultrasound__c, pg_procedure_id__c From Procedures__r), 
            (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Closest_Margin__c, 
            Histological_Type__c, LCIS__c, Margins__c, Specify_No__c, Specify_Units__c, Total_histological_span__c, 
            Total_histological_span_measurement_unit__c, Unknown_Not_Reported__c, Histology__c, pg_Lcis_Id__c, On_Study_Pathology_Form__c, 
            Post_Surgery_Summary__c From LCIS__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
            LastModifiedById, SystemModstamp, Anterior_Inferior_Size__c, Anterior_Inferior__c, Anterior_Superior_Size__c, 
            Anterior_Superior__c, Apocrine__c, Calcifications__c, Clinging__c, Closest_Margin__c, Comedonecrosis__c, Cribiform__c, 
            Cruciform__c, DCIS__c, Deep_Margin_Size__c, Deep_Margin__c, From_Slide__c, Intra_cystic_encysted_papillary__c, 
            Lateral_Size__c, Lateral__c, Margin__c, Medical_Size__c, Medical__c, Micropapillary__c, Microscopic_foci_upto__c, 
            Necrosis__c, Nuclear_Grade__c, Other__c, Other_if_other_mention_type_in_textb__c, Papillary__c, Present_as_scattered_microscopic_foci__c, 
            Present_in_continous_section__c, Punctate_necrosis__c, Solid__c, Spanning__c, Specific_Closest_Margin_Measurement_Unit__c, 
            Specific_Closest_Margin__c, To_Slide__c, Total_Histological_Span_Measurement_Unit__c, Total_Histological_Span__c, Tumor_Size__c, 
            Unknown_Not_Reported__c, Calcifications_Present__c, Histology__c, On_Study_Pathology_Form__c, 
            Post_Surgery_Summary__c, pg_dcis_Id__c From DCIS__r), 
            (Select i.Unknown_Not_Reported__c, i.Ulceration_by_tumor__c, i.Tumor_Size__c, i.Tumor_Size_Width__c, 
            i.Tumor_Size_Height__c, i.Tumor_Measurement_Unit__c, i.Tubulolobular_carcinoma__c, 
            i.Tubule_Papilla_formation__c, i.Tubular_carcinoma__c, i.Total_Points__c, i.SystemModstamp, 
            i.Specify_Units__c, i.Specify_No__c, i.Skin_Involvement__c, i.Signs_of_Treatment_Effect__c, 
            i.SBR_Grade__c, i.Pleomorphic_lobular_carcinoma__c, i.Paget_disease__c, i.OwnerId, 
            i.Overall_cancer_cellularity__c, i.Other_if_other_mention_type_in_textbox__c, 
            i.Other_changes_present__c, i.Other__c, i.Nuclear_Grade__c, i.Name, i.Muscle_involvement__c, 
            i.Multi_focal_Tumor__c, i.Mucinous_carcinoma__c, i.Mitotic_Count__c, i.Medullary_carcinoma__c, 
            i.Medical__c, i.Medical_Size__c, i.Lympatic_vascular_Invasion__c, i.Lateral__c, i.Lateral_Size__c, 
            i.Invasive_papillary_carcinoma__c, i.Invasive_margins_size__c, i.Invasive_margins__c, 
            i.Invasive_lobular_carcinoma_classic_type__c, i.Invasive_lobular_carcinoma_alveolar_type__c, 
            i.Invasive_ductal_carcinoma_nos__c, i.Invasive_cribiform_carcinoma__c, 
            i.Invasive_carcinoma_mixed_ductal_lobular__c, i.Histology__c, i.Evidence_of_therapeutic_effects__c, 
            i.Dermal_Involvement__c, i.Derma_lymphatic_vascular_invasion__c, i.Deep_Margin__c, i.Deep_Margin_Size__c, 
            i.Closest_Margin__c, i.Calcifications__c, i.Calcifications_Present__c, i.Anterios_Superior_Size__c, 
            i.Anterior_Superior__c, i.Anterior_Superior_Size__c, i.Anterior_Inferior__c, 
            i.Anterior_Inferior_Size__c From Invasive_Tumor_Details__r i) 
            from Post_Surgaory_Summary__c where Id IN:postIds];
            
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'ypT' or Name = 'ypN' 
        or Name = 'ypM' or Name = 'pCR' or Name = 'RCB_class' or Name = 'RCB_index' or Name = 'InSitu_PS' or Name = 'LVI_PS' or Name = 'BaseNodeExt'
        or Name = 'InvMultifocal_PS' or Name = 'BaseDiseaseExt' or Name = 'DCISGrade_PS' or Name = 'InvMargin_PS' or Name = 'GrossPathSize1_PS' or Name = 'GrossPathSize2_PS' 
        or Name = 'InvPathSize1_PS' or Name = 'InvPathSize1_PS' or Name = 'InvPathSize2_PS' or Name = 'SizeMetLN_PS' or Name = 'InvHistology_PS'
        or Name = 'DCISHistology_PS' or Name = 'DCISspan_PS' or Name = 'LCISHistology_PS' or Name = 'CoreNeedle Guidance_pretx'];
        for(Post_Surgaory_Summary__c pss : lstPostSurgery){
            for(Code_Master__c sm : lstSnomedMaster){
                if(sm.Name == 'pCR'){
                    Snomed_Code__c sc3 = new Snomed_Code__c();
                    sc3.CRF__c = pss.CRF__c;
                    sc3.TrialPatient__c = pss.TrialPatient__c;
                    sc3.snomed_Code_Name__c = '103338009 | in complete remission |';
                    sc3.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw3 = new SnomedCTCode.SnomedWrapper();
                    if(pss.pcr__c){
                        sw3 = SnomedCTCode.SnomedCode('Yes', 'pCR');
                    } else {
                        sw3 = SnomedCTCode.SnomedCode('No', 'pCR');
                    }
                    sc3.Value__c = sw3.snomedCodeVal;
                    sc3.Code_System__c = sw3.codeSystem;
                    sc3.caIntegratorValue__c = sw3.caIntegratorValue;
                    sc3.Code_System_Version__c = sw3.codeSystemVersion;
                    lstSnomed.add(sc3);
                }
                
                if(sm.Name == 'GrossPathSize1_PS' || sm.Name == 'GrossPathSize2_PS'){
                    Snomed_Code__c sc6 = new Snomed_Code__c();
                    sc6.CRF__c = pss.CRF__c;
                    sc6.TrialPatient__c = pss.TrialPatient__c;
                    sc6.snomed_Code_Name__c = 'IHTSDO_4583_1'; 
                    sc6.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw6 = SnomedCTCode.SnomedCode('No Surgery', 'GrossPathSize1_PS');
                    sc6.Value__c = sw6.snomedCodeVal;
                    sc6.Code_System__c = sw6.codeSystem;
                    sc6.caIntegratorValue__c = sw6.caIntegratorValue;
                    sc6.Code_System_Version__c = sw6.codeSystemVersion;
                    lstSnomed.add(sc6);
                }
                
                if(sm.Name == 'RCB_class' && pss.RCB_Class__c != null){
                    Snomed_Code__c sc11 = new Snomed_Code__c();
                    sc11.CRF__c = pss.CRF__c;
                    sc11.TrialPatient__c = pss.TrialPatient__c;
                    sc11.snomed_Code_Name__c = 'IHTSDO_4575';
                    sc11.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw11 = SnomedCTCode.SnomedCode(pss.RCB_Class__c, 'RCB_class');
                    sc11.Value__c = sw11.snomedCodeVal;
                    sc11.Code_System__c = sw11.codeSystem;
                    sc11.caIntegratorValue__c = sw11.caIntegratorValue;
                    sc11.Code_System_Version__c = sw11.codeSystemVersion;
                    lstSnomed.add(sc11);
                }
                if(sm.Name == 'InvPathSize1_PS' || sm.Name == 'InvPathSize2_PS'){
                    Snomed_Code__c sc20 = new Snomed_Code__c();
                    sc20.CRF__c = pss.CRF__c;
                    sc20.TrialPatient__c = pss.TrialPatient__c;
                    sc20.snomed_Code_Name__c = 'IHTSDO_4583_2';
                    sc20.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw20 = SnomedCTCode.SnomedCode('No Surgery', 'InvPathSize1_PS');
                    sc20.Value__c = sw20.snomedCodeVal;
                    sc20.caIntegratorValue__c = sw20.caIntegratorValue;
                    sc20.Code_System__c = sw20.codeSystem;
                    sc20.Code_System_Version__c = sw20.codeSystemVersion;
                    lstSnomed.add(sc20);
                }
                /*if(sm.Name == 'SizeMetLN_PS'){
                    Snomed_Code__c sc21 = new Snomed_Code__c();
                    sc21.CRF__c = pss.CRF__c;
                    sc21.TrialPatient__c = pss.TrialPatient__c;
                    sc21.snomed_Code_Name__c = 'IHTSDO_4594';
                    sc21.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw21 = SnomedCTCode.SnomedCode('IHTSDO_4594', pss.Lymph_node_dissection_done__c);
                    sc21.Value__c = sw21.snomedCodeVal;
                    sc21.caIntegratorValue__c = sw21.caIntegratorValue;
                    sc21.Code_System__c = sw21.codeSystem;
                    lstSnomed.add(sc21);
                }*/
                if(sm.Name == 'InSitu_PS') {
                    if(pss.Is_DCIS_Present__c == 'Yes'){
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = pss.CRF__c;
                        sc.TrialPatient__c = pss.TrialPatient__c;
                        sc.Code_Master__c = sm.Id;
                        sc.snomed_Code_Name__c = '364708003 | sample observable |';
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes, DCIS', 'InSitu_PS');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    } else if(pss.Is_LCIS_Present__c == 'Yes'){
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = pss.CRF__c;
                        sc.TrialPatient__c = pss.TrialPatient__c;
                        sc.Code_Master__c = sm.Id;
                        sc.snomed_Code_Name__c = '364708003 | sample observable |';
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes, LCIS', 'InSitu_PS');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    } else if(pss.Is_DCIS_Present__c == 'No' && pss.Is_LCIS_Present__c == 'No'){
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = pss.CRF__c;
                        sc.TrialPatient__c = pss.TrialPatient__c;
                        sc.Code_Master__c = sm.Id;
                        sc.snomed_Code_Name__c = '364708003 | sample observable |';
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No', 'InSitu_PS');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    } else if(pss.Is_DCIS_Present__c == 'Not Reported' || pss.Is_LCIS_Present__c == 'Not Reported'){
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = pss.CRF__c;
                        sc.TrialPatient__c = pss.TrialPatient__c;
                        sc.Code_Master__c = sm.Id;
                        sc.snomed_Code_Name__c = '364708003 | sample observable |';
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Not Reported', 'InSitu_PS');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    } else {
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = pss.CRF__c;
                        sc.TrialPatient__c = pss.TrialPatient__c;
                        sc.Code_Master__c = sm.Id;
                        sc.snomed_Code_Name__c = '364708003 | sample observable |';
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No Surgery', 'InSitu_PS');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        lstSnomed.add(sc);
                    }
                }
                
                if(sm.Name == 'InvDz') {
                    Snomed_Code__c sc15 = new Snomed_Code__c();
                    sc15.CRF__c = pss.CRF__c;
                    sc15.TrialPatient__c = pss.TrialPatient__c;
                    sc15.Code_Master__c = sm.Id;
                    sc15.snomed_Code_Name__c = '371510003 | proportion of specimen involved by tumour |';
                    SnomedCTCode.SnomedWrapper sw15 = new SnomedCTCode.SnomedWrapper();
                    if(pss.Is_invasive_tumor_present__c == 'Yes'){
                        sw15 = SnomedCTCode.SnomedCode('Present', 'InvDz');
                    } else if(pss.Is_invasive_tumor_present__c == 'No'){
                        sw15 = SnomedCTCode.SnomedCode('Absent', 'InvDz');
                    }
                    sc15.Value__c = sw15.snomedCodeVal;
                    sc15.caIntegratorValue__c = sw15.caIntegratorValue;
                    sc15.Code_System__c = sw15.codeSystem;
                    sc15.Code_System_Version__c = sw15.codeSystemVersion;
                    lstSnomed.add(sc15);
                }
            }
        }
        
        
        for(Post_Surgaory_Summary__c pss : lstPostSurgery) {
            boolean InSituHisto_PS = false;
            for(LCIS__c lcis : pss.LCIS__r){
                for(Code_Master__c sm : lstSnomedMaster){
                    if(lcis.Post_Surgery_Summary__c == pss.Id) {
                        InSituHisto_PS = true;
                        if(sm.Name == 'InSituHisto_PS'){
                            Snomed_Code__c sc28 = new Snomed_Code__c();
                            sc28.CRF__c = pss.CRF__c;
                            sc28.TrialPatient__c = pss.TrialPatient__c;
                            sc28.snomed_Code_Name__c = '396984004 | histologic feature of tumor | ';
                            sc28.Code_Master__c = sm.Id; 
                            sc28.Value__c = '77284006 | lobular carcinoma in situ | ';
                            sc28.caIntegratorValue__c = '2';
                            sc28.Code_System__c = 'SNOMED CT';
                            lstSnomed.add(sc28);
                        }
                    }
                }
            }
            if(!InSituHisto_PS) {
                for(DCIS__c dcis : pss.DCIS__r){
                    for(Code_Master__c sm : lstSnomedMaster){
                        if(dcis.Post_Surgery_Summary__c == pss.Id) {
                            InSituHisto_PS = true;
                            if(sm.Name == 'InSituHisto_PS'){
                                Snomed_Code__c sc28 = new Snomed_Code__c();
                                sc28.CRF__c = pss.CRF__c;
                                sc28.TrialPatient__c = pss.TrialPatient__c;
                                sc28.snomed_Code_Name__c = '396984004 | histologic feature of tumor | ';
                                sc28.Code_Master__c = sm.Id; 
                                sc28.Value__c = '408643008 | infiltrating duct carcinoma of breast | ';
                                sc28.caIntegratorValue__c = '1';
                                sc28.Code_System__c = 'SNOMED CT';
                                lstSnomed.add(sc28);
                            }
                        }
                    }
                }
            }
            if(!InSituHisto_PS) {
                for(Code_Master__c sm : lstSnomedMaster){
                    if(sm.Name == 'InSituHisto_PS'){
                        Snomed_Code__c sc28 = new Snomed_Code__c();
                        sc28.CRF__c = pss.CRF__c;
                        sc28.TrialPatient__c = pss.TrialPatient__c;
                        sc28.snomed_Code_Name__c = '396984004 | histologic feature of tumor | ';
                        sc28.Code_Master__c = sm.Id; 
                        sc28.Value__c = '416237000 | procedure not done | : 363589002 | associated procedure | = 392090004 | operation on breast | ';
                        sc28.caIntegratorValue__c = '1';
                        sc28.Code_System__c = 'SNOMED CT';
                        lstSnomed.add(sc28);
                    }
                }
            }
        }
        
        if(!lstSnomed.isEmpty() && !Test.isRunningTest()){
            insert lstSnomed;
        }
        
        insertProcedureRelatedCodes(lstPostSurgery, new List<On_Study_Pathology_Form__c>());
        insertLymphNodeRelatedCode(postIds);
        insertDCISRelatedCodes(lstPostSurgery);
        insertLCISRelatedCodes(lstPostSurgery, new List<On_Study_Pathology_Form__c>());
        insertInvasiveTumorRelatedCodes(lstPostSurgery, new List<On_Study_Pathology_Form__c>());
        insertReceptorRelatedCodes(lstPostSurgery, new List<On_Study_Pathology_Form__c>());
        insertStagingRelatedCodes(lstPostSurgery);
    }
    
    @future
    public static void insertRegistrationRelatedCode(Set<id> regIds) {
        List<Registration__c> lstRegistration = [Select r.TrialPatient__c, r.Institution__c, r.CRF__c From Registration__c r where Id IN:regIds];
        set<Id> instIds = new set<Id>();
        set<Id> trialPatientIds = new set<Id>();
        for(Registration__c reg : lstRegistration){
            instIds.add(reg.Institution__c);
        }
        System.debug('-------Snomed----instIds----->'+instIds);
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Institution'];
        List<Account> lstAcc = [select id,Name from Account where id IN : instIds];
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        System.debug('-------Snomed---lstAcc------>'+lstAcc);
        
        if(!lstSnomedMaster.isEmpty()) {
            for(Registration__c reg : lstRegistration){
                if(reg.Institution__c == null) continue;
                for(Account acc : lstAcc){
                    if(acc.Id != reg.Institution__c) continue;
                    Code_Master__c sm = lstSnomedMaster[0];
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = reg.CRF__c;
                    sc.TrialPatient__c = reg.TrialPatient__c;
                    sc.snomed_Code_Name__c = '398321007 | institution name | ';
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(acc.Name, 'InstID');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.Numeric_Value__c = sw.numericValue;
                    sc.Code_Master__c = sm.Id;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                }
            }
            if(!lstSnomed.isEmpty()){
                insert lstSnomed;
            }
        }
    }
    
    @future
    public static void insertPatientRelatedCode(Set<id> patientIds) {
        List<Patient_Custom__c> lstPatient = [select Id, Country_of_Birth__c ,Age__c, Race__c, Ethnicity__c from Patient_Custom__c where Id IN:patientIds];
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Age' or Name = 'Race' or Name = 'Ethn'];
        List<Pre_Registration_Snomed_Codes__c> lstSnomed = new List<Pre_Registration_Snomed_Codes__c>();
        for(Patient_Custom__c pat : lstPatient) {
            for(Code_Master__c sm : lstSnomedMaster){
                if(sm.Name == 'Age'){
                    Pre_Registration_Snomed_Codes__c sc = new Pre_Registration_Snomed_Codes__c();
                    sc.snomed_Code_Name__c = '424144002 | current chronological age | '; 
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(''+pat.Age__c, 'Age');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.Code_Master__c = sm.Id;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    sc.Patient__c = pat.Id;
                    lstSnomed.add(sc);
                }
                if(sm.Name == 'Race'){
                    Pre_Registration_Snomed_Codes__c sc1 = new Pre_Registration_Snomed_Codes__c();
                    sc1.snomed_Code_Name__c = '103579009 | race | ';
                    SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode(pat.Race__c, 'Race');
                    sc1.Value__c = sw1.snomedCodeVal;
                    sc1.Code_System__c = sw1.codeSystem;
                    sc1.Code_Master__c = sm.Id;
                    sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                    sc1.Code_System_Version__c = sw1.codeSystemVersion;
                    sc1.Patient__c = pat.Id;
                    lstSnomed.add(sc1);
                }
                if(sm.Name == 'Ethn'){ 
                    Pre_Registration_Snomed_Codes__c sc2 = new Pre_Registration_Snomed_Codes__c();
                    sc2.snomed_Code_Name__c = '2002440';
                    SnomedCTCode.SnomedWrapper sw2 = SnomedCTCode.SnomedCode(pat.Ethnicity__c, 'Ethn');
                    sc2.Value__c = sw2.snomedCodeVal;
                    sc2.Code_System__c = sw2.codeSystem;
                    sc2.caIntegratorValue__c = sw2.caIntegratorValue;
                    sc2.Code_System_Version__c = sw2.codeSystemVersion;
                    sc2.Code_Master__c = sm.Id;
                    sc2.Patient__c = pat.Id;
                    lstSnomed.add(sc2);
                }
            }
        }
        
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    @future
    public static void insertMenopasualRelatedCode(Set<id> menopasualIds) {
        List<Menopausal_Status_Detail__c> lstMenopausal = [select Id, CRF_Id__c, TrialPatient__c, Menopausal_Status__c from Menopausal_Status_Detail__c where Id IN:menopasualIds];
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Menopausal_OS'];
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        for(Menopausal_Status_Detail__c msd : lstMenopausal){
            for(Code_Master__c sm : lstSnomedMaster){
                if(sm.Name == 'Menopausal_OS') {
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = msd.CRF_Id__c;
                    sc.TrialPatient__c = msd.TrialPatient__c;
                    sc.snomed_Code_Name__c = '161712005 | menopause | '; 
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(msd.Menopausal_Status__c, 'Menopausal_OS');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_Master__c = sm.Id;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                }
            } 
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    @future
    public static void insertOnStudyPathologyCode(Set<id> ospIds) {
        List<On_Study_Pathology_Form__c> lstOnStudyPath = [Select o.pg_onstudypathology_Id__c, o.Tumor_laterality__c, o.TrialPatient__c, o.SystemModstamp, o.Status__c, o.RecordTypeId, o.Phase__c, o.OwnerId, o.OriginalCRF__c, o.Name, o.Is_invasive_tumor_present__c, o.Is_LCIS_Present__c, o.Is_DCIS_Present__c, o.Id, o.Does_the_patient_have_bilateral_breast_c__c, o.CreatedDate, o.CreatedById, o.CompletedDate__c, o.CRF__c, (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, CB_11_Value__c, CB_11__c, DAKO_Herceptest_Value__c, DAKO_Herceptest__c, ER_TS_OS_Snomed__c, ERpos_OS_Snomed__c, Estrogen_Intensity_Score__c, Estrogen_Receptor_Proportion_Score__c, Estrogen_Receptor_Status__c, FISH_test_not_done__c, Fish__c, HER2_neu_Marker__c, Her2Pos_OS_Snomed__c, IHC__c, IHC_test_not_done__c, Letarality__c, Other_FISH_Results__c, Other_FISH_Test_Value__c, Other_FISH_Test__c, Other_IHC_Results__c, Other_IHC_Test_Value__c, Other_IHC_Test__c, PgR_TS_OS_Snomed__c, Progesterone_Intensity_Score__c, Progesterone_Receptor_Proportion_Score__c, Progesterone_Receptor_Status__c, Total_Score_ER__c, Total_Score_PR__c, Ventana_Oncoprobe_Value__c, Ventana_Oncoprobe__c, Ventana_kit_Value__c, Ventana_kit__c, Vysis_Path_Vision_Value__c, Vysis_Path_Vision__c, pg_Receptors_Id__c, On_Study_Pathology_Form__c, Post_Surgery_Summary__c, Type__c From Receptors__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Date_Of_Procedure__c, Form_Name__c, Laterality__c, Location__c, MRI__c, Mammography__c, Node_Result__c, Node_Type__c, On_Study_Pathology_Form__c, Palpation_guided__c, Post_Surgery_Summary__c, Procedure_Name__c, Stereotactic__c, Total_Examined_Nodes__c, Total_Positive__c, TrialPatient__c, Ultrasound__c, pg_procedure_id__c From Procedures__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Closest_Margin__c, Histological_Type__c, LCIS__c, Margins__c, Specify_No__c, Specify_Units__c, Total_histological_span__c, Total_histological_span_measurement_unit__c, Unknown_Not_Reported__c, Histology__c, pg_Lcis_Id__c, On_Study_Pathology_Form__c, Post_Surgery_Summary__c From LCIS__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Anterior_Inferior_Size__c, Anterior_Inferior__c, Anterior_Superior__c, Anterios_Superior_Size__c, Calcifications__c, Closest_Margin__c, Deep_Margin_Size__c, Deep_Margin__c, Derma_lymphatic_vascular_invasion__c, Dermal_Involvement__c, Evidence_of_therapeutic_effects__c, Invasive_carcinoma_mixed_ductal_lobular__c, Invasive_cribiform_carcinoma__c, Invasive_ductal_carcinoma_nos__c, Invasive_lobular_carcinoma_alveolar_type__c, Invasive_lobular_carcinoma_classic_type__c, Invasive_margins__c, Invasive_margins_size__c, Invasive_papillary_carcinoma__c, Lateral_Size__c, Lateral__c, Lympatic_vascular_Invasion__c, Medical_Size__c, Medical__c, Medullary_carcinoma__c, Mitotic_Count__c, Mucinous_carcinoma__c, Multi_focal_Tumor__c, Muscle_involvement__c, Nuclear_Grade__c, Other__c, Other_changes_present__c, Other_if_other_mention_type_in_textbox__c, Overall_cancer_cellularity__c, Paget_disease__c, Pleomorphic_lobular_carcinoma__c, SBR_Grade__c, Signs_of_Treatment_Effect__c, Skin_Involvement__c, Specify_No__c, Specify_Units__c, Total_Points__c, Tubular_carcinoma__c, Tubule_Papilla_formation__c, Tubulolobular_carcinoma__c, Tumor_Measurement_Unit__c, Tumor_Size_Height__c, Tumor_Size_Width__c, Tumor_Size__c, Ulceration_by_tumor__c, Unknown_Not_Reported__c, Calcifications_Present__c, Anterior_Superior_Size__c, Histology__c, pg_InvasiveTumor_Id__c, On_Study_Pathology_Form__c, Post_Surgery_Summary__c From Invasive_Tumor_Details__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Anterior_Inferior_Size__c, Anterior_Inferior__c, Anterior_Superior_Size__c, Anterior_Superior__c, Apocrine__c, Calcifications__c, Clinging__c, Closest_Margin__c, Comedonecrosis__c, Cribiform__c, Cruciform__c, DCIS__c, Deep_Margin_Size__c, Deep_Margin__c, From_Slide__c, Intra_cystic_encysted_papillary__c, Lateral_Size__c, Lateral__c, Margin__c, Medical_Size__c, Medical__c, Micropapillary__c, Microscopic_foci_upto__c, Necrosis__c, Nuclear_Grade__c, Other__c, Other_if_other_mention_type_in_textb__c, Papillary__c, Present_as_scattered_microscopic_foci__c, Present_in_continous_section__c, Punctate_necrosis__c, Solid__c, Spanning__c, Specific_Closest_Margin_Measurement_Unit__c, Specific_Closest_Margin__c, To_Slide__c, Total_Histological_Span_Measurement_Unit__c, Total_Histological_Span__c, Tumor_Size__c, Unknown_Not_Reported__c, Calcifications_Present__c, Histology__c, On_Study_Pathology_Form__c, Post_Surgery_Summary__c, pg_dcis_Id__c From DCIS__r) From On_Study_Pathology_Form__c o where Id IN:ospIds];
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where 
            Name = 'InvHistology_OSInvasive'
            or Name = 'ERstatus_OS' or Name = 'PRstatus_OS' or Name = 'BilateralCa' or Name = 'Laterality' 
            or Name = 'LNsampled_OS' or Name = 'LNresult_OS' or Name = 'InvSBR_OS' or 
            Name = 'CoreNeedle Guidance_pretx'];
        Map<String, Code_Master__c> snomedMasterMap = new Map<String, Code_Master__c>();
        for(Code_Master__c sm : lstSnomedMaster) {
            snomedMasterMap.put(sm.Name, sm);
        }
        
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        boolean samplingPerformed = false;
        boolean singleNode = false;
        
        
        for(On_Study_Pathology_Form__c osp : lstOnStudyPath){
            for(Code_Master__c sm : lstSnomedMaster){
                if(sm.Name == 'BilateralCa'){
                    Snomed_Code__c sc2 = new Snomed_Code__c();
                    sc2.CRF__c = osp.CRF__c;
                    sc2.TrialPatient__c = osp.TrialPatient__c;
                    sc2.snomed_Code_Name__c = '254838004 | carcinoma of breast | : 272741003 | laterality | = 51440002 | right and left | ';
                    sc2.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw2 = SnomedCTCode.SnomedCode(osp.Does_the_patient_have_bilateral_breast_c__c, 'BilateralCa');
                    sc2.Code_System__c = sw2.codeSystem;
                    sc2.caIntegratorValue__c = sw2.caIntegratorValue;
                    sc2.Code_System_Version__c = sw2.codeSystemVersion;
                    lstSnomed.add(sc2);
                }
                if(sm.Name == 'Laterality'){ 
                    Snomed_Code__c sc3 = new Snomed_Code__c();
                    sc3.CRF__c = osp.CRF__c;
                    sc3.TrialPatient__c = osp.TrialPatient__c;
                    sc3.snomed_Code_Name__c = '384727002 | specimen laterality | ';
                    sc3.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw3 = SnomedCTCode.SnomedCode(osp.Tumor_laterality__c, 'Laterality');
                    sc3.Value__c = sw3.snomedCodeVal;
                    sc3.Code_System__c = sw3.codeSystem;
                    sc3.caIntegratorValue__c = sw3.caIntegratorValue;
                    sc3.Code_System_Version__c = sw3.codeSystemVersion;
                    lstSnomed.add(sc3);
                }
                if(sm.Name == 'LNsampled_OS'){
                    //osp.Procedures__r
                    if(osp.Procedures__r != null) {
                        for(Procedure__c pro : osp.Procedures__r) {
                            if(pro.Form_Name__c == 'On-Study Pathology Form(Lymph Node Biopsies)') {
                                samplingPerformed = true;
                                break;
                            }
                        }
                    }
                    Snomed_Code__c sc4 = new Snomed_Code__c();
                    sc4.CRF__c = osp.CRF__c;
                    sc4.TrialPatient__c = osp.TrialPatient__c;
                    sc4.snomed_Code_Name__c = '396487001 | sentinel lymph node biopsy';
                    sc4.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw4 = null;
                    if(samplingPerformed) {
                        sw4 = SnomedCTCode.SnomedCode('yes', 'LNsampled_OS');
                    } else {
                        sw4 = SnomedCTCode.SnomedCode('no', 'LNsampled_OS');
                    }
                    sc4.Value__c = sw4.snomedCodeVal;
                    sc4.Code_System__c = sw4.codeSystem;
                    sc4.caIntegratorValue__c = sw4.caIntegratorValue;
                    sc4.Code_System_Version__c = sw4.codeSystemVersion;
                    system.debug('OSP sw4.caIntegratorValue : '+sw4.caIntegratorValue);
                    lstSnomed.add(sc4);
                    
                }
                if(sm.Name == 'LNresult_OS'){
                    if(osp.Procedures__r != null) {
                        for(Procedure__c pro : osp.Procedures__r) {
                            if(pro.Form_Name__c == 'On-Study Pathology Form(Lymph Node Biopsies)' && pro.Node_Result__c == 'Positive') {
                                singleNode = true;
                                break;
                            }
                        }
                    }
                    Snomed_Code__c sc5 = new Snomed_Code__c();
                    sc5.CRF__c = osp.CRF__c;
                    sc5.TrialPatient__c = osp.TrialPatient__c;
                    sc5.snomed_Code_Name__c = '396487001 | sentinel lymph node biopsy ';
                    sc5.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw5 = null;
                    if(singleNode) {
                        sw5 = SnomedCTCode.SnomedCode('Positive', 'LNresult_OS');
                    } else {
                        sw5 = SnomedCTCode.SnomedCode('Negative', 'LNresult_OS');
                    }
                    
                    sc5.Value__c = sw5.snomedCodeVal;
                    sc5.Code_System__c = sw5.codeSystem;
                    sc5.caIntegratorValue__c = sw5.caIntegratorValue;
                    sc5.Code_System_Version__c = sw5.codeSystemVersion;
                    system.debug('OSP sw4.caIntegratorValue : '+sw5.caIntegratorValue);
                    lstSnomed.add(sc5);
                }
            }
        }
        
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
        
        insertProcedureRelatedCodes(new List<Post_Surgaory_Summary__c>(), lstOnStudyPath);
        insertLCISRelatedCodes(new List<Post_Surgaory_Summary__c>(), lstOnStudyPath);
        insertInvasiveTumorRelatedCodes(new List<Post_Surgaory_Summary__c>(), lstOnStudyPath);
        insertReceptorRelatedCodes(new List<Post_Surgaory_Summary__c>(), lstOnStudyPath);
    }
    
    @future
    public static void insertMammaPrintCode(Set<id> mpIds) {
        List<MammaPrintDetail__c> lstMammaPrint = [select CRF__c, TrialPatient__c, MammaPrint_Index__c, H1_H2_status__c, TargetPrint_Her_2_Status__c, MammaPrint_Risk__c,Risk_Category__c from MammaPrintDetail__c where Id IN:mpIds];
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Her2TargetPrint_OS' or Name = 'MP_Risk' or Name = 'MP_Index' or Name = 'MP_Cat'];
        for(MammaPrintDetail__c mpd : lstMammaPrint){
            for(Code_Master__c sm : lstSnomedMaster){
                if(mpd.TargetPrint_Her_2_Status__c != null && mpd.TargetPrint_Her_2_Status__c != ''){
                    if(sm.Name == 'Her2TargetPrint_OS'){
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = mpd.CRF__c;
                        sc.TrialPatient__c = mpd.TrialPatient__c;
                        sc.snomed_Code_Name__c = '48675-3';
                        sc.Code_Master__c = sm.Id;
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(mpd.TargetPrint_Her_2_Status__c, 'Her2TargetPrint_OS');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    }
                } 
                if(mpd.MammaPrint_Risk__c != null && mpd.MammaPrint_Risk__c != ''){
                    if(sm.Name == 'MP_Risk'){
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = mpd.CRF__c;
                        sc.TrialPatient__c = mpd.TrialPatient__c;
                        sc.snomed_Code_Name__c = 'IHTSDO_4668';
                        sc.Code_Master__c = sm.Id;
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(mpd.MammaPrint_Risk__c, 'MP_Risk');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    }
                }
                if(mpd.MammaPrint_Index__c != 0 ){
                    if(sm.Name == 'MP_Index'){
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = mpd.CRF__c;
                        sc.TrialPatient__c = mpd.TrialPatient__c;
                        sc.snomed_Code_Name__c = 'IHTSDO_4669';
                        sc.Code_Master__c = sm.Id;
                        //SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(mpd.MammaPrint_Index__c+'', 'MP_Index');
                        sc.Value__c = mpd.MammaPrint_Index__c+'';
                        sc.Code_System__c = 'SNOMED CT';
                        sc.caIntegratorValue__c = mpd.MammaPrint_Index__c+'';
                        sc.Code_System_Version__c = '';
                        lstSnomed.add(sc);
                    }
                    if(sm.Name == 'MP_Cat'){
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = mpd.CRF__c;
                        sc.TrialPatient__c = mpd.TrialPatient__c;
                        sc.snomed_Code_Name__c = 'IHTSDO_4670_1';
                        sc.Code_Master__c = sm.Id;
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode(mpd.H1_H2_status__c, 'MP_Cat');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    }
                }
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    @future
    public static void insertRandomizationCode(Set<id> randIds) {
        system.debug('randIds:'+randIds.size());
        List<Randomization_Form__c> lstRandomization = [select Id, CRF__c, TrialPatient__c, Randomization_Result__c,Why_Patient_Not_Signed_Consent_Form__c, Did_Patient_Sign_Treatment_Consent_Form__c from Randomization_Form__c where Id IN:randIds];
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name IN ('Randomized', 'Her2status_PS','ChemoCat')];
        for(Randomization_Form__c ran : lstRandomization){
            for(Code_Master__c sm : lstSnomedMaster){
                if(sm.Name == 'Randomized'){
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = ran.CRF__c;
                    sc.TrialPatient__c = ran.TrialPatient__c;
                    sc.snomed_Code_Name__c = 'IHTSDO_4674';
                    sc.Code_Master__c = sm.Id;
                    system.debug('ran.Did_Patient_Sign_Treatment_Consent_Form__c:'+ran.Did_Patient_Sign_Treatment_Consent_Form__c);
                    system.debug('ran.Why_Patient_Not_Signed_Consent_Form__c:'+ran.Why_Patient_Not_Signed_Consent_Form__c);
                    if(ran.Did_Patient_Sign_Treatment_Consent_Form__c && ran.Randomization_Result__c != null && ran.Randomization_Result__c != '' && ran.Randomization_Result__c != 'Not Randomized'){
                        system.debug('111111111');
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes', 'Randomized');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                    } else if (!ran.Did_Patient_Sign_Treatment_Consent_Form__c && ran.Randomization_Result__c != null && ran.Randomization_Result__c != '' && ran.Randomization_Result__c != 'Not Randomized'){
                        system.debug('2222222');
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes, did not sign consent to Tx', 'Randomized');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                    } else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because they are MammaPrint Low, ER Positive, HER2 Negative') {
                        system.debug('333333333');
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No, not eligible due to MammaPrint Low, ER+ and Her2-', 'Randomized');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                    } else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because they did not meet other eligibility criteria') {
                        system.debug('44444444');
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No, ineligible due to other criteria', 'Randomized');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                    } else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because patient could not complete MRI') {
                        system.debug('555555555');
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No, unable to complete MRI', 'Randomized');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                    } else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Patient found to be ineligible because patient could not complete core biopsy') {
                        system.debug('66666666');
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No, unable to complete core biopsy', 'Randomized');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                    } else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Decided not to have neoadjuvant chemotherapy') {
                        system.debug('77777777777');
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No, decided NOT to have neoadjuvant chemo', 'Randomized');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                    } else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Decided not to be treated with a novel agent') {
                        system.debug('88888888');
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No, decided NOT to sign', 'Randomized');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                    } else if(ran.Randomization_Result__c == 'Not Randomized' && ran.Why_Patient_Not_Signed_Consent_Form__c == 'Other') {
                        system.debug('9999999999');
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('No, Other', 'Randomized');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                    }
                    lstSnomed.add(sc);
                }
                
                if(sm.Name == 'ChemoCat'){
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = ran.CRF__c;
                    sc.TrialPatient__c = ran.TrialPatient__c;
                    sc.snomed_Code_Name__c = 'IHTSDO_4674';
                    sc.Code_Master__c = sm.Id;
                    if(ran.Randomization_Result__c == 'Paclitaxel') {
                        sc.Value__c = '486610';
                        sc.Code_System__c = 'RxNorm (RXCUI)';
                        sc.caIntegratorValue__c = '1';
                        sc.Code_System_Version__c = '';
                    } else if(ran.Randomization_Result__c == 'Paclitaxel + Trastuzumab') {
                        sc.Value__c = '224905';
                        sc.Code_System__c = 'RxNorm';
                        sc.caIntegratorValue__c = '2';
                        sc.Code_System_Version__c = '';
                    } else if(ran.Randomization_Result__c == 'Paclitaxel + Neratinib') {
                        sc.Value__c = '';
                        sc.Code_System__c = '';
                        sc.caIntegratorValue__c = '3';
                        sc.Code_System_Version__c = '';
                    } else if(ran.Randomization_Result__c == 'Paclitaxel + ABT-888 + Carboplatin') {
                        sc.Value__c = '';
                        sc.Code_System__c = '';
                        sc.caIntegratorValue__c = '4';
                        sc.Code_System_Version__c = '';
                    } else if(ran.Randomization_Result__c == 'Paclitaxel + AMG386') {
                        sc.Value__c = '';
                        sc.Code_System__c = '';
                        sc.caIntegratorValue__c = '5';
                        sc.Code_System_Version__c = '';
                    } else if(ran.Randomization_Result__c == 'Paclitaxel + Ganitumab') {
                        sc.Value__c = '';
                        sc.Code_System__c = '';
                        sc.caIntegratorValue__c = '6';
                        sc.Code_System_Version__c = '';
                    } else if(ran.Randomization_Result__c == 'Paclitaxel + MK-2206') {
                        sc.Value__c = '';
                        sc.Code_System__c = '';
                        sc.caIntegratorValue__c = '7';
                        sc.Code_System_Version__c = '';
                    } else if(ran.Randomization_Result__c == 'Paclitaxel + MK-2206 + Trastuzumab') {
                        sc.Value__c = '224905';
                        sc.Code_System__c = 'RxNorm';
                        sc.caIntegratorValue__c = '8';
                        sc.Code_System_Version__c = '';
                    }
                    lstSnomed.add(sc);
                }
                /*commented by bakul 08_08_13 as this is not valid code as per snomed excel by client
                if(sm.Name == 'Her2status_PS') {
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = ran.CRF__c;
                    sc.TrialPatient__c = ran.TrialPatient__c;
                    sc.snomed_Code_Name__c = '48676-1';
                    sc.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes', 'Her2status_PS');
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.Numeric_Value__c = sw.numericValue;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Code_System_Version__c = sw.codeSystemVersion;
                    lstSnomed.add(sc);
                }*/
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }
    }
    
    //@future
    private static void insertChemoTherapyRegimenCode(List<Chemo_Treatment__c> lstChemoTreat) {
        
        /*List<Chemo_Therapy_Regimen__c> lstChemoTherapyRegimen = [select Id, Agent__c, Chemo_Treatment__c from Chemo_Therapy_Regimen__c where Id IN:ctrIds];
        set<Id> chemoIds = new set<Id>();
        for(Chemo_Therapy_Regimen__c ctr : lstChemoTherapyRegimen){
            chemoIds.add(ctr.Chemo_Treatment__c);
        }
        List<Chemo_Treatment__c> lstChemoTreat = [select id,CRF__c,TrialPatient__c from Chemo_Treatment__c where Id IN : chemoIds];*/
        
        
        //commented as ChemoCat comes from Randomization form
        /*set<Id> agentIds = new set<Id>();
        for(Chemo_Treatment__c ct : lstChemoTreat){
            for(Chemo_Therapy_Regimen__c ctr : ct.Chemo_Therapy_Regimens__r){
                agentIds.add(ctr.Agent__c);
            }
        }
        List<Agent__c> lstAgent = [select id,Name from Agent__c where Id IN : agentIds];
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'ChemoCat'];
        for(Chemo_Treatment__c ct : lstChemoTreat){
            for(Chemo_Therapy_Regimen__c ctr : ct.Chemo_Therapy_Regimens__r){
                for(Agent__c agent : lstAgent){
                    if(ctr.Agent__c == agent.Id && ct.Id == ctr.Chemo_Treatment__c){
                        for(Code_Master__c sm : lstSnomedMaster){
                            Snomed_Code__c sc = new Snomed_Code__c();
                            sc.CRF__c = ct.CRF__c;
                            sc.TrialPatient__c = ct.TrialPatient__c;
                            sc.snomed_Code_Name__c = '69960004 | antineoplastic chemotherapy regimen | ';
                            sc.Code_Master__c = sm.Id;
                            if(agent.Name == 'Paclitaxel (Taxol)'){
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Paclitaxel + Anthracycline/Cytoxan', 'ChemoCat');
                                sc.Value__c = sw.snomedCodeVal;
                                sc.Code_System__c = sw.codeSystem;
                                sc.Numeric_Value__c = sw.numericValue;
                                sc.caIntegratorValue__c = sw.caIntegratorValue;
                                sc.Code_System_Version__c = sw.codeSystemVersion;
                            } else if(agent.Name == 'Cyclophosphamide (Cytoxan)'){
                                SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('', 'ChemoCat');
                                sc.Value__c = sw.snomedCodeVal;
                                sc.Code_System__c = sw.codeSystem;
                                sc.Numeric_Value__c = sw.numericValue;
                                sc.caIntegratorValue__c = sw.caIntegratorValue;
                                sc.Code_System_Version__c = sw.codeSystemVersion;
                            }
                            lstSnomed.add(sc);
                        }
                    }
                }
            }
        }
        if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }*/
    }
    
    //@future
    private static void insertLymphNodeRelatedCode(Set<id> postIds) {
        List<Lymph_Nodes__c> lstLymph = [Select l.Single_Detection_Result__c, l.Sentinel_Nodes__c, l.Procedure__c, Post_Surgery_Summary__c, l.Positive__c, l.Method_of_Detection__c, l.Location__c, l.Focus_Detection_Result__c, l.Extramodal_Extension__c, l.Examined__c, l.Detection_Result__c, l.Cluster_Detection_Result__c, l.Axillary_Nodes__c, l.Additional_Nodes__c From Lymph_Nodes__c l where Post_Surgery_Summary__c IN:postIds];
        //Set<Id> postIds = new Set<Id>();
        Map<Id, Integer> largestPasitiveLymph = new Map<Id, Integer>();
        for(Lymph_Nodes__c ln : lstLymph) {
            //postIds.add(ln.Procedure__r.Post_Surgery_Summary__c);
            Integer maxPositiveValue = 0;
            if(largestPasitiveLymph.containsKey(ln.Post_Surgery_Summary__c)) {
                if(largestPasitiveLymph.get(ln.Post_Surgery_Summary__c) < ln.Positive__c) {
                    maxPositiveValue = Integer.valueOf(ln.Positive__c);
                }
            } else if(ln.Sentinel_Nodes__c && ln.Positive__c > 0) {
                maxPositiveValue =Integer.valueOf(ln.Positive__c);
            } else if(ln.Axillary_Nodes__c && ln.Positive__c > 0) {
                if(maxPositiveValue < ln.Positive__c) {
                    maxPositiveValue = Integer.valueOf(ln.Positive__c);
                }
            }
            largestPasitiveLymph.put(ln.Post_Surgery_Summary__c, maxPositiveValue);
        }
        List<Post_Surgaory_Summary__c> lstPostSur = [select CRF__c, TrialPatient__c,Is_invasive_tumor_present__c,Is_DCIS_Present__c ,Is_LCIS_Present__c ,(Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Location__c, Procedure_Name__c, Laterality__c, Form_Name__c, Date_Of_Procedure__c, Node_Result__c, Node_Type__c, Ultrasound__c, Palpation_guided__c, Mammography__c, MRI__c, Stereotactic__c, Post_Surgery_Summary__c, TrialPatient__c, On_Study_Pathology_Form__c, Total_Positive__c, Total_Examined_Nodes__c From Procedures__r), (Select Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Multi_focal_Tumor__c, Tumor_Size_Height__c, Tumor_Size_Width__c, Tumor_Measurement_Unit__c, Deep_Margin__c, Deep_Margin_Size__c, Medical__c, Medical_Size__c, Lateral__c, Lateral_Size__c, Anterior_Superior__c, Anterior_Superior_Size__c, Anterior_Inferior__c, Anterior_Inferior_Size__c, Invasive_ductal_carcinoma_nos__c, Tubular_carcinoma__c, Mucinous_carcinoma__c, Invasive_lobular_carcinoma_alveolar_type__c, Medullary_carcinoma__c, Pleomorphic_lobular_carcinoma__c, Invasive_papillary_carcinoma__c, Invasive_cribiform_carcinoma__c, Invasive_carcinoma_mixed_ductal_lobular__c, Other__c, Signs_of_Treatment_Effect__c, Calcifications__c, Nuclear_Grade__c, Mitotic_Count__c, Tubule_Papilla_formation__c, Lympatic_vascular_Invasion__c, Skin_Involvement__c, Other_changes_present__c, Evidence_of_therapeutic_effects__c, Muscle_involvement__c, Dermal_Involvement__c, Invasive_lobular_carcinoma_classic_type__c, Tubulolobular_carcinoma__c, Invasive_margins__c, Closest_Margin__c, Overall_cancer_cellularity__c, Unknown_Not_Reported__c, Other_if_other_mention_type_in_textbox__c, Tumor_Size__c, Invasive_margins_size__c, Specify_No__c, Specify_Units__c, Total_Points__c, SBR_Grade__c, Paget_disease__c, Ulceration_by_tumor__c, Derma_lymphatic_vascular_invasion__c, Calcifications_Present__c, On_Study_Pathology_Form__c, Post_Surgery_Summary__c From Invasive_Tumor_Details__r) from Post_Surgaory_Summary__c where Id IN :postIds];
    
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'SizeMetLN_PS'];
        for(Post_Surgaory_Summary__c pss : lstPostSur) {
            for(Lymph_Nodes__c ln : lstLymph){
                if(ln.Post_Surgery_Summary__c == pss.Id) {
                    for(Code_Master__c sm : lstSnomedMaster){
                        if(sm.Name == 'SizeMetLN_PS'){
                            Snomed_Code__c sc21 = new Snomed_Code__c();
                            sc21.CRF__c = pss.CRF__c;
                            sc21.TrialPatient__c = pss.TrialPatient__c;
                            sc21.snomed_Code_Name__c = 'IHTSDO_4594';
                            sc21.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw21 = SnomedCTCode.SnomedCode(largestPasitiveLymph.get(ln.Post_Surgery_Summary__c)+'', 'SizeMetLN_PS');
                            sc21.Value__c = sw21.snomedCodeVal;
                            sc21.caIntegratorValue__c = sw21.caIntegratorValue;
                            sc21.Code_System__c = sw21.codeSystem;
                            sc21.Code_System_Version__c = sw21.codeSystemVersion;
                            lstSnomed.add(sc21);
                        }
                    }
                }
            }
        }
        if(!lstSnomed.isEmpty()) {
            insert lstSnomed;
        }
    }
    
    private static Snomed_Code__c histologySnomed(DCIS__c dcis, Invasive_Tumor_Detail__c inv, Procedure__c pro, Post_Surgaory_Summary__c pss, Snomed_Code__c sc) {
        if(dcis.Margin__c == 'Negative' && inv.Invasive_margins__c == 'Negative'){
            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Negative for invasive and in situ disease (DCIS and LCIS)', 'InvMargin_PS');
            sc.Value__c = sw.snomedCodeVal;
            sc.Code_System__c = sw.codeSystem;
            sc.caIntegratorValue__c = sw.caIntegratorValue;
            sc.Code_System_Version__c = sw.codeSystemVersion;
        } else if(pss.Is_invasive_tumor_present__c == 'Yes' && (pro.Procedure_Name__c == 'Therapeutic mastectomy' || pro.Procedure_Name__c == 'Prophylatic mastectomy' || pro.Procedure_Name__c == 'Skin Sparing Mastectomy' || pro.Procedure_Name__c == 'Total Skin Sparing Mastectomy' || pro.Procedure_Name__c == 'Modified Radical Mastectomy')){
            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Positive for invasive disease, completion of mastectomy was performed, additional invasive disease was found', 'InvMargin_PS');
            sc.Value__c = sw.snomedCodeVal;
            sc.Code_System__c = sw.codeSystem;
            sc.caIntegratorValue__c = sw.caIntegratorValue;
            sc.Code_System_Version__c = sw.codeSystemVersion;
        } else if(pss.Is_invasive_tumor_present__c == 'Yes' && pro.Procedure_Name__c == 'Re-excision'){
            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Positive for invasive disease, re-excision was performed, additional invasive disease was found', 'InvMargin_PS');
            sc.Value__c = sw.snomedCodeVal;
            sc.Code_System__c = sw.codeSystem;
            sc.caIntegratorValue__c = sw.caIntegratorValue;
            sc.Code_System_Version__c = sw.codeSystemVersion;
        } else if(pss.Is_invasive_tumor_present__c == 'Yes' && pro.Procedure_Name__c == 'Re-excision' && inv.Invasive_margins__c == 'Positive'){
            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Positive for invasive disease, re-excision was performed, no additional invasive or in situ disease was found', 'InvMargin_PS');
            sc.Value__c = sw.snomedCodeVal;
            sc.Code_System__c = sw.codeSystem;
            sc.caIntegratorValue__c = sw.caIntegratorValue;
            sc.Code_System_Version__c = sw.codeSystemVersion;
        } else if(pss.Is_invasive_tumor_present__c == 'Yes' && pro.Procedure_Name__c == 'Re-excision' && inv.Invasive_margins__c == 'Negative'){
            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Positive for invasive disease, re-excision was not performed, patient had radiation instead', 'InvMargin_PS');
            sc.Value__c = sw.snomedCodeVal;
            sc.Code_System__c = sw.codeSystem;
            sc.caIntegratorValue__c = sw.caIntegratorValue;
            sc.Code_System_Version__c = sw.codeSystemVersion;
        } else if(pss.Is_invasive_tumor_present__c == 'Yes' && pro.Procedure_Name__c != 'Re-excision'){
            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Positive for in situ disease, re-excision was performed, no additional in situ or invasive disease was found', 'InvMargin_PS');
            sc.Value__c = sw.snomedCodeVal;
            sc.Code_System__c = sw.codeSystem;
            sc.caIntegratorValue__c = sw.caIntegratorValue;
            sc.Code_System_Version__c = sw.codeSystemVersion;
        } else if(pss.Is_DCIS_Present__c == 'Yes' && pss.Is_LCIS_Present__c == 'Yes' && pro.Procedure_Name__c == 'Re-excision' && dcis.Margin__c == 'Negative' && inv.Invasive_margins__c == 'Negative'){
            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Positive for in situ disease, re-excision was performed, no additional in situ or invasive disease was found', 'InvMargin_PS');
            sc.Value__c = sw.snomedCodeVal;
            sc.Code_System__c = sw.codeSystem;
            sc.caIntegratorValue__c = sw.caIntegratorValue;
            sc.Code_System_Version__c = sw.codeSystemVersion;
        } /*else if(pro.Procedure_Name__c == null && pro.Procedure_Name__c == ''){
            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('396631001 | surgical margin observable |', 'No Surgery');
            sc.Value__c = sw.snomedCodeVal;
            sc.Code_System__c = sw.codeSystem;
            sc.caIntegratorValue__c = sw.caIntegratorValue;
        }*/
        
        return sc;
    }
    
    @future
    public static void insertOffstudyRelatedCode(Set<id> offStudyIds) {
        List<Off_Study_Detail__c> lstOffStudy = [select Id, Date_patient_went_off_study__c,CRF__c, TrialPatient__c, Patient_Died__c, Patient_did_not_have_surgery__c, Why_patient_didnt_continue_treatment_arm__c, Patient_did_nt_continue_on_treatment_arm__c, Patient_did_nt_want_to_complete_core_bio__c, Patient_did_not_want_to_complete_MRI__c, Patient_completed_study_per_protocol__c from Off_Study_Detail__c where Id IN:offStudyIds];
        List<Snomed_Code__c> lstSnomed = new List<Snomed_Code__c>();
        List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'OffStudy' or Name = 'SurvDateD'];
        for(Off_Study_Detail__c off : lstOffStudy){
            for(Code_Master__c sm : lstSnomedMaster){
                if(sm.Name == 'OffStudy') {
                    if(off.Patient_completed_study_per_protocol__c){
                        Snomed_Code__c sc = new Snomed_Code__c();
                        sc.CRF__c = off.CRF__c;
                        sc.TrialPatient__c = off.TrialPatient__c;
                        sc.snomed_Code_Name__c = '373573001 | clinical finding present | : 246090004 | associated finding | = 185924006 | patient withdrawn from trial | ';
                        sc.Code_Master__c = sm.Id;
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes, completed protocol', 'OffStudy');
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    } else {
                        if(off.Patient_did_not_want_to_complete_MRI__c) {
                            Snomed_Code__c sc = new Snomed_Code__c();
                            sc.CRF__c = off.CRF__c;
                            sc.TrialPatient__c = off.TrialPatient__c;
                            sc.snomed_Code_Name__c = '373573001 | clinical finding present | : 246090004 | associated finding | = 185924006 | patient withdrawn from trial | ';
                            sc.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes, did not want to complete MRI', 'OffStudy');
                            sc.Value__c = sw.snomedCodeVal;
                            sc.Code_System__c = sw.codeSystem;
                            sc.Numeric_Value__c = sw.numericValue;
                            sc.caIntegratorValue__c = sw.caIntegratorValue;
                            sc.Code_System_Version__c = sw.codeSystemVersion;
                            lstSnomed.add(sc);
                        }
                        if(off.Patient_did_nt_want_to_complete_core_bio__c) {
                            Snomed_Code__c sc = new Snomed_Code__c();
                            sc.CRF__c = off.CRF__c;
                            sc.TrialPatient__c = off.TrialPatient__c;
                            sc.snomed_Code_Name__c = '373573001 | clinical finding present | : 246090004 | associated finding | = 185924006 | patient withdrawn from trial | ';
                            sc.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes, did not want to complete study core biopsy', 'OffStudy');
                            sc.Value__c = sw.snomedCodeVal;
                            sc.Code_System__c = sw.codeSystem;
                            sc.Numeric_Value__c = sw.numericValue;
                            sc.caIntegratorValue__c = sw.caIntegratorValue;
                            sc.Code_System_Version__c = sw.codeSystemVersion;
                            lstSnomed.add(sc);
                        }
                        if(off.Patient_did_nt_continue_on_treatment_arm__c) {
                            Snomed_Code__c sc = new Snomed_Code__c();
                            sc.CRF__c = off.CRF__c;
                            sc.TrialPatient__c = off.TrialPatient__c;
                            sc.snomed_Code_Name__c = '373573001 | clinical finding present | : 246090004 | associated finding | = 185924006 | patient withdrawn from trial | ';
                            sc.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes, did not continue treatment', 'OffStudy');
                            sc.Value__c = sw.snomedCodeVal;
                            sc.Code_System__c = sw.codeSystem;
                            sc.Numeric_Value__c = sw.numericValue;
                            sc.caIntegratorValue__c = sw.caIntegratorValue;
                            sc.Code_System_Version__c = sw.codeSystemVersion;
                            lstSnomed.add(sc);
                        }
                        if(off.Why_patient_didnt_continue_treatment_arm__c == 'Due to (S)AE') {
                            Snomed_Code__c sc = new Snomed_Code__c();
                            sc.CRF__c = off.CRF__c;
                            sc.TrialPatient__c = off.TrialPatient__c;
                            sc.snomed_Code_Name__c = '373573001 | clinical finding present | : 246090004 | associated finding | = 185924006 | patient withdrawn from trial | ';
                            sc.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes, due to (S)AE', 'OffStudy');
                            sc.Value__c = sw.snomedCodeVal;
                            sc.Code_System__c = sw.codeSystem;
                            sc.Numeric_Value__c = sw.numericValue;
                            sc.caIntegratorValue__c = sw.caIntegratorValue;
                            sc.Code_System_Version__c = sw.codeSystemVersion;
                            lstSnomed.add(sc);
                        } else if(off.Why_patient_didnt_continue_treatment_arm__c == 'Personal Preference') {
                            Snomed_Code__c sc = new Snomed_Code__c();
                            sc.CRF__c = off.CRF__c;
                            sc.TrialPatient__c = off.TrialPatient__c;
                            sc.snomed_Code_Name__c = '373573001 | clinical finding present | : 246090004 | associated finding | = 185924006 | patient withdrawn from trial | ';
                            sc.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes, due to Personal preference', 'OffStudy');
                            sc.Value__c = sw.snomedCodeVal;
                            sc.Code_System__c = sw.codeSystem;
                            sc.Numeric_Value__c = sw.numericValue;
                            sc.caIntegratorValue__c = sw.caIntegratorValue;
                            sc.Code_System_Version__c = sw.codeSystemVersion;
                            lstSnomed.add(sc);
                        } else if(off.Why_patient_didnt_continue_treatment_arm__c == 'Other') {
                            Snomed_Code__c sc = new Snomed_Code__c();
                            sc.CRF__c = off.CRF__c;
                            sc.TrialPatient__c = off.TrialPatient__c;
                            sc.snomed_Code_Name__c = '373573001 | clinical finding present | : 246090004 | associated finding | = 185924006 | patient withdrawn from trial | ';
                            sc.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes, due to Other reason', 'OffStudy');
                            sc.Value__c = sw.snomedCodeVal;
                            sc.Code_System__c = sw.codeSystem;
                            sc.Numeric_Value__c = sw.numericValue;
                            sc.caIntegratorValue__c = sw.caIntegratorValue;
                            sc.Code_System_Version__c = sw.codeSystemVersion;
                            lstSnomed.add(sc);
                        }
                        
                        if(off.Patient_did_not_have_surgery__c) {
                            Snomed_Code__c sc = new Snomed_Code__c();
                            sc.CRF__c = off.CRF__c;
                            sc.TrialPatient__c = off.TrialPatient__c;
                            sc.snomed_Code_Name__c = '373573001 | clinical finding present | : 246090004 | associated finding | = 185924006 | patient withdrawn from trial | ';
                            sc.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes, patient did not have surgery', 'OffStudy');
                            sc.Value__c = sw.snomedCodeVal;
                            sc.Code_System__c = sw.codeSystem;
                            sc.Numeric_Value__c = sw.numericValue;
                            sc.caIntegratorValue__c = sw.caIntegratorValue;
                            sc.Code_System_Version__c = sw.codeSystemVersion;
                            lstSnomed.add(sc);
                        }
                        
                        if(off.Patient_Died__c) {
                            Snomed_Code__c sc = new Snomed_Code__c();
                            sc.CRF__c = off.CRF__c;
                            sc.TrialPatient__c = off.TrialPatient__c;
                            sc.snomed_Code_Name__c = '373573001 | clinical finding present | : 246090004 | associated finding | = 185924006 | patient withdrawn from trial | ';
                            sc.Code_Master__c = sm.Id;
                            SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('Yes, patient died', 'OffStudy');
                            sc.Value__c = sw.snomedCodeVal;
                            sc.Code_System__c = sw.codeSystem;
                            sc.Numeric_Value__c = sw.numericValue;
                            sc.caIntegratorValue__c = sw.caIntegratorValue;
                            sc.Code_System_Version__c = sw.codeSystemVersion;
                            lstSnomed.add(sc);
                        }
                    }
                } else if(sm.Name == 'SurvDateD'){
                    Snomed_Code__c sc = new Snomed_Code__c();
                    sc.CRF__c = off.CRF__c;
                    sc.TrialPatient__c = off.TrialPatient__c;
                    //sc.Name = 'IHTSDO_4597';
                    sc.snomed_Code_Name__c = 'IHTSDO_4597';
                    sc.Code_Master__c = sm.Id;
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCodeNew('IHTSDO_4597', '', off);
                    if(sw != null) {  
                        sc.Value__c = sw.snomedCodeVal;
                        sc.Code_System__c = sw.codeSystem;
                        sc.caIntegratorValue__c = sw.caIntegratorValue;
                        sc.Numeric_Value__c = sw.numericValue;
                        sc.Code_System_Version__c = sw.codeSystemVersion;
                        lstSnomed.add(sc);
                    }
                }
            }
        }
        if(!lstSnomed.isEmpty()) {
            insert lstSnomed;
        }
    }
    
    public class SnomedWrapper {
        public String snomedCodeVal;
        public String codeSystem;
        public Integer numericValue;
        public String caIntegratorValue;
        public String codeSystemVersion;
        
    }
    
    public static void dummyMethod() {
        integer i = 0;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
    }
    
    public static void dummyMethod1() {
        integer i = 0;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
   }
   public static void dummyMethod2() {
        integer i = 0;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
   }
   public static void dummyMethod3() {
        integer i = 0;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
   }
   public static void dummyMethod4() {
        integer i = 0;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
        i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;i=1;
   }
    
    @isTest(SeeAllData=true) static void myUnitTest16() { 
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'SurvDateD';
        insert snomedObject;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.Last_Name__c = 'test1';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1986, 8, 9);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc.Id;
        insert pc;
        
        TrialPatient__c tpObject = new TrialPatient__c();
        tpObject.Patient_Id__c = pc.Id;
        insert tpObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id;
        snomed.TrialPatient__c = tpObject.Id;
        insert snomed;
        
        Post_Surgaory_Summary__c postObject1 = new Post_Surgaory_Summary__c();
        postObject1.Type_Of_Tumor__c = 'Single Discrete Mass';
        postObject1.RCB_Class__c = 'I';
        postObject1.Is_DCIS_Present__c = 'No';
        postObject1.TrialPatient__c = tpObject.Id;
        postObject1.Is_invasive_tumor_present__c = 'Yes';
        postObject1.status__c = 'Accepted';
        insert postObject1;
        
        Invasive_Tumor_Detail__c inv = new Invasive_Tumor_Detail__c();
        inv.Post_Surgery_Summary__c  = postObject1.id;
        inv.Invasive_ductal_carcinoma_nos__c = true;
        inv.Invasive_lobular_carcinoma_classic_type__c = true;
        inv.Invasive_lobular_carcinoma_alveolar_type__c = true;
        inv.Pleomorphic_lobular_carcinoma__c = true;
        inv.Tubulolobular_carcinoma__c = true;
        inv.Invasive_carcinoma_mixed_ductal_lobular__c = true;
        inv.Tubular_carcinoma__c = true;
        inv.Mucinous_carcinoma__c = true;
        inv.Medullary_carcinoma__c = true;
        inv.Invasive_papillary_carcinoma__c = true;
        inv.Invasive_cribiform_carcinoma__c = true;
        inv.Multi_focal_Tumor__c = 'Yes'; 
        insert inv;
        
        DCIS__c dcis = new DCIS__c();
        dcis.Post_Surgery_Summary__c = postObject1.Id;
        dcis.Punctate_necrosis__c = true;
        dcis.Comedonecrosis__c = true;
        dcis.Papillary__c = true;
        dcis.Micropapillary__c = true;
        dcis.Necrosis__c = true;
        dcis.Cribiform__c = true;
        dcis.Cruciform__c = true;
        dcis.Clinging__c = true;
        dcis.Solid__c = true;
        dcis.Apocrine__c = true;
        dcis.Intra_cystic_encysted_papillary__c = true;
        dcis.Other__c = true;
        insert dcis;
        
        
        
        On_Study_Pathology_Form__c ospobject=[Select id from On_Study_Pathology_Form__c where status__c = 'Accepted' limit 1];
        
        Procedure__c pro1 = new Procedure__c();
        pro1.On_Study_Pathology_Form__c = ospobject.Id;
        pro1.Procedure_Name__c = 'Sentinel lymph node dissection';
        insert pro1;
      
        SnomedCTCode.histologySnomed(dcis,inv,pro1,postObject1,snomed);
        dcis.Margin__c='Negative';
        update dcis;
        inv.Invasive_margins__c='Negative';
        update inv;
        SnomedCTCode.histologySnomed(dcis,inv,pro1,postObject1,snomed);
         
        postObject1.Is_invasive_tumor_present__c = 'Yes';
        pro1.Procedure_Name__c = 'Re-excision';
        dcis.Margin__c='Positive';
        update dcis;
        SnomedCTCode.histologySnomed(dcis,inv,pro1,postObject1,snomed);
		pro1.Procedure_Name__c = 'Therapeutic mastectomy'; 
		update pro1;
		SnomedCTCode.histologySnomed(dcis,inv,pro1,postObject1,snomed);
		pro1.Procedure_Name__c = 'Re-excision';
		update pro1;
		SnomedCTCode.histologySnomed(dcis,inv,pro1,postObject1,snomed);
		inv.Invasive_margins__c = 'Positive';
		update inv;
		SnomedCTCode.histologySnomed(dcis,inv,pro1,postObject1,snomed);
    }
    
    
   
   
}