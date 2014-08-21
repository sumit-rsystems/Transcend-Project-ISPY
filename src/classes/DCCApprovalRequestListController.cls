public with sharing class DCCApprovalRequestListController {

	public List<Approval_Request__c> appReqList {get;set;}
	public String selectedRequestStatus{get;set;}
	public String csvFileName{get;set;}
	public static integer PAGE_SIZE {get;}
	static{
		PAGE_SIZE = 100;
	}
	public integer totalRecords {get;set;}
	public integer currentPage {get;set;}
	
	public boolean showNextLink {get;set;}
	public boolean showPrevLink {get;set;}
	public boolean showFirstLink {get;set;}
	public boolean showLastLink {get;set;}
	
	public integer displayingFrom {get;set;}
	public integer displayingTo {get;set;}
	
	public DCCApprovalRequestListController() {
		String mode = Apexpages.currentPage().getParameters().get('mode');
		
		appReqList = new List<Approval_Request__c>();
		if(mode != 'csv') {
			selectedRequestStatus = 'pending';
			currentPage = 0;
			List<Approval_Request__c> allRequests = getApprovalRequests();
			totalRecords = allRequests.size(); 
			system.debug('totalRecords: '+totalRecords);
			setData();
		}
	}
	
	public void next() {
		currentPage++;
		setData();
	}
	
	public void prev() {
		currentPage--;
		setData();
	}
	
	public void firstPage() {
		currentPage = 0;
		setData();
	}
	
	public void lastPage() {
		currentPage = -1;
		setData();
	}
	
	public void changeStatus() {
		currentPage = 0;
		appReqList = new List<Approval_Request__c>();
		List<Approval_Request__c> allRequests = getApprovalRequests();
		totalRecords = allRequests.size(); 
		setData();
	}
	
	private void setData() {
		List<Approval_Request__c> allRequests = getApprovalRequests();
		appReqList.clear();
		appReqList.addAll(setCurrentApprovalRequests(currentPage, allRequests));
		displayingFrom = currentPage * PAGE_SIZE + 1;
		displayingTo = currentPage * PAGE_SIZE + appReqList.size();
	}
		    
	private List<Approval_Request__c> getApprovalRequests() {
		List<Approval_Request__c> approvalReqList = null;
		if(!Test.isRunningTest()) {
			List<GroupMember> grpMemList = [Select g.UserOrGroupId, g.Group.Type, g.Group.Name, g.GroupId From GroupMember g where UserOrGroupId =:Userinfo.getUserId() and Group.Type='Queue'];
			Set<Id> grpIdSet = new Set<Id>(); 
			for(GroupMember grpMemObj: grpMemList) {
				grpIdSet.add(grpMemObj.GroupId);
			}
			
			if(selectedRequestStatus == 'approved') {
				approvalReqList = [Select a.Site__r.Name, a.Study__r.Name, Subject_Id__c, Status__c, Institution__c, Institution__r.Name, a.Record_Id__c, a.Object_Label__c, a.Name, a.Id, a.Group_Id__c, a.CreatedDate, a.CreatedById, CreatedBy.Name, a.Approval_URL__c From Approval_Request__c a where Group_Id__c IN :grpIdSet and Status__c = 'approved' order by CreatedDate desc];
			} else if(selectedRequestStatus == 'rejected') {
				approvalReqList = [Select a.Site__r.Name, a.Study__r.Name, Subject_Id__c, Status__c, Institution__c, Institution__r.Name, a.Record_Id__c, a.Object_Label__c, a.Name, a.Id, a.Group_Id__c, a.CreatedDate, a.CreatedById, CreatedBy.Name, a.Approval_URL__c From Approval_Request__c a where Group_Id__c IN :grpIdSet and Status__c = 'rejected' order by CreatedDate desc];
			} else {
				approvalReqList = [Select a.Site__r.Name, a.Study__r.Name, Subject_Id__c, Status__c, Institution__c, Institution__r.Name, a.Record_Id__c, a.Object_Label__c, a.Name, a.Id, a.Group_Id__c, a.CreatedDate, a.CreatedById, CreatedBy.Name, a.Approval_URL__c From Approval_Request__c a where Group_Id__c IN :grpIdSet and Status__c = 'pending' order by CreatedDate desc];
			}
		} else {
			if(selectedRequestStatus == 'approved') {
				approvalReqList = [Select a.Site__r.Name, a.Study__r.Name, Subject_Id__c, Status__c, Institution__c, Institution__r.Name, a.Record_Id__c, a.Object_Label__c, a.Name, a.Id, a.Group_Id__c, a.CreatedDate, a.CreatedById, CreatedBy.Name, a.Approval_URL__c From Approval_Request__c a where Status__c = 'approved' order by CreatedDate desc];
			} else if(selectedRequestStatus == 'rejected') {
				approvalReqList = [Select a.Site__r.Name, a.Study__r.Name, Subject_Id__c, Status__c, Institution__c, Institution__r.Name, a.Record_Id__c, a.Object_Label__c, a.Name, a.Id, a.Group_Id__c, a.CreatedDate, a.CreatedById, CreatedBy.Name, a.Approval_URL__c From Approval_Request__c a where Status__c = 'rejected' order by CreatedDate desc];
			} else {
				approvalReqList = [Select a.Site__r.Name, a.Study__r.Name, Subject_Id__c, Status__c, Institution__c, Institution__r.Name, a.Record_Id__c, a.Object_Label__c, a.Name, a.Id, a.Group_Id__c, a.CreatedDate, a.CreatedById, CreatedBy.Name, a.Approval_URL__c From Approval_Request__c a where Status__c = 'pending' order by CreatedDate desc];
			}
		}
		system.debug('__appReqList__'+approvalReqList.size());
		
		return approvalReqList;
	}
		
	private List<Approval_Request__c> setCurrentApprovalRequests(integer pageNumber, List<Approval_Request__c> approvalReqList) {
		List<Approval_Request__c> appReqListLocal = new List<Approval_Request__c>();
		if(!approvalReqList.isEmpty()){
			List<Approval_Request__c> approvalReqListTemp = new List<Approval_Request__c>();
			if(currentPage == -1) {
				for(integer i = 0; i < approvalReqList.size(); i = (i+PAGE_SIZE)) {
					currentPage++;
				}
			}		
			integer fromCount = currentPage * PAGE_SIZE;
			integer toCount = (currentPage * PAGE_SIZE + PAGE_SIZE)-1;
			if(approvalReqList.size() > toCount) {
				for(integer i = fromCount; i <= toCount; i++){
					appReqListLocal.add(approvalReqList[i]);
				}
				showNextLink = true;
				showLastLink = true;
				if(currentPage > 0) {
					showPrevLink = true;
					showFirstLink = true;
				} else {
					showPrevLink = false;
					showFirstLink = false;
				}
			} else if(approvalReqList.size() >= fromCount && approvalReqList.size() <= toCount) {
				for(integer i = fromCount; i < approvalReqList.size(); i++){
					appReqListLocal.add(approvalReqList[i]);
				}
				showNextLink = false;
				showLastLink = false;
				if(currentPage > 0) {
					showPrevLink = true;
					showFirstLink = true;
				} else {
					showPrevLink = false;
					showFirstLink = false;
				}
			}
		}
		return appReqListLocal;
	}
	
	public void showCSVRecords() {
		String selectedRequest = Apexpages.currentPage().getParameters().get('selectedReq');
		String curPage = Apexpages.currentPage().getParameters().get('curPg');
		
		selectedRequestStatus = selectedRequest;
		currentPage = Integer.valueOf(curPage);
		system.debug('selectedRequest: '+selectedRequestStatus);
		system.debug('currentPage: '+currentPage);
		
		List<Approval_Request__c> allRequests = getApprovalRequests();
		totalRecords = allRequests.size(); 
		system.debug('totalRecords: '+totalRecords);
		setData();
		csvFileName = selectedRequestStatus.capitalize()+'List-From'+displayingFrom+'To'+displayingTo;
	}
}