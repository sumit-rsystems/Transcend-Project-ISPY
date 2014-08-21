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
private class TestInsertCRFOnMRIVolume {

     @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst1 = new Account();

        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
        
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];
                
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.First_Name__c = 'test';
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = inst1.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Name = 'test';
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = t.Id;
        insert tp;
        
        CRF__c crf = new CRF__c();
        crf.Patient__c = p.Id;
        crf.Status__c = 'Not Completed';
        insert crf;
        
        Code_Master__c snomedObject = new Code_Master__c();
        snomedObject.Variable_Description__c = 'test';
        snomedObject.IsReportColumn__c = true;
        snomedObject.Display_Order__c = 3.0;
        snomedObject.Name = 'MRIvol_T0';
        insert snomedObject;
        
        Snomed_Code__c snomed = new Snomed_Code__c();
        snomed.Code_Master__c = snomedObject.Id;
        snomed.snomed_Code_Name__c = 'LOINC_MRI_Vol_3';
        snomed.CRF__c = crf.Id;
        insert snomed;
        
        MRI_Volume__c mri = new MRI_Volume__c();
        mri.TrialPatient__c = tp.Id;
        mri.CRF__c = crf.Id;
        mri.Time_Point__c = 'Pre-Treatment';
        mri.MRI_Volume_in_cm3__c = 12.0;
        mri.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
        insert mri;
        update mri;
        
     /*   //=========================else if line 137====================================================
        
        Code_Master__c snomedObject3 = new Code_Master__c();
        snomedObject3.Variable_Description__c = 'test';
        snomedObject3.IsReportColumn__c = true;
        snomedObject3.Display_Order__c = 3.0;
        snomedObject3.Name = 'MRIvol_T3';
        insert snomedObject3;
        
        Snomed_Code__c snomed1 = new Snomed_Code__c();
        snomed1.Code_Master__c = snomedObject.Id;
        snomed1.snomed_Code_Name__c = 'MRIvol_T3';
        snomed1.CRF__c = crf.Id;
        insert snomed1;
        
        MRI_Volume__c mri3 = new MRI_Volume__c();
        mri3.TrialPatient__c = tp.Id;
        mri3.CRF__c = crf.Id;
        mri3.Time_Point__c = 'Pre-Surgery';
        mri3.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri3.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
        mri3.MRI_Volume_in_cm3__c = 12.0;
        insert mri3;
        update mri3; */
            }
        }
    }
    
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst1 = new Account();

        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
        
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];
                
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.First_Name__c = 'test';
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = inst1.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Name = 'test';
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = t.Id;
        insert tp;
        
        CRF__c crf = new CRF__c();
        crf.Patient__c = p.Id;
        crf.Status__c = 'Not Completed';
        insert crf;
        
        //===========================else if line 119================================================
        
        Code_Master__c snomedObject1 = new Code_Master__c();
        snomedObject1.Variable_Description__c = 'test';
        snomedObject1.IsReportColumn__c = true;
        snomedObject1.Display_Order__c = 3.0;
        snomedObject1.Name = 'MRIvol_T1';
        insert snomedObject1;
        
        MRI_Volume__c mri1 = new MRI_Volume__c();
        mri1.TrialPatient__c = tp.Id;
        mri1.CRF__c = crf.Id;
        mri1.Time_Point__c = 'Early Treatment';
        mri1.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri1.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
        mri1.MRI_Volume_in_cm3__c = 12.0;
        insert mri1;
        update mri1;
        
            }
        }
    }
    
    @isTest static void myUnitTest3() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account inst1 = new Account();

        List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
        
        if(!lstAccount.isEmpty()){
                
        inst1 = lstAccount[0];
                
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = inst1.Id;
        insert site1;
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Ethnicity__c = 'Hispanic or latino';
        p.Gender__c = 'female';
        p.Race__c = 'asian;indian';
        p.Last_Name__c = 'kumar';
        p.Status__c = 'approval not required';
        p.First_Name__c = 'test';
        p.Birthdate__c = date.newInstance(1980, 08, 05);
        p.Institution__c = inst1.Id;
        insert p;
        
        Trial__c t = new Trial__c();
        t.Name = 'test';
        insert t;
        
        TrialPatient__c tp = new TrialPatient__c();
        tp.Patient_Id__c = p.Id;
        tp.Trial_Id__c = t.Id;
        insert tp;
        
        CRF__c crf = new CRF__c();
        crf.Patient__c = p.Id;
        crf.Status__c = 'Not Completed';
        insert crf;
        
        //=========================else if line 128====================================================
        
        Code_Master__c snomedObject2 = new Code_Master__c();
        snomedObject2.Variable_Description__c = 'test';
        snomedObject2.IsReportColumn__c = true;
        snomedObject2.Display_Order__c = 3.0;
        snomedObject2.Name = 'MRIvol_T2';
        insert snomedObject2;
        
        MRI_Volume__c mri2 = new MRI_Volume__c();
        mri2.TrialPatient__c = tp.Id;
        mri2.CRF__c = crf.Id;
        mri2.Time_Point__c = 'Inter-Regimen';
        mri2.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri2.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
        mri2.MRI_Volume_in_cm3__c = 12.0;
        insert mri2;
        update mri2;
        
            }
        }
    }
}