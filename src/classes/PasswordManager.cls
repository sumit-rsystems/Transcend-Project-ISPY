public with sharing class PasswordManager {
	public static String generatePassword() {
		
		Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        key = key.substring(0,8);
        System.debug('actual password : '+key);
        blob blobPwd = Blob.valueOf(key);
       
        String password = EncodingUtil.base64Encode(blobKey);
        System.debug('encoded password : '+password);
        return password;
	}
	
	public static String generateSecurityToken() {
		Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        return key;
	}
	
	public static Boolean verifyPassword(String userId, String password) {
		List<User> lstUser = [select SecurityCode__c from User where Id = :userId];
		if(lstUser != null || lstUser.size() > 0) {
			if(lstUser[0].SecurityCode__c == null || lstUser[0].SecurityCode__c == '') {
				return false;
			}
			blob blobKey = Encodingutil.base64Decode(lstUser[0].SecurityCode__c);
			String securityCode = EncodingUtil.convertToHex(blobKey);
			securityCode = securityCode.substring(0,8);
			//String securityCode = blobKey.toString();
			system.debug('password : '+password+'   and    securityCode : '+securityCode);
			
			if(securityCode == password) {
				return true;
			}
		}
		
		return false; 
	}
}