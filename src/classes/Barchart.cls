public with sharing class Barchart implements IChart {
    
    public Barchart() {
    
    }
    
    public String getData(Widget__c widget) {
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
                                    str += '[' +  '\''+ sobj.get(field.trim())+ '\''  ;
                                }
                            }
                            else if ( i+1 == fields.size()) {
                                if(field.contains('.')){
                                    string [] arr = field.split('\\.');
                                    sobject obj = sobj.getSObject(arr[0].trim() );
                                    str += '[' + obj.get(arr[1].trim()  ) + '],';
                                }
                                else{
                                    str +=  ',' + sobj.get(field.trim())+ '],' ;
                                }
                            }
                            else{
                                if(field.contains('.')){
                                    string [] arr = field.split('\\.');
                                    sobject obj = sobj.getSObject(arr[0].trim() );
                                    str += ',' + obj.get(arr[1].trim()  ) ;
                                }
                                else{
                                    str +=  ','+sobj.get(field.trim())  ;
                                }
                            }
                            i ++;
                        }
                        data  += str;     
                    }
                   
                }
                else{
                    for(AggregateResult ar : Database.query(query)) {
                        integer i = 0;
                        String str = '';
                        for (String field : fields ) {
                            
                            if ( i == 0) {
                                str += '[' +  '\''+ ar.get(field.trim())+ '\''  ;
                            }
                            else if ( i+1 == fields.size()) {
                                str +=  ',' + ar.get(field.trim())+ '],' ;
                            }
                            else{
                                str +=  ','+ar.get(field.trim())  ;
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
        String data ='';
        for (string field :fields){
            if ( j == 0) {
                data += '[' + '\'' + field + '\'' + ','  ;
            }
            else if(j+1 == fields.size()){
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