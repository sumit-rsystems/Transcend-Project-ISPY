trigger AddUserRecordWhenInstitutionCerated on Account (after insert) {

    List<InstitutionUser__c> insuserList = new List<InstitutionUser__c>();
    List<RecordType> recType = [select id,Name,SobjectType from RecordType where SobjectType = 'Account' and Name = 'Institution']; 
    List<User> useList = [Select u.Id From User u where (Profile.Name = 'System Administrator' or Profile.Name = 'Developers' or Profile.Name = 'Custom Read Only User') and IsActive = true];
     
    for(Account acc : trigger.new){
        if(acc.RecordTypeId == recType[0].Id){
            for(User us : useList){
                InstitutionUser__c istuser = new InstitutionUser__c();
                istuser.Institution__c = acc.Id;
                istuser.User__c = us.id;
                insuserList.add(istuser);
            }
        }
    }
    if(!insuserList.isEmpty()){ 
        insert insuserList;
    }
}