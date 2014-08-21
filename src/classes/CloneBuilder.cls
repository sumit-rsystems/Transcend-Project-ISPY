public with sharing class CloneBuilder {
	static Map<String,String> keyPrefixMap = new Map<String,String>();
	static {
		system.debug('inside the Clonebuilder Class ----------------->');
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
          system.debug('Schema.SObjectType is ------------------------->'+ gd);
    	for(String id : gd.keySet()){
      		Schema.DescribeSObjectResult r = gd.get(id).getDescribe();
      		keyPrefixMap.put(r.getKeyPrefix(), r.getName());
    	}
    	 system.debug('KeyprefixMap is ------------------------->'+ keyPrefixMap);
	}
	@future
    public static void cloneMeFutureCall(String objectId, String parentId, String lookupFieldName) {
        cloneMe(new Set<String>{objectId}, parentId, lookupFieldName);
    }
    
	public static void cloneMe(Set<String> objectIds, String parentId, String lookupFieldName) {
		/*Map<String,String> keyPrefixMap = new Map<String,String>();
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
          
    	for(String id : gd.keySet()){
      		Schema.DescribeSObjectResult r = gd.get(id).getDescribe();
      		keyPrefixMap.put(r.getKeyPrefix(), r.getName());
    	}*/
    	system.debug('objectIds: '+objectIds);
    	system.debug('parentId: '+parentId);
    	system.debug('LookupFieldName: '+lookupFieldName);
    	
    	String objectTypeKey = new List<String>(objectIds)[0].subString(0,3);
      	String objectTypeName = keyPrefixMap.get(objectTypeKey);
      	system.debug('__objectTypeKey__'+objectTypeKey+'__objectTypeName__'+objectTypeName+', objectIds: '+objectIds);
      	if(objectTypeKey == '02c') {
      		String parentObjectTypeKey = parentId.subString(0,3);
      		String parentObjectTypeName = keyPrefixMap.get(parentObjectTypeKey);
      		if(parentObjectTypeName.endsWith('__c')) {
				objectTypeName = parentObjectTypeName.replaceAll('__c', '__Share');
			} else {
				objectTypeName = parentObjectTypeName + 'Share';
			}
      	}
	if(objectTypeName == null || objectTypeName == 'UserProfileFeed') return;
		String primaryObjectQueryString = 'SELECT Id FROM '+ objectTypeName+' WHERE Id IN :objectIds';
		system.debug('__objectTypeName.endsWith__'+objectTypeName.endsWith('__Share'));
		if(objectTypeName.endsWith('__Share')) {
			system.debug('__Share__');
			primaryObjectQueryString = 'SELECT Id FROM '+ objectTypeName+' WHERE Id IN :objectIds and AccessLevel!=\'All\'';
		}
    	system.debug('__primaryObjectQueryString__'+primaryObjectQueryString);
    	List<SObject> headSObject = Database.query(primaryObjectQueryString);
    	if(headSObject != null && !headSObject.isEmpty()) {
	    	
	    	//List<Sobject> cloneObjs = cloneObjects(headSObject);
	    	Map<Id, SObject> dbIdClonedObj = cloneObjects(headSObject);
	    	List<Sobject> cloneObjs = dbIdClonedObj.values();
	    	system.debug('In the clone object after getting out fo the clone method()'+cloneObjs[0]);
	    	system.debug('cloneObjs[0]: '+cloneObjs[0]);
	    	system.debug('Parent Id of the clone object'+parentId);
	    	
	    	if(parentId != '0') {
		    	for(Sobject cObj : cloneObjs) {
		    		cObj.put(lookupFieldName, parentId);
		    	}
	    	} else if(parentId == '0'){
	    		for(Sobject cObj : cloneObjs) {
		    		cObj.put('OriginalCRF__c', new List<String>(objectIds)[0]); //first element of set because first time set contians always only one element 
		    		cObj.put('Status__c', 'Cloned');
		    		//cObj.put('OwnerId', Userinfo.getUserId());
                    cObj.put('Effective_Time__c', null); //Value is null because if Effective_Time__c will be null then only workflow will copy createdDate in Effective_Time__c field.
		    	}
	    	}
	    	system.debug('cloneObjs : '+cloneObjs);
	    	try {
	    		/*if(objectTypeName == 'AE_Detail__Share') {
	    			system.debug('cloneObjs[0]: '+cloneObjs[0]);
	    			insert cloneObjs[0];
	    			system.debug('cloneObjs[1]: '+cloneObjs[1]);
	    			insert cloneObjs[1];
	    		} else {*/
					insert cloneObjs;
	    		//}
				if(objectTypeName == 'On_Study_Eligibility_Form__c' || objectTypeName == 'Lab_and_Test__c') {
	        		system.debug('Query: Select Id From CRFAdditionalQuestion__c c where CRFId__c IN :objectIds and isDeleted__c = false');
	        		Map<String, Sobject> mapCRFAdditionalQuestion = new Map<String, Sobject>(Database.query('Select Id From CRFAdditionalQuestion__c c where CRFId__c IN :objectIds and isDeleted__c = false'));
	        		if(!mapCRFAdditionalQuestion.keySet().isEmpty()) {
		        		cloneAdditionQuestion(mapCRFAdditionalQuestion.keySet(), cloneObjs[0].Id, 'CRFId__c');
	        		}
					/*for (SObject childObject : Database.query('Select Id From CRFAdditionalQuestion__c c where CRFId__c IN :objectIds')) {
		        		cloneAdditionQuestion(childObject.Id, cloneObjs[0].Id, 'CRFId__c');
		        	}*/
				}
	    	} catch(Exception e) {
	    		system.debug('Exception : '+e);
	    		/*if(objectTypeName.endsWith('__Feed')) {
					system.debug('primaryObjectQueryString: '+primaryObjectQueryString);
					return;
				}*/
	    	}
			system.debug('parentId1:'+parentId);
			integer index  = 0;
			
			Schema.DescribeSObjectResult headDescribe = headsObject[0].getSObjectType().getDescribe();
		    List<Schema.ChildRelationship> childRelationships = headDescribe.getChildRelationships();
		    
			//for(String objId : objectIds) {
				
				//system.debug('headsObject.getSObjectType() : '+headsObject.getSObjectType()+'  childRelationships : '+childRelationships);
				for (Schema.ChildRelationship childRelationship : childRelationships) {
		    		Schema.SObjectType childObjectType = childRelationship.getChildSObject();
		    		//system.debug('childObjectType : '+childObjectType);
		    		Schema.SObjectField childObjectField = childRelationship.getField();
		    		/*String relatedChildSObjectsquery = 'SELECT ID FROM ' 
					             + childObjectType.getDescribe().getName()
					             + ' WHERE '
					             + childObjectField.getDescribe().getName()
					             + ' = \'' 
					             + headsObject[0].Id
					             + '\''; */
					String childObjectTypeName = childObjectType.getDescribe().getName();
					system.debug('childObjectTypeName:'+childObjectTypeName);
					 
		        	try {
		        		if(childObjectField.getDescribe().getName() != 'OriginalCRF__c' && 
	                        childObjectTypeName != 'NoteAndAttachment' &&
	                        childObjectTypeName != 'EntitySubscription' &&
	                        childObjectTypeName != 'Note' &&
	                        childObjectTypeName != 'ProcessInstanceHistory' &&
	                        childObjectTypeName != 'UserProfileFeed' &&
	                        childObjectTypeName != 'ProcessInstance' &&
	                        childObjectTypeName != 'FeedComment' &&
	                        childObjectTypeName != 'FeedPost' &&
	                        childObjectTypeName != 'NewsFeed' &&
	                        childObjectTypeName != 'ActivityHistory' &&
	                        childObjectTypeName != 'OpenActivity' &&
	                        childObjectTypeName != 'FeedSubscriptionsForEntity' &&
	                        childObjectTypeName != 'ContentDocumentFeed' && 
	                        childObjectTypeName != 'Attachment' &&
	                        childObjectTypeName != 'FeedLike' &&
	                        childObjectTypeName != 'FeedItem' &&
	                        childObjectTypeName != 'ContentDocument' &&
	                        childObjectTypeName != 'FeedTrackedChange' &&
	                        childObjectTypeName != 'ContentDocumentLink' && 
	                        childObjectTypeName != 'ContentVersion' && 
	                        childObjectTypeName != 'ContentDocumentHistory' &&
	                        childObjectTypeName != 'AnswerOption__Share' &&
	                        childObjectTypeName != 'Toxicity__Share' &&
	                        childObjectTypeName != 'CTCAE_Code__c' &&
	                        //!childObjectTypeName.endsWith('__share') &&
	                        !childObjectTypeName.endsWith('__Feed')) {
	                        	
	                        	String parentFieldName = childObjectField.getDescribe().getName(); 
	                        	
	                        	String relatedChildSObjectsquery = 'SELECT ID,'+parentFieldName+' FROM '+ childObjectTypeName+ ' WHERE '
				             			+parentFieldName  + ' IN :objectIds ';
				             			
	                        	system.debug('__relatedChildSObjectsquery__'+relatedChildSObjectsquery);
	                        	Map<String, Sobject> mapSobject = new Map<String, Sobject>(Database.query(relatedChildSObjectsquery));
	                        	system.debug('__cloneObjs__'+cloneObjs);
	                        	system.debug('__cloneObjs['+index+'].Id__'+cloneObjs[index].Id);
	                        	if(!mapSobject.keySet().isEmpty()) {
	                        		//system.debug('childName:'+childName); 
	                        		system.debug('childObjectType:'+childObjectType+':'+childObjectTypeName); 
			            			system.debug('objectTypeName123'+objectTypeName);
			            			//system.debug('dbIdClonedObj.get(objId).Id:'+dbIdClonedObj.get(objId).Id);
		            				if(objectTypeName == 'Post_Surgaory_Summary__c' && childObjectTypeName == 'Lymph_Nodes__c'){
		                        		//skip this parent child combination as it creates duplicate lymph nodes because
		                        		//lymph nodes also have procedure as their parent
		            				} else {
		            					
		            					List<SObject> childrenRecords = mapSobject.values();
		            					Set<String> childrenToClone = new Set<String>();
		            					Map<String, Set<String>> clonedParentChildMap = new Map<String, Set<String>>();
		            					for(SObject child : childrenRecords) {
		            						String dbParentId = String.valueOf(child.get(parentFieldName));
		            						system.debug('dbParentId:'+dbParentId);
		            						String childId = String.valueOf(child.get('Id'));
		            						system.debug('childId:'+childId);
		            						if(clonedParentChildMap.containsKey(dbParentId)) {
		            							clonedParentChildMap.get(dbParentId).add(childId);
		            						} else {
		            							Set<String> childrenIds = new Set<String>();
		            							childrenIds.add(childId);
		            							clonedParentChildMap.put(dbParentId, childrenIds);
		            						}
		            					}
		            					for(Id dbParentId : clonedParentChildMap.keySet()) {
		            						system.debug('dbParentId:'+dbParentId+' Number of children:'+clonedParentChildMap.get(dbParentId).size());
		            						//cloneMe(mapSobject.keySet(), dbIdClonedObj.get(objId).Id, childObjectField.getDescribe().getName());
		            						cloneMe(clonedParentChildMap.get(dbParentId), dbIdClonedObj.get(dbParentId).Id, childObjectField.getDescribe().getName());
		            					}
		            				}
	                        	}
				        		/*for (SObject childObject : Database.query(relatedChildSObjectsquery)) {
					        		system.debug('relatedChildSObjectsquery : '+relatedChildSObjectsquery);
					        		cloneMe(childObject.Id, cloneObjs[0].Id, childObjectField.getDescribe().getName());
					        	}*/
				        }
			        } catch(Exception e) {
		    			system.debug('Exception : '+e);
		    			if(parentId == '0' && childObjectTypeName == 'FeedItem'){
		    				system.debug('____Exception____');
		    				return;
		    			}
		    		}
				}
				index++;
			//}
    	}
		//return null;
	}

	// Clone a list of objects to a particular object type
  	// Parameters 
  	// - List<sObject> sObjects - the list of objects to be cloned 
  	// The sObjects you pass in must include the ID field, 
  	// and the object must exist already in the database, 
  	// otherwise the method will not work.
  	public static Map<Id,SObject> cloneObjects(List<sObject> sObjects){
                                                
	    Schema.SObjectType objectType = sObjects.get(0).getSObjectType();
	    system.debug('inside the clone object method------------------------->CloneBuilder Class '+objectType);
	    // A list of IDs representing the objects to clone
	    List<Id> sObjectIds = new List<Id>{};
	     system.debug('A list of IDs representing the objects to cloneCloneBuilder Class '+sObjectIds);
	    // A list of fields for the sObject being cloned
	    List<String> sObjectFields = new List<String>{}; system.debug('A list of fields for the sObject being cloned '+sObjectFields);
	    // A list of new cloned sObjects
	    List<sObject> clonedSObjects = new List<sObject>{};
	    system.debug('A list of new cloned sObjects '+clonedSObjects);
	    // Get all the fields from the selected object type using 
	    // the get describe method on the object type.
	    if(objectType != null) {
	      sObjectFields.addAll(objectType.getDescribe().fields.getMap().keySet());
	    }
	      system.debug('Get all the fields from the selected object type using the get describe method on the object type. '+sObjectFields);
	    Map<Id,SObject> dbIdCloneObj = new Map<Id,SObject>();
	    
	    // If there are no objects sent into the method, 
	    // then return an empty list
	    if (sObjects != null || sObjects.isEmpty() || sObjectFields.isEmpty()){
			
			// Strip down the objects to just a list of Ids.
	      	for (sObject objectInstance: sObjects){
	        	sObjectIds.add(objectInstance.Id);
	      	}
	
	      	/* Using the list of sObject IDs and the object type, 
	        we can construct a string based SOQL query 
	        to retrieve the field values of all the objects.*/
	    
	      	String allSObjectFieldsQuery = 'SELECT ' + sObjectFields.get(0); 
	          system.debug('Using the list of sObject IDs and the object type, we can construct a string based SOQL query   to retrieve the field values of all the objects. '+allSObjectFieldsQuery);
	
	      	for (Integer i=1 ; i < sObjectFields.size() ; i++) {
	      		/*if(objectType.getDescribe().getName() == 'FeedItem') {
  					system.debug('sObjectFields.get(i): '+sObjectFields.get(i));
	      			if((sObjectFields.get(0) != sObjectFields.get(i)) && sObjectFields.get(i) == 'Body' || 
	      				sObjectFields.get(i) == 'Type' || 
	      				sObjectFields.get(i) == 'Title' || 
	      				sObjectFields.get(i) == 'RelatedRecordId' || 
	      				sObjectFields.get(i) == 'ParentId') {
	      				allSObjectFieldsQuery += ', ' + sObjectFields.get(i);
	      			}
	      		} else {*/
		        	allSObjectFieldsQuery += ', ' + sObjectFields.get(i);
	      		//}
	      	}
	    
	      	allSObjectFieldsQuery += ' FROM '+objectType.getDescribe().getName() +' WHERE ID IN (\'' + sObjectIds.get(0) + '\'';
	
	      	for (Integer i=1 ; i < sObjectIds.size() ; i++){
	        	allSObjectFieldsQuery += ', \'' + sObjectIds.get(i) + '\'';
	      	}
	    
	      	allSObjectFieldsQuery += ')';
	    
	      	system.debug('allSObjectFieldsQuery:-------------------------> ' + allSObjectFieldsQuery);
	    
	      	try{
				// Execute the query. For every result returned, 
		        // use the clone method on the generic sObject 
		        // and add to the collection of cloned objects
		        for (SObject sObjectFromDatabase: Database.query(allSObjectFieldsQuery)){
		        	SObject cloneObj = sObjectFromDatabase.clone(false,true);
		        	clonedSObjects.add(cloneObj);
		        	dbIdCloneObj.put(sObjectFromDatabase.Id, cloneObj);
		        }
	      	} catch (exception e){
	      		System.debug('Exception : '+e);
	      	}
		}
		system.debug('ned from the object retuCloned list of thevcloneObjects methind () is line 289 '+dbIdCloneObj);
	    return dbIdCloneObj;
	}
	
	public static void cloneAdditionQuestion(Set<String> objectIds, String parentId, String lookupFieldName) {
		/*Map<String,String> keyPrefixMap = new Map<String,String>();
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
          
    	for(String id : gd.keySet()){
      		Schema.DescribeSObjectResult r = gd.get(id).getDescribe();
      		keyPrefixMap.put(r.getKeyPrefix(), r.getName());
    	}*/
    	String objectTypeKey = new list<string>(objectIds)[0].subString(0,3);
      	String objectTypeName = keyPrefixMap.get(objectTypeKey);
      	system.debug('__objectTypeName__'+objectTypeName+', objectIds: '+objectIds);
      	/*if(objectTypeKey == '0D5') {
      		objectTypeName = 'FeedItem';
      	}*/
		if(objectTypeName == null || objectTypeName == 'UserProfileFeed') return;
		String primaryObjectQueryString = 'SELECT Id FROM '+ objectTypeName+' WHERE Id IN :objectIds';
    
    	List<SObject> headSObject = Database.query(primaryObjectQueryString);
    	if(headSObject != null && !headSObject.isEmpty()) {
	    	
	    	//List<Sobject> cloneObjs = cloneObjects(headSObject);
	    	Map<Id, SObject> dbIdClonedObj = cloneObjects(headSObject);
	    	List<Sobject> cloneObjs = dbIdClonedObj.values();
	    	
	    	if(parentId != '0') {
		    	for(Sobject cObj : cloneObjs) {
		    		cObj.put(lookupFieldName, parentId);
		    	}
	    	}
	    	system.debug('cloneObjs : '+cloneObjs);
	    	try {
				insert cloneObjs;
				/*if(objectTypeName.endsWith('__Feed')) {
					system.debug('primaryObjectQueryString: '+primaryObjectQueryString);
					return;
				}*/
	    	} catch(Exception e) {
	    		system.debug('Exception : '+e);
	    		/*if(objectTypeName.endsWith('__Feed')) {
					system.debug('primaryObjectQueryString: '+primaryObjectQueryString);
					return;
				}*/
	    	}
			
			
			Schema.DescribeSObjectResult headDescribe = headsObject[0].getSObjectType().getDescribe();
	    	List<Schema.ChildRelationship> childRelationships = headDescribe.getChildRelationships();
	    	//system.debug('headsObject.getSObjectType() : '+headsObject.getSObjectType()+'  childRelationships : '+childRelationships); 
			for (Schema.ChildRelationship childRelationship : childRelationships) {
	    		Schema.SObjectType childObjectType = childRelationship.getChildSObject();
	    		//system.debug('childObjectType : '+childObjectType);
	    		Schema.SObjectField childObjectField = childRelationship.getField();
	    		/*String relatedChildSObjectsquery = 'SELECT ID FROM ' 
				             + childObjectType.getDescribe().getName()
				             + ' WHERE '
				             + childObjectField.getDescribe().getName()
				             + ' = \'' 
				             + headsObject[0].Id
				             + '\''; */
				String relatedChildSObjectsquery = 'SELECT ID FROM '+ childObjectType.getDescribe().getName()+ ' WHERE '
				             + childObjectField.getDescribe().getName()+ ' IN :objectIds'; 
	        	try {
	        		if(childObjectType.getDescribe().getName() != 'AnswerOption__c' && 
                        childObjectType.getDescribe().getName() != 'NoteAndAttachment' &&
                        childObjectType.getDescribe().getName() != 'EntitySubscription' &&
                        childObjectType.getDescribe().getName() != 'Note' &&
                        childObjectType.getDescribe().getName() != 'ProcessInstanceHistory' &&
                        childObjectType.getDescribe().getName() != 'UserProfileFeed' &&
                        childObjectType.getDescribe().getName() != 'ProcessInstance' &&
                        childObjectType.getDescribe().getName() != 'FeedComment' &&
                        childObjectType.getDescribe().getName() != 'FeedPost' &&
                        childObjectType.getDescribe().getName() != 'NewsFeed' &&
                        childObjectType.getDescribe().getName() != 'ActivityHistory' &&
                        childObjectType.getDescribe().getName() != 'OpenActivity' &&
                        childObjectType.getDescribe().getName() != 'FeedSubscriptionsForEntity' &&
                        childObjectType.getDescribe().getName() != 'ContentDocumentFeed' && 
                        childObjectType.getDescribe().getName() != 'Attachment' &&
                        childObjectType.getDescribe().getName() != 'FeedLike' &&
                        childObjectType.getDescribe().getName() != 'FeedItem' &&
                        childObjectType.getDescribe().getName() != 'ContentDocument' &&
                        childObjectType.getDescribe().getName() != 'FeedTrackedChange' &&
                        childObjectType.getDescribe().getName() != 'ContentDocumentLink' && 
                        childObjectType.getDescribe().getName() != 'ContentVersion' && 
                        childObjectType.getDescribe().getName() != 'ContentDocumentHistory' &&
                        //!childObjectType.getDescribe().getName().endsWith('__share') &&
                        !childObjectType.getDescribe().getName().endsWith('__Feed')) {
                        	system.debug('__relatedChildSObjectsquery__'+relatedChildSObjectsquery);
			            	/*if(childObjectType.getDescribe().getName().endsWith('__share')){
			            		system.debug('__parentId__'+parentId);
			            		relatedChildSObjectsquery = 'select Id FROM '+childObjectType.getDescribe().getName()+' WHERE AccessLevel != \'All\' ';
			            		//system.debug('__Database.query(relatedChildSObjectsquery)__'+Database.query(relatedChildSObjectsquery));
			            		//return;
			            	}
			        		system.debug('relatedChildSObjectsquery : '+relatedChildSObjectsquery);*/
			            	Map<String, Sobject> mapSobject = new Map<String, Sobject>(Database.query(relatedChildSObjectsquery));
			            	if(!mapSobject.keySet().isEmpty()) {
	                        	if(childObjectType.getDescribe().getName() == 'CRFAdditionalQuestion__Share') {
			            			cloneMeAdditionQuestion(mapSobject.keySet(), cloneObjs, childObjectField.getDescribe().getName());
			            		} else {
		                        	cloneMe(mapSobject.keySet(), cloneObjs[0].Id, childObjectField.getDescribe().getName());
			            		}
			            	}
		        		/*for (SObject childObject : Database.query(relatedChildSObjectsquery)) {
			        		cloneMe(childObject.Id, cloneObjs[0].Id, childObjectField.getDescribe().getName());
			        	}*/
			        }
			        
		        } catch(Exception e) {
	    			system.debug('Exception : '+e);
	    			if(parentId == '0' && childObjectType.getDescribe().getName() == 'FeedItem'){
	    				system.debug('____Exception____');
	    				return;
	    			}
	    		}
			}
    	}
		//return null;
	}
	
	public static void cloneMeAdditionQuestion(Set<String> objectIds, List<Sobject> lstParentObject, String lookupFieldName) {
    	system.debug('objectIds: '+objectIds);
    	String objectTypeKey = new List<String>(objectIds)[0].subString(0,3);
      	String objectTypeName = keyPrefixMap.get(objectTypeKey);
      	system.debug('__objectTypeName__'+objectTypeName+', objectIds: '+objectIds);
      	if(objectTypeKey == '02c') {
      		String parentObjectTypeKey = String.valueOf(lstParentObject[0].get('Id')).subString(0,3);
      		String parentObjectTypeName = keyPrefixMap.get(parentObjectTypeKey);
      		system.debug('parentObjectTypeName: '+parentObjectTypeName);
      		if(parentObjectTypeName.endsWith('__c')) {
				objectTypeName = parentObjectTypeName.replaceAll('__c', '__Share');
			} else {
				objectTypeName = parentObjectTypeName + 'Share';
			}
      	}
		if(objectTypeName == null || objectTypeName == 'UserProfileFeed') return;
		String primaryObjectQueryString = 'SELECT Id FROM '+ objectTypeName+' WHERE Id IN :objectIds';
		system.debug('__objectTypeName.endsWith__'+objectTypeName.endsWith('__Share'));
		if(objectTypeName.endsWith('__Share')) {
			system.debug('__Share__');
			primaryObjectQueryString = 'SELECT Id FROM '+ objectTypeName+' WHERE Id IN :objectIds and AccessLevel!=\'All\'';
		}
    	system.debug('__primaryObjectQueryString__'+primaryObjectQueryString);
    	List<SObject> headSObject = Database.query(primaryObjectQueryString);
    	if(headSObject != null && !headSObject.isEmpty()) {
	    	
	    	//List<Sobject> cloneObjs = cloneObjects(headSObject);
	    	Map<Id, SObject> dbIdClonedObj = cloneObjects(headSObject);
	    	List<Sobject> cloneObjs = dbIdClonedObj.values();
	    	
	    	system.debug('cloneObjs[0]: '+cloneObjs[0]);
	    	if(!lstParentObject.isEmpty()) {
	    		Set<Id> processedParentIds = new Set<Id>();
	    		Map<Id, Id> mapOldNewParent = new Map<Id, Id>();
	    		for(Sobject cObj : cloneObjs) {
		    		for(Sobject obj : lstParentObject) {
		    			if(mapOldNewParent.containsKey((Id)cObj.get(lookupFieldName)) || processedParentIds.contains((Id)obj.get('Id'))) continue;
		    			mapOldNewParent.put((Id)cObj.get(lookupFieldName), (Id)obj.get('Id'));
		    			processedParentIds.add((Id)obj.get('Id'));
		    			break;
		    		}
	    		}
	    		system.debug('mapOldNewParent: '+mapOldNewParent);
		    	for(Sobject cObj : cloneObjs) {
		    		cObj.put(lookupFieldName, mapOldNewParent.get((Id)cObj.get(lookupFieldName)));
		    	}
	    	}
	    	system.debug('cloneObjs : '+cloneObjs);
	    	try {
				insert cloneObjs;
	    	} catch(Exception e) {
	    		system.debug('Exception : '+e);
	    	}
    	}
	}
	
  	@isTest(SeeAllData=true)
	static void runCloneMe() {
		List<ProtocolViolationDetail__c> lstPro = [Select p.Name, p.Id From ProtocolViolationDetail__c p];
		if(!lstPro.isEmpty()) {
			system.debug('lstPro[0].id: '+lstPro[0].id);
			CloneBuilder.cloneMe(new Set<String>{lstPro[0].id},'0','');
		}
	}
	
	/*public void testClone() {
		CloneBuilder.cloneMe('a1Oc00000004zob','0','');
	}*/
}