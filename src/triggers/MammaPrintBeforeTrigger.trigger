trigger MammaPrintBeforeTrigger on MammaPrintDetail__c (before update)
{
    if(Trigger.isUpdate)
     {
       List<MammaPrintDetail__c> lstRandToShare = new List<MammaPrintDetail__c>();
   // ---  set<Id> setCrfIds = new set <Id>();
       for(MammaPrintDetail__c random : Trigger.new)
         {
           if(!Trigger.oldMap.get(random.Id).First_Save_and_Close__c && random.First_Save_and_Close__c)
               {
                lstRandToShare.add(random);
               } 
         }
      //------------------------- Sharing only with Lab USers ----------------------------------   
      SharingManager.shareObjectWithSite(lstRandToShare, 'MammaPrintDetail__c', 'Lab');
   }
}