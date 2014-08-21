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
private class TestIrradiatedSiteTrigger {

    @isTest static void myUnitTest() {
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
            Account acc = new Account();
            List<Account> lstAccount = [select Id from Account limit 1];
            if(!lstAccount.isEmpty()) {
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
                
                CRF__c crf = new CRF__c();
                crf.Patient__c = p.Id;
                insert crf;
            
                Followup_Form__c ff1=new Followup_Form__c();
                ff1.TrialPatient__c = tp.Id;
                insert ff1;
                
                Irradiated_Site__c thRec1 = new Irradiated_Site__c();
                thRec1.Followup_Form__c = ff1.Id;
                thRec1.Site__c = 'Boost';
                thRec1.Total_dose_cGy_AP__c = 2.0;
                insert thRec1;
                
                thRec1.Site__c = 'Boost';
                update thRec1;
            }
        }
            
    }
    
    @isTest static void myUnitTest2() {
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
            Account acc = new Account();
            List<Account> lstAccount = [select Id from Account limit 1];
            if(!lstAccount.isEmpty()) {
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
                
                CRF__c crf = new CRF__c();
                crf.Patient__c = p.Id;
                insert crf;
            
                Followup_Form__c ff1=new Followup_Form__c();
                ff1.TrialPatient__c = tp.Id;
                insert ff1;
                
                Irradiated_Site__c thRec2 = new Irradiated_Site__c();
                thRec2.Followup_Form__c = ff1.Id;
                thRec2.Site__c = 'Axilla';
                thRec2.Total_dose_cGy_AP__c = 2.0;
                insert thRec2;
                
                thRec2.Site__c = 'Axilla';
                update thRec2;
            }
        }
            
    }
    
    @isTest static void myUnitTest3() {
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
            Account acc = new Account();
            List<Account> lstAccount = [select Id from Account limit 1];
            if(!lstAccount.isEmpty()) {
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
                
                CRF__c crf = new CRF__c();
                crf.Patient__c = p.Id;
                insert crf;
            
                Followup_Form__c ff1=new Followup_Form__c();
                ff1.TrialPatient__c = tp.Id;
                insert ff1;
                
                Irradiated_Site__c thRec3 = new Irradiated_Site__c();
                thRec3.Followup_Form__c = ff1.Id;
                thRec3.Site__c = 'Supraclavicular node';
                thRec3.Total_dose_cGy_AP__c = 2.0;
                insert thRec3;
                
                thRec3.Site__c = 'Supraclavicular node';
                update thRec3;
            }
        }
            
    }
    
    @isTest static void myUnitTest4() {
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
            Account acc = new Account();
            List<Account> lstAccount = [select Id from Account limit 1];
            if(!lstAccount.isEmpty()) {
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
                
                CRF__c crf = new CRF__c();
                crf.Patient__c = p.Id;
                insert crf;
            
                Followup_Form__c ff1=new Followup_Form__c();
                ff1.TrialPatient__c = tp.Id;
                insert ff1;
                
                Irradiated_Site__c thRec4 = new Irradiated_Site__c();
                thRec4.Followup_Form__c = ff1.Id;
                thRec4.Site__c = 'Internal mammary node';
                thRec4.Total_dose_cGy_AP__c = 2.0;
                insert thRec4;
                
                thRec4.Site__c = 'Internal mammary node';
                update thRec4;
            }
        }
            
    }
    
    @isTest static void myUnitTest5() {
        Profile SiteProp = [ Select p.UserType, p.Name, (Select u.IsActive, u.Id, SecurityCode__c From Users u where IsActive = true) From Profile p where Name = 'Site User'];
        List<User> lstSiteUser = SiteProp.Users;     
        System.runAs ( lstSiteUser[0] ) { 
        
            Account acc = new Account();
            List<Account> lstAccount = [select Id from Account limit 1];
            if(!lstAccount.isEmpty()) {
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
                
                CRF__c crf = new CRF__c();
                crf.Patient__c = p.Id;
                insert crf;
            
                Followup_Form__c ff1=new Followup_Form__c();
                ff1.TrialPatient__c = tp.Id;
                insert ff1;
                
                Irradiated_Site__c thRec5 = new Irradiated_Site__c();
                thRec5.Followup_Form__c = ff1.Id;
                thRec5.Site__c = 'Internal mammary node';
                thRec5.Total_dose_cGy_AP__c = 2.0;
                insert thRec5;
                
                thRec5.Site__c = 'IHTSDO_4585';
                update thRec5;
            }
        }
            
    }
}