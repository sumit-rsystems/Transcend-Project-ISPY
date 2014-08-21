global class DashboardController{
 
    public List<DashBoardViewWrapper> dBoardWrapper{get;set;}
    public string relatedId{get;set;}
    public string widgetId{get;set;}
    public string viewName{get;set;}
    public string tabIndex{get;set;}
    public string startPosition{get;set;}
    public string newPosition{get;set;}
    public string idsAndSequenceNumbers{get;set;}
    public string fortabelview{get;set;}
    public List<User_Settings__c> UserSettings;
    public string dashBoardId {get;set;}
    public static String datag{get;set;} 
    public String datal {get;set;}
    Map<Id,Widget__c> mapWidgets;
    public List<String> viewWidget{get;set;}
    public Integer countWidget{get;set;}
    public LIst<String> datas{get;set;}
    Public List<Id> wId{get;set;}
    public String profileName{get;set;}
     Map<string ,List<View_Widget__c>>  mapViewWidgets;
     
    public List<Selectoption> trialList{get;set;}
    public String trialId{get;set;}
    public List<Selectoption> siteList{get;set;}
    public String siteId{get;set;}
    public List<Selectoption> instituteList{get;set;}
    public String instituteId{get;set;}
    public Set<String> widgetIds;
    
    public String parentclolumnvalue{get;set;}
    public List<Selectoption> childpicklist{get;set;}
   
        
    public DashboardController(ApexPages.StandardController controller){
        try {
            dashBoardId  = controller.getId();
            datag='';
            datal = '';
            widgetId ='';
            relatedId= '';
            fortabelview='';
            countWidget=0;
            parentclolumnvalue = '';
           
            
            
            instituteList = new List<SelectOption>();
            
            viewWidget = new List<String>();
            wId = new List<Id>();
            datas = new LIst<String>();
            if (dashBoardId != null) {
          
                instituteList.add(new SelectOption('','Select'));
                List<RecordType> rt = [SELECT name ,Id FROM RecordType where name = 'Institution' ];
                List<Account> institute= [select Id,Name from Account where recordTypeId = :rt[0].id Order By Name asc];
                for(Account ins : institute){
                   instituteList.add(new SelectOption(ins.Id,ins.Name)); 
                }
                
                dBoardWrapper = new List<DashBoardViewWrapper>();
                
                List<Dashboard_View__c> dashboardViews = [select id,name,View__r.name,View__r.id from  Dashboard_View__c 
                where Dashboard__c = :dashBoardId and Active__c = true order by Sequence__c];
                
                List<string> viewIds = new List<string>(); 
                for (Dashboard_View__c dv : dashboardViews ) {
                     viewIds.add(dv.View__r.id);
                }
               
                 mapViewWidgets =  new map<string ,List<View_Widget__c>>();
                
                 widgetIds = new Set<String>();
                
                
               // System.assert(false,'Hii'+profileRight);
                List<User_Settings__c> userSettings = [select Widget__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.query_type__c,
                    Widget__r.parent__c,Widget__r.X3D_Chart__c,Widget__r.id,
                    Widget__r.size__c  from User_Settings__c where User__c =: Userinfo.getUserId() and View__c in : viewIds 
                   
                    order by sequence__c];
                
                if (userSettings.size() > 0) {
                    
                    Map<Id,View_Widget__c> mapVW = new Map<Id,View_Widget__c>( [select Widget__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.query_type__c,
                    Widget__r.parent__c,Widget__r.X3D_Chart__c,Widget__r.id,
                    Widget__r.size__c  from View_Widget__c where View__c in : viewIds and Widget__r.parent__c = null
                    and active__c = true order by sequence__c]);
                    
                    List<View_Widget__c> vw = [select Widget__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.query_type__c,
                    Widget__r.parent__c,Widget__r.X3D_Chart__c,Widget__r.id,Widget__r.Stacked__c,
                    Widget__r.size__c  from View_Widget__c where View__c in : viewIds
                    and active__c = true order by sequence__c] ;
                    //System.assert(false,vw);
                    for (User_Settings__c us : userSettings ) {
                        if (!mapViewWidgets.containskey(us.View__r.id)) {
                            mapViewWidgets.put(us.View__r.id, new List<View_Widget__c>());
                        }
                        for(View_Widget__c vw1 : vw){
                            
                            if(vw1.View__c == us.View__r.id && vw1.Widget__r.id == us.widget__r.id)
                           {
                                mapViewWidgets.get(us.View__r.id).add(vw1);
                               
                           }
                            
                            }
                         widgetIds.add(us.Widget__c);
                    }
                   for (View_Widget__c vw1 : [select Widget__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.query_type__c,
                    Widget__r.parent__c,Widget__r.X3D_Chart__c,Widget__r.id, Widget__r.Stacked__c,
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
                else {
                
                    for (View_Widget__c vw : [select Widget__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.query_type__c,
                    Widget__r.parent__c,Widget__r.X3D_Chart__c,Widget__r.id, Widget__r.Stacked__c,
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
                List<Profile_Right__c> profileRightList = [Select Id,Name,Widget__c,Profile_Id__c From Profile_Right__c 
                where Widget__c in : widgetIds and Profile_Id__c != null];
                
                for(Profile_Right__c pr : profileRightList){
                    if(!profileRight.containskey(pr.Widget__c)){
                        profileRight.put(pr.Widget__c,new Set<Id>());
                    }
                    profileRight.get(pr.Widget__c).add(pr.Profile_Id__c);
                    
                } 
                
                mapWidgets = new Map<Id,Widget__c>([select id,parent__c,name,query__c,query_type__c,type__c,Size__c,
                Chart_Fields__c,X3D_Chart__c,Data_Limit__c,Stacked__c,Drill_Down_Field__c,Chart_Display_Fields__c from Widget__c 
                where id in: widgetIds ]);
                
                
                
                //system.assert(false,mapViewWidgets);
                for (Dashboard_View__c dv : dashboardViews ) {
                    List<ViewWidgetWrapper> lstViewWidget = new List<ViewWidgetWrapper>();
                    if (mapViewWidgets.containskey(dv.View__r.id)) {
                        for (View_Widget__c vw : mapViewWidgets.get(dv.View__r.id)) {
                             //ViewWidgetWrapper objVW = new ViewWidgetWrapper(vw, getData(mapWidgets.get(vw.Widget__c)));
                             
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
                               }System.debug('Enter In User Setting ************'+mapViewWidgets);   
                           } 
                        }
                        //System.assert(false,''+userinfo.getProfileId()+'===='+profileRight);
                        dBoardWrapper.add(new DashBoardViewWrapper(dv,lstViewWidget,dBoardWrapper.size()));
                    }
                }
            }
            //system.assert(false,'dBoardWrapper = '+ dBoardWrapper);
        }
        catch(Exception e) {
            system.assert(false,e.getstacktracestring()+'---'+e.getMessage());
           // System.debug('*************'+e.getstacktracestring());
        }
        
        
         
    }
    
    
    public void actionTrial(){
        
           String backup= '';
           String widgetIdlocal='';
           String str12='';
           String addstr = '';
           trialList = new List<SelectOption>();
           siteList = new List<SelectOption>();
           List<InstitutionTrial__c> trial  = [select Trial_Id__c,Trial_Id__r.name from InstitutionTrial__c Order By Trial_Id__r.name asc];
            trialList.add(new SelectOption('','Select'));
            siteList.add(new SelectOption('','Select'));
           Map<Id,String> trialmap = new Map<Id,String>();
           for(InstitutionTrial__c tr : trial){
               if(!trialmap.containsKey(tr.Trial_Id__c) ){
                   trialmap.put(tr.Trial_Id__c,tr.Trial_Id__r.name);
               }
           } 
            
            List<Site_Trial__c>  trial1= [select Trial__c,Trial__r.Name from Site_Trial__c where  Site__c =:siteId Order By Name asc];
            for(Site_Trial__c st : trial1){  
                 trialList.add(new SelectOption(st.Trial__c,st.Trial__r.Name)); 
            }
            List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            profileName = profiles[0].Name;
            List<Site__c> site = new List<Site__c>();
            if(profileName == 'Institute Level Admin')
                site= [select Id,Name from Site__c Order By Name asc];
            else
                site= [select Id,Name from Site__c where  Institute__c =:instituteId Order By Name asc];    
            for(Site__c st : site){
               siteList.add(new SelectOption(st.Id,st.Name)); 
            }
            try{
                Map<Id,Widget__c> mapWidgets = new Map<Id,Widget__c>([select id,parent__c,name,query__c,query_type__c,type__c,Size__c,
                Chart_Fields__c,X3D_Chart__c,Data_Limit__c,Stacked__c,Drill_Down_Field__c,Chart_Display_Fields__c from Widget__c 
                where id in: widgetIds ]);
                System.debug('&&&&&&&&&&&&&&&&&&&&&'+mapWidgets);
                if (mapWidgets.size() > 0) {
                
                    Map<string ,List<View_Widget__c>>  mapViewWidgets =  new map<string ,List<View_Widget__c>>();
                    
                    for (View_Widget__c vw : [select Id,Widget__c,Widget__r.Institute_Filter__c,Widget__r.Site_Filter__c,Widget__r.Trial_Filter__c,Widget__r.Drill_Down_Field__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.parent__c,
                    Widget__r.size__c  from View_Widget__c where Widget__c in : mapWidgets.keyset() and active__c = true]) {
                        if (!mapViewWidgets.containskey(vw.View__r.id)) {
                            mapViewWidgets.put(vw.View__r.id, new List<View_Widget__c>());
                        }
                        mapViewWidgets.get(vw.View__r.id).add(vw);
                    }
                  
                    List<Dashboard_View__c> dashboardViews = [select id,name,View__r.name,View__r.id from  Dashboard_View__c 
                        where Dashboard__c = :dashBoardId and view__c in: mapViewWidgets.keyset() ];
                        
                    for (Dashboard_View__c dv : dashboardViews ) {
                        List<ViewWidgetWrapper> lstViewWidget = new List<ViewWidgetWrapper>();
                        if (mapViewWidgets.containskey(dv.View__r.id)) {
                            for (View_Widget__c vw : mapViewWidgets.get(dv.View__r.id)) {
                                
                                 Widget__c widget = mapWidgets.get(vw.Widget__c);
                                if (widget.query__c != null) {
                                    //widgetIdlocal = vw.Widget__c;
                                    widgetId = vw.Widget__c;
                                    backup = widget.query__c;
                                   
                                    if(string.valueOf(widget.query__c).contains('group by')){
                                       String query = ''+widget.query__c;
                                       
                                       viewName =vw.Id;
                                        if(trialId != null && vw.Widget__r.Trial_Filter__c != null){
                                            Integer k = query.indexOf('group');
                                            String hquery = query.subString(0,k);
                                            String rquery = query.subString(k,query.length());
                                            if (query.contains('where')){
                                                 query  =  hquery+' and '+vw.Widget__r.Trial_Filter__c+'=\''+trialId+'\' '+rquery;
                                            }
                                            else{
                                                 query  = hquery+' where '+vw.Widget__r.Trial_Filter__c+'=\''+trialId+'\' '+rquery;
                                            } 
                                            
                                        }
                                       if(siteId != null && vw.Widget__r.Site_Filter__c != null){
                                            Integer k = query.indexOf('group');
                                            String hquery = query.subString(0,k);
                                            String rquery = query.subString(k,query.length());
                                            if (query.contains('where')){
                                                  query  =  hquery+' and '+vw.Widget__r.Site_Filter__c+'=\''+siteId +'\' '+rquery;
                                            }
                                            else{
                                                 query  = hquery+' where '+vw.Widget__r.Site_Filter__c+'=\''+siteId+'\' '+rquery;
                                            } 
                                            
                                        }
                                        
                                        if(instituteId != null && vw.Widget__r.Institute_Filter__c != null){
                                            Integer k = query.indexOf('group');
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
                                        
                                         System.debug('$$$$$$$$$$$$'+widget.query__c+'%%%%%'+query  );
                                    }
                                    else{
                                         if(trialId != null && vw.Widget__r.Trial_Filter__c != null){
                                              if (string.valueOf(widget.query__c).contains('where'))
                                                  widget.query__c +=   ' and '+vw.Widget__r.Trial_Filter__c+'=\''+trialId+'\'';    
                                              else
                                                  widget.query__c += ' where '+vw.Widget__r.Trial_Filter__c+'=\''+trialId+'\'';    
                                         }
                                         if(siteId != null && vw.Widget__r.Site_Filter__c != null){
                                             if (string.valueOf(widget.query__c).contains('where'))
                                                 widget.query__c +=   ' and '+vw.Widget__r.Site_Filter__c+'=\''+siteId+'\'';
                                             else
                                                 widget.query__c += ' where '+vw.Widget__r.Site_Filter__c+'=\''+siteId+'\'';    
                                         }
                                         if(instituteId != null && vw.Widget__r.Institute_Filter__c != null){
                                             if (string.valueOf(widget.query__c).contains('where'))
                                                 widget.query__c +=   ' and '+vw.Widget__r.Institute_Filter__c+'=\''+instituteId +'\'';
                                             else
                                                 widget.query__c += ' where '+vw.Widget__r.Institute_Filter__c+'=\''+instituteId +'\'';            
                                         }
                                      }  
                                      str12 = getData(mapWidgets.get(vw.Widget__c));
                                }
                                System.debug('%%%%%%%%%%%%%%%%'+widget.query__c);   
                              //System.debug('******8********'+str12); 
                              
                            }
                        }
                    }
            }
           //Get Data From Child Chart And Load Data On Page 
            for (DashBoardViewWrapper dbvw : dBoardWrapper) {
                for (ViewWidgetWrapper vww : dbvw.viewWidgets ) {
                    if (widgetIds.contains(vww.viewWidget.Widget__c)) {
                        viewWidget.add(vww.viewWidget.Id);
                        String str = str12;
                        vww.data =str;
                    }
                        System.debug('Data LOAD ======='+str12 );
                       
                    }
                }
            }
            catch(Exception e){
                System.debug('Error==================='+e.getstacktracestring());
            } 
                
         
    }
    
    void profileRights() {
        string profileName = [select id, name from profile where id =: Userinfo.getProfileId()].Name;
    }
    
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
    
    public void getChildWidget() {
        List<string> splitedvalue = parentclolumnvalue.split('###');
        childpicklist = new List<SelectOption>();
        childpicklist.add(new SelectOption('','Select'));
        if(splitedvalue.size()>0){
            for(integer i=0;i<splitedvalue.size();i++)
            childpicklist.add(new selectOption(''+splitedvalue[i],''+splitedvalue[i]));
        }    
        List<Widget__c> childw = [select id from Widget__c where parent__c = :widgetId];
        if(childw.size()>0)
        {
            String backup= '';
            String widgetIdlocal='';
           String str12='';
           try{
                Map<Id,Widget__c> mapWidgets = new Map<Id,Widget__c>([select id,Data_Limit__c,query_type__c ,parent__c,name,query__c,type__c,Size__c,
                    Chart_Fields__c,X3D_Chart__c,Chart_Display_Fields__c from Widget__c 
                    where parent__c =: widgetId ]);
                if (mapWidgets.size() > 0) {
                
                    Map<string ,List<View_Widget__c>>  mapViewWidgets =  new map<string ,List<View_Widget__c>>();
                    
                    for (View_Widget__c vw : [select Id,Widget__c,Widget__r.Drill_Down_Field__c, View__r.id,Widget__r.name,Widget__r.type__c,Widget__r.parent__c,
                    Widget__r.size__c  from View_Widget__c where Widget__c in : mapWidgets.keyset() and active__c = true]) {
                        if (!mapViewWidgets.containskey(vw.View__r.id)) {
                            mapViewWidgets.put(vw.View__r.id, new List<View_Widget__c>());
                        }
                        mapViewWidgets.get(vw.View__r.id).add(vw);
                    }
                  
                    List<Dashboard_View__c> dashboardViews = [select id,name,View__r.name,View__r.id from  Dashboard_View__c 
                        where Dashboard__c = :dashBoardId and view__c in: mapViewWidgets.keyset() ];
                        
                    for (Dashboard_View__c dv : dashboardViews ) {
                        List<ViewWidgetWrapper> lstViewWidget = new List<ViewWidgetWrapper>();
                        if (mapViewWidgets.containskey(dv.View__r.id)) {
                            for (View_Widget__c vw : mapViewWidgets.get(dv.View__r.id)) {
                                
                                 Widget__c widget = mapWidgets.get(vw.Widget__c);
                                if (widget.query__c != null) {
                                    //widgetIdlocal = vw.Widget__c;
                                    widgetId = vw.Widget__c;
                                    backup = widget.query__c;
                                    if (string.valueOf(widget.query__c).contains('where')){
                                           viewName =vw.Id;
                                           widget.query__c +=   ' and '+vw.Widget__r.Drill_Down_Field__c+'=\''+relatedId+'\'';
                                        }
                                        else{
                                           viewName =vw.Id;
                                           widget.query__c += ' where '+vw.Widget__r.Drill_Down_Field__c+'=\''+relatedId+'\'';
                                        }
                                        str12 = getData(mapWidgets.get(vw.Widget__c));
                                       
                                }
                              //System.debug('******8********'+str12); 
                            }
                        }
                    }
            }
           //Get Data From Child Chart And Load Data On Page 
            for (DashBoardViewWrapper dbvw : dBoardWrapper) {
                for (ViewWidgetWrapper vww : dbvw.viewWidgets ) {
                    if ( vww.viewWidget.Widget__c == widgetId) {
                        viewWidget.add(vww.viewWidget.Id);
                        String str = str12;
                        vww.data =str;
                    }
                        System.debug('Data LOAD ======='+str12 );
                    }
                }
            }
            catch(Exception e){
                System.debug('Error==================='+e.getstacktracestring());
            } 
        }
        else{
        
        }            
    }
    public void saveInSequence(){
    
        List<User_Settings__c> USettings =  new List<User_Settings__c>();
        USettings = [select Sequence__c from  User_Settings__c  where User__c != null AND (Sequence__c =: integer.valueOf(startPosition) OR Sequence__c =: integer.valueOf(newPosition)) ];
        List<string> idsAndSequenceNumbersLst = new List<string>();
        idsAndSequenceNumbersLst = idsAndSequenceNumbers.split('##');
        List<string> ids = new List<string>();
        List<string> sequenceNumbers  = new List<string>();
        for(string idAndNumber : idsAndSequenceNumbersLst){
            sequenceNumbers.add(idAndNumber.split(',')[0]);
            ids.add(idAndNumber.split(',')[1]);
        }
        
        for(User_Settings__c UserSetting : USettings){
            if(UserSetting.Sequence__c == integer.valueOf(startPosition)){
                UserSetting.Sequence__c = integer.valueOf(newPosition) ;
            }
            else{
                UserSetting.Sequence__c = integer.valueOf(startPosition) ;
            }
        }
        if(UserSettings.size() > 0){
            update UserSettings;
        }
    } 
    
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
    public void loadData() {
       
     try{
       
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
                        str1  = getData(mapWidgets.get(widgetId));
                     
                    vww.data =str1;
                    countWidget++;
                   System.debug('Data LOAD ======='+str1 );
                 }
            
            }
        }
      }
      catch(exception e){
           // System.assert(false,'Error==================='+e.getstacktracestring());
           Apexpages.addMessages(e);
      }
    }
    
    
    
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
    
    
    
    
    @RemoteAction
    public  static String getUserSetting(String arr0,String arr1,String arr2) {
        arr0 = arr0.substring(1, arr0.length()-1);
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
        }
        for(Integer l=0;l<listarr2.size();l++){
            viewIds.add(listarr2[l]);
        } 
        
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
      // System.assert(false,widgetId+'====='+widgetIds);
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
    public Set<String> str=new Set<String>();
    public void dd(){
         str.add(widgetId);
       System.debug('%%%%%%%%%%%%%%%%%'+str);
       
    }
  
}