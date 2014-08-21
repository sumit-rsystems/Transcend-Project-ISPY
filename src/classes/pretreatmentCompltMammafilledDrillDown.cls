Public with sharing class pretreatmentCompltMammafilledDrillDown{
    public String data{get;set;}
    public pretreatmentCompltMammafilledDrillDown(){
        data = '[\'Subject ID\',\' Tissue CRF completion date\',\' MammaPrint Due Date\'],';
        set<Id> patientPreTreatment = new set<Id>();
        set<Id> patientMammaprint = new set<Id>();
        String drilldownfiled = ApexPages.CurrentPage().getParameters().get('drilldown');
        
        List<TissueSpecimenDetail__c > pretreatment =    database.query('SELECT CRFId__r.Patient__c FROM TissueSpecimenDetail__c where Time_Point__c  = \'Pre-Treatment\' and CRFId__r.Patient__c != null ');  
        for(TissueSpecimenDetail__c  ts : pretreatment )
        patientPreTreatment.add(ts.CRFId__r.Patient__c);
        List<MammaPrintDetail__c > mammaprint = [Select CRF__r.Patient__c , Tissue_Specimen_Detail__c From MammaPrintDetail__c 
        where  Status__c = 'Approval Not Required' and Tissue_Specimen_Detail__c in (SELECT Id  FROM TissueSpecimenDetail__c where Time_Point__c  = 'Pre-Treatment') ];
        
        for(MammaPrintDetail__c  ts : mammaprint )
        patientMammaprint.add(ts.CRF__r.Patient__c);  
        List<TissueSpecimenDetail__c>   registerd = new List<TissueSpecimenDetail__c>();
        if(drilldownfiled  == 'Pre-Treatment Completed')
            registerd = [select TrialPatient__r.Patient_Id__r.Name, CompletedDate__c, CreatedDate from TissueSpecimenDetail__c where CompletedDate__c != null and TrialPatient__r.Patient_Id__c in :patientPreTreatment];
        else
            registerd = [select TrialPatient__r.Patient_Id__r.Name, CompletedDate__c, CreatedDate from TissueSpecimenDetail__c where CompletedDate__c != null and TrialPatient__r.Patient_Id__c in :patientMammaprint];    
        integer count=1;
        for(TissueSpecimenDetail__c c: registerd ){
            if(count == registerd.size())
            data += '[\''+c.TrialPatient__r.Patient_Id__r.Name+'\',\''+c.CompletedDate__c+'\',\''+c.CreatedDate+'\']';
            else    
            data += '[\''+c.TrialPatient__r.Patient_Id__r.Name+'\',\''+c.CompletedDate__c+'\',\''+c.CreatedDate+'\'],';   
            count++;  
        }
       
       }
    
    
}