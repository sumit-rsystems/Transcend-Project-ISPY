public without sharing class SubjectIdGenerator {
    public static String generateISPYSubjectId() {
        
        Set<String> setSubjId = new Set<String>();
        List<Registration__c> lstRegistration = [Select r.ISPY2_Subject_Id__c, r.Effective_Time__c From Registration__c r where ISPY2_Subject_Id__c != null ];
        for(Registration__c reg : lstRegistration) {
            setSubjId.add(reg.ISPY2_Subject_Id__c);
        }
        String subjectId = getRandomNumber();
        while(setSubjId.contains(subjectId)) {
            subjectId = getRandomNumber();
        }
        
        /*if(subjectId != null) {
            
            if(subjectId.length() == 1) {
                subjectId = '0000'+subjectId;
            } else if(subjectId.length() == 2) {
                subjectId = '000'+subjectId;
            } else if(subjectId.length() == 3) {
                subjectId = '00'+subjectId;
            } else if(subjectId.length() == 4) {
                subjectId = '0'+subjectId;
            }
            
            system.debug('subjectId : '+subjectId);
        }*/
        
        system.debug('subjectId : '+subjectId);
        return subjectId;
    }
    
    public static String getRandomNumber() {
        Integer ranInt = crypto.getRandomInteger();
        ranInt = Math.abs(ranInt);
        String ranString = String.valueOf(ranInt);
        system.debug('ranString : '+ranString);
        
        if(ranString.length() == 1) {
            ranString = '0000'+ranString;
        } else if(ranString.length() == 2) {
            ranString = '000'+ranString;
        } else if(ranString.length() == 3) {
            ranString = '00'+ranString;
        } else if(ranString.length() == 4) {
            ranString = '0'+ranString;
        } else if(ranString.length() > 5) {
            ranString = ranString.substring(0, 5);
        }
        
        return ranString;   
    }
    
    @isTest public static void unitTest() {
        //SubjectIdGenerator.generateISPYSubjectId();
        SubjectIdGenerator.generateISPYSubjectId();     
    }
}