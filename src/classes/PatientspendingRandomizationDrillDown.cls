Public with sharing class PatientspendingRandomizationDrillDown{
    public String data{get;set;}
    public PatientspendingRandomizationDrillDown(){
        data =  '[\'Last CRF Completion Date\',\'Last CRF Name\',\'Subject ID\'],';
        Set<Id> patientId = new Set<Id>();
        String drilldownfiled = ApexPages.CurrentPage().getParameters().get('drilldown');
        
       for(CRF__c  CRF: [SELECT Patient__c, Site__c  FROM CRF__c where (Type__c = 'TissueSpecimenDetail__c' or 
                    Type__c ='PreEligibility_Checklist__c' or Type__c = 'Registration__c' or Type__c = 'On_Study_Eligibility_Form__c'
                     or Type__c ='On_Study_Pathology_Form__c' or Type__c ='MRI_Volume__c' or Type__c = 'MammaPrintDetail__c' ) and 
                     (Status__c = 'Approval Not Required' or  Status__c = 'Accepted')]){
            patientId.add(CRF.Patient__c); 
        }
        set<Id> patientbySite = new set<Id>();
        if(drilldownfiled  == ''){
             for(TrialPatient__c p : [Select Patient_Id__c from TrialPatient__c where Patient_Id__c in :patientId ]){
                patientbySite.add(p.Patient_Id__c);
            }
        }
        else{
            for(TrialPatient__c p : [Select Patient_Id__c from TrialPatient__c where Patient_Id__c in :patientId and Site__r.Name = :drilldownfiled]){
                patientbySite.add(p.Patient_Id__c);
            }
        }    
        List<CRF__c>  registraedPatient = [Select Name,Type__c, Patient__r.Name, Complete_Date__c from CRF__c where Complete_Date__c != null and Patient__c in : patientbySite];
        integer count=1;
        for(CRF__c c : registraedPatient){
            String type = c.Type__c.replace('__c','');
            String type1 = type.replace('_',' ');
            if(count == registraedPatient.size())
                data += '[\''+c.Complete_Date__c+'\',\''+type1 +'\',\''+c.Patient__r.Name+'\']';
            else    
                data += '[\''+c.Complete_Date__c+'\',\''+type1 +'\',\''+c.Patient__r.Name+'\'],';
            count++;     
        }
         //System.assert(false,data);
      }  
     
        
}