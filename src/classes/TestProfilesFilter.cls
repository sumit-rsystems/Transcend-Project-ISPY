@isTest
public class TestProfilesFilter{
    static testMethod void test1(){
        Dashboard__c dc = new Dashboard__c(Profile_Filter__c  = false);      
        dc.name='TestDashboard';
        insert dc;
        
        ApexPages.StandardController sc = new ApexPages.standardController(dc);
        ProfilesFilter pf = new ProfilesFilter(sc);
                   
    }
     static testMethod void test2(){
        Dashboard__c dc = new Dashboard__c(Profile_Filter__c  = true);      
        dc.name='TestDashboard';
        
        insert dc;
        
        ApexPages.StandardController sc = new ApexPages.standardController(dc);
        ProfilesFilter pf = new ProfilesFilter(sc);
        pf.validateProfileFilters('System Administrator', dc.Id);
        
        pf = new ProfilesFilter(sc);
        pf.validateProfileFilters('Trial Administrator', dc.Id);
        
        pf = new ProfilesFilter(sc);
        pf.validateProfileFilters('Institute Level Admin', dc.Id);
        
        pf = new ProfilesFilter(sc);
        pf.validateProfileFilters('Site User', dc.Id);
                   
    }
}