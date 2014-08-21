public with sharing Class CRFPendingApproval_site{
    public String data{get;set;}
    public CRFPendingApproval_site(){
        data = ''; 
          List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
          String profileName = profiles[0].Name;
          if(profileName == 'Site User')
          siteUserData();
          if(profileName == 'Dcc User')
          dccUserData();
         // System.assert(false,data);    
    }
    public void siteUserData(){    
        data= '[\'Phase\',';  
        Map<String, List<String>> mapData = new Map<String, List<String>>();
        List<String> type = new List<String>();
        List<AggregateResult> patients = [SELECT count(Patient__c) countPatient,  TrialPatient__r.Site__c siteId, Type__c type FROM CRF__c where Status__c = 'Approval Pending' group by TrialPatient__r.Site__c, Type__c];
        Map<String,String> mapsite = new Map<String,String>();
            List<String> siteId = new List<String>();
            for(AggregateResult agr : patients){
                siteId.add(String.valueOf(agr.get('siteId')));    
            }
            
            List<Site__c> site = [select Name from Site__c where id in :siteId] ;
            for(Site__c st : site ){
                  mapsite.put(st.id, st.Name);
           }
            
        
        for(AggregateResult ag : patients){
            if(!mapData.containsKey(mapsite.get(String.valueOf(ag.get('siteId'))))){
                mapData.put(mapsite.get(String.valueOf(ag.get('siteId'))), new List<String>());
            }
            mapData.get(mapsite.get(String.valueOf(ag.get('siteId')))).add(String.valueOf(ag.get('type'))+'###'+String.valueOf(ag.get('countPatient')));       
            type.add(String.valueOf(ag.get('type')));
        }
        type.sort();
        for(String tp : type){
            data += '\''+tp+'\',';
        }
        data = data.subString(0,data.length()-1)+'],';
       
        for(String mp : mapData.keySet()){
            data += '[\''+mp+'\',';
            List<String> types = mapData.get(mp);
            types.sort();
            Integer count = type.size();
            for(String st : types){
                List<String> split = st.split('###');
                data += split[1]+',';
                count--;
            }
            for(Integer i=0; i<count; i++)
                data += '0,';
            data  = data.subString(0,data.length()-1)+'],';             
        }
        data = data.subString(0,data.length()-1);
        //System.assert(false,data);
    }
    
    public void dccUserData(){    
        data= '[\'Phase\',';  
        Map<String, List<String>> mapData = new Map<String, List<String>>();
        List<String> type = new List<String>();
        List<AggregateResult> patients = [SELECT count(Patient__c) countPatient, TrialPatient__r.Site__c siteId, TrialPatient__r.Trial_Id__c trialId FROM CRF__c where Status__c = 'Approval Pending' group by TrialPatient__r.Site__c, TrialPatient__r.Trial_Id__c];
        Map<String,String> maptrial = new Map<String,String>();
        List<String> trialId = new List<String>();
         Map<String,String> mapsite = new Map<String,String>();
        List<String> siteId = new List<String>();
        for(AggregateResult agr : patients ){
            siteId.add(String.valueOf(agr.get('siteId')));    
        }
        for(AggregateResult agr : patients ){
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
        for(AggregateResult ag : patients){
            if(!mapData.containsKey(maptrial.get(String.valueOf(ag.get('trialId'))))){
                mapData.put(maptrial.get(String.valueOf(ag.get('trialId'))), new List<String>());
            }
            mapData.get(maptrial.get(String.valueOf(ag.get('trialId')))).add(mapsite.get(String.valueOf(ag.get('siteId')))+'###'+String.valueOf(ag.get('countPatient')));       
            type.add(mapsite.get(String.valueOf(ag.get('siteId'))));
        }
        type.sort();
        for(String tp : type){
            data += '\''+tp+'\',';
        }
        data = data.subString(0,data.length()-1)+'],';
       
        for(String mp : mapData.keySet()){
            data += '[\''+mp+'\',';
            List<String> types = mapData.get(mp);
            types.sort();
            Integer count = type.size();
            for(String st : types){
                List<String> split = st.split('###');
                data += split[1]+',';
                count--;
            }
            for(Integer i=0; i<count; i++)
                data += '0,';
            data  = data.subString(0,data.length()-1)+'],';             
        }
        data = data.subString(0,data.length()-1);
        //System.assert(false,data);
    }
}