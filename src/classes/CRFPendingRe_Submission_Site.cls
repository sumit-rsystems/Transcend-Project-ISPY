public with sharing class CRFPendingRe_Submission_Site{
    public String data {get;set;}
     public String siteId;
    public String condition ;
    public CRFPendingRe_Submission_Site(){
      data = ''; 
      siteId = ApexPages.CurrentPage().getParameters().get('site');
      List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
      String profileName = profiles[0].Name;
      if(profileName == 'Site User')
      siteUserData();
      if(profileName == 'Dcc User')
      dccUserData();
      
      //System.assert(false,data);
    }
    
    public void siteUserData(){
         
        List<AggregateResult> ag = new List<AggregateResult>();
        if(siteId != '' && siteId != null){
             condition ='and TrialPatient__r.Site__c IN ('+siteId+')';
            ag = database.query('select type__c type, count(id) RecordCount, TrialPatient__r.Site__c siteId from  CRF__c  where Status__c = \'Rejected\' and status__c != \'re-submitted\' and type__c != null and TrialPatient__r.Site__c != null '+condition+'  Group By type__c,TrialPatient__r.Site__c');
        }
        else
            ag = database.query('select type__c type, count(id) RecordCount, TrialPatient__r.Site__c siteId from  CRF__c  where Status__c = \'Rejected\' and status__c != \'re-submitted\' and type__c != null and TrialPatient__r.Site__c != null  Group By type__c,TrialPatient__r.Site__c');
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
                    mapdata.get(mapsite.get(String.valueOf(agr.get('siteId')))).add(agr.get('type')+'##'+agr.get('RecordCount'));
                    if(String.valueOf(agr.get('type')) != null)
                    types .add(String.valueOf(agr.get('type')));
                }
            }
            
            List<String> typeList= new List<String>();
            for(String st : types ){
              typeList.add(st);    
            }
            typeList.sort();
            for(String st : typeList){
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
    public void dccUserData(){
         
       // List<AggregateResult> ag = database.query('select type__c type, count(id) RecordCount, TrialPatient__r.Site__c siteId from  CRF__c  where Status__c = \'Rejected\' and status__c != \'re-submitted\' and type__c != null  Group By type__c,TrialPatient__r.Site__c');
        List<AggregateResult> ag = database.query('select  count(id) RecordCount, TrialPatient__r.Site__c siteId, TrialPatient__r.Trial_Id__c trialId from  CRF__c  where Status__c = \'Rejected\' and status__c != \'re-submitted\' and type__c != null and  TrialPatient__r.Site__c != null  Group By TrialPatient__r.Site__c, TrialPatient__r.Trial_Id__c');
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
        if (ag.size() > 0) {
            data += '[\'Site Name\',';
            Map<String, List<String>> mapdata = new Map<String, List<String>>();
            List<String> types = new List<String>();
            for(AggregateResult agr : ag){
                if(agr.get('trialId') != null){
                    if(!mapdata.containskey(maptrial.get(String.valueOf(agr.get('trialId'))))){
                        mapdata.put(maptrial.get(String.valueOf(agr.get('trialId'))), new List<String>());
                    }  
                    mapdata.get(maptrial.get(String.valueOf(agr.get('trialId')))).add(mapsite.get(String.valueOf(agr.get('siteId')))+'##'+agr.get('RecordCount'));
                    if(mapsite.get(String.valueOf(agr.get('siteId'))) != null)
                    types .add(mapsite.get(String.valueOf(agr.get('siteId'))));
                }
            }
            types .sort();
           /* Set<String> typeset= new Set<String>();
            for(String st : types ){
              typeset.add(st);    
            }*/
            for(String st : types ){
               data += '\''+st+'\',';    
            } 
            
            data = data.subString(0,data.length()-1)+'],';
            if(mapdata.size()>0){
                for(String st : mapdata.keySet()){
                    data += '[\''+st+'\',';
                    List<String> temp = mapdata.get(st);
                    temp.sort();
                    Integer count = types.size();
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
                data = '[\'Site Name\', \'Type1\',\'Type2\'], [\'No Data\',0,0]';    
            }   
       }
       else {
           data = '[\'Site Name\', \'Type1\',\'Type2\'], [\'No Data\',0,0]';
       } 
    }   
}