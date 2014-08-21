public with sharing class PatientsContinueOptedOut_Site{
    public String data {get;set;}
     public String siteId;
    public String condition ;
    public PatientsContinueOptedOut_Site(){
      data = ''; 
      siteId = ApexPages.CurrentPage().getParameters().get('site');
      List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
      String profileName = profiles[0].Name;
      siteUserData();
      
    }
    
    public void siteUserData(){
         
        List<AggregateResult> randomizationpatientlist = new List<AggregateResult>();
        List<AggregateResult> randomizationpatientlist1 = new List<AggregateResult>();
        if(siteId != '' && siteId != null){
             condition ='and TrialPatient__r.Site__c IN ('+siteId+')';
             randomizationpatientlist = database.query('SELECT Count(TrialPatient__r.Patient_Id__c) countPatient,TrialPatient__r.Site__c siteId FROM Randomization_Form__c where Randomization_Result__c != \'Not Randomized\' and Status__c = \'Approval Not Required\' '+condition+' and Did_Patient_Sign_Treatment_Consent_Form__c = true and TrialPatient__c not in (SELECT TrialPatient__c   FROM Off_Study_Detail__c where  status__c = \'Accepted\') group by TrialPatient__r.Site__c');
             randomizationpatientlist1 = database.query('SELECT Count(TrialPatient__r.Patient_Id__c) countPatient,TrialPatient__r.Site__c siteId FROM Randomization_Form__c where Randomization_Result__c != \'Not Randomized\' and Status__c = \'Approval Not Required\' '+condition+' and Did_Patient_Sign_Treatment_Consent_Form__c = true and TrialPatient__c  in (SELECT TrialPatient__c   FROM Off_Study_Detail__c where  status__c = \'Accepted\') group by TrialPatient__r.Site__c');
        }
        else{
            randomizationpatientlist = database.query('SELECT Count(TrialPatient__r.Patient_Id__c) countPatient,TrialPatient__r.Site__c siteId FROM Randomization_Form__c where Randomization_Result__c != \'Not Randomized\' and Status__c = \'Approval Not Required\' and Did_Patient_Sign_Treatment_Consent_Form__c = true and TrialPatient__c not in (SELECT TrialPatient__c   FROM Off_Study_Detail__c where  status__c = \'Accepted\') group by TrialPatient__r.Site__c');
            randomizationpatientlist1 = database.query('SELECT Count(TrialPatient__r.Patient_Id__c) countPatient,TrialPatient__r.Site__c siteId FROM Randomization_Form__c where Randomization_Result__c != \'Not Randomized\' and Status__c = \'Approval Not Required\' and Did_Patient_Sign_Treatment_Consent_Form__c = true and TrialPatient__c  in (SELECT TrialPatient__c   FROM Off_Study_Detail__c where  status__c = \'Accepted\') group by TrialPatient__r.Site__c');
        }
        Map<String,String> mapsite = new Map<String,String>();
        List<String> siteId = new List<String>();
        for(AggregateResult agr : randomizationpatientlist ){
            siteId.add(String.valueOf(agr.get('siteId')));    
        }
        for(AggregateResult agr : randomizationpatientlist1 ){
            siteId.add(String.valueOf(agr.get('siteId')));    
        }
        
        List<Site__c> site = [select Name from Site__c where id in :siteId] ;
        for(Site__c st : site ){
              mapsite.put(st.id, st.Name);
        }
            
        
        if (randomizationpatientlist.size() > 0 || randomizationpatientlist1.size()>0) {
            data += '[\'Site Name\',';
            Map<String, List<String>> mapdata = new Map<String, List<String>>();
            Set<String> types = new Set<String>();
            for(AggregateResult agr : randomizationpatientlist){
                if(agr.get('siteId') != null){
                    if(!mapdata.containskey(mapsite.get(String.valueOf(agr.get('siteId'))))){
                        mapdata.put(mapsite.get(String.valueOf(agr.get('siteId'))), new List<String>());
                    }  
                    mapdata.get(mapsite.get(String.valueOf(agr.get('siteId')))).add('Continued##'+agr.get('countPatient'));
                  
                }
            }
             for(AggregateResult agr : randomizationpatientlist1){
                if(agr.get('siteId') != null){
                    if(!mapdata.containskey(mapsite.get(String.valueOf(agr.get('siteId'))))){
                        mapdata.put(mapsite.get(String.valueOf(agr.get('siteId'))), new List<String>());
                    }  
                    mapdata.get(mapsite.get(String.valueOf(agr.get('siteId')))).add('optedout##'+agr.get('countPatient'));
                  
                }
            }
           data += '\'Continued Patient\',\'Opted Out Patient\'],';    
           if(mapdata.size()>0){
                for(String st : mapdata.keySet()){
                    data += '[\''+st+'\',';
                    List<String> temp = mapdata.get(st);
                    temp.sort();
                    
                    Integer continued = 0, optedout = 0;
                    for(String phase : mapdata.get(st)){
                        List<String> pasecount = phase.split('##');
                        if(pasecount[0] ==  'Continued')
                            continued    = Integer.valueOf(pasecount[1]); 
                        if(pasecount[0] ==  'optedout')
                            optedout  = Integer.valueOf(pasecount[1]);  
                    }        
                    data += continued+','+optedout+',';     
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