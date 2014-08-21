Public with sharing class OverdueCRFDrillDown{
    public String data{get;set;}
    public OverdueCRFDrillDown(){
        data =  '[\'Phase\',\' CRF Name\',\'Subject ID\'],';
        Set<Id> registrationId= new Set<Id>();
        set<Id> noofpatient = new set<Id>();
        String drilldownfiled = ApexPages.CurrentPage().getParameters().get('drilldown');
        List<Task> alltask = database.query('Select t.CRF_Form_Id__c,t.whatId From Task t where (t.Status = \'In Progress\' OR t.Status = \'Not Started\') AND t.WhatId != null AND t.Original_Due_Date__c = LAST_N_DAYS:15 AND t.CRF_Form_Id__c != null AND t.Object_Name__c != null order by CreatedDate asc ');
        List<AggregateResult> reg;
        Map<String,String> mapSites = new Map<String,String>();
    //System.assert(false,alltask );
        
            for(Task task: alltask){
                registrationId.add(task.whatId);  
            }
            
        List<CRF__c>  registraedPatient;
        if(drilldownfiled  == '')
                registraedPatient = [Select TrialPatient__r.Phase_Master__r.Name, Type__c, TrialPatient__r.Subject_Id__c from CRF__c where Patient__c in:registrationId and TrialPatient__r.site__c != null and TrialPatient__r.Phase_Master__r.Name != null ];
        else
            registraedPatient = [Select TrialPatient__r.Phase_Master__r.Name, Type__c, TrialPatient__r.Subject_Id__c from CRF__c where Patient__c in:registrationId and TrialPatient__r.site__c != null and TrialPatient__r.Phase_Master__r.Name !=null and TrialPatient__r.Site__r.Name = :drilldownfiled];
        integer count=1;
        for(CRF__c c : registraedPatient){
            String type = c.Type__c.replace('__c','');
            String type1 = type.replace('_',' ');
            if(count == registraedPatient.size())
                data += '[\''+c.TrialPatient__r.Phase_Master__r.Name+'\',\''+type1+'\',\''+c.TrialPatient__r.Subject_Id__c+'\']';
            else    
                data += '[\''+c.TrialPatient__r.Phase_Master__r.Name+'\',\''+type1+'\',\''+c.TrialPatient__r.Subject_Id__c+'\'],';   
            count++;     
        }
        
       
       
    }
         
        
}