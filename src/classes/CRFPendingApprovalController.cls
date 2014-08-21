public with sharing Class CRFPendingApprovalController{
    public String data{get;set;}
    public CRFPendingApprovalController(){
        data= '[\'Phase\',';  
        Map<String, List<String>> mapData = new Map<String, List<String>>();
        List<String> type = new List<String>();
        List<AggregateResult> patients = [SELECT count(Patient__c) countPatient, Phase__c phase, Type__c type FROM CRF__c where Status__c = 'Approval Pending' group by Phase__c, Type__c];
        for(AggregateResult ag : patients){
            if(!mapData.containsKey(String.valueOf(ag.get('phase')))){
                mapData.put(String.valueOf(ag.get('phase')), new List<String>());
            }
            mapData.get(String.valueOf(ag.get('phase'))).add(String.valueOf(ag.get('type'))+'###'+String.valueOf(ag.get('countPatient')));       
            type.add(String.valueOf(ag.get('type')));
        }
        type.sort();
        for(String tp : type){
            String type1 = tp.replace('__c','');
            String type2 = type1.replace('_',' ');
            data += '\''+type2+'\',';
        }
        data = data.subString(0,data.length()-1)+'],';
       
        for(String mp : mapData.keySet()){
            data += '[\''+mp+'\',';
            List<String> types = mapData.get(mp);
            types.sort();
            Integer count = type.size();
            for(String st : types){
                List<String> split = st.split('###');
                data += split[1]+',';
                count--;
            }
            for(Integer i=0; i<count; i++)
                data += '0,';
            data  = data.subString(0,data.length()-1)+'],';             
        }
        data = data.subString(0,data.length()-1);
        //System.assert(false,data);
    }
}