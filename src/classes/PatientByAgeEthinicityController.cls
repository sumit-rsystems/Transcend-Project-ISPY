Public with sharing class PatientByAgeEthinicityController{
    Public String data{get;set;}
   public PatientByAgeEthinicityController(){
 
              
     /*******  Patient By age and ethinicity    ***********/
        List<AggregateResult>  results;  
        String instituteId = ApexPages.CurrentPage().getParameters().get('institute');
        String siteId = ApexPages.CurrentPage().getParameters().get('site');
        String trialId = ApexPages.CurrentPage().getParameters().get('trial');
        System.debug('****'+InstituteId+'****'+siteId+'******'+trialId);
        if((siteId != '' && siteId != null) || (instituteId != '' && instituteId != null) || (trialId != '' && trialId != null)){    
            String condition ='';
            if(instituteId != '' && instituteId != null){
                condition ='and Patient_Id__r.Institution__c=\''+instituteId+'\'' ;
            }
            if(siteId != '' && siteId != null){
                 condition +=' and Site__c IN ('+siteId+')';
            }
            if(trialId != '' && trialId != null){
               condition +='and Trial_Id__c=\''+trialId+'\'';
             } 
             System.debug('==========select Patient_Id__r.Ethnicity__c Ethnicity, Patient_Id__r.Age_Group__c age, count(Id) PatientCount from TrialPatient__c where  Patient_Id__r.Ethnicity__c != null and Patient_Id__r.Age_Group__c != null '+condition +' group by Patient_Id__r.Ethnicity__c, Patient_Id__r.Age_Group__c,Patient_Id__r.Institution__c');
          results = database.query('select Patient_Id__r.Ethnicity__c Ethnicity, Patient_Id__r.Age_Group__c age, count(Id) PatientCount from TrialPatient__c where  Patient_Id__r.Ethnicity__c != null and Patient_Id__r.Age_Group__c != null '+condition +' group by Patient_Id__r.Ethnicity__c, Patient_Id__r.Age_Group__c,Patient_Id__r.Institution__c') ;
         
      }
      else {
           
                results =  [select Ethnicity__c Ethnicity, Age_Group__c age, count(Id) PatientCount from Patient_Custom__c where  Ethnicity__c != null and Age_Group__c != null group by Ethnicity__c, Age_Group__c ];
          }
      data = '[\'Ethinicity\',\' under 20\',\'20-30\',\'30-40\',\'40-50\',\'50-60\',\'60-70\',\'70-80\',\'80-90\',\'over 90\'],';
      if (results.size() == 0) {
          data += '[\'No Data\',0,0,0,0,0,0,0,0,0]';
          
      }
      else {
      //System.assert(false,results);
      Map<String, List<String>> mapRaceAgeGroup = new Map<String,List<String>>();
      System.debug('*******'+integer.valueof(results[0].get('PatientCount'))); 
        for (AggregateResult ar : results) {
            
            if (!mapRaceAgeGroup.containskey(String.valueof(ar.get('Ethnicity'))) ) {
                mapRaceAgeGroup.put(String.valueof(ar.get('Ethnicity')), new LIst<String>());
            }
            mapRaceAgeGroup.get(String.valueof(ar.get('Ethnicity'))).add(String.valueof(ar.get('age')) + '###' + integer.valueof(ar.get('PatientCount')));
        }
        
       
        for(String race : mapRaceAgeGroup.keyset()){
           data += '[\''+race+'\',';
           Integer a1=0,a2=0,a3=0,a4=0,a5=0,a6=0,a7=0,a8=0,a9=0,a10=0;
           
            for (String s : mapRaceAgeGroup.get(race)) {
                LIst<String> arr = s.split('###');
                if (arr.size() == 2) {
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
               
            }
           
               data += a1+','+a2+','+a3+','+a4+','+a5+','+a6+','+a7+','+a8+','+a9+'],'; 
        }
      }
      
              
    }
   
  
}