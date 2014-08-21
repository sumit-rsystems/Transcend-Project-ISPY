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
private class TestContentDocumentBeforeDelete {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        List<User> lstUser = [select Id from User where Profile.Name='DCC User' and IsActive = true limit 1];
        if(!lstUser.isEmpty()) {
            System.runAs(lstUser[0]) {
                
                ContentVersion doc = new ContentVersion();
            
                doc.Title = 'an Image';
                doc.PathOnClient = 'Image.gif';
                doc.VersionData = Blob.valueOf('Image');
                insert doc;
                doc = [select ContentDocumentId from ContentVersion where id = :doc.id];
            
                /*ContentWorkspace c6Workspace = [select id from ContentWorkspace limit 1]; 
                ContentWorkspaceDoc docLink = new ContentWorkspaceDoc();
                docLink.ContentDocumentId = doc.ContentDocumentId;
                docLink.ContentWorkspaceId = c6Workspace.id;
            
                insert docLink;*/
                
                List<ContentDocument> lstContentDoc = [select Id, Title, LatestPublishedVersionId, OwnerId from ContentDocument where Id =:doc.ContentDocumentId];
                /*if(!lstContentDoc.isEmpty()) {
                    doc.Title='test';
                    update doc;
                }*/
                delete lstContentDoc;
                system.debug('__Deleted__');
                
                /*MRI_Volume__c mri = new MRI_Volume__c();
                mri.Time_Point__c = 'Pre-Treatment';
                mri.MRI_Scan_Date__c = date.newInstance(2012, 7, 7);
                mri.MRI_Volume_in_cm3__c = 2.3;
                mri.Longest_Diameter_Of_Index_Lesion_in_cm__c = 2.4;
                mri.Status__c = 'Approval Pending';
                insert mri;
                
                FeedItem post = new FeedItem();
                post.body = '[APPROVED BY CHANNEL]';
                post.ParentId = mri.Id;
                post.ContentFileName = 'test';
                post.ContentData = blob.valueOf('fvd');
                //Test.startTest();
                insert post;
                //Test.stopTest();
                
                List<FeedItem> lstFeedItem = [select Id, RelatedRecordId from FeedItem where Id =:post.Id];
                if(!lstFeedItem.isEmpty()) {
                    system.debug('lstFeedItem[0].RelatedRecordId: '+lstFeedItem[0].RelatedRecordId);
                    try {
                        //delete [select Id from ContentDocument where LatestPublishedVersionId=:lstFeedItem[0].RelatedRecordId];
                        //ContentDocument ContDoc = [select Id from ContentDocument where LatestPublishedVersionId=:lstFeedItem[0].RelatedRecordId];
                        //delete ContDoc;
                        //delete [Select c.ContentDocument.LatestPublishedVersionId, c.ContentDocumentId From ContentVersion c where ContentDocument.LatestPublishedVersionId =:lstFeedItem[0].RelatedRecordId];
                        delete [select Id from ContentDocument where LatestPublishedVersionId=:lstFeedItem[0].RelatedRecordId];
                        system.debug('__Deleted__');
                    } catch(Exception e) {
                        system.debug('Error: '+e);
                    }
                }*/
            }
        }
    }
}