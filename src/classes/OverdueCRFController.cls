Public with sharing class OverdueCRFController{
    public String data{get;set;}
    public OverdueCRFController(){
        
        Set<Id> patientIDs = new Set<Id>();
        set<Id> noofpatient = new set<Id>();
        String siteId = ApexPages.CurrentPage().getParameters().get('site');
        String tabular = ApexPages.CurrentPage().getParameters().get('tabular');
        if(tabular != '' && tabular != null)
            data =  '[\'Site\',\' No. Of CRFs Overdue\'],';
        else
            data =  '[\'Site\',\' No. Of CRFs Overdue\'],[\'No Data\',0],';
        List<Task> alltask = database.query('Select t.CRF_Form_Id__c, t.WhatId From Task t where (t.Status = \'In Progress\' OR t.Status = \'Not Started\') AND t.WhatId != null  AND Original_Due_Date__c = LAST_N_DAYS:15 AND t.Object_Name__c != null order by CreatedDate asc ');
        for(Task task: alltask){
            patientIDs.add(task.WhatId);
        }
        
        List<AggregateResult> reg = new List<AggregateResult>();
        Map<String,String> mapSites = new Map<String,String>();
        String condition = '';
        if((siteId != '' && siteId != null)){
            if(siteId != '' && siteId != null){
                condition +=' and  Site__c IN ('+siteId+') ';
            }
            
            if(patientIds.size()>0) {
                reg = database.query('SELECT  count(Patient_Id__c) countCRF,Site__c cname FROM TrialPatient__c where Patient_Id__c in:patientIds '+condition+' and site__c != null group by site__c');
            }
               
        }
        else{
            reg = [SELECT  count(Patient_Id__c) countCRF,Site__c cname FROM TrialPatient__c where Patient_Id__c in:patientIds and site__c != null group by site__c];   
            
        }
        List<String> sites = new List<String>();
        for(AggregateResult c : reg ){
            sites.add(String.valueOf(c.get('cname')));
        }
        for (Site__c site: [ SELECT  Id,Name FROM Site__c where Name != null and id in:sites ]) {
            mapSites.put(site.Id,site.name );
        }
           
        integer count=1;
        for(AggregateResult c : reg ){
            if(count == reg.size()){
                if(tabular != '' && tabular != null)
                    data += '[\''+mapSites.get(String.valueOf(c.get('cname')))+'\','+c.get('countCRF')+']';
                else 
                    data += '[\''+mapSites.get(String.valueOf(c.get('cname')))+'\',{v:'+c.get('countCRF')+',f:\''+mapSites.get(String.valueOf(c.get('cname')))+'\'}]';
            }
            else{
                if(tabular != '' && tabular != null)
                    data += '[\''+mapSites.get(String.valueOf(c.get('cname')))+'\','+c.get('countCRF')+'],';
                else 
                    data += '[\''+mapSites.get(String.valueOf(c.get('cname')))+'\',{v:'+c.get('countCRF')+',f:\''+mapSites.get(String.valueOf(c.get('cname')))+'\'}],';
            }    
            
            count++;     
        }
        
        //System.assert(false,'Randomization======='+data); 
       
    }
         
        
}