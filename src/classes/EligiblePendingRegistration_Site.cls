public with sharing class EligiblePendingRegistration_Site{
    public String data {get;set;}
    public String siteId;
    public String condition ;
    public EligiblePendingRegistration_Site(){
      data = ''; 
      siteId = ApexPages.CurrentPage().getParameters().get('site');
      
      List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
      String profileName = profiles[0].Name;
      if(profileName == 'Site User')
          siteUserData();
      if(profileName == 'DCC User')
          dccUserData();
     // System.assert(false,data);
    }
    
    public void siteUserData(){
        List<AggregateResult> ag;
        if(siteId != '' && siteId != null){
             condition ='and Site__c IN ('+siteId+')';
             List<TrialPatient__c> tp = database.query('select Patient_Id__c from TrialPatient__c where Site__c IN ('+siteId+')');
              ag = database.query('select count(Patient__c) countPatient ,Phase__c phase, TrialPatient__r.Site__c siteId from CRF__c where type__c = \'PreEligibility_Checklist__c\' and Patient__c not in (Select Patient__c from Registration__c where Status__c = \'Approval Not Required\') and Patient__c in (select Patient_Id__c from TrialPatient__c where Site__c IN ('+siteId+'))  Group By Phase__c,TrialPatient__r.Site__c');
          } 
        else
             ag = database.query('select count(Patient__c) countPatient ,Phase__c phase, TrialPatient__r.Site__c siteId from CRF__c where type__c = \'PreEligibility_Checklist__c\' and Patient__c not in (Select Patient__c from Registration__c where Status__c = \'Approval Not Required\')  Group By Phase__c,TrialPatient__r.Site__c');        
        if (ag.size() > 0) {
            data += '[\'Site Name\',';
            Map<String, List<String>> mapdata = new Map<String, List<String>>();
            List<String> phases = new List<String>();
            
            Map<String,String> mapsite = new Map<String,String>();
            List<String> siteId = new List<String>();
            for(AggregateResult agr : ag){
                siteId.add(String.valueOf(agr.get('siteId')));    
            }
            
            List<Site__c> site = [select Name from Site__c where id in :siteId] ;
            for(Site__c st : site ){
                  mapsite.put(st.id, st.Name);
           }
           
            for(AggregateResult agr : ag){
                if(agr.get('siteId') != null){
                    if(!mapdata.containskey(mapsite.get(String.valueOf(agr.get('siteId'))))){
                        mapdata.put(mapsite.get(String.valueOf(agr.get('siteId'))), new List<String>());
                    }  
                    mapdata.get(mapsite.get(String.valueOf(agr.get('siteId')))).add(agr.get('phase')+'##'+agr.get('countPatient'));
                    if(String.valueOf(agr.get('phase')) != null)
                    phases.add(String.valueOf(agr.get('phase')));
                }
            }
            
            phases.sort();
            Set<String> pahesset = new Set<String>();
            for(String st : phases){
              pahesset.add(st);    
            }
            for(String st : pahesset){
               data += '\''+st+'\',';    
            }  
            data = data.subString(0,data.length()-1)+'],';
            if(mapdata.size()>0){
                for(String st : mapdata.keySet()){
                    data += '[\''+st+'\',';
                    List<String> temp = mapdata.get(st);
                    temp.sort();
                    Integer count = pahesset.size();
                    for(String phase : temp){
                        List<String> pasecount = phase.split('##');
                        data += pasecount[1]+','; 
                        count--;
                    } 
                    for(Integer i=0; i<count ; i++)
                        data += '0,';     
                    data = data.subString(0,data.length()-1)+'],'; 
                   
               }  
             data = data.subString(0,data.length()-1);
            }
            else{
                data = '[\'Site Name\', \'NO Data\',\'No Data\'], [\'No Data\',0,0]';    
            }   
       }
       else {
           data = '[\'Site Name\', \'No Data\',\'No Data\'], [\'No Data\',0,0]';
       } 
    }
    public void dccUserData(){
         
        List<AggregateResult> ag;
        if(siteId != '' && siteId != null){
             condition ='and TrialPatient__r.Site__c IN ('+siteId+')';
             ag = database.query('select count(Patient__c) countPatient, TrialPatient__r.Site__c siteId, TrialPatient__r.Trial_Id__c trialId from CRF__c where type__c = \'PreEligibility_Checklist__c\' and Id not in (Select CRF__c from Registration__c where Status__c = \'Approval Not Required\') and Phase__c != null '+condition +' Group By TrialPatient__r.Site__c, TrialPatient__r.Trial_Id__c ');
        }
        else
            ag = database.query('select count(Patient__c) countPatient, TrialPatient__r.Site__c siteId, TrialPatient__r.Trial_Id__c trialId from CRF__c where type__c = \'PreEligibility_Checklist__c\' and Id not in (Select CRF__c from Registration__c where Status__c = \'Approval Not Required\') and Phase__c != null Group By TrialPatient__r.Site__c, TrialPatient__r.Trial_Id__c ');    
        if (ag.size() > 0) {
            data += '[\'Site Name\',';
            Map<String, List<String>> mapdata = new Map<String, List<String>>();
            List<String> phases = new List<String>();
            
            Map<String,String> maptrial = new Map<String,String>();
            List<String> trialId = new List<String>();
             Map<String,String> mapsite = new Map<String,String>();
            List<String> siteId = new List<String>();
            for(AggregateResult agr : ag){
                siteId.add(String.valueOf(agr.get('siteId')));    
            }
            for(AggregateResult agr : ag){
                trialId.add(String.valueOf(agr.get('trialId')));    
            }
            List<Trial__c> trial = [select Name from Trial__c where id in :trialId] ;
            for(Trial__c st : trial){
                  maptrial .put(st.id, st.Name);
            }
            List<Site__c> site = [select Name from Site__c where id in :siteId] ;
            for(Site__c st : site ){
                  mapsite.put(st.id, st.Name);
           }
            
            for(AggregateResult agr : ag){
                if(agr.get('trialId') != null){
                   if(!mapdata.containskey(maptrial.get(String.valueOf(agr.get('trialId'))))){
                        mapdata.put(maptrial.get(String.valueOf(agr.get('trialId'))), new List<String>());
                    }  
                    mapdata.get(maptrial.get(String.valueOf(agr.get('trialId')))).add(mapsite.get(String.valueOf(agr.get('siteId')))+'##'+agr.get('countPatient'));
                    if(mapsite.get(String.valueOf(agr.get('siteId'))) != null)
                    phases.add(mapsite.get(String.valueOf(agr.get('siteId'))));
                }
            }
            //System.assert(false,ag);
            phases.sort();
            Set<String> pahesset = new Set<String>();
            for(String st : phases){
              pahesset.add(st);    
            }
            for(String st : pahesset){
               data += '\''+st+'\',';    
            }  
            data = data.subString(0,data.length()-1)+'],';
            if(mapdata.size()>0){
                for(String st : mapdata.keySet()){
                    data += '[\''+st+'\',';
                    List<String> temp = mapdata.get(st);
                    temp.sort();
                    Integer count = pahesset.size();
                    for(String phase : temp){
                        List<String> pasecount = phase.split('##');
                        data += pasecount[1]+','; 
                        count--;
                    } 
                    for(Integer i=0; i<count ; i++)
                        data += '0,';     
                    data = data.subString(0,data.length()-1)+'],'; 
                   
               }  
             data = data.subString(0,data.length()-1);
            }
            else{
                data = '[\'Site Name\', \'No Data\',\'No Data\'], [\'No Data\',0,0]';    
            }   
       }
       else {
           data = '[\'Site Name\', \'No Data\',\'No Data\'], [\'No Data\',0,0]';
       } 
    }
   
}