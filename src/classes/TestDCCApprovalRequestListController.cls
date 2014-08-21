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
private class TestDCCApprovalRequestListController {
    
    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        RecordType rt = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.Name = 'DCC' and r.SobjectType = 'Account'];
        
        Account a = new Account();
        a.Name = 'dcc';
        a.RecordTypeId = rt.Id;
        insert a;
        
        RecordType rt1 = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.Name = 'Institution' and r.SobjectType = 'Account'];

        a = new Account();
        a.Name = 'inst';
        a.RecordTypeId = rt1.Id;
        insert a;
        
        RecordType rt2 = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.Name = 'Site' and r.SobjectType = 'Site__c'];
        Site__c s = new Site__c();
        s.Name = 'dsfadsf';
        s.RecordTypeId = rt2.Id;
        s.Institute__c = a.Id;
        insert s; 
        
        a = [select id, Inst_Group__c from Account where id = :a.Id];
        Group g = [Select g.Name, g.Id From Group g where g.Name = :a.Inst_Group__c];
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'DCC User' and IsActive = true];
        
		List<Approval_Request__c> arList = new List<Approval_Request__c>();
		for(integer i=0; i < 1000; i++) {
			Approval_Request__c ar = new Approval_Request__c();
	        ar.Site__c = s.Id;
	        ar.Subject_Id__c = '12323';
	        ar.Status__c = 'approved';
	        ar.Institution__c = a.Id;
	        ar.Group_Id__c = g.Id;
	        arList.add(ar);
		}
        insert arList;
        
		        
        System.runAs (thisUser[0]){
	        
	        DCCApprovalRequestListController dcc = new DCCApprovalRequestListController();  
	        dcc.selectedRequestStatus = 'approved';
	        dcc.next();
	        dcc.prev();
	        dcc.firstPage();
	        dcc.lastPage();
		}
	}
	
	@isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        RecordType rt = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.Name = 'DCC' and r.SobjectType = 'Account'];
        
        Account a = new Account();
        a.Name = 'dcc';
        a.RecordTypeId = rt.Id;
        insert a;
        
        RecordType rt1 = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.Name = 'Institution' and r.SobjectType = 'Account'];

        a = new Account();
        a.Name = 'inst';
        a.RecordTypeId = rt1.Id;
        insert a;
        
        RecordType rt2 = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.Name = 'Site' and r.SobjectType = 'Site__c'];
        Site__c s = new Site__c();
        s.Name = 'dsfadsf';
        s.RecordTypeId = rt2.Id;
        s.Institute__c = a.Id;
        insert s; 
        
        a = [select id, Inst_Group__c from Account where id = :a.Id];
        Group g = [Select g.Name, g.Id From Group g where g.Name = :a.Inst_Group__c];
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'DCC User' and IsActive = true];
        
		List<Approval_Request__c> arList = new List<Approval_Request__c>();
		for(integer i=0; i < 1000; i++) {
			Approval_Request__c ar = new Approval_Request__c();
	        ar.Site__c = s.Id;
	        ar.Subject_Id__c = '12323';
	        ar.Status__c = 'pending';
	        ar.Institution__c = a.Id;
	        ar.Group_Id__c = g.Id;
	        arList.add(ar);
		}
        insert arList;
        
		        
        System.runAs (thisUser[0]){
	        
	        DCCApprovalRequestListController dcc = new DCCApprovalRequestListController();  
	        dcc.selectedRequestStatus = 'pending';
	        dcc.next();
	        dcc.prev();
	        dcc.firstPage();
	        dcc.lastPage();
	        dcc.changeStatus();
	        
	        Apexpages.currentPage().getParameters().put('selectedReq', 'pending');
			Apexpages.currentPage().getParameters().put('curPg', '0');
	        dcc.showCSVRecords();
		}
	}
	
	@isTest static void myUnitTest2() {
        // TO DO: implement unit test
        
        RecordType rt = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.Name = 'DCC' and r.SobjectType = 'Account'];
        
        Account a = new Account();
        a.Name = 'dcc';
        a.RecordTypeId = rt.Id;
        insert a;
        
        RecordType rt1 = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.Name = 'Institution' and r.SobjectType = 'Account'];

        a = new Account();
        a.Name = 'inst';
        a.RecordTypeId = rt1.Id;
        insert a;
        
        RecordType rt2 = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.Name = 'Site' and r.SobjectType = 'Site__c'];
        Site__c s = new Site__c();
        s.Name = 'dsfadsf';
        s.RecordTypeId = rt2.Id;
        s.Institute__c = a.Id;
        insert s; 
        
        a = [select id, Inst_Group__c from Account where id = :a.Id];
        Group g = [Select g.Name, g.Id From Group g where g.Name = :a.Inst_Group__c];
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'DCC User' and IsActive = true];
        
		List<Approval_Request__c> arList = new List<Approval_Request__c>();
		for(integer i=0; i < 1000; i++) {
			Approval_Request__c ar = new Approval_Request__c();
	        ar.Site__c = s.Id;
	        ar.Subject_Id__c = '12323';
	        ar.Status__c = 'rejected';
	        ar.Institution__c = a.Id;
	        ar.Group_Id__c = g.Id;
	        arList.add(ar);
		}
        insert arList;
        
		        
        System.runAs (thisUser[0]){
	        
	        DCCApprovalRequestListController dcc = new DCCApprovalRequestListController();  
	        dcc.selectedRequestStatus = 'rejected';
	        dcc.next();
	        dcc.prev();
	        dcc.firstPage();
	        dcc.lastPage();
		}
	}
}