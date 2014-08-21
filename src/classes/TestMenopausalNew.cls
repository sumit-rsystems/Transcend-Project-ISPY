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
private class TestMenopausalNew {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
            List<User> lstSiteUser = [Select u.IsActive, u.Id, SecurityCode__c From User u where IsActive = true and Profile.Name = 'Site User'];     
            System.runAs ( lstSiteUser[0] ) { 
            
            Account acc = new Account();
            
            List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
            if(!lstAccount.isEmpty()){
                
            acc = lstAccount[0];
        
            Patient_Custom__c pat = new Patient_Custom__c();
            pat.Race__c = 'Asian';
            pat.First_Name__c = 'test3';
            pat.Last_Name__c = 'Test';
            pat.Gender__c = 'Female';
            pat.Ethnicity__c = 'Not Hispanic or Latino';
            pat.Birthdate__c = date.newInstance(2000, 7, 7);  // this satisfy 'if' part , age<50
            pat.Institution__c = acc.Id;
            insert pat;
            
            Trial__c tr = new Trial__c();
            tr.Name = 'test trial new';
            insert tr;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = pat.Id;
            tp.Trial_Id__c = tr.Id;
            insert tp;
            
            Menopausal_Status_Detail__c m = new Menopausal_Status_Detail__c();
            m.Patient__c = pat.Id;
            m.TrialPatient__c = tp.Id;
            m.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
            insert m;
            
            
            Apexpages.standardcontroller msd = new Apexpages.standardcontroller(m);
            MenopausalNew meno = new MenopausalNew(msd);
            
            meno.CustomeNew(); // else part 
            Apexpages.currentPage().getParameters().put('CF00Nc0000000GqXy_lkid',tp.Id); // this satisfy 'if' part , age<50
            meno.CustomeNew();
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
            
            Patient_Custom__c pat = new Patient_Custom__c();
            pat.Race__c = 'Asian';
            pat.Institution__c = acc.Id;
            pat.First_Name__c = 'test3';
            pat.Last_Name__c = 'Test';
            pat.Gender__c = 'Female';
            pat.Ethnicity__c = 'Not Hispanic or Latino';
            pat.Birthdate__c = date.newInstance(1950, 7, 7); // this satisfy 'else' part , age>50
            insert pat;
            
            Trial__c tr = new Trial__c();
            tr.Name = 'test trial new';
            insert tr;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = pat.Id;
            tp.Trial_Id__c = tr.Id;
            insert tp;
            
            Menopausal_Status_Detail__c m = new Menopausal_Status_Detail__c();
            m.Patient__c = pat.Id;
            m.TrialPatient__c = tp.Id;
            m.Menopausal_Status__c = 'Above categories not applicable AND Age < 50';
            insert m;
            
            Apexpages.standardcontroller msd = new Apexpages.standardcontroller(m);
            MenopausalNew meno = new MenopausalNew(msd);
            Apexpages.currentPage().getParameters().put('CF00Nc0000000GqXy_lkid',tp.Id); //this satisfy 'else' part , age>50
            meno.CustomeNew(); 
            }
        }
    }
}