public with sharing class ReviewRequestXMLController {
    String returnId =null;
    public ReviewRequestXMLController(){
         returnId = Apexpages.currentPage().getParameters().get('Id');
    }
   
    public String getXmlOutput() {
        String xml = null;
        
        cdapackage.CDAGeneratorPort iHub = new  cdapackage.CDAGeneratorPort();
        
        External_Connection_Settings__c iHubEndpoint = External_Connection_Settings__c.getInstance('iHub');
        if (iHubEndpoint !=null){
            ihub.endpoint_x=iHubEndpoint.URL__c;
            ihub.timeout_x=iHubEndpoint.Timeout__c.intValue();
        }
        else{
            ihub.endpoint_x = 'http://ec2-23-20-103-202.compute-1.amazonaws.com:8086/services/GetRequest';
            ihub.timeout_x = 120000;
        }
       
        try{
            if(!Test.isRunningTest()){
                xml = iHub.getRequest(returnId);
            }else{
                xml='<xml>myxml</xml>';
            }
            
        }catch(Exception e){
            xml = e.getMessage();
        }
        
        return xml;
    }
     @isTest public static void myTest1(){
        /*
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='Asian',Gender__c='Male',Ethnicity__c='Hispanic or Latino');
        insert p;
        Failed_Registration__c fr = new Failed_Registration__c(Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure');
        insert fr;
        */
        ApexPages.currentPage().getParameters().put('id','1212091288');
        ReviewRequestXMLController rr = new ReviewRequestXMLController();
        rr.getXmlOutput();
    }

}