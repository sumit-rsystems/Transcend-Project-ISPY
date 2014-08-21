trigger MenopausalStatusDetail on Menopausal_Status_Detail__c (before insert, before update)
 {
    if(Trigger.isUpdate)
    {   
 List<Menopausal_Status_Detail__c> lstRandToShare = new List<Menopausal_Status_Detail__c>();
        set<Id> setCrfIds = new set <Id>();
        for(Menopausal_Status_Detail__c random : Trigger.new)
         {
           if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c)
            {
            lstRandToShare.add(random);   
           }
                }
       SharingManager.shareObjectWithSite(lstRandToShare, 'Menopausal_Status_Detail__c', 'Site');
       }
}