Public with sharing class pretreatmentCompltMammafilledController{
    public String data{get;set;}
    public pretreatmentCompltMammafilledController(){
         data = '[\'Type\',\' Number Of Patients\'],';
         set<Id> patientPreTreatment = new set<Id>();
         set<Id> patientMammaprint = new set<Id>();
         String siteId = ApexPages.CurrentPage().getParameters().get('site');
         if((siteId != '' && siteId != null) ){
            String condition ='';
            if(siteId != '' && siteId != null){
                 condition +='and TrialPatient__r.Site__c IN ('+siteId+')';
            }
            List<TissueSpecimenDetail__c > pretreatment =    database.query('SELECT CRFId__r.Patient__c FROM TissueSpecimenDetail__c where Time_Point__c  = \'Pre-Treatment\' and CRFId__r.Patient__c != null '+condition);  
            for(TissueSpecimenDetail__c  ts : pretreatment )
            patientPreTreatment.add(ts.CRFId__r.Patient__c);
            
            List<MammaPrintDetail__c > mammaprint = database.query('Select CRF__r.Patient__c , Tissue_Specimen_Detail__c From MammaPrintDetail__c where  Status__c = \'Approval Not Required\' and Tissue_Specimen_Detail__c in (SELECT Id  FROM TissueSpecimenDetail__c where Time_Point__c  = \'Pre-Treatment\') '+condition);
               for(MammaPrintDetail__c  ts : mammaprint )
                patientMammaprint.add(ts.CRF__r.Patient__c); 
             
         }    
         else{
              List<TissueSpecimenDetail__c > pretreatment =    database.query('SELECT CRFId__r.Patient__c FROM TissueSpecimenDetail__c where Time_Point__c  = \'Pre-Treatment\' and CRFId__r.Patient__c != null ');  
              for(TissueSpecimenDetail__c  ts : pretreatment )
                  patientPreTreatment.add(ts.CRFId__r.Patient__c);
            List<MammaPrintDetail__c > mammaprint = [Select CRF__r.Patient__c , Tissue_Specimen_Detail__c From MammaPrintDetail__c 
                where  Status__c = 'Approval Not Required' and Tissue_Specimen_Detail__c in (SELECT Id  FROM TissueSpecimenDetail__c where Time_Point__c  = 'Pre-Treatment') ];
           
            for(MammaPrintDetail__c  ts : mammaprint )
                patientMammaprint.add(ts.CRF__r.Patient__c);     
        }
        List<Patient_Custom__c> patientcount1 = [select id from Patient_Custom__c where Id in :patientPreTreatment];         
        List<Patient_Custom__c> patientcount2 = [select id from Patient_Custom__c where Id in :patientMammaprint];     
        if(patientcount1.size() == 0 && patientcount2.size() == 0)
            data += '[\'No Data\',0]';
        else
            data += '[\'Pre-Treatment Completed\','+patientcount1.size()+'],[\'Mamma Print Filled\','+patientcount2.size()+']';
       
       }
    
    
}