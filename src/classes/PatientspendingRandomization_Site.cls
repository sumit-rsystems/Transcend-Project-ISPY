public class PatientspendingRandomization_Site{
 public String data{get;set;}
 public String siteId;
    public String condition ;
    public PatientspendingRandomization_Site(){
         data = ''; 
         siteId = ApexPages.CurrentPage().getParameters().get('site');
         List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
          String profileName = profiles[0].Name;
          if(profileName == 'Site User')
          siteUserData();
          if(profileName == 'DCC User')
          dccUserData();
          
    }
    public void siteUserData(){      
        Set<Id> patientId = new Set<Id>();
        set<Id> noofpatient = new set<Id>();
        for(CRF__c CRF: [SELECT patient__c  FROM CRF__c where (Type__c = 'TissueSpecimenDetail__c' or 
                    Type__c ='PreEligibility_Checklist__c' or Type__c = 'Registration__c' or Type__c = 'On_Study_Eligibility_Form__c'
                     or Type__c ='On_Study_Pathology_Form__c' or Type__c ='MRI_Volume__c' or Type__c = 'MammaPrintDetail__c' ) and 
                     (Status__c = 'Approval Not Required' or  Status__c = 'Accepted')]){
            patientId.add(CRF.patient__c);  
        }
        List<AggregateResult> ag= new List<AggregateResult>();
        if(siteId != '' && siteId != null){
             condition ='and TrialPatient__r.Site__c IN ('+siteId+')';
             ag =  database.query(' Select count(patient__c) countPatient,Phase__c phase, TrialPatient__r.Site__c siteId from CRF__c where Type__c = \'Randomization_Form__c\' and patient__c not in :patientId '+condition+' group by Phase__c, TrialPatient__r.Site__c ');
         }
         else
             ag =  [ Select count(patient__c) countPatient,Phase__c phase, TrialPatient__r.Site__c siteId from CRF__c where Type__c = 'Randomization_Form__c' and patient__c not in :patientId group by Phase__c, TrialPatient__r.Site__c ];
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
            List<String> phases = new List<String>();
            for(AggregateResult agr : ag){
                if(agr.get('siteId') != null){
                    if(!mapdata.containskey(mapsite.get(String.valueOf(agr.get('siteId'))))){
                        mapdata.put(mapsite.get(String.valueOf(agr.get('siteId'))), new List<String>());
                    }  
                    mapdata.get(mapsite.get(String.valueOf(agr.get('siteId')))).add(agr.get('phase')+'##'+agr.get('countPatient'));
                    if(String.valueOf(agr.get('phase')) != null)
                    phases.add(String.valueOf(agr.get('phase')));
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
             data = data.subString(0,data.length()-1);
            }
            
            else{
                data = '[\'Site Name\', \'NO Data\',\'No Data\'], [\'No Data\',0,0]';    
            }   //System.assert(false,data+ag);
       }
       else {
           data = '[\'Site Name\', \'No Data\',\'No Data\'], [\'No Data\',0,0]';
       } 
    }
    
     public void dccUserData(){      
        Set<Id> patientId = new Set<Id>();
        set<Id> noofpatient = new set<Id>();
        for(CRF__c CRF: [SELECT patient__c  FROM CRF__c where (Type__c = 'TissueSpecimenDetail__c' or 
                    Type__c ='PreEligibility_Checklist__c' or Type__c = 'Registration__c' or Type__c = 'On_Study_Eligibility_Form__c'
                     or Type__c ='On_Study_Pathology_Form__c' or Type__c ='MRI_Volume__c' or Type__c = 'MammaPrintDetail__c' ) and 
                     (Status__c = 'Approval Not Required' or  Status__c = 'Accepted')]){
            patientId.add(CRF.patient__c);  
        }
        List<AggregateResult> ag= [ Select count(patient__c) countPatient,TrialPatient__r.Site__c siteId, TrialPatient__r.Trial_Id__c trialId  from CRF__c where Type__c = 'Randomization_Form__c' and patient__c not in :patientId group by TrialPatient__r.Site__c, TrialPatient__r.Trial_Id__c];
         
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
            } //System.assert(false,data+ag); 
       }
       else {
           data = '[\'Site Name\', \'No data\',\'No data\'], [\'No Data\',0,0]';
       } 
    }
}