public with sharing Class PatientByRaceController{
    public String data{get;set;}
    public PatientByRaceController(){
         data = '[\'Race\',\' Number Of Patients\'],';
         Map<String, List<String>> mapRacePatients = new Map<String, LIst<String>>();
        /* ['Race',' Number Of Patients'],['American Indian or Alaska Native',155],['Asian',169],
         ['Black or African American',42],['Native Hawaiian or Pacific Islander',9],['White',9]
          ['Race',' Number Of Patients'],['Native Hawaiian or Pacific Islander',10],['White',10],
          ['Asian',178],['Black or African American',45],['American Indian or Alaska Native',157]
         */
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
             List<TrialPatient__c> patients = database.query('select Patient_Id__r.Race__c   from TrialPatient__c  where   Patient_Id__r.Race__c != null '+condition);
              for (TrialPatient__c   pc: patients ) {
                   for (String race : String.valueof(pc.Patient_Id__r.Race__c).split(';')) {
                       if (!mapRacePatients.containskey(race)) {
                           mapRacePatients.put(race, new LIst<String>());
                       }
                       mapRacePatients.get(race).add(pc.id);
                    }
                }
      }    
        else{  
        List<Patient_Custom__c  > patients = [select  Race__c  from Patient_Custom__c 
          where  Race__c != null ];
        
        
        for (Patient_Custom__c   pc: patients ) {
            for (String race : String.valueof(pc.Race__c).split(';')) {
                if (!mapRacePatients.containskey(race)) {
                    mapRacePatients.put(race, new LIst<String>());
                }
                mapRacePatients.get(race).add(pc.id);
            }
        }
       }
       
        if(mapRacePatients.size() > 0){
            Integer count = 1 ;
            for(String str : mapRacePatients.keyset()){
                if(mapRacePatients.keyset().size() == count)
                    data += '[\''+str+'\','+mapRacePatients.get(str).size()+']';
                else
                    data += '[\''+str+'\','+mapRacePatients.get(str).size()+'],';
                
            
            }
        }
        else{
             data += '[\'No Data\',0]';    
        }        
       //System.assert(false,data); 
    }
}