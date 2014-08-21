public with sharing class PatientAddController {

    public Patient_Custom__c patientObj{get;set;}
    private Pagereference pageRef{get;set;}
    public String patientId{get;set;}
    public String errorMsg{get;set;}
    public String errorMsgBirthday{get;set;}
    public Boolean isShowError{get;set;}
    public Boolean isLastName{get;set;}
    public Boolean isGender{get;set;}
    public Boolean isBirthday{get;set;}
    public Boolean isRace{get;set;}
    public Boolean isEthnicity{get;set;}
    private Boolean isNameChanged{get;set;}
    private String screenFirstName{get;set;}
    private String screenLastName{get;set;}
    public List<Selectoption> institutions {get;set;}
    public String selectedInstitution{get;set;}
    public boolean userAssociatedWithMultipleInstitute{get;set;}
    public String InstIdVal{get;set;}
    
    public PatientAddController(Apexpages.StandardController std) {
    	InstIdVal = ApexPages.currentPage().getParameters().get('instId');
        errorMsg = '';
        errorMsgBirthday = '';
        isShowError = false;
        isLastName = false;
        isGender = false;
        isBirthday = false;
        isRace = false;
        isEthnicity = false;
        isNameChanged = false;
        userAssociatedWithMultipleInstitute = false;
        patientId = Apexpages.currentPage().getParameters().get('pid');
        system.debug('__patientId__'+patientId);
        if(patientId!=null && patientId!='') {
            patientObj = [Select p.Zip__c, Middle_Name__c , p.Unsigned_Patient_Last_Name__c, p.Unsigned_Patient_First_Name__c, Suffix__c, VIP__c, p.SystemModstamp, p.Surgeon__r.Name, p.Surgeon__c, p.Study_Registration_Eligibility__c, p.Status__c, p.State__c, p.Signed_Screening__c, p.Screen_Failure_Number__c, p.SSN__c, p.RecordTypeId, p.Race__c, p.Primary_MD__r.Name, p.Primary_MD__c, p.Owner.Name, p.OwnerId, p.Name, p.Medical_Record_Number__c, p.Last_Name__c, p.LastModifiedDate, p.LastModifiedBy.Name, p.LastModifiedById, p.LastActivityDate, p.IsDeleted, p.Institution__c, p.Institute_Text__c, p.Id, p.Gender__c, p.First_Name__c, p.Ethnicity__c, p.CreatedDate, p.CreatedBy.Name, p.CreatedById, p.Country_of_Birth__c, p.Country__c, p.City__c, p.Birthdate__c, p.Age__c, p.Address_Line_2__c, p.Address_Line_1__c, RecordType.Name From Patient_Custom__c p where Id = :patientId];
            /*if(patientObj.Signed_Screening__c == false) {
                screenFirstName = patientObj.First_Name__c;
                screenLastName = patientObj.Last_Name__c; 
                patientObj.First_Name__c = patientObj.Unsigned_Patient_First_Name__c;
                patientObj.Last_Name__c = patientObj.Unsigned_Patient_Last_Name__c;
                isNameChanged = true;
            }*/
        }
        else {
            patientObj = new Patient_Custom__c();
            
            //carry over latsname from duplicate search
            String lastname = Apexpages.currentPage().getParameters().get('lastname');
            if(lastname != null && lastname != '') {
                patientObj.Last_Name__c = lastname;
            }
        }
        if(InstIdVal != null) {
        	patientObj.Institution__c = InstIdVal; 
        } else {
	        institutions = new List<Selectoption>();
	        institutions.add(new Selectoption('', '--None--'));
	        //List<InstitutionUser__c> userAssociations = [Select i.User__c, i.OwnerId, i.Name, i.Institution__c,i.Institution__r.Name, i.Id From InstitutionUser__c i where i.User__c = :Userinfo.getUserId()];
	        List<Account> instusr = [Select a.Name, (Select Institution__c From InstitutionUsers__r where User__c = :Userinfo.getUserId()) From Account a where RecordType.Name = 'Institution'];
	        System.debug('__instusr__'+instusr);
	        System.debug('__instusr.size__'+instusr.size());
	        if(instusr.size() > 1) {  
	            userAssociatedWithMultipleInstitute = true;
	            for(Account iu : instusr) {
	                if(iu.InstitutionUsers__r.isEmpty())continue;
	                	Selectoption so = new Selectoption(iu.id, iu.Name);
	                	institutions.add(so);
	            }
	            if(patientObj.Institution__c != null) {
	            	selectedInstitution = patientObj.Institution__c;
	            }
	        }
	        else if(!instusr.isEmpty()) {
	            patientObj.Institution__c = instusr[0].id; 
	            selectedInstitution = instusr[0].id;
	        }  
	      }
    }
    
    public Pagereference redirectPage() {
        String pageStr = Apexpages.currentPage().getParameters().get('paramAtt');
        system.debug('__pageStr__'+pageStr);
        isLastName = false;
        isGender = false;
        isBirthday = false;
        isRace = false;
        isEthnicity = false;
        errorMsg = '';
        errorMsgBirthday = '';
        
        if(pageStr!=null && pageStr!='') {
            if(pageStr=='save') {
                system.debug('__patientObj__'+patientObj);
                Integer flag = 0;
                if(selectedInstitution == null ) {
                	isShowError = true;
                    errorMsg+= 'Please select Institution.<br/>';
                    flag = 1;
                }
                if(patientObj.Birthdate__c == null) {
                    isShowError = true;
                    errorMsg+= 'Please enter birth date <br/>';
                    errorMsgBirthday ='Please enter birth date';
                    isBirthday = true;
                    flag = 1;
                } else if(patientObj.Birthdate__c >= System.today()) {
                    isShowError = true;
                    errorMsg+= 'Please enter birth date less than today\'s date <br/>';
                    errorMsgBirthday ='Please enter birth date less than today\'s date';
                    isBirthday = true; 
                    flag = 1;
                    /*isShowError = true;
                    return null;*/
                }
                
                if(patientObj.Gender__c == null) {
                    isGender = true;
                    flag = 1;
                }
                
                if(patientObj.Race__c == null) {
                    isShowError = true;
                    errorMsg+= 'Please select race in Additional Details <br/>';
                    isRace = true;
                    flag = 1;
                }
                
                if(patientObj.Ethnicity__c == null) {
                    isShowError = true;
                    errorMsg+= 'Please select ethnicity in Additional Details <br/>';
                    isEthnicity = true;
                    flag = 1;
                }
                
                if(patientObj.Last_Name__c == null) {
                    isLastName = true;
                    flag = 1;
                }
                
                if(flag == 1) {
                    return null;
                }
                
                if(patientObj.Last_Name__c!=null && patientObj.Last_Name__c!='') {
                    List<InstitutionUser__c> instUserList = [select Site__c, Institution__c from InstitutionUser__c where User__c =: userInfo.getUserId()];
                    
                    if(patientObj.Primary_MD__c != null || patientObj.Primary_MD__c != '') {
                        List<Contact> contactList = [select Type__c, Site__c, AccountId from Contact where Id =:patientObj.Primary_MD__c];
                        for(Contact tmpContact: contactList) {
                            if(tmpContact.Type__c != 'MD') {
                                if(!instUserList.isEmpty()) {
                                    tmpContact.AccountId = instUserList[0].Institution__c;
                                    tmpContact.Site__c = instUserList[0].Site__c;  
                                }
                                tmpContact.Type__c = 'MD';
                            }
                        }
                        
                        if(!contactList.isEmpty()) {
                            update contactList;
                        }
                    }
                    
                    if(patientObj.Surgeon__c != null || patientObj.Surgeon__c != '') {
                        List<Contact> contactList = [select Type__c, Site__c, AccountId from Contact where Id =:patientObj.Surgeon__c];
                        for(Contact tmpContact: contactList) {
                            if(tmpContact.Type__c != 'Surgeon') {
                                if(!instUserList.isEmpty()) {
                                    tmpContact.AccountId = instUserList[0].Institution__c;
                                    tmpContact.Site__c = instUserList[0].Site__c;  
                                }
                                tmpContact.Type__c = 'Surgeon';
                            }
                        }
                        
                        if(!contactList.isEmpty()) {
                            update contactList;
                        }
                    }
                    if(userAssociatedWithMultipleInstitute) {
                        patientObj.Institution__c = selectedInstitution;
                    }
                    if(patientId!=null && patientId!='') {
                        if(isNameChanged == true) {
                            patientObj.Unsigned_Patient_First_Name__c = patientObj.First_Name__c;
                            patientObj.Unsigned_Patient_Last_Name__c = patientObj.Last_Name__c;
                            patientObj.First_Name__c = screenFirstName;
                            patientObj.Last_Name__c = screenLastName; 
                        }
                        //Added by Amit on 10-Jun-13
                        //GenerateCalloutController c = new GenerateCalloutController();
	                   	//c.submitRegistrationForPatientUpdate(patientObj.id);
	                   	//End Added by Amit
                        update patientObj;                  
                    }
                    else {
                    	RequiredFieldHandler.fromDataLoader = true;
                        insert patientObj;
                    }
                    pageRef = new Pagereference('/apex/TranscendPage?id='+patientObj.Id);
                    pageRef.setRedirect(true);
                } 
                
            }
            else if(pageStr=='cancel') {
                if(patientId!=null && patientId!='') {
                    pageRef = new Pagereference('/apex/TranscendPage?id='+patientObj.Id);
                    pageRef.setRedirect(true);                  
                }
                else {
                    pageRef = new Pagereference('/apex/patientsViewTab');
                    pageRef.setRedirect(true);
                }
                
            }
        }
        return pageRef;
    }
}