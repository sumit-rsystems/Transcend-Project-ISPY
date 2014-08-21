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
private class TestBloodSpecimenController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = acc.Id;
        p.Race__c = 'White';
       
        p.Ethnicity__c = 'Not Hispanic or Latino';
        
         
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        BloodSpecimenForm__c bsf = new BloodSpecimenForm__c();
        bsf.TrialPatient__c = tp.Id;
        bsf.Reason_all_samples_not_collected__c = 'Other';
        bsf.CollectionDate__c = system.today();
        bsf.Time_Point__c = 'Pre-treatment';
        //insert bsf;
        
        BloodSpecimenForm__c bsfSerumCollected = new BloodSpecimenForm__c();
        bsfSerumCollected.TrialPatient__c = tp.Id;
        bsfSerumCollected.Reason_all_samples_not_collected__c = 'Other';
        bsfSerumCollected.CollectionDate__c = system.today();
        bsfSerumCollected.Time_Point__c = 'Pre-treatment';
        //insert bsfSerumCollected;
        List<BloodSpecimenForm__c> bsfList = new List<BloodSpecimenForm__c>();
        bsfList.add(bsf);
        bsfList.add(bsfSerumCollected);
        
        insert bsfList;
        
        
        BloodSpecimenInfo__c bsi = new BloodSpecimenInfo__c();
        bsi.BloodSpecimenForm__c = bsf.Id;
        bsi.Name = 'Serum Specimen #';  // satisfies "if" condition, line 84
        bsi.Shipped__c = 'No';
        bsi.Reason_samples_not_shipped__c = 'Other';
        insert bsi;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.currentPage().getParameters().put('bloodSpecimenId',bsf.Id);
        Apexpages.StandardController std = new Apexpages.StandardController(bsf);
        BloodSpecimenController bsc = new BloodSpecimenController(std);
        
        
        
        BloodSpecimenInfo__c bsiSerumCollected = new BloodSpecimenInfo__c();
        bsiSerumCollected.BloodSpecimenForm__c = bsfSerumCollected.Id;
        bsiSerumCollected.Name = 'Serum Specimen #'; 
        bsiSerumCollected.Shipped__c = 'Yes';
        insert bsiSerumCollected;
        
        BloodSpecimenInfo__c bsiSerumCollected1 = new BloodSpecimenInfo__c();
        bsiSerumCollected1.BloodSpecimenForm__c = bsfSerumCollected.Id;
        bsiSerumCollected1.Name = 'Serum Specimen #';  // satisfies "if" condition, line 84
        bsiSerumCollected1.Shipped__c = 'No';
        bsiSerumCollected1.Reason_samples_not_shipped__c = '';
        insert bsiSerumCollected1;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController stdSerumCollected = new Apexpages.StandardController(bsfSerumCollected);
        BloodSpecimenController bscSerumCollected = new BloodSpecimenController(stdSerumCollected);
        bscSerumCollected.addSpecimen();
        bscSerumCollected.saveCRF();
        
        BloodSpecimenController.calculateSID('123', 'Serum', 'Pre-treatment', '12345');
        BloodSpecimenController.calculateSID('123', 'Plasma', 'Pre-treatment', '12345');
        BloodSpecimenController.calculateSID('123', 'Buffy coat', 'Pre-treatment', '12345');
       
        BloodSpecimenController.calculateSID('123', 'Plasma', 'Early treatment', '12345');
        BloodSpecimenController.calculateSID('123', 'Buffy coat', 'Early treatment', '12345'); 
        BloodSpecimenController.calculateSID('123', 'Serum', 'Early treatment', '12345');
        
        Apexpages.currentPage().getParameters().put('type','serum');
        bsc.addMoreSpecimen(); // method "addMoreSpecimen()" begins and end here
        
        bsc.saveCRF(); // method "saveCRF()" begins and end here
        
        BloodSpecimenInfo__c bsi1 = new BloodSpecimenInfo__c();
        bsi1.BloodSpecimenForm__c = bsf.Id;
        bsi1.Name = 'Plasma Specimen #'; // satisfies "if" condition, line 92
        bsi1.Shipped__c = 'No';
        bsi1.Reason_samples_not_shipped__c = 'Other';
        insert bsi1;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController std1 = new Apexpages.StandardController(bsf);
        BloodSpecimenController bsc1 = new BloodSpecimenController(std1);   
        
        BloodSpecimenForm__c bsfPlasmaCollected = new BloodSpecimenForm__c();
        bsfPlasmaCollected.TrialPatient__c = tp.Id;
        bsfPlasmaCollected.Reason_all_samples_not_collected__c = 'Other';
        bsfPlasmaCollected.CollectionDate__c = system.today();
        bsfPlasmaCollected.Time_Point__c = 'Pre-treatment';
        insert bsfPlasmaCollected;
        
        BloodSpecimenInfo__c bsiPlasmaCollected = new BloodSpecimenInfo__c();
        bsiPlasmaCollected.BloodSpecimenForm__c = bsfPlasmaCollected.Id;
        bsiPlasmaCollected.Name = 'Plasma Specimen #'; 
        bsiPlasmaCollected.Shipped__c = 'Yes';
        insert bsiPlasmaCollected;
        
        BloodSpecimenInfo__c bsiPlasmaCollected2 = new BloodSpecimenInfo__c();
        bsiPlasmaCollected2.BloodSpecimenForm__c = bsfPlasmaCollected.Id;
        bsiPlasmaCollected2.Name = 'Serum Specimen #'; 
        bsiPlasmaCollected2.Shipped__c = 'No';
        bsiPlasmaCollected2.Reason_samples_not_shipped__c = '';
        insert bsiPlasmaCollected2;
        BloodSpecimenInfo__c bsiPlasmaCollected1 = new BloodSpecimenInfo__c();
        bsiPlasmaCollected1.BloodSpecimenForm__c = bsfPlasmaCollected.Id;
        bsiPlasmaCollected1.Name = 'Plasma Specimen #'; 
        bsiPlasmaCollected1.Shipped__c = 'No';
        bsiPlasmaCollected1.Reason_samples_not_shipped__c = '';
        insert bsiPlasmaCollected1;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController stdPlasmaCollected = new Apexpages.StandardController(bsfPlasmaCollected);
        BloodSpecimenController bscPlasmaCollected = new BloodSpecimenController(stdPlasmaCollected);
        
        bscPlasmaCollected.bloodSpecimen.Reason_all_samples_not_collected__c = null;
        bscPlasmaCollected.bloodSpecimen.Status__c = 'Approval Not Required';
        bscPlasmaCollected.bloodSpecimen.TrialPatient__c = tp.Id;
        upsert bscPlasmaCollected.bloodSpecimen;
        bscPlasmaCollected.saveCRF();
        /*
        Apexpages.currentPage().getParameters().put('type','plasma');
        bsc1.addMoreSpecimen(); 
        
        BloodSpecimenInfo__c bsi2 = new BloodSpecimenInfo__c();
        bsi2.BloodSpecimenForm__c = bsf.Id;
        bsi2.Name = 'Buffy coat specimen #'; // satisfies "if" condition, line 100
        bsi2.Shipped__c = 'No';
        bsi2.Reason_samples_not_shipped__c = 'Other';
        insert bsi2;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController std2 = new Apexpages.StandardController(bsf);
        BloodSpecimenController bsc2 = new BloodSpecimenController(std2);
        bsc2.bloodSpecimen.CollectionDate__c = null;
        bsc2.bloodSpecimen.Time_Point__c = null;
        bsc2.bloodSpecimen.CollectionDate__c = Date.newInstance(2012, 12, 12);
        BloodSpecimenForm__c bsfBuffyCollected = new BloodSpecimenForm__c();
        bsfBuffyCollected.TrialPatient__c = tp.Id;
        bsfBuffyCollected.Reason_all_samples_not_collected__c = 'Other';
        bsfBuffyCollected.CollectionDate__c = system.today();
        bsfBuffyCollected.Time_Point__c = 'Pre-treatment';
        insert bsfBuffyCollected;
        
        BloodSpecimenInfo__c bsiBuffyCollected = new BloodSpecimenInfo__c();
        bsiBuffyCollected.BloodSpecimenForm__c = bsfBuffyCollected.Id;
        bsiBuffyCollected.Name = 'Buffy coat specimen #'; 
        bsiBuffyCollected.Shipped__c = 'Yes';
        insert bsiBuffyCollected;
        
        BloodSpecimenInfo__c bsiBuffyCollected1 = new BloodSpecimenInfo__c();
        bsiBuffyCollected1.BloodSpecimenForm__c = bsfBuffyCollected.Id;
        bsiBuffyCollected1.Name = 'Buffy coat specimen #'; 
        bsiBuffyCollected1.Shipped__c = 'No';
        bsiBuffyCollected1.Reason_samples_not_shipped__c = '';
        insert bsiBuffyCollected1;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController stdBuffyCollected = new Apexpages.StandardController(bsfBuffyCollected);
        BloodSpecimenController bscBuffyCollected = new BloodSpecimenController(stdBuffyCollected);
        bscBuffyCollected.bloodSpecimen.Reason_all_samples_not_collected__c = null;
        bscBuffyCollected.bloodSpecimen.Status__c = 'Approval Not Required';
        bscBuffyCollected.bloodSpecimen.TrialPatient__c = tp.Id;
        upsert bscBuffyCollected.bloodSpecimen;
        bscBuffyCollected.saveCRF();
        Apexpages.currentPage().getParameters().put('type','buffy');
        bsc2.addMoreSpecimen(); // method "addMoreSpecimen()" begins and end here
        
        bsc2.saveCRF(); // method "saveCRF()" begins and end here
        
        Apexpages.currentPage().getParameters().put('nextTab','saveAndClose'); 
        bsc2.nextTabName = 'saveAndClose';
        bsc2.next();
        
        bsc2.currentTab = 'ConsentTab';
        bsc2.next();
        
        bsc2.cancelCRF();
        bsc2.trialPatientId = null;
        bsc2.cancelCRF(); 
        TrialPatient__c tp2 = new TrialPatient__c();
        tp2.Patient_Id__c = p.Id;
        tp2.FirstName__c = 'a';
        tp2.LastName__c = 'b';
        insert tp2;
        bsc2.cancelCRF(); // method "cancelCRF()" begins and end here
        */
            }
        }
    }
    
    @isTest static void myUnitTestNew() {
        // TO DO: implement unit test
        List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = acc.Id;
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        BloodSpecimenForm__c bsf = new BloodSpecimenForm__c();
        bsf.TrialPatient__c = tp.Id;
        bsf.Reason_all_samples_not_collected__c = 'Other';
        bsf.CollectionDate__c = system.today();
        bsf.Time_Point__c = 'Pre-treatment';
        //insert bsf;
        
        BloodSpecimenForm__c bsfSerumCollected = new BloodSpecimenForm__c();
        bsfSerumCollected.TrialPatient__c = tp.Id;
        bsfSerumCollected.Reason_all_samples_not_collected__c = 'Other';
        bsfSerumCollected.CollectionDate__c = system.today();
        bsfSerumCollected.Time_Point__c = 'Pre-treatment';
        //insert bsfSerumCollected;
        List<BloodSpecimenForm__c> bsfList = new List<BloodSpecimenForm__c>();
        bsfList.add(bsf);
        bsfList.add(bsfSerumCollected);
        
        insert bsfList;
        
        
        BloodSpecimenInfo__c bsi = new BloodSpecimenInfo__c();
        bsi.BloodSpecimenForm__c = bsf.Id;
        bsi.Name = 'Serum Specimen #';  // satisfies "if" condition, line 84
        bsi.Shipped__c = 'No';
        bsi.Reason_samples_not_shipped__c = 'Other';
        insert bsi;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.currentPage().getParameters().put('bloodSpecimenId',bsf.Id);
        Apexpages.StandardController std = new Apexpages.StandardController(bsf);
        BloodSpecimenController bsc = new BloodSpecimenController(std);
        
        
        
        BloodSpecimenInfo__c bsiSerumCollected = new BloodSpecimenInfo__c();
        bsiSerumCollected.BloodSpecimenForm__c = bsfSerumCollected.Id;
        bsiSerumCollected.Name = 'Serum Specimen #'; 
        bsiSerumCollected.Shipped__c = 'Yes';
        insert bsiSerumCollected;
        
        BloodSpecimenInfo__c bsiSerumCollected1 = new BloodSpecimenInfo__c();
        bsiSerumCollected1.BloodSpecimenForm__c = bsfSerumCollected.Id;
        bsiSerumCollected1.Name = 'Serum Specimen #';  // satisfies "if" condition, line 84
        bsiSerumCollected1.Shipped__c = 'No';
        bsiSerumCollected1.Reason_samples_not_shipped__c = '';
        insert bsiSerumCollected1;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController stdSerumCollected = new Apexpages.StandardController(bsfSerumCollected);
        BloodSpecimenController bscSerumCollected = new BloodSpecimenController(stdSerumCollected);
        bscSerumCollected.addSpecimen();
        bscSerumCollected.saveCRF();
        
        BloodSpecimenController.calculateSID('123', 'Serum', 'Pre-treatment', '12345');
        BloodSpecimenController.calculateSID('123', 'Plasma', 'Pre-treatment', '12345');
        BloodSpecimenController.calculateSID('123', 'Buffy coat', 'Pre-treatment', '12345');
       
        BloodSpecimenController.calculateSID('123', 'Plasma', 'Early treatment', '12345');
        BloodSpecimenController.calculateSID('123', 'Buffy coat', 'Early treatment', '12345'); 
        BloodSpecimenController.calculateSID('123', 'Serum', 'Early treatment', '12345');
        
        Apexpages.currentPage().getParameters().put('type','serum');
        bsc.addMoreSpecimen(); // method "addMoreSpecimen()" begins and end here
        
        bsc.saveCRF(); // method "saveCRF()" begins and end here
        
        BloodSpecimenInfo__c bsi1 = new BloodSpecimenInfo__c();
        bsi1.BloodSpecimenForm__c = bsf.Id;
        bsi1.Name = 'Plasma Specimen #'; // satisfies "if" condition, line 92
        bsi1.Shipped__c = 'No';
        bsi1.Reason_samples_not_shipped__c = 'Other';
        insert bsi1;
        /*
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController std1 = new Apexpages.StandardController(bsf);
        BloodSpecimenController bsc1 = new BloodSpecimenController(std1);   
        
        BloodSpecimenForm__c bsfPlasmaCollected = new BloodSpecimenForm__c();
        bsfPlasmaCollected.TrialPatient__c = tp.Id;
        bsfPlasmaCollected.Reason_all_samples_not_collected__c = 'Other';
        bsfPlasmaCollected.CollectionDate__c = system.today();
        bsfPlasmaCollected.Time_Point__c = 'Pre-treatment';
        insert bsfPlasmaCollected;
        
        BloodSpecimenInfo__c bsiPlasmaCollected = new BloodSpecimenInfo__c();
        bsiPlasmaCollected.BloodSpecimenForm__c = bsfPlasmaCollected.Id;
        bsiPlasmaCollected.Name = 'Plasma Specimen #'; 
        bsiPlasmaCollected.Shipped__c = 'Yes';
        insert bsiPlasmaCollected;
        
        BloodSpecimenInfo__c bsiPlasmaCollected2 = new BloodSpecimenInfo__c();
        bsiPlasmaCollected2.BloodSpecimenForm__c = bsfPlasmaCollected.Id;
        bsiPlasmaCollected2.Name = 'Serum Specimen #'; 
        bsiPlasmaCollected2.Shipped__c = 'No';
        bsiPlasmaCollected2.Reason_samples_not_shipped__c = '';
        insert bsiPlasmaCollected2;
        BloodSpecimenInfo__c bsiPlasmaCollected1 = new BloodSpecimenInfo__c();
        bsiPlasmaCollected1.BloodSpecimenForm__c = bsfPlasmaCollected.Id;
        bsiPlasmaCollected1.Name = 'Plasma Specimen #'; 
        bsiPlasmaCollected1.Shipped__c = 'No';
        bsiPlasmaCollected1.Reason_samples_not_shipped__c = '';
        insert bsiPlasmaCollected1;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController stdPlasmaCollected = new Apexpages.StandardController(bsfPlasmaCollected);
        BloodSpecimenController bscPlasmaCollected = new BloodSpecimenController(stdPlasmaCollected);
        
        bscPlasmaCollected.bloodSpecimen.Reason_all_samples_not_collected__c = null;
        bscPlasmaCollected.bloodSpecimen.Status__c = 'Approval Not Required';
        bscPlasmaCollected.bloodSpecimen.TrialPatient__c = tp.Id;
        upsert bscPlasmaCollected.bloodSpecimen;
        bscPlasmaCollected.saveCRF();
        
        Apexpages.currentPage().getParameters().put('type','plasma');
        bsc1.addMoreSpecimen(); 
        
        BloodSpecimenInfo__c bsi2 = new BloodSpecimenInfo__c();
        bsi2.BloodSpecimenForm__c = bsf.Id;
        bsi2.Name = 'Buffy coat specimen #'; // satisfies "if" condition, line 100
        bsi2.Shipped__c = 'No';
        bsi2.Reason_samples_not_shipped__c = 'Other';
        insert bsi2;
        */
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController std2 = new Apexpages.StandardController(bsf);
        BloodSpecimenController bsc2 = new BloodSpecimenController(std2);
        bsc2.bloodSpecimen.CollectionDate__c = null;
        bsc2.bloodSpecimen.Time_Point__c = null;
        bsc2.bloodSpecimen.CollectionDate__c = Date.newInstance(2012, 12, 12);
        BloodSpecimenForm__c bsfBuffyCollected = new BloodSpecimenForm__c();
        bsfBuffyCollected.TrialPatient__c = tp.Id;
        bsfBuffyCollected.Reason_all_samples_not_collected__c = 'Other';
        bsfBuffyCollected.CollectionDate__c = system.today();
        bsfBuffyCollected.Time_Point__c = 'Pre-treatment';
        insert bsfBuffyCollected;
        
        BloodSpecimenInfo__c bsiBuffyCollected = new BloodSpecimenInfo__c();
        bsiBuffyCollected.BloodSpecimenForm__c = bsfBuffyCollected.Id;
        bsiBuffyCollected.Name = 'Buffy coat specimen #'; 
        bsiBuffyCollected.Shipped__c = 'Yes';
        insert bsiBuffyCollected;
        
        BloodSpecimenInfo__c bsiBuffyCollected1 = new BloodSpecimenInfo__c();
        bsiBuffyCollected1.BloodSpecimenForm__c = bsfBuffyCollected.Id;
        bsiBuffyCollected1.Name = 'Buffy coat specimen #'; 
        bsiBuffyCollected1.Shipped__c = 'No';
        bsiBuffyCollected1.Reason_samples_not_shipped__c = '';
        insert bsiBuffyCollected1;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController stdBuffyCollected = new Apexpages.StandardController(bsfBuffyCollected);
        BloodSpecimenController bscBuffyCollected = new BloodSpecimenController(stdBuffyCollected);
        bscBuffyCollected.bloodSpecimen.Reason_all_samples_not_collected__c = null;
        bscBuffyCollected.bloodSpecimen.Status__c = 'Approval Not Required';
        bscBuffyCollected.bloodSpecimen.TrialPatient__c = tp.Id;
        upsert bscBuffyCollected.bloodSpecimen;
        bscBuffyCollected.saveCRF();
        Apexpages.currentPage().getParameters().put('type','buffy');
        bsc2.addMoreSpecimen(); // method "addMoreSpecimen()" begins and end here
        
        bsc2.saveCRF(); // method "saveCRF()" begins and end here
        
        Apexpages.currentPage().getParameters().put('nextTab','saveAndClose'); 
        bsc2.nextTabName = 'saveAndClose';
        bsc2.next();
        
        bsc2.currentTab = 'ConsentTab';
        bsc2.next();
        
        bsc2.cancelCRF();
        bsc2.trialPatientId = null;
        bsc2.cancelCRF(); 
        TrialPatient__c tp2 = new TrialPatient__c();
        tp2.Patient_Id__c = p.Id;
        tp2.FirstName__c = 'a';
        tp2.LastName__c = 'b';
        insert tp2;
        bsc2.cancelCRF(); // method "cancelCRF()" begins and end here
            }
        }
    }
    @isTest static void myUnitTest1() { // 2nd method to satisfy "else" part line 120,123,127
        // TO DO: implement unit test
        List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = acc.Id;
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        BloodSpecimenForm__c bsf = new BloodSpecimenForm__c();
        bsf.TrialPatient__c = tp.Id;
        bsf.CollectionDate__c = system.today();
        bsf.Time_Point__c = 'Pre-treatment';
        insert bsf;
        
        BloodSpecimenInfo__c bsi = new BloodSpecimenInfo__c();
        bsi.BloodSpecimenForm__c = bsf.Id;
        bsi.Name = 'Serum Specimen #';  // satisfies "else" condition, line 120,123,127
        //bsi.Reason_samples_not_shipped__c = 'Thawed';
        insert bsi;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController std = new Apexpages.StandardController(bsf);
        BloodSpecimenController bsc = new BloodSpecimenController(std);
        
        Apexpages.currentPage().getParameters().put('type','serum');
        bsc.addMoreSpecimen(); // method "addMoreSpecimen()" begins and end here
        
        bsc.saveCRF(); // method "saveCRF()" begins and end here
        
        BloodSpecimenController.calculateSID('123', 'Serum', 'Inter-regimen', '12345');
        BloodSpecimenController.calculateSID('123', 'Plasma', 'Inter-regimen', '12345');
        BloodSpecimenController.calculateSID('123', 'Buffy coat', 'Inter-regimen', '12345');
        
        BloodSpecimenController.calculateSID('123', 'Serum', 'Surgery', '12345');
        BloodSpecimenController.calculateSID('123', 'Plasma', 'Surgery', '12345');
        BloodSpecimenController.calculateSID('123', 'Buffy coat', 'Surgery', '12345');
        
        BloodSpecimenInfo__c bsi1 = new BloodSpecimenInfo__c();
        bsi1.BloodSpecimenForm__c = bsf.Id;
        bsi1.Name = 'Plasma Specimen #'; // satisfies "else" condition, line 145,148,152
        //bsi1.Reason_samples_not_shipped__c = 'Thawed';
        insert bsi1;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController std1 = new Apexpages.StandardController(bsf);
        BloodSpecimenController bsc1 = new BloodSpecimenController(std1);
        
        Apexpages.currentPage().getParameters().put('type','plasma');
        bsc1.addMoreSpecimen(); // method "addMoreSpecimen()" begins and end here
        
        bsc1.saveCRF(); // method "saveCRF()" begins and end here
        
        BloodSpecimenInfo__c bsi2 = new BloodSpecimenInfo__c();
        bsi2.BloodSpecimenForm__c = bsf.Id;
        bsi2.Name = 'Buffy coat specimen #'; // satisfies "else" condition, line 171,174,174
       // bsi2.Reason_samples_not_shipped__c = 'Thawed';
        insert bsi2;
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id); 
        Apexpages.StandardController std2 = new Apexpages.StandardController(bsf);
        BloodSpecimenController bsc2 = new BloodSpecimenController(std2);
        
        Apexpages.currentPage().getParameters().put('type','buffy');
        bsc2.addMoreSpecimen(); // method "addMoreSpecimen()" begins and end here
        
        bsc2.saveCRF(); // method "saveCRF()" begins and end here
        
        }
      }
    }
    
    @isTest static void getTriggerCoverage() { 
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = acc.Id;
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        BloodSpecimenForm__c bloodSpecimen = new BloodSpecimenForm__c(); 
        bloodSpecimen.TrialPatient__c = tp.Id;
        bloodSpecimen.CollectionDate__c = system.today();
        bloodSpecimen.Time_Point__c = 'Early Treatment'; 
        bloodSpecimen.Status__c = 'Completed';
        insert bloodSpecimen;
        
        BloodSpecimenInfo__c serumSample = new BloodSpecimenInfo__c();
        serumSample.BloodSpecimenForm__c = bloodSpecimen.Id;
        serumSample.Name = 'Serum Specimen #';
        insert serumSample;
        
        BloodSpecimenInfo__c plasmaSample = new BloodSpecimenInfo__c();
        plasmaSample.BloodSpecimenForm__c = bloodSpecimen.Id;
        plasmaSample.Name = 'Plasma Specimen #';
        insert plasmaSample;
        
        BloodSpecimenInfo__c buffySample = new BloodSpecimenInfo__c();
        buffySample.BloodSpecimenForm__c = bloodSpecimen.Id;
        buffySample.Name = 'Buffy coat specimen #';
        insert buffySample;
        
        bloodSpecimen.Status__c = 'Approval Not Required';
        update bloodSpecimen;
         
        bloodSpecimen.Status__c = 'Completed';
        bloodSpecimen.Time_Point__c = 'Inter-Regimen';
        update bloodSpecimen; 
        
        bloodSpecimen.Status__c = 'Approval Not Required';
        update bloodSpecimen;
        
        bloodSpecimen.Status__c = 'Completed';
        bloodSpecimen.Time_Point__c = 'Pre-Surgery';
        update bloodSpecimen;
        
        bloodSpecimen.Status__c = 'Approval Not Required'; 
        update bloodSpecimen;
        
         
        BloodSpecimenForm__c bloodSpecimen1 = new BloodSpecimenForm__c();
        bloodSpecimen1.TrialPatient__c = tp.Id;
        bloodSpecimen1.CollectionDate__c = system.today();
        bloodSpecimen1.Time_Point__c = 'Pre-Surgery';
        
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);
        Apexpages.StandardController std = new Apexpages.StandardController(bloodSpecimen1);
        BloodSpecimenController tsf = new BloodSpecimenController(std);
        tsf.bloodSpecimen = bloodSpecimen;
        tsf.saveMainCRF(); // else if line 119
        
        Apexpages.currentPage().getParameters().put('nextTab','CompleteTab');
        tsf.nextTabName = 'CompleteTab';
        tsf.next();
        
        tsf.currentTab = 'Blood';
        tsf.next();
        
       
        tsf.previous();
        tsf.resendCode();
        tsf.customCancel();
        tsf.signAndSubmit();
      }
    }
  }
  @isTest static void getTriggerCoverageNew() { 
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = acc.Id;
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        BloodSpecimenForm__c bloodSpecimen = new BloodSpecimenForm__c(); 
        bloodSpecimen.TrialPatient__c = tp.Id;
        bloodSpecimen.CollectionDate__c = system.today();
        bloodSpecimen.Time_Point__c = 'Early Treatment'; 
        bloodSpecimen.Status__c = 'Completed';
        insert bloodSpecimen;
        
        BloodSpecimenInfo__c serumSample = new BloodSpecimenInfo__c();
        serumSample.BloodSpecimenForm__c = bloodSpecimen.Id;
        serumSample.Name = 'Serum Specimen #';
        insert serumSample;
        
        BloodSpecimenInfo__c plasmaSample = new BloodSpecimenInfo__c();
        plasmaSample.BloodSpecimenForm__c = bloodSpecimen.Id;
        plasmaSample.Name = 'Plasma Specimen #';
        insert plasmaSample;
        
        BloodSpecimenInfo__c buffySample = new BloodSpecimenInfo__c();
        buffySample.BloodSpecimenForm__c = bloodSpecimen.Id;
        buffySample.Name = 'Buffy coat specimen #';
        insert buffySample;
        
        bloodSpecimen.Status__c = 'Approval Not Required';
        update bloodSpecimen;
         
        bloodSpecimen.Status__c = 'Completed';
        bloodSpecimen.Time_Point__c = 'Inter-Regimen';
        update bloodSpecimen; 
        
        bloodSpecimen.Status__c = 'Approval Not Required';
        update bloodSpecimen;
        
        bloodSpecimen.Status__c = 'Completed';
        bloodSpecimen.Time_Point__c = 'Pre-Surgery';
        update bloodSpecimen;
        
        bloodSpecimen.Status__c = 'Approval Not Required'; 
        update bloodSpecimen;
        
        BloodSpecimenForm__c bloodSpecimen1 = new BloodSpecimenForm__c();
        bloodSpecimen1.TrialPatient__c = tp.Id;
        bloodSpecimen1.CollectionDate__c = system.today();
        bloodSpecimen1.Time_Point__c = 'Pre-Surgery';
        
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);
        Apexpages.StandardController std = new Apexpages.StandardController(bloodSpecimen1);
        BloodSpecimenController tsf = new BloodSpecimenController(std);
        tsf.bloodSpecimen = bloodSpecimen1;
        tsf.saveMainCRF(); // else if line 119
        
        Apexpages.currentPage().getParameters().put('nextTab','CompleteTab');
        tsf.nextTabName = 'CompleteTab';
        tsf.next();
        
        tsf.currentTab = 'Blood';
        tsf.next();
        
        
        
        bloodSpecimen.Status__c = 'Approval Not Required'; 
        update bloodSpecimen;
        tsf.signAndSubmit();
        
       // tsf.viewXML();
        tsf.redirect();
        
        
        
        //tsf.previous();
        tsf.resendCode();
        //tsf.customCancel();
      }
    }
  }
  
    @isTest static void test3() { 
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){
         Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = acc.Id;
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        BloodSpecimenForm__c bloodSpecimen = new BloodSpecimenForm__c(); 
        bloodSpecimen.TrialPatient__c = tp.Id;
        bloodSpecimen.CollectionDate__c = system.today();
        bloodSpecimen.Time_Point__c = 'Early Treatment'; 
        bloodSpecimen.Status__c = 'Completed';
        insert bloodSpecimen;
        
        BloodSpecimenInfo__c serumSample = new BloodSpecimenInfo__c();
        serumSample.BloodSpecimenForm__c = bloodSpecimen.Id;
        serumSample.Name = 'Serum Specimen #';
        insert serumSample;
        
        BloodSpecimenInfo__c plasmaSample = new BloodSpecimenInfo__c();
        plasmaSample.BloodSpecimenForm__c = bloodSpecimen.Id;
        plasmaSample.Name = 'Plasma Specimen #';
        insert plasmaSample;
        
        BloodSpecimenInfo__c buffySample = new BloodSpecimenInfo__c();
        buffySample.BloodSpecimenForm__c = bloodSpecimen.Id;
        buffySample.Name = 'Buffy coat specimen #';
        insert buffySample;
        
        bloodSpecimen.Status__c = 'Approval Not Required';
        update bloodSpecimen;
         
        bloodSpecimen.Status__c = 'Completed';
        bloodSpecimen.Time_Point__c = 'Inter-Regimen';
        update bloodSpecimen; 
        
        bloodSpecimen.Status__c = 'Approval Not Required';
        update bloodSpecimen;
        
        bloodSpecimen.Status__c = 'Completed';
        bloodSpecimen.Time_Point__c = 'Pre-Surgery';
        update bloodSpecimen;
        
        bloodSpecimen.Status__c = 'Approval Not Required'; 
        update bloodSpecimen;
        
        BloodSpecimenForm__c bloodSpecimen1 = new BloodSpecimenForm__c();
        bloodSpecimen1.TrialPatient__c = tp.Id;
        bloodSpecimen1.CollectionDate__c = system.today();
        bloodSpecimen1.Time_Point__c = 'Pre-Surgery';
        
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);
        Apexpages.StandardController std = new Apexpages.StandardController(bloodSpecimen1);
        BloodSpecimenController tsf = new BloodSpecimenController(std);
        tsf.bloodSpecimen = bloodSpecimen1;
      
        
        Apexpages.currentPage().getParameters().put('nextTab','CompleteTab');
        tsf.nextTabName = 'CompleteTab';
       
        
         tsf.viewXML();
       
       
       
       
       
       
        p.Race__c = 'Black or African American';
          update p;
           tsf.viewXML();
            p.Race__c = 'American Indian or Alaska Native';
          update p;
           tsf.viewXML();
            p.Race__c = 'Asian';
          update p;
           tsf.viewXML();
            p.Race__c = 'Native Hawaiian or Pacific Islander';
          update p;
           tsf.viewXML();
           p.Race__c = 'N/A';
          update p;
           tsf.viewXML();
           
            p.Ethnicity__c = 'Not Hispanic or Latino';
            update p;
           tsf.viewXML();
           p.Ethnicity__c = 'N/A';
            update p;
           tsf.viewXML();
        }
        
     } 
     }  
  @isTest private static  void test4() {
              List<User> thisUser = [ select u.Id , u.IsActive from User u where IsActive = true and id =: userinfo.getUserId()];
        System.runAs (thisUser[0]){
         Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.First_Name__c = 'test';
        p.Last_Name__c = 'kumar';
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = acc.Id;
        p.Race__c = 'White';
        p.Ethnicity__c = 'Not Hispanic or Latino';
        insert p;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.FirstName__c = 'a';
        tp.LastName__c = 'b';
        insert tp;
        
        BloodSpecimenForm__c bloodSpecimen = new BloodSpecimenForm__c(); 
        bloodSpecimen.TrialPatient__c = tp.Id;
        bloodSpecimen.CollectionDate__c = system.today();
        bloodSpecimen.Time_Point__c = 'Early Treatment'; 
        bloodSpecimen.Status__c = 'Completed';
        insert bloodSpecimen;
        
        BloodSpecimenInfo__c serumSample = new BloodSpecimenInfo__c();
        serumSample.BloodSpecimenForm__c = bloodSpecimen.Id;
        serumSample.Name = 'Serum Specimen #';
        insert serumSample;
        
        BloodSpecimenInfo__c plasmaSample = new BloodSpecimenInfo__c();
        plasmaSample.BloodSpecimenForm__c = bloodSpecimen.Id;
        plasmaSample.Name = 'Plasma Specimen #';
        insert plasmaSample;
        
        BloodSpecimenInfo__c buffySample = new BloodSpecimenInfo__c();
        buffySample.BloodSpecimenForm__c = bloodSpecimen.Id;
        buffySample.Name = 'Buffy coat specimen #';
        insert buffySample;
        
        bloodSpecimen.Status__c = 'Approval Not Required';
        update bloodSpecimen;
         
        bloodSpecimen.Status__c = 'Completed';
        bloodSpecimen.Time_Point__c = 'Inter-Regimen';
        update bloodSpecimen; 
        
        bloodSpecimen.Status__c = 'Approval Not Required';
        update bloodSpecimen;
        
        bloodSpecimen.Status__c = 'Completed';
        bloodSpecimen.Time_Point__c = 'Pre-Surgery';
        update bloodSpecimen;
        
        bloodSpecimen.Status__c = 'Approval Not Required'; 
        update bloodSpecimen;
        //tsf.submitBloodSpecimen(bloodSpecimen.Id,tp.Id,p.Id);
         
        BloodSpecimenForm__c bloodSpecimen1 = new BloodSpecimenForm__c();
        bloodSpecimen1.TrialPatient__c = tp.Id;
        bloodSpecimen1.CollectionDate__c = system.today();
        bloodSpecimen1.Time_Point__c = 'Pre-Surgery';
        
        Apexpages.currentPage().getParameters().put('trialPat', tp.Id);
        Apexpages.StandardController std = new Apexpages.StandardController(bloodSpecimen1);
        BloodSpecimenController tsf = new BloodSpecimenController(std);
        tsf.bloodSpecimen = bloodSpecimen1;
      
        
        Apexpages.currentPage().getParameters().put('nextTab','CompleteTab');
        tsf.nextTabName = 'CompleteTab';
      
       
            }
       }
      }
}