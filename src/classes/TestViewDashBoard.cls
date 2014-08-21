@isTest
public class TestViewDashBoard{
   public static testMethod void TestViewDashBoard(){
     dashboard__c d = new dashboard__c(Name = 'Test Dashboard');
     insert d; 
     
     Dashboard_Profile_Right__c dpr = new Dashboard_Profile_Right__c (Dashboard__c  = d.Id);
     insert dpr;
     
     ViewDashBoard vd = new ViewDashBoard(); 
   
   }
}