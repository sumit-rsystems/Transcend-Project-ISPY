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
private class TestGrowthFactorTrigger {

    @isTest static void myUnitTest() {
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) {
            
            Account acc = new Account();

            List<Account> lstAccount = [select Id from Account limit 1]; 
            
            if(!lstAccount.isEmpty()){
                
            acc = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Birthdate__c = date.newInstance(1980, 08, 05);
            p.Institution__c = acc.Id;
            p.Last_Name__c = 'test'; 
            p.Gender__c = 'Male';
            p.Race__c = 'White';
            p.Ethnicity__c = 'Not Hispanic or Latino';
            insert p;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = p.Id;
            insert tp;
            
            Chemo_Treatment__c chemo = new Chemo_Treatment__c();
            chemo.TrialPatient__c = tp.Id;
            chemo.Cycle_number__c = 2.0;
            chemo.Date_of_therapy__c = date.newInstance(2012, 6, 6);
            insert chemo;
            
            Arm__c arm = new Arm__c();
            arm.Name = 'test';
            insert arm;
            
            ArmPatient__c armPat = new ArmPatient__c();
            armPat.Patient_Id__c = p.Id;
            armPat.TrialPatient__c = tp.Id;
            armPat.Arm_Id__c = arm.Id;
            insert armPat;
            
            Growth_Factor__c gro1 = new Growth_Factor__c();
            gro1.Chemo_Treatment__c = chemo.Id;
            gro1.Name = 'Neulasta';
            gro1.isReceived__c = true;
            insert gro1;
            
            Growth_Factor__c gro2 = new Growth_Factor__c();
            gro2.Chemo_Treatment__c = chemo.Id;
            gro2.Name = 'Neupogen';
            gro2.isReceived__c = true;
            insert gro2;
            
            Growth_Factor__c gro3 = new Growth_Factor__c();
            gro3.Chemo_Treatment__c = chemo.Id;
            gro3.Name = 'test1';
            gro3.isReceived__c = true;
            insert gro3;
            
            gro1.Name = 'Neulasta';
            update gro1;
            
            gro2.Name = 'Neupogen';
            update gro2;
            
            gro3.Name = 'test2';
            update gro3;
            
         }
      }
   }
}