public with sharing class ViewFailedRegistrationDetailsController {

    public Failed_Registration__c fr { get; set; }
    
    public ViewFailedRegistrationDetailsController(){
        String frId = Apexpages.currentPage().getParameters().get('Id');
        List<Failed_Registration__c > frList = [Select f.Trial__c, f.System_Name__c, f.Study_Id__c, f.Site__c, f.Retry__c, f.Patient__c, f.Number_of_Retry__c, f.Name, f.MRN__c, f.Last_Success_Message__c, f.Last_Status__c, f.Last_Run_DateTime__c, f.Last_Error_Message__c, f.Id, f.Error_Code__c, f.CreatedDate,f.CreatedBy.Name, f.CreatedById, f.CRF_Name__c,f.ReturnId__c From Failed_Registration__c f where f.Id=:frId];
        
        if(frList.size()>0 )
        {
            fr = frList[0];
        }else
        {
            fr = new Failed_Registration__c(); 
        }
    }
    
    @isTest public static void myTest1(){
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='Asian',Gender__c='Male',Ethnicity__c='Hispanic or Latino');
        insert p;
        Failed_Registration__c fr = new Failed_Registration__c(Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        ApexPages.currentPage().getParameters().put('id',fr.id);
        ViewFailedRegistrationDetailsController frd = new ViewFailedRegistrationDetailsController();
    }
    
    @isTest public static void myTest2(){        
        ApexPages.currentPage().getParameters().put('id','100');
        ViewFailedRegistrationDetailsController frd = new ViewFailedRegistrationDetailsController();
    }
}