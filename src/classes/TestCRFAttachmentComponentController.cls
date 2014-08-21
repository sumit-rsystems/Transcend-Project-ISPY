/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the 
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestCRFAttachmentComponentController {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        List<User> thisUser = [ select u.Id , u.IsActive from User u where profile.Name = 'System Administrator' and IsActive = true];
        System.runAs (thisUser[0]){
            Account inst1 = new Account();
            List<Account> lstAccount = [Select a.RecordType.Name, a.RecordTypeId, a.Id From Account a where RecordType.Name = 'Institution'];
            if(!lstAccount.isEmpty()){
                    
            inst1 = lstAccount[0];
            
            Patient_Custom__c p = new Patient_Custom__c();
            p.Ethnicity__c = 'Hispanic or latino';
            p.Gender__c = 'female';
            p.Race__c = 'asian;indian';
            p.Last_Name__c = 'kumar';
            p.Status__c = 'approval not required';
            p.Birthdate__c = date.newInstance(1980, 08, 05);
            p.Institution__c = inst1.Id;
            insert p;
            
            Trial__c t = new Trial__c();
            t.Name = 'test';
            insert t;
            
            TrialPatient__c tp = new TrialPatient__c();
            tp.Patient_Id__c = p.Id;
            tp.Trial_Id__c = t.Id;
            insert tp;
            
            MRI_Volume__c mri = new MRI_Volume__c();
            mri.Time_Point__c = 'Pre-Treatment';
            mri.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
            mri.MRI_Volume_in_cm3__c = 2.3;
            mri.Longest_Diameter_Of_Index_Lesion_in_cm__c = 1;
            mri.TrialPatient__c = tp.Id;
            insert mri;
            
           /* FeedItem post = new FeedItem();
            post.ParentId = mri.Id; //eg. Opportunity id, custom object id..
            post.Body = 'Attachment added';
            post.ContentData = Encodingutil.base64Decode('att');
            post.ContentFileName = 'attachment.Name';
            insert post; */
            
            //List<ContentVersion> lstContent = [Select c.Title, c.PublishStatus, c.PathOnClient, c.Origin, c.Id, c.FirstPublishLocationId, c.FileType, c.Description, c.ContentSize From ContentVersion c ];
            
            CRFAttachmentComponentController crfAtt = new CRFAttachmentComponentController();
            
            //CRFAttachmentComponentController.WrapFeed wrapObj = new CRFAttachmentComponentController.WrapFeed(); 
            
            crfAtt.recordId = mri.Id;  
            crfAtt.feedCRFName = 'MRI_Volume__Feed';
            crfAtt.getLstWrapFeed();
      }
    }
  }
}