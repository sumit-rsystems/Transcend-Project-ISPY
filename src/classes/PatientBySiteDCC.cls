public with sharing Class PatientBySiteDCC{
    public String data{get;set;}
     public String siteId;
    public PatientBySiteDCC(){
        data = '';
         siteId = ApexPages.CurrentPage().getParameters().get('site');
          List<AggregateResult> ag;
          if(siteId != '' && siteId != null){
              ag= database.query('Select count(Patient_Id__c) countPatient, Site__c siteId, Trial_Id__c trialId from TrialPatient__c where Site__c IN ('+siteId+' ) group by Site__c, Trial_Id__c'); 
          }
          else
              ag= [Select count(Patient_Id__c) countPatient, Site__c siteId, Trial_Id__c trialId from TrialPatient__c  group by Site__c, Trial_Id__c]; 
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
            List<String> phases = new List<String>();
            for(AggregateResult agr : ag){
                if(agr.get('siteId') != null){
                    if(!mapdata.containskey(maptrial.get(String.valueOf(agr.get('trialId'))))){
                        mapdata.put(maptrial.get(String.valueOf(agr.get('trialId'))), new List<String>());
                    }  
                    mapdata.get(maptrial.get(String.valueOf(agr.get('trialId')))).add(mapsite.get(String.valueOf(agr.get('siteId')))+'##'+agr.get('countPatient'));
                    if(mapsite.get(String.valueOf(agr.get('siteId'))) != null)
                    phases.add(mapsite.get(String.valueOf(agr.get('siteId'))));
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
             data = data.subString(0,data.length()-1);//System.assert(false,data+ag);
            }
            else{
                data = '[\'Site Name\', \'No data\',\'No data\'], [\'No Data\',0,0]';    
            }
          }
       else {
           data = '[\'Site Name\', \'No data\',\'No data\'], [\'No Data\',0,0]';
       } 
        
    }
}