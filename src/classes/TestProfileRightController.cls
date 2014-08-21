@isTest
public class TestProfileRightController{
   public static testMethod void TestProfileRightController(){
     
        List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
       
        Widget__c widget=new  Widget__c();


  
        Profile_Right__c pr=new Profile_Right__c();
        
        ApexPages.StandardController controller= new ApexPages.StandardController(pr);
        ProfileRightController prc=new  ProfileRightController(controller);
        pr.Name='test';
        pr.Widget__c=profiles[0].id;
       
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