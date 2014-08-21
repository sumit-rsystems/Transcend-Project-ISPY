public with sharing Class ProfilesFilter{
    public boolean showtrial{get;set;}
    public boolean showsite{get;set;}
    public boolean showinstitute{get;set;}
    
    public ProfilesFilter(ApexPages.StandardController controller) {
        List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String profileName = profiles[0].Name;
        String dashBoardId  = controller.getId();
            
        validateProfileFilters(profileName,dashboardId)   ;    
        
           
    }
    public void validateProfileFilters(string profileName, string dashboardId){
        List<Dashboard__c> dashboard = [select Profile_Filter__c from Dashboard__c where Id  = :dashBoardId];
        if(dashboard[0].Profile_Filter__c == false){
                showtrial = false;
                showinstitute = false;
                showsite = false;
        }
        else{
            
            if(profileName == 'System Administrator' ||profileName== 'Transcend Admin' ||profileName== 'DCC User' ||profileName== 'Lab User' ){
                showtrial = true;
                showsite = true;
                showinstitute = true;
            }
            else if(profileName  == 'Trial Administrator' ){
                showtrial = false;
                showsite = true;
                showinstitute = true;
            }
            else if(profileName  == 'Institute Level Admin' ){
                showtrial = false;
                showinstitute = false;
                showsite = true;
                
            }
           else if(profileName  == 'Site User' ){
                showtrial = false;
                showinstitute = false;
                showsite = false;
                
            } 
        }     
    }
    
      
}