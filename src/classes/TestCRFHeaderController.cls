@isTest
public class TestCRFHeaderController{
 public static testMethod void TestCRFHeaderController(){
     Account acc  = new Account(Name = 'Test Intstitute');
     insert acc;
     Date myDate = 
        date.newinstance(1960, 2, 17);
     Patient_Custom__c  p = new Patient_Custom__c( Ethnicity__c='Hispanic or Latino',Race__c = 'American Indian or Alaska Native',Birthdate__c = myDate ,Institution__c = acc.Id, First_Name__c ='T', Middle_Name__c = 'es' , Last_Name__c  = 't',Name = 'TestP',Institute_Text__c = 'test Institute');
     insert p;
    CRFHeaderController chc=new CRFHeaderController();
    chc.patientId = p.id;
    chc.patientInitials = p.Initials__c;
    chc.patientInstitute = p.Institute_Text__c ;
    chc.shortName = 'Testi';
    chc.getPatientSubjectId();
 }
}