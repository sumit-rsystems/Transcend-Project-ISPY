trigger RecoverPatientNameBeforeUpdate on Patient_Custom__c (after update,after insert) {
    
    /*if(Trigger.isUpdate){
        List<Patient_Custom__c> patientList = [Select p.Screen_Failure_Number__c From Patient_Custom__c p where First_Name__c='Screen' and Last_Name__c like '%Failure%' and Screen_Failure_Number__c != null order by Screen_Failure_Number__c desc limit 1];
        Integer counter = 1;
        if(!patientList.isEmpty()) {
            
            counter = Integer.valueOf((patientList[0].Screen_Failure_Number__c)+1);
        }
         
        for(Patient_Custom__c tmpPatient : trigger.new) {
            if(trigger.oldMap.get(tmpPatient.id).Signed_Screening__c == false && tmpPatient.Signed_Screening__c == true) {
                tmpPatient.First_Name__c = tmpPatient.Unsigned_Patient_First_Name__c;
                tmpPatient.Last_Name__c = tmpPatient.Unsigned_Patient_Last_Name__c;
            } else if(trigger.oldMap.get(tmpPatient.id).Signed_Screening__c == true && tmpPatient.Signed_Screening__c == false) {
                tmpPatient.Unsigned_Patient_First_Name__c = tmpPatient.First_Name__c;
                tmpPatient.Unsigned_Patient_Last_Name__c = tmpPatient.Last_Name__c;  
                tmpPatient.First_Name__c = 'Screen';
                tmpPatient.Last_Name__c = 'Failure '+counter;
                tmpPatient.Screen_Failure_Number__c = counter; 
                counter++;
            }
        }
    }*/
    /*for(Patient_Custom__c tmpPatient : trigger.new) {
        tmpPatient.Age_Snomed__c = SnomedCTCode.SnomedCode('Patient_Custom__c','Age__c','');
        tmpPatient.Race_Snomed__c = SnomedCTCode.SnomedCode('Patient_Custom__c','Race__c','');
        tmpPatient.Race_Asian_Snomed__c = SnomedCTCode.SnomedCode('Patient_Custom__c','Race__c','Asian');
        tmpPatient.Ethnicity_Snomed__c = SnomedCTCode.SnomedCode('Patient_Custom__c','Ethnicity__c','');
        tmpPatient.Ethnicity_value_Snomed__c = SnomedCTCode.SnomedCode('Patient_Custom__c','Ethnicity__c',tmpPatient.Ethnicity__c);
    }*/
    
    if(Trigger.isInsert){
        
        /*List<Code_Master__c> lstSnomedMaster = [select id,Name,Variable_Description__c from Code_Master__c where Name = 'Age' or Name = 'Race' or Name = 'Ethn'];
        List<Pre_Registration_Snomed_Codes__c> lstSnomed = new List<Pre_Registration_Snomed_Codes__c>();*/
        Set<Id> patientIds = new Set<Id>();
        for(Patient_Custom__c pat : Trigger.new){
            if(!RequiredFieldHandler.fromDataLoader) {
                if(pat.Last_Name__c == null || pat.Last_Name__c == '') {
                    throw new RequiredFieldException('Required field missing - Please provide Last Name.');
                } else if(pat.Gender__c == null || pat.Gender__c == '') {
                    throw new RequiredFieldException('Required field missing - Please provide Gender.');
                } else if(pat.Birthdate__c == null) {
                    throw new RequiredFieldException('Required field missing - Please provide Birthdate.');
                } else if(pat.Race__c == null || pat.Race__c == '') {
                    throw new RequiredFieldException('Required field missing - Please provide Race.');
                } else if(pat.Ethnicity__c == null || pat.Ethnicity__c == '') {
                    throw new RequiredFieldException('Required field missing - Please provide Ethnicity.');
                }
                if(pat.Status__c != 'Approval Not Required') continue;
                patientIds.add(pat.Id);
            }
            /*for(Code_Master__c sm : lstSnomedMaster){
                if(sm.Name == 'Age'){
                    Pre_Registration_Snomed_Codes__c sc = new Pre_Registration_Snomed_Codes__c();
                    sc.Name = '424144002'; 
                    SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('424144002', ''+pat.Age__c);
                    sc.Value__c = sw.snomedCodeVal;
                    sc.Code_System__c = sw.codeSystem;
                    sc.Code_Master__c = sm.Id;
                    sc.caIntegratorValue__c = sw.caIntegratorValue;
                    sc.Patient__c = pat.Id;
                    lstSnomed.add(sc);
                }
                if(sm.Name == 'Race'){
                    Pre_Registration_Snomed_Codes__c sc1 = new Pre_Registration_Snomed_Codes__c();
                    sc1.Name = '103579009';
                    SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('103579009', pat.Race__c);
                    sc1.Value__c = sw1.snomedCodeVal;
                    sc1.Code_System__c = sw1.codeSystem;
                    sc1.Code_Master__c = sm.Id;
                    sc1.caIntegratorValue__c = sw1.caIntegratorValue;
                    sc1.Patient__c = pat.Id;
                    lstSnomed.add(sc1);
                }
                if(sm.Name == 'Ethn'){ 
                    Pre_Registration_Snomed_Codes__c sc2 = new Pre_Registration_Snomed_Codes__c();
                    sc2.Name = '2002440';
                    SnomedCTCode.SnomedWrapper sw2 = SnomedCTCode.SnomedCode('2002440', pat.Ethnicity__c);
                    sc2.Value__c = sw2.snomedCodeVal;
                    sc2.Code_System__c = sw2.codeSystem;
                    sc2.caIntegratorValue__c = sw2.caIntegratorValue;
                    sc2.Code_Master__c = sm.Id;
                    sc2.Patient__c = pat.Id;
                    lstSnomed.add(sc2);
                }
            }*/
        } 
        if(!patientIds.isEmpty()) {
            SnomedCTCode.insertPatientRelatedCode(patientIds);
        }
        /*if(!lstSnomed.isEmpty()){
            insert lstSnomed;
        }*/
    }
    if(Trigger.isUpdate){
        Set<Id> patientIds = new Set<Id>();
        String isuserstatusNew;
        string isuserStatusOld;
        for(Patient_Custom__c pat : Trigger.new) {
            isuserstatusNew = pat.isUserStatus__c;
            isuserStatusOld = Trigger.oldMap.get(pat.id).isUserStatus__c;
            system.debug('-------isuserstatusNew-------'+isuserstatusNew);
            system.debug('-------isuserStatusOld-------'+isuserStatusOld);
            if(pat.Status__c != 'Approval Not Required') continue;
            patientIds.add(pat.Id);
        }
        List<Pre_Registration_Snomed_Codes__c> lstPRSC = [select id,Name,Patient__c from Pre_Registration_Snomed_Codes__c where Patient__c IN : patientIds 
                                                    and snomed_Code_Name__c IN ('424144002 | current chronological age | '
                                                    ,'103579009 | race | ', '2002440')];
        if(!lstPRSC.isEmpty()) {
            delete lstPRSC;
        }
        
        if(!patientIds.isEmpty()) {
            if(isuserstatusNew == '2' && isuserStatusOld == '1'){
                system.debug('--------isuserStatusOld---------'+isuserStatusOld);
                system.debug('-------isuserstatusNew---------'+isuserstatusNew);
            }else{
                system.debug('--------test---------');
                SnomedCTCode.insertPatientRelatedCode(patientIds);
            }
        }
        /*for(Patient_Custom__c pat : Trigger.new){
            for(Pre_Registration_Snomed_Codes__c prsc : lstPRSC){
                if(pat.Id == prsc.Patient__c){
                    if(prsc.Name == '424144002'){
                        SnomedCTCode.SnomedWrapper sw = SnomedCTCode.SnomedCode('424144002', ''+pat.Age__c);
                        prsc.Value__c = sw.snomedCodeVal;
                        prsc.Code_System__c = sw.codeSystem;
                        prsc.caIntegratorValue__c = sw.caIntegratorValue;
                    }
                    if(prsc.Name == '103579009'){
                        SnomedCTCode.SnomedWrapper sw1 = SnomedCTCode.SnomedCode('103579009', pat.Race__c);
                        prsc.Value__c = sw1.snomedCodeVal;
                        prsc.Code_System__c = sw1.codeSystem;
                        prsc.caIntegratorValue__c = sw1.caIntegratorValue;
                    }
                    if(prsc.Name == '2002440'){
                        SnomedCTCode.SnomedWrapper sw2 = SnomedCTCode.SnomedCode('2002440', pat.Ethnicity__c);
                        prsc.Value__c = sw2.snomedCodeVal;
                        prsc.Code_System__c = sw2.codeSystem;
                        prsc.caIntegratorValue__c = sw2.caIntegratorValue;
                    }
                }
            }
        }
        if(!lstPRSC.isEmpty()){
            update lstPRSC;
        }*/
    }
}