public global class ArmWebservice {
    public webservice static boolean createArm(Arm a){
        System.debug('arm------------'+a);
        boolean isCreated = false;
        if(a.name == null || a.name == '' || a.trialName == null || a.trialName == ''){
            return isCreated;
        }else{
            Trial__c tc;
            List<Trial__c> trialList = [Select t.Name, t.Id From Trial__c t where name = :a.trialName];
            if(trialList.isEmpty()){
                tc = new Trial__c();
                tc.Name = a.trialName;
                insert tc;
            }else{
                tc = trialList[0];
            }
            System.debug('new trial------'+tc);
            
            try{
                Arm__c newArm = new Arm__c();
                newArm.Name = a.name;
                newArm.Description__c = a.description;
                newArm.Generic_Name__c = a.genericName;
                newArm.Trial_Id__c = tc.Id;
                insert newArm;
                System.debug('newArm----'+newArm);
                isCreated = true;
            }catch(Exception e){
                System.debug('error----'+e.getMessage());
                isCreated = false;
            }
        }
        return isCreated;
    }
    
    public webservice static List<Arm> getArm(String armName){
        List<Arm__c> armList1;
        List<Arm> armList2;
        if(armName != null && armName != ''){
            armList1 = [Select a.Trial_Id__c, a.Site_Id__c, a.Name, a.Generic_Name__c, a.Description__c From Arm__c a where Name = :armName];
        }else{
            armList1 = [Select a.Trial_Id__c, a.Site_Id__c, a.Name, a.Generic_Name__c, a.Description__c From Arm__c a];
        }
        if(!armList1.isEmpty()){
            Set<Id> trialIdSet = new Set<Id>();
            for(Arm__c arm1 : armList1){
                trialIdSet.add(arm1.Trial_Id__c);
            }
            Map<id,Trial__c> trialMap = new Map<id,Trial__c>([Select t.Name, t.Id From Trial__c t where id IN :trialIdSet]);
            armList2 = new List<Arm>(); 
            for(Arm__c arm1 : armList1){
                Arm arm2 = new Arm();
                arm2.name = arm1.Name;
                arm2.description = arm1.Description__c;
                arm2.genericName = arm1.Generic_Name__c;
                if(!trialMap.isEmpty() && trialMap.get(arm1.Trial_Id__c) != null)arm2.trialName = trialMap.get(arm1.Trial_Id__c).Name;
                armList2.add(arm2);
            }
        }
        return armList2;
    }
    
       @isTest public static void  test1(){
        Account acc = new Account();
        acc.Name = 'testing';
        insert acc;
        
        Site__c st = new Site__c();
        st.Name = 'test Site';
        st.Institute__c = acc.id;
        insert st;
        
        Trial__c tc = new Trial__c(); 
        tc.Name = 'test trial';
        insert tc;
        
        Arm__c am = new Arm__c();
        am.Name = 'testArm';
        am.Description__c = 'testDesc';
        am.Generic_Name__c = 'testName';
        am.Site_Id__c = st.id;
        am.Trial_Id__c = tc.id;
        insert am;
        
        Arm a = new Arm();
        a.name = 'testArm';
        a.description = 'testDesc';
        a.genericName = 'testName';
        a.trialName = 'testTrial';
        
        boolean isSuccessfullyCreated = ArmWebservice.createArm(a);
        List<Arm> armList1 = ArmWebservice.getArm('testArm');
    }
}