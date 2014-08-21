@isTest
global class TestChart{
   
   public static testMethod void TestChart(){
         Widget__c widget=new  Widget__c();
         widget.query__c = 'select name , NumberOfEmployees from account where  NumberOfEmployees != null ';
         widget.query_type__c ='normal';
         widget.Type__c='Bar';
         widget.Size__c='Small';
         widget.Data_Limit__c = 5;
         widget.Chart_Fields__c=('name,NumberOfEmployees');
         Chart chart = new Chart( new BarChart());
         chart.widget = widget;
         chart.getChartData();
       }
}