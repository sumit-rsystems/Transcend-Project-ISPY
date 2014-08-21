@isTest
public class TestPieChart{
 public static testMethod void TestPieChart(){
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
     widget4.Type__c='Grid';
     widget4.Size__c='Small';
     widget4.Data_Limit__c = 5;
     widget4.Chart_Fields__c='name,NumberOfEmployees';
     widget4.Chart_Display_Fields__c='test,test1'; 
     insert widget4;
     
     Widget__c widget1=new  Widget__c();
     widget1.query__c = 'select name ,Count(AccountId) countaac from contact group by name';
     widget1.query_type__c ='Aggregate';
     widget1.Chart_Fields__c='name, countaac';
     widget1.Type__c='Grid';
     widget1.Size__c='Small';
     widget1.Chart_Fields__c='name,countaac';
     widget1.Chart_Display_Fields__c='test,test1'; 
     insert widget1;
     
     Widget__c widget2=new  Widget__c();
     widget2.query__c = 'select Account.name ,Account.NumberOfEmployees from contact';
     widget2.query_type__c ='Normal';
     widget2.Chart_Fields__c='Account.name,Account.NumberOfEmployees';
     widget2.Chart_Display_Fields__c='test,test1'; 
     insert widget2;
     
     PieChart pc=new PieChart();
     
     pc.getData(widget4);
     
     pc = new PieChart();
     pc.getData(widget1);
    
     pc.getData(widget2);
      
 }
}