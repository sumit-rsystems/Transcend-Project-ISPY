Public with sharing class PatientspendingRandomizationController{
    public String data{get;set;}
    public PatientspendingRandomizationController(){
        
        Set<Id> patientId = new Set<Id>();
        set<Id> noofpatient = new set<Id>();
        String instituteId = ApexPages.CurrentPage().getParameters().get('institute');
        String siteId = ApexPages.CurrentPage().getParameters().get('site');
        String trialId = ApexPages.CurrentPage().getParameters().get('trial');
        String tabular = ApexPages.CurrentPage().getParameters().get('tabular');
        if(tabular != '' && tabular != null)
            data =  '[\'Site\',\'Count\'],';
        else
            data =  '[\'Site\',\'Count\'],[\' \',0],';
        Map<String,String> mapSites = new Map<String,String>(); 
        
        for(CRF__c  CRF: [SELECT Patient__c, Site__c  FROM CRF__c where (Type__c = 'TissueSpecimenDetail__c' or 
                    Type__c ='PreEligibility_Checklist__c' or Type__c = 'Registration__c' or Type__c = 'On_Study_Eligibility_Form__c'
                     or Type__c ='On_Study_Pathology_Form__c' or Type__c ='MRI_Volume__c' or Type__c = 'MammaPrintDetail__c' ) and 
                     (Status__c = 'Approval Not Required' or  Status__c = 'Accepted')]){
            patientId.add(CRF.Patient__c); 
        }
          
        List<AggregateResult>  crfPatient;          
        if((siteId != '' && siteId != null) || (instituteId != '' && instituteId != null) || (trialId != '' && trialId != null)){
            String condition ='';
            
        
            if(siteId != '' && siteId != null){
                     condition +='and Site__c IN ('+siteId+')';
            }
           
             //System.assert(false,''+'SELECT patient__c  FROM CRF__c where (Type__c = \'TissueSpecimenDetail__c\' or Type__c =\'PreEligibility_Checklist__c\' or Type__c = \'Registration__c\' or Type__c = \'On_Study_Eligibility_Form__c\' or Type__c =\'On_Study_Pathology_Form__c\' or Type__c =\'MRI_Volume__c\' or Type__c = \'MammaPrintDetail__c\' ) and (Status__c = \'Approval Not Required\' or  Status__c = \'Accepted\')'+condition);
            crfPatient = database.query('select  count(Patient_Id__c) countPatient,Site__c siteId from TrialPatient__c where Patient_Id__c in: patientId '+condition+' group by site__c');   
            
        }
        else{
            crfPatient = [select count(Patient_Id__c) countPatient,Site__c siteId from TrialPatient__c where Patient_Id__c in: patientId  group by site__c];
        }
        
        Set<Id> siteIds = new Set<Id>();
        for (AggregateResult ag: crfPatient ) {
            siteIds.add(String.valueOf(ag.get('siteId')));
        }
        for(Site__c site : [select name from Site__c where id in :siteIds])
             mapSites.put(site.Id,site.Name ); 
         Integer count=0;             
         for(AggregateResult c : crfPatient){
            if(count == crfPatient.size()){
                if(tabular != '' && tabular != null)
                    data += '[\''+mapSites.get(String.valueOf(c.get('siteId')))+'\','+c.get('countPatient')+']'; 
                else
                    data += '[\''+mapSites.get(String.valueOf(c.get('siteId')))+'\',{v:'+c.get('countPatient')+',f:\''+mapSites.get(String.valueOf(c.get('siteId')))+'\'}]';
            }
            else{
                if(tabular != '' && tabular != null)
                    data += '[\''+mapSites.get(String.valueOf(c.get('siteId')))+'\','+c.get('countPatient')+'],';        
                else
                    data += '[\''+mapSites.get(String.valueOf(c.get('siteId')))+'\',{v:'+c.get('countPatient')+',f:\''+mapSites.get(String.valueOf(c.get('siteId')))+'\'}],';    
            }
            count++;     
        } 
         
         
        //System.assert(false,data );
      }  
}