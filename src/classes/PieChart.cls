public with sharing class PieChart implements IChart {
    
    public PieChart() {
    
    }
    /*
    ['Task', 'Hours per Day'],
          ['Work',     11],
          ['Eat',      2],
          ['Commute',  2],
          ['Watch TV', 2],
          ['Sleep',    7]
    */
   public String getData(Widget__c widget) {
       System.debug('^^^^^^^^^^^^^^^^^^^^^^^^'+widget);
        String data = '' ;
        try {
        List<Widget__c> childw = [select id from Widget__c where parent__c = :widget.Id];
        
        if (widget.query__c != null) {
            String query = widget.query__c;
            if (widget.Data_Limit__c != null) {
                query += ' limit '+ widget.Data_Limit__c;
            }
            List<String> fields = new List<String>();
            if (widget.Chart_Fields__c != null) {
                fields = String.valueOf(widget.Chart_Fields__c).split(',');
                data = getFieldsData(fields );
            }
            if(childw.size()>0)
              data += '[\'\',0],';
          
            if(widget.query_type__c != null){ 
                if(widget.query_type__c == 'Normal'){
                    for (Sobject sobj : Database.query(query)) {
                        integer i = 0;
                        String str = '';
                      
                        for (String field : fields ) {
                             if ( i == 0) {
                                if(field.contains('.')){
                                    string [] arr = field.split('\\.');
                                    sobject obj = sobj.getSObject(arr[0].trim() );
                                    str += '[' + '\'' + obj.get(arr[1].trim()  ) +'\'';
                                }
                                else{
                                    str += '[' + '\'' + sobj.get(field.trim()) + '\''  ;
                                }
                            }
                            else {
                                if(field.contains('.')){
                                    string [] arr = field.split('\\.');
                                    //system.assert(false,arr[0].trim().length());
                                    sobject obj = sobj.getSObject( arr[0].trim());
                                     if(childw.size()>0){
                                   str +=   ',{v:' + obj.get(arr[1].trim()) + ',f:\''+obj.get(widget.Drill_Down_Field__c)+ 

'\'}],';
                               }
                               else
                                    str += ', ' + obj.get( arr[1].trim()) + '],';
                                }
                                
                                else{
                                     if(childw.size()>0){
                                   str +=   ',{v:' + sobj.get(field.trim()) + ',f:\''+sobj.get

(widget.Drill_Down_Field__c)+ '\'}],';
                                   }
                                   else
                                    str +=   ', ' + sobj.get(field.trim())  + '],';
                                }
                            }
                            i ++;
                        }
                        data  += str;     
                    }
                }
                else{
                    //System.assert(false,query);
                    for (AggregateResult ar : Database.query(query)) {
                   
                        String str = '';
                        integer i = 0;
                        for (String field : fields ) {
                            if ( i == 0) {
                                str += '[' +  '\''+ ar.get(field.trim())+ '\''  ;
                            }
                            else {
                               if(childw.size()>0){
                                   str +=   ',{v:' + ar.get(field.trim()) + ',f:\''+ar.get(widget.Drill_Down_Field__c)+ 

'\'}],';
                               }
                               else
                                   str +=  ',' + ar.get(field.trim())+ '],' ;
                            }
                           
                            i ++;
                        }
                        data  += str;     
                    }
                  
                }
            }
        }
        //if(childw.size()>0)
        
           
        data = data.removeEnd(',');
        }
        catch(Exception e) {
            throw e;
        }
        return data;
    }
    
    string getFieldsData(List<String> fields) {
        integer j = 0;
        String data = '';
        for (string field :fields){
            if ( j == 0) {
                data += '[' + '\'' + field + '\'' + ','  ;
            }
            else {
                data +=  '\'' + field + '\'' + '],';
            }
            j++ ;
        }
        return data;
    }
    
}