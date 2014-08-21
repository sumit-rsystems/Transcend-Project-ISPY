trigger MRIVolumeBeforeTrigger on MRI_Volume__c (before insert,before update) 
{
    if(Trigger.isUpdate)
     {
        List<MRI_Volume__c> lstRandToShare = new List<MRI_Volume__c>();
        set<Id> setCrfIds = new set <Id>();
        for(MRI_Volume__c random : Trigger.new)
         {
           if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c)
            {
            lstRandToShare.add(random);  
           }
       }
       SharingManager.shareObjectWithSite(lstRandToShare, 'MRI_Volume__c', 'Site');
       }
}