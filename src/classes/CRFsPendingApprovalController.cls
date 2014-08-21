Public with sharing class CRFsPendingApprovalController{
    Public String data{get;set;}
    public void getData() {
        Map<String, List<String>> mapCrf= new Map<String, LIst<String>>();
        List<String> crfId= new List<String>();
        String instituteId = ApexPages.CurrentPage().getParameters().get('institute');
        String siteId = ApexPages.CurrentPage().getParameters().get('site');
        String trialId = ApexPages.CurrentPage().getParameters().get('trial');
        if((siteId != '' && siteId != null) || (instituteId != '' && instituteId != null) || (trialId != '' && trialId != null)){    
            String condition ='';
            if(instituteId != '' && instituteId != null){
                condition ='and Patient_Id__r.Institution__c=\''+instituteId+'\'' ;
            }
            if(siteId != '' && siteId != null){
                 condition +='and TrialPatient__r.Site__c IN ('+siteId+')';
            }
            if(trialId != '' && trialId != null){
               condition +='and Trial_Id__c=\''+trialId+'\'';
             } 
             List<AggregateResult> patients = database.query('select Type__c type ,Phase__c phase, count(id) RecordCount from CRF__c where Status__c = \'Approval Pending\' and Type__c != null and Phase__c != null '+condition+ 'group by Phase__c, Type__c ');
             
             for (AggregateResult  race : patients ){
                        if (!mapCrf.containskey(String.valueOf(race .get('phase')))) {
                            mapCrf.put(String.valueOf(race .get('phase')), new LIst<String>());
                        }
                        mapCrf.get(String.valueOf(race.get('phase'))).add(String.valueOf(race.get('type'))+'##'+String.valueOf(race.get('RecordCount')));
                      crfId.add(String.valueOf(race.get('type')));
                  }
              }
       else{ 
            List<AggregateResult > patients = database.query('select Type__c type ,Phase__c phase, count(id) RecordCount from CRF__c where Status__c = \'Approval Pending\' and Type__c != null and Phase__c != null group by Phase__c, Type__c');
            for (AggregateResult  race : patients ){
                        if (!mapCrf.containskey(String.valueOf(race .get('phase')))) {
                            mapCrf.put(String.valueOf(race .get('phase')), new LIst<String>());
                        }
                        mapCrf.get(String.valueOf(race.get('phase'))).add(String.valueOf(race.get('type'))+'##'+String.valueOf(race.get('RecordCount')));
                      crfId.add(String.valueOf(race.get('type')));
                  }
             
        }
        
       crfId.sort(); 
        set<String> typeList= new set<String>();
            for(String st : crfId){
              typeList.add(st);    
            }
      
       data = '[\'Phase\',';
       for(String s :typeList){
           String type1 = s.replace('__c','');
           String type2 = type1.replace('_',' ');
           data += '\''+type2+'\',';
       }
       data = data.subString(0,data.length()-1)+'],'; 
        if(mapCrf.size()>0){
                for(String st : mapCrf.keySet()){
                    data += '[\''+st+'\',';
                    List<String> temp = mapCrf.get(st);
                    temp.sort();
                    for(String type : typeList){
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
             data = '[\'phase\',\'Type\',\'Count\'],[\'No Data\',0,0],';    
        }     
       System.debug('CRF Pending Approval *****'+data );
    }
    
    public CRFsPendingApprovalController(){
        getData();
    
    }    
}