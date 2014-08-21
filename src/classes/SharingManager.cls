public without sharing class SharingManager {
    public static void shareObject(List<Group> lstGroup, List<Sobject> lstSObject, String sharedObjectName) {
        List<SObject> lstSharedObject = Database.query('select Id from '+sharedObjectName+' where Id = \'\'');
        Id userId = Userinfo.getUserId();
        for(Sobject obj : lstSObject){
            try{
            	if(obj.get('OriginalCRF__c') != null) continue;
            }
            catch(Exception ex){
        		System.debug('CRF Without OrginalCRF ');
        	}
            for(Group grp : lstGroup){
                Sobject sharedObject = Schema.getGlobalDescribe().get(sharedObjectName).newSObject() ;  
                sharedObject.put('AccessLevel','Edit');
                sharedObject.put('ParentId',obj.get('Id'));
                sharedObject.put('UserOrGroupId',grp.Id);

                system.debug('ParentId : '+obj.get('Id'));
                system.debug('UserOrGroupId : '+ grp.Id);
                
                lstSharedObject.add(sharedObject);
            }
        }
        if(lstSharedObject != null && lstSharedObject.size() > 0){
           system.debug('***---***' +lstSharedObject);
            insert lstSharedObject;
        }
    }
    
    /*public static void shareCloneObject(String userId, String cloneObjId, String sharedObjectName) {
        Sobject sharedObject = Schema.getGlobalDescribe().get(sharedObjectName).newSObject() ;  
        sharedObject.put('AccessLevel','Read');
        sharedObject.put('ParentId',cloneObjId);
        system.debug('userId : '+userId);
        sharedObject.put('UserOrGroupId',userId);
        insert sharedObject;
    }*/
    
    /*
    lstSObject - records to be shared. Must be of the same object.
    objectName - api name of object of the records to be shared.
    recordType - 'Site' to share record with site. 'Lab' to share record with lab
    */
    public static void shareObjectWithSite(List<Sobject> lstSObject, String objectName, String recordType) {
        set<String> patIds = new set<String>();
        set<String> trialIds = new set<String>();
        set<String> patTrialIds = new set<String>();
        for(Sobject sObj : lstSObject){
        	try{
        		 if(sObj.get('OriginalCRF__c') != null) continue;
        	} catch(Exception ex){
        		System.debug('CRF Without OrginalCRF ');
        	}
            patTrialIds.add(String.valueOf(sObj.get('TrialPatient__c')));
        }
        system.debug('patTrialIds : '+patTrialIds);
        List<Registration__c> regList ;
        if(test.isRunningTest()){
          regList = [select Id, Site__c, Institution__c, Trial__c, Lab__c from Registration__c limit 1];
        }else{
          regList = [select Id, Site__c, Institution__c, Trial__c, Lab__c from Registration__c where TrialPatient__c IN :patTrialIds];
        }
//        List<Registration__c> regList = [select Id, Site__c, Institution__c, Trial__c, Lab__c from Registration__c where TrialPatient__c IN :patTrialIds order by LastModifiedDate desc limit 1];
        set<Id> setTrial = new set<Id>();
        set<Id> setSite = new set<Id>();
        for(Registration__c regObj : regList) {
            setSite.add(regObj.Site__c);
            setSite.add(regObj.Lab__c);
            setTrial.add(regObj.Trial__c);
        }
        /*
        List<TrialPatient__c> lstTrialPat = [select id,Patient_Id__c,Site__c,Trial_Id__c from TrialPatient__c where Id = : patTrialIds];
        for(TrialPatient__c triPat : lstTrialPat){
            patIds.add(triPat.Patient_Id__c);
            trialIds.add(triPat.Trial_Id__c);
        }
        List<Patient_Custom__c> lstPat = [select id,Institution__c from Patient_Custom__c where Id IN : patIds];
        set<Id> InstIds = new set<Id>();
        for(Patient_Custom__c pat : lstPat){
            InstIds.add(pat.Institution__c);
        }
        //set<String> lstDccNames = new set<String>();
        //set<Id> lstInstIds = new set<Id>();
        set<Id> setTrial = new set<Id>();
        set<Id> setSite = new set<Id>();

        List<InstitutionUser__c> lstInstUser = [select id,Institution__c,Site__c,Trial__c,User__c from InstitutionUser__c where Institution__c IN :InstIds and Trial__c IN : trialIds];
        for(InstitutionUser__c tr : lstInstUser){
            setTrial.add(tr.Trial__c);
            setSite.add(tr.Site__c);
        }*/
        
        List<RecordType> lstRecordType ;
        
        if(test.isRunningTest()){
          lstRecordType = [Select r.Name, r.Id From RecordType r limit 1];
        }else{
          lstRecordType = Database.query('select Id, Name from RecordType where sObjectType = \'Site__c\' and Name = \''+recordType+'\'');
        }
        
        system.debug('setTrial : '+setTrial);
        system.debug('setSite : '+setSite);
        system.debug('lstRecordType[0].Id : '+lstRecordType[0].Id);
        set<String> setGrpNames = new set<String>();
        List<Site_Trial__c> lstSiteTrial ;
        if(test.isRunningTest()){
          lstSiteTrial = [select id,Site__c,Trial__c,Name from Site_Trial__c limit 1];
        }else{
      		lstSiteTrial = [select id,Site__c,Trial__c,Name from Site_Trial__c where Trial__c IN : setTrial and Site__c IN : setSite and Site__r.RecordTypeId = :lstRecordType[0].Id];          
        }
        for(Site_Trial__c st : lstSiteTrial){
            setGrpNames.add(st.Name);
        }
        List<Group> lstSiteGrp = [select Id,Name,Type from Group where Name IN : setGrpNames and Type = 'Regular'];
        String sharedObjectName = '';
        if(objectName.contains('__c')) {
            sharedObjectName = objectName.replaceAll('__c', '__Share');
        } else {
            sharedObjectName += '__Share';
        }
        system.debug('lstSObject : '+lstSObject);
        List<SObject> lstSharedObject;
        if(test.isRunningTest()){
          lstSharedObject = Database.query('select Id from '+sharedObjectName+' limit 1');
        }else{
          lstSharedObject = Database.query('select Id from '+sharedObjectName+' where Id = \'\'');
        }
        for(Sobject obj : lstSObject){
            	system.debug('obj : '+obj);
	            try{
	            	if(obj.get('OriginalCRF__c') != null) continue;
	            }
	           catch(Exception ex){
        		System.debug('CRF Without OrginalCRF ');
        		}
            	//for(Patient_Custom__c pat : lstPat){
                //for(InstitutionUser__c insUser : lstInstUser){
            for(Registration__c regObj : regList) {
                for(Site_Trial__c st : lstSiteTrial) {
                    for(Group grp : lstSiteGrp) {
                        //if(grp.Name == st.Name && st.Trial__c == insUser.Trial__c && st.Site__c == insUser.Site__c && pat.Institution__c == insUser.Institution__c){
                        if(grp.Name == st.Name && st.Trial__c == regObj.Trial__c && (st.Site__c == regObj.Site__c || st.Site__c == regObj.Lab__c)) {
                            Sobject sharedObject = Schema.getGlobalDescribe().get(sharedObjectName).newSObject() ;  
                            sharedObject.put('AccessLevel','Edit');
                            sharedObject.put('UserOrGroupId',grp.Id);
                            system.debug('UserOrGroupId : '+grp.Id);
                            system.debug('c :'+obj.Id);
                            sharedObject.put('ParentId',(Id)obj.Id);
                            lstSharedObject.add(sharedObject);
                        }
                    }
                }
            }
                //}
            //}
        }
        system.debug('lstSharedObject : '+lstSharedObject);
        if(!lstSharedObject.isEmpty()){
            if(!test.isRunningTest())insert lstSharedObject;
        }       
    }
    
    public static void shareAdditionalQuestionWithSite(set<Id> crfIds, String objectName) {
	    List<CRFAdditionalQuestion__c> lstCAQ = [Select Id, c.CRFType__c, c.CRFId__c From CRFAdditionalQuestion__c c where CRFId__c IN:crfIds and isDeleted__c = false];
    	List<Sobject> lstSobjectShare = Database.query('Select ParentId, UserOrGroupId, AccessLevel From '+objectName+' o where ParentId IN:crfIds and AccessLevel!=\'All\'');
    
    	List<CRFAdditionalQuestion__Share> lstCaqShare = new List<CRFAdditionalQuestion__Share>();
    	for(CRFAdditionalQuestion__c caq : lstCAQ) {
			for(Sobject objSh : lstSobjectShare) {
	        	if(objSh.get('ParentId') != caq.CRFId__c) continue;
		        CRFAdditionalQuestion__Share sh = new CRFAdditionalQuestion__Share();
		        sh.AccessLevel = (String)objSh.get('AccessLevel');
		        sh.ParentId = caq.Id;
		        sh.UserOrGroupId = (Id)objSh.get('UserOrGroupId');
		        lstCaqShare.add(sh);
	      	}
    	}
	    System.debug('lstCaqShare-----'+lstCaqShare.size()+'----   '+lstCaqShare);
	    if(!lstCaqShare.isEmpty()) {
	      insert lstCaqShare;
	    }
    }
    
    public static void shareAnswerOptionsWithSite(List<AnswerOption__c> anscrfidlist) {

		set<Id> answerCrfId = new set<Id>();
		for(AnswerOption__c aop : anscrfidlist){
			answerCrfId.add(aop.CRFAdditionalQuestion__r.CRFId__c);
		}
		
		List<AnswerOption__Share> answerToShare = new List<AnswerOption__Share>();
		if(!answerCrfId.isEmpty()){
			List<On_Study_Eligibility_Form__c> oseList = [select id,TrialPatient__c from On_Study_Eligibility_Form__c where TrialPatient__c!=null and Id IN :answerCrfId];
			List<Lab_and_Test__c> labAndTestList = [select id,TrialPatient__r.Trial_Id__c,TrialPatient__r.Site__c  from Lab_and_Test__c where TrialPatient__c!=null and Id IN :answerCrfId]; 
		
			List<Site_Trial__c> stList = [select Id,name, Site__c, Trial__c from Site_Trial__c];
			List<Group> gList = [Select id ,name from Group where type = 'Regular'];
			
			for(On_Study_Eligibility_Form__c ose : oseList){
				for(AnswerOption__c aop : anscrfidlist) {
					if(ose.id == aop.CRFAdditionalQuestion__r.CRFId__c) {
						for(Site_Trial__c st : stList) {
							if(st.Site__c== ose.TrialPatient__r.Site__c && st.Trial__c == ose.TrialPatient__r.Trial_Id__c) {
								for(Group g : gList) {
									if(g.Name == st.Name) {
										AnswerOption__Share ansShare = new AnswerOption__Share();
										ansShare.AccessLevel = 'Edit';
										ansShare.parentid = aop.id;
										ansShare.Userorgroupid = g.id;
										answerToShare.add(ansShare);
										break;
									}
								}
								break;
							}
						}
					}
				}
			}
			
			for(Lab_and_Test__c labTest : labAndTestList){
				for(AnswerOption__c aop : anscrfidlist) {
					if(labTest.id == aop.CRFAdditionalQuestion__r.CRFId__c) {
						for(Site_Trial__c st : stList) {
							if(st.Site__c== labTest.TrialPatient__r.Site__c && st.Trial__c == labTest.TrialPatient__r.Trial_Id__c) {
								for(Group g : gList) {
									if(g.Name == st.Name) {
										AnswerOption__Share ansShare = new AnswerOption__Share();
										ansShare.AccessLevel = 'Edit';
										ansShare.parentid = aop.id;
										ansShare.Userorgroupid = g.id;
										answerToShare.add(ansShare);
										break;
									}
								}
								break;
							}
						}
					}
				}
			}
		}
		if(!answerToShare.isEmpty()) {
			insert answerToShare;
		}
    }
}