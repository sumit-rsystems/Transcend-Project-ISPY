public with sharing class CRFPendingSubmission_Site{
    public String data {get;set;}
    public String profileName {get;set;}
    public String siteId;
    public String condition ;
    public CRFPendingSubmission_Site(){
          data = ''; 
          siteId = ApexPages.CurrentPage().getParameters().get('site');
          List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
          profileName = profiles[0].Name;
          if(profileName == 'Site User')
          siteUserData();
         
          
    }
    public void siteUserData(){       
       List<AggregateResult> ag = new  List<AggregateResult>();
        if(siteId != '' && siteId != null){
           condition ='and TrialPatient__r.Site__c IN ('+siteId+')';
           ag = database.query('select Phase__c Phase, count(id) RecordCount, TrialPatient__r.Site__c siteId from  CRF__c  where Status__c = \'Not Completed\' and Phase__c != null '+condition+' and TrialPatient__r.Site__c != null  Group By Phase__c,TrialPatient__r.Site__c');
        }
        else
           ag = database.query('select Phase__c Phase, count(id) RecordCount, TrialPatient__r.Site__c siteId from  CRF__c  where Status__c = \'Not Completed\' and Phase__c != null and TrialPatient__r.Site__c != null  Group By Phase__c,TrialPatient__r.Site__c'); 
        Map<String,String> mapsite = new Map<String,String>();
        List<String> siteId = new List<String>();
        for(AggregateResult agr : ag){
            siteId.add(String.valueOf(agr.get('siteId')));    
        }
        
        List<Site__c> site = [select Name from Site__c where id in :siteId] ;
        for(Site__c st : site ){
              mapsite.put(st.id, st.Name);
        }
            
        
        if (ag.size() > 0) {
            data += '[\'Site Name\',';
            Map<String, List<String>> mapdata = new Map<String, List<String>>();
            Set<String> types = new Set<String>();
            for(AggregateResult agr : ag){
                if(agr.get('siteId') != null){
                    if(!mapdata.containskey(mapsite.get(String.valueOf(agr.get('siteId'))))){
                        mapdata.put(mapsite.get(String.valueOf(agr.get('siteId'))), new List<String>());
                    }  
                    mapdata.get(mapsite.get(String.valueOf(agr.get('siteId')))).add(agr.get('Phase')+'##'+agr.get('RecordCount'));
                    if(String.valueOf(agr.get('Phase')) != null)
                    types .add(String.valueOf(agr.get('Phase')));
                }
            }
           List<String> typeset= new List<String>();
            for(String st : types ){
              typeset.add(st);    
            }
            typeset.sort();
            for(String st : typeset){
                String type1 = st.replace('__c','');
                String type2 = type1.replace('_',' ');
            
               data += '\''+type2+'\',';    
            } 
            
            data = data.subString(0,data.length()-1)+'],';
             if(mapdata.size()>0){
                for(String st : mapdata.keySet()){
                    data += '[\''+st+'\',';
                    List<String> temp = mapdata.get(st);
                    temp.sort();
                    for(String type : types){
                        Integer flag =0;
                        for(String phase : temp){
                            List<String> pasecount = phase.split('##');
                            if(pasecount[0] == type){
                                data += pasecount[1]+',';
                                flag =1;
                               }
                             
                            }
                            if(flag ==0)
                                  data += '0,';   
                              
                       }       
                     
                    data = data.subString(0,data.length()-1)+'],'; 
                   
               }  
             data = data.subString(0,data.length()-1);
            }
            else{
                data = '[\'Site Name\', \'Type1\',\'Type2\'], [\'No Data\',0,0]';    
            }   
       }
       else {
           data = '[\'Site Name\', \'Type1\',\'Type2\'], [\'No Data\',0,0]';
       } 
    }
}