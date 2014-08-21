public with sharing class TestHarnessService {
    String transId = '';
    public String createPatient(String institution, String site, String trial,List<Patient> lstPatient) {
        List<Patient_Custom__c> lstPatientCust = new List<Patient_Custom__c>();
        Map<String, String> mapRecordType = getObjectRecordType('Patient_Custom__c');
        system.debug('mapRecordType : '+mapRecordType);
        Set<String> avlRestHarnessIds = new Set<String>();
        String dupTestHarnessIds = '';
        List<Patient_Custom__c> lstPC = [select Id, TestHarnessId__c from Patient_Custom__c where IsTestHarnessPatient__c = true];
        for(Patient_Custom__c pc : lstPC) {
            avlRestHarnessIds.add(pc.TestHarnessId__c);
        }
        for(Patient patient : lstPatient) {
            Patient_Custom__c pc = new Patient_Custom__c();
            if(patient.TestHarnessId != null && patient.TestHarnessId != '') {
                pc.TestHarnessId__c = patient.TestHarnessId;    
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide TestHarnessID (Unique identifier for patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            pc.First_Name__c = patient.FirstName;
            pc.Middle_Name__c = patient.MiddleName;
            pc.Last_Name__c = patient.LastName;
            pc.Suffix__c = patient.Suffix;
            pc.Gender__c = patient.Gender;
            String birthDate = patient.Birthdate;
            if(birthDate != null) {
                List<String> lstDate = birthDate.split('/');
                if(lstDate != null && lstDate.size() == 3) {
                    pc.Birthdate__c = Date.newinstance(Integer.valueOf(lstDate[2]), Integer.valueOf(lstDate[1]), Integer.valueOf(lstDate[0]));
                }
            }
            
            pc.Address_Line_1__c = patient.AddressLine1;
            pc.Address_Line_2__c = patient.AddressLine2;
            pc.City__c = patient.City;
            pc.State__c = patient.State;
            pc.Country__c = patient.Country;
            pc.Zip__c = patient.Zip;
            pc.Race__c = patient.Race;
            pc.Ethnicity__c = patient.Ethnicity;
            pc.Medical_Record_Number__c = patient.MedicalRecordNumber;
            pc.Country_of_Birth__c = patient.CountryOfBirth;
            
            pc.Institution__c = institution;
            String compDate = patient.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                    pc.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
            pc.Status__c = patient.Status;
            system.debug('pc.Status__c : '+pc.Status__c);
            if(pc.Status__c == 'Completed' || pc.Status__c == 'Not Completed'){
                pc.RecordTypeId = mapRecordType.get('Live');
            } else {
                pc.RecordTypeId = mapRecordType.get('Approval Pending');                
            } 
            system.debug('pc.RecordTypeId : '+pc.RecordTypeId);
            pc.IsTestHarnessPatient__c = true;
            if(avlRestHarnessIds.contains(patient.TestHarnessId)) {
                dupTestHarnessIds += patient.TestHarnessId+', ';    
            } else {
                lstPatientCust.add(pc);
            }
        }
        if(dupTestHarnessIds.length() > 0) {
            dupTestHarnessIds = dupTestHarnessIds.subString(0, dupTestHarnessIds.length() - 2);
        }
        try {
            insert lstPatientCust;
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            if(errorMsg != null) {
                if(errorMsg.contains('Required fields are missing: [Last Name]: [Last Name] ')) {
                    errorMsg = 'Required field missing - Please provide Last Name.';
                } else if(errorMsg.contains('Required field missing - Please provide Gender.')) {
                    errorMsg = 'Required field missing - Please provide Gender.';
                } else if(errorMsg.contains('Required field missing - Please provide Birthdate.')) {
                    errorMsg = 'Required field missing - Please provide Birthdate.';
                } else if(errorMsg.contains('Birth date must be less then today.')) {
                    errorMsg = 'Birth date must be less then today.';
                } else if(errorMsg.contains('Required field missing - Please provide Race.')) {
                    errorMsg = 'Required field missing - Please provide Race.';
                } else if(errorMsg.contains('Required field missing - Please provide Ethnicity.')) {
                    errorMsg = 'Required field missing - Please provide Ethnicity.';
                }
            }
            transId = insertErrorLog('Failure : '+errorMsg);
            lstPatientCust.clear();
            return transId;
        }
        String logMsg = 'Sucess : ' + lstPatientCust.size() +' record inserted.';
        if(dupTestHarnessIds.length() > 0) {
            logMsg += '<br /> '+dupTestHarnessIds+' are already available in the database.';
        }
        transId = insertErrorLog(logMsg);
        return transId;
    }
    
    public String createPreEligibilityCheckList(String institution, String site, String trial, List<PreEligibilityCRF> lstPreEligibilityCRF) {
        
        List<PreEligibility_Checklist__c> lstPreEligibility = new List<PreEligibility_Checklist__c>();
        Set<String> testHarnessIds = new Set<String>();
        for(PreEligibilityCRF preEle : lstPreEligibilityCRF) {
            testHarnessIds.add(preEle.PatientId);
        }
        Map<String, String> mapRecordType = getObjectRecordType('PreEligibility_Checklist__c');
        List<Patient_Custom__c> lstPatient = [Select p.TestHarnessId__c, p.Id From Patient_Custom__c p where TestHarnessId__c IN :testHarnessIds and IsTestHarnessPatient__c = true and Institution__c = :institution];
        Map<String, Patient_Custom__c> mapPatient = new Map<String, Patient_Custom__c>();
        
        for(Patient_Custom__c pat : lstPatient) {
            mapPatient.put(pat.TestHarnessId__c, pat);
        }
        
        for(PreEligibilityCRF preEligiblityCRF : lstPreEligibilityCRF) {
            PreEligibility_Checklist__c preEligibility = new PreEligibility_Checklist__c();
            system.debug('mapPatient.get(preEligiblityCRF.PatientId) : '+mapPatient.get(preEligiblityCRF.PatientId));
            if(mapPatient.get(preEligiblityCRF.PatientId) == null) continue;
            preEligibility.Patient__c = mapPatient.get(preEligiblityCRF.PatientId).Id;  
            preEligibility.Histologically_confirmed_invasive_cancer__c = Boolean.valueOf(preEligiblityCRF.HistologicallyConfirmedInvasiveCancer);
            preEligibility.Clinically_radiologically_measurable__c = Boolean.valueOf(preEligiblityCRF.ClinicallyRadiologicallyMeasurable);
            preEligibility.Cytotoxic_Regiments__c = Boolean.valueOf(preEligiblityCRF.CytotoxicRegiments);
            preEligibility.X30_Days_Investigational_Agents__c = Boolean.valueOf(preEligiblityCRF.X30DaysInvestigationalAgents);
            preEligibility.Not_had_prior_RT__c = Boolean.valueOf(preEligiblityCRF.NotHadPriorRT);
            preEligibility.Patient_is_18_years_or_older__c = Boolean.valueOf(preEligiblityCRF.PatientIs18yearsOrOlder);
            preEligibility.Non_Pregnant_Not_Lactating__c = Boolean.valueOf(preEligiblityCRF.NonPregnantNotLactating);   
            preEligibility.Ferromegnatic_Prostheses__c = Boolean.valueOf(preEligiblityCRF.NoFerromegnaticProstheses);
            preEligibility.Patient_is_willing_to_have_core_biospy__c = Boolean.valueOf(preEligiblityCRF.WillingToHaveCoreBiospy);
            preEligibility.Patient_is_willin_to_have_study_MRI__c = Boolean.valueOf(preEligiblityCRF.WillinToHaveStudyMRI);
            preEligibility.ECOG_Score__c = preEligiblityCRF.ECOGScore;
            preEligibility.Patient_signed_up_for_I_SPY2_screening__c = Boolean.valueOf(preEligiblityCRF.PatientSignedUpISPY2Screening);
            preEligibility.Reason_for_not_signing_screening_consent__c = preEligiblityCRF.ReasonNotSigningScreeningConsent;
            
            String compDate = preEligiblityCRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                    preEligibility.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
            preEligibility.Status__c = preEligiblityCRF.Status;
            if(preEligibility.Status__c == 'Completed' || preEligibility.Status__c == 'Not Completed'){
                preEligibility.RecordTypeId = mapRecordType.get('Live');
            } else {
                preEligibility.RecordTypeId = mapRecordType.get('Approval Pending');                
            } 
            lstPreEligibility.add(preEligibility);
        }
        try {
            insert lstPreEligibility;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstPreEligibility.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstPreEligibility.size() +' row inserted.');
        return transId;
    }
    
    public String createRegistration(String institution, String site, String trial,List<PatientRegistration> lstPatientReg) {
        List<Registration__c> lstRegistration = new List<Registration__c>();
        Map<String, String> mapRecordType = getObjectRecordType('Registration__c');
        
        Set<String> testHarnessIds = new Set<String>();
        for(PatientRegistration patReg : lstPatientReg) {
            testHarnessIds.add(patReg.PatientId);
        }
        
        List<Patient_Custom__c> lstPatient = [Select p.TestHarnessId__c, p.Id From Patient_Custom__c p where TestHarnessId__c IN :testHarnessIds and IsTestHarnessPatient__c = true and Institution__c = :institution];
        Map<String, Patient_Custom__c> mapPatient = new Map<String, Patient_Custom__c>();
        
        for(Patient_Custom__c pat : lstPatient) {
            mapPatient.put(pat.TestHarnessId__c, pat);
        }
        
        for(PatientRegistration patReg : lstPatientReg) {
            Registration__c reg = new Registration__c();
            
            system.debug('mapPatient.get(patReg.PatientId) : '+mapPatient.get(patReg.PatientId));
            if(mapPatient.get(patReg.PatientId) == null) continue;
            reg.Patient__c = mapPatient.get(patReg.PatientId).Id;   
            
            String birthDate = patReg.regDate;
            if(birthDate != null) {
                List<String> lstDate = birthDate.split('/');
                if(lstDate != null && lstDate.size() == 3) {
                    reg.Registration_Date__c = Date.newinstance(Integer.valueOf(lstDate[2]), Integer.valueOf(lstDate[1]), Integer.valueOf(lstDate[0]));
                } else {
                    reg.Registration_Date__c = null;
                }
            }
            //reg.ACRIN_6693_MRS_Participant__c = patReg.hasPatientParticipateInRepeatMRIScan;
            String irbDate = patReg.IRBApprovalDate;
            if(irbDate != null) {
                List<String> lstIRBDate = irbDate.split('/');
                if(lstIRBDate != null && lstIRBDate.size() == 3) {
                    reg.IRB_Approval_Date__c = Date.newinstance(Integer.valueOf(lstIRBDate[2]), Integer.valueOf(lstIRBDate[1]), Integer.valueOf(lstIRBDate[0]));
                }
            }
            
            String consentDate = patReg.ScreeningConsentDate;
            if(consentDate != null) {
                List<String> lstConsentDate = consentDate.split('/');
                if(lstConsentDate != null && lstConsentDate.size() == 3) {
                    reg.Screening_Informed_Consent_Date__c = Date.newinstance(Integer.valueOf(lstConsentDate[2]), Integer.valueOf(lstConsentDate[1]), Integer.valueOf(lstConsentDate[0]));
                }
            }
            
            String hippaDate = patReg.HIPPAConsentDate;
            if(hippaDate != null) {
                List<String> lstHippaDate = hippaDate.split('/');
                if(lstHippaDate != null && lstHippaDate.size() == 3) {
                    //reg.HIPPA_Consent_Date__c = Date.newinstance(Integer.valueOf(lstHippaDate[2]), Integer.valueOf(lstHippaDate[1]), Integer.valueOf(lstHippaDate[0]));
                    reg.HIPPA_Consent_Date__c = system.today();
                }
            }
            reg.Institution__c = institution;
            reg.Site__c = site;
            reg.Trial__c = trial;
            //reg.Patient__c = mapPatientId.get(patReg.PatientOrderNumber);
            //reg.Patient__c = patReg.patientId;
            
            String compDate = patReg.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                    reg.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
            reg.Status__c = patReg.Status;
            if(reg.Status__c == 'Completed' || reg.Status__c == 'Not Completed'){
                reg.RecordTypeId = mapRecordType.get('Live');
            } else {
                reg.RecordTypeId = mapRecordType.get('Approval Pending');               
            } 
            lstRegistration.add(reg);
        }
        try {
            insert lstRegistration;
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            if(errorMsg != null) {
                if(errorMsg.contains('Required fields are missing: [Registration Date]: [Registration Date]')) {
                    errorMsg = 'Required fields are missing: Please provide Registration Date';
                } else if(errorMsg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, Date can\'t be in future: [Registration_Date__c]')) {
                    errorMsg = 'Date can\'t be in future: [Registration_Date__c]';
                } else if(errorMsg.contains('Please provide &quot;Has this patient consented to participate in the repeat MRI scans required by the ACRIN 6698 protocol?&quot;')) {
                    errorMsg = 'Required field missing - Please provide "Has this patient consented to participate in the repeat MRI scans required by the ACRIN 6698 protocol?"';
                } else if(errorMsg.contains('Required field missing - Please provide IRB Approval Date.')) {
                    errorMsg = 'Required field missing - Please provide IRB Approval Date.';
                } else if(errorMsg.contains('Required field missing - Please provide Screening Informed Consent Date.')) {
                    errorMsg = 'Required field missing - Please provide Screening Informed Consent Date.';
                } else if(errorMsg.contains('Required field missing - Please provide HIPPA Consent Date.')) {
                    errorMsg = 'Required field missing - Please provide HIPPA Consent Date.';
                }
            }
            transId = insertErrorLog('Failure : '+errorMsg);
            lstRegistration.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstRegistration.size() +' row inserted.');
        return transId;
    }
    
    public String createMenopausalStatus(String institution, String site, String trial, List<MenopausalStatus> lstMenopausalStatus) {
        List<Menopausal_Status_Detail__c> lstMenopausalStatusDetail = new List<Menopausal_Status_Detail__c>();
        Map<String, String> mapRecordType = getObjectRecordType('Menopausal_Status_Detail__c');
        
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
        }
        
        system.debug('mapTrialPatient : '+mapTrialPatient);
        for(MenopausalStatus menopausal : lstMenopausalStatus) {
            Menopausal_Status_Detail__c menopausalDetail = new Menopausal_Status_Detail__c();
            String date1 = menopausal.DateOfLastMenstrualPeriod;
            List<String> lstDate1 = date1.split('/');
            if(lstDate1 != null && lstDate1.size() == 3) {
                menopausalDetail.Date_of_Last_Menstrual_Period__c = Date.newinstance(Integer.valueOf(lstDate1[2]), Integer.valueOf(lstDate1[1]), Integer.valueOf(lstDate1[0]));
            }
            String date2 = menopausal.UnknownDate;
            List<String> lstDate2 = date2.split('/');
            if(lstDate2 != null && lstDate2.size() == 3) {
                menopausalDetail.Date_of_Last_Menstrual_Period__c = Date.newinstance(Integer.valueOf(lstDate2[2]), Integer.valueOf(lstDate2[1]), Integer.valueOf(lstDate2[0]));
            }
            menopausalDetail.Unknown_Date_but_12_Months_Ago__c = Boolean.valueOf(menopausal.UnknownDate12MonthsAgo);
            menopausalDetail.On_Estrogen_Replacement__c = Boolean.valueOf(menopausal.OnEstrogenReplacement);
            menopausalDetail.Enstrogent_Replacement_Duration_Months__c = Decimal.valueOf(menopausal.OnEstrogenReplacementMonths);
            menopausalDetail.Enstrogent_Replacement_Duration_Years__c = Decimal.valueOf(menopausal.OnEstrogenReplacementYears);
            menopausalDetail.Bilateral_oophorectomy__c = Boolean.valueOf(menopausal.BilateralOophorectomy);
            String date3 = menopausal.BilateralOophorectomyDate;
            List<String> lstDate3 = date3.split('/');
            if(lstDate3 != null && lstDate3.size() == 3) {
                menopausalDetail.Bilateral_Oophorectomy_Date__c = Date.newinstance(Integer.valueOf(lstDate3[2]), Integer.valueOf(lstDate3[1]), Integer.valueOf(lstDate3[0]));
            }
            menopausalDetail.Hysterectomy__c = Boolean.valueOf(menopausal.Hysterectomy);
            String date4 = menopausal.HysterectomyDate;
            List<String> lstDate4 = date4.split('/');
            if(lstDate4 != null && lstDate4.size() == 3) {
                menopausalDetail.Hysterectomy_Date__c = Date.newinstance(Integer.valueOf(lstDate4[2]), Integer.valueOf(lstDate4[1]), Integer.valueOf(lstDate4[0]));
            }
            menopausalDetail.Menopausal_Status__c = menopausal.MenopausalStatus;
            if(mapTrialPatient.get(menopausal.PatientId) == null) continue;
            menopausalDetail.TrialPatient__c = mapTrialPatient.get(menopausal.PatientId).Id;
            String compDate = menopausal.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                    menopausalDetail.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
            String status = menopausal.Status;
            menopausalDetail.Status__c = status;
            system.debug('status : '+status);
            if(status == 'Completed' || status == 'Not Completed'){
                system.debug('Record Type : Live');
                menopausalDetail.RecordTypeId = mapRecordType.get('Live');
                system.debug('mapRecordType : '+mapRecordType.get('Live'));
            } else {
                system.debug('Record Type : Approval Pending');
                menopausalDetail.RecordTypeId = mapRecordType.get('Approval Pending');
                system.debug('mapRecordType : '+mapRecordType.get('Approval Pending'));         
            } 
            lstMenopausalStatusDetail.add(menopausalDetail);
        }
        
        try {
            insert lstMenopausalStatusDetail;
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            if(errorMsg != null) {
                if(errorMsg.contains('Required field missing - Please provide Menopausal Status.')) {
                    errorMsg = 'Required field missing - Please provide Menopausal Status.';
                }
            }
            transId = insertErrorLog('Failure : '+errorMsg);
            lstMenopausalStatusDetail.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstMenopausalStatusDetail.size() +' row inserted.');
        return transId;
    }
    
    public String createTissueSpecimen(String institution, String site, String trial, List<TissueSpecimenCRF> lstTissueSpecimen) {
        List<TissueSpecimenDetail__c> lstTissueSpecimenDetail = new List<TissueSpecimenDetail__c>();
        Map<String, String> mapRecordType = getObjectRecordType('TissueSpecimenDetail__c');
        system.debug('inst : '+institution+'    site : '+site+'   trial : '+trial);
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        
        system.debug('lstTrialPatient : '+lstTrialPatient);
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        Map<Id, Id> mapTrialPatient1 = new Map<Id, Id>();
        
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
            mapTrialPatient1.put(trialPatient.Id, trialPatient.Patient_Id__c);
        }
        system.debug('mapTrialPatient : '+mapTrialPatient);
        for(TissueSpecimenCRF tissueSpecimen : lstTissueSpecimen) {
            TissueSpecimenDetail__c ts = new TissueSpecimenDetail__c();
            system.debug('tissueSpecimen.CRFId : '+tissueSpecimen.CRFId);
            if(tissueSpecimen.CRFId != null && tissueSpecimen.CRFId != '') {
                ts.TestHarnessId__c = tissueSpecimen.CRFId; 
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRFID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String proDate = tissueSpecimen.ProcedureDate;
            List<String> lstProDate = proDate.split('/');
            if(lstProDate != null && lstProDate.size() == 3) {
                ts.ProcedureDate__c = Date.newinstance(Integer.valueOf(lstProDate[2]), Integer.valueOf(lstProDate[1]), Integer.valueOf(lstProDate[0]));
            }
            ts.Guidance_Method_s__c = tissueSpecimen.GuidanceMethod;            
            ts.Other_Guidance_Method__c = tissueSpecimen.OtherGuidanceMethod;
            ts.Time_Point__c = tissueSpecimen.TimePoint;
            ts.NumberOfSamplesCollected__c = Decimal.valueOf(tissueSpecimen.NumberOfCoreBiopsyCollected);
            ts.Reason_all_samples_not_collected__c = tissueSpecimen.ReasonAllSampleNotCollected;
            ts.Other_Reason_not_all_samples_collected__c = tissueSpecimen.Other;
            ts.PatientConsentedStudy__c = Boolean.valueOf(tissueSpecimen.PatientConsentedForThisStudy == null?'false':tissueSpecimen.PatientConsentedForThisStudy);
            ts.PatientConsentedOutsideStudy__c = Boolean.valueOf(tissueSpecimen.PatientConsentedForOutSideStudy == null?'false':tissueSpecimen.PatientConsentedForOutSideStudy);
            if(tissueSpecimen.PatientId != null && tissueSpecimen.PatientId != '') {
                if(mapTrialPatient.get(tissueSpecimen.PatientId) != null) {
                    ts.TrialPatient__c = mapTrialPatient.get(tissueSpecimen.PatientId).Id;  
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            
            String compDate = tissueSpecimen.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                    ts.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
            ts.Status__c = tissueSpecimen.Status;
            if(ts.Status__c == 'Completed' || ts.Status__c == 'Not Completed'){
                ts.RecordTypeId = mapRecordType.get('Live');
            } else {
                ts.RecordTypeId = mapRecordType.get('Approval Pending');                
            } 
            lstTissueSpecimenDetail.add(ts);
            
        }
        system.debug('lstTissueSpecimenDetail : '+lstTissueSpecimenDetail);
        try {
            insert lstTissueSpecimenDetail;
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            if(errorMsg != null) {
                if(errorMsg.contains('Required field missing - Please provide procedure Date.')) {
                    errorMsg = 'Required field missing - Please provide procedure Date.';
                } else if(errorMsg.contains('Required field missing - Please provide time point.')) {
                    errorMsg = 'Required field missing - Please provide time point.';
                }
            }
            transId = insertErrorLog('Failure : '+errorMsg);
            lstTissueSpecimenDetail.clear();
            return transId;
        }
        
        transId = insertErrorLog('Sucess :  ' + lstTissueSpecimenDetail.size() +' row inserted.');
        return transId;
    }
    
    public String createCoreBiopsyForTissueSpecimenCRF(String institution, String site, String trial, List<CoreBiopsySpecimen_TSF> lstCoreBiopsyForTSF) {
        List<Core_Biopsy_Specimens__c> lstCoreBiopsy = new List<Core_Biopsy_Specimens__c>();
        
        Set<String> testHarnessIds = new Set<String>();
        for(CoreBiopsySpecimen_TSF coreBiopsy_TSF : lstCoreBiopsyForTSF) {
            testHarnessIds.add(coreBiopsy_TSF.TissueSpecimenCRFId);
        }
        Map<String, Id> mapTissueSpecimenIds = new Map<String, Id>();
        List<TissueSpecimenDetail__c> lstTSF = [select Id, TestHarnessId__c from TissueSpecimenDetail__c where TestHarnessId__c IN :testHarnessIds];
        for(TissueSpecimenDetail__c tsf : lstTSF) {
            mapTissueSpecimenIds.put(tsf.TestHarnessId__c, tsf.Id);
        }
        
        
        for(CoreBiopsySpecimen_TSF coreBiopsy_TSF : lstCoreBiopsyForTSF) {
            Core_Biopsy_Specimens__c cbs = new Core_Biopsy_Specimens__c();
            cbs.Core_Specimen__c = coreBiopsy_TSF.CoreSpecimen;
            cbs.Shipped__c = coreBiopsy_TSF.Shipped;
            cbs.Reason_samples_not_shipped__c = coreBiopsy_TSF.ReasonSamplesNotShipped;
            cbs.Other_Reason_samples_not_shipped__c = coreBiopsy_TSF.OtherReasonSamplesNotShipped;
            
            if(coreBiopsy_TSF.TissueSpecimenCRFId != null && coreBiopsy_TSF.TissueSpecimenCRFId != '') {
                if(mapTissueSpecimenIds.get(coreBiopsy_TSF.TissueSpecimenCRFId) != null) {
                    cbs.TissueSpecimenDetail__c = mapTissueSpecimenIds.get(coreBiopsy_TSF.TissueSpecimenCRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
            lstCoreBiopsy.add(cbs);
        }
        try {
            insert lstCoreBiopsy;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstCoreBiopsy.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstCoreBiopsy.size() +' row inserted.');
        return transId;
    }
    
    public String createBloodSpecimenSamples(String institution, String site, String trial, List<BloodSpecimen_BSF> lstBloodSpecimen_BSF) {
        List<BloodSpecimenInfo__c> lstSamples = new List<BloodSpecimenInfo__c>();
        
        Set<String> testHarnessIds = new Set<String>();
        for(BloodSpecimen_BSF bss : lstBloodSpecimen_BSF) {
            testHarnessIds.add(bss.CRFId);
        }
        Map<String, Id> mapBloodSpecimenIds = new Map<String, Id>();
        List<BloodSpecimenForm__c> lstBSF = [select Id, TestHarnessId__c from BloodSpecimenForm__c where TestHarnessId__c IN :testHarnessIds];
        for(BloodSpecimenForm__c bsf : lstBSF) {
            mapBloodSpecimenIds.put(bsf.TestHarnessId__c, bsf.Id);
        }
        
        for(BloodSpecimen_BSF samples : lstBloodSpecimen_BSF) {
            BloodSpecimenInfo__c bs = new BloodSpecimenInfo__c();
            bs.Name = samples.SpecimenType+' specimen'+' #'+samples.SpecimenNumber;
            bs.Shipped__c = samples.Shipped;
            bs.Reason_samples_not_shipped__c = samples.ReasonSamplesNotShipped;
            bs.Other_Reason_samples_not_shipped__c = samples.OtherReasonSamplesNotShipped;
            
            if(samples.CRFId != null && samples.CRFId != '') {
                if(mapBloodSpecimenIds.get(samples.CRFId) != null) {
                    bs.BloodSpecimenForm__c = mapBloodSpecimenIds.get(samples.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
            lstSamples.add(bs);
        }
        try {
            insert lstSamples;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstSamples.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstSamples.size() +' row inserted.');
        return transId;
    }
    
    public String createBloodSpecimen(String institution, String site, String trial, List<BloodSpecimenCRF> lstBloodSpecimenCRF) {
        List<BloodSpecimenForm__c> lstBloodSpecimenForm = new List<BloodSpecimenForm__c>();
        Map<String, String> mapRecordType = getObjectRecordType('BloodSpecimenForm__c');
        system.debug('inst : '+institution+'    site : '+site+'   trial : '+trial);
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        
        system.debug('lstTrialPatient : '+lstTrialPatient);
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
        }
        
        system.debug('mapTrialPatient : '+mapTrialPatient);
        for(BloodSpecimenCRF bsCRF : lstBloodSpecimenCRF) {
            BloodSpecimenForm__c bs = new BloodSpecimenForm__c();
            
            if(bsCRF.CRFId != null && bsCRF.CRFId != '') {
                bs.TestHarnessId__c = bsCRF.CRFId;  
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRFID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String colDate = bsCRF.CollectionDate;
            List<String> lstColDate = colDate.split('/');
            if(lstColDate != null && lstColDate.size() == 3) {
                bs.CollectionDate__c = Date.newinstance(Integer.valueOf(lstColDate[2]), Integer.valueOf(lstColDate[1]), Integer.valueOf(lstColDate[0]));
            }
            
            bs.Time_Point__c = bsCRF.TimePoint;
            bs.Reason_all_samples_not_collected__c = bsCRF.ReasonallSamplenotCollected;
            bs.Other_Reason_samples_not_shipped__c = bsCRF.Other;
            bs.Consented_to_use_specimen_study__c = Boolean.valueOf(bsCRF.PatientConsentedForThisStudy == null?'false':bsCRF.PatientConsentedForThisStudy);
            bs.Contented_specimen_outside_study__c = Boolean.valueOf(bsCRF.PatientConsentedForOutSideStudy == null?'false':bsCRF.PatientConsentedForOutSideStudy);
            if(bsCRF.PatientId != null && bsCRF.PatientId != '') {
                if(mapTrialPatient.get(bsCRF.PatientId) != null) {
                    bs.TrialPatient__c = mapTrialPatient.get(bsCRF.PatientId).Id;   
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            
            String compDate = bsCRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                    bs.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
            bs.Status__c = bsCRF.Status;
            if(bs.Status__c == 'Completed' || bs.Status__c == 'Not Completed'){
                bs.RecordTypeId = mapRecordType.get('Live');
            } else {
                bs.RecordTypeId = mapRecordType.get('Approval Pending');                
            } 
            lstBloodSpecimenForm.add(bs);
            
        }
        system.debug('lstBloodSpecimenForm : '+lstBloodSpecimenForm);
        try {
            insert lstBloodSpecimenForm;
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            if(errorMsg != null) {
                if(errorMsg.contains('Required field missing - Please provide procedure Date.')) {
                    errorMsg = 'Required field missing - Please provide procedure Date.';
                } else if(errorMsg.contains('Required field missing - Please provide time point.')) {
                    errorMsg = 'Required field missing - Please provide time point.';
                }
            }
            transId = insertErrorLog('Failure : '+errorMsg);
            lstBloodSpecimenForm.clear();
            return transId;
        }
        
        transId = insertErrorLog('Sucess :  ' + lstBloodSpecimenForm.size() +' row inserted.');
        return transId;
    }
    
    public String createMammaprint(String institution, String site, String trial, List<MammaprintCRF> lstMammaPrintCRF) {
        List<MammaPrintDetail__c> lstMammaPrintDetail = new List<MammaPrintDetail__c>();
        Map<String, String> mapRecordType = getObjectRecordType('MammaPrintDetail__c');
        
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
        }
        
        for(MammaprintCRF mammaPrintCRF : lstMammaPrintCRF) {
            MammaPrintDetail__c mammaPrint = new MammaPrintDetail__c();
            String repDate = mammaPrintCRF.ReportDate;
            List<String> lstRepDate = repDate.split('/');
            if(lstRepDate != null && lstRepDate.size() == 3) {
                mammaPrint.Report_Date__c = Date.newinstance(Integer.valueOf(lstRepDate[2]), Integer.valueOf(lstRepDate[1]), Integer.valueOf(lstRepDate[0]));
            }
            
            String colDate = mammaPrintCRF.SpecimenCollectionDates;
            List<String> lstColDate = colDate.split('/');
            if(lstColDate != null && lstColDate.size() == 3) {
                mammaPrint.Specimen_Collection_Dates__c = Date.newinstance(Integer.valueOf(lstColDate[2]), Integer.valueOf(lstColDate[1]), Integer.valueOf(lstColDate[0]));
            }
            mammaPrint.Specimen_Used__c = mammaPrintCRF.SpecimenUsed;
            mammaPrint.MammaPrint_Risk__c = mammaPrintCRF.MammaPrintRisk;
            mammaPrint.MammaPrint_Index__c = Decimal.valueOf(mammaPrintCRF.MammaPrintIndex);
            mammaPrint.TargetPrint_Her_2_Index__c = Decimal.valueOf(mammaPrintCRF.TargetPrintHER2Index);
            
            if(mammaPrintCRF.PatientId!= null && mammaPrintCRF.PatientId != '') {
                if(mapTrialPatient.get(mammaPrintCRF.PatientId) != null) {
                    mammaPrint.TrialPatient__c = mapTrialPatient.get(mammaPrintCRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String compDate = mammaPrintCRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                    mammaPrint.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
            mammaPrint.Status__c = mammaPrintCRF.Status;
            if(mammaPrint.Status__c == 'Completed' || mammaPrint.Status__c == 'Not Completed'){
                mammaPrint.RecordTypeId = mapRecordType.get('Live');
            } else {
                mammaPrint.RecordTypeId = mapRecordType.get('Approval Pending');                
            } 
            lstMammaPrintDetail.add(mammaPrint);
        }
        try {
            insert lstMammaPrintDetail;
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            if(errorMsg != null) {
                if(errorMsg.contains('Required fields are missing: [Report Date]: [Report Date]')) {
                    errorMsg = 'Required fields are missing - Please provide report date.';
                }
            }
            transId = insertErrorLog('Failure : '+errorMsg);
            lstMammaPrintDetail.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstMammaPrintDetail.size() +' row inserted.');
        return transId;
    }
    
    public String createMRIVolume(String institution, String site, String trial, List<MRIVolumeCRF> lstMRIVolumeCRF) {
        List<MRI_Volume__c> lstMRIVolume = new List<MRI_Volume__c>();
        Map<String, String> mapRecordType = getObjectRecordType('MRI_Volume__c');
        
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
        }
        
        for(MRIVolumeCRF mriVolumeCRF : lstMRIVolumeCRF) {
            MRI_Volume__c mriVolume = new MRI_Volume__c();
            mriVolume.Was_MRI_Readable__c = MRIVolumeCRF.WasMRIReadable;
            String dateString = MRIVolumeCRF.DataOfMRIScan;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
                mriVolume.MRI_Scan_Date__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }
            mriVolume.Time_Point__c = MRIVolumeCRF.TimePoint;
            system.debug('MRIVolumeCRF.MRIVolumeInCM : '+MRIVolumeCRF.MRIVolumeInCM);
            if(MRIVolumeCRF.MRIVolumeInCM != null && MRIVolumeCRF.MRIVolumeInCM != '') {
                mriVolume.MRI_Volume_in_cm3__c = Decimal.valueOf(MRIVolumeCRF.MRIVolumeInCM);
            }
            mriVolume.Laterality__c = MRIVolumeCRF.Laterality;
            if(MRIVolumeCRF.LongestDiameterOfIndexLesion != null  && MRIVolumeCRF.LongestDiameterOfIndexLesion != '') {
                mriVolume.Longest_Diameter_Of_Index_Lesion_in_cm__c = Decimal.valueOf(MRIVolumeCRF.LongestDiameterOfIndexLesion);
            }
            mriVolume.Seprate_masses_or_enhancements_reported__c = MRIVolumeCRF.AreSeparateMassesOrEnhancementsReported;
            
            if(mriVolumeCRF.PatientId != null && mriVolumeCRF.PatientId != '') {
                if(mapTrialPatient.get(mriVolumeCRF.PatientId) != null) {
                    mriVolume.TrialPatient__c = mapTrialPatient.get(mriVolumeCRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String compDate = mriVolumeCRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                    mriVolume.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
            mriVolume.Status__c = mriVolumeCRF.Status;
            if(mriVolume.Status__c == 'Completed' || mriVolume.Status__c == 'Not Completed'){
                mriVolume.RecordTypeId = mapRecordType.get('Live');
            } else {
                mriVolume.RecordTypeId = mapRecordType.get('Approval Pending');             
            } 
            lstMRIVolume.add(mriVolume);
        }
        try {
            insert lstMRIVolume;
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            if(errorMsg != null) {
                if(errorMsg.contains('Required field missing - Please provide Date of MRI scan.')) {
                    errorMsg = 'Required field missing - Please provide Date of MRI scan.';
                } else if(errorMsg.contains('Required field missing - Please provide time point.')) {
                    errorMsg = 'Required field missing - Please provide time point.';
                } else if(errorMsg.contains('Required field missing - Please provide Longest Diameter Of Index Lesion (in cm).')) {
                    errorMsg = 'Required field missing - Please provide Longest Diameter Of Index Lesion (in cm).';
                } else if(errorMsg.contains('Required field missing - Please provide MRI Volume (in cm3).')) {
                    errorMsg = 'Required field missing - Please provide MRI Volume (in cm3).';
                } 
            }
            transId = insertErrorLog('Failure : '+errorMsg);
            lstMRIVolume.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstMRIVolume.size() +' row inserted.');
        return transId;
    }
    
    
    
    public String createOnStudyEligibility(String institution, String site, String trial, List<OnStudyEligibilityCRF> lstOSE_CRF) {
        
        List<On_Study_Eligibility_Form__c> lstOSE = new List<On_Study_Eligibility_Form__c>();
        Map<String, String> mapRecordType = getObjectRecordType('On_Study_Eligibility_Form__c');
        
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
        }
        
        for(OnStudyEligibilityCRF OSE_CRF : lstOSE_CRF) {
            On_Study_Eligibility_Form__c ose = new On_Study_Eligibility_Form__c();
            ose.No_Clinical_Or_Imaging_Evidence__c = Boolean.valueOf(OSE_CRF.NoClinicalOrImagingEvidence);
            ose.No_Uncontrolled_or_Cardiovascular_Diseas__c = Boolean.valueOf(OSE_CRF.NoUncontrolledorCardiovascularDiseas);
            ose.No_history_of_allergic_reactions__c = Boolean.valueOf(OSE_CRF.NoHistoryOfAllergicReactions);
            ose.No_uncontrolled_intercurrent_illness__c = Boolean.valueOf(OSE_CRF.NoUncontrolledIntercurrentIllness);
            ose.Not_had_a_sentinel_lymph_node__c = Boolean.valueOf(OSE_CRF.NotHadASentinelLymphNode);
            ose.Lab_Values__c = Boolean.valueOf(OSE_CRF.LabValues);
            ose.Leukocytes_3000_L__c = Boolean.valueOf(OSE_CRF.Leukocytes3000L);
            ose.Absolute_Neutrophil_count_1500_L__c = Boolean.valueOf(OSE_CRF.AbsoluteNeutrophilCount1500L);
            ose.Platelets_100_000_L__c = Boolean.valueOf(OSE_CRF.Platelets100000L);
            ose.Total_Bilirubin_within_institutional__c = Boolean.valueOf(OSE_CRF.TotalBilirubinWithinInstitutional);
            ose.AST_SGOT_or_ALT_SGPT_1_5_x_insti__c = Boolean.valueOf(OSE_CRF.ASTSGOTOrALTSGPT15xinsti);
            ose.Creatinine_1_5_x_institutional_ULN__c = Boolean.valueOf(OSE_CRF.Creatinine15xInstitutionalULN);
            ose.How_was_the_cancer_first_detected__c = OSE_CRF.HowWasTheCancerFirstDetected;
            ose.Is_mass_palpable__c = OSE_CRF.IsMassPalpable;
            ose.Other_Reason_for_Cancer_first_detected__c = OSE_CRF.OtherReasonForCancerFirstDetected; 
            
            String dateString = OSE_CRF.MassIdentificationDate;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
                ose.Mass_Identification_Date__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }
            ose.Screening_Memogram_Prior_to_Mass_Detect__c = Boolean.valueOf(OSE_CRF.ScreeningMemogramPriorToMassDetect);
             
            String dateString1 = OSE_CRF.MostRecentDate;
            List<String> splitedDate1 = dateString1.split('/');
            if(splitedDate1 != null && splitedDate1.size() == 3) {
                ose.Most_Recent_Date__c = Date.newinstance(Integer.valueOf(splitedDate1[2]), Integer.valueOf(splitedDate1[1]), Integer.valueOf(splitedDate1[0]));
            }
            
            if(OSE_CRF.PatientId != null && OSE_CRF.PatientId != '') {
                if(mapTrialPatient.get(OSE_CRF.PatientId) != null) {
                    ose.TrialPatient__c = mapTrialPatient.get(OSE_CRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String compDate = OSE_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                    ose.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
            ose.Status__c = OSE_CRF.Status;
            if(ose.Status__c == 'Completed' || ose.Status__c == 'Not Completed'){
                ose.RecordTypeId = mapRecordType.get('Live');
            } else {
                ose.RecordTypeId = mapRecordType.get('Approval Pending');               
            } 
            lstOSE.add(ose);
        }
        try {
            insert lstOSE;
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            if(errorMsg != null) {
                if(errorMsg.contains('Required field missing - Please provide How was the cancer first detected?.')) {
                    errorMsg = 'Required field missing - Please provide How was the cancer first detected?.';
                }
            }
            transId = insertErrorLog('Failure : '+errorMsg);
            lstOSE.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstOSE.size() +' row inserted.');
        return transId;
    }
    
    public String createOnStudyPathology(String institution, String site, String trial, List<OnStudyPathologyCRF> lstOSP_CRF) {
        
        List<On_Study_Pathology_Form__c> lstOSP = new List<On_Study_Pathology_Form__c>();
        Map<String, String> mapRecordType = getObjectRecordType('On_Study_Pathology_Form__c');
        
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        
        Map<Id, Id> mapTrialPatient1 = new Map<Id, Id>();
        
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
            mapTrialPatient1.put(trialPatient.Id, trialPatient.Patient_Id__c);
        }
        
        for(OnStudyPathologyCRF OSP_CRF : lstOSP_CRF) {
            On_Study_Pathology_Form__c osp = new On_Study_Pathology_Form__c();
            
            if(OSP_CRF.CRFId != null && OSP_CRF.CRFId != '') { 
                osp.TestHarnessId__c = OSP_CRF.CRFId;   
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRFID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            osp.Does_the_patient_have_bilateral_breast_c__c = OSP_CRF.DoesThePatientHaveBilateralBreast;
            osp.Tumor_laterality__c = OSP_CRF.Tumorlaterality;
            osp.Is_DCIS_Present__c = OSP_CRF.IsDCISPresent; // Is_DCIS_Present__c is picklist
            osp.Is_LCIS_Present__c = OSP_CRF.IsLCISPresent; // Is_LCIS_Present__c is picklist
            osp.Is_invasive_tumor_present__c = OSP_CRF.IsInvasiveTumorPresent; // Is_invasive_tumor_present__c is picklist
            
            if(OSP_CRF.PatientId != null && OSP_CRF.PatientId != '') {
                if(mapTrialPatient.get(OSP_CRF.PatientId) != null) {
                    osp.TrialPatient__c = mapTrialPatient.get(OSP_CRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            osp.Status__c = OSP_CRF.Status;
            String compDate = OSP_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                    osp.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
            osp.Status__c = OSP_CRF.Status;
            if(osp.Status__c == 'Completed' || osp.Status__c == 'Not Completed'){
                osp.RecordTypeId = mapRecordType.get('Live');
            } else {
                osp.RecordTypeId = mapRecordType.get('Approval Pending');               
            } 
            lstOSP.add(osp);
        }
        try {
            insert lstOSP;
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            if(errorMsg != null) {
                if(errorMsg.contains('Required field missing - Please provide Does the patient have bilateral breast cancer?')) {
                    errorMsg = 'Required field missing - Please provide Does the patient have bilateral breast cancer?';
                } else if(errorMsg.contains('Required field missing - Please provide Tumor laterality (or side with most advanced disease).')) {
                    errorMsg = 'Required field missing - Please provide Tumor laterality (or side with most advanced disease).';
                }
            }
            transId = insertErrorLog('Failure : '+errorMsg);
            lstOSP.clear();
            return transId;
        }
        String csvResult = 'Patient Id,Does the patient have bilateral breast cancer?,'+
        'Tumor laterality (or side with most advanced disease),Completed Date,Status\n';
        for(On_Study_Pathology_Form__c op : lstOSP) { 
            csvResult += mapTrialPatient1.get(op.TrialPatient__c)+',';
            csvResult += op.Does_the_patient_have_bilateral_breast_c__c+',';
            csvResult += op.Tumor_laterality__c+',';
            csvResult += op.CompletedDate__c+',';
            csvResult += op.Status__c+',';
            csvResult += op.Id+'\n';
        }
        transId = insertErrorLog('Sucess :  ' + lstOSP.size() +' row inserted.', csvResult);
        return transId;
    }
    
    public String createReceptors(String institution, String site, String trial, List<Receptors_OSP_CRF> lstReceptors_OSP_CRF) {
        List<Receptors__c> lstReceptor = new List<Receptors__c>();
        Set<String> ospIds = new Set<String>();
        for(Receptors_OSP_CRF receptorOSP : lstReceptors_OSP_CRF) {
            ospIds.add(receptorOSP.OSPId);
        }
        Map<String, Id> mapOSPIds = new Map<String, Id>();
        List<On_Study_Pathology_Form__c> lstOSP = [select Id, TestHarnessId__c from On_Study_Pathology_Form__c where TestHarnessId__c IN :ospIds];
        for(On_Study_Pathology_Form__c osp : lstOSP) {
            mapOSPIds.put(osp.TestHarnessId__c, osp.Id);
        }
        
        for(Receptors_OSP_CRF receptorOSP : lstReceptors_OSP_CRF) {
            Receptors__c receptor = new Receptors__c();
            
            if(receptorOSP.OSPId != null && receptorOSP.OSPId != '') {
                if(mapOSPIds.get(receptorOSP.OSPId) != null) {
                    receptor.On_Study_Pathology_Form__c = mapOSPIds.get(receptorOSP.OSPId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            receptor.Estrogen_Receptor_Status__c = receptorOSP.ERStatus;
            receptor.Estrogen_Receptor_Proportion_Score__c = receptorOSP.ERProporationScore;
            receptor.Estrogen_Intensity_Score__c = receptorOSP.ERIntensityScore;
            receptor.Progesterone_Receptor_Status__c = receptorOSP.PRStatus;
            receptor.Progesterone_Receptor_Proportion_Score__c= receptorOSP.PRProporationScore;
            receptor.Progesterone_Intensity_Score__c = receptorOSP.PRIntensityScore;
            receptor.IHC__c = receptorOSP.IHC;
            if(receptorOSP.DAKOHerceptest != null) {
                receptor.DAKO_Herceptest__c = true;
                if(receptorOSP.DAKOHerceptest == '1') {
                    receptor.DAKO_Herceptest_Value__c = '+1';   
                } else if(receptorOSP.DAKOHerceptest == '2') {
                    receptor.DAKO_Herceptest_Value__c = '+2';   
                } else if(receptorOSP.DAKOHerceptest == '3') {
                    receptor.DAKO_Herceptest_Value__c = '+3';   
                } else {
                    receptor.DAKO_Herceptest_Value__c = receptorOSP.DAKOHerceptest;
                }   
            }
            receptor.Other_IHC_Results__c = receptorOSP.OtherIHCResult;
            if(receptorOSP.OtherIHCTest != null) {
                receptor.Other_IHC_Test__c = true;
                receptor.Other_IHC_Test_Value__c = receptorOSP.OtherIHCTest;
            }
            if(receptorOSP.VentanaKit != null) {
                receptor.Ventana_kit__c = true;
                if(receptorOSP.VentanaKit == '1') {
                    receptor.Ventana_kit_Value__c = '+1';   
                } else if(receptorOSP.VentanaKit == '2') {
                    receptor.Ventana_kit_Value__c = '+2';   
                } else if(receptorOSP.VentanaKit == '3') {
                    receptor.Ventana_kit_Value__c = '+3';   
                } else {
                    receptor.Ventana_kit_Value__c = receptorOSP.VentanaKit;
                }  
            }
            if(receptorOSP.CB11 != null) {
                receptor.CB_11__c = true;
                if(receptorOSP.CB11 == '1') {
                    receptor.CB_11_Value__c = '+1'; 
                } else if(receptorOSP.CB11 == '2') {
                    receptor.CB_11_Value__c = '+2'; 
                } else if(receptorOSP.CB11 == '3') {
                    receptor.CB_11_Value__c = '+3'; 
                } else {
                    receptor.CB_11_Value__c = receptorOSP.CB11;
                }  
            }
            receptor.IHC_test_not_done__c = Boolean.valueOf(receptorOSP.IHCTestNotDone);
            receptor.Fish__c = receptorOSP.FISH;
            if(receptorOSP.VentanaOncoprobe != null) {
                receptor.Ventana_Oncoprobe__c = true;
                if(receptorOSP.VentanaOncoprobe == '1') {
                    receptor.Ventana_Oncoprobe_Value__c = '+1'; 
                } else if(receptorOSP.VentanaOncoprobe == '2') {
                    receptor.Ventana_Oncoprobe_Value__c = '+2'; 
                } else if(receptorOSP.VentanaOncoprobe == '3') {
                    receptor.Ventana_Oncoprobe_Value__c = '+3'; 
                } else {
                    receptor.Ventana_Oncoprobe_Value__c = receptorOSP.VentanaOncoprobe;
                }  
            }
            if(receptorOSP.OtherFISHTest != null) {
                receptor.Other_FISH_Test__c = true;
                receptor.Other_FISH_Test_Value__c = receptorOSP.OtherFISHTest;
            }
            receptor.Other_FISH_Results__c = receptorOSP.OtherFISHResults;
            receptor.FISH_test_not_done__c = Boolean.valueOf(receptorOSP.FISHTestNotDone);
            system.debug('receptor : '+receptor);
            lstReceptor.add(receptor);
        }
        try {
            insert lstReceptor;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstReceptor.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess : ' + lstReceptor.size() +' row inserted.');
        return transId;
    }
    
    public String createProcedure(String institution, String site, String trial, List<Procedure_OSP_PSS> lstProcedure_OSP_PSS) {
        List<Procedure__c> lstProcedure = new List<Procedure__c>();
        
        Set<String> crfIds = new Set<String>();
        for(Procedure_OSP_PSS pro_OSP : lstProcedure_OSP_PSS) {
            crfIds.add(pro_OSP.CRFId);
        }
        system.debug('crfIds : '+crfIds);
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<On_Study_Pathology_Form__c> lstOSP = [select Id, TestHarnessId__c from On_Study_Pathology_Form__c where TestHarnessId__c IN :crfIds];
        for(On_Study_Pathology_Form__c osp : lstOSP) {
            mapCRFIds.put(osp.TestHarnessId__c, osp.Id);
        }
        
        /*List<Post_Surgaory_Summary__c> lstPSS = [select Id, TestHarnessId__c from Post_Surgaory_Summary__c where TestHarnessId__c IN :crfIds];
        for(Post_Surgaory_Summary__c pss : lstPSS) {
            mapCRFIds.put(pss.TestHarnessId__c, pss.Id);
        }*/
        
        for(Procedure_OSP_PSS procedure_OSP : lstProcedure_OSP_PSS) {
            Procedure__c pro = new Procedure__c();
            if(procedure_OSP.FormName == null || procedure_OSP.FormName == '') {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide Form Name (Options : On-Study Pathology Form(Positive Breast Biopsies) / On-Study Pathology Form(Lymph Node Biopsies) / Post Surgery Summary Form ).');
                return transId;
            }
            system.debug('procedure_OSP.CRFId : '+procedure_OSP.CRFId);
            if(procedure_OSP.CRFId != null && procedure_OSP.CRFId != '') {
                String crfId = mapCRFIds.get(procedure_OSP.CRFId);
                if(crfId != null) {
                    system.debug('crfId : '+crfId);
                    if(crfId.startsWith('a0Q')) {
                        pro.On_Study_Pathology_Form__c = crfId;
                    } else {
                        pro.Post_Surgery_Summary__c = crfId;
                    }
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for CRF) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            //pro.is_breast_surgical_procedure__c = Boolean.valueOf(procedure_OSP.isBreastSurgicalProcedure);
            pro.Ultrasound__c = Boolean.valueOf(procedure_OSP.Ultrasound);
            pro.Stereotactic__c = Boolean.valueOf(procedure_OSP.Stereotactic);
            pro.Procedure_Name__c = procedure_OSP.ProcedureName;
            pro.Palpation_guided__c = Boolean.valueOf(procedure_OSP.Palpationguided);
            pro.Node_Type__c = procedure_OSP.NodeType;
            pro.Node_Result__c = procedure_OSP.NodeResult;
            pro.Mammography__c = Boolean.valueOf(procedure_OSP.Mammography);
            pro.MRI__c = Boolean.valueOf(procedure_OSP.MRI);
            pro.Location__c = procedure_OSP.Location;
            pro.Laterality__c = procedure_OSP.Laterality;
            pro.Form_Name__c = procedure_OSP.FormName;
            String proDate = procedure_OSP.DateOfProcedure;
            List<String> lstProDate = proDate.split('/');
            if(lstProDate != null && lstProDate.size() == 3) {
                pro.Date_Of_Procedure__c = Date.newinstance(Integer.valueOf(lstProDate[2]), Integer.valueOf(lstProDate[1]), Integer.valueOf(lstProDate[0]));
            }
            if(procedure_OSP.CRFId.startsWith('a0W')) {
                pro.Total_Positive__c = Decimal.valueOf(procedure_OSP.TotalPositive);
                pro.Total_Examined_Nodes__c = Decimal.valueOf(procedure_OSP.TotalExaminedNodes);
            }
            
            lstProcedure.add(pro);
        }
        try {
            insert lstProcedure;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstProcedure.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstProcedure.size() +' row inserted.');
        return transId; 
    }
    
    public String createDCIS(String institution, String site, String trial, List<DCIS_OSP_CRF> lstDCIS_OSP_CRF) {
        List<DCIS__c> lstDCIS = new List<DCIS__c>();
        
        Set<String> crfIds = new Set<String>();
        for(DCIS_OSP_CRF dcisOSP : lstDCIS_OSP_CRF) {
            crfIds.add(dcisOSP.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<On_Study_Pathology_Form__c> lstOSP = [select Id, TestHarnessId__c from On_Study_Pathology_Form__c where TestHarnessId__c IN :crfIds];
        for(On_Study_Pathology_Form__c osp : lstOSP) {
            mapCRFIds.put(osp.TestHarnessId__c, osp.Id);
        }
        
        /*List<Post_Surgaory_Summary__c> lstOSP = [select Id, TestHarnessId__c from Post_Surgaory_Summary__c where TestHarnessId__c IN :crfIds];
        for(Post_Surgaory_Summary__c osp : lstOSP) {
            mapCRFIds.put(osp.TestHarnessId__c, osp.Id);
        }*/
        
        for(DCIS_OSP_CRF dcisOSP : lstDCIS_OSP_CRF) {
            DCIS__c dcis = new DCIS__c();
            
            if(dcisOSP.CRFId != null && dcisOSP.CRFId != '') {
                String crfId = mapCRFIds.get(dcisOSP.CRFId);
                if(crfId != null) {
                    if(crfId.startsWith('a0Q')) {
                        dcis.On_Study_Pathology_Form__c = crfId;
                    } else {
                        dcis.Post_Surgery_Summary__c = crfId;
                    }
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for CRF) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            dcis.Punctate_necrosis__c = Boolean.valueOf(dcisOSP.PunctateNecrosis);
            dcis.Comedonecrosis__c = Boolean.valueOf(dcisOSP.Comedonecrosis);
            dcis.Papillary__c = Boolean.valueOf(dcisOSP.Papillary);
            dcis.Micropapillary__c = Boolean.valueOf(dcisOSP.Micropapillary);
            dcis.Necrosis__c = Boolean.valueOf(dcisOSP.Necrosis);
            dcis.Cribiform__c = Boolean.valueOf(dcisOSP.Cribiform);
            dcis.Cruciform__c = Boolean.valueOf(dcisOSP.Cruciform);
            dcis.Clinging__c = Boolean.valueOf(dcisOSP.Clinging);
            dcis.Solid__c = Boolean.valueOf(dcisOSP.Solid);
            dcis.Apocrine__c = Boolean.valueOf(dcisOSP.Apocrine);
            dcis.Intra_cystic_encysted_papillary__c = Boolean.valueOf(dcisOSP.IntraCysticEncystedPapillary);
            if(dcisOSP.Other != null) {
                dcis.Other__c = true;
                dcis.Other_if_other_mention_type_in_textb__c = dcisOSP.Other;   
            }
            dcis.Calcifications__c = dcisOSP.Calcifications;
            dcis.Calcifications_Present__c = dcisOSP.CalcificationsPresent;
            dcis.Nuclear_Grade__c = dcisOSP.NuclearGrade;
            
            lstDCIS.add(dcis);
        }
        try {
            insert lstDCIS;
            
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstDCIS.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstDCIS.size() +' row inserted.');
        return transId;
    }
    
    public String createLCIS(String institution, String site, String trial, List<LCIS_OSP_CRF> lstLCIS_OSP_CRF) {
        List<LCIS__c> lstLCIS = new List<LCIS__c>();
        
        Set<String> crfIds = new Set<String>();
        for(LCIS_OSP_CRF lcisOSP : lstLCIS_OSP_CRF) {
            crfIds.add(lcisOSP.CRFId); 
        }
        
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<On_Study_Pathology_Form__c> lstOSP = [select Id, TestHarnessId__c from On_Study_Pathology_Form__c where TestHarnessId__c IN :crfIds];
        for(On_Study_Pathology_Form__c osp : lstOSP) {
            mapCRFIds.put(osp.TestHarnessId__c, osp.Id);
        }
        
        for(LCIS_OSP_CRF lcisOSP : lstLCIS_OSP_CRF) {
            LCIS__c lcis = new LCIS__c();
            
            if(lcisOSP.CRFId != null && lcisOSP.CRFId != '') {
                String crfId = mapCRFIds.get(lcisOSP.CRFId);
                if(crfId != null) {
                    if(crfId.startsWith('a0Q')) {
                        lcis.On_Study_Pathology_Form__c = crfId;
                    } else {
                        lcis.Post_Surgery_Summary__c = crfId;
                    }
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            lcis.Histological_Type__c = lcisOSP.LCISType;
            lstLCIS.add(lcis);
        }
        try {
            insert lstLCIS;
            
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstLCIS.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstLCIS.size() +' row inserted.');
        return transId;
    }
    
    public String createInvasiveTumor(String institution, String site, String trial, List<InvasiveTumor_OSP_PSS> lstInvasiveTumor_OSP_PSS) {
        List<Invasive_Tumor_Detail__c> lstInvTumor = new List<Invasive_Tumor_Detail__c>();
        
        Set<String> crfIds = new Set<String>();
        for(InvasiveTumor_OSP_PSS inv_OSP_PSS : lstInvasiveTumor_OSP_PSS) {
            crfIds.add(inv_OSP_PSS.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<On_Study_Pathology_Form__c> lstOSP = [select Id, TestHarnessId__c from On_Study_Pathology_Form__c where TestHarnessId__c IN :crfIds];
        for(On_Study_Pathology_Form__c osp : lstOSP) {
            mapCRFIds.put(osp.TestHarnessId__c, osp.Id);
        }
        
        /*List<Post_Surgaory_Summary__c> lstPSS = [select Id, TestHarnessId__c from Post_Surgaory_Summary__c where TestHarnessId__c IN :crfIds];
        for(Post_Surgaory_Summary__c pss : lstPSS) {
            mapCRFIds.put(pss.TestHarnessId__c, pss.Id);
        }*/
        
        for(InvasiveTumor_OSP_PSS inv_OSP_PSS : lstInvasiveTumor_OSP_PSS) {
            Invasive_Tumor_Detail__c invTumor = new Invasive_Tumor_Detail__c();
            
            if(inv_OSP_PSS.CRFId != null && inv_OSP_PSS.CRFId != '') {
                String crfId = mapCRFIds.get(inv_OSP_PSS.CRFId);
                if(crfId != null) {
                    if(crfId.startsWith('a0Q')) {
                        invTumor.On_Study_Pathology_Form__c = crfId;
                    } else {
                        invTumor.Post_Surgery_Summary__c = crfId;
                    }
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for CRF) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
            invTumor.Invasive_ductal_carcinoma_nos__c = Boolean.valueOf(inv_OSP_PSS.InvasiveDuctalCarcinomaNos);
            invTumor.Invasive_lobular_carcinoma_classic_type__c = Boolean.valueOf(inv_OSP_PSS.InvasiveLobularCarcinomaClassicType);
            invTumor.Invasive_lobular_carcinoma_alveolar_type__c = Boolean.valueOf(inv_OSP_PSS.InvasiveLobularCarcinomaAlveolarType);
            invTumor.Pleomorphic_lobular_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.PleomorphicLobularCarcinoma);
            invTumor.Tubulolobular_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.TubulolobularCarcinoma);
            invTumor.Invasive_carcinoma_mixed_ductal_lobular__c = Boolean.valueOf(inv_OSP_PSS.InvasiveCarcinomaMixedDuctalAndLobularType);
            invTumor.Tubular_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.TubularCarcinoma);
            invTumor.Mucinous_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.MucinousCarcinoma);
            invTumor.Medullary_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.MedullaryCarcinoma);
            invTumor.Invasive_papillary_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.InvasivePapillaryCarcinoma);
            invTumor.Invasive_cribiform_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.InvasiveCribiformCarcinoma);
            if(inv_OSP_PSS.Other != null) {
                invTumor.Other__c = true;
                invTumor.Other_if_other_mention_type_in_textbox__c = inv_OSP_PSS.Other;
            }
            invTumor.Signs_of_Treatment_Effect__c = Boolean.valueOf(inv_OSP_PSS.SignsOfTreatmentEffect);
            invTumor.Calcifications__c = inv_OSP_PSS.Calcifications;
            invTumor.Calcifications_Present__c = inv_OSP_PSS.CalcificationsPresent;
            invTumor.Nuclear_Grade__c = inv_OSP_PSS.NuclearGrade;
            invTumor.Mitotic_Count__c = inv_OSP_PSS.MitoticCount;
            invTumor.Tubule_Papilla_formation__c = inv_OSP_PSS.TubulePapillaFormation;
            invTumor.Lympatic_vascular_Invasion__c = inv_OSP_PSS.LympaticVascularInvasion;
            invTumor.Skin_Involvement__c = inv_OSP_PSS.SkinInvolvement;
            invTumor.Paget_disease__c = Boolean.valueOf(inv_OSP_PSS.PagetDisease);
            invTumor.Ulceration_by_tumor__c = Boolean.valueOf(inv_OSP_PSS.UlcerationByTumor);
            invTumor.Derma_lymphatic_vascular_invasion__c = Boolean.valueOf(inv_OSP_PSS.DermaLymphaticVascularInvasion);
            lstInvTumor.add(invTumor);
        }
        try {
            insert lstInvTumor;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstInvTumor.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstInvTumor.size() +' row inserted.');
        return transId; 
    }
    
    public String createAEForm(String institution, String site, String trial, List<AEFormCRF> lstAEF_CRF) {
        List<AE_Detail__c> lstAtt = new List<AE_Detail__c>();
        Map<String, String> mapRecordType = getObjectRecordType('AE_Detail__c');
        system.debug('inst : '+institution+'    site : '+site+'   trial : '+trial);
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        
        system.debug('lstTrialPatient : '+lstTrialPatient);
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        Map<Id, Id> mapTrialPatient1 = new Map<Id, Id>();
        
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
            mapTrialPatient1.put(trialPatient.Id, trialPatient.Patient_Id__c);
        }
        system.debug('mapTrialPatient : '+mapTrialPatient);
        for(AEFormCRF AEF_CRF : lstAEF_CRF) {
            AE_Detail__c  AEObj = new AE_Detail__c();
            system.debug('AEF_CRF.CRFId : '+AEF_CRF.CRFId);
            if(AEF_CRF.CRFId != null && AEF_CRF.CRFId != '') {
             AEObj.TestHarnessId__c =AEF_CRF.CRFId; 
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRFID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
            
             String dateString = AEF_CRF.VisitDate;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
          AEObj.Visit_Date__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }
          AEObj.Patient_Hospitalized__c =  Boolean.valueOf(AEF_CRF.PatientHospitalized); 
          AEObj.caAERS_report_filed__c =  Boolean.valueOf(AEF_CRF.caAERSreportfiled);            
            if(AEF_CRF.PatientId != null && AEF_CRF.PatientId != '') {
                if(mapTrialPatient.get(AEF_CRF.PatientId) != null) {
                 AEObj.TrialPatient__c = mapTrialPatient.get(AEF_CRF.PatientId).Id;  
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            
            String compDate = AEF_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                 AEObj.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
         AEObj.Status__c = AEF_CRF.Status;
            if(AEObj.Status__c == 'Completed' ||AEObj.Status__c == 'Not Completed'){
             AEObj.RecordTypeId = mapRecordType.get('Live');
            } else {
             AEObj.RecordTypeId = mapRecordType.get('Approval Pending');                
            } 
          lstAtt.add(AEObj);
            
        }
        try {
            insert lstAtt;
           } catch(Exception e) {
           transId = insertErrorLog('Failure : '+e.getMessage());
         lstAtt.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstAtt.size() +' row inserted.');
        return transId;
    }


public String createToxicity(String institution, String site, String trial, List<Toxicity_OSP_CRF> lstToxicity_OSP_CRF) {
        List<Toxicity__c> toxicityDisplayList = new List<Toxicity__c>();
        
        Set<String> CRFIds = new Set<String>();
        for(Toxicity_OSP_CRF toc_CRF : lstToxicity_OSP_CRF) {
            CRFIds.add(toc_CRF.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<AE_Detail__c> lstAtt =  [select Id, TestHarnessId__c from AE_Detail__c  where TestHarnessId__c IN :CRFIds];
        for(AE_Detail__c AEObj : lstAtt) {
            mapCRFIds.put(AEObj.TestHarnessId__c,AEObj.Id);
        }
        
        
        for(Toxicity_OSP_CRF toxicity_CRF : lstToxicity_OSP_CRF) {
        Toxicity__c toxicityObj = new Toxicity__c();
       toxicityObj.Symptom_Status__c = toxicity_CRF.SymptomStatus;
       toxicityObj.Symptom_Masters__c = toxicity_CRF.SymptomMasters;
       toxicityObj.Toxicity_Master__c = toxicity_CRF.ToxicityAgent;
       toxicityObj.Toxicity_Other__c = toxicity_CRF.ToxicityOther;
       toxicityObj.Toxicity_Status__c = toxicity_CRF.ToxicityStatus;
       toxicityObj.Grade__c = toxicity_CRF.Grade;
       toxicityObj.Attribution__c = toxicity_CRF.Attribution;
       toxicityObj.Was_event_life_threatning__c = Boolean.valueOf(toxicity_CRF.Waseventlifethreatning);
       toxicityObj.Did_event_required_hospitalization__c = Boolean.valueOf(toxicity_CRF.Dideventrequiredhospitalization);
       toxicityObj.Result_persistent_significant_disability__c = Boolean.valueOf(toxicity_CRF.Resultpersistentsignificantdisability);
       toxicityObj.Result_conginental_abnormality_defect__c = Boolean.valueOf(toxicity_CRF.Resultconginentalabnormalitydefect);
       toxicityObj.Did_the_investigator_find_event_unusual__c = Boolean.valueOf(toxicity_CRF.Didtheinvestigatorfindeventunusual);
       toxicityObj.Did_event_result_in_death__c = Boolean.valueOf(toxicity_CRF.Dideventresultindeath);
        String dateString = toxicity_CRF.OnsetDate;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
             toxicityObj.Onset_Date__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }

       toxicityObj.SAE__c = toxicity_CRF.SAE;
       toxicityObj.Resolved__c = Boolean.valueOf(toxicity_CRF.Resolved);
        String dateString1 = toxicity_CRF.AEEndDate;
            List<String> splitedDate1 = dateString1.split('/');
            if(splitedDate1 != null && splitedDate1.size() == 3) {
             toxicityObj.AE_End_Date__c = Date.newinstance(Integer.valueOf(splitedDate1[2]), Integer.valueOf(splitedDate1[1]), Integer.valueOf(splitedDate1[0]));
            }

       toxicityObj.Patient_Complaint__c = toxicity_CRF.PatientComplaint;
         if(toxicity_CRF.CRFId != null && toxicity_CRF.CRFId != '') {
                if(mapCRFIds.get(toxicity_CRF.CRFId) != null) {
                 toxicityObj.AE_Detail__c = mapCRFIds.get(toxicity_CRF.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                 transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
        toxicityDisplayList.add(toxicityObj);
        }
        try {
            insert toxicityDisplayList;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
        toxicityDisplayList.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +toxicityDisplayList.size() +' row inserted.');
        return transId;     
    }     
      
    public String createProtocolViolation(String institution, String site, String trial, List<ProtocolViolationCRF> lstPV_CRF) {
        
        List<ProtocolViolationDetail__c> lstPV = new List<ProtocolViolationDetail__c>();
        Map<String, String> mapRecordType = getObjectRecordType('ProtocolViolationDetail__c');
        
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
        }
        
        for(ProtocolViolationCRF PV_CRF : lstPV_CRF) {
            ProtocolViolationDetail__c  protocolViolation = new ProtocolViolationDetail__c();
            String dateString = PV_CRF.DateOfProtocolViolation;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
               protocolViolation.DateOfProtocolViolation__c= Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }

           protocolViolation.Medication_non_complicance__c = Boolean.valueOf(PV_CRF.Medicationnoncompliance);
           protocolViolation.Visit_non_complicance__c = Boolean.valueOf(PV_CRF.Visitnoncomplicance);
           protocolViolation.On_study_procedure_required_by_protocol__c = Boolean.valueOf(PV_CRF.Onstudyprocedurerequiredbyprotocol);
           protocolViolation.Incorrect_therapy_given_to_patient__c = Boolean.valueOf(PV_CRF.Incorrecttherapygiventopatient);
           protocolViolation.Screening_and_on_study_test_lab_done__c = Boolean.valueOf(PV_CRF.Screeningandonstudytestlabdone);
           protocolViolation.Screening_procedure_required__c = Boolean.valueOf(PV_CRF.Screeningprocedurerequired);
           protocolViolation.Eligibility_criteria_exception__c = Boolean.valueOf(PV_CRF.Eligibilitycriteriaexception);
           protocolViolation.Enrollment_of_ineligeligibleible_patient__c = Boolean.valueOf(PV_CRF.Enrollmentofineligeligibleiblepatient);
           protocolViolation.Patient_became_pregnant_prior_to_surgery__c = Boolean.valueOf(PV_CRF.Patientbecamepregnantpriortosurgery);
           protocolViolation.Other_Violation_Checkbox__c= Boolean.valueOf(PV_CRF.OtherViolationCheckbox);
           protocolViolation.Other_Type_of_Violation__c = PV_CRF.OtherTypeofViolation;
           protocolViolation.Narrative_description__c = PV_CRF.Narrativedescription;
           protocolViolation.Patient_Remains_on_Study__c = Boolean.valueOf(PV_CRF.PatientRemainsonStudy);
           protocolViolation.Patient_withdrawn__c =Boolean.valueOf(PV_CRF.Patientwithdrawn);
           protocolViolation.Other_Action_Checkbox__c =Boolean.valueOf(PV_CRF.OtherActionCheckbox);
           protocolViolation.Other_Action__c =PV_CRF.OtherActionTaken; 
           protocolViolation.Local_IRB_Notified__c =PV_CRF.LocalIRBNotified; 
                   
                    
            if(PV_CRF.PatientId != null &&PV_CRF.PatientId != '') {
                if(mapTrialPatient.get(PV_CRF.PatientId) != null) {
                   protocolViolation.TrialPatient__c = mapTrialPatient.get(PV_CRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String compDate =PV_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                  protocolViolation.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
           protocolViolation.Status__c =PV_CRF.Status;
            if(protocolViolation.Status__c == 'Completed' ||protocolViolation.Status__c == 'Not Completed'){
               protocolViolation.RecordTypeId = mapRecordType.get('Live');
            } else {
               protocolViolation.RecordTypeId = mapRecordType.get('Approval Pending');               
            } 
           lstPV .add(protocolViolation);
        }
        try {
            insert lstPV ;
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            if(errorMsg != null) {
                if(errorMsg.contains('Required field missing - Please provide Date of protocol violation.')) {
                    errorMsg = 'Required field missing - Please provide Date of protocol violation.';
                } else if(errorMsg.contains('Required field missing - Please select at-least one Type of Protocol Violation.')) {
                    errorMsg = 'Required field missing - Please select at-least one Type of Protocol Violation.';
                }
            }
            transId = insertErrorLog('Failure : '+errorMsg);
           lstPV.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstPV.size() +' row inserted.');
        return transId;

        }
     public String createOffStudy(String institution, String site, String trial, List<OffStudyCRF> lstOS_CRF) {
        
        List<Off_Study_Detail__c> lstOS = new List<Off_Study_Detail__c>();
        Map<String, String> mapRecordType = getObjectRecordType('Off_Study_Detail__c');
        
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
        }
        
        for(OffStudyCRF OS_CRF : lstOS_CRF) {
            Off_Study_Detail__c  offStudyObj  = new Off_Study_Detail__c();
              String dateString = OS_CRF.Datepatientwentoffstudy;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
               offStudyObj.Date_patient_went_off_study__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }
           offStudyObj.Patient_completed_study_per_protocol__c = Boolean.valueOf(OS_CRF.Patientcompletedstudyperprotocol);
           offStudyObj.Patient_did_not_want_to_complete_MRI__c = Boolean.valueOf(OS_CRF.PatientdidnotwanttocompleteMRI);
           offStudyObj.Patient_did_nt_want_to_complete_core_bio__c = Boolean.valueOf(OS_CRF.Patientdidntwanttocompletecorebio);
           offStudyObj.Patient_did_nt_continue_on_treatment_arm__c = Boolean.valueOf(OS_CRF.Patientdidntcontinueontreatmentarm);
           offStudyObj.Why_patient_didnt_continue_treatment_arm__c = OS_CRF.Whypatientdidntcontinuetreatmentarm;
           offStudyObj.Treatment_arm_other_reason__c = OS_CRF.Treatmentarmotherreason;
           offStudyObj.Patient_did_not_have_surgery__c = Boolean.valueOf(OS_CRF.Patientdidnothavesurgery);
           offStudyObj.Patient_did_not_have_surgery_reason__c = OS_CRF.Patientdidnothavesurgeryreason;
           offStudyObj.Patient_Died__c = Boolean.valueOf(OS_CRF.PatientDied);
           offStudyObj.Did_patient_withdraw_for_survival__c = OS_CRF.Didpatientwithdrawforsurvival;
           offStudyObj.Patient_withdrew_for_specimens__c = OS_CRF.Patientwithdrewforspecimens;
                      
            if(OS_CRF.PatientId != null && OS_CRF.PatientId != '') {
                if(mapTrialPatient.get(OS_CRF.PatientId) != null) {
                   offStudyObj.TrialPatient__c = mapTrialPatient.get(OS_CRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String compDate =OS_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                    offStudyObj.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
           offStudyObj.Status__c =OS_CRF.Status;
            if(offStudyObj.Status__c == 'Completed' ||offStudyObj.Status__c == 'Not Completed'){
               offStudyObj.RecordTypeId = mapRecordType.get('Live');
            } else {
               offStudyObj.RecordTypeId = mapRecordType.get('Approval Pending');               
            } 
           lstOS.add(offStudyObj);
        }
        try {
            insert lstOS;
        } catch(Exception e) {
           transId = insertErrorLog('Failure : '+e.getMessage());
           lstOS.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstOS.size() +' row inserted.');
        return transId;
    }
    public String createNolongLosttoFollowup(String institution, String site, String trial, List<NolongLosttoFollowupCRF> lstNLLF_CRF) {
       
        List<No_Longer_lost_to_Followup__c> lstNLLF = new List<No_Longer_lost_to_Followup__c>();
        Map<String, String> mapRecordType = getObjectRecordType('No_Longer_lost_to_Followup__c');
       
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
        }
       
        for(NolongLosttoFollowupCRF NLLF_CRF : lstNLLF_CRF) {
            No_Longer_lost_to_Followup__c  NLLFF = new No_Longer_lost_to_Followup__c();
           NLLFF.New_Information__c = NLLF_CRF.NewInformation;
           NLLFF.Survial_Status__c = NLLF_CRF.SurvialStatus;
            String dateString =NLLF_CRF.lastalivedeathdate;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
               NLLFF.last_alive_death_date__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }                     
           if(NLLF_CRF.PatientId != null && NLLF_CRF.PatientId != '') {
                if(mapTrialPatient.get(NLLF_CRF.PatientId) != null) {
                    NLLFF.TrialPatient__c = mapTrialPatient.get(NLLF_CRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
               
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
           
            String compDate = NLLF_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                    NLLFF.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
            NLLFF.Status__c = NLLF_CRF.Status;
            if(NLLFF.Status__c == 'Completed' ||NLLFF.Status__c == 'Not Completed'){
               NLLFF.RecordTypeId = mapRecordType.get('Live');
            } else {
               NLLFF.RecordTypeId = mapRecordType.get('Approval Pending');              
            }
            lstNLLF.add(NLLFF);
        }
        try {
            insert lstNLLF;
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            if(errorMsg != null) {
                if(errorMsg.contains('Required field missing -  End Date must be same as or earlier than today.')) {
                    errorMsg = 'Required field missing -  End Date must be same as or earlier than today.';
                }
            }
            transId = insertErrorLog('Failure : '+errorMsg);
            lstNLLF.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstNLLF.size() +' row inserted.');
        return transId;
    }
     public String createLosttoFollowup(String institution, String site, String trial, List<LosttoFollowupCRF> lstLTF_CRF) {
        
        List<Lost_to_Follow_Up__c> lstLTF = new List<Lost_to_Follow_Up__c>();
        Map<String, String> mapRecordType = getObjectRecordType('Lost_to_Follow_Up__c');
        
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
        }
        
        for(LosttoFollowupCRF LTF_CRF : lstLTF_CRF) {
            Lost_to_Follow_Up__c LFF = new Lost_to_Follow_Up__c();
           LFF.Last_contact_before_2_yrs__c= Boolean.valueOf(LTF_CRF.Lastcontactbefore2yrs);
           String dateString =LTF_CRF.Dateoflastcontact;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
               LFF.Date_of_last_contact__c= Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }
          
          LFF.Social_Sec_Death_Index_Research__c= Boolean.valueOf(LTF_CRF.SocialSecDeathIndexResearch);

           String dateString1 =LTF_CRF.SocialSecDeathIndexResearchDate;
            List<String> splitedDate1 = dateString1.split('/');
            if(splitedDate1!= null && splitedDate1.size() == 3) {
               LFF.Social_Sec_Death_Index_Research_Date__c= Date.newinstance(Integer.valueOf(splitedDate1[2]), Integer.valueOf(splitedDate1[1]), Integer.valueOf(splitedDate1[0]));
            }
          
           LFF.Send_certified_registered_ltr_to_known__c= Boolean.valueOf(LTF_CRF.Sendcertifiedregisteredltrtoknown);
        String dateString2 =LTF_CRF.SendcertifiedregisteredltrDATE;
            List<String> splitedDate2= dateString2.split('/');
            if(splitedDate2 != null && splitedDate2.size() == 3) {
               LFF.Send_certified_registered_ltr_DATE__c= Date.newinstance(Integer.valueOf(splitedDate2[2]), Integer.valueOf(splitedDate2[1]), Integer.valueOf(splitedDate2[0]));
            }

           LFF.Send_certified_registered_ltr_Responce__c=LTF_CRF.SendcertifiedregisteredltrResponse;
                       
            if(LTF_CRF.PatientId != null &&LTF_CRF.PatientId != '') {
                if(mapTrialPatient.get(LTF_CRF.PatientId) != null) {
                   LFF.TrialPatient__c = mapTrialPatient.get(LTF_CRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String compDate =LTF_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                   LFF.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
           LFF.Status__c =LTF_CRF.Status;
            if(LFF.Status__c == 'Completed' ||LFF.Status__c == 'Not Completed'){
               LFF.RecordTypeId = mapRecordType.get('Live');
            } else {
               LFF.RecordTypeId = mapRecordType.get('Approval Pending');               
            } 
           lstLTF .add(LFF);
        }
        try {
            insert lstLTF ;
        } catch(Exception e) {
             transId = insertErrorLog('Failure : '+e.getMessage());
          lstLTF .clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstLTF .size() +' row inserted.');
        return transId;
    }
    
      public String createFollowupForm(String institution, String site, String trial, List<FollowupCRF> lstFF_CRF) {
        
        List<Followup_Form__c> lstFollowupForm = new List<Followup_Form__c>();
        Map<String, String> mapRecordType = getObjectRecordType('Followup_Form__c');
      system.debug('inst : '+institution+'    site : '+site+'   trial : '+trial);
        
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
      system.debug('lstTrialPatient : '+lstTrialPatient);
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
      Map<Id, Id> mapTrialPatient1 = new Map<Id, Id>();

        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
      mapTrialPatient1.put(trialPatient.Id, trialPatient.Patient_Id__c);
        }
        system.debug('mapTrialPatient : '+mapTrialPatient);
        for(FollowupCRF FF_CRF : lstFF_CRF) {
           Followup_Form__c  FF = new Followup_Form__c();
       system.debug('FF_CRF.CRFId : '+FF_CRF.CRFId);
         if(FF_CRF.CRFId != null && FF_CRF.CRFId != '') {
               FF.TestHarnessId__c = FF_CRF.CRFId; 
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRFID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }

          String dateString = FF_CRF.StartDate;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
               FF.Start_Date__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }

            String dateString1 =  FF_CRF.EndDate;
            List<String> splitedDate1 = dateString1.split('/');
            if(splitedDate1 != null && splitedDate1.size() == 3) {
               FF.End_Date__c = Date.newinstance(Integer.valueOf(splitedDate1[2]), Integer.valueOf(splitedDate1[1]), Integer.valueOf(splitedDate1[0]));
            }

           
           
           FF.Patient_doc_clinial_assessment__c = Boolean.valueOf(FF_CRF.Patientdocclinialassessment);
           String dateString2 =FF_CRF.ClinicalassessmentDate;
           FF.Survival_Status__c = FF_CRF.SurvivalStatus;
            List<String> splitedDate2 = dateString2.split('/');
            if(splitedDate2 != null && splitedDate2.size() == 3) {
               FF.Clinical_assessment_Date__c = Date.newinstance(Integer.valueOf(splitedDate2[2]), Integer.valueOf(splitedDate2[1]), Integer.valueOf(splitedDate2[0]));
            }
            FF.Patient_diagnose_with_new__c = Boolean.valueOf(FF_CRF.PatientDiagnoseWithNew);
            
            String dateString3 =FF_CRF.Dates;
            List<String> splitedDate3 = dateString3.split('/');
            if(splitedDate3 != null && splitedDate3.size() == 3) {
               FF.Date__c= Date.newinstance(Integer.valueOf(splitedDate3[2]), Integer.valueOf(splitedDate3[1]), Integer.valueOf(splitedDate3[0]));
            }

            FF.Surgery__c = Boolean.valueOf(FF_CRF.Surgery);
            FF.Surgery_Details__c = FF_CRF.SurgeryDetails;
            FF.Chemotherapy__c = Boolean.valueOf(FF_CRF.Chemotherapy);
            FF.Chemotherapy_Details__c = FF_CRF.ChemotherapyDetails;
            FF.Radiation_Therapy__c = Boolean.valueOf(FF_CRF.RadiationTherapy);
            FF.Radiation_Therapy_Details__c = FF_CRF.RadiationTherapyDetails;
            FF.Hormone_Therapy__c = Boolean.valueOf(FF_CRF.HormoneTherapy);
            FF.Hormone_Therapy_Details__c = FF_CRF.HormoneTherapyDetails;
            FF.Causeof_Death__c = FF_CRF.CauseofDeath;
            FF.Describe_Cause_of_Death__c = FF_CRF.DescribeCauseOfDeath;
            FF.patient_diagnosed_local_progression__c = Boolean.valueOf(FF_CRF.patientdiagnosedlocalprogression); 
            
            String dateString4 =FF_CRF.LocalprogressionDate;
            List<String> splitedDate4 = dateString4.split('/');
            if(splitedDate4 != null && splitedDate4.size() == 3) {
               FF.Local_progression_Date__c= Date.newinstance(Integer.valueOf(splitedDate4[2]), Integer.valueOf(splitedDate4[1]), Integer.valueOf(splitedDate4[0]));
            }

            FF.patient_diagnosed_distant_progression__c = Boolean.valueOf(FF_CRF.patientdiagnoseddistantprogression);
             
            String dateString5 = FF_CRF.DistantprogressionDate;
            List<String> splitedDate5 = dateString5.split('/');
            if(splitedDate5 != null && splitedDate5.size() == 3) {
                FF.Distant_progression_Date__c = Date.newinstance(Integer.valueOf(splitedDate5[2]), Integer.valueOf(splitedDate5[1]), Integer.valueOf(splitedDate5[0]));
            }
            
          FF.Recurrence_progression_information__c = FF_CRF.Recurrenceprogressioninformation;
          FF.Local__c = FF_CRF.Local;
          FF.Distant__c = FF_CRF.Distant;
          FF.Other__c = FF_CRF.Other;
          FF.Patient_received_adjuvant_therapy__c = Boolean.valueOf(FF_CRF.Patientreceivedadjuvanttherapy);
           String dateString6 = FF_CRF.RadiationTherapyStartDate;
            List<String> splitedDate6 = dateString6.split('/');
            if(splitedDate6 != null && splitedDate6.size() == 3) {
                FF.Radiation_Therapy_Start_Date__c = Date.newinstance(Integer.valueOf(splitedDate6[2]), Integer.valueOf(splitedDate6[1]), Integer.valueOf(splitedDate6[0]));
            }

           String dateString7 = FF_CRF.RadiationTherapyEndDate;
            List<String> splitedDate7 = dateString7.split('/');
            if(splitedDate7 != null && splitedDate7.size() == 3) {
                FF.Radiation_Therapy_End_Date__c = Date.newinstance(Integer.valueOf(splitedDate7[2]), Integer.valueOf(splitedDate7[1]), Integer.valueOf(splitedDate7[0]));
            }

          FF.Long_Term_Therapy_for_primary_Trial__c = Boolean.valueOf(FF_CRF.LongTermTherapyforprimaryTrial);
          
          FF.patient_have_a_menstrual_period__c = Boolean.valueOf(FF_CRF.patienthaveamenstrualperiod);
          FF.Date_of_Last_Menstrual_period_UKData12M__c = Boolean.valueOf(FF_CRF.DateofLastMenstrualperiodUKData12M);
          String dateString8 = FF_CRF.DateofLastMenstrualperiod;
            List<String> splitedDate8 = dateString8.split('/');
            if(splitedDate8 != null && splitedDate8.size() == 3) {
                FF.Date_of_Last_Menstrual_period__c = Date.newinstance(Integer.valueOf(splitedDate8[2]), Integer.valueOf(splitedDate8[1]), Integer.valueOf(splitedDate8[0]));
            }

          
          
          FF.On_Estrogen_Replacement__c = Boolean.valueOf(FF_CRF.OnEstrogenReplacement);
          FF.On_Estrogen_Replacement_Months__c =  Decimal.valueOf(FF_CRF.OnEstrogenReplacementMonths);
          FF.On_Estrogen_Replacement_Years__c = Decimal.valueOf(FF_CRF.OnEstrogenReplacementYears);
          FF.Bilateral_oophorectomy__c = Boolean.valueOf(FF_CRF.Bilateraloophorectomy);
          String dateString9 = FF_CRF.BilateraloophorectomyDate;
            List<String> splitedDate9 = dateString9.split('/');
            if(splitedDate9 != null && splitedDate9.size() == 3) {
                FF.Bilateral_oophorectomy_Date__c = Date.newinstance(Integer.valueOf(splitedDate9[2]), Integer.valueOf(splitedDate9[1]), Integer.valueOf(splitedDate9[0]));
            }

          FF.Hysterectomy__c = Boolean.valueOf(FF_CRF.Hysterectomy);
          String dateString10 = FF_CRF.HysterectomyDate;
            List<String> splitedDate10 = dateString10.split('/');
            if(splitedDate10 != null && splitedDate10.size() == 3) {
                FF.Hysterectomy_Date__c = Date.newinstance(Integer.valueOf(splitedDate10[2]), Integer.valueOf(splitedDate10[1]), Integer.valueOf(splitedDate10[0]));
            }

          FF.Menopausal_status__c = FF_CRF.Menopausalstatus;
         
            if(FF_CRF.PatientId != null && FF_CRF.PatientId != '') {
                if(mapTrialPatient.get(FF_CRF.PatientId) != null) {
                    FF.TrialPatient__c = mapTrialPatient.get(FF_CRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String compDate = FF_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                   FF.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
            FF.Status__c = FF_CRF.Status;
            if(FF.Status__c == 'Completed' || FF.Status__c == 'Not Completed'){
                FF.RecordTypeId = mapRecordType.get('Live');
            } else {
                FF.RecordTypeId = mapRecordType.get('Approval Pending');               
            } 
           lstFollowupForm.add(FF);
        }
            try {
            insert lstFollowupForm;
        } catch(Exception e) {
           transId = insertErrorLog('Failure : '+e.getMessage());
          lstFollowupForm.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstFollowupForm.size() +' row inserted.');
        return transId;
    }

    
    public String createTherapyReceived(String institution, String site, String trial, List<TherapyReceivedCRF> lstTherapyReceivedCRF) {
        List<Therapy_Received__c> THRecvdList = new List<Therapy_Received__c>();
        
        Set<String> CRFIds = new Set<String>();
        for(TherapyReceivedCRF tr_CRF : lstTherapyReceivedCRF) {
           CRFIds.add(tr_CRF.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<Followup_Form__c> lstFollowupForm = [select Id, TestHarnessId__c from Followup_Form__c where TestHarnessId__c IN :CRFIds];
        for(Followup_Form__c FF : lstFollowupForm) {
            mapCRFIds.put(FF.TestHarnessId__c,FF.Id);
        }
        
        
        for(TherapyReceivedCRF therapyreceived_CRF : lstTherapyReceivedCRF) {
          Therapy_Received__c thr = new Therapy_Received__c();
          thr.Therapy__c = therapyreceived_CRF.Therapy;
          thr.Detail__c = therapyreceived_CRF.Detail;
       String dateString = therapyreceived_CRF.StartDateDatePerformed;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
              thr.Start_Date_Date_Performed__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }

        String dateString1 =  (therapyreceived_CRF.EndDate.trim());
            List<String> splitedDate1 = dateString1.split('/');
            if(splitedDate1 != null && splitedDate1.size() == 3) {
              thr.End_Date__c = Date.newinstance(Integer.valueOf(splitedDate1[2]), Integer.valueOf(splitedDate1[1]), Integer.valueOf(splitedDate1[0]));
            }

            if(therapyreceived_CRF.CRFId != null && therapyreceived_CRF.CRFId != '') {
                if(mapCRFIds.get(therapyreceived_CRF.CRFId) != null) {
                 thr.Followup_Form__c = mapCRFIds.get(therapyreceived_CRF.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
         THRecvdList.add(thr);
        }
        try {
            insert THRecvdList;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
         THRecvdList.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +THRecvdList.size() +' row inserted.');
        return transId;
    }


public String createIrradiatedSite(String institution, String site, String trial, List<IrradiatedSiteCRF>lstIrradiatedSiteCRF) {
        List<Irradiated_Site__c> IrrdSiteList = new List<Irradiated_Site__c>();
        
        Set<String> CRFIds = new Set<String>();
        for(IrradiatedSiteCRF ir_CRF : lstIrradiatedSiteCRF) {
           CRFIds.add(ir_CRF.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<Followup_Form__c> lstFF = [select Id, TestHarnessId__c from Followup_Form__c where TestHarnessId__c IN :CRFIds];
        for(Followup_Form__c FF : lstFF) {
            mapCRFIds.put(FF.TestHarnessId__c,FF.Id);
        }
        
        
        for(IrradiatedSiteCRF irradiatedsite_CRF : lstIrradiatedSiteCRF) {
            Irradiated_Site__c irs = new Irradiated_Site__c();
          irs.Site__c = irradiatedsite_CRF.Site;
          system.debug('irs.Site__c '+irs.Site__c);
          irs.Laterality__c = irradiatedsite_CRF.Laterality;
          system.debug('irs.Laterality__c'+irs.Laterality__c);
          irs.Dose_per_FX_cGy__c = Decimal.valueOf(irradiatedsite_CRF.DoseperFXcGy);
          system.debug('irs.Dose_per_FX_cGy__c'+irs.Dose_per_FX_cGy__c);
           irs.Total_FX__c = Decimal.valueOf(irradiatedsite_CRF.TotalFX);
           system.debug('irs.Total_FX__c '+irs.Total_FX__c);
            system.debug('saurabh01'+irradiatedsite_CRF.TotaldosecGyAP);
            system.debug('saurabh01Length'+irradiatedsite_CRF.TotaldosecGyAP.length());
           system.debug('saurabh02'+Decimal.ValueOf(irradiatedsite_CRF.TotaldosecGyAP.trim().length()));
                      
           system.debug('saurabh02'+Decimal.valueOf(irradiatedsite_CRF.TotaldosecGyAP.trim()));
          irs.Total_dose_cGy_AP__c = Decimal.valueOf(irradiatedsite_CRF.TotaldosecGyAP.trim());
          system.debug('irs.Total_dose_cGy_AP__c '+irs.Total_dose_cGy_AP__c);
          
           if(irradiatedsite_CRF.CRFId != null && irradiatedsite_CRF.CRFId != '') {
                if(mapCRFIds.get(irradiatedsite_CRF.CRFId) != null) {
                 irs.Followup_Form__c = mapCRFIds.get(irradiatedsite_CRF.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
         IrrdSiteList.add(irs);
        }
        try {
            insert IrrdSiteList;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
         IrrdSiteList.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +IrrdSiteList.size() +' row inserted.');
        return transId;
    } 

    
     public String createResponseEvaluation(String institution, String site, String trial, List<ResponseEvaluationCRF> lstREF_CRF) {
        
        List<Response_Evaluation_Form__c> lstREF = new List<Response_Evaluation_Form__c>();
        Map<String, String> mapRecordType = getObjectRecordType('Response_Evaluation_Form__c');
      system.debug('inst : '+institution+'    site : '+site+'   trial : '+trial);
        
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
      system.debug('lstTrialPatient : '+lstTrialPatient);
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
      Map<Id, Id> mapTrialPatient1 = new Map<Id, Id>();

        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
          mapTrialPatient1.put(trialPatient.Id, trialPatient.Patient_Id__c);
        }
        system.debug('mapTrialPatient : '+mapTrialPatient);
        for(ResponseEvaluationCRF REF_CRF : lstREF_CRF) {
            Response_Evaluation_Form__c  responseEval = new Response_Evaluation_Form__c();
           system.debug('REF_CRF.CRFId : '+REF_CRF.CRFId);
            if(REF_CRF.CRFId != null && REF_CRF.CRFId != '') {
               responseEval.TestHarnessId__c = REF_CRF.CRFId; 
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRFID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }

            responseEval.Reporting__c = REF_CRF.ReportingPeriod;
            String dateString =REF_CRF.Dateofclinicalassessment;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
                responseEval.Date_of_clinical_assessment__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }


            responseEval.Disease_Extent__c = Decimal.valueOf(REF_CRF.DiseaseExtent);
            responseEval.Palpable_nodes__c = REF_CRF.Palpablenodes;
            responseEval.Matted_nodes__c = REF_CRF.Mattednodes;
            responseEval.Nodes_fixed_to_chest_wall__c = REF_CRF.Nodesfixedtochestwall;
            responseEval.Type_of_lymph_node_involvement__c = REF_CRF.Typeoflymphnodeinvolvement;
            responseEval.Size_of_largest_node__c = Decimal.valueOf(REF_CRF.Sizeoflargestnode);
            responseEval.Clinical_Staging_Period__c = REF_CRF.ClinicalStagingPeriod;
            responseEval.Clinically_staging_period_T__c = REF_CRF.ClinicallystagingperiodT;
            responseEval.Clinically_staging_period_N__c = REF_CRF.ClinicallystagingperiodN;
            responseEval.Clinically_staging_period_M__c = REF_CRF.ClinicallystagingperiodM;
            responseEval.Current_status_of_T4_tumor__c = REF_CRF.CurrentStatusofT4Tumor;
            responseEval.IsCandidateForConservationSurgery__c =REF_CRF.IsCandidateForConservationSurgery;
            responseEval.ReasonNotConservationSurgeryCandidate__c =REF_CRF.ReasonNotConservationSurgeryCandidate; 
            responseEval.OtherReason__c =REF_CRF.OtherReason;
            responseEval.Best_overall_Response_to_date__c =REF_CRF.ResponseStatus; 
            responseEval.Complete_response_CR__c = Boolean.valueOf(REF_CRF.CompleteresponseCR);
            String dateString1 = REF_CRF.CompleteresponseCRDate;
            List<String> splitedDate1 = dateString1.split('/');
            if(splitedDate1 != null && splitedDate1.size() == 3) {
               responseEval.Complete_response_CR_Date__c = Date.newinstance(Integer.valueOf(splitedDate1[2]), Integer.valueOf(splitedDate1[1]), Integer.valueOf(splitedDate1[0]));
            }

         responseEval.Partial_response_PR__c = Boolean.valueOf(REF_CRF.PartialresponsePR);
         String dateString2 = REF_CRF.PartialresponsePRDate;
            List<String> splitedDate2 = dateString2.split('/');
            if(splitedDate2 != null && splitedDate2.size() == 3) {
               responseEval.Partial_response_PR_Date__c = Date.newinstance(Integer.valueOf(splitedDate2[2]), Integer.valueOf(splitedDate2[1]), Integer.valueOf(splitedDate2[0]));
            }

         responseEval.New_local_regional_recurrence__c = Boolean.valueOf(REF_CRF.Newlocalregionalrecurrence);
         String dateString3 = REF_CRF.NewlocalregionalrecurrenceDate;
            List<String> splitedDate3 = dateString3.split('/');
            if(splitedDate3 != null && splitedDate3.size() == 3) {
               responseEval.New_local_regional_recurrence_Date__c = Date.newinstance(Integer.valueOf(splitedDate3[2]), Integer.valueOf(splitedDate3[1]), Integer.valueOf(splitedDate3[0]));
            }

         responseEval.New_distant_progression__c = Boolean.valueOf(REF_CRF.Newdistantprogression);
         String dateString4 = REF_CRF.NewdistantprogressionDate;
            List<String> splitedDate4 = dateString4.split('/');
            if(splitedDate4 != null && splitedDate4.size() == 3) {
               responseEval.New_distant_progression_Date__c= Date.newinstance(Integer.valueOf(splitedDate4[2]), Integer.valueOf(splitedDate4[1]), Integer.valueOf(splitedDate4[0]));
            }

         responseEval.Local_Regional__c = REF_CRF.LocalRegional;
         responseEval.Distant__c = REF_CRF.Distant;
         responseEval.Other__c = REF_CRF.OtherDistant;            
                     
            if(REF_CRF.PatientId != null && REF_CRF.PatientId != '') {
                if(mapTrialPatient.get(REF_CRF.PatientId) != null) {
                   responseEval.TrialPatient__c = mapTrialPatient.get(REF_CRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String compDate = REF_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                   responseEval.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
           responseEval.Status__c = REF_CRF.Status;
            if(responseEval.Status__c == 'Completed' ||responseEval.Status__c == 'Not Completed'){
               responseEval.RecordTypeId = mapRecordType.get('Live');
            } else {
               responseEval.RecordTypeId = mapRecordType.get('Approval Pending');               
            } 
            lstREF.add(responseEval);
        }
        try {
            insert lstREF;
        } catch(Exception e) {
            String errorMsg = e.getMessage();
            if(errorMsg != null) {
                if(errorMsg.contains('Required field missing - Please provide Is Candidate For Conservation Surgery.')) {
                    errorMsg = 'Required field missing - Please provide Is Candidate For Conservation Surgery.';
                }
            }
            transId = insertErrorLog('Failure : '+errorMsg);
           lstREF.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstREF.size() +' row inserted.');
        return transId;
    }
      public String createDiseaseAssessment(String institution, String site, String trial, List<Disease_Assessment_CRF_REF> lstDisease_Assessment_CRF_REF) {
        List<Disease_Assessment__c> lstDiseaseAssessment = new List<Disease_Assessment__c>();
        
        Set<String> CRFIds = new Set<String>();
        for(Disease_Assessment_CRF_REF da_CRF : lstDisease_Assessment_CRF_REF) {
           CRFIds.add(da_CRF.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<Response_Evaluation_Form__c> lstREF = [select Id, TestHarnessId__c from Response_Evaluation_Form__c where TestHarnessId__c IN :CRFIds];
        for(Response_Evaluation_Form__c  responseEval : lstREF) {
            mapCRFIds.put(responseEval.TestHarnessId__c,responseEval.Id);
        }
        
        
        for(Disease_Assessment_CRF_REF diseaseassessment_CRF : lstDisease_Assessment_CRF_REF) {
            Disease_Assessment__c da = new Disease_Assessment__c();
           da.O_Clock_Position_From__c = diseaseassessment_CRF.OClockPositionFrom;
           da.O_Clock_Position_To__c = diseaseassessment_CRF.OClockPositionTo;
           da.Distance_from_nipple__c = Decimal.valueOf(diseaseassessment_CRF.Distancefromnipplecm);
           da.Longest_Diameter__c = Decimal.valueOf(diseaseassessment_CRF.LongestDiameter);
           da.Clip_placed__c = diseaseassessment_CRF.Clipplaced;
          
           if(diseaseassessment_CRF.CRFId != null && diseaseassessment_CRF.CRFId != '') {
                if(mapCRFIds.get(diseaseassessment_CRF.CRFId) != null) {
                  da.Response_Evaluation_Form__c  = mapCRFIds.get(diseaseassessment_CRF.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
          lstDiseaseAssessment.add(da);
        }
        try {
            insert lstDiseaseAssessment;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
          lstDiseaseAssessment.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstDiseaseAssessment.size() +' row inserted.');
        return transId;
    }

     public String createChemoSummary(String institution, String site, String trial, List<ChemoSummaryCRF> lstChemoSummary) {
        List<Chemo_Summary_Form__c> lstCSF = new List<Chemo_Summary_Form__c>();
        Map<String, String> mapRecordType = getObjectRecordType('Chemo_Summary_Form__c');
        system.debug('inst : '+institution+'    site : '+site+'   trial : '+trial);
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        
        system.debug('lstTrialPatient : '+lstTrialPatient);
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        Map<Id, Id> mapTrialPatient1 = new Map<Id, Id>();
        
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
            mapTrialPatient1.put(trialPatient.Id, trialPatient.Patient_Id__c);
        }
        system.debug('mapTrialPatient : '+mapTrialPatient);
        for(ChemoSummaryCRF CSF_CRF : lstChemoSummary) {
             Chemo_Summary_Form__c csf = new Chemo_Summary_Form__c();
            system.debug('CSF_CRF.CRFId : '+CSF_CRF.CRFId);
            if(CSF_CRF.CRFId != null && CSF_CRF.CRFId != '') {
               csf .TestHarnessId__c = CSF_CRF.CRFId; 
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRFID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String dateString = CSF_CRF.FirstDateofTaxaneTherapy;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
             csf.First_Date_of_Taxane_Therapy__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }
          String dateString1 = CSF_CRF.LastDateofTaxaneTherapy;
            List<String> splitedDate1 = dateString1.split('/');
            if(splitedDate1 != null && splitedDate1.size() == 3) {
               csf.Last_Date_of_Taxane_Therapy__c = Date.newinstance(Integer.valueOf(splitedDate1[2]), Integer.valueOf(splitedDate1[1]), Integer.valueOf(splitedDate1[0]));
            }
           csf.Taxane_Regimen_Treatment_End_Reasons__c = CSF_CRF.TaxaneRegimenTreatmentEndReasons;
           csf.Other_Reason__c = CSF_CRF.OtherReason;

           String dateString2 = CSF_CRF.FirstDateofAnthracyclineTherapy;
            List<String> splitedDate2 = dateString2.split('/');
            if(splitedDate2 != null && splitedDate2.size() == 3) {
               csf.First_Date_of_Anthracycline_Therapy__c = Date.newinstance(Integer.valueOf(splitedDate2[2]), Integer.valueOf(splitedDate2[1]), Integer.valueOf(splitedDate2[0]));
            }
           String dateString3 = CSF_CRF.LastDateofAnthracyclineTherapy;
            List<String> splitedDate3 = dateString3.split('/');
            if(splitedDate3 != null && splitedDate3.size() == 3) {
               csf.Last_Date_of_Anthracycline_Therapy__c = Date.newinstance(Integer.valueOf(splitedDate3[2]), Integer.valueOf(splitedDate3[1]), Integer.valueOf(splitedDate3[0]));
            }
           csf.Anthracycline_Regimen__c = CSF_CRF.AnthracyclineRegimenTreatmentEndReason;
           csf.Other_Reason__c = CSF_CRF.OtherReason1;

           String dateString4 = CSF_CRF.FirstDateofInvestigationalTherapy;
            List<String> splitedDate4 = dateString4.split('/');
            if(splitedDate4 != null && splitedDate4.size() == 3) {
               csf.First_Date_of_Investigational_Therapy__c = Date.newinstance(Integer.valueOf(splitedDate4[2]), Integer.valueOf(splitedDate4[1]), Integer.valueOf(splitedDate4[0]));
            }
           String dateString5 = CSF_CRF.LastDateofInvestigationalTherapy;
            List<String> splitedDate5 = dateString5.split('/');
            if(splitedDate5 != null && splitedDate5.size() == 3) {
               csf.Last_Date_of_Investigational_Therapy__c = Date.newinstance(Integer.valueOf(splitedDate5[2]), Integer.valueOf(splitedDate5[1]), Integer.valueOf(splitedDate5[0]));
            }
           csf.InvestigationalRegimenTreatmentEndReason__c = CSF_CRF.InvestigationalRegimenTreatmentEndReason;
           csf.Other_Reason__c = CSF_CRF.OtherReason2;
          if(CSF_CRF.PatientId != null && CSF_CRF.PatientId != '') {
                if(mapTrialPatient.get(CSF_CRF.PatientId) != null) {
                   csf.TrialPatient__c = mapTrialPatient.get(CSF_CRF.PatientId).Id;  
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            
            String compDate = CSF_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                   csf.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
           csf.Status__c = CSF_CRF.Status;
            if(csf.Status__c == 'Completed' ||csf.Status__c == 'Not Completed'){
               csf.RecordTypeId = mapRecordType.get('Live');
            } else {
               csf.RecordTypeId = mapRecordType.get('Approval Pending');                
            } 
           lstCSF.add(csf);         
        
       }
        try {
            insert lstCSF;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
           lstCSF.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstCSF.size() +' row inserted.');
        return transId;      
    }
    
    public String createChemoSummaryRegimen(String institution, String site, String trial, List<ChemoSummaryRegimen_OSP_CRF> lstChemoSummaryRegimen) {
        List<ChemoSummaryRegimenDetail__c> lstCSR = new List<ChemoSummaryRegimenDetail__c>();
        
        Set<String> CRFIds = new Set<String>();
        for(ChemoSummaryRegimen_OSP_CRF CSR : lstChemoSummaryRegimen) {
           CRFIds.add(CSR.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<Chemo_Summary_Form__c> lstCSF = [select Id, TestHarnessId__c from Chemo_Summary_Form__c where TestHarnessId__c IN :CRFIds];
        for(Chemo_Summary_Form__c csf : lstCSF) {
            mapCRFIds.put(csf.TestHarnessId__c,csf.Id);
        }
        
        
        for(ChemoSummaryRegimen_OSP_CRF CSR_CRF : lstChemoSummaryRegimen) {
            ChemoSummaryRegimenDetail__c csr = new ChemoSummaryRegimenDetail__c();
           String dateString = CSR_CRF.FirstDateofTherapy;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
               csr.First_Date_of_Therapy__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }
           String dateString1 = CSR_CRF.LastDateofTherapy;
            List<String> splitedDate1 = dateString1.split('/');
            if(splitedDate1 != null && splitedDate1.size() == 3) {
               csr.Last_Date_of_Therapy__c = Date.newinstance(Integer.valueOf(splitedDate1[2]), Integer.valueOf(splitedDate1[1]), Integer.valueOf(splitedDate1[0]));
            }
           csr.Treatment_End_Reasons__c = CSR_CRF.TreatmentEndReasons;
           csr.Other_Reason__c = CSR_CRF.OtherReason;
           if(CSR_CRF.CRFId != null && CSR_CRF.CRFId != '') {
                if(mapCRFIds.get(CSR_CRF.CRFId) != null) {
                   csr.Chemo_Summary_Form__c = mapCRFIds.get(CSR_CRF.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
           lstCSR.add(csr);
        }
        try {
            insert lstCSR;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
           lstCSR.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstCSR.size() +' row inserted.');
        return transId;
    }    

     public String createBaselineSymptoms(String institution, String site, String trial, List<BaselineSymptomsCRF> lsBaselineSymptoms) {
        List<BaselineSymptomsForm__c> lstCloneBaseline = new List<BaselineSymptomsForm__c>();
        Map<String, String> mapRecordType = getObjectRecordType('BaselineSymptomsForm__c');
        system.debug('inst : '+institution+'    site : '+site+'   trial : '+trial);
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        
        system.debug('lstTrialPatient : '+lstTrialPatient);
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        Map<Id, Id> mapTrialPatient1 = new Map<Id, Id>();
        
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
            mapTrialPatient1.put(trialPatient.Id, trialPatient.Patient_Id__c);
        }
        system.debug('mapTrialPatient : '+mapTrialPatient);
        for( BaselineSymptomsCRF BSF_CRF : lsBaselineSymptoms) {
             BaselineSymptomsForm__c  baselineSymptoms = new BaselineSymptomsForm__c ();
            system.debug('BSF_CRF.CRFId : '+BSF_CRF.CRFId);
            if(BSF_CRF.CRFId != null &&BSF_CRF.CRFId != '') {
               baselineSymptoms.TestHarnessId__c = BSF_CRF.CRFId; 
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRFID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String dateString = BSF_CRF.VisitDate;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
            baselineSymptoms.Visit_Date__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }

          if(BSF_CRF.PatientId != null && BSF_CRF.PatientId != '') {
                if(mapTrialPatient.get(BSF_CRF.PatientId) != null) {
                  baselineSymptoms.TrialPatient__c = mapTrialPatient.get(BSF_CRF.PatientId).Id;  
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            
            String compDate = BSF_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                  baselineSymptoms.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
          baselineSymptoms.Status__c = BSF_CRF.Status;
            if(baselineSymptoms.Status__c == 'Completed' ||baselineSymptoms.Status__c == 'Not Completed'){
              baselineSymptoms.RecordTypeId = mapRecordType.get('Live');
            } else {
              baselineSymptoms.RecordTypeId = mapRecordType.get('Approval Pending');                
            } 
          lstCloneBaseline.add(baselineSymptoms);         
        
       }
        try {
            insert lstCloneBaseline;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
          lstCloneBaseline.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstCloneBaseline.size() +' row inserted.');
        return transId;      
    }
    
    public String createAllergy(String institution, String site, String trial, List<Allergy_CRF_BSF> lstAllergy_CRF_BSF) {
        List<Allergy__c>  lstAllergy = new List<Allergy__c>();
        
        Set<String> CRFIds = new Set<String>();
        for(Allergy_CRF_BSF aoc_CRF : lstAllergy_CRF_BSF) {
           CRFIds.add(aoc_CRF.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<BaselineSymptomsForm__c> lstCloneBaseline = [select Id, TestHarnessId__c from BaselineSymptomsForm__c where TestHarnessId__c IN :CRFIds];
        for(BaselineSymptomsForm__c  baselineSymptoms : lstCloneBaseline) {
            mapCRFIds.put(baselineSymptoms.TestHarnessId__c,baselineSymptoms.Id);
        }
        
        
        for(Allergy_CRF_BSF allergy_CRF : lstAllergy_CRF_BSF) {
         Allergy__c  allergy = new Allergy__c();
        allergy.Allergy_Type__c = allergy_CRF.AllergyType;
        allergy.Other_Allergy__c = allergy_CRF.OtherAllergy;
        allergy.Allergies__c = allergy_CRF.Allergies != null && allergy_CRF.Allergies != '' ? allergy_CRF.Allergies : null;
        //bc.Daignosis__c = BC_CRF.Daignosis != null && BC_CRF.Daignosis != '' ? BC_CRF.Daignosis : null;
        allergy.Reactions__c = allergy_CRF.Reactions;
        allergy.Other_Reactions__c = allergy_CRF.OtherReactions;
        allergy.Severity__c = allergy_CRF.Severity;
        allergy.Year_first_seen__c = allergy_CRF.Yearfirstseen;
        allergy.Form_Name__c = allergy_CRF.FormName;  
           if(allergy_CRF.CRFId != null && allergy_CRF.CRFId != '') {
                if(mapCRFIds.get(allergy_CRF.CRFId) != null) {
                 allergy.BaselineSymptomsForm__c = mapCRFIds.get(allergy_CRF.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
         lstAllergy.add(allergy);
        }
        try {
            insert lstAllergy;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
         lstAllergy.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstAllergy.size() +' row inserted.');
        return transId;
    }
   

     public String createBaselineCondition(String institution, String site, String trial, List<BaselineCondition_OSP_CRF> lstBaselineCondition) {
        List<BaselineCondition__c> lstBC = new List<BaselineCondition__c>();
        
        Set<String> CRFIds = new Set<String>();
        for(BaselineCondition_OSP_CRF BC : lstBaselineCondition) {
           CRFIds.add(BC.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<BaselineSymptomsForm__c> lstCloneBaseline = [select Id, TestHarnessId__c from BaselineSymptomsForm__c where TestHarnessId__c IN :CRFIds];
        for(BaselineSymptomsForm__c  baselineSymptoms : lstCloneBaseline) {
            mapCRFIds.put(baselineSymptoms.TestHarnessId__c,baselineSymptoms.Id);
        }
        
        
        for(BaselineCondition_OSP_CRF BC_CRF : lstBaselineCondition) {
         BaselineCondition__c bc = new BaselineCondition__c();
         bc.DiagnosisType__c = BC_CRF.DiagnosisType;
         bc.OtherDaignosis__c = BC_CRF.OtherDaignosis;
         system.debug('===BC_CRF.Daignosis===='+BC_CRF.Daignosis);
         bc.Daignosis__c = BC_CRF.Daignosis != null && BC_CRF.Daignosis != '' ? BC_CRF.Daignosis : null; 
                   
         bc.Severity_Grade__c = BC_CRF.SeverityGrade;
         bc.Attribution__c = BC_CRF.Attribution;
         bc.Onset_Month__c = BC_CRF.OnsetMonth;
         bc.Onset_Day__c = BC_CRF.OnsetDay;
         bc.Onset_Year__c = BC_CRF.OnsetYear;
         bc.Resolved__c = BC_CRF.Resolved;
         bc.End_Month__c = BC_CRF.EndMonth;
         bc.End_Day__c = BC_CRF.EndDay;
         bc.End_Year__c = BC_CRF.EndYear;
           if(BC_CRF.CRFId != null && BC_CRF.CRFId != '') {
                if(mapCRFIds.get(BC_CRF.CRFId) != null) {
                  bc.BaselineSymptomsForm__c = mapCRFIds.get(BC_CRF.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
          lstBC.add(bc);
        }
        try {
            insert lstBC;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
          lstBC.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstBC.size() +' row inserted.');
        return transId;
    }    

      public String createToxicities(String institution, String site, String trial, List<Toxicity_OSP_CRF> lstToxicity_OSP_CRF) {
        List<Toxicity__c> toxicityDisplayList = new List<Toxicity__c>();
        
        Set<String> CRFIds = new Set<String>();
        for(Toxicity_OSP_CRF toc_CRF : lstToxicity_OSP_CRF) {
            CRFIds.add(toc_CRF.CRFId);
        }
         Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<BaselineSymptomsForm__c> lstCloneBaseline = [select Id, TestHarnessId__c from BaselineSymptomsForm__c where TestHarnessId__c IN :CRFIds];
        for(BaselineSymptomsForm__c  baselineSymptoms : lstCloneBaseline) {
            mapCRFIds.put(baselineSymptoms.TestHarnessId__c,baselineSymptoms.Id);
        }
        
        
        for(Toxicity_OSP_CRF toxicity_CRF : lstToxicity_OSP_CRF) {
        Toxicity__c toxicityObj = new Toxicity__c();
       toxicityObj.Symptom_Status__c = toxicity_CRF.SymptomStatus;
       toxicityObj.Symptom_Masters__c = toxicity_CRF.SymptomMasters;
       toxicityObj.Toxicity_Master__c = toxicity_CRF.ToxicityAgent;
       toxicityObj.Toxicity_Other__c = toxicity_CRF.ToxicityOther;
       toxicityObj.Toxicity_Status__c = toxicity_CRF.ToxicityStatus;
       toxicityObj.Grade__c = toxicity_CRF.Grade;
       toxicityObj.Attribution__c = toxicity_CRF.Attribution;
       toxicityObj.Was_event_life_threatning__c = Boolean.valueOf(toxicity_CRF.Waseventlifethreatning);
       toxicityObj.Did_event_required_hospitalization__c = Boolean.valueOf(toxicity_CRF.Dideventrequiredhospitalization);
       toxicityObj.Result_persistent_significant_disability__c = Boolean.valueOf(toxicity_CRF.Resultpersistentsignificantdisability);
       toxicityObj.Result_conginental_abnormality_defect__c = Boolean.valueOf(toxicity_CRF.Resultconginentalabnormalitydefect);
       toxicityObj.Did_the_investigator_find_event_unusual__c = Boolean.valueOf(toxicity_CRF.Didtheinvestigatorfindeventunusual);
       toxicityObj.Did_event_result_in_death__c = Boolean.valueOf(toxicity_CRF.Dideventresultindeath);
        String dateString = toxicity_CRF.OnsetDate;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
             toxicityObj.Onset_Date__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }

       toxicityObj.SAE__c = toxicity_CRF.SAE;
       toxicityObj.Resolved__c = Boolean.valueOf(toxicity_CRF.Resolved);
        String dateString1 = toxicity_CRF.AEEndDate;
            List<String> splitedDate1 = dateString1.split('/');
            if(splitedDate1 != null && splitedDate1.size() == 3) {
             toxicityObj.AE_End_Date__c = Date.newinstance(Integer.valueOf(splitedDate1[2]), Integer.valueOf(splitedDate1[1]), Integer.valueOf(splitedDate1[0]));
            }

       toxicityObj.Patient_Complaint__c = toxicity_CRF.PatientComplaint;
         if(toxicity_CRF.CRFId != null && toxicity_CRF.CRFId != '') {
                if(mapCRFIds.get(toxicity_CRF.CRFId) != null) {
                 toxicityObj.Baseline_Symptoms_Form__c = mapCRFIds.get(toxicity_CRF.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                 transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
        toxicityDisplayList.add(toxicityObj);
        }
        try {
            insert toxicityDisplayList;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
        toxicityDisplayList.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +toxicityDisplayList.size() +' row inserted.');
        return transId;     
    }    

     public String createLabandTest(String institution, String site, String trial, List<LabandTestCRF> lstLAT_CRF) {
        
        List<Lab_and_Test__c> lstLAT = new List<Lab_and_Test__c>();
        Map<String, String> mapRecordType = getObjectRecordType('Lab_and_Test__c');
        
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
        }
        
        for(LabandTestCRF LAT_CRF : lstLAT_CRF) {
           Lab_and_Test__c latObj = new Lab_and_Test__c();
           String dateString = LAT_CRF.CollectionDate;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
               latObj.Collection_Date__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }
           latObj.Leukocytes__c = Boolean.valueOf(LAT_CRF.Leukocytes);
           latObj.Leukocytes_Result__c = Decimal.valueOf(LAT_CRF.LeukocytesResult);
           latObj.Leukocytes_Institutional_Reference_Range__c = LAT_CRF.LeukocytesInstitutionalReferenceRange;
           latObj.Absolute_Neutrophil_Count_ANC__c = Boolean.valueOf(LAT_CRF.AbsoluteNeutrophilCountANC);
           latObj.Absolute_Neutrophil_Count_ANC_Result__c = Decimal.valueOf(LAT_CRF.AbsoluteNeutrophilCountANCResult);
           latObj.ANC_Industrial_Reference_Range__c = LAT_CRF.ANCIndustrialReferenceRange;
           latObj.Platelets__c = Boolean.valueOf(LAT_CRF.Platelets);
           latObj.Platelets_Result__c = Decimal.valueOf(LAT_CRF.PlateletsResult);
           latObj.Platelets_Institutional_Reference_Range__c = LAT_CRF.PlateletsInstitutionalReferenceRange;
           latObj.Total_Bilirubin__c = Boolean.valueOf(LAT_CRF.TotalBilirubin);
           latObj.Total_Bilirubin_Result__c = Decimal.valueOf(LAT_CRF.TotalBilirubinResult);
           latObj.Total_Bilirubin_Institutional_Reference__c = LAT_CRF.TotalBilirubinInstitutionalReference;
           latObj.AST__c = Boolean.valueOf(LAT_CRF.AST);
           latObj.AST_Result__c = Decimal.valueOf(LAT_CRF.ASTResult);
           latObj.AST_Institutional_Reference_Range__c = LAT_CRF.ASTInstitutionalReferenceRange; 
           latObj.ALT__c = Boolean.valueOf(LAT_CRF.ALT);
           latObj.ALT_Result__c = Decimal.valueOf(LAT_CRF.ALTResult);
           latObj.ALT_Institutional_Reference_Range__c = LAT_CRF.ALTInstitutionalReferenceRange;
           latObj.Creatinine__c = Boolean.valueOf(LAT_CRF.Creatinine);
           latObj.Creatinine_Result__c = Decimal.valueOf(LAT_CRF.CreatinineResult);
           latObj.Creatinine_Institutional_Reference_Range__c = LAT_CRF.CreatinineInstitutionalReferenceRange; 
           latObj.MUGA_Scan__c = Boolean.valueOf(LAT_CRF.MUGAScan); 
            
            String dateString1 = LAT_CRF.MUGAScanDate;
            List<String> splitedDate1 = dateString1.split('/');
            if(splitedDate1 != null && splitedDate1.size() == 3) {
               latObj.MUGA_Scan_Date__c = Date.newinstance(Integer.valueOf(splitedDate1[2]), Integer.valueOf(splitedDate1[1]), Integer.valueOf(splitedDate1[0]));
            }
           latObj.MUGA_Scan_LVEF__c = Decimal.valueOf(LAT_CRF.MUGAScanLVEF);
           latObj.MUGA_Institutional_Lower_Limit_of_Normal__c = Decimal.valueOf(LAT_CRF.MUGAInstitutionalLowerLimitofNormal);
           latObj.Cardiac_Echo__c = Boolean.valueOf(LAT_CRF.CardiacEcho); 
            
            String dateString2 = LAT_CRF.CardiacEchoDate;
            List<String> splitedDate2 = dateString2.split('/');
            if(splitedDate2 != null && splitedDate2.size() == 3) {
               latObj.Cardiac_Echo_Date__c = Date.newinstance(Integer.valueOf(splitedDate2[2]), Integer.valueOf(splitedDate2[1]), Integer.valueOf(splitedDate2[0]));
            }
           latObj.Cardiac_Echo_LVEF__c = Decimal.valueOf(LAT_CRF.CardiacEchoLVEF);
           latObj.Cardiac_Echo_Institutional_Lower_Limit__c = Decimal.valueOf(LAT_CRF.CardiacEchoInstitutionalLowerLimit);
             
            String dateString3 = LAT_CRF.CollectionDate1;
            List<String> splitedDate3 = dateString3.split('/');
            if(splitedDate3 != null && splitedDate3.size() == 3) {
               latObj.Collection_Date_for_Investigative_Agent__c = Date.newinstance(Integer.valueOf(splitedDate3[2]), Integer.valueOf(splitedDate3[1]), Integer.valueOf(splitedDate3[0]));
            }
            
            if(LAT_CRF.PatientId != null && LAT_CRF.PatientId != '') {
                if(mapTrialPatient.get(LAT_CRF.PatientId) != null) {
                   latObj.TrialPatient__c = mapTrialPatient.get(LAT_CRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String compDate = LAT_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                   latObj.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
           latObj.Status__c = LAT_CRF.Status;
            if(latObj.Status__c == 'Completed' || latObj.Status__c == 'Not Completed'){
               latObj.RecordTypeId = mapRecordType.get('Live');
            } else {
               latObj.RecordTypeId = mapRecordType.get('Approval Pending');               
            } 
           lstLAT.add(latObj);
        }
        try {
            insert lstLAT;
        } catch(Exception e) {
           transId = insertErrorLog('Failure : '+e.getMessage());
          lstLAT.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstLAT.size() +' row inserted.');
        return transId;
    }
    
      public String createPostSurgery(String institution, String site, String trial, List<PostSurgeryCRF> lstPSS_CRF) {
      
        List<Post_Surgaory_Summary__c> lstPSS = new List<Post_Surgaory_Summary__c>();
        Map<String, String> mapRecordType = getObjectRecordType('Post_Surgaory_Summary__c');
       system.debug('inst : '+institution+'    site : '+site+'   trial : '+trial);
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
      system.debug('lstTrialPatient : '+lstTrialPatient);
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
      
        Map<Id, Id> mapTrialPatient1 = new Map<Id, Id>();
      
        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
            mapTrialPatient1.put(trialPatient.Id, trialPatient.Patient_Id__c);
        }
      system.debug('mapTrialPatient : '+mapTrialPatient);
          for(PostSurgeryCRF PSS_CRF : lstPSS_CRF) {
             Post_Surgaory_Summary__c  postSurObj= new Post_Surgaory_Summary__c();
            system.debug('PSS_CRF.CRFId : '+PSS_CRF.CRFId);
            if(PSS_CRF.CRFId != null && PSS_CRF.CRFId != '') {
              postSurObj.TestHarnessId__c = PSS_CRF.CRFId; 
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRFID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
          
            String dateString = PSS_CRF.DateOfProcedure;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
            postSurObj.Date_Of_Procedure__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }
      
        postSurObj.Surgeon__c = PSS_CRF.Surgeon != null && PSS_CRF.Surgeon != '' ? PSS_CRF.Surgeon : null;
        postSurObj.Surgeon_Other__c = PSS_CRF.SurgeonOther;
        postSurObj.Type_Of_Tumor__c = PSS_CRF.TypeOfTumor;
        postSurObj.Size_of_Gross_Mass_Height__c = Decimal.valueOf(PSS_CRF.SizeofGrossMassHeight);
        postSurObj.Size_of_Gross_Mass_Width__c = Decimal.valueOf(PSS_CRF.SizeofGrossMassWidth);
        postSurObj.Gross_Mass_Measurement_Unit__c = PSS_CRF.GrossMassMeasurementUnit;
        postSurObj.Size_of_Largest_Gross_Mass_Height__c = Decimal.valueOf(PSS_CRF.SizeofLargestGrossMassHeight);
        postSurObj.Size_of_Largest_Gross_Mass_Width__c = Decimal.valueOf(PSS_CRF.SizeofLargestGrossMassWidth);
        postSurObj.Largest_Gross_Mass_Measurement_Unit__c = PSS_CRF.LargestGrossMassMeasurementUnit;
        postSurObj.Total_span_multifocal_gross_mass_height__c = Decimal.valueOf(PSS_CRF.Totalspanmultifocalgrossmassheight);
        postSurObj.Total_span_multifocal_gross_mass_width__c = Decimal.valueOf(PSS_CRF.Totalspanmultifocalgrossmasswidth);
        postSurObj.Total_Span_Measurement_Unit__c = PSS_CRF.TotalSpanMeasurementUnit;
        postSurObj.Span_of_gross_changes_height__c = Decimal.valueOf(PSS_CRF.Spanofgrosschangesheight);
        postSurObj.Span_of_gross_changes_width__c = Decimal.valueOf(PSS_CRF.Spanofgrosschangeswidth);
        postSurObj.Gross_Changes_Measurement_Unit__c = PSS_CRF.GrossChangesMeasurementUnit;
        postSurObj.Lymph_node_dissection_done__c = PSS_CRF.Lymphnodedissectiondone;
        postSurObj.Are_Calcifications_Present__c = PSS_CRF.AreCalcificationsPresent;
        postSurObj.Calcification_Details__c = PSS_CRF.CalcificationDetails;
        postSurObj.Is_DCIS_Present__c = PSS_CRF.IsDCISPresent; // Is_DCIS_Present__c is picklist
        postSurObj.Is_LCIS_Present__c = PSS_CRF.IsLCISPresent; // Is_LCIS_Present__c is picklist
        postSurObj.Is_invasive_tumor_present__c = PSS_CRF.Isinvasivetumorpresent; // Is_invasive_tumor_present__c is picklist
        postSurObj.separately_submitted_margins__c = PSS_CRF.separatelysubmittedmargins;
        postSurObj.Invasive_CA_present__c = PSS_CRF.InvasiveCAPresent;
        postSurObj.Invasive_CA_at_true_margin__c = PSS_CRF.InvasiveCAattruemargin;
        postSurObj.In_Situ_Disease_Present__c = PSS_CRF.InSituDiseasePresent;
        postSurObj.In_Situ_Disease_At_True_Margin__c = PSS_CRF.InSituDiseaseAtTrueMargin;
        postSurObj.Other_Changes_Present__c = PSS_CRF.OtherChangesPresent;
        postSurObj.Other_Changes__c = PSS_CRF.OtherChanges;
        postSurObj.Other_Change__c = PSS_CRF.OtherChange;
        postSurObj.pcr__c = Boolean.valueOf(PSS_CRF.pcr);
        postSurObj.Primary_Tumor_Bed_Area__c = PSS_CRF.PrimaryTumorBedArea;
        postSurObj.RCB_Overall_Center_Cellularity__c = Decimal.valueOf(PSS_CRF.OverallCenterCellularity);
        postSurObj.percentage_of_CA_in_Situ_Disease__c = Decimal.valueOf(PSS_CRF.percentageofCAinSituDisease);
        postSurObj.Number_of_lymph_nodes_positive__c = PSS_CRF.Numberoflymphnodespositive;
        postSurObj.Diameter_of_largest_met__c = PSS_CRF.Diameteroflargestmet;
        postSurObj.RCB_index__c = Decimal.valueOf(PSS_CRF.RCBindex);
        postSurObj.RCB_Class__c = PSS_CRF.RCBClass;
          
             if(PSS_CRF.PatientId != null &&PSS_CRF.PatientId != '') {
                if(mapTrialPatient.get(PSS_CRF.PatientId) != null) {
                postSurObj.TrialPatient__c = mapTrialPatient.get(PSS_CRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
              
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
             system.debug('transId : '+transId);
                return transId;
            }

             String compDate = PSS_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                postSurObj.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
        postSurObj.Status__c =PSS_CRF.Status;
            if(postSurObj.Status__c == 'Completed' ||postSurObj.Status__c == 'Not Completed'){
            postSurObj.RecordTypeId = mapRecordType.get('Live');
            } else {
            postSurObj.RecordTypeId = mapRecordType.get('Approval Pending');             
            }
           lstPSS .add(postSurObj);
        }
      system.debug('lstPSS : '+lstPSS);
         try {
            insert lstPSS ;
        } catch(Exception e) {
           transId = insertErrorLog('Failure : '+e.getMessage());
          lstPSS .clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstPSS.size() +' row inserted.');
        return transId;
    }

  
    public String createProcedureSpecimen(String institution, String site, String trial, List<Procedure_Specimen_Detail_OSP_PSS> lstProcedure_Specimen_Detail_OSP_PSS) {
        List<Procedure_Specimen_Detail__c> lstProcedureSpecimen = new List<Procedure_Specimen_Detail__c>();
        Set<String> crfIds = new Set<String>();
        for(Procedure_Specimen_Detail_OSP_PSS ProcedureSpecimeOSP : lstProcedure_Specimen_Detail_OSP_PSS) {
           crfIds.add(ProcedureSpecimeOSP.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<Post_Surgaory_Summary__c> lstPSS = [select Id, TestHarnessId__c from Post_Surgaory_Summary__c where TestHarnessId__c IN :crfIds];
         for(Post_Surgaory_Summary__c postSurObj : lstPSS) {
            mapCRFIds.put(postSurObj.TestHarnessId__c, postSurObj.Id);
        }
      
        for(Procedure_Specimen_Detail_OSP_PSS ProcedureSpecimeOSP : lstProcedure_Specimen_Detail_OSP_PSS) {
            Procedure_Specimen_Detail__c procedurespecimen = new Procedure_Specimen_Detail__c();
          
            if(ProcedureSpecimeOSP.CRFId != null && ProcedureSpecimeOSP.CRFId != '') {
                if(mapCRFIds.get(ProcedureSpecimeOSP.CRFId) != null) {
                   procedurespecimen.Post_Surgery_Summary__c = mapCRFIds.get(ProcedureSpecimeOSP.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
              
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
          
           procedurespecimen.Procedure__c = ProcedureSpecimeOSP.Procedure;
           procedurespecimen.Specimen__c = ProcedureSpecimeOSP.Specimen;                 
           procedurespecimen.Main_Specimen_submitted_for_histology__c = ProcedureSpecimeOSP.MainSpecimensubmittedforhistology;
           procedurespecimen.Single_Speciment_submitted_for_histology__c = ProcedureSpecimeOSP.SingleSpecimentsubmittedforhistology;
           procedurespecimen.Medial_lateral_Gross_specimen_size__c = Decimal.valueOf(ProcedureSpecimeOSP.MediallateralGrossspecimensize);
           procedurespecimen.Medial_lateral_size_unit__c = ProcedureSpecimeOSP.Mediallateralsizeunit;
           procedurespecimen.Anterior_deep_Gross_specimen_size__c = Decimal.valueOf(ProcedureSpecimeOSP.AnteriordeepGrossspecimensize);
           procedurespecimen.Anterior_deep_size_unit__c= ProcedureSpecimeOSP.Anteriordeepsizeunit;
           procedurespecimen.Superor_inferior_Gross_specimen_size__c = Decimal.valueOf(ProcedureSpecimeOSP.SuperorinferiorGrossspecimensize);
           procedurespecimen.Superor_inferior_size_unit__c = ProcedureSpecimeOSP.Superorinferiorsizeunit;
           procedurespecimen.Total_Slices__c = Decimal.valueOf(ProcedureSpecimeOSP.TotalSlices);
           procedurespecimen.Slicing_Method__c = ProcedureSpecimeOSP.SlicingMethod;
           procedurespecimen.Slice_Plane1__c= ProcedureSpecimeOSP.SlicePlane1;
           procedurespecimen.Slice1__c= ProcedureSpecimeOSP.Slice1;
           procedurespecimen.Block1__c = ProcedureSpecimeOSP.Block1;
           procedurespecimen.Slice_Plane2__c = ProcedureSpecimeOSP.SlicePlane2;
           procedurespecimen.Slice2__c = ProcedureSpecimeOSP.Slice2;
           procedurespecimen.Block2__c = ProcedureSpecimeOSP.Block2;
           procedurespecimen.Lab__c = ProcedureSpecimeOSP.PerformingLab;
           procedurespecimen.Lymph_node_tissue_present_in_sample__c = Boolean.valueOf(ProcedureSpecimeOSP.Lymphnodetissuepresentinsample);         
         
           system.debug('procedurespecimen : '+procedurespecimen);
           lstProcedureSpecimen.add(procedurespecimen);
        }
        try {
            insert lstProcedureSpecimen;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstProcedureSpecimen.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess : ' + lstProcedureSpecimen.size() +' row inserted.');
        return transId;
    }

        public String createLymphNode(String institution, String site, String trial, List<Lymph_Nodes_OSP_CRF> lstLymph_Nodes_OSP_CRF) {
        List<Lymph_Nodes__c> lstLymphNode = new List<Lymph_Nodes__c>();
        Set<String> crfIds = new Set<String>();
        for(Lymph_Nodes_OSP_CRF lymphnodeOSP : lstLymph_Nodes_OSP_CRF) {
           crfIds.add( lymphnodeOSP.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
         List<Post_Surgaory_Summary__c> lstPSS = [select Id, TestHarnessId__c from Post_Surgaory_Summary__c where TestHarnessId__c IN :crfIds];
        for(Post_Surgaory_Summary__c postSurObj : lstPSS) {
         mapCRFIds.put(postSurObj.TestHarnessId__c, postSurObj.Id);
        }
      
        for(Lymph_Nodes_OSP_CRF lymphnodeOSP : lstLymph_Nodes_OSP_CRF) {
            Lymph_Nodes__c lymphnode = new Lymph_Nodes__c();
          
            if(lymphnodeOSP.CRFId != null && lymphnodeOSP.CRFId != '') {
                if(mapCRFIds.get(lymphnodeOSP.CRFId) != null) {
                    lymphnode.Post_Surgery_Summary__c = mapCRFIds.get(lymphnodeOSP.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
              
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
        
        lymphnode.Procedure__c = lymphnodeOSP.Procedure; 
        lymphnode.Letarality__c = lymphnodeOSP.Letarality;
        lymphnode.Sentinel_Nodes__c = Boolean.valueOf(lymphnodeOSP.SentinelNodes);
        //lymphnode.Node_Checkbox_Value__c = lymphnodeOSP.NodeCheckboxValue;
        lymphnode.Location__c = lymphnodeOSP.Location;
        lymphnode.Positive__c = Decimal.valueOf(lymphnodeOSP.Positive);
        lymphnode.Examined__c = Decimal.valueOf(lymphnodeOSP.Examined);
        lymphnode.Method_of_Detection__c = lymphnodeOSP.MethodofDetection;
        lymphnode.Single_Detection_Result__c = Boolean.valueOf(lymphnodeOSP.SingleDetectionResult);
        lymphnode.Cluster_Detection_Result__c = Boolean.valueOf(lymphnodeOSP.ClusterDetectionResult);
        lymphnode.Focus_Detection_Result__c = Boolean.valueOf(lymphnodeOSP.FocusDetectionResult);
        lymphnode.Not_reported_Detection_Result__c = Boolean.valueOf(lymphnodeOSP.NotreportedDetectionResult);
        lymphnode.Size_of_Largest_Tumor__c = lymphnodeOSP.SizeofLargestTumor;
        lymphnode.Specific_Size_of_Largest_Tumor__c = Decimal.valueOf(lymphnodeOSP.SpecificSizeofLargestTumor);
        lymphnode.Tumor_Size_Measurement_Unit__c = lymphnodeOSP.TumorSizeMeasurementUnit;
        lymphnode.Extramodal_Extension__c = lymphnodeOSP.ExtramodalExtension;
        lymphnode.Axillary_Nodes__c = Boolean.valueOf(lymphnodeOSP.AxillaryNodes);
        //lymphnode.Node_Checkbox_Value__c = lymphnodeOSP.NodeCheckboxValue1;
        lymphnode.Positive__c = Decimal.valueOf(lymphnodeOSP.Positive1);
        lymphnode.Examined__c = Decimal.valueOf(lymphnodeOSP.Examined1);
        lymphnode.Method_of_Detection__c = lymphnodeOSP.MethodofDetection1;
        lymphnode.Single_Detection_Result__c = Boolean.valueOf(lymphnodeOSP.SingleDetectionResult1);
        lymphnode.Cluster_Detection_Result__c = Boolean.valueOf(lymphnodeOSP.ClusterDetectionResult1);
        lymphnode.Focus_Detection_Result__c = Boolean.valueOf(lymphnodeOSP.FocusDetectionResult1);
        lymphnode.Not_reported_Detection_Result__c = Boolean.valueOf(lymphnodeOSP.NotreportedDetectionResult1);
        lymphnode.Size_of_Largest_Tumor__c = lymphnodeOSP.SizeofLargestTumor1;
        lymphnode.Specific_Size_of_Largest_Tumor__c = Decimal.valueOf(lymphnodeOSP.SpecificSizeofLargestTumor1);
        lymphnode.Tumor_Size_Measurement_Unit__c = lymphnodeOSP.TumorSizeMeasurementUnit1;
        lymphnode.Extramodal_Extension__c = lymphnodeOSP.ExtramodalExtension1;
        lymphnode.Additional_Nodes__c = Boolean.valueOf(lymphnodeOSP.AdditionalNodes);
        //lymphnode.Node_Checkbox_Value__c = lymphnodeOSP.NodeCheckboxValue2;
        lymphnode.Location__c = lymphnodeOSP.Location1;
        lymphnode.Positive__c = Decimal.valueOf(lymphnodeOSP.Positive2);
        lymphnode.Examined__c = Decimal.valueOf(lymphnodeOSP.Examined2);
        lymphnode.Size_of_Largest_Tumor__c = lymphnodeOSP.SizeofLargestTumor2;
        lymphnode.Specific_Size_of_Largest_Tumor__c = Decimal.valueOf(lymphnodeOSP.SpecificSizeofLargestTumor2);
        lymphnode.Tumor_Size_Measurement_Unit__c = lymphnodeOSP.TumorSizeMeasurementUnit2;
        lymphnode.Extramodal_Extension__c = lymphnodeOSP.ExtramodalExtension2;

           system.debug('lymphnode : '+lymphnode);
            lstLymphNode.add(lymphnode);
        }
        try {
            insert lstLymphNode;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
           lstLymphNode.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess : ' + lstLymphNode.size() +' row inserted.');
        return transId;
    }


     public String createReceptor(String institution, String site, String trial, List<Receptors_OSP_CRF> lstReceptors_OSP_CRF) {
        List<Receptors__c> lstReceptor = new List<Receptors__c>();
        Set<String> ospIds = new Set<String>();
        for(Receptors_OSP_CRF receptorOSP : lstReceptors_OSP_CRF) {
           ospIds.add(receptorOSP.OSPId);
        }
        Map<String, Id> mapOSPIds = new Map<String, Id>();
         List<Post_Surgaory_Summary__c> lstPSS = [select Id, TestHarnessId__c from Post_Surgaory_Summary__c where TestHarnessId__c IN :ospIds];
         for(Post_Surgaory_Summary__c postSurObj : lstPSS) {
         mapOSPIds.put(postSurObj.TestHarnessId__c, postSurObj.Id);
        }
     
        for(Receptors_OSP_CRF receptorOSP : lstReceptors_OSP_CRF) {
            Receptors__c receptor = new Receptors__c();
         
             if(receptorOSP.OSPId != null && receptorOSP.OSPId != '') {
               if(mapOSPIds.get(receptorOSP.OSPId) != null) {
                    receptor.Post_Surgery_Summary__c = mapOSPIds.get(receptorOSP.OSPId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
             
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
         
            receptor.Estrogen_Receptor_Status__c = receptorOSP.ERStatus;
            receptor.Estrogen_Receptor_Proportion_Score__c = receptorOSP.ERProporationScore;
            receptor.Estrogen_Intensity_Score__c = receptorOSP.ERIntensityScore;
            receptor.Total_Score_ER__c = Decimal.valueOf(receptorOSP.TotalScoreER);
            receptor.Progesterone_Receptor_Status__c = receptorOSP.PRStatus;
            receptor.Progesterone_Receptor_Proportion_Score__c= receptorOSP.PRProporationScore;
            receptor.Progesterone_Intensity_Score__c = receptorOSP.PRIntensityScore;
           receptor.Total_Score_PR__c = Decimal.valueOf(receptorOSP.TotalScorePR);
            receptor.HER2_neu_Marker__c = receptorOSP.HER2neuMarkerStatus;
            if(receptorOSP.DAKOHerceptest != null) {
                receptor.DAKO_Herceptest__c = true;
                if(receptorOSP.DAKOHerceptest == '1') {
                    receptor.DAKO_Herceptest_Value__c = '+1';
                } else if(receptorOSP.DAKOHerceptest == '2') {
                    receptor.DAKO_Herceptest_Value__c = '+2';
                } else if(receptorOSP.DAKOHerceptest == '3') {
                    receptor.DAKO_Herceptest_Value__c = '+3';
                } else {
                    receptor.DAKO_Herceptest_Value__c = receptorOSP.DAKOHerceptest;
                }
            }
            receptor.Other_IHC_Results__c = receptorOSP.OtherIHCResult;
            if(receptorOSP.OtherIHCTest != null) {
                receptor.Other_IHC_Test__c = true;
                receptor.Other_IHC_Test_Value__c = receptorOSP.OtherIHCTest;
            }
            if(receptorOSP.VentanaKit != null) {
                receptor.Ventana_kit__c = true;
                if(receptorOSP.VentanaKit == '1') {
                    receptor.Ventana_kit_Value__c = '+1';
                } else if(receptorOSP.VentanaKit == '2') {
                    receptor.Ventana_kit_Value__c = '+2';
                } else if(receptorOSP.VentanaKit == '3') {
                    receptor.Ventana_kit_Value__c = '+3';
                } else {
                    receptor.Ventana_kit_Value__c = receptorOSP.VentanaKit;
                }
            }
            if(receptorOSP.CB11 != null) {
                receptor.CB_11__c = true;
                if(receptorOSP.CB11 == '1') {
                    receptor.CB_11_Value__c = '+1';
                } else if(receptorOSP.CB11 == '2') {
                    receptor.CB_11_Value__c = '+2';
                } else if(receptorOSP.CB11 == '3') {
                    receptor.CB_11_Value__c = '+3';
                } else {
                    receptor.CB_11_Value__c = receptorOSP.CB11;
                }
            }
            receptor.IHC_test_not_done__c = Boolean.valueOf(receptorOSP.IHCTestNotDone);
                if(receptorOSP.VentanaOncoprobe != null) {
                receptor.Ventana_Oncoprobe__c = true;
                if(receptorOSP.VentanaOncoprobe == '1') {
                    receptor.Ventana_Oncoprobe_Value__c = '+1';
                } else if(receptorOSP.VentanaOncoprobe == '2') {
                    receptor.Ventana_Oncoprobe_Value__c = '+2';
                } else if(receptorOSP.VentanaOncoprobe == '3') {
                    receptor.Ventana_Oncoprobe_Value__c = '+3';
                } else {
                    receptor.Ventana_Oncoprobe_Value__c = receptorOSP.VentanaOncoprobe;
                }
            }
            if(receptorOSP.OtherFISHTest != null) {
                receptor.Other_FISH_Test__c = true;
                receptor.Other_FISH_Test_Value__c = receptorOSP.OtherFISHTest;
            }
            receptor.Other_FISH_Results__c = receptorOSP.OtherFISHResults;
            receptor.FISH_test_not_done__c = Boolean.valueOf(receptorOSP.FISHTestNotDone);
            receptor.Vysis_Path_Vision__c = Boolean.valueOf(receptorOSP.VysisPathVision);
            receptor.Vysis_Path_Vision_Value__c = receptorOSP.VysisPathVisionValue;
            receptor.Letarality__c = receptorOSP.Letarality;
            system.debug('receptor : '+receptor);
            lstReceptor.add(receptor);
        }
        try {
            insert lstReceptor;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstReceptor.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess : ' + lstReceptor.size() +' row inserted.');
        return transId;
    }


       public String createStagingDetail(String institution, String site, String trial, List<Staging_OSP_CRF> lstStaging_OSP_CRF) {
        List<Staging_Detail__c> lstStagingDetail = new List<Staging_Detail__c>();
        Set<String> crfIds = new Set<String>();
        for(Staging_OSP_CRF stagingOSP : lstStaging_OSP_CRF) {
            crfIds.add(stagingOSP.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<Post_Surgaory_Summary__c> lstPSS = [select Id, TestHarnessId__c from Post_Surgaory_Summary__c where TestHarnessId__c IN :crfIds];
        for(Post_Surgaory_Summary__c postSurObj : lstPSS) {
         mapCRFIds.put(postSurObj.TestHarnessId__c, postSurObj.Id);
        }
      
        for(Staging_OSP_CRF stagingOSP :  lstStaging_OSP_CRF) {
            Staging_Detail__c staging = new Staging_Detail__c();
          
            if(stagingOSP.CRFId != null && stagingOSP.CRFId != '') {
                if(mapCRFIds.get(stagingOSP.CRFId) != null) {
                   staging.Post_Surgery_Summary__c = mapCRFIds.get(stagingOSP.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
              
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
        
        staging.Letarality__c = stagingOSP.Letarality;  
        staging.Staging_Modifier_Type__c = stagingOSP.StagingModifierType;
        staging.Modifier_multiple_primary__c = Boolean.valueOf(stagingOSP.Modifiermultipleprimary);
        staging.Modifier_classification_done__c = Boolean.valueOf(stagingOSP.Modifierclassificationdone);
        staging.Modifier_indicates_recurrent__c = Boolean.valueOf(stagingOSP.Modifierindicatesrecurrent);
        staging.Modifier_designates__c= Boolean.valueOf(stagingOSP.Modifierdesignates);
        staging.Tumor_Type__c = stagingOSP.TumorType;
        staging.Node_Type__c = stagingOSP.NodeType;
        staging.Metastasis__c = stagingOSP.Metastasis;
        staging.Calculated_Stage__c = stagingOSP.CalculatedStage;
        staging.Calculated_Stage_Value__c = stagingOSP.CalculatedStageValue;
        staging.Adjudicated_Stage__c = stagingOSP.AdjudicatedStage;
        staging.Adjudicated_By__c = stagingOSP.AdjudicatedBy;
        staging.T4_Tumor_final_status__c = stagingOSP.T4Tumorfinalstatus;        
           system.debug('staging : '+staging);
           lstStagingDetail.add(staging);
        }
        try {
            insert lstStagingDetail;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstStagingDetail.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess : ' + lstStagingDetail.size() +' row inserted.');
        return transId;
    }
 
     public String createProcedures(String institution, String site, String trial, List<Procedure_OSP_PSS> lstProcedure_OSP_PSS) {
        List<Procedure__c> lstProcedure = new List<Procedure__c>();
       
        Set<String> crfIds = new Set<String>();
        for(Procedure_OSP_PSS pro_OSP : lstProcedure_OSP_PSS) {
            crfIds.add(pro_OSP.CRFId);
        }
        system.debug('crfIds : '+crfIds);
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<Post_Surgaory_Summary__c> lstPSS = [select Id, TestHarnessId__c from Post_Surgaory_Summary__c where TestHarnessId__c IN :crfIds];
        for(Post_Surgaory_Summary__c postSurObj : lstPSS) {
            mapCRFIds.put(postSurObj.TestHarnessId__c, postSurObj.Id);
        }
       
               
        for(Procedure_OSP_PSS procedure_OSP : lstProcedure_OSP_PSS) {
            Procedure__c pro = new Procedure__c();
           
            if(procedure_OSP.CRFId != null && procedure_OSP.CRFId != '') {
                String crfId = mapCRFIds.get(procedure_OSP.CRFId);
                 if(crfId != null) {
                    if(crfId.startsWith('a0Q')) {
                        pro.On_Study_Pathology_Form__c = crfId;
                    } else {
                        pro.Post_Surgery_Summary__c = crfId;
                    }
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for CRF) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
               
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
           
            pro.Procedure_Name__c = procedure_OSP.ProcedureName;            
            pro.Laterality__c = procedure_OSP.Laterality;
            pro.Location__c = procedure_OSP.Location;
            lstProcedure.add(pro);
        }
        try {
            insert lstProcedure;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstProcedure.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstProcedure.size() +' row inserted.');
        return transId;
    }
         public String createDCISs(String institution, String site, String trial, List<DCIS_OSP_CRF> lstDCIS_OSP_CRF) {
        List<DCIS__c> lstDCIS = new List<DCIS__c>();
      
        Set<String> crfIds = new Set<String>();
        for(DCIS_OSP_CRF dcisOSP : lstDCIS_OSP_CRF) {
            crfIds.add(dcisOSP.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
         List<Post_Surgaory_Summary__c> lstPSS = [select Id, TestHarnessId__c from Post_Surgaory_Summary__c where TestHarnessId__c IN :crfIds];
        for(Post_Surgaory_Summary__c postSurObj : lstPSS) {
         mapCRFIds.put(postSurObj.TestHarnessId__c, postSurObj.Id);
        }
      
        
      
        for(DCIS_OSP_CRF dcisOSP : lstDCIS_OSP_CRF) {
            DCIS__c dcis = new DCIS__c();
          
            if(dcisOSP.CRFId != null && dcisOSP.CRFId != '') {
                String crfId = mapCRFIds.get(dcisOSP.CRFId);
                if(crfId != null) {
                    if(crfId.startsWith('a0Q')) {
                        dcis.On_Study_Pathology_Form__c = crfId;
                    } else {
                        dcis.Post_Surgery_Summary__c = crfId;
                    }
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for CRF) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
              
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
          
          dcis.DCIS__c = Decimal.valueOf(dcisOSP.DCIS);
          dcis.Unknown_Not_Reported__c = Boolean.valueOf(dcisOSP.UnknownNotReported);
          dcis.Total_Histological_Span__c = Decimal.valueOf(dcisOSP.TotalHistologicalSpan);
          dcis.Total_Histological_Span_Measurement_Unit__c = dcisOSP.TotalHistologicalSpanMeasurementUnit;
          dcis.Margin__c = dcisOSP.Margin;
          dcis.Closest_Margin__c = dcisOSP.ClosestMargin;
          dcis.Specific_Closest_Margin__c = Decimal.valueOf(dcisOSP.SpecificClosestMargin);
          dcis.Specific_Closest_Margin_Measurement_Unit__c = dcisOSP.SpecificClosestMarginMeasurementUnit;
           if(dcisOSP.ClosestMargin != null) {
                
                if(dcisOSP.ClosestMargin == 'Specify') {
                    dcis.Specific_Closest_Margin_Measurement_Unit__c = 'CM';   
                } else if(dcisOSP.ClosestMargin == 'Specify') {
                    dcis.Specific_Closest_Margin_Measurement_Unit__c = 'MM';                 
                } else {
                    dcis.Specific_Closest_Margin_Measurement_Unit__c = dcisOSP.ClosestMargin;
             }
            }

            dcis.Punctate_necrosis__c = Boolean.valueOf(dcisOSP.PunctateNecrosis);
            dcis.Comedonecrosis__c = Boolean.valueOf(dcisOSP.Comedonecrosis);
            dcis.Papillary__c = Boolean.valueOf(dcisOSP.Papillary);
            dcis.Micropapillary__c = Boolean.valueOf(dcisOSP.Micropapillary);
            dcis.Necrosis__c = Boolean.valueOf(dcisOSP.Necrosis);
            dcis.Cribiform__c = Boolean.valueOf(dcisOSP.Cribiform);
            dcis.Cruciform__c = Boolean.valueOf(dcisOSP.Cruciform);
            dcis.Clinging__c = Boolean.valueOf(dcisOSP.Clinging);
            dcis.Solid__c = Boolean.valueOf(dcisOSP.Solid);
            dcis.Apocrine__c = Boolean.valueOf(dcisOSP.Apocrine);
            dcis.Intra_cystic_encysted_papillary__c = Boolean.valueOf(dcisOSP.IntraCysticEncystedPapillary);
            if(dcisOSP.Other != null) {
                dcis.Other__c = true;
                dcis.Other_if_other_mention_type_in_textb__c = dcisOSP.Other; 
            }
             dcis.Nuclear_Grade__c = dcisOSP.NuclearGrade;
          
            lstDCIS.add(dcis);
        }
        try {
            insert lstDCIS;
          
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstDCIS.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstDCIS.size() +' row inserted.');
        return transId;
    }
  
    public String createLCISs(String institution, String site, String trial, List<LCIS_OSP_CRF> lstLCIS_OSP_CRF) {
        List<LCIS__c> lstLCIS = new List<LCIS__c>();
      
        Set<String> crfIds = new Set<String>();
        for(LCIS_OSP_CRF lcisOSP : lstLCIS_OSP_CRF) {
            crfIds.add(lcisOSP.CRFId);
        }
      
        Map<String, Id> mapCRFIds = new Map<String, Id>();
         List<Post_Surgaory_Summary__c> lstPSS = [select Id, TestHarnessId__c from Post_Surgaory_Summary__c where TestHarnessId__c IN :crfIds];
        for(Post_Surgaory_Summary__c postSurObj : lstPSS) {
         mapCRFIds.put(postSurObj.TestHarnessId__c, postSurObj.Id);
        }
      
        for(LCIS_OSP_CRF lcisOSP : lstLCIS_OSP_CRF) {
            LCIS__c lcis = new LCIS__c();
          
            if(lcisOSP.CRFId != null && lcisOSP.CRFId != '') {
                String crfId = mapCRFIds.get(lcisOSP.CRFId);
                if(crfId != null) {
                    if(crfId.startsWith('a0Q')) {
                        lcis.On_Study_Pathology_Form__c = crfId;
                    } else {
                        lcis.Post_Surgery_Summary__c = crfId;
                    }
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
              
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
          
            lcis.LCIS__c = Decimal.valueOf(lcisOSP.LCIS);
            lcis.Unknown_Not_Reported__c = Boolean.valueOf(lcisOSP.UnknownNotReported);
            lcis.Total_histological_span__c = Decimal.valueOf(lcisOSP.Totalhistologicalspan);
            lcis.Total_histological_span_measurement_unit__c = lcisOSP.Totalhistologicalspanmeasurementunit;
            lcis.Histological_Type__c = lcisOSP.HistologicalType;
            lstLCIS.add(lcis);
        }
        try {
            insert lstLCIS;
          
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstLCIS.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstLCIS.size() +' row inserted.');
        return transId;
    }
  
    public String createInvasiveTumors(String institution, String site, String trial, List<InvasiveTumor_OSP_PSS> lstInvasiveTumor_OSP_PSS) {
        List<Invasive_Tumor_Detail__c> lstInvTumor = new List<Invasive_Tumor_Detail__c>();
      
        Set<String> crfIds = new Set<String>();
        for(InvasiveTumor_OSP_PSS inv_OSP_PSS : lstInvasiveTumor_OSP_PSS) {
            crfIds.add(inv_OSP_PSS.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<Post_Surgaory_Summary__c> lstPSS = [select Id, TestHarnessId__c from Post_Surgaory_Summary__c where TestHarnessId__c IN :crfIds];
        for(Post_Surgaory_Summary__c postSurObj : lstPSS) {
         mapCRFIds.put(postSurObj.TestHarnessId__c, postSurObj.Id);
        }
      
        
      
        for(InvasiveTumor_OSP_PSS inv_OSP_PSS : lstInvasiveTumor_OSP_PSS) {
            Invasive_Tumor_Detail__c invTumor = new Invasive_Tumor_Detail__c();
          
            if(inv_OSP_PSS.CRFId != null && inv_OSP_PSS.CRFId != '') {
                String crfId = mapCRFIds.get(inv_OSP_PSS.CRFId);
                if(crfId != null) {
                    if(crfId.startsWith('a0Q')) {
                        invTumor.On_Study_Pathology_Form__c = crfId;
                    } else {
                        invTumor.Post_Surgery_Summary__c = crfId;
                    }
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for CRF) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
              
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
           invTumor.Overall_cancer_cellularity__c = Decimal.valueOf(inv_OSP_PSS.Overallcancercellularity);
           invTumor.Unknown_Not_Reported__c = Boolean.valueOf(inv_OSP_PSS.UnknownNotReported);
           invTumor.Tumor_Size_Height__c = Decimal.valueOf(inv_OSP_PSS.TumorSizeHeight);
           invTumor.Tumor_Size_Width__c = Decimal.valueOf(inv_OSP_PSS.TumorSizeWidth);
           invTumor.Tumor_Measurement_Unit__c = inv_OSP_PSS.TumorMeasurementUnit;
           invTumor.Multi_focal_Tumor__c = inv_OSP_PSS.MultifocalTumor;
           invTumor.Invasive_margins__c = inv_OSP_PSS.Invasivemargins;
           invTumor.Closest_Margin__c = inv_OSP_PSS.ClosestMargin;
           invTumor.Specify_No__c = Decimal.valueOf(inv_OSP_PSS.SpecifyNo);
           invTumor.Specify_Units__c = inv_OSP_PSS.SpecifyUnits;        
           invTumor.Invasive_ductal_carcinoma_nos__c = Boolean.valueOf(inv_OSP_PSS.InvasiveDuctalCarcinomaNos);
           invTumor.Invasive_lobular_carcinoma_classic_type__c = Boolean.valueOf(inv_OSP_PSS.InvasiveLobularCarcinomaClassicType);
           invTumor.Invasive_lobular_carcinoma_alveolar_type__c = Boolean.valueOf(inv_OSP_PSS.InvasiveLobularCarcinomaAlveolarType);
           invTumor.Pleomorphic_lobular_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.PleomorphicLobularCarcinoma);
           invTumor.Tubulolobular_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.TubulolobularCarcinoma);
           invTumor.Invasive_carcinoma_mixed_ductal_lobular__c = Boolean.valueOf(inv_OSP_PSS.InvasiveCarcinomaMixedDuctalAndLobularType);
           invTumor.Tubular_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.TubularCarcinoma);
           invTumor.Mucinous_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.MucinousCarcinoma);
           invTumor.Medullary_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.MedullaryCarcinoma);
           invTumor.Invasive_papillary_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.InvasivePapillaryCarcinoma);
           invTumor.Invasive_cribiform_carcinoma__c = Boolean.valueOf(inv_OSP_PSS.InvasiveCribiformCarcinoma);
           if(inv_OSP_PSS.Other != null) {
               invTumor.Other__c = true;
               invTumor.Other_if_other_mention_type_in_textbox__c = inv_OSP_PSS.Other;
            }        
            invTumor.Nuclear_Grade__c = inv_OSP_PSS.NuclearGrade;
            invTumor.Mitotic_Count__c = inv_OSP_PSS.MitoticCount;
            invTumor.Tubule_Papilla_formation__c = inv_OSP_PSS.TubulePapillaFormation;
            invTumor.Total_Points__c = inv_OSP_PSS.TotalPoints;
            invTumor.SBR_Grade__c = inv_OSP_PSS.SBRGrade;
            invTumor.Lympatic_vascular_Invasion__c = inv_OSP_PSS.LympaticVascularInvasion;
            invTumor.Dermal_Involvement__c = inv_OSP_PSS.DermalInvolvement;
            invTumor.Muscle_involvement__c = inv_OSP_PSS.Muscleinvolvement;
            invTumor.Evidence_of_therapeutic_effects__c = inv_OSP_PSS.Evidenceoftherapeuticeffects;
            invTumor.Other_changes_present__c = inv_OSP_PSS.Otherchangespresent ;
            lstInvTumor.add(invTumor);
        }
        try {
            insert lstInvTumor;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
            lstInvTumor.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstInvTumor.size() +' row inserted.');
        return transId;
    } 
    
   
       public String createChemoTreatment(String institution, String site, String trial, List<ChemoTreatmentCRF> lstChemoTreatmentCRF) {
        
        List<Chemo_Treatment__c> lstCTF = new List<Chemo_Treatment__c>();
        Map<String, String> mapRecordType = getObjectRecordType('Chemo_Treatment__c');
      system.debug('inst : '+institution+'    site : '+site+'   trial : '+trial);
        
        List<TrialPatient__c> lstTrialPatient = [Select Trial_Id__c, Patient_Id__r.TestHarnessId__c, Patient_Id__r.IsTestHarnessPatient__c, Patient_Id__c From TrialPatient__c t where Trial_Id__c = :trial and Site__c = :site and Patient_Id__r.IsTestHarnessPatient__c = true];
      system.debug('lstTrialPatient : '+lstTrialPatient);
        Map<String, TrialPatient__c> mapTrialPatient = new Map<String, TrialPatient__c>();
      Map<Id, Id> mapTrialPatient1 = new Map<Id, Id>();

        for(TrialPatient__c trialPatient : lstTrialPatient) {
            mapTrialPatient.put(trialPatient.Patient_Id__r.TestHarnessId__c, trialPatient);
          mapTrialPatient1.put(trialPatient.Id, trialPatient.Patient_Id__c);
        }
        system.debug('mapTrialPatient : '+mapTrialPatient);
        for(ChemoTreatmentCRF CTF_CRF : lstChemoTreatmentCRF) {
            Chemo_Treatment__c chemoTreatment = new Chemo_Treatment__c();
           system.debug('CTF_CRF.CRFId : '+CTF_CRF.CRFId);
            if(CTF_CRF.CRFId != null && CTF_CRF.CRFId != '') {
             chemoTreatment.TestHarnessId__c = CTF_CRF.CRFId; 
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRFID (Unique identifier for CRF).');
                system.debug('transId : '+transId);
                return transId;
            }
         String dateString = CTF_CRF.Dateoftherapy;
            List<String> splitedDate = dateString.split('/');
            if(splitedDate != null && splitedDate.size() == 3) {
            chemoTreatment.Date_of_therapy__c = Date.newinstance(Integer.valueOf(splitedDate[2]), Integer.valueOf(splitedDate[1]), Integer.valueOf(splitedDate[0]));
            }
       chemoTreatment.Cycle_number__c = Decimal.valueOf(CTF_CRF.Cyclenumber);
       chemoTreatment.Did_patient_go_off_study_treatment__c = Boolean.valueOf(CTF_CRF.Didpatientgooffstudytreatment);
       chemoTreatment.Patient_weight__c = Decimal.valueOf(CTF_CRF.Patientweight);
       chemoTreatment.Patient_height__c = Decimal.valueOf(CTF_CRF.Patientheight);                     
            if(CTF_CRF.PatientId != null && CTF_CRF.PatientId != '') {
                if(mapTrialPatient.get(CTF_CRF.PatientId) != null) {
                 chemoTreatment.TrialPatient__c = mapTrialPatient.get(CTF_CRF.PatientId).Id;
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid PatientID (Unique identifier for Patient) - Patient Id is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide PatientID (Unique identifier for Patient).');
                system.debug('transId : '+transId);
                return transId;
            }
            
            String compDate = CTF_CRF.completedDate;
            if(compDate != null) {
                List<String> lstCompDate = compDate.split('/');
                if(lstCompDate != null && lstCompDate.size() == 3) {
                 chemoTreatment.CompletedDate__c = Date.newinstance(Integer.valueOf(lstCompDate[2]), Integer.valueOf(lstCompDate[1]), Integer.valueOf(lstCompDate[0]));
                }
            }
         chemoTreatment.Status__c = CTF_CRF.Status;
            if(chemoTreatment.Status__c == 'Completed' ||chemoTreatment.Status__c == 'Not Completed'){
             chemoTreatment.RecordTypeId = mapRecordType.get('Live');
            } else {
             chemoTreatment.RecordTypeId = mapRecordType.get('Approval Pending');               
            } 
           lstCTF.add(chemoTreatment);
        }
        try {
            insert lstCTF;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
          lstCTF.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' + lstCTF.size() +' row inserted.');
        return transId;      
        }
      
      public String createChemoTherapyRegimen(String institution, String site, String trial, List<ChemoTherapyRegimen_CRF_CTF> lstChemoTherapyRegimen_CRF_CTF) {
        List<Chemo_Therapy_Regimen__c> lstChemoTherapyRegimen = new List<Chemo_Therapy_Regimen__c>();
        
        Set<String> CRFIds = new Set<String>();
        for(ChemoTherapyRegimen_CRF_CTF ctr_CRF : lstChemoTherapyRegimen_CRF_CTF) {
           CRFIds.add(ctr_CRF.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<Chemo_Treatment__c> lstCTF = [select Id, TestHarnessId__c from Chemo_Treatment__c where TestHarnessId__c IN :CRFIds];
        for(Chemo_Treatment__c chemoTreatment : lstCTF) {
            mapCRFIds.put(chemoTreatment.TestHarnessId__c,chemoTreatment.Id);
        }
        
        
        for(ChemoTherapyRegimen_CRF_CTF ChemoTherapyRegimen_CRF : lstChemoTherapyRegimen_CRF_CTF) {
          Chemo_Therapy_Regimen__c chemoTherapy = new Chemo_Therapy_Regimen__c();
         chemoTherapy.Agent__c = ChemoTherapyRegimen_CRF.Agent != null && ChemoTherapyRegimen_CRF.Agent != '' ? ChemoTherapyRegimen_CRF.Agent : null;
         //bc.Daignosis__c = BC_CRF.Daignosis != null && BC_CRF.Daignosis != '' ? BC_CRF.Daignosis : null;
       chemoTherapy.Prescribed_Dose__c = Decimal.valueOf(ChemoTherapyRegimen_CRF.PrescribedDose);
       chemoTherapy.Total_Dose__c = Decimal.valueOf(ChemoTherapyRegimen_CRF.TotalDoseAdministered);
       chemoTherapy.Day__c = Decimal.valueOf(ChemoTherapyRegimen_CRF.Day);
          chemoTherapy.Dose_Delay__c = ChemoTherapyRegimen_CRF.DoseDelay;
          chemoTherapy.Dose_Mod__c = Decimal.valueOf(ChemoTherapyRegimen_CRF.DoseMod);
        chemoTherapy.Dose_modification__c = ChemoTherapyRegimen_CRF.Dosemodification;          
          chemoTherapy.Other_Dose_Mod_Reason__c = ChemoTherapyRegimen_CRF.OtherDoseModReason;
        chemoTherapy.Did_patient_stop_receiving__c = Boolean.valueOf(ChemoTherapyRegimen_CRF.Didpatientstopreceiving);
        chemoTherapy.Reason_why_patient_stopped_receiving__c = ChemoTherapyRegimen_CRF.Reasonwhypatientstoppedreceiving;
        chemoTherapy.Other_Reason_Patient_Stop_Receiving__c = ChemoTherapyRegimen_CRF.OtherReasonPatientStopReceiving;
        chemoTherapy.Other_Agent__c = ChemoTherapyRegimen_CRF.OtherAgent;
        //chemoTherapy.Prescribed_Dose__c = Decimal.valueOf(ChemoTherapyRegimen_CRF.PrescribedDose1);
        chemoTherapy.Prescribed_dose_Units__c = ChemoTherapyRegimen_CRF.PrescribeddoseUnits;
        //chemoTherapy.Total_Dose__c = Decimal.valueOf(ChemoTherapyRegimen_CRF.TotalDoseAdministered1);
        chemoTherapy.Administered_dose_Units__c = ChemoTherapyRegimen_CRF.AdministereddoseUnits;
        //chemoTherapy.Day__c = Decimal.valueOf(ChemoTherapyRegimen_CRF.Day1);
       // chemoTherapy.Dose_Delay__c = ChemoTherapyRegimen_CRF.DoseDelay1;
          
           if(ChemoTherapyRegimen_CRF.CRFId != null && ChemoTherapyRegimen_CRF.CRFId != '') {
                if(mapCRFIds.get(ChemoTherapyRegimen_CRF.CRFId) != null) {
                 chemoTherapy.Chemo_Treatment__c = mapCRFIds.get(ChemoTherapyRegimen_CRF.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
        lstChemoTherapyRegimen.add(chemoTherapy);
        }
        try {
            insert lstChemoTherapyRegimen;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
        lstChemoTherapyRegimen.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstChemoTherapyRegimen.size() +' row inserted.');
        return transId;
    }

public String createGrowthFactor(String institution, String site, String trial, List<GrowthFactor_CRF_CTF> lstGrowthFactor_CRF_CTF) {
        List<Growth_Factor__c> lstGrowthFact = new List<Growth_Factor__c>();
        
        Set<String> CRFIds = new Set<String>();
        for(GrowthFactor_CRF_CTF gf_CRF : lstGrowthFactor_CRF_CTF) {
           CRFIds.add(gf_CRF.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<Chemo_Treatment__c> lstCTF = [select Id, TestHarnessId__c from Chemo_Treatment__c where TestHarnessId__c IN :CRFIds];
        for(Chemo_Treatment__c chemoTreatment : lstCTF) {
            mapCRFIds.put(chemoTreatment.TestHarnessId__c,chemoTreatment.Id);
        }
        
        
        for(GrowthFactor_CRF_CTF GrowthFactor_CRF : lstGrowthFactor_CRF_CTF) {
           Growth_Factor__c gf = new Growth_Factor__c();
          gf.Name = GrowthFactor_CRF.Name;
          gf.Dose__c = Decimal.valueOf(GrowthFactor_CRF.Dose);
          gf.TotalDose__c = Decimal.valueOf(GrowthFactor_CRF.TotalDose);
        gf.Route__c = GrowthFactor_CRF.Route;         
          gf.Notes__c = GrowthFactor_CRF.Notes;
          gf.isReceived__c = true ;//Boolean.valueOf(GrowthFactor_CRF.isReceived);
          system.debug('gf boolean------'+Boolean.valueOf(GrowthFactor_CRF.isReceived));
          system.debug('gf boolean 2------'+GrowthFactor_CRF.isReceived);
          
          system.debug('gf.isReceived__c------'+gf.isReceived__c);
          
          
           if(GrowthFactor_CRF.CRFId != null && GrowthFactor_CRF.CRFId != '') {
                if(mapCRFIds.get(GrowthFactor_CRF.CRFId) != null) {
                 gf.Chemo_Treatment__c = mapCRFIds.get(GrowthFactor_CRF.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
         lstGrowthFact.add(gf);
        }
        try {
            insert lstGrowthFact;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
         lstGrowthFact.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstGrowthFact.size() +' row inserted.');
        return transId;
    }

        public String createConcomitantMedication(String institution, String site, String trial, List<ConcomitantMedication_CRF_CTF> lstConcomitantMedication_CRF_CTF) {
        List<Concomitant_Medication__c> lstConMedication = new List<Concomitant_Medication__c>();
        
        Set<String> CRFIds = new Set<String>();
        for(ConcomitantMedication_CRF_CTF cm_CRF : lstConcomitantMedication_CRF_CTF) {
           CRFIds.add(cm_CRF.CRFId);
        }
        Map<String, Id> mapCRFIds = new Map<String, Id>();
        List<Chemo_Treatment__c> lstCTF = [select Id, TestHarnessId__c from Chemo_Treatment__c where TestHarnessId__c IN :CRFIds];
        for(Chemo_Treatment__c chemoTreatment : lstCTF) {
            mapCRFIds.put(chemoTreatment.TestHarnessId__c,chemoTreatment.Id);
        }
        
        
        for(ConcomitantMedication_CRF_CTF ConcomitantMedication_CRF : lstConcomitantMedication_CRF_CTF) {
            Concomitant_Medication__c conMed = new Concomitant_Medication__c();
          conMed.Type__c = ConcomitantMedication_CRF.Type;
          conMed.Other_Madication__c = ConcomitantMedication_CRF.OtherMadication;
        conMed.Medication__c = ConcomitantMedication_CRF.Medication != null && ConcomitantMedication_CRF.Medication != '' ? ConcomitantMedication_CRF.Medication : null;
        //bc.Daignosis__c = BC_CRF.Daignosis != null && BC_CRF.Daignosis != '' ? BC_CRF.Daignosis : null;
        conMed.Start_Year__c = ConcomitantMedication_CRF.StartYear;
        conMed.Start_Month__c = ConcomitantMedication_CRF.StartMonth;
        conMed.Start_Day__c = ConcomitantMedication_CRF.StartDay;
        conMed.End_Year__c = ConcomitantMedication_CRF.EndYear;
        conMed.End_Month__c = ConcomitantMedication_CRF.EndMonth;
        conMed.End_Day__c = ConcomitantMedication_CRF.EndDay;
        conMed.DoseValue__c = ConcomitantMedication_CRF.DoseValue;
        conMed.Dose__c = ConcomitantMedication_CRF.Dose;
        conMed.Route__c = ConcomitantMedication_CRF.Route;
        conMed.Frequency__c = ConcomitantMedication_CRF.Frequency;
                    
           if(ConcomitantMedication_CRF.CRFId != null && ConcomitantMedication_CRF.CRFId != '') {
                if(mapCRFIds.get(ConcomitantMedication_CRF.CRFId) != null) {
                 conMed.Chemo_Treatment__c = mapCRFIds.get(ConcomitantMedication_CRF.CRFId);
                } else {
                    transId = insertErrorLog('Failure : '+'Invalid CRF ID (Unique identifier for Tissue Specimen Form) - CRF ID is not available in our Database.');
                    system.debug('transId : '+transId);
                    return transId;
                }
                
            } else {
                transId = insertErrorLog('Failure : '+'Required field missing - Please provide CRF ID (Unique identifier for Tissue Specimen Form).');
                system.debug('transId : '+transId);
                return transId;
            }
         lstConMedication.add(conMed);
        }
        try {
            insert lstConMedication;
        } catch(Exception e) {
            transId = insertErrorLog('Failure : '+e.getMessage());
         lstConMedication.clear();
            return transId;
        }
        transId = insertErrorLog('Sucess :  ' +lstConMedication.size() +' row inserted.');
        return transId;
    } 
 
    public List<List<RandomizationResultWrapper>> getRandomizationResult(String sortFullExp) {
        
        List<RandomizationResultWrapper> lstRandResult = new List<RandomizationResultWrapper>();
        List<List<RandomizationResultWrapper>> lstRandResultList = new List<List<RandomizationResultWrapper>>();
        
        Datetime latestDate = null;
        Datetime previousDate = null;
        String ltDateAsString = '';
        String prDateAsString = '';
        //List<RandomizationTestingDetail__c> lstResult = new List<RandomizationTestingDetail__c>();
        List<TestHarnessHistory__c> lstHistory = [Select t.TestHarnessType__c, t.Status__c, t.CreatedDate, t.LastModifiedDate From TestHarnessHistory__c t where TestHarnessType__c = 'Randomization' order by CreatedDate DESC];
        if(lstHistory.size() > 1) {
            
            //latestDate = lstHistory[0].LastModifiedDate;
            previousDate = lstHistory[1].CreatedDate;
            system.debug('String date : '+latestDate);
            system.debug('String time : '+previousDate);
            
            //Previous day string operation
            String pryr = String.valueOf(previousDate.year());
            String prmnth = String.valueOf(previousDate.monthGmt());
            if(prmnth.length() == 1) {
                prmnth = '0'+prmnth;
            }
            String prday = String.valueOf(previousDate.dayGmt());
            if(prday.length() == 1) {
                prday = '0'+prday;
            }
            String prhr = String.valueOf(previousDate.hourGmt());
            if(prhr.length() == 1) {
                prhr = '0'+prhr;
            }
            String prmin = String.valueOf(previousDate.minuteGmt());
            if(prmin.length() == 1) {
                prmin = '0'+prmin;
            }
            String prsec = String.valueOf(previousDate.secondGmt());
            if(prsec.length() == 1) {
                prsec = '0'+prsec;
            }
            
            //ltDateAsString = ltyr+'-'+ltmnth+'-'+ltday+'T'+lthr+':'+ltmin+':'+ltsec+'Z';
            prDateAsString = pryr+'-'+prmnth+'-'+prday+'T'+prhr+':'+prmin+':'+prsec+'Z';
            
            system.debug('ltDateAsString : '+ltDateAsString);
            system.debug('prDateAsString : '+prDateAsString);
            
            //lstResult = Database.query('Select r.Request_XML__c, r.LastModifiedDate, r.MiddleName__c, r.RandomizationResponse__c, r.Race__c, r.PR__c, r.Name, r.MP__c, r.Laterality__c, r.LastName__c, r.IsRandomized__c, r.HER2ByTargetPrint__c, r.HER2ByIHC__c, r.HER2ByFISH__c, r.FirstName__c, r.ER__c From RandomizationTestingDetail__c r where LastModifiedDate >= '+prDateAsString+' and IsRandomized__c=true order by ' + sortFullExp);
            for(RandomizationTestingDetail__c res : Database.query('Select r.Request_XML__c, r.LastModifiedDate, r.MiddleName__c, r.RandomizationResponse__c, r.Race__c, r.PR__c, r.Name, r.MP__c, r.Laterality__c, r.LastName__c, r.IsRandomized__c, r.HER2ByTargetPrint__c, r.HER2ByIHC__c, r.HER2ByFISH__c, r.FirstName__c, r.ER__c From RandomizationTestingDetail__c r where LastModifiedDate >= '+prDateAsString+' and IsRandomized__c=true order by ' + sortFullExp)) {
                RandomizationResultWrapper randResult = new RandomizationResultWrapper();
                String firstName = res.FirstName__c==null?'':res.FirstName__c;
                String middleName = res.MiddleName__c==null?'':res.MiddleName__c;
                String lastName = res.LastName__c==null?'':res.LastName__c;
                randResult.patientName = lastName+', '+firstName;
                randResult.isRandomized = res.IsRandomized__c;
                randResult.treatmentArm = res.RandomizationResponse__c;
                randResult.randomizationDate = String.valueOf(res.LastModifiedDate);
                randResult.ER = res.ER__c;
                randResult.PR = res.PR__c;
                randResult.HER2IHC = res.HER2ByIHC__c;
                randResult.HER2FISH = res.HER2ByFISH__c;
                randResult.HER2TP = res.HER2ByTargetPrint__c;
                randResult.MP = res.MP__c;
                lstRandResult.add(randResult);
                if(lstRandResult.size() > 999) {
                    lstRandResultList.add(lstRandResult);
                    lstRandResult = new List<RandomizationResultWrapper>();
                }
            }
        } else if(lstHistory.size() == 1) {
            //latestDate = lstHistory[0].CreatedDate;
            
            //String ltyr = String.valueOf(latestDate.year());
            //String ltmnth = String.valueOf(latestDate.minuteGmt());
            //String ltday = String.valueOf(latestDate.dayGmt());
            //String lthr = String.valueOf(latestDate.hourGmt());
            //String ltmin = String.valueOf(latestDate.minuteGmt());
            //String ltsec = String.valueOf(latestDate.secondGmt());
            
            //ltDateAsString = ltyr+'-'+ltmnth+'-'+ltday+'T'+lthr+':'+ltmin+':'+ltsec+'Z';
            //lstResult = Database.query('Select r.Request_XML__c, r.MiddleName__c, r.LastModifiedDate , r.RandomizationResponse__c, r.Race__c, r.PR__c, r.Name, r.MP__c, r.Laterality__c, r.LastName__c, r.IsRandomized__c, r.HER2ByTargetPrint__c, r.HER2ByIHC__c, r.HER2ByFISH__c, r.FirstName__c, r.ER__c From RandomizationTestingDetail__c r where IsRandomized__c=true order by ' + sortFullExp);
            for(RandomizationTestingDetail__c res : Database.query('Select r.Request_XML__c, r.MiddleName__c, r.LastModifiedDate , r.RandomizationResponse__c, r.Race__c, r.PR__c, r.Name, r.MP__c, r.Laterality__c, r.LastName__c, r.IsRandomized__c, r.HER2ByTargetPrint__c, r.HER2ByIHC__c, r.HER2ByFISH__c, r.FirstName__c, r.ER__c From RandomizationTestingDetail__c r where IsRandomized__c=true order by ' + sortFullExp)) {
                RandomizationResultWrapper randResult = new RandomizationResultWrapper();
                String firstName = res.FirstName__c==null?'':res.FirstName__c;
                String middleName = res.MiddleName__c==null?'':res.MiddleName__c;
                String lastName = res.LastName__c==null?'':res.LastName__c;
                randResult.patientName = lastName+', '+firstName;
                randResult.isRandomized = res.IsRandomized__c;
                randResult.treatmentArm = res.RandomizationResponse__c;
                randResult.randomizationDate = String.valueOf(res.LastModifiedDate);
                randResult.ER = res.ER__c;
                randResult.PR = res.PR__c;
                randResult.HER2IHC = res.HER2ByIHC__c;
                randResult.HER2FISH = res.HER2ByFISH__c;
                randResult.HER2TP = res.HER2ByTargetPrint__c;
                randResult.MP = res.MP__c;
                lstRandResult.add(randResult);
                if(lstRandResult.size() > 999) {
                    lstRandResultList.add(lstRandResult);
                    lstRandResult = new List<RandomizationResultWrapper>();
                }
            }
        } 
        
        if(!lstRandResult.isEmpty()) {
            lstRandResultList.add(lstRandResult);
        }
        return lstRandResultList;
    }
    
    /*public class RandomizationResultWrapper {
        public String patientName {get;set;}
        public boolean isRandomized {get;set;}
        public String treatmentArm {get;set;}
        public String randomizationDate {get;set;}
    }*/
    
    public String insertErrorLog(String msg) {
        ErrorLog__c errorLog = new ErrorLog__c();
        errorLog.message__c = msg;
        if(msg != null && msg.contains('Failure : '))
            errorLog.IsSuccess__c = false;
        else 
            errorLog.IsSuccess__c = true;
        insert errorLog;
        
        return errorLog.Id;
    }
    
    public String insertErrorLog(String msg, String successResult) {
        ErrorLog__c errorLog = new ErrorLog__c();
        errorLog.message__c = msg;
        errorLog.Result__c = successResult;
        if(msg != null && msg.contains('Failure : '))
            errorLog.IsSuccess__c = false;
        else 
            errorLog.IsSuccess__c = true;
        insert errorLog;
        
        return errorLog.Id;
    }
    
    Map<String, String> getObjectRecordType(String sobjectName) {
        List<RecordType> lstRType = [Select SobjectType, Name From RecordType r where SobjectType = :sobjectName];
        Map<String, String> mapRecordType = new Map<String, String>();
        for(RecordType rt : lstRType) {
            mapRecordType.put(rt.Name, rt.Id);
        }
        return mapRecordType;
    }
}