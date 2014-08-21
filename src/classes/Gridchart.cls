public with sharing class Gridchart implements IChart {
    
    public Gridchart() {
    
    }
    public Widget__c getwidget;
    public String getData(Widget__c widget) {
        getwidget = widget;
        String data ='' ;
        if (widget.query__c != null) {
            String query = widget.query__c;
            if (widget.Data_Limit__c != null) {
                query += ' limit '+ widget.Data_Limit__c;
            }
            List<String> fields = new List<String>();
           if (widget.Chart_Display_Fields__c != null) {
                fields = String.valueOf(widget.Chart_Display_Fields__c).split(',');
                data = getFieldsData(fields);
            }
            
            if (widget.Chart_Fields__c != null) {
                fields = String.valueOf(widget.Chart_Fields__c).split(',');
                
                if (widget.Chart_Display_Fields__c == null) {
                    data = getFieldsData(fields);
                }
            } 
           
            if(widget.query_type__c != null){ 
                if(widget.query_type__c == 'Normal'){
                //system.assert(false, Database.query(query)+'@@@@@@');
                    for (Sobject sobj : Database.query(query)) {
                        integer i = 0;
                        String str = '';
                        for (String field : fields ) {
                            if ( i == 0) {
                                if(field.contains('.')){
                                    string [] arr = field.split('\\.');
                                    sobject obj = sobj.getSObject(arr[0].trim() );
                                    If(obj.get(arr[1].trim()) != null && String.valueOf(obj.get(arr[1].trim())).contains('__c')){
                                        String type =  String.valueOf(obj.get(arr[1].trim())).replace('__c','');
                                        String type1 = type.replace('_',' ');
                                        str += '[' + '\'' +type1+'\'' + ',';
                                    }
                                    else{
                                         str += '[' + '\'' +obj.get(arr[1].trim())+'\'' + ',';    
                                    }
                                }
                                else{
                                    if(sobj.get(field.trim()) != null && String.valueOf(sobj.get(field.trim())).contains('__c')){
                                        String type =  String.valueOf(sobj.get(field.trim())).replace('__c','');
                                        String type1 = type.replace('_',' ');
                                        str += '[' + '\'' + type1 + '\'' + ','  ;
                                    }
                                    else{
                                        str += '[' + '\'' + String.valueOf(sobj.get(field.trim())) + '\'' + ','  ;    
                                    }
                                }
                            }
                            else if(i+1 == fields.size()) {
                                if(field.contains('.')){
                                    string [] arr = field.split('\\.');
                                    sobject obj = sobj.getSObject(arr[0].trim() );
                                     If(obj.get(arr[1].trim()) != null && String.valueOf(obj.get(arr[1].trim())).contains('__c')){
                                        String type =  String.valueOf(obj.get(arr[1].trim())).replace('__c','');
                                        String type1 = type.replace('_',' ');
                                        str +='\'' +type1+'\'' + '],';
                                    }
                                    else{
                                         str += '\'' +obj.get(arr[1].trim())+'\'' + '],';    
                                    }
                                }
                                else{
                                   if(sobj.get(field.trim()) != null && String.valueOf(sobj.get(field.trim())).contains('__c')){
                                        String type =  String.valueOf(sobj.get(field.trim())).replace('__c','');
                                        String type1 = type.replace('_',' ');
                                        str +=  '\'' + type1 + '\'' + '],'  ;
                                    }
                                    else{
                                        str += '\'' + String.valueOf(sobj.get(field.trim())) + '\'' + '],'  ;    
                                    }
                                }
                            }
                            
                            else{
                                if(field.contains('.')){
                                    string [] arr = field.split('\\.');
                                    sobject obj = sobj.getSObject(arr[0].trim() );
                                    If(obj.get(arr[1].trim()) != null && String.valueOf(obj.get(arr[1].trim())).contains('__c')){
                                        String type =  String.valueOf(obj.get(arr[1].trim())).replace('__c','');
                                        String type1 = type.replace('_',' ');
                                        str +=  '\'' +type1+'\'' + ',';
                                    }
                                    else{
                                         str += '\'' +obj.get(arr[1].trim())+'\'' + ',';    
                                    }
                                }
                                else{
                                    if(sobj.get(field.trim()) != null && String.valueOf(sobj.get(field.trim())).contains('__c')){
                                        String type =  String.valueOf(sobj.get(field.trim())).replace('__c','');
                                        String type1 = type.replace('_',' ');
                                        str +=  '\'' + type1 + '\'' + ','  ;
                                    }
                                    else{
                                        str +=  '\'' + String.valueOf(sobj.get(field.trim())) + '\'' + ','  ;    
                                    }
                                }        
                                
                            }
                            i ++;
                        }
                        data  += str;     
                    }
                }
                else{
                    //system.assert(false,Database.query(query));
                    for (AggregateResult ar : Database.query(query)) {
                        integer i = 0;
                        String str = '';
                        for (String field : fields ) {
                            
                            if ( i == 0) {
                                if(ar.get(field.trim()) != null && String.valueOf(ar.get(field.trim())).contains('__c')){
                                    String type =  String.valueOf(ar.get(field.trim())).replace('__c','');
                                    String type1 = type.replace('_',' ');
                                    str += '[' +  '\''+type1 + '\''  ;
                                }
                                else{
                                    str += '[' +  '\''+ar.get(field.trim()) + '\''  ;
                                }
                            }
                            else if(i+1 == fields.size()) {
                                 if(ar.get(field.trim()) != null && String.valueOf(ar.get(field.trim())).contains('__c')){
                                     String type =  String.valueOf(ar.get(field.trim())).replace('__c','');
                                     String type1 = type.replace('_',' ');
                                     str +=  ',' +type1 + '],' ;
                                 }
                                else{
                                    str +=  ',' +String.valueOf(ar.get(field.trim())) + '],' ;    
                                }    
                            }
                            else{
                                if(ar.get(field.trim()) != null && String.valueOf(ar.get(field.trim())).contains('__c')){
                                     String type =  String.valueOf(ar.get(field.trim())).replace('__c','');
                                     String type1 = type.replace('_',' ');
                                     str +=  ',' +type1 ;
                                 }
                                else{
                                    str +=  ',' +String.valueOf(ar.get(field.trim()));    
                                } 
                            }
                           
                            i ++;
                        }
                        data  += str;     
                    }
                  
                }
            }
        }
        
        data = data.removeEnd(',');
        return data;
    }
    
    string getFieldsData(List<String> fields) {
        integer j = 0;
        String data = '';
        for (string field :fields){
            if ( j == 0) {
                data += '[' + '\'' + field + '\'' + ','  ;
            }
            else if(j+1 == fields.size()) {
                data +=  '\'' + field + '\'' + '],';
            }
            else{
                data +=  '\'' + field + '\'' +',' ;
            }
            j++ ;
        }
        return data;
    }
    
}