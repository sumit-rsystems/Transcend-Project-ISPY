Public with sharing class RegisteredPendingMammaprintDrillDown{
    public String data{get;set;}
    public RegisteredPendingMammaprintDrillDown(){
        data = '[\'Subject ID\',\' Registration CRF Completion Date\',\' Mammaprint CRF Due Date\'],';
        set<Id> numberofpatient = new set<Id>();
        set<Id> numberofpatient1 = new set<Id>();
        Integer no_of_registred_patient = 0, no_of_completed_mamaprint = 0;
        String drilldownfiled = ApexPages.CurrentPage().getParameters().get('drilldown');
        List<Registration__c >  registeredpatient = [SELECT TrialPatient__r.Patient_Id__c FROM Registration__c where Status__c = 'Approval Not Required' and TrialPatient__r.Patient_Id__c != null];
        List<Registration__c >  mammaprintfilledpatient = [SELECT TrialPatient__r.Patient_Id__c FROM Registration__c where Status__c = 'Approval Not Required' and TrialPatient__r.Patient_Id__c != null and TrialPatient__c in (Select TrialPatient__c From MammaPrintDetail__c where Status__c  != 'Approval Not Required' )];
        List<Registration__c >  mammaprintfilledpatient1 = [SELECT TrialPatient__r.Patient_Id__c FROM Registration__c where Status__c = 'Approval Not Required' and TrialPatient__r.Patient_Id__c != null and TrialPatient__c not in (Select TrialPatient__c From MammaPrintDetail__c )];
        
        for(Registration__c  r : registeredpatient)
            numberofpatient.add(r.TrialPatient__r.Patient_Id__c);
         LIST<Patient_Custom__c> patientregistered = [select Id from Patient_Custom__c where id in :numberofpatient];
         
         for(Registration__c  r : mammaprintfilledpatient )
            numberofpatient1.add(r.TrialPatient__r.Patient_Id__c);
            
         for(Registration__c  r : mammaprintfilledpatient1 )
            numberofpatient1.add(r.TrialPatient__r.Patient_Id__c);
               
         LIST<Patient_Custom__c> mammaprintfilled= [select Id from Patient_Custom__c where id in :numberofpatient1];
         List<Registration__c > registerd = new List<Registration__c >();
         if(drilldownfiled  == 'Registered Patient')
             registerd = [select CRF__c,TrialPatient__r.Patient_Id__r.Name, CompletedDate__c, Registration_Date__c from Registration__c where TrialPatient__r.Patient_Id__c in :numberofpatient and CompletedDate__c != null Order By Registration_Date__c];
         else if(drilldownfiled  == 'Pending Mammaprint CRF')
             registerd = [select CRF__c,TrialPatient__c,TrialPatient__r.Patient_Id__r.Name, CompletedDate__c, Registration_Date__c from Registration__c where TrialPatient__r.Patient_Id__c in :numberofpatient1 and CompletedDate__c != null Order By Registration_Date__c];    
         else
             registerd = [select CRF__c,TrialPatient__c,TrialPatient__r.Patient_Id__r.Name, CompletedDate__c, Registration_Date__c from Registration__c where (TrialPatient__r.Patient_Id__c in :numberofpatient or TrialPatient__r.Patient_Id__c in :numberofpatient1 ) and CompletedDate__c != null Order By Registration_Date__c];
         
         Map<String, String> mapDueDate = new Map<String, String>();
         Set<Id> crfIds = new Set<Id>();
         for(Registration__c r: registerd )
             crfIds.add(r.TrialPatient__c);
             
         List<PreEligibility_Checklist__c> task = [Select TrialPatient__c,CompletedDate__c from PreEligibility_Checklist__c where TrialPatient__c in :crfIds and CompletedDate__c != null ];
         for(PreEligibility_Checklist__c t: task ){
             if(!mapDueDate.containsKey(t.TrialPatient__c )){
                 mapDueDate.put(t.TrialPatient__c ,String.valueOf(t.CompletedDate__c.addDays(3)));
             }
         }
         //System.assert(false,mapDueDate );
         integer count=1;
         for(Registration__c  c: registerd ){
             if(count == registerd.size())
                data += '[\''+c.TrialPatient__r.Patient_Id__r.Name+'\',\''+c.CompletedDate__c+'\',\''+mapDueDate.get(c.TrialPatient__c)+'\']';
            else    
                data += '[\''+c.TrialPatient__r.Patient_Id__r.Name+'\',\''+c.CompletedDate__c+'\',\''+mapDueDate.get(c.TrialPatient__c)+'\'],';   
            count++;  
        }
                  
    }
}