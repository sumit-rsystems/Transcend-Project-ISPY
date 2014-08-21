public with sharing class ViewDashBoard{

    
    public String dashboardId{get;set;}
    public String profileId{get;set;}
    public List<Profile> profile;
    public List<dashboard__c> dashboards { get; set; }
    
    public ViewDashBoard(){
        try{
        dashboards  = new  List<dashboard__c>();
        profile = new List<Profile>();
        profile = [select id from Profile where id = :userinfo.getProfileId()];
        profileId = profile[0].Id;
        List<String> dashboardIds = new List<String>();
        for(Dashboard_Profile_Right__c dbright : [select Dashboard__c From Dashboard_Profile_Right__c where Profile_Id__c = :profileId ]) 
               dashboardIds.add(dbright.Dashboard__c);
        if(dashboardIds.size()>0)
            dashboards = [select id,name from dashboard__c where id in :dashboardIds];
        }
        catch(Exception e){
        
            System.assert(false,e.getstacktracestring());
        }    
    }
    
}