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
private class TestMRIVolumeController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
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
        
        MRI_Volume__c mri = new MRI_Volume__c();
        mri.TrialPatient__c = tp.Id;
        mri.Time_Point__c = 'Pre-Treatment';
        mri.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri.MRI_Volume_in_cm3__c = 2.3;
        mri.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
        mri.Status__c = 'Approval Pending';
        insert mri;    
        mri.Status__c = 'Accepted';
        update mri; 
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        ApexPages.StandardController con = new ApexPages.StandardController(mri);
        MRIVolumeController mrivolume = new MRIVolumeController(con);
        mrivolume.saveCrf();
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        Apexpages.currentPage().getParameters().put('mriId',mri.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(mri);
        MRIVolumeController mrivol = new MRIVolumeController(controller);
        mrivol.mriObj = mri;
        
        Apexpages.currentPage().getParameters().put('nextTab','saveAndClose');
        mrivol.nextTabName = 'saveAndClose';
        mrivol.next();
        
        Apexpages.currentPage().getParameters().put('prevTab','CompleteTab');
        mrivol.previous();
        
        mrivol.cloneCRF();
        
        mrivol.saveCrf();
      }
    }
  }
  @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
        System.runAs ( lstSiteUser[0] ) { 
        
        Account acc = new Account();
        
        List<Account> lstAccount = [Select a.Id From Account a limit 1];
        
        if(!lstAccount.isEmpty()){
            
        acc = lstAccount[0];
        
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
        
        MRI_Volume__c mri = new MRI_Volume__c();
        mri.TrialPatient__c = tp.Id;
        mri.Time_Point__c = 'Pre-Treatment';
        mri.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
        mri.MRI_Volume_in_cm3__c = 2.3;
        mri.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
        mri.Status__c = 'Accepted';
        insert mri;    
        update mri; 
        
        Apexpages.currentPage().getParameters().put('trialPat',tp.Id);
        ApexPages.StandardController con = new ApexPages.StandardController(mri);
        MRIVolumeController mrivolume = new MRIVolumeController(con);
        mrivolume.saveCrf();
        Apexpages.currentPage().getParameters().put('mriId',mri.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(mri);
        MRIVolumeController mrivol = new MRIVolumeController(controller);
        
        Apexpages.currentPage().getParameters().put('id',mri.Id);
        mrivol.saveCrf();
        
        mrivol.resendCode();
        mrivol.editCRF();
        mrivol.signAndSubmit();
        mrivol.customCancel();
      }
    }
  }
}