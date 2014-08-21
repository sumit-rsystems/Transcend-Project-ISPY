Public with sharing class EligiblebutPendingRegistration{
    public String data{get;set;}
    public EligiblebutPendingRegistration(){
        
        Set<Id> registrationId= new Set<Id>();
        set<Id> noofpatient = new set<Id>();
        String instituteId = ApexPages.CurrentPage().getParameters().get('institute');
        String siteId = ApexPages.CurrentPage().getParameters().get('site');
        String trialId = ApexPages.CurrentPage().getParameters().get('trial');
        String tabular = ApexPages.CurrentPage().getParameters().get('tabular');
        if(tabular != '' && tabular != null)
            data =  '[\'Type\',\' No. Of Patient\'],';
        else
            data =  '[\'Type\',\' No. Of Patient\'],[\'DummyData\',0],';
        List<CRF__c> allPatient = new List<CRF__c>();
        List<CRF__c> pendingRegistrationPatient = new List<CRF__c>();
        if((siteId != '' && siteId != null) || (instituteId != '' && instituteId != null) || (trialId != '' && trialId != null)){
            String condition ='';
            if(siteId != '' && siteId != null){
                condition +='and TrialPatient__r.Site__c IN ('+siteId+')';
            }
            //system.assert(false,'SELECT Patient__c,Phase__c  FROM CRF__c where type__c = \'PreEligibility_Checklist__c\' '+condition);
            allPatient  = database.query('SELECT Patient__c,Phase__c  FROM CRF__c where type__c = \'PreEligibility_Checklist__c\' '+condition);
            pendingRegistrationPatient  = database.query('SELECT Patient__c,Phase__c  FROM CRF__c where type__c = \'PreEligibility_Checklist__c\' and Patient__c not in (Select Patient__c from Registration__c where Status__c = \'Approval Not Required\') '+condition);
        System.debug('Randomization======='+allPatient  +'SELECT Patient__c,Phase__c  FROM CRF__c where type__c = \'PreEligibility_Checklist__c\' '+condition); 
        }
        else{
            allPatient  = database.query('SELECT Patient__c,Phase__c  FROM CRF__c where type__c = \'PreEligibility_Checklist__c\' ');
            pendingRegistrationPatient  = database.query('SELECT Patient__c,Phase__c  FROM CRF__c where type__c = \'PreEligibility_Checklist__c\' and Patient__c not in (Select Patient__c from Registration__c where Status__c = \'Approval Not Required\') ');
        }
        List<Id> totalPatient = new List<Id>();
        List<Id> pendingPatient = new List<Id>();
        for(CRF__c c :allPatient)
            totalPatient.add(c.Patient__c);
        for(CRF__c c :pendingRegistrationPatient )
            pendingPatient .add(c.Patient__c);
        Integer registeredPatient = totalPatient.size()-pendingPatient.size();
           if(tabular != '' && tabular != null)
                    data += '[\'Registered Patient\','+registeredPatient +'],[\'Pending Registration\','+pendingPatient.size()+']';
                else 
                    data += '[\'Registered Patient\',{v:'+registeredPatient +',f:\'Registered Patient\'}],[\'Pending Registration\',{v:'+pendingPatient.size()+',f:\'Pending Registration\'}]';
       
        
       System.debug('Eligile but Pending Registration'+data);
    }
         
        
}