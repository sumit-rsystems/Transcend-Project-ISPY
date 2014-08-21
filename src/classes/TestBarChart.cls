@isTest
public class TestBarChart {
  public static testMethod void TestBarChart(){
      
      List<Account> ac = new List<Account>();
      
      for (integer i = 1 ; i < 5 ; i ++ ) {
          ac.add(new Account(name = 'test'+i ,NumberOfEmployees = 10*i,AnnualRevenue = 200 * i));
      }
      
      insert ac;
      Site__c st = new Site__c();
      st.Institute__c = ac[0].Id;
      st.Name = 'Test';
      insert st;
      
      List<Contact> contacts = new List<Contact>();
      
      for (integer i = 1 ; i < ac.size() ; i ++ ) {
          contacts.add(new Contact(lastname = 'test'+i , AccountId= ac[i-1].id, site__c=st.id));
      }
      insert contacts;
      
     Widget__c widget4=new  Widget__c();
     widget4.query__c = 'select name , NumberOfEmployees from account where  NumberOfEmployees != null ';
     widget4.query_type__c ='Normal';
     widget4.Type__c='Bar';
     widget4.Size__c='Small';
     widget4.Data_Limit__c = 5;
     widget4.Chart_Fields__c='name,NumberOfEmployees';
     insert widget4;
     
     Widget__c widget1=new  Widget__c();
     widget1.query__c = 'select name ,Count(AccountId) countaac from contact group by name';
     widget1.query_type__c ='Aggregate';
     widget1.Chart_Fields__c='name, countaac';
     widget1.Type__c='Bar';
     widget1.Size__c='Small';
     insert widget1;
     
      
     Widget__c widget2=new  Widget__c();
     widget2.query__c = 'select Account.name ,Account.NumberOfEmployees from contact';
     widget2.query_type__c ='Normal';
     widget2.Chart_Fields__c='Account.name,Account.NumberOfEmployees';
     insert widget2;
     
     BarChart bc=new BarChart();
     
     bc.getData(widget4);
     
     bc = new BarChart();
     bc.getData(widget1);
    
     bc.getData(widget2);
      
    
     //System.assert(false,''+bc.getData(widget1) +''+bc.getData(widget));
    
  }
}