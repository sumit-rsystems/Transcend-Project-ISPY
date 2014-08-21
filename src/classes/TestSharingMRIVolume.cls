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
private class TestSharingMRIVolume {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account acc1 = new Account();
            
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc1 = lstAccount[0];
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = acc1.Id;
        insert site1;
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1998, 8, 8);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc1.Id;
        //pc.Site__c = site1.Id;
        pc.Medical_Record_Number__c = '3434';
        insert pc;
        
        Trial__c trial1 = new Trial__c();
        trial1.Name = 'test trial';
        insert trial1;
        
        TrialPatient__c trialPatObj = new TrialPatient__c();
        trialPatObj.Patient_Id__c = pc.Id;
        trialPatObj.Trial_Id__c = trial1.Id;
        trialPatObj.Site__c = site1.Id;
        trialPatObj.FirstName__c = pc.First_Name__c;
        trialPatObj.LastName__c = pc.Last_Name__c;
        insert trialPatObj;
        
        Site_Trial__c stTrial = new Site_Trial__c();
        stTrial.Site__c = site1.Id;
        stTrial.Trial__c = trial1.Id;
        insert stTrial;
        
        List<Profile> profileSiteUser = [select Id from Profile where Name = 'Site User'];
        List<User> user1 = [select Id from User where User.ProfileId = :profileSiteUser[0].Id];
        
      /*  InstitutionUser__c instUser1 = new InstitutionUser__c();
        instUser1.Site__c = site1.Id;
        instUser1.Trial__c = trial1.Id;
        instUser1.Institution__c = acc1.Id;
        instUser1.User__c = userinfo.getUserId();
        insert instUser1; */
        
        List<Site_Trial__c> stTrialList = [select Name from Site_Trial__c where Id =:stTrial.Id];
        
        system.debug('__stTrialName__'+stTrialList[0].Name);
        
        Group grp1 = new Group();
        grp1.Name = stTrialList[0].Name;
        grp1.Type = 'Regular';
        insert grp1;
        
        /*RecordType rType = new RecordType();
        rType.SobjectType = 'MRI_Volume__c';
        rType.Name = 'Live';
        insert rType;*/
        
        List<RecordType> recTypeLive = [select id,Name from RecordType where sObjectType = 'MRI_Volume__c' and Name = 'Live' ];
        
        MRI_Volume__c mriObj = new MRI_Volume__c();
        mriObj.TrialPatient__c = trialPatObj.Id;
        mriObj.Time_Point__c = 'Pre-Treatment';
        mriObj.MRI_Volume_in_cm3__c = 12.0;
        //mriObj.ACRIN_ID__c = '1';   
        mriObj.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mriObj.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;        
        insert mriObj; 
        
        mriObj.RecordTypeId = recTypeLive[0].Id;
        update mriObj;
        }
      }
   }
}