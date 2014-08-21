@isTest
public class TestDashboardController{
   public static testMethod void TestDashboardController(){
   
    String strRecordTypeId = [Select Id From RecordType Where  Name = 'Site'].Id;
    List<Profile>  profiles = [SELECT Id, Name FROM Profile ];
    List<User> user = [SELECT Id, Name FROM User];
    
    Account acc = new Account(Name = 'Test acc');
    insert acc;
    
    Site__c site = new Site__c(Name = 'Test Site', recordtypeId = strRecordTypeId, Institute__c = acc.Id);
    insert site;
   
    Dashboard__c db = new  Dashboard__c(Name = 'Test dashboard');
    insert db;
    
    List<Widget__c> widget=new List<Widget__c>();
    widget.add(new Widget__c(name='testing',Site_Filter__c = 'Site__c' , query__c = 'select Site__r.Name SiteName, count(Subject_Id__c) PatientCount from TrialPatient__c group by Site__r.Name',query_type__c ='Normal',Type__c='Bar',Size__c='Small',Data_Limit__c = 5,Chart_Fields__c='name,NumberOfEmployees',Drill_Down_Field__c='test'));
    widget.add(new Widget__c(name='testing',Site_Filter__c = 'Site__c',query__c = 'select Site__r.Name, Subject_Id__c from TrialPatient__c where Site__c != null and Subject_Id__c != null',query_type__c ='Normal',Type__c='Pie',Size__c='Small',Data_Limit__c = 5,Chart_Fields__c='name,NumberOfEmployees',Drill_Down_Field__c='test'));
    widget.add(new Widget__c(name='testing',query__c = 'select Id, name , NumberOfEmployees from Account where  NumberOfEmployees != null ',query_type__c ='Normal',Type__c='Column',Size__c='Small',Data_Limit__c = 5,Chart_Fields__c='name,NumberOfEmployees',Drill_Down_Field__c='test'));
    widget.add(new Widget__c(name='testing',Site_Filter__c = 'Site__c', Data_Source__c = 'EligiblebutPendingRegistration',query_type__c ='Normal',Type__c='Grid',Size__c='Small',Data_Limit__c = 5,Chart_Fields__c='name,NumberOfEmployees',Drill_Down_Field__c='test'));
    widget.add(new Widget__c(name='testing',query__c = 'select Id, name , Count(NumberOfEmployees) from Account where  NumberOfEmployees != null group by Id,name',query_type__c ='Normal',Type__c='Grid',Size__c='Small',Data_Limit__c = 5,Chart_Fields__c='name,NumberOfEmployees',Drill_Down_Field__c='test'));
    insert widget;
    
    
    List<View__c> view=new List<View__c>();
    view.add(new View__c(name='test view'));
    view.add(new View__c(name='test view1'));
    view.add(new View__c(name='test view2'));
    insert view;
    
    
    List<Dashboard_View__c> dbView = new List<Dashboard_View__c>();
    dbView.add(new Dashboard_View__c(View__c = view[0].id, Dashboard__c = db.Id, Active__c = true, Sequence__c = 1));
    dbView.add(new Dashboard_View__c(View__c = view[1].id, Dashboard__c = db.Id, Active__c = true, Sequence__c = 2));
    dbView.add(new Dashboard_View__c(View__c = view[2].id, Dashboard__c = db.Id, Active__c = true, Sequence__c = 3));
    insert dbView;
    
    List<View_Widget__c> vw = new List<View_Widget__c>();
    vw.add(new View_Widget__c(Widget__c = widget[0].id, View__c=view[1].id, Sequence__c=123));
    insert vw;
    
    List<Profile_Right__c> profileRight = new List<Profile_Right__c>();
    profileRight.add(new Profile_Right__c(Profile_Id__c = ''+profiles[0].Id, Widget__c = widget[0].id));
    profileRight.add(new Profile_Right__c(Profile_Id__c = ''+profiles[1].Id, Widget__c = widget[1].id));
    profileRight.add(new Profile_Right__c(Profile_Id__c = ''+profiles[1].Id, Widget__c = widget[2].id));
    profileRight.add(new Profile_Right__c(Profile_Id__c = ''+profiles[1].Id, Widget__c = widget[3].id));
    insert profileRight;
    
     List<View_Widget__c> viewWidget= new List<View_Widget__c>();
     viewWidget.add(new View_Widget__c(Widget__c =widget[0].id, View__c=view[0].id, Sequence__c=1, Active__c=true));
     viewWidget.add(new View_Widget__c(Widget__c =widget[1].id, View__c=view[1].id, Sequence__c=1, Active__c=true));
     viewWidget.add(new View_Widget__c(Widget__c =widget[2].id, View__c=view[2].id, Sequence__c=1, Active__c=true));
     viewWidget.add(new View_Widget__c(Widget__c =widget[3].id, View__c=view[2].id, Sequence__c=1, Active__c=true));
     viewWidget.add(new View_Widget__c(Widget__c =widget[4].id, View__c=view[0].id, Sequence__c=1, Active__c=true));
     insert viewWidget;
     
     List<User_Settings__c> usersetting = new List<User_Settings__c>();
     usersetting .add(new User_Settings__c(User__c = user[0].Id, View__c = view[1].Id, Widget__c = widget[1].Id));
     usersetting .add(new User_Settings__c(User__c = user[0].Id, View__c = view[2].Id, Widget__c = widget[2].Id));
     usersetting .add(new User_Settings__c(User__c = user[0].Id, View__c = view[2].Id, Widget__c = widget[3].Id));
     usersetting .add(new User_Settings__c(User__c = user[0].Id, View__c = view[0].Id, Widget__c = widget[0].Id));
     insert usersetting;
     
     
     
    ApexPages.StandardController controller=new ApexPages.StandardController(db);
    DashboardController2 dc = new  DashboardController2(controller);
    //System.assert(false,dc.viewIds);
    dc.getData(widget[0]);
    dc.getChildWidget();
    dc.fortabelview = 'Yes';
    // dc.saveInSequence();
    dc.dBoardWrapper = new List<DashboardController2.DashBoardViewWrapper>();
    Dashboard_View__c dv  = new Dashboard_View__c();
    dv.View__c=view[0].id;
    dv.Dashboard__c=db.id;
    dv.Active__c=true;
    insert dv;
    DashboardController2.DashBoardViewWrapper  objdashBoardViewWrapper= new DashboardController2.DashBoardViewWrapper(null,null,1);
    DashboardController2.ViewWidgetWrapper  objViewWidgetWrapper= new DashboardController2.ViewWidgetWrapper(vw[0],'selva');
    List<DashboardController2.ViewWidgetWrapper> lstViewWidget = new List<DashboardController2.ViewWidgetWrapper>();
    lstViewWidget.add(objViewWidgetWrapper);
    dc.dBoardWrapper.add(new DashboardController2.DashBoardViewWrapper(dv,lstViewWidget,dc.dBoardWrapper.size()));
    dc.widgetId=vw[0].id;
    dc.loadData();
    //dc.loadWidgetsByUserSettings(usersetting,dc.viewIds);
    dc.widgetId = widget[3].Id;
     dc.loadFilter();
     dc.loadData();
     dc.widgetId = widget[0].Id;
     dc.siteId = '\''+site.Id+'\'';
     dc.value = site.Name;
    dc.getFilterWidget();
    dc.loadFilter();
    dc.widgetId = widget[0].Id;
    dc.loadData();
     dc.widgetId = widget[1].Id;
    dc.getFilterWidget();
    dc.loadData();
    
    DashboardController2.getUserSetting(''+viewWidget[0].id+','+viewWidget[1].id+','+viewWidget[2].id+','+viewWidget[3].id+','+viewWidget[4].id,''+viewWidget[0].id,''+viewWidget[0].id+'##1'+
    ','+viewWidget[2].id+'##2'+','+viewWidget[3].id+'##3'+','+viewWidget[4].id+'##4'+','+viewWidget[0].id+'##5'+','+viewWidget[2].id+'##6'+','+viewWidget[3].id+'##7'+','+viewWidget[4].id+'##8'+
    ','+viewWidget[3].id+'##9'+','+viewWidget[4].id+'##A'+','+viewWidget[0].id+'##B'+','+viewWidget[0].id+'##C');
        
   }
 /*     public static testMethod void TestDashboardController1(){
    Dashboard__c db = new  Dashboard__c();
    db.Name='test';
    insert db;
    Widget__c widget=new Widget__c();
    widget.name='testing';
    widget.query__c = 'select Id, name , NumberOfEmployees from Account where  NumberOfEmployees != null ';
    widget.query_type__c ='Normal';
    widget.Type__c='Bar';
    widget.Size__c='Small';
    widget.Data_Limit__c = 5;
    widget.Chart_Fields__c='name,NumberOfEmployees';
    widget.Drill_Down_Field__c='test';
    insert widget;
    View__c v=new View__c();
    v.name='test';
    insert v;
    View_Widget__c vw=new View_Widget__c();
    vw.Widget__c =widget.id;
    vw.View__c=v.id;
    vw.Sequence__c=123;
    vw.Active__c=true;
    insert vw;
    List<View_Widget__c> listviewWidget= new List<View_Widget__c>();
    listviewWidget.add(vw);
    ApexPages.StandardController controller=new ApexPages.StandardController(db);
    DashboardController2 dc=new  DashboardController2(controller);
    User_Settings__c  usersettingobj= new User_Settings__c();
    usersettingobj.Widget__c=widget.id;
    usersettingobj.View__c=v.id;
    insert usersettingobj;
    List<User_Settings__c> usetlistsetting=    new List<User_Settings__c>();
    usetlistsetting.add(usersettingobj);
   // dc.loadWidgetsByUserSettings(usetlistsetting);
    dc.setInstitute();
    dc.setSite();
    dc.setTrial();
    dc.loadchartProfileFilter();
    DashboardController2.DashBoardViewWrapper  objdashBoardViewWrapper= new DashboardController2.DashBoardViewWrapper(null,null,1);
    DashboardController2.ViewWidgetWrapper  objViewWidgetWrapper= new DashboardController2.ViewWidgetWrapper(vw,'selva');
    dc.getFilterWidget();
    
    dc.dBoardWrapper = new List<DashboardController2.DashBoardViewWrapper>();
    Dashboard_View__c dv  = new Dashboard_View__c();
    dv.View__c=v.id;
    dv.Dashboard__c=db.id;
    dv.Active__c=true;
    insert dv;
    DashboardController2.DashBoardViewWrapper  objdashBoardViewWrapper1= new DashboardController2.DashBoardViewWrapper(null,null,1);
    DashboardController2.ViewWidgetWrapper  objViewWidgetWrapper1= new DashboardController2.ViewWidgetWrapper(vw,'selva');
    List<DashboardController2.ViewWidgetWrapper> lstViewWidget = new List<DashboardController2.ViewWidgetWrapper>();
    lstViewWidget.add(objViewWidgetWrapper);
    dc.dBoardWrapper.add(new DashboardController2.DashBoardViewWrapper(dv,lstViewWidget,dc.dBoardWrapper.size()));
    dc.widgetId=vw.id;
    
    dc.loadFilter();

        
   } */
   
   
   
   
   
}