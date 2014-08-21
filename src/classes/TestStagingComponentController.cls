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
private class TestStagingComponentController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        insert pss;
        
        Staging_Detail__c sdc = new Staging_Detail__c();
        sdc.Letarality__c = 'Left';
        sdc.Post_Surgery_Summary__c = pss.Id;
        
        Apexpages.currentPage().getParameters().put('postid',pss.Id); // else part line 23 staglist shud be empty
        StagingComponentController scc1 = new StagingComponentController();
        
        Staging_Detail__c sdc2 = new Staging_Detail__c(); 
        sdc2.Post_Surgery_Summary__c = pss.Id;
        sdc2.Letarality__c = 'Left';  //if condition line 14
        insert sdc2;
       
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        StagingComponentController scc = new StagingComponentController();
        
        scc.stagObjLeft = sdc;
        scc.recId = pss.Id;
        scc.insertStageLeft(pss.Id); // method "insertStageLeft()" completed 
        
        Staging_Detail__c sdc1 = new Staging_Detail__c(); //method "insertStageRight()" started from here
        sdc1.Letarality__c = 'Right';
        sdc1.Post_Surgery_Summary__c = pss.Id;
       
        scc.stagObjRight = sdc1;
        scc.recId = pss.Id;
        scc.insertStageRight(pss.Id); // method "insertStageRight()" completed
    }
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
        insert pss;
        
        Staging_Detail__c sdc2 = new Staging_Detail__c();
        sdc2.Post_Surgery_Summary__c = pss.Id;
        sdc2.Letarality__c = 'Right'; //else if condition line 16
        insert sdc2;
       
        Apexpages.currentPage().getParameters().put('postid',pss.Id);
        StagingComponentController scc = new StagingComponentController();
        
    }
    @isTest static void myUnitTest2() {
        // TO DO: implement unit test
        User u = [select Id from User where Id =:Userinfo.getUserId()];
        System.runAs(u) {
            
            Account acc = new Account();

            List<Account> lstAccount = [select Id from Account limit 1]; 
            
            if(!lstAccount.isEmpty()){
                
            acc = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Institution__c = acc.Id;
            p.Last_Name__c = 'test'; // patient
            p.Gender__c = 'Male';
            p.Race__c = 'White';
            p.Ethnicity__c = 'Not Hispanic or Latino';
            p.Birthdate__c = date.newInstance(1986, 7, 7);
            insert p;
                    
            Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
            insert pss;
            
            Staging_Detail__c sdc2 = new Staging_Detail__c(); // else part line 18 ..neither "left" nor "right" Letarality__c ..so it goes in else condition
            sdc2.Post_Surgery_Summary__c = pss.Id;
            insert sdc2;
           
            Apexpages.currentPage().getParameters().put('postid',pss.Id);
            StagingComponentController scc = new StagingComponentController();
            
            Apexpages.currentPage().getParameters().put('postid',null);
            Apexpages.currentPage().getParameters().put('patientId',p.Id);
            StagingComponentController scc1 = new StagingComponentController();
            
            scc1.insertBreastSurgicalStageLeft(p.Id);
            scc1.insertBreastSurgicalStageRight(p.Id);
            scc1.setPageController(scc1.getPageController());
            scc1.setKey(scc1.getKey());
        } 
      }
   } 
}