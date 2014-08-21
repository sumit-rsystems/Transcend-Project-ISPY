Public with sharing class RegisteredPendingMammaprintController{
    public String data{get;set;}
    public RegisteredPendingMammaprintController(){
        data = '[\'Type \',\' Number Of Patients\'],';
        set<Id> numberofpatient = new set<Id>();
        set<Id> numberofpatient1 = new set<Id>();
        Integer no_of_registred_patient = 0, no_of_completed_mamaprint = 0;
        String instituteId = ApexPages.CurrentPage().getParameters().get('institute');
        String siteId = ApexPages.CurrentPage().getParameters().get('site');
        String trialId = ApexPages.CurrentPage().getParameters().get('trial');
        if((siteId != '' && siteId != null) || (instituteId != '' && instituteId != null) || (trialId != '' && trialId != null)){    
            String condition ='';
           
            if(siteId != '' && siteId != null){
                 condition +='and Site__c IN ('+siteId+')';
            }
            
            List<Registration__c >  registeredpatient = database.query('SELECT TrialPatient__r.Patient_Id__c FROM Registration__c where Status__c = \'Approval Not Required\' and TrialPatient__r.Patient_Id__c!= null '+condition);
            List<Registration__c >  mammaprintfilledpatient = database.query('SELECT TrialPatient__r.Patient_Id__c FROM Registration__c where Status__c = \'Approval Not Required\' and TrialPatient__r.Patient_Id__c != null and TrialPatient__c not in (Select TrialPatient__c From MammaPrintDetail__c ) '+condition);
            List<Registration__c >  mammaprintfilledpatient1 = database.query('SELECT TrialPatient__r.Patient_Id__c FROM Registration__c where Status__c = \'Approval Not Required\' and TrialPatient__r.Patient_Id__c != null and TrialPatient__c  in (Select TrialPatient__c From MammaPrintDetail__c where Status__c  != \'Approval Not Required\'  ) '+condition);
            for(Registration__c  r : registeredpatient)
                numberofpatient.add(r.TrialPatient__r.Patient_Id__c );
             LIST<Patient_Custom__c> patientregistered = [select Id from Patient_Custom__c where id in :numberofpatient];
            
             for(Registration__c  r : mammaprintfilledpatient )
                numberofpatient1.add(r.TrialPatient__r.Patient_Id__c);
                
             for(Registration__c  r : mammaprintfilledpatient1 )
                numberofpatient1.add(r.TrialPatient__r.Patient_Id__c);
             
             LIST<Patient_Custom__c> mammaprintfilled= [select Id from Patient_Custom__c where id in :numberofpatient1];
             
             no_of_completed_mamaprint = mammaprintfilled.size();
             no_of_registred_patient  = patientregistered.size();
             Integer pendingmammaprint = no_of_completed_mamaprint ;
             
             if(pendingmammaprint == 0 && no_of_registred_patient == 0)
                 data += '[\'No Data\',0]';
             else
                 data += '[\'Registered Patient\','+no_of_registred_patient+'],[\'Pending Mammaprint CRF\','+pendingmammaprint+']'; 
      }    
    else{  
        List<Registration__c >  registeredpatient = [SELECT TrialPatient__r.Patient_Id__c FROM Registration__c where Status__c = 'Approval Not Required' and TrialPatient__r.Patient_Id__c != null];
        List<Registration__c >  mammaprintfilledpatient = [SELECT TrialPatient__r.Patient_Id__c FROM Registration__c where Status__c = 'Approval Not Required' and TrialPatient__r.Patient_Id__c != null and TrialPatient__c in (Select TrialPatient__c From MammaPrintDetail__c where Status__c  = 'Approval Not Required' )];
        List<Registration__c >  mammaprintfilledpatient1 = [SELECT TrialPatient__r.Patient_Id__c FROM Registration__c where Status__c = 'Approval Not Required' and TrialPatient__r.Patient_Id__c != null and TrialPatient__c not in (Select TrialPatient__c From MammaPrintDetail__c )];
        
        for(Registration__c  r : registeredpatient)
            numberofpatient.add(r.TrialPatient__r.Patient_Id__c);
         LIST<Patient_Custom__c> patientregistered = [select Id from Patient_Custom__c where id in :numberofpatient];
         
         for(Registration__c  r : mammaprintfilledpatient )
            numberofpatient1.add(r.TrialPatient__r.Patient_Id__c);
            
         for(Registration__c  r : mammaprintfilledpatient1 )
            numberofpatient1.add(r.TrialPatient__r.Patient_Id__c);
               
         LIST<Patient_Custom__c> mammaprintfilled= [select Id from Patient_Custom__c where id in :numberofpatient1];
         no_of_completed_mamaprint = mammaprintfilled.size();
         no_of_registred_patient  = patientregistered.size();
         Integer pendingmammaprint = no_of_completed_mamaprint ;
         
         if(pendingmammaprint == 0 && no_of_registred_patient == 0)
             data += '[\'No Data\',0]';
         else
             data += '[\'Registered Patient\','+no_of_registred_patient+'],[\'Pending Mammaprint CRF\','+pendingmammaprint+']';
       }           
    }
}