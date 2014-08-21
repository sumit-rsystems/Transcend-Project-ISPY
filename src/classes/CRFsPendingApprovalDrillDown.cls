Public with sharing class CRFsPendingApprovalDrillDown{
    Public String data{get;set;}
    public void getData() {
        data =  '[\'Phase\',\' CRF Type\',\'CRF completion date\',\'Subject ID\'],';
        String drilldownfiled = ApexPages.CurrentPage().getParameters().get('drilldown');
        /*List<String> phases = drilldownfiled.split(',');
        String condition = 'and Phase__c in (\'';
        for(String s : phases )
            condition += s+'\',';
        condition  = condition.subString(0,condition.length()-1)+')';
        System.assert(false,condition );*/
        List<CRF__c> patients  = new List<CRF__c>();
        if(drilldownfiled != '')
            patients = Database.query('select Type__c ,Phase__c,Complete_Date__c,Patient__r.Name from CRF__c where Status__c = \'Approval Pending\' and Complete_Date__c != null and Type__c != null and Phase__c != null and Phase__c = \''+drilldownfiled+'\'Order By Complete_Date__c');
        else
            patients = Database.query('select Type__c ,Phase__c,Complete_Date__c,Patient__r.Name from CRF__c where Status__c = \'Approval Pending\' and Complete_Date__c != null and Type__c != null and Phase__c != null Order By Complete_Date__c ');
        integer count=1;
        for(CRF__c c : patients ){
             String type  = c.Type__c.replace('__c','');
             String type1 = type.replace('_',' ');
            if(count == patients .size())
                data += '[\''+c.Phase__c+'\',\''+type1  +'\',\''+c.Complete_Date__c+'\',\''+c.Patient__r.Name+'\']';
            else    
                data += '[\''+c.Phase__c+'\',\''+type1   +'\',\''+c.Complete_Date__c+'\',\''+c.Patient__r.Name+'\'],';   
            count++;     
        }
        
    }
    
    public CRFsPendingApprovalDrillDown(){
        getData();
    
    }    
}