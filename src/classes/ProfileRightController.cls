public with sharing class ProfileRightController {
    
    Public List<string> leftselected{get;set;}
    Public List<string> rightselected{get;set;}
    Set<String> profileNames{get;set;}
    Set<string> leftvalues = new Set<string>();
    Set<string> rightvalues = new Set<string>();
    
    Map<String,String> profielNameId = new Map<String,String>();
    private final Profile_Right__c parentId;
    public String widgetId=null; 
    public Set<String> alreadySelected = new Set<String>();
    
    
    public ProfileRightController (ApexPages.StandardController controller){
        this.parentId = (Profile_Right__c)controller.getRecord();
        if(controller.getId()!=null)
            widgetId = [Select Id,widget__c from Profile_Right__c where Id = :controller.getId()].widget__c;
        leftselected = new List<String>();
        rightselected = new List<String>();
        profileNames = new Set<String>();
        List<Profile> profileName = [Select Id ,Name From profile];
        List<Profile_Right__c> profileRight;
        if(controller.getId()!=null)
            profileRight = [Select Id ,Name From Profile_Right__c where widget__c  = :widgetId];
        else
            profileRight = [Select Id ,Name From Profile_Right__c where widget__c  = :parentId.widget__c];
        for(Profile str :profileName ){
            Integer flag = 0;
             for(Profile_Right__c str1 :profileRight ){
                if(str1.Name == str.Name)
                    flag =1;
             }   
             if(flag==0){
                profielNameId .put(str.Name,str.Id);
                leftvalues.add(str.name); 
             }   
        }
        for(Profile_Right__c str1 :profileRight )
            rightvalues.add(str1.Name);
    }
    
    public PageReference selectclick(){
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
        }
        return null;
    }
     
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            profileNames.remove(s);
            leftvalues.add(s);
        }
        return null;
    }
 
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
 
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList){
            options1.add(new SelectOption(s,s));
            profileNames.add(s);
        }
        return options1;
    }
    
    public PageReference Save() { 
        for(String str: leftvalues ){
            Integer i =0;
            for(String st :profielNameId.keySet()){
                if(st==str)
                    i=1;
            }
            if(i==0){
                Profile_Right__c pr;
                if(widgetId==null)
                    pr = [Select Id, Name from Profile_Right__c where widget__c  = :parentId.widget__c And Name =:str];
                else
                    pr = [Select Id, Name from Profile_Right__c where widget__c  = :widgetId And Name =:str];
                delete pr;
            }
        }
        for(String st :profielNameId.keySet()){
            Integer flage =0;
            for(String p :profileNames){
                if(p == st)
                    flage = 1;
            }
            if(flage == 1 ){
                Profile_Right__c pr = new  Profile_Right__c();
                pr.Name = st;
                pr.Profile_Id__c = profielNameId.get(st);
                if(widgetId==null)
                    pr.widget__c = ''+parentId.widget__c;
                else
                    pr.widget__c = ''+widgetId;
                insert pr;
            }
        } 
        if(widgetId==null) 
            return new PageReference('/'+parentId.widget__c);
        else
            return new PageReference('/'+widgetId);
    }
        
}