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
private class TestPatientAddController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account acc1 = new Account();

        List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
        if(!lstAccount.isEmpty()){
            
        acc1 = lstAccount[0];
                
        Site__c s1 = new Site__c();
        s1.Name = 'test site';
        s1.Institute__c = acc1.Id;
        insert s1;
        
        Contact con = new Contact();
        con.LastName = 'Test Con';
        con.AccountId = acc1.Id;
        con.Site__c = s1.Id; 
        con.Type__c = 'MD';
        insert con;
        
        Contact con1 = new Contact();
        con1.LastName = 'Test Con1';
        con1.AccountId = acc1.Id;
        con1.Site__c = s1.Id; 
        con1.Type__c = 'Surgeon';
        insert con1; 
        
        Patient_Custom__c patientObj = new Patient_Custom__c();
        patientObj.Birthdate__c = date.newInstance(2012, 8, 10);
        patientObj.Institution__c = acc1.Id;
        patientObj.Last_Name__c = 'test';
        patientObj.Gender__c = 'Male';
        patientObj.Race__c = 'White';
        patientObj.Ethnicity__c = 'Not Hispanic or Latino';
        insert patientObj;
        
        Patient_Custom__c patientObj1 = new Patient_Custom__c();
        patientObj1.Birthdate__c = date.newInstance(2012, 8, 10);
        patientObj1.Last_Name__c = 'test';
        patientObj1.Primary_MD__c = con.Id;
        patientObj1.Institution__c = acc1.Id;
        patientObj1.Surgeon__c = con1.Id;
        patientObj1.Gender__c = 'Male';
        patientObj1.Race__c = 'White';
        patientObj1.Ethnicity__c = 'Not Hispanic or Latino';
        
        Apexpages.StandardController std1 = new Apexpages.StandardController(patientObj);  //to satisfy else condition
        PatientAddController pac1 = new PatientAddController(std1);
       
        Apexpages.currentPage().getParameters().put('paramAtt','save'); //satisfy else part
        pac1.patientObj = patientObj1;
        pac1.redirectPage();
        
        Patient_Custom__c patientObj2 = new Patient_Custom__c();
        patientObj2.Birthdate__c = date.newInstance(2013, 8, 10);
        patientObj2.Last_Name__c = 'test';
        patientObj2.Primary_MD__c = con.Id;
        patientObj2.Surgeon__c = con1.Id;
        patientObj2.Institution__c = acc1.Id;
        patientObj2.Gender__c = 'Male';
        patientObj2.Race__c = 'White';
        patientObj2.Ethnicity__c = 'Not Hispanic or Latino';
                
        Apexpages.currentPage().getParameters().put('paramAtt','save'); //satisfy else part
        pac1.patientObj = patientObj2;
        pac1.redirectPage();
        
        Apexpages.currentPage().getParameters().put('paramAtt','cancel'); //satisfy else part
        pac1.redirectPage();
        
        Apexpages.currentPage().getParameters().put('pid',patientObj.Id); // satisfy if condition (put method is used before setting class-object , if its consturctor)
        Apexpages.currentPage().getParameters().put('lastname','test');
        Apexpages.StandardController std = new Apexpages.StandardController(patientObj); // satisfy if condition
        PatientAddController pac = new PatientAddController(std);
       
        pac.patientId = patientObj.Id;
       
        Apexpages.currentPage().getParameters().put('paramAtt','save'); //if part
        pac.redirectPage(); // after "save" , we are calling the method
        Apexpages.currentPage().getParameters().put('paramAtt','cancel'); //if part
        pac.redirectPage(); // after "cancel" , we are calling the method
        }
      }
    }
    @isTest static void myUnitTest1() {
        // TO DO: implement unit test
        
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
        
        Account acc1 = new Account();

        List<Account> lstAccount = [Select a.Id From Account a limit 1];
            
        if(!lstAccount.isEmpty()){
            
        acc1 = lstAccount[0];
        
        Arm__c ar = new Arm__c();
        insert ar;
        
        Site__c s1 = new Site__c();
        s1.Name = 'test site';
        s1.Institute__c = acc1.Id;
        insert s1;
        
        Contact con = new Contact();
        con.LastName = 'Test Con';
        con.AccountId = acc1.Id;
        con.Site__c = s1.Id; 
        con.Type__c = 'MD';
        insert con;
        
        Contact con1 = new Contact();
        con1.LastName = 'Test Con1';
        con1.AccountId = acc1.Id;
        con1.Site__c = s1.Id; 
        con1.Type__c = 'Surgeon';
        insert con1; 
        
        Patient_Custom__c patientObj = new Patient_Custom__c();
        patientObj.Birthdate__c = date.newInstance(2012, 8, 10);
        patientObj.Last_Name__c = 'test';
        patientObj.Gender__c = 'female';
        patientObj.Race__c = 'asian';
        patientObj.Ethnicity__c = 'Hispanic or latino';
        patientObj.Primary_MD__c = con.Id;
        patientObj.Surgeon__c = con1.Id;
        patientObj.Institution__c = acc1.Id;
        insert patientObj;
        
        Patient_Custom__c patientObj1 = new Patient_Custom__c();
        patientObj1.Birthdate__c = date.newInstance(2012, 8, 10);
        patientObj1.Last_Name__c = 'test';
        patientObj1.Gender__c = 'female';
        patientObj1.Race__c = 'asian';
        patientObj1.Ethnicity__c = 'Hispanic or latino';
        patientObj1.Primary_MD__c = con.Id;
        patientObj1.Surgeon__c = con1.Id;
        patientObj1.Institution__c = acc1.Id; 
        
        Apexpages.StandardController std1 = new Apexpages.StandardController(patientObj);  //to satisfy else condition
        PatientAddController pac1 = new PatientAddController(std1);
       
        Apexpages.currentPage().getParameters().put('paramAtt','save'); //satisfy else part
        pac1.patientObj = patientObj1;
        pac1.redirectPage();
        
        Contact c = new Contact(); // line 97 "if" cond
        c.LastName = 'Test Con';
        c.AccountId = acc1.Id;
        c.Site__c = s1.Id; 
        c.Type__c = 'Surgeon';
        insert c;
        
        Contact c1 = new Contact(); // line 97 "if" cond
        c1.LastName = 'Test Con';
        c1.AccountId = acc1.Id;
        c1.Site__c = s1.Id; 
        c1.Type__c = 'MD';
        insert c1;
        
        Apexpages.StandardController std2 = new Apexpages.StandardController(patientObj);  
        PatientAddController pac2 = new PatientAddController(std2);
        
        Apexpages.currentPage().getParameters().put('paramAtt','save'); 
        pac2.redirectPage();
        
        Patient_Custom__c p = new Patient_Custom__c();
        p.Birthdate__c = date.newInstance(2012, 8, 10);
        p.Last_Name__c = 'test';
        p.Gender__c = 'female';
        p.Race__c = 'asian';
        p.Ethnicity__c = 'Hispanic or latino';
        p.Primary_MD__c = c1.Id;
        p.Surgeon__c = c.Id; 
        p.Institution__c = acc1.Id;
        insert p;
        
        Contact c3 = new Contact(); // line 97 "if" cond
        c3.LastName = 'Test Con';
        c3.AccountId = acc1.Id;
        c3.Site__c = s1.Id; 
        c3.Type__c = 'Surgeon';
        insert c3;
        
        Contact c4 = new Contact(); // line 97 "if" cond
        c4.LastName = 'Test Con';
        c4.AccountId = acc1.Id;
        c4.Site__c = s1.Id; 
        c4.Type__c = 'MD';
        insert c4;
        
        Patient_Custom__c p1 = new Patient_Custom__c();
        p1.Birthdate__c = date.newInstance(2012, 8, 10);
        p1.Last_Name__c = 'test';
        p1.Gender__c = 'female';
        p1.Race__c = 'asian';
        p1.Ethnicity__c = 'Hispanic or latino';
        p1.Primary_MD__c = c4.Id; 
        p1.Surgeon__c = c3.Id; 
        p1.Institution__c = acc1.Id;
      //  insert p1;
        
        Apexpages.StandardController std3 = new Apexpages.StandardController(p);  
        PatientAddController pac3 = new PatientAddController(std3);
        
        Apexpages.currentPage().getParameters().put('paramAtt','save'); //satisfy else part
        pac3.patientObj = p1;
        pac3.selectedInstitution = acc1.Id;
        pac3.redirectPage();
        
        Apexpages.currentPage().getParameters().put('pid',p.Id);
        Apexpages.StandardController std4 = new Apexpages.StandardController(p);  
        PatientAddController pac4 = new PatientAddController(std4);
        pac4.patientObj = p;
        pac4.selectedInstitution = acc1.Id;
        pac4.redirectPage();
        }
     }
   }
}