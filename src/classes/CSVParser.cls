public with sharing class CSVParser {
    
    public static List<List<String>> parseCSV(String contents,Boolean skipHeaders) {
        List<List<String>> allFields = new List<List<String>>();
    
        // replace instances where a double quote begins a field containing a comma
        // in this case you get a double quote followed by a doubled double quote
        // do this for beginning and end of a field
        system.debug('contents1 : '+contents);
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        system.debug('contents2 : '+contents);
        // now replace all remaining double quotes - we do this so that we can reconstruct
        // fields with commas inside assuming they begin and end with a double quote
        system.debug('contents3 : '+contents);
        contents = contents.replaceAll('""','DBLQT');
        system.debug('contents4 : '+contents);
        // we are not attempting to handle fields with a newline inside of them
        // so, split on newline to get the spreadsheet rows
        List<String> lines = new List<String>();
        try {
            lines = contents.split('\n');
        } catch (System.ListException e) {
            System.debug('Limits exceeded?' + e.getMessage());
        }
        Integer num = 0;
        for(String line : lines) {
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) break;
            
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field : fields) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    system.debug('field1 : '+field);
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                    system.debug('field2 : '+field);
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    system.debug('compositeField1 : '+compositeField);
                    compositeField = field;
                    system.debug('compositeField2 : '+compositeField);
                } else if (field.endsWith('"')) {
                    system.debug('compositeField3 : '+compositeField);
                    compositeField += ',' + field;
                    system.debug('compositeField4 : '+compositeField);
                    cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                }
            }
            
            allFields.add(cleanFields);
        }
        system.debug('allFields : '+allFields);
        if(allFields != null && allFields.size() > 0) {
            if (skipHeaders) allFields.remove(0);
        }
        /*
        for(List<String> fields : allFields) {
            for(String field : fields) {
                field = field.trim();
                system.debug('with dcot field : '+field);
                if(field.startsWith('"') && field.endsWith('"')) {
                    field = field.replaceAll('"', '');
                }
                system.debug('without dcot field : '+field);
            }
        }
        */
        system.debug('allFields : '+allFields);
        for(List<String> lstStr : allFields) {
            system.debug('lstStr : '+lstStr);
        }
        return allFields;       
    }
    
    public static List<List<String>> parseCSV1(String contents,Boolean skipHeaders) {
        List<List<String>> allFields = new List<List<String>>();
    
        // replace instances where a double quote begins a field containing a comma
        // in this case you get a double quote followed by a doubled double quote
        // do this for beginning and end of a field
        //contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        system.debug('before contents : '+contents);
        contents = contents.replaceAll(',', '*COMMA*');
        system.debug('after contents : '+contents);
        // now replace all remaining double quotes - we do this so that we can reconstruct
        // fields with commas inside assuming they begin and end with a double quote
        //contents = contents.replaceAll('""','DBLQT');
        // we are not attempting to handle fields with a newline inside of them
        // so, split on newline to get the spreadsheet rows
        List<String> lines = new List<String>();
        try {
            lines = contents.split('\n');
        } catch (System.ListException e) {
            System.debug('Limits exceeded?' + e.getMessage());
        }
        system.debug('lines : '+lines);
        Integer num = 0;
        for(String line : lines) {
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) break;
            List<String> fields = line.split(',');
            system.debug('fields'); 
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field : fields) {
                field = field.replace('*COMMA*', ',');
                /*system.debug('field : '+field);
                if (field.startsWith('"') && field.endsWith('"')) {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                }*/
                field = field.trim();
                system.debug('with dcot field : '+field);
                system.debug('field last char : '+field.substring(field.length()-1,field.length()));
                system.debug('start dcot contains :'+field.startsWith('"'));
                system.debug('end dcot contains :'+field.endsWith('"'));
                system.debug('end dcot space contains :'+field.endsWith(' '));
                if(field.startsWith('"') && field.endsWith('"')) {
                    field = field.replace('"', '');
                    system.debug('without dcot field : '+field);
                }
                cleanFields.add(field);
            }
            allFields.add(cleanFields);
            system.debug('allFields : '+allFields);
        }
        if(allFields != null && allFields.size() > 0) {
            if (skipHeaders) allFields.remove(0);
        }
        return allFields;       
    }
    
    @isTest static void test(){
        String contents = '1,2,3,4,5,6\n,7,8,9,10,11,12';
        CSVParser.parseCSV(contents, false);
        
        String contents2 = '1,2,3,4,5,6\n,7,8,9,10,11,12';
        CSVParser.parseCSV1(contents2, false);
    }
}