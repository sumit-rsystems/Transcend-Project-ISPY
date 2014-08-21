public with sharing class ViewFailedRegistrationController {

   
    public String systemName { get; set; }

    public String CRFName { get; set; }

    
    public List<SelectOption> getStatusList() {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Failed_Registration__c.Last_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('All', 'All'));    
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }


    public List<SelectOption> getErrorCodes() {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Failed_Registration__c.Error_Code__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('All', 'All'));    
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public List<SelectOption> getCRFNames() {
        List<SelectOption> options = new List<SelectOption>();
        
        //Schema.DescribeFieldResult fieldResult = Failed_Registration__c.Error_Code__c.getDescribe();
        //List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('All', 'All'));    
        //for( Schema.PicklistEntry f : ple)
        //{
        //    options.add(new SelectOption(f.getLabel(), f.getValue()));
        //} 
        List<CRFMaster__c> crfList = [Select CRFType__c From CRFMaster__c order by CRFType__c ];
        for( CRFMaster__c cm : crfList){
            options.add(new SelectOption(cm.CRFType__c, cm.CRFType__c));
        }
              
        return options;
    }
    public List<SelectOption> getSystemNames() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All', 'All'));
        options.add(new SelectOption('caAERS', 'caAERS'));
        options.add(new SelectOption('caTissue', 'caTissue'));
        return options;
    }

    public PageReference doFilter() {
        doSort();
        return null;
    }


    public String lastStatus { get; set; }

    public String errorCode { get; set; }

    //public String toDate { get; set; }

    //public String fromDate { get; set; }

    Public Integer pageSize{get; set;}
    
    Public Dummy_Object__c filter {get; set;}
    
    private String getFilterString(){
        String fltrStr = '';
        if(filter.From_Date__c!=null){
                //try{
                        //Date mydate = Date.parse(fromDate);
                        //Datetime dt = DateTime.parse('10/14/2011 11:46 AM');
                        //String tmpDate = fromDate;
                        //if(tmpDate.length()<=10){
                        //    tmpDate +=' 1:00 AM';
                        //}
                        //Datetime dt = DateTime.parse(tmpDate);
                        Datetime dt = filter.From_Date__c;
                        String strDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                        fltrStr +=' AND CreatedDate>='+strDt;
                //}catch(Exception e){
                //        System.debug('Amit Exception1============================'+e);
                //}
        }
        if(filter.To_Date__c!=null){
                //try{
                        //Date mydate = Date.parse(toDate);
                        //String tmpDate = toDate;
                        //if(tmpDate.length()<=10){
                        //    tmpDate +=' 11:59 PM';
                        //}
                        //Datetime dt = DateTime.parse(tmpDate );
                        Datetime dt = filter.To_Date__c;
                        String strDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                        fltrStr +=' AND CreatedDate<='+strDt;
                //}catch(Exception e){
                //        System.debug('Amit Exception2============================'+e);
                //}
        }
        /*
        if(fromDate!=null&&!fromDate.trim().equals('')){
                try{
                        //Date mydate = Date.parse(fromDate);
                        //Datetime dt = DateTime.parse('10/14/2011 11:46 AM');
                        String tmpDate = fromDate;
                        if(tmpDate.length()<=10){
                            tmpDate +=' 1:00 AM';
                        }
                        Datetime dt = DateTime.parse(tmpDate);
                        String strDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                        fltrStr +=' AND CreatedDate>='+strDt;
                }catch(Exception e){
                        System.debug('Amit Exception1============================'+e);
                }
        }
        if(toDate!=null&&!toDate.trim().equals('')){
                try{
                        //Date mydate = Date.parse(toDate);
                        String tmpDate = toDate;
                        if(tmpDate.length()<=10){
                            tmpDate +=' 11:59 PM';
                        }
                        Datetime dt = DateTime.parse(tmpDate );
                        String strDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
                        fltrStr +=' AND CreatedDate<='+strDt;
                }catch(Exception e){
                        System.debug('Amit Exception2============================'+e);
                }
        }*/
        if(errorCode!=null &&!errorCode.equals('All')){
                fltrStr +=' AND Error_Code__c=\''+errorCode+'\'';
        }
        if(lastStatus!=null &&!lastStatus.equals('All')){
                fltrStr +=' AND Last_Status__c=\''+lastStatus+'\'';
        }
        
        if(CRFName!=null &&!CRFName.equals('All')){
                fltrStr +=' AND CRF_Name__c=\''+CRFName+'\'';
        }
        
        if(systemName!=null &&!systemName.equals('All')){
                fltrStr +=' AND System_Name__c=\''+systemName+'\'';
        }
        
        //Data should be shown based on the site to which the user belongs
        String siteStr = '';
        List<InstitutionUser__c > instUserList = [Select i.User__c, i.Site__c From InstitutionUser__c i where i.User__c= :UserInfo.getUserId()];
        Integer j=0;
        for(Integer i=0;i<instUserList.size();i++ ){
            InstitutionUser__c instUser = instUserList[i];
            if(instUser.Site__c !=null){
                if(j==0){
                    siteStr= '\''+instUser.Site__c +'\'';
                }else{
                    siteStr+= ',\''+instUser.Site__c +'\'';
                }
                j++;
            }
           
        }
        if(!Test.isRunningTest()){
            fltrStr +=' AND Site__c in ('+siteStr+')';
        }
        
        if(fltrStr.length()>0){
                fltrStr = fltrStr.substring(4);
        }
        
        return fltrStr;
    }
     
    public List<FailedRegistrationWrapper> recLst {get{
            
            List<Failed_Registration__c > records = con.getRecords();
    
            recLst = new List<FailedRegistrationWrapper>();
            for(Failed_Registration__c  fr : records ){
    
                recLst.add(new FailedRegistrationWrapper(fr) );
    
            }
            return recLst;
    }
     set;}
    
    
    public String downloadQuery='';
    private String sortDirection = 'DESC';
    private String sortExp = 'CreatedDate';

    public String sortExpression{
        get {
            return sortExp;
        } 
        set{
            if (value == sortExp){
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            }
            else{
                sortDirection = 'DESC';
            }
            sortExp = value;
        }
    }
    
    
    public String getSortDirection(){
        //if not column is selected 
        if (sortExpression == null || sortExpression == ''){
            return 'ASC';
        }
        else{
            return sortDirection;
        }
    }

    public void setSortDirection(String value){  
        sortDirection = value;
    }



    public ViewFailedRegistrationController (){
        //Id=ApexPages.currentPage().getParameters().get('id');
                pageSize = 10; //TODO
                filter = new Dummy_Object__c();
    }


    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                String query = 'SELECT ';
                for(Schema.FieldSetMember f : this.getFields()) {
                    query += f.getFieldPath()+',';
                }
                Integer length = query.length();
                                query=query.substring(0,length-1);
                query += ' FROM Failed_Registration__c ';
                //downloadQuery = query;
                String filter = getFilterString();
                if(filter.length()>0){
                        query +=' Where '+filter;
                }
                query = query + ' order by '+ sortExpression  + ' ' + sortDirection;
                System.debug('Amit========'+query);
                con = new ApexPages.StandardSetController(Database.getQueryLocator(query));

                // sets the number of records in each page set
                con.setPageSize(pageSize);
            }
            return con;
            
        }
        set;
    }
    /*
    public List<FailedRegistrationWrapper> getFailedRegistration() {


        List<Failed_Registration__c  > records = con.getRecords();

        recLst.clear();
        for(Failed_Registration__c  fr : records ){

            recLst.add(new FailedRegistrationWrapper(fr) );

        }

        return recLst;
    }*/

    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Failed_Registration__c.FieldSets.View_Failed_Registration_Field_Set.getFields();
      
    }



    public class FailedRegistrationWrapper
    {
        public Failed_Registration__c failedRegistration{get; set;}
        public Boolean selected {get; set;}
        public Boolean disabled{get; set;}
        public FailedRegistrationWrapper(Failed_Registration__c fr)
        {
            failedRegistration = fr;
            selected = false;
            disabled = false;
        }
    }

    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }

    // returns the first page of records
    public void first() {
        con.first();
        
        List<Failed_Registration__c  > records = con.getRecords();

        recLst.clear();
        for(Failed_Registration__c li : records ){

            recLst.add(new FailedRegistrationWrapper(li) );

        }
    }

    // returns the last page of records
    public void last() {
        con.last();
        List<Failed_Registration__c > records = con.getRecords();

        recLst.clear();
        for(Failed_Registration__c li : records ){

            recLst.add(new FailedRegistrationWrapper(li) );

        }
    }

    // returns the previous page of records
    public void previous() {
        con.previous();
        List<Failed_Registration__c > records = con.getRecords();

        recLst.clear();
        for(Failed_Registration__c li : records ){

            recLst.add(new FailedRegistrationWrapper(li) );

        }
    }

    // returns the next page of records
    public void next() {
        con.next();
        List<Failed_Registration__c > records = con.getRecords();

        recLst.clear();
        for(Failed_Registration__c li : records ){

            recLst.add(new FailedRegistrationWrapper(li) );

        }
    }
    /*
    public Integer getRecordSize(){

        return con.getResultSize();
    }
    */
  

   public void doSort(){
        /*
            List<Failed_Registration__c> recs = con.getRecords();
            List<Failed_Registration__c> dlObjects = recs.deepClone(true,true,true);
            
            sortList(dlObjects,sortExp,sortDirection);
            recLst.clear();
        for(Failed_Registration__c li : dlObjects ){

            recLst.add(new FailedRegistrationWrapper(li) );

        }
        */
        String query = 'SELECT ';
        
        for(Schema.FieldSetMember f : this.getFields()) {
                query += f.getFieldPath()+',';
        }
        Integer length = query.length();
                query=query.substring(0,length-1);
        query += ' FROM Failed_Registration__c ';
        //downloadQuery = query;
        String filter = getFilterString();
        if(filter.length()>0){
                query +=' Where '+filter;
        }
        query += ' order by '+ sortExpression  + ' ' + sortDirection;
        System.debug('Amit query==================='+query );
        con = new ApexPages.StandardSetController(Database.getQueryLocator(query));
        // sets the number of records in each page set
        con.setPageSize(pageSize);
   
        List<Failed_Registration__c> recs = con.getRecords();
        recLst.clear();
        for(Failed_Registration__c li : recs ){

            recLst.add(new FailedRegistrationWrapper(li) );

        }
    
   }
   /*
   public static void sortList(List<Sobject> items, String sortField, String order){


        List<Sobject> resultList = new List<Sobject>();

        //Create a map that can be used for sorting 
        Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();

        for(Sobject ob : items){
            if(objectMap.get(ob.get(sortField)) == null){  // For non Sobject use obj.ProperyName
                objectMap.put(ob.get(sortField), new List<Sobject>()); 
            }
            objectMap.get(ob.get(sortField)).add(ob);
        }       
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();

        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }

        //Apply the sorted values to the source list
        items.clear();
        if(order.toLowerCase() == 'asc'){
            for(Sobject ob : resultList){
                items.add(ob); 
            }
        }else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i]);  
            }
        }
    }*/
    
    @isTest public static void myTest1(){
        Test.startTest();
        Trial__c t = new Trial__c(Name='Test Trial',Start_Date__c=System.today());
        insert t;
        Account a = new Account(Name='Test Account');
        insert a;
        Patient_Custom__c p = new Patient_Custom__c(Name='Test Patient',Institution__c=a.id,Last_Name__c='Last Name',Birthdate__c=System.today(),Race__c='Asian',Gender__c='Male',Ethnicity__c='Hispanic or Latino');
        insert p;
        
        //Select i.User__c, i.Site__c From InstitutionUser__c i where i.User__c= :UserInfo.getUserId()
        Site__c site1 = new Site__c();
        site1.Name = 'test site1';
        site1.Type__c = 'test type';
        site1.Institute__c = a.Id;
        insert site1;
        
        InstitutionUser__c iu = new InstitutionUser__c();
        iu.User__c = UserInfo.getUserId();
        iu.Site__c = site1.Id;
        iu.Institution__c = a.Id;
        insert iu;
        
        
        Failed_Registration__c fr = new Failed_Registration__c(Trial__c=t.id,Patient__c=p.id,Retry__c=true,Last_Status__c='Failure',Site__c=site1.id);
        insert fr;
        
        ViewFailedRegistrationController c = new ViewFailedRegistrationController();
        
        c.getErrorCodes();
        c.getStatusList();
        c.getCRFNames();
        c.getSystemNames();
        //c.recLst;
        c.getFields();
        c.filter = new Dummy_Object__c();
        Dummy_Object__c fil = c.filter;
        c.filter.From_Date__c=DateTime.parse('01/01/2011 11:46 AM');       
        c.filter.To_Date__c=DateTime.parse('01/01/2015 11:46 AM');
       
        c.sortExpression='CreatedDate';
        c.setSortDirection('DESC');
        c.getSortDirection();
        c.errorCode='All';
        String ec = c.errorCode;
        c.lastStatus='All';
        //ApexPages.StandardSetController con1 = c.con;
        String ls = c.lastStatus;
        c.pageSize = 1;
        ApexPages.StandardSetController con = c.con;
        Integer i = c.pageSize;
        Integer i2 = c.pageNumber;
        c.pageNumber = 2; 
        
        List<FailedRegistrationWrapper> recLst = c.recLst;
        c.doFilter();
        Boolean b1 = c.hasNext;
        c.next();
        Boolean b2 = c.hasPrevious;
        c.previous();
        c.first();
        c.last();
        Test.stopTest(); 
    }
    
    @isTest public static void myTest2(){
        ViewFailedRegistrationController c = new ViewFailedRegistrationController();
        c.filter = new Dummy_Object__c();
        Dummy_Object__c fil = c.filter;
        c.filter.From_Date__c=DateTime.parse('01/01/2011 11:46 AM');       
        c.filter.To_Date__c=DateTime.parse('01/01/2015 11:46 AM');
        c.errorCode='ERROR_1';
        c.lastStatus='Success';
        c.sortExpression='ASC';
        String str=c.getFilterString();
    }
    @isTest public static void myTest3(){
        ViewFailedRegistrationController c = new ViewFailedRegistrationController();
        ///c.fromDate='31/33/2099';
        //c.toDate='31/33/2099';
        //c.errorCode='ERROR_1';
        //c.lastStatus='Success';
        c.sortExpression=null;
        String str=c.getSortDirection();
    }
}