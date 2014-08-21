Public with sharing class EligiblebutPendingRegistrationDrillDown{
    public String data{get;set;}
    public EligiblebutPendingRegistrationDrillDown(){
    try{
        String drilldownfiled = ApexPages.CurrentPage().getParameters().get('drilldown');
        data =  '[\'Subject IDs\',\' Pre-Eligibility completion date\', \'Due Date\'],';
        List<CRF__c> crfPatient = new List<CRF__c>();
        if(drilldownfiled == 'Registered Patient'){
            crfPatient = database.query('SELECT Id,Patient__r.Name,Complete_Date__c,CreatedDate,Patient__c  FROM CRF__c where type__c = \'PreEligibility_Checklist__c\' and Patient__c in (Select Patient__c from Registration__c where Status__c = \'Approval Not Required\') Order By Complete_Date__c');
        }
        else if(drilldownfiled == 'Pending Registration'){
            crfPatient = database.query('SELECT Id,Patient__r.Name,Complete_Date__c,CreatedDate,Patient__c  FROM CRF__c where type__c = \'PreEligibility_Checklist__c\' and Patient__c not in (Select Patient__c from Registration__c where Status__c = \'Approval Not Required\') Order By Complete_Date__c');
        }
        else{
            crfPatient = database.query('SELECT Id,Patient__r.Name,Complete_Date__c,CreatedDate,Patient__c  FROM CRF__c where type__c = \'PreEligibility_Checklist__c\'  Order By Complete_Date__c');    
        }
        Set<Id> trialP = new Set<Id>();
        for(CRF__c c :crfPatient){
            trialP.add(String.valueOf(c.Id));
       }
       List<PreEligibility_Checklist__c>  pri = [SELECT Patient__r.Name, CompletedDate__c FROM PreEligibility_Checklist__c where CRF_Id__c in :trialP];
      
      for(PreEligibility_Checklist__c c :pri ){
           String datestr = '';
           String compdate = '';
           if(String.valueOf(c.CompletedDate__c) != null){
               datestr = String.valueOf(c.CompletedDate__c);
               Datetime d = c.CompletedDate__c;
               compdate = ''+d.addDays(3);
           }    
               
               data += '[\''+c.Patient__r.Name+'\',\''+datestr +'\',\''+compdate +'\'],';
          
       }
       
       System.debug('*************************'+data+crfPatient.size());
      }
      catch(exception e) {
          
      }
    }
         
        
}