@isTest
public class TestDBProfileRightController{
   public static testMethod void TestDBProfileRightController(){
     
        List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
       
        Dashboard__c widget=new  Dashboard__c ();


  
        Dashboard_Profile_Right__c pr=new Dashboard_Profile_Right__c();
        
        ApexPages.StandardController controller= new ApexPages.StandardController(pr);
        DBProfileRightController prc=new  DBProfileRightController(controller);
        pr.Name='test';
        pr.Dashboard__c =profiles[0].id;
       
        List<String> leftselected = new List<String>();
        leftselected.add(profiles[0].id);
        prc.leftselected=leftselected;
        
        List<String> rightselected = new List<String>();
        rightselected.add(profiles[0].id);
        prc.rightselected=rightselected;    
       
       
        prc.selectclick();
        prc.unselectclick();
        prc.getunSelectedValues();
        prc.getSelectedValues();
        prc.Save(); 
    
    }

}