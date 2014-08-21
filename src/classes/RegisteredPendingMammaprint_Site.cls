public class RegisteredPendingMammaprint_Site{
 public String data{get;set;}
    public RegisteredPendingMammaprint_Site(){
        data = ''; 
        List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String profileName = profiles[0].Name;
        if(true)
        siteUserData();
        if(profileName == 'Dcc User')
        dccUserData();
        // System.assert(false,data) ;
    }
    public void siteUserData(){
        List<AggregateResult> registeredP = [SELECT Count(Patient__c) countPatient,  TrialPatient__r.Site__c siteId FROM Registration__c where Status__c = 'Approval Not Required' and  Patient__c != null and TrialPatient__r.Site__c != null group by  TrialPatient__r.Site__c];
        List<AggregateResult> pendingmammaprint= [SELECT Count(Patient__c) countPatient,  TrialPatient__r.Site__c siteId FROM Registration__c where Status__c = 'Approval Not Required' and Patient__c != null and TrialPatient__r.Site__c != null  and TrialPatient__c  in (Select TrialPatient__c From MammaPrintDetail__c where Status__c  != 'Approval Not Required' ) group by  TrialPatient__r.Site__c];
        List<AggregateResult> pendingmammaprint1= [SELECT Count(Patient__c) countPatient,  TrialPatient__r.Site__c siteId FROM Registration__c where Status__c = 'Approval Not Required' and Patient__c != null and TrialPatient__r.Site__c != null  and TrialPatient__c not in (Select TrialPatient__c From MammaPrintDetail__c) group by  TrialPatient__r.Site__c];
        
        Map<String,String> mapsite = new Map<String,String>();
        set<String> siteId = new set<String>();
        for(AggregateResult agr : registeredP ){
            siteId.add(String.valueOf(agr.get('siteId')));    
        }
        for(AggregateResult agr : pendingmammaprint){
            siteId.add(String.valueOf(agr.get('siteId')));    
        }
        for(AggregateResult agr : pendingmammaprint1){
            siteId.add(String.valueOf(agr.get('siteId')));    
        }
        List<Site__c> site = [select Name from Site__c where id in :siteId] ;
        for(Site__c st : site ){
              mapsite.put(st.id, st.Name);
        }
         
         if (registeredP.size() > 0 || pendingmammaprint.size() > 0) {
            data += '[\'Site Name\',\'Continued Treatment\',\'Opted out of Treatment\'],';
            Map<String, List<String>> mapdata = new Map<String, List<String>>();
            for(AggregateResult agr : registeredP ){
                if(agr.get('siteId') != null){
                    if(!mapdata.containskey(mapsite.get(String.valueOf(agr.get('siteId'))))){
                        mapdata.put(mapsite.get(String.valueOf(agr.get('siteId'))), new List<String>());
                    }  
                    mapdata.get(mapsite.get(String.valueOf(agr.get('siteId')))).add('continue##'+agr.get('countPatient'));
                    
                }
            }
            for(AggregateResult agr : pendingmammaprint){
                if(agr.get('siteId') != null){
                    if(!mapdata.containskey(mapsite.get(String.valueOf(agr.get('siteId'))))){
                        mapdata.put(mapsite.get(String.valueOf(agr.get('siteId'))), new List<String>());
                    }  
                    mapdata.get(mapsite.get(String.valueOf(agr.get('siteId')))).add('optedout##'+agr.get('countPatient'));
                    
                }
            }
            if(mapdata.size()>0){
                for(String st : mapdata.keySet()){
                    data += '[\''+st+'\',';
                    String c = '0', o = '0'; 
                    for(String str : mapdata.get(st)){
                        List<String> strlist = str.split('##');
                        if(strlist[0] == 'continue')
                            c = strlist[1];
                        else
                            o =  strlist[1];  
                    } 
                    data += c+','+o+'],';
                   
               }  
               data =  data.subString(0,data.length()-1);
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
            
    }   
}