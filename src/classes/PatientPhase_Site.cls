public with sharing class PatientPhase_Site{
    public String data {get;set;}
     public String siteId;
    public String condition ;
    public PatientPhase_Site(){
      data = ''; 
      siteId = ApexPages.CurrentPage().getParameters().get('site');
      List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
      String profileName = profiles[0].Name;
      siteUserData();
      
    }
    
    public void siteUserData(){
         
        List<AggregateResult> ag = new List<AggregateResult>();
        if(siteId != '' && siteId != null){
             condition ='and Site__c IN ('+siteId+')';
            ag = database.query('select Patient_Id__r.Phase_Master__r.Name Phase,Site__c siteId,count(Patient_Id__c) PatientCount from TrialPatient__c where Patient_Id__r.Phase_Master__r.Name != null and Site__r.Name != null '+condition+' group by Site__c, Patient_Id__r.Phase_Master__r.Name');
        }
        else
            ag = database.query('select Patient_Id__r.Phase_Master__r.Name Phase,Site__c siteId,count(Patient_Id__c) PatientCount from TrialPatient__c where Patient_Id__r.Phase_Master__r.Name != null and Site__r.Name != null group by Site__c, Patient_Id__r.Phase_Master__r.Name');
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
                    mapdata.get(mapsite.get(String.valueOf(agr.get('siteId')))).add(agr.get('phase')+'##'+agr.get('PatientCount'));
                    if(String.valueOf(agr.get('phase')) != null)
                    types .add(String.valueOf(agr.get('phase')));
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
 }