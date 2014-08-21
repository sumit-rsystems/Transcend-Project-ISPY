public with sharing Class PatientByAgeRaceController{
    public String data{get;set;}
    public PatientByAgeRaceController(){
        
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
             List<TrialPatient__c> patients = database.query('select Patient_Id__r.Race__c , Patient_Id__r.Age_Group__c  from TrialPatient__c  where Patient_Id__r.Ethnicity__c != null and  Patient_Id__r.Age_Group__c != null '+condition);
           // System.debug('Query=========='+'select Patient_Id__r.Race__c , Patient_Id__r.Age_Group__c  from TrialPatient__c  where Patient_Id__r.Ethnicity__c != null and  Patient_Id__r.Age_Group__c != null '+condition);     
            for (TrialPatient__c   pc: patients ) {
                allethnicity.add(pc.Patient_Id__r.Age_Group__c);
                for (String race : String.valueof(pc.Patient_Id__r.Race__c).split(';')) {
                    if (!mapRacePatients.containskey(race+'##'+pc.Patient_Id__r.Age_Group__c)) {
                        mapRacePatients.put(race+'##'+pc.Patient_Id__r.Age_Group__c, new LIst<String>());
                    }
                    mapRacePatients.get(race+'##'+pc.Patient_Id__r.Age_Group__c ).add(pc.Patient_Id__r.id);
                }
            }
        }    
        else{ 
             List<Patient_Custom__c> patients = [select Race__c , Age_Group__c  from Patient_Custom__c
              where Ethnicity__c != null and  Age_Group__c != null ];
             for (Patient_Custom__c   pc: patients ) {
                allethnicity.add(pc.Age_Group__c);
                for (String race : String.valueof(pc.Race__c).split(';')) {
                    if (!mapRacePatients.containskey(race+'##'+pc.Age_Group__c)) {
                        mapRacePatients.put(race+'##'+pc.Age_Group__c, new LIst<String>());
                    }
                mapRacePatients.get(race+'##'+pc.Age_Group__c ).add(pc.id);
                }
             }
        }
       
        
        Map<String,List<String>> ethnicity = new Map<String,List<String>>();
        
        for(String keyq : mapRacePatients.keyset()){
            list<String> splitrace = keyq.split('##');
            if(!ethnicity.containsKey(splitrace[0])){
                ethnicity.put(splitrace[0], new List<String>());
            }
            ethnicity.get(splitrace[0]).add(splitrace[1]+'##'+mapRacePatients.get(keyq).size());
        }
        List<String> allethnicitysorted = new List<String>();
        for(String eth : allethnicity)
            allethnicitysorted.add(eth);
        allethnicitysorted.sort();    
       data = '[\'Race\',\' under 20\',\'20-30\',\'30-40\',\'40-50\',\'50-60\',\'60-70\',\'70-80\',\'80-90\',\'over 90\'],';
       if(ethnicity.keyset().size() == 0){
           data = '[\'Race\',\' under 20\',\'20-30\',\'30-40\',\'40-50\',\'50-60\',\'60-70\',\'70-80\',\'80-90\',\'over 90\'],[\'No Data\',0,0,0,0,0,0,0,0,0]';
       }
       else{ 
            for(String race : ethnicity.keyset()){
                 data += '[\''+race+'\',';
                 integer countlast = 1;
                 Integer a1=0, a2=0, a3=0, a4=0, a5=0, a6=0, a7=0, a8=0, a9=0;
                 for(String ethnicitycount : ethnicity.get(race)){
                   List<String> arr =    ethnicitycount.split('##');
                      if (arr[0] == 'under 20') {
                           a1 = Integer.valueOf(arr[1]);
                        }
                        else if (arr[0] == '20-30') {
                            a2 =  Integer.valueOf(arr[1]);
                        }
                        else if (arr[0] == '30-40') {
                            a3 =  Integer.valueOf(arr[1]);
                        }
                        else if (arr[0] == '40-50') {
                            a4 =  Integer.valueOf(arr[1]);
                        }
                        else if (arr[0] == '50-60') {
                           a5 =  Integer.valueOf(arr[1]);
                        }
                        else if (arr[0] == '60-70') {
                           a6 =  Integer.valueOf(arr[1]);
                        }
                        else if (arr[0] == '70-80') {
                            a7 =  Integer.valueOf(arr[1]);
                        }
                        else if (arr[0] == '80-90') {
                             a8 =  Integer.valueOf(arr[1]);
                        }
                        else if (arr[0] == 'over 90') {
                             a9 = Integer.valueOf(arr[1]);
                        }
                     } 
                     data += a1+','+a2+','+a3+','+a4+','+a5+','+a6+','+a7+','+a8+','+a9+'],';
            
            }
        }
        System.debug('Race & Age======'+data);
    }
}