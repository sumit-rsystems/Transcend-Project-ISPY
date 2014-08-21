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
private class TestRandomizationXMLBuilder {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
        Account acc1 = new Account();

        List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution']; 
            
        if(!lstAccount.isEmpty()){
                
        acc1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
        
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = acc1.Id;
        insert site1;
        
        Trial__c trial1 = new Trial__c();
        trial1.Name='test Trial 1';
        insert trial1; 
        
        Patient_Custom__c pc = new Patient_Custom__c();
        pc.First_Name__c = 'test';
        pc.Last_Name__c = 'test';
        pc.Gender__c = 'Male';
        pc.Birthdate__c = date.newInstance(1999, 8, 8);
        pc.Race__c = 'White';
        pc.Ethnicity__c = 'Not Hispanic or Latino';
        pc.Institution__c = acc1.Id;
        pc.Medical_Record_Number__c = '3434';
        insert pc;
        
        TrialPatient__c tp1 = new TrialPatient__c();
        tp1.Trial_Id__c = trial1.Id;
        tp1.Patient_Id__c = pc.Id;
        insert tp1; 
        
        Registration__c reg1 = new Registration__c();
        reg1.Patient__c = pc.Id;
        reg1.Registration_Date__c = system.today();
        reg1.Trial__c = trial1.Id;
        reg1.Institution__c = acc1.Id;
        reg1.Site__c = site1.Id;
        reg1.IRB_Approval_Date__c = date.newInstance(2008, 7, 7); //regist
        reg1.Screening_Informed_Consent_Date__c = date.newInstance(2009, 7, 7);
        reg1.HIPPA_Consent_Date__c = date.newInstance(2011, 7, 7);
        reg1.Effective_Time__c = system.now();
        reg1.ISPY2_Subject_Id__c = ''+123;
        insert reg1;
        
        //Randomization_Form__c rfc = new Randomization_Form__c();
        //rfc.TrialPatient__c = tp1.Id;
        //rfc.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible for the study';
        //insert rfc;
        
        TrialPatient__c tp = [Select Id from TrialPatient__c where Patient_Id__c = :pc.Id];
        
        RandomizePatient.RandomizationEligibilityData randEleData = new RandomizePatient.RandomizationEligibilityData();
        List<RandomizePatient.CRFStatusWrapper> lstCRFStatusWrapper = new List<RandomizePatient.CRFStatusWrapper>();
        randEleData.crfStatusList = lstCRFStatusWrapper;
        
        RandomizePatient.CRFStatusWrapper crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'MRI Volume Form';
        crfStatusWrapper.IsSubmitted = 'Yes';
        crfStatusWrapper.IsApproved = 'Yes';
        lstCRFStatusWrapper.add(crfStatusWrapper);
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'On Study Pathology Form';
        crfStatusWrapper.IsSubmitted = 'Yes';
        crfStatusWrapper.IsApproved = 'Yes';
        randEleData.ICH_HER2_Status = 'Positive';
        randEleData.FISH_HER2_Status = 'Positive';
        randEleData.erStatus = 'Positive';
        randEleData.prStatus = 'Positive';
        lstCRFStatusWrapper.add(crfStatusWrapper);
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'On Study Eligibility Form';
        crfStatusWrapper.IsSubmitted = 'Yes';
        crfStatusWrapper.IsApproved = 'No';
        randEleData.isAllOSECheckboxesChecked = true;
        lstCRFStatusWrapper.add(crfStatusWrapper);
        crfStatusWrapper = new RandomizePatient.CRFStatusWrapper();
        crfStatusWrapper.CRFType = 'MammaPrint Form';
        crfStatusWrapper.IsSubmitted = 'Yes';
        crfStatusWrapper.IsApproved = 'Approval Not Required';
        randEleData.MammaPrintRisk = '2';
        randEleData.targetPrintHer2Status = 'Negative';
        lstCRFStatusWrapper.add(crfStatusWrapper);
        
        RandomizationXMLBuilder rb = new RandomizationXMLBuilder();
        rb.randomizePatient(randEleData, tp.Id, false, false,'abc');
        
        //RandomizationXMLBuilder rXMLb = new RandomizationXMLBuilder();
        //rXMLb.executeUpdatePatient();
            }
        }
    }
    
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            
            Account acc1 = new Account();
    
            List<Account> lstAccount = [select Id from Account where RecordType.Name = 'Institution']; 
                
            if(!lstAccount.isEmpty()){
                        
                acc1 = lstAccount[0];           // newly added logic to overcome the error of "setup and nonsetup" object
                
                Site__c site1 = new Site__c();
                site1.Name = 'test site1';
                site1.Type__c = 'test type';
                site1.Institute__c = acc1.Id;
                insert site1;
                
                Trial__c trial1 = new Trial__c();
                trial1.Name='test Trial 1';
                insert trial1; 
                
                Patient_Custom__c pc = new Patient_Custom__c();
                pc.First_Name__c = 'test';
                pc.Last_Name__c = 'test';
                pc.Gender__c = 'Male';
                pc.Birthdate__c = date.newInstance(1999, 8, 8);
                pc.Race__c = 'White';
                pc.Ethnicity__c = 'Not Hispanic or Latino';
                pc.Institution__c = acc1.Id;
                pc.Medical_Record_Number__c = '3434';
                insert pc;
                
                TrialPatient__c tp1 = new TrialPatient__c();
                tp1.Trial_Id__c = trial1.Id;
                tp1.Patient_Id__c = pc.Id;
                insert tp1; 
                
                Registration__c reg1 = new Registration__c();
                reg1.Patient__c = pc.Id;
                reg1.Registration_Date__c = system.today();
                reg1.Trial__c = trial1.Id;
               // reg1.MRN__c = '3535';
                reg1.TrialPatient__c = tp1.Id;
                reg1.Institution__c = acc1.Id;
                reg1.Site__c = site1.Id;
                reg1.IRB_Approval_Date__c = date.newInstance(2008, 7, 7); //regist
                reg1.Screening_Informed_Consent_Date__c = date.newInstance(2009, 7, 7);
                reg1.HIPPA_Consent_Date__c = date.newInstance(2011, 7, 7);
                reg1.Effective_Time__c = system.now();
                reg1.ISPY2_Subject_Id__c = ''+123;
                //reg1.ACRIN_6693_MRS_Participant__c = 'Yes';
                insert reg1;
                
                Randomization_Form__c rfc = new Randomization_Form__c();
                rfc.TrialPatient__c = tp1.Id;
                rfc.Why_Patient_Not_Signed_Consent_Form__c = 'Patient found to be ineligible for the study';
                insert rfc;
                
                Post_Surgaory_Summary__c pss = new Post_Surgaory_Summary__c();
                pss.Date_Of_Procedure__c = system.today();
                pss.pcr__c = true;
                pss.TrialPatient__c = tp1.Id;
                insert pss;
                
                MRI_Volume__c mri1 = new MRI_Volume__c();
                mri1.Time_Point__c = 'Pre-Treatment';
                mri1.TrialPatient__c = tp1.Id;
                //mri1.ACRIN_ID__c = '1';
                mri1.MRI_Volume_in_cm3__c = 12.0;
                mri1.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
                mri1.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
                insert mri1;
                
                RandomizationXMLBuilder rXMLb = new RandomizationXMLBuilder();
                RandomizationXMLBuilder.updatePatientXML(new Set<String>{tp1.Id});
            }
        }
    }
}