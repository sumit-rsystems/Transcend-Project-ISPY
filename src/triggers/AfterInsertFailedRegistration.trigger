trigger AfterInsertFailedRegistration on Failed_Registration__c (after insert) {
    
    for(Failed_Registration__c fr : Trigger.new){
        Failed_Registration__c f = [Select CRF_Name__c,Error_Code__c,Last_Error_Message__c,Patient__r.Name,Trial__r.Name,Site__r.Name, CreatedDate,CreatedBy.Name from Failed_Registration__c where id=:fr.Id];
        EmailNotification.sendEmail(f.Patient__r.Name, f.Trial__r.Name, f.Site__r.Name, f.CRF_Name__c, String.valueOf(f.CreatedDate), f.CreatedBy.Name, f.Error_Code__c, f.Last_Error_Message__c);
    }
}