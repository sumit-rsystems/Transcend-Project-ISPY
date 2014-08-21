public with sharing class CRFUtilities {
	public CRFUtilities(){
		
	}
	
	public static String CRFStatus(Id crfId){
		system.debug('crfId : '+crfId);
		List<CRF__c> lstCrf = [select id,Status__c from CRF__c where Id = : crfId];
		if(lstCrf.isEmpty()) {
			return '';
		}
		return lstCrf[0].Status__c;
	} 
	
	//Function to know current user's profile is Read Only
	public static Boolean isReadOnlyUsr(){ 
		User usr = [Select u.Profile.Name From User u where id =:UserInfo.getUserId()];
		if(usr.Profile.Name == 'Custom Read Only User' || usr.Profile.Name == 'Trial Administrator' ){ 
			 return false;
 		} 
 		return true;           
	}  
}