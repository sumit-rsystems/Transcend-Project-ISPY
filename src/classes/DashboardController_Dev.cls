public with sharing class DashboardController_Dev{
    
    public string relatedId{get;set;}
    public string widgetId{get;set;}
    public string viewName{get;set;}
    
    public string fortabelview{get;set;}
    public string dashBoardId {get;set;}
    public String datal {get;set;}
    public Integer countWidget{get;set;}
    public String profileName{get;set;}
    public List<String> viewWidget{get;set;}
    public List<DashBoardViewWrapper> dBoardWrapper{get;set;}
    public List<User_Settings__c> UserSettings;
   
    public List<Selectoption> trialList{get;set;}
    public String trialId{get;set;}
    public List<Selectoption> siteList{get;set;}
    public String siteId{get;set;}
    public List<Selectoption> instituteList{get;set;}
    public String instituteId{get;set;}
    public Set<String> widgetIds;
     
    public String parentcolumnvalue{get;set;}
    public String parentwidgetid{get;set;}
    public List<Selectoption> childpicklist{get;set;}
    public List<Selectoption> filterpicklist{get;set;}
    
    public String fillterSelect{get;set;}
    
    public String ChildChartData{get;set;}
    public String ChildChartName{get;set;}
    public Map<String, List<String>> updatedWidgetsandView{get;set;}
    List<Profile> profiles;
    List<string> viewIds;
    Map<string ,List<View_Widget__c>>  mapViewWidgets;
    Map<Id,Widget__c> mapWidgets; 
    
  
    
   //**************** Constructor ********************//
    public DashboardController_dev(ApexPages.StandardController controller){
        try {
            fillterSelect = 'Yes';
            widgetId ='';
            relatedId= '';
            fortabelview='';
            countWidget=0;
            parentcolumnvalue = '';
            parentwidgetid = '';
            viewIds  = new List<String>();
            dashBoardId  = controller.getId();
            instituteList = new List<SelectOption>();
            viewWidget = new List<String>();
            
            if (dashBoardId != null) {
                profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
                profileName = profiles[0].Name;
                //********* Load Institute ************//
                instituteList.add(new SelectOption('','Select'));
                
                List<RecordType> rt = [SELECT name ,Id FROM RecordType where name = 'Institution' ];
                set<Id> instituteUserset = new set<Id>();
                for (InstitutionUser__c instituteUser : [select Institution__c from InstitutionUser__c where User__c =: Userinfo.getUserId()]) {
                    instituteUserset.add(instituteUser.Institution__c );
                }
                List<Account> institute= [select Id,Name from Account where id in : instituteUserset  Order By Name asc];
                for(Account ins : institute){
                    instituteList.add(new SelectOption(ins.Id,ins.Name)); 
                }
                
                //********* END Load Institute ************//
                
                
                dBoardWrapper = new List<DashBoardViewWrapper>();
                List<Dashboard_View__c> dashboardViews = [select id,name,View__r.name,View__r.id from  Dashboard_View__c 
                        where Dashboard__c = :dashBoardId and Active__c = true order by Sequence__c];
                viewIds = new List<string>(); 
                for (Dashboard_View__c dv : dashboardViews ) {
                    viewIds.add(dv.View__r.id);
                }
                mapViewWidgets =  new map<string ,List<View_Widget__c>>();
                widgetIds = new Set<String>();
                List<User_Settings__c> userSettings = [select Widget__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.query_type__c,
                Widget__r.parent__c,Widget__r.X3D_Chart__c,Widget__r.id,
                Widget__r.size__c  from User_Settings__c where User__c =: Userinfo.getUserId() and View__c in : viewIds 
                order by sequence__c];

                if (userSettings.size() > 0) {
                    loadWidgetsByUserSettings(userSettings);
                    
                }
                else {
                    for (View_Widget__c vw : [select Widget__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.Query__c , Widget__r.Data_Source__c,Widget__r.query_type__c,
                        Widget__r.parent__c,Widget__r.X3D_Chart__c,Widget__r.id, Widget__r.Stacked__c,Widget__r.Institute_Filter__c,Widget__r.Site_Filter__c,Widget__r.Trial_Filter__c,
                        Widget__r.size__c  from View_Widget__c where View__c in : viewIds 
                        and active__c = true order by sequence__c]) {

                        if (!mapViewWidgets.containskey(vw.View__r.id)) {
                        mapViewWidgets.put(vw.View__r.id, new List<View_Widget__c>());
                        }
                        mapViewWidgets.get(vw.View__r.id).add(vw);
                        widgetIds.add(vw.Widget__c);
                    }
                }
                Map<Id ,Set<Id>>  profileRight=  new map<Id ,Set<Id>>();
                List<Profile_Right__c> profileRightList = [Select Id,Name,Widget__c,Related_widget__c,Profile_Id__c From Profile_Right__c 
                where Widget__c in : widgetIds and Profile_Id__c != null];
                
                widgetIds = new Set<String>();
                String widgetId = '';
                set<String> removeId = new set<String>();
                integer recordCount = 0;
                if (profileName == 'DCC User') {
                    Set<String> trialIds = new Set<String>();
                    for (InstitutionUser__c insuser: [select id,trial__c from InstitutionUser__c where 
                    User__c =: Userinfo.getUserId() and trial__c != null]) {
                        trialIds.add(insuser.trial__c);
                    }
                    List<Site_Trial__c> siteTrials = [select site__c from Site_Trial__c where  trial__c in:trialIds];
                    recordCount  = siteTrials.size();
                }
                else if (profileName == 'Site User' || profileName  != 'System Adminstrator') {
                    recordCount  = [select id from InstitutionUser__c where User__c =: Userinfo.getUserId() and site__c != null].size();
                }
                for(Profile_Right__c pr : profileRightList){
                    if (profileName  != 'System Administrator') {
                            if (pr.Related_widget__c == null) {
                               
                            }
                            else {
                                if (recordCount > 1) {
                                    removeId.add(pr.Widget__c);
                                    
                                }
                                else {
                                    removeId.add(pr.Related_widget__c);
                                    
                                }
                            }
                        }
                        else {
                            removeId.add(pr.Related_widget__c);
                            
                        }
                }
                //System.assert(false,removeId+''+recordCount);
                for(Profile_Right__c pr : profileRightList){
                    if(!removeId.contains(pr.Widget__c)){
                        if (profileName  != 'System Administrator') {
                            if (pr.Related_widget__c == null) {
                                widgetId = pr.Widget__c;
                            }
                            else {
                                if (recordCount > 1) {
                                    widgetId = pr.Related_widget__c;
                                }
                                else {
                                    widgetId = pr.Widget__c;
                                }
                            }
                        }
                        else {
                            widgetId = pr.Widget__c;
                        }
                        
                        if(!profileRight.containskey(widgetId )){
                            widgetIds.add(widgetId );
                            profileRight.put(widgetId ,new Set<Id>());
                        }
                        profileRight.get(widgetId).add(pr.Profile_Id__c);
                    }   
                }
                mapWidgets = new Map<Id,Widget__c>([select id,parent__c,name,query__c,query_type__c,type__c,Size__c,
                Chart_Fields__c,X3D_Chart__c,Data_Limit__c,Stacked__c,Drill_Down_Field__c,Chart_Display_Fields__c from Widget__c 
                where id in: widgetIds ]);
                
                for (Dashboard_View__c dv : dashboardViews ) {
                    List<ViewWidgetWrapper> lstViewWidget = new List<ViewWidgetWrapper>();
                    if (mapViewWidgets.containskey(dv.View__r.id)) {
                        for (View_Widget__c vw : mapViewWidgets.get(dv.View__r.id)) {
                            ViewWidgetWrapper objVW = new ViewWidgetWrapper(vw, '');
                            List<Widget__c> childw = [select id from Widget__c where parent__c = :vw.widget__r.Id];
                            if(childw.size()>0){
                                objVW.selectEvent = 'true';
                            }
                            if(profileRight.containskey(vw.Widget__c)) {
                                for(Id profileId :profileRight.get(vw.Widget__c)) {
                                    if(profileId  == userinfo.getProfileId()) {
                                        lstViewWidget.add(objVW);
                                    }
                                }                                                                           System.debug('Enter In User Setting ************'+mapViewWidgets);   
                            } 
                        }
                        dBoardWrapper.add(new DashBoardViewWrapper(dv,lstViewWidget,dBoardWrapper.size()));
                    }
                }
            }
        }
        catch(Exception e) {
        system.assert(false,e.getstacktracestring()+'---'+e.getMessage());
        // System.debug('*************'+e.getstacktracestring());
        }
    }
    //********** END Of Constructor ***********///
    
    public void loadWidgetsByUserSettings(List<User_Settings__c> userSettings) {
        Map<Id,View_Widget__c> mapVW = new Map<Id,View_Widget__c>( [select Widget__c,Widget__r.Query__c , Widget__r.Data_Source__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.query_type__c,
            Widget__r.parent__c,Widget__r.X3D_Chart__c,Widget__r.id,Widget__r.Institute_Filter__c,Widget__r.Site_Filter__c,Widget__r.Trial_Filter__c,
            Widget__r.size__c  from View_Widget__c where View__c in : viewIds and Widget__r.parent__c = null
            and active__c = true order by sequence__c]);

        List<View_Widget__c> vw = [select Widget__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.Query__c , Widget__r.Data_Source__c,Widget__r.query_type__c,
            Widget__r.parent__c,Widget__r.X3D_Chart__c,Widget__r.id,Widget__r.Stacked__c,Widget__r.Institute_Filter__c,Widget__r.Site_Filter__c,Widget__r.Trial_Filter__c,
            Widget__r.size__c  from View_Widget__c where View__c in : viewIds
            and active__c = true order by sequence__c] ;

        for (User_Settings__c us : userSettings ) {
            if (!mapViewWidgets.containskey(us.View__r.id)) {
                mapViewWidgets.put(us.View__r.id, new List<View_Widget__c>());
            }
            for(View_Widget__c vw1 : vw){
                if(vw1.View__c == us.View__r.id && vw1.Widget__r.id == us.widget__r.id){
                    mapViewWidgets.get(us.View__r.id).add(vw1);
                }
            }
            widgetIds.add(us.Widget__c);
        }

        for (View_Widget__c vw1 : [select Widget__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.Query__c , Widget__r.Data_Source__c,Widget__r.query_type__c,
            Widget__r.parent__c,Widget__r.X3D_Chart__c,Widget__r.id, Widget__r.Stacked__c,Widget__r.Institute_Filter__c,Widget__r.Site_Filter__c,Widget__r.Trial_Filter__c,
            Widget__r.size__c  from View_Widget__c where View__c in : viewIds 
            and active__c = true order by sequence__c]) {
                String flag = '';
                for(String wids:widgetIds){
                if(wids == vw1.Widget__c)
                flag = 'yes';
                }
                if(flag == ''){
                if (!mapViewWidgets.containskey(vw1.View__r.id)) {
                mapViewWidgets.put(vw1.View__r.id, new List<View_Widget__c>());
                }
                mapViewWidgets.get(vw1.View__r.id).add(vw1);
                widgetIds.add(vw1.Widget__c);
                }  
        }
    }
    
    
    
   //********* Institute Action  *********//
    public void setInstitute(){
        siteId = '';
        trialId = '';
        siteList = new List<SelectOption>();
        trialList = new List<SelectOption>(); 
        siteList.add(new SelectOption('','Select'));
        profileName = profiles[0].Name;
        List<InstitutionUser__c> site = new List<InstitutionUser__c>();
        if(profileName == 'Institute Level Admin'){
           site = [select Site__r.Name from InstitutionUser__c where  
                     User__c = :Userinfo.getUserId() Order By Site__r.Name asc] ;
        }
        else{
           site= [select Site__r.Name from InstitutionUser__c where     Institution__c = :InstituteId and
                     User__c = :Userinfo.getUserId() and Site__c!= null Order By Site__r.Name asc] ;
        }
        for(InstitutionUser__c st : site){
               siteList.add(new SelectOption(st.Site__c,st.Site__r.Name));
        }
        loadchartProfileFilter();                  
    }
    //***** End Of Action Institute *******//
    
    //******* Action Site  ********//
    public void setSite(){
        if(siteId != null && siteId != ''){
            trialList = new List<SelectOption>(); 
            trialList.add(new SelectOption('','Select'));
            List<InstitutionUser__c> site = new List<InstitutionUser__c>();
            if(profileName == 'Institute Level Admin'){
               site = [select Trial__r.Name from InstitutionUser__c where  
                         User__c = :Userinfo.getUserId() Order By Site__r.Name asc] ;
            }
            else{
               site= [select Trial__r.Name from InstitutionUser__c where     Site__c = :siteId and
                         User__c = :Userinfo.getUserId() Order By Site__r.Name asc] ;
            }
            for(InstitutionUser__c st : site){
                   trialList.add(new SelectOption(st.Trial__c,st.Trial__r.Name));
            }
            loadchartProfileFilter();
         }             
    }
    //*******End Of Action Site ********//
    
    //********Action Trial ******//
    public void setTrial(){
        loadchartProfileFilter();
    }
    //*******End Action Trial ******//
    
    //******** Load Widgets After Profile Filter Action *********//
    public void loadchartProfileFilter(){
        updatedWidgetsandView = new  Map<String, List<String>>();
        for (View_Widget__c vw : [select Widget__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.Query__c , Widget__r.Data_Source__c,Widget__r.query_type__c,
                    Widget__r.parent__c,Widget__r.X3D_Chart__c,Widget__r.id, Widget__r.Stacked__c,Widget__r.Trial_Filter__c,Widget__r.Site_Filter__c,Widget__r.Institute_Filter__c,
                    Widget__r.size__c  from View_Widget__c where View__c in : viewIds 
                    and active__c = true order by sequence__c]) {
            String str12;
            Widget__c widget = mapWidgets.get(vw.Widget__c);
            if (vw.widget__r.query__c != null) {
                String query = ''+string.valueOf(vw.widget__r.query__c).toLowerCase();
                if(string.valueOf(vw.widget__r.query__c).toLowerCase().contains('group by')){
                    if(trialId != null && vw.Widget__r.Trial_Filter__c != null && trialId != ''){
                        Integer k = query.indexOf('group by');
                        String hquery = query.subString(0,k);
                        String rquery = query.subString(k,query.length());
                        if (query.contains('where')){
                             query  =  hquery+' and '+vw.Widget__r.Trial_Filter__c+'=\''+trialId+'\' '+rquery;
                        }
                        else{
                             query  = hquery+' where '+vw.Widget__r.Trial_Filter__c+'=\''+trialId+'\' '+rquery;
                        } 
                    }
                    if(siteId != null && siteId !='' && vw.Widget__r.Site_Filter__c != null){
                        Integer k = query.indexOf('group by');
                        String hquery = query.subString(0,k);
                        String rquery = query.subString(k,query.length());
                        if (query.contains('where')){
                              query  =  hquery+' and '+vw.Widget__r.Site_Filter__c+'=\''+siteId +'\' '+rquery;
                        }
                        else{
                             query  = hquery+' where '+vw.Widget__r.Site_Filter__c+'=\''+siteId+'\' '+rquery;
                        } 
                    }
                    
                    if(instituteId != null && instituteId != '' && vw.Widget__r.Institute_Filter__c != null){
                        String querylower = query.toLowerCase();
                        Integer k = querylower.indexOf('group by');
                        String hquery = query.subString(0,k);
                        String rquery = query.subString(k,query.length());
                        if (query.contains('where')){
                             query  =  hquery+' and '+vw.Widget__r.Institute_Filter__c+'=\''+instituteId+'\' '+rquery;
                        }
                        else{
                             query  = hquery+' where '+vw.Widget__r.Institute_Filter__c+'=\''+instituteId+'\' '+rquery;
                        } 
                        
                    }
                    widget.query__c = query ;
                    if((trialId != null || siteId != null || instituteId != null) && ( vw.Widget__r.Trial_Filter__c != null || vw.Widget__r.Site_Filter__c != null || vw.Widget__r.Institute_Filter__c != null)){
                        if(!updatedWidgetsandView.containsKey(vw.Id)){
                           updatedWidgetsandView.put(String.ValueOf(vw.Id), new List<String>());
                        }
                        System.debug('UPDATED Query ============'+widget.Query__c );
                        updatedWidgetsandView.get(String.ValueOf(vw.Id)).add(String.ValueOf(vw.Widget__c));
                        for (DashBoardViewWrapper dbvw : dBoardWrapper) {
                            for (ViewWidgetWrapper vww : dbvw.viewWidgets ) {
                                if(vww.viewWidget.Widget__c ==vw.Widget__c){
                                    vww.data = getData(mapWidgets.get(vw.Widget__c));
                                }
                            }
                        }
                    }
                }
                else{
                    if(trialId != null && vw.Widget__r.Trial_Filter__c != null){
                      if (string.valueOf(vw.widget__r.query__c = query ).contains('where'))
                          vw.widget__r.query__c +=   ' and '+vw.Widget__r.Trial_Filter__c+'=\''+trialId+'\'';    
                      else
                          vw.widget__r.query__c += ' where '+vw.Widget__r.Trial_Filter__c+'=\''+trialId+'\'';    
                    }
                    if(siteId != null && vw.Widget__r.Site_Filter__c != null){
                     if (string.valueOf(vw.widget__r.query__c = query ).contains('where'))
                         vw.widget__r.query__c +=   ' and '+vw.Widget__r.Site_Filter__c+'=\''+siteId+'\'';
                     else
                         vw.widget__r.query__c += ' where '+vw.Widget__r.Site_Filter__c+'=\''+siteId+'\'';    
                    }
                    if(instituteId != null && vw.Widget__r.Institute_Filter__c != null){
                     if (string.valueOf(vw.widget__r.query__c = query ).contains('where'))
                         vw.widget__r.query__c +=   ' and '+vw.Widget__r.Institute_Filter__c+'=\''+instituteId +'\'';
                     else
                         vw.widget__r.query__c += ' where '+vw.Widget__r.Institute_Filter__c+'=\''+instituteId +'\'';            
                    }
                    if((trialId != null || siteId != null || instituteId != null) && ( vw.Widget__r.Trial_Filter__c != null || vw.Widget__r.Site_Filter__c != null || vw.Widget__r.Institute_Filter__c != null)){
                    if(!updatedWidgetsandView.containsKey(vw.Id)){
                       updatedWidgetsandView.put(String.ValueOf(vw.Id), new List<String>());
                    }
                    updatedWidgetsandView.get(String.ValueOf(vw.Id)).add(String.ValueOf(vw.Widget__c));

                            for (DashBoardViewWrapper dbvw : dBoardWrapper) {
                                for (ViewWidgetWrapper vww : dbvw.viewWidgets ) {
                                    if(vww.viewWidget.Widget__c == vw.Widget__c){
                                        vww.data = getData(mapWidgets.get(vw.Widget__c));
                                    }
                                }
                         }
                    }
                }  
            }
            else{
                if((trialId != null || siteId != null || instituteId != null) && ( vw.Widget__r.Trial_Filter__c != null || vw.Widget__r.Site_Filter__c != null || vw.Widget__r.Institute_Filter__c != null)){
                    
                      
                    if(!updatedWidgetsandView.containsKey(vw.Id)){
                       updatedWidgetsandView.put(String.ValueOf(vw.Id), new List<String>());
                    }
                    System.debug('UPDATED Query ============'+widget.Query__c );
                    updatedWidgetsandView.get(String.ValueOf(vw.Id)).add(String.ValueOf(vw.Widget__c));
                    for (DashBoardViewWrapper dbvw : dBoardWrapper) {
                        for (ViewWidgetWrapper vww : dbvw.viewWidgets ) {
                            if(vww.viewWidget.Widget__c ==vw.Widget__c){
                                String link ='/apex/'+vww.viewWidget.Widget__r.Data_Source__c+'?institute='+instituteId; 
                                if(siteId != null && siteId != '' && trialId != null && trialId != '')
                                    link = '/apex/'+vww.viewWidget.Widget__r.Data_Source__c+'?institute='+instituteId +'&site='+siteId+'&trial='+trialId;
                                if((trialId == null || trialId == '') && siteId != null && siteId != '')
                                    link = '/apex/'+vww.viewWidget.Widget__r.Data_Source__c+'?institute='+instituteId +'&site='+siteId;
                                System.debug('Page Link========'+link);
                                PageReference  pg = new PageReference(link);
                                String str  = pg.getContent().toString();
                                Integer i = str.indexOf('<body>');
                                Integer j = str.lastIndexOf('</body>');
                                String dataSource = str.subString(i+6,j);  
                                vww.data = dataSource ;                     System.debug('UPDATED Data Source Data============'+dataSource);
                            }
                        }
                    }
                }
             }   
        }
        
    }
    //********End  Load Widgets After Profile Filter Action *********//
 
    //******** Get Data ******//
    public string getData(Widget__c widget) {
        Chart chart ;
        if (widget.type__c == 'Bar') {
            chart = new Chart( new BarChart());
        }
        else if (widget.type__c == 'Pie') {
            chart = new Chart( new PieChart());
        }
        else if (widget.type__c == 'Column') {
            chart = new Chart( new ColumnChart());
        }
        else if (widget.type__c == 'Grid') {
            chart = new Chart( new GridChart());
        }
        chart.widget = widget;
        return chart.getChartData();
    }
    //******** End Of Get Data ******//
    
    //******** Get Child Widget *******//
    public void getChildWidget() {
        List<string> splitedvalue = parentcolumnvalue.split('###');
        childpicklist = new List<SelectOption>();
        childpicklist.add(new SelectOption('','Select'));
        if(splitedvalue.size()>0){
            for(integer i=0;i<splitedvalue.size();i++)
                childpicklist.add(new selectOption(''+splitedvalue[i],''+splitedvalue[i]));
        }    
        parentwidgetid = widgetId;
        List<Widget__c> childw = [select id,Drill_Down_Field__c,Data_Limit__c,query_type__c ,parent__c,name,query__c,type__c,Size__c,
                    Chart_Fields__c,X3D_Chart__c,Chart_Display_Fields__c from Widget__c where parent__c = :widgetId];
        System.debug('HHHH%%%%%'+childw.size());
        if(childw.size()>0){
            ChildChartName = childw[0].name;
                if (childw[0].query__c != null) {
                    if (string.valueOf(childw[0].query__c).contains('where')){
                        childw[0].query__c +=   ' and '+childw[0].Drill_Down_Field__c+'=\''+relatedId+'\'';
                    }
                    else{
                        childw[0].query__c += ' where '+childw[0].Drill_Down_Field__c+'=\''+relatedId+'\'';
                    }
                    ChildChartData = getData(childw[0]);
                }
        }   
        else{   
        
        }            
    }
    //********End Of  Get Child Widget *******//
    
    //******* Dashboad Wrapper Class *******//
    public class DashBoardViewWrapper{
        public integer index{get;set;}
        public Dashboard_View__c dashboardView{get;set;}    
        public List<ViewWidgetWrapper> viewWidgets {get;set;}  
        public DashBoardViewWrapper(Dashboard_View__c dashboardView,List<ViewWidgetWrapper> viewWidgets, Integer index) {
            this.dashboardView = dashboardView;
            this.viewWidgets = viewWidgets;
            this.index = index;
        }
    }
    //******* End Of Dashboad Wrapper Class *******//
    
    //********ViewWidget Wrapper Class ******//
    public class ViewWidgetWrapper{
        public View_Widget__c viewWidget {get;set;}
        public String data {get;set;}
        public String selectEvent{get;set;}
        public ViewWidgetWrapper(View_Widget__c  viewWidget , string data) {
            this.viewWidget = viewWidget;
            this.data = data;
            this.selectEvent = 'false';
        }
    }
    //********End Of ViewWidget Wrapper Class ******//
    
     public void getFilterWidget() {
        try{
            fillterSelect = 'Yes';
            loadFilter();
            }
        catch(Exception e){
            System.assert(false,e.getstacktracestring());            }
        
    }
    
    public void loadFilter(){
       
        updatedWidgetsandView = new  Map<String, List<String>>();
        for (View_Widget__c vw : [select Widget__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.Query__c , Widget__r.Data_Source__c,Widget__r.query_type__c,
                    Widget__r.parent__c,Widget__r.X3D_Chart__c,Widget__r.id, Widget__r.Stacked__c,Widget__r.Trial_Filter__c,Widget__r.Site_Filter__c,Widget__r.Institute_Filter__c,
                    Widget__r.size__c  from View_Widget__c where View__c in : viewIds 
                    and active__c = true and Widget__c = :widgetId order by sequence__c]) {
            String str12;
            Widget__c widget = mapWidgets.get(vw.Widget__c);
            if (vw.widget__r.query__c != null) {
                String query = ''+string.valueOf(vw.widget__r.query__c).toLowerCase();
                if(string.valueOf(vw.widget__r.query__c).toLowerCase().contains('group by')){
                    if(trialId != null && vw.Widget__r.Trial_Filter__c != null && trialId != ''){
                        Integer k = query.indexOf('group by');
                        String hquery = query.subString(0,k);
                        String rquery = query.subString(k,query.length());
                        if (query.contains('where')){
                             query  =  hquery+' and '+vw.Widget__r.Trial_Filter__c+'=\''+trialId+'\' '+rquery;
                        }
                        else{
                             query  = hquery+' where '+vw.Widget__r.Trial_Filter__c+'=\''+trialId+'\' '+rquery;
                        } 
                    }
                    if(siteId != null && siteId !='' && vw.Widget__r.Site_Filter__c != null){
                        Integer k = query.indexOf('group by');
                        String hquery = query.subString(0,k);
                        String rquery = query.subString(k,query.length());
                        if (query.contains('where')){
                              query  =  hquery+' and '+vw.Widget__r.Site_Filter__c+'=\''+siteId +'\' '+rquery;
                        }
                        else{
                             query  = hquery+' where '+vw.Widget__r.Site_Filter__c+'=\''+siteId+'\' '+rquery;
                        } 
                    }
                    
                    if(instituteId != null && instituteId != '' && vw.Widget__r.Institute_Filter__c != null){
                        String querylower = query.toLowerCase();
                        Integer k = querylower.indexOf('group by');
                        String hquery = query.subString(0,k);
                        String rquery = query.subString(k,query.length());
                        if (query.contains('where')){
                             query  =  hquery+' and '+vw.Widget__r.Institute_Filter__c+'=\''+instituteId+'\' '+rquery;
                        }
                        else{
                             query  = hquery+' where '+vw.Widget__r.Institute_Filter__c+'=\''+instituteId+'\' '+rquery;
                        } 
                        
                    }
                    widget.query__c = query ;
                    if((trialId != null || siteId != null || instituteId != null) && ( vw.Widget__r.Trial_Filter__c != null || vw.Widget__r.Site_Filter__c != null || vw.Widget__r.Institute_Filter__c != null)){
                        if(!updatedWidgetsandView.containsKey(vw.Id)){
                           updatedWidgetsandView.put(String.ValueOf(vw.Id), new List<String>());
                        }
                        System.debug('UPDATED Query ============'+widget.Query__c );
                        updatedWidgetsandView.get(String.ValueOf(vw.Id)).add(String.ValueOf(vw.Widget__c));
                        for (DashBoardViewWrapper dbvw : dBoardWrapper) {
                            for (ViewWidgetWrapper vww : dbvw.viewWidgets ) {
                                if(vww.viewWidget.Widget__c ==vw.Widget__c){
                                    vww.data = getData(mapWidgets.get(vw.Widget__c));
                                }
                            }
                        }
                    }
                }
                else{
                    if(trialId != null && vw.Widget__r.Trial_Filter__c != null){
                      if (string.valueOf(vw.widget__r.query__c = query ).contains('where'))
                          vw.widget__r.query__c +=   ' and '+vw.Widget__r.Trial_Filter__c+'=\''+trialId+'\'';    
                      else
                          vw.widget__r.query__c += ' where '+vw.Widget__r.Trial_Filter__c+'=\''+trialId+'\'';    
                    }
                    if(siteId != null && vw.Widget__r.Site_Filter__c != null){
                     if (string.valueOf(vw.widget__r.query__c = query ).contains('where'))
                         vw.widget__r.query__c +=   ' and '+vw.Widget__r.Site_Filter__c+'=\''+siteId+'\'';
                     else
                         vw.widget__r.query__c += ' where '+vw.Widget__r.Site_Filter__c+'=\''+siteId+'\'';    
                    }
                    if(instituteId != null && vw.Widget__r.Institute_Filter__c != null){
                     if (string.valueOf(vw.widget__r.query__c = query ).contains('where'))
                         vw.widget__r.query__c +=   ' and '+vw.Widget__r.Institute_Filter__c+'=\''+instituteId +'\'';
                     else
                         vw.widget__r.query__c += ' where '+vw.Widget__r.Institute_Filter__c+'=\''+instituteId +'\'';            
                    }
                    if((trialId != null || siteId != null || instituteId != null) && ( vw.Widget__r.Trial_Filter__c != null || vw.Widget__r.Site_Filter__c != null || vw.Widget__r.Institute_Filter__c != null)){
                    if(!updatedWidgetsandView.containsKey(vw.Id)){
                       updatedWidgetsandView.put(String.ValueOf(vw.Id), new List<String>());
                    }
                    updatedWidgetsandView.get(String.ValueOf(vw.Id)).add(String.ValueOf(vw.Widget__c));

                            for (DashBoardViewWrapper dbvw : dBoardWrapper) {
                                for (ViewWidgetWrapper vww : dbvw.viewWidgets ) {
                                    if(vww.viewWidget.Widget__c == vw.Widget__c){
                                        vww.data = getData(mapWidgets.get(vw.Widget__c));
                                    }
                                }
                         }
                    }
                }  
            }
            else{
                if((trialId != null || siteId != null || instituteId != null) && ( vw.Widget__r.Trial_Filter__c != null || vw.Widget__r.Site_Filter__c != null || vw.Widget__r.Institute_Filter__c != null)){
                    
                      
                    if(!updatedWidgetsandView.containsKey(vw.Id)){
                       updatedWidgetsandView.put(String.ValueOf(vw.Id), new List<String>());
                    }
                    System.debug('UPDATED Query ============'+widget.Query__c );
                    updatedWidgetsandView.get(String.ValueOf(vw.Id)).add(String.ValueOf(vw.Widget__c));
                    for (DashBoardViewWrapper dbvw : dBoardWrapper) {
                        for (ViewWidgetWrapper vww : dbvw.viewWidgets ) {
                            if(vww.viewWidget.Widget__c ==vw.Widget__c){
                                String link ='/apex/'+vww.viewWidget.Widget__r.Data_Source__c+'?site='+siteId; 
                                System.debug('Page Link========'+link);
                                PageReference  pg = new PageReference(link);
                                String str  = pg.getContent().toString();
                                Integer i = str.indexOf('<body>');
                                Integer j = str.lastIndexOf('</body>');
                                String dataSource = str.subString(i+6,j);  
                                vww.data = dataSource ;                    
                                 System.debug('UPDATED Data Source Data============'+dataSource);
                            }
                        }
                    }
                }
             }   
        }
        
    }
    //*********  Load Data Of Widgets Function *****//
    
    //*********  Load Data Of Widgets Function *****//
    public void loadData() {
        try{
            fillterSelect = 'Yes';
            filterpicklist = new List<SelectOption>();
            filterpicklist.add(new SelectOption('','Select'));
            for(Site__c s : [Select Id, Name from Site__c]){
                filterpicklist.add(new selectOption(s.Id,s.Name));
            }  
            //System.assert(false,filterpicklist);  
            for (DashBoardViewWrapper dbvw : dBoardWrapper) {
                for (ViewWidgetWrapper vww : dbvw.viewWidgets ) {
                    String str1 ='';
                    if ( vww.viewWidget.Widget__c == widgetId) {
                        viewWidget.add(vww.viewWidget.Id);
                        if(fortabelview != null && fortabelview != '' ){
                            Chart chart = new Chart( new GridChart());
                            chart.widget = mapWidgets.get(widgetId);
                            str1 = chart.getChartData();
                            fortabelview = '';
                        }
                        else
                            System.debug('^^^^^^^^^^^^'+vww.viewWidget.Widget__r.query__c);
                        if(vww.viewWidget.Widget__r.query__c == null){
                            PageReference  pg = new PageReference('/apex/'+vww.viewWidget.Widget__r.Data_Source__c);
                            String str  = pg.getContent().toString();
                            Integer i = str.indexOf('<body>');
                            Integer j = str.lastIndexOf('</body>');
                            str1 = str.subString(i+6,j);
                        }
                        else     
                            str1  = getData(mapWidgets.get(widgetId));

                        vww.data =str1;
                        countWidget++;
                        System.debug('Data LOAD ======='+str1+ vww.viewWidget.Widget__r.query__c);
                    }
                }
            }
        }
        catch(exception e){
            // System.assert(false,'Error==================='+e.getstacktracestring());
            Apexpages.addMessages(e);
        }
    }
    //********* End Of  Load Data Fun *****//
   
    //********** Widget View (Drag and Drop )Setting Function *******//
    @RemoteAction
    public  static String saveUserSetting(String arr00,String arr11,String arr22) {
    /*    arr0 = arr0.substring(1, arr0.length()-1);
        arr1 = arr1.substring(1, arr1.length()-1);
        arr2 = arr2.substring(1, arr2.length()-1);
        List<String> listarr0 = arr0.split(',');
        List<String> listarr1 = arr1.split(',');
        List<String> listarr2 = arr2.split(',');
        List<String> viewIds = new  List<String>();
        Integer ii = listarr0.size();
        Integer j = listarr1.size();
        integer k;
        if(ii>j){
            k=ii;
        }
        else
            k=j;
        
        for(Integer m=0;m<k;m++){
            if(m<ii)
                viewIds.add(listarr0[m]); 
            if(m<j)
                viewIds.add(listarr1[m]);
        } */
        List<String> viewIds = new  List<String>();
        
        List<String> arr0 = new List<String>();
         List<String> arr1 = new List<String>();
          List<String> arr2 = new List<String>();
           List<String> arr3 = new List<String>();
            List<String> arr4 = new List<String>();
             List<String> arr5 = new List<String>();
              List<String> arr6 = new List<String>();
               List<String> arr7 = new List<String>();
                List<String> arr8 = new List<String>();
                 List<String> arr9 = new List<String>();
                  List<String> arr10 = new List<String>();
                 
        List<String> allwidget = arr22.split(',');
        for(String seqwidget : allwidget){
            if(seqwidget.contains('##1')){
                arr0.add(''+seqwidget.subString(0,seqwidget.length()-3));
            }
            if(seqwidget.contains('##2')){
                arr1.add(''+seqwidget.subString(0,seqwidget.length()-3));
            }
            if(seqwidget.contains('##3')){
                arr3.add(''+seqwidget.subString(0,seqwidget.length()-3));
            }
            if(seqwidget.contains('##4')){
                arr4.add(''+seqwidget.subString(0,seqwidget.length()-3));
            }
            if(seqwidget.contains('##5')){
                arr5.add(''+seqwidget.subString(0,seqwidget.length()-3));
            }
            if(seqwidget.contains('##6')){
                arr6.add(''+seqwidget.subString(0,seqwidget.length()-3));
            }
            if(seqwidget.contains('##7')){
                arr7.add(''+seqwidget.subString(0,seqwidget.length()-3));
            }
            if(seqwidget.contains('##8')){
                arr8.add(''+seqwidget.subString(0,seqwidget.length()-3));
            }
            if(seqwidget.contains('##9')){
                arr9.add(''+seqwidget.subString(0,seqwidget.length()-3));
            }
            if(seqwidget.contains('##A')){
                arr10.add(''+seqwidget.subString(0,seqwidget.length()-3));
            }
             if(seqwidget.contains('##B')){
                arr2.add(''+seqwidget.subString(0,seqwidget.length()-3));
            }
        } 
        
        Integer si = arr0.size();
        Integer sj = arr1.size();
        integer sk = arr3.size(); 
        integer sl = arr4.size();
        integer forlength = 0; 
        if(si>=sj&&si>=sk&&si>=sl){
            forlength = si;
        }
        if(sk>=si&&sk>=sj&&sk>=sl){
            forlength = sk;
        }
        if(sj>=si&&sj>=sk&&sj>=sl){
            forlength = sj;
        }
        if(sl>=si&&sl>=sj&&sl>=sk){
            forlength = sl;
        }
        for(Integer m=0;m<forlength;m++){
            if(m<si)
                viewIds.add(arr0[m]); 
            if(m<sj)
                viewIds.add(arr1[m]);
            if(m<sk)
                viewIds.add(arr3[m]);
            if(m<sl)
                viewIds.add(arr4[m]);
        }
        Integer oti = arr5.size();
        Integer otj = arr6.size();
        integer otk = arr7.size(); 
        forlength = 0; 
        if(oti>=otj&&oti>=otk){
            forlength = oti;
        }
        if(otk>=oti&&otk>=otj){
            forlength = otk;
        }
        if(otj>=oti&&otj>=otk){
            forlength = otj;
        }
        for(Integer m=0;m<forlength;m++){
            if(m<oti)
                viewIds.add(arr5[m]); 
            if(m<otj)
                viewIds.add(arr6[m]);
            if(m<otk)
                viewIds.add(arr7[m]);
        }
        Integer hi = arr8.size();
        Integer hj = arr9.size();
        forlength = 0; 
        if(hi>=hj){
            forlength = hi;
        }
        if(hj>=hi){
            forlength = hj;
        }
        for(Integer m=0;m<forlength;m++){
            if(m<hi)
                viewIds.add(arr8[m]); 
            if(m<hj)
                viewIds.add(arr9[m]);
          
        }
        for(String str : arr10 ){
            viewIds.add(str);
        }
        for(String str : arr2 ){
            viewIds.add(str);
        }
        /*for(Integer l=0;l<listarr2.size();l++){
            viewIds.add(listarr2[l]);
        } */
       
        Integer i=0;
        List<View_Widget__c> viewwidget =  [select Id,Widget__r.Id,View__c,Widget__c from View_Widget__c];
        List<String> widgetId = new List<String>();
        String view;
         
         for(String wId : viewIds){
            for(View_Widget__c vw   : viewwidget ){
                //System.assert(false,wId.trim()+' == '+vw.Id);
                if(wId.trim() == ''+vw.Id)
                {
                        view = vw.View__c;
                        widgetId.add(vw.Widget__c);
                }
            }
        }
        List<User_Settings__c> usr = [Select id,Widget__r.Id,Widget__c,View__c From User_Settings__c Where Widget__r.Id in :widgetId];
        //System.assert(false,widgetId);
        String uu = Userinfo.getUserId();
        for(String wId : widgetId ){
            Integer flag = 0,update_flag=0;
            Id usId;
            for(User_Settings__c u : usr){
                if(u.Widget__c == wId.trim() && u.View__c == view){
                    flag = 1;
                    usId = u.Id;
                }
            }    
            if(flag==1){
                User_Settings__c us = new User_Settings__c(Id=usId); 
                us.Sequence__c = i;
                update us;
            }
            else{    
                User_Settings__c us = new User_Settings__c(); 
                us.View__c = view;
                us.Sequence__c = i;
                us.User__c = uu;
                us.Widget__c = wId;
                insert us;
            }
            i++;
        } 
        return null;
    }
    //********** End Of Widget View Setting Function *******//
}
//*******************************************End Of Class*********************//