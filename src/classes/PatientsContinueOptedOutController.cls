Public with sharing class PatientsContinueOptedOutController{
    public String data{get;set;} 
    public PatientsContinueOptedOutController(){
        data = '[\'Type \',\'Number of Patients\'],';
        Integer Continuedvar  = 0 ,OptedOutvar = 0 ; 
        List<Randomization_Form__c >  randomizationpatientlist;
        List<Randomization_Form__c >  randomizationpatientlist1;
         String instituteId = ApexPages.CurrentPage().getParameters().get('institute');
        String siteId = ApexPages.CurrentPage().getParameters().get('site');
        String trialId = ApexPages.CurrentPage().getParameters().get('trial');
        System.debug('****'+InstituteId+'****'+siteId+'******'+trialId);
        if((siteId != '' && siteId != null) || (instituteId != '' && instituteId != null) || (trialId != '' && trialId != null)){    
            String condition ='';
            if(instituteId != '' && instituteId != null){
                condition ='and CRF__r.Patient__r.Institution__c=\''+instituteId+'\'' ;
            }
            if(siteId != '' && siteId != null){
                 condition +='and TrialPatient__r.Site__c IN ('+siteId+')';
            }
            if(trialId != '' && trialId != null){
               condition +='and CRF__r.Trial__c=\''+trialId+'\'';
             } 
             System.debug('==========select Patient_Id__r.Ethnicity__c Ethnicity, Patient_Id__r.Age_Group__c age, count(Id) PatientCount from TrialPatient__c where  Patient_Id__r.Ethnicity__c != null and Patient_Id__r.Age_Group__c != null '+condition +' group by Patient_Id__r.Ethnicity__c, Patient_Id__r.Age_Group__c,Patient_Id__r.Institution__c');
          randomizationpatientlist = database.query('SELECT TrialPatient__r.Patient_Id__c,Randomization_Result__c FROM Randomization_Form__c where Randomization_Result__c != \'Not Randomized\' and Status__c = \'Approval Not Required\' and Did_Patient_Sign_Treatment_Consent_Form__c = true and TrialPatient__c not in (SELECT TrialPatient__c FROM Off_Study_Detail__c where  status__c = \'Accepted\') '+condition);
          randomizationpatientlist1 = database.query('SELECT TrialPatient__r.Patient_Id__c,Randomization_Result__c FROM Randomization_Form__c where Randomization_Result__c != \'Not Randomized\' and Status__c = \'Approval Not Required\' and Did_Patient_Sign_Treatment_Consent_Form__c = true and TrialPatient__c in (SELECT TrialPatient__c FROM Off_Study_Detail__c where  status__c = \'Accepted\') '+condition);
      }
      else {
        
        randomizationpatientlist = [SELECT TrialPatient__r.Patient_Id__c,Randomization_Result__c FROM Randomization_Form__c where Randomization_Result__c != 'Not Randomized' and Status__c = 'Approval Not Required' and Did_Patient_Sign_Treatment_Consent_Form__c = true and TrialPatient__c not in (SELECT TrialPatient__c   FROM Off_Study_Detail__c where  status__c = 'Accepted')];
        randomizationpatientlist1 = [SELECT TrialPatient__r.Patient_Id__c,Randomization_Result__c FROM Randomization_Form__c where Randomization_Result__c != 'Not Randomized' and Status__c = 'Approval Not Required' and Did_Patient_Sign_Treatment_Consent_Form__c = true and TrialPatient__c in (SELECT TrialPatient__c FROM Off_Study_Detail__c where  status__c = 'Accepted')];
        }
        
        set<Id> patientid = new set<Id>();
        for(Randomization_Form__c  rf: randomizationpatientlist ){
            patientid.add(rf.TrialPatient__r.Patient_Id__c);    
        }
        set<Id> patientid1 = new set<Id>();
        for(Randomization_Form__c  rf: randomizationpatientlist1 ){
            patientid1.add(rf.TrialPatient__r.Patient_Id__c);    
        }
        LIST<Patient_Custom__c> Continued = [select id from Patient_Custom__c where Id in :patientid];
        
        
        LIST<Patient_Custom__c> OptedOut = [select id from Patient_Custom__c where Id  in :patientid1];
        
        if(Continued.size() > 0 ){
            Continuedvar  =  Continued.size();
        }
        if(OptedOut.size() > 0){
            OptedOutvar  =  OptedOut.size();
        }
       if(OptedOutvar ==0 && Continuedvar   == 0)
           data += '[\'No Data\',0]';
       else     
           data += '[\'Continued Patient\','+Continuedvar+'],[\'Opted Out Patient\','+OptedOutvar+']';
    }
}