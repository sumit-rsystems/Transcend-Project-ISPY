public with sharing Class PatientByEthinicityAndRaceController{
    Public String data{get;set;}
    public void getData() {
        Map<String, List<String>> mapRacePatients = new Map<String, LIst<String>>();
        set<String> allethnicity = new set<String>();
        String instituteId = ApexPages.CurrentPage().getParameters().get('institute');
        String siteId = ApexPages.CurrentPage().getParameters().get('site');
        String trialId = ApexPages.CurrentPage().getParameters().get('trial');
        if((siteId != '' && siteId != null) || (instituteId != '' && instituteId != null) || (trialId != '' && trialId != null)){    
            String condition ='';
            if(instituteId != '' && instituteId != null){
                condition ='and Patient_Id__r.Institution__c=\''+instituteId+'\'' ;
            }
            if(siteId != '' && siteId != null){
                 condition +='and Site__c IN ('+siteId+')';
            }
            if(trialId != '' && trialId != null){
               condition +='and Trial_Id__c=\''+trialId+'\'';
             } 
             List<TrialPatient__c> patients = database.query('select Patient_Id__r.Race__c , Patient_Id__r.Ethnicity__c  from TrialPatient__c  where Patient_Id__r.Ethnicity__c != null and  Patient_Id__r.Race__c != null '+condition);
              for (TrialPatient__c     pc: patients ) {
                  allethnicity.add(pc.Patient_Id__r.Ethnicity__c);
                  for (String race : String.valueof(pc.Patient_Id__r.race__c).split(';')) {
                        if (!mapRacePatients.containskey(race+'##'+pc.Patient_Id__r.Ethnicity__c )) {
                            mapRacePatients.put(race+'##'+pc.Patient_Id__r.Ethnicity__c, new LIst<String>());
                        }
                        mapRacePatients.get(race+'##'+pc.Patient_Id__r.Ethnicity__c).add(pc.Patient_Id__c);
                  }
              }
        }    
        else{ 
            List<Patient_Custom__c  > patients = [select Ethnicity__c , Race__c  from Patient_Custom__c 
          where Ethnicity__c != null and Race__c != null];
          for (Patient_Custom__c   pc: patients ) {
              allethnicity.add(pc.Ethnicity__c);
              for (String race : String.valueof(pc.race__c).split(';')) {
                    if (!mapRacePatients.containskey(race+'##'+pc.Ethnicity__c )) {
                        mapRacePatients.put(race+'##'+pc.Ethnicity__c, new LIst<String>());
                    }
                    mapRacePatients.get(race+'##'+pc.Ethnicity__c).add(pc.id);
              }
          }
        
        }
        
        Map<String,Map<String,Integer>> ethnicity = new Map<String,Map<String,Integer>>();
        
        for(String keyq : mapRacePatients.keyset()){
            list<String> splitrace = keyq.split('##');
            if(!ethnicity.containsKey(splitrace[0])){
                ethnicity.put(splitrace[0], new Map<String,Integer>());
            }
            ethnicity.get(splitrace[0]).put(splitrace[1],mapRacePatients.get(keyq).size());
        }
        
        List<String> allethnicitysorted = new List<String>();
        for(String eth : allethnicity)
            allethnicitysorted.add(eth);
        allethnicitysorted.sort();    
        data = '[\'Race\',\' Hispanic or latino \',\' Not Hispanic or Latino\'],';
        if(ethnicity.size() > 0){
            for(String race : ethnicity.keyset()){
                 data += '[\''+race+'\',';
                 integer countlast = 1;
                 Integer Hisanic =0, NHisanic =0;
                 for(String  eth : ethnicity.get(race).keyset()){
                     if(eth == 'Hispanic or Latino'){
                         Hisanic =  ethnicity.get(race).get(eth);
                      }    
                     else
                         NHisanic = ethnicity.get(race).get(eth);      
                     countlast++; 
                     } 
               data += Hisanic +','+NHisanic+'],';       
               
            }
        }
        else{
             data += '[\'No Data\',0,0],';    
        }     
       //System.assert(false,data );
    }
    
    public PatientByEthinicityAndRaceController(){
        getData();
    
    }    
}