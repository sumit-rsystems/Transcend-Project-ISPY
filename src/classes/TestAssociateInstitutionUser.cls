/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the 
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestAssociateInstitutionUser {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
       // Profile dccProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id From Users u where IsActive = true) From Profile p where Name = 'Developers' ];
        List<User> lstUser = [Select u.IsActive, u.Id From User u where IsActive = true];     
        System.runAs ( lstUser[0] ) {
        
        List<RecordType> lstRecType = [select Id,Name,SobjectType from RecordType where SobjectType = 'Account' and Name = 'Institution']; 
        
        Account acc = new Account();
        acc.RecordTypeId = lstRecType[0].Id;
        acc.Name = 'Test';
        insert acc;
        
        List<RecordType> lstSiteRecType = [select Id,Name,SobjectType from RecordType where SobjectType = 'Site__c' and (Name = 'Site' or Name = 'Lab')];
        
        Site__c st = new Site__c();
        st.Institute__c = acc.Id;
        st.RecordTypeId = lstSiteRecType[0].Id;
        st.Name = 'Test';
        insert st;
        
        Trial__c tri = new Trial__c();
        tri.Name = 'Test';
        insert tri;
        
        Site_Trial__c stTri = new Site_Trial__c();
        stTri.Site__c = st.Id;
        stTri.Trial__c = tri.Id;
        insert stTri;
        
        InstitutionUser__c IntUser = new InstitutionUser__c();
        IntUser.Institution__c = acc.Id;
        IntUser.Trial__c = tri.Id;
        IntUser.Site__c = st.Id;
        IntUser.User__c = lstUser[0].Id;
        insert IntUser;
        
        AssociateInstitutionUser aiu = new AssociateInstitutionUser();
        aiu.selectInstitutions = acc.Id;
        aiu.getSiteRec();
        aiu.selectSite = st.Id;
        
        aiu.getUserRec();
        
        aiu.CustomeSave();
        
        ApexPages.currentPage().getParameters().put('InstName','Institution');
        ApexPages.currentPage().getParameters().put('InstId',acc.Id);
        ApexPages.currentPage().getParameters().put('SiteName','site'); 
        ApexPages.currentPage().getParameters().put('siteId',st.Id);
        AssociateInstitutionUser aiu1 = new AssociateInstitutionUser();
        
        aiu1.getSiteRec();
        
        aiu1.getUserRec();
        
        aiu1.CustomeSave();
        
    }
   }
}