public class CheckStatusOfMasterCRFWithAllCRFs {
	public List<Messaging.Singleemailmessage> singlEmailMessageList;
	public Map<string,string> formNameMap;
	
	public string emailBodyRows ;
	public boolean toSendEmail;
	public CheckStatusOfMasterCRFWithAllCRFs(){
	}
	
	public void compareStatusAndSendEmail(){
		singlEmailMessageList = new List<Messaging.Singleemailmessage>();
		User userObj = [select Email, Name from User where Id =:Userinfo.getUserId()];
		List<CRFMaster__c> crfMasterList = [Select c.Object_Name__c, c.Name, c.CRFType__c From CRFMaster__c c];
		System.debug('crfMasterList----------'+crfMasterList);
		formNameMap = new Map<string,string>(); 
		for(CRFMaster__c crfMaster : crfMasterList){
			formNameMap.put(crfMaster.Object_Name__c,crfMaster.CRFType__c);
		}
		
		emailBodyRows = '';
		toSendEmail = false;
		for(PreEligibility_Checklist__c p : [Select p.Status__c, p.LastModifiedDate, p.CreatedDate, p.CRF_Id__r.Status__c, p.CRF_Id__r.CreatedDate, p.CRF_Id__r.Owner.Email, p.CRF_Id__c From PreEligibility_Checklist__c p]){
			if(p.Status__c == p.CRF_Id__r.Status__c)continue;
			toSendEmail = true;
			//buildEmailBodyRows(string objName, datetime createdDate, datetime lastModifiedDate, string trialPatSubjectId, string formName, string masterCrfStatus, string crfStatus)
			emailBodyRows = buildEmailBodyRows(p.id,'PreEligibility_Checklist__c',p.createdDate,p.lastModifiedDate,'',formNameMap.get('PreEligibility_Checklist__c'),p.CRF_Id__r.Status__c,p.Status__c);	
		}
		if(toSendEmail)buildEmail('','PreEligibility_Checklist__c',emailBodyRows);
		
	
		emailBodyRows = '';
		toSendEmail = false;
		for(Registration__c r : [Select r.Status__c, r.LastModifiedDate, r.CreatedDate, r.CRF__r.Status__c, r.CRF__r.CreatedDate, r.CRF__r.Owner.Email, r.CRF__c From Registration__c r]){
			if(r.Status__c == r.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(r.id,'Registration__c',r.createdDate,r.lastModifiedDate,'',formNameMap.get('Registration__c'),r.CRF__r.Status__c,r.Status__c);
			
		}
		if(toSendEmail)buildEmail('','Registration__c',emailBodyRows);
	
	
		emailBodyRows = '';
		toSendEmail = false;
		for(Menopausal_Status_Detail__c m : [Select m.TrialPatient__r.Subject_Id__c, m.TrialPatient__c, m.Status__c, m.LastModifiedDate, m.CreatedDate, m.CRF_Id__r.Status__c, m.CRF_Id__r.CreatedDate, m.CRF_Id__r.Owner.Email, m.CRF_Id__c From Menopausal_Status_Detail__c m]){
			if(m.Status__c == m.CRF_Id__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(m.id,'Menopausal_Status_Detail__c',m.createdDate,m.lastModifiedDate,m.TrialPatient__r.Subject_Id__c,formNameMap.get('Menopausal_Status_Detail__c'),m.CRF_Id__r.Status__c,m.Status__c);
							
		}
		if(toSendEmail)buildEmail('','Menopausal_Status_Detail__c',emailBodyRows);	
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(TissueSpecimenDetail__c t : [Select t.TrialPatient__r.Subject_Id__c, t.TrialPatient__c, t.Status__c, t.LastModifiedDate, t.CreatedDate, t.CRFId__r.Status__c, t.CRFId__r.CreatedDate, t.CRFId__r.Owner.Email, t.CRFId__c From TissueSpecimenDetail__c t]){
			if(t.Status__c == t.CRFId__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(t.id,'TissueSpecimenDetail__c',t.createdDate,t.lastModifiedDate,t.TrialPatient__r.Subject_Id__c,formNameMap.get('TissueSpecimenDetail__c'),t.CRFId__r.Status__c,t.Status__c);
		}
		if(toSendEmail)buildEmail('','TissueSpecimenDetail__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(BloodSpecimenForm__c b : [Select b.TrialPatient__r.Subject_Id__c, b.TrialPatient__c, b.Status__c, b.LastModifiedDate, b.CreatedDate, b.CRF__r.Status__c, b.CRF__r.CreatedDate, b.CRF__r.Owner.Email, b.CRF__c From BloodSpecimenForm__c b]){
			if(b.Status__c == b.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(b.id,'BloodSpecimenForm__c',b.createdDate,b.lastModifiedDate,b.TrialPatient__r.Subject_Id__c,formNameMap.get('BloodSpecimenForm__c'),b.CRF__r.Status__c,b.Status__c);
		}
		if(toSendEmail)buildEmail('','BloodSpecimenForm__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(MammaPrintDetail__c m : [Select m.TrialPatient__r.Subject_Id__c, m.TrialPatient__c, m.Status__c, m.LastModifiedDate, m.CreatedDate, m.CRF__r.Status__c, m.CRF__r.CreatedDate, m.CRF__r.Owner.Email, m.CRF__c From MammaPrintDetail__c m]){
			if(m.Status__c == m.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(m.id,'MammaPrintDetail__c',m.createdDate,m.lastModifiedDate,m.TrialPatient__r.Subject_Id__c,formNameMap.get('MammaPrintDetail__c'),m.CRF__r.Status__c,m.Status__c);
		}
		if(toSendEmail)buildEmail('','MammaPrintDetail__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(MRI_Volume__c m : [Select m.TrialPatient__r.Subject_Id__c, m.TrialPatient__c, m.Status__c, m.LastModifiedDate, m.CreatedDate, m.CRF__r.Status__c, m.CRF__r.LastModifiedDate, m.CRF__r.CreatedDate, m.CRF__r.Owner.Email, m.CRF__c From MRI_Volume__c m]){
			if(m.Status__c == m.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(m.id,'MRI_Volume__c',m.createdDate,m.lastModifiedDate,m.TrialPatient__r.Subject_Id__c,formNameMap.get('MRI_Volume__c'),m.CRF__r.Status__c,m.Status__c);
		}
		if(toSendEmail)buildEmail('','MRI_Volume__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(Response_Evaluation_Form__c r : [Select r.TrialPatient__r.Subject_Id__c, r.TrialPatient__c, r.Status__c, r.LastModifiedDate, r.CreatedDate, r.CRF__r.Status__c, r.CRF__r.LastModifiedDate, r.CRF__r.CreatedDate, r.CRF__r.Owner.Email, r.CRF__c From Response_Evaluation_Form__c r]){
			if(r.Status__c == r.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(r.id,'Response_Evaluation_Form__c',r.createdDate,r.lastModifiedDate,r.TrialPatient__r.Subject_Id__c,formNameMap.get('Response_Evaluation_Form__c'),r.CRF__r.Status__c,r.Status__c);
		}
		if(toSendEmail)buildEmail('','Response_Evaluation_Form__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(On_Study_Pathology_Form__c o : [Select o.TrialPatient__r.Subject_Id__c, o.TrialPatient__c, o.Status__c, o.LastModifiedDate, o.CreatedDate, o.CRF__r.Status__c, o.CRF__r.LastModifiedDate, o.CRF__r.CreatedDate, o.CRF__r.Owner.Email, o.CRF__c From On_Study_Pathology_Form__c o]){
			if(o.Status__c == o.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(o.id,'On_Study_Pathology_Form__c',o.createdDate,o.lastModifiedDate,o.TrialPatient__r.Subject_Id__c,formNameMap.get('On_Study_Pathology_Form__c'),o.CRF__r.Status__c,o.Status__c);
		}
		if(toSendEmail)buildEmail('','On_Study_Pathology_Form__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(On_Study_Eligibility_Form__c o : [Select o.TrialPatient__r.Subject_Id__c, o.TrialPatient__c, o.Status__c, o.LastModifiedDate, o.CreatedDate, o.CRF__r.Status__c, o.CRF__r.LastModifiedDate, o.CRF__r.CreatedDate, o.CRF__r.Owner.Email, o.CRF__c From On_Study_Eligibility_Form__c o]){
			if(o.Status__c == o.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(o.id,'On_Study_Eligibility_Form__c',o.createdDate,o.lastModifiedDate,o.TrialPatient__r.Subject_Id__c,formNameMap.get('On_Study_Eligibility_Form__c'),o.CRF__r.Status__c,o.Status__c);
		}
		if(toSendEmail)buildEmail('','On_Study_Eligibility_Form__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(Off_Study_Detail__c o : [Select o.TrialPatient__r.Subject_Id__c, o.TrialPatient__c, o.Status__c, o.LastModifiedDate, o.CreatedDate, o.CRF__r.Status__c, o.CRF__r.LastModifiedDate, o.CRF__r.CreatedDate, o.CRF__r.Owner.Email, o.CRF__c From Off_Study_Detail__c o]){
			if(o.Status__c == o.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(o.id,'Off_Study_Detail__c',o.createdDate,o.lastModifiedDate,o.TrialPatient__r.Subject_Id__c,formNameMap.get('Off_Study_Detail__c'),o.CRF__r.Status__c,o.Status__c);
		}
		if(toSendEmail)buildEmail('','Off_Study_Detail__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(No_Longer_lost_to_Followup__c n : [Select n.TrialPatient__r.Subject_Id__c, n.TrialPatient__c, n.Status__c, n.LastModifiedDate, n.CreatedDate, n.CRF__r.Status__c, n.CRF__r.LastModifiedDate, n.CRF__r.CreatedDate, n.CRF__r.Owner.Email, n.CRF__c From No_Longer_lost_to_Followup__c n]){
			if(n.Status__c == n.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(n.id,'No_Longer_lost_to_Followup__c',n.createdDate,n.lastModifiedDate,n.TrialPatient__r.Subject_Id__c,formNameMap.get('No_Longer_lost_to_Followup__c'),n.CRF__r.Status__c,n.Status__c);
		}
		if(toSendEmail)buildEmail('','No_Longer_lost_to_Followup__c',emailBodyRows);
		
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(ProtocolViolationDetail__c p : [Select p.TrialPatient__r.Subject_Id__c, p.TrialPatient__c, p.Status__c, p.LastModifiedDate, p.CreatedDate, p.CRFId__r.Status__c, p.CRFId__r.LastModifiedDate, p.CRFId__r.CreatedDate, p.CRFId__r.Owner.Email, p.CRFId__c From ProtocolViolationDetail__c p]){
			if(p.Status__c == p.CRFId__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(p.id,'ProtocolViolationDetail__c',p.createdDate,p.lastModifiedDate,p.TrialPatient__r.Subject_Id__c,formNameMap.get('ProtocolViolationDetail__c'),p.CRFId__r.Status__c,p.Status__c);
		}
		if(toSendEmail)buildEmail('','ProtocolViolationDetail__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(Randomization_Form__c r : [Select r.TrialPatient__r.Subject_Id__c, r.TrialPatient__c, r.Status__c, r.LastModifiedDate, r.CreatedDate, r.CRF__r.Status__c, r.CRF__r.LastModifiedDate, r.CRF__r.CreatedDate, r.CRF__r.Owner.Email, r.CRF__c From Randomization_Form__c r]){
			if(r.Status__c == r.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(r.id,'Randomization_Form__c',r.createdDate,r.lastModifiedDate,r.TrialPatient__r.Subject_Id__c,formNameMap.get('Randomization_Form__c'),r.CRF__r.Status__c,r.Status__c);
		}
		if(toSendEmail)buildEmail('','Randomization_Form__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(AE_Detail__c a : [Select a.TrialPatient__r.Subject_Id__c, a.TrialPatient__c, a.Status__c, a.LastModifiedDate, a.CreatedDate, a.CRF__r.Status__c, a.CRF__r.LastModifiedDate, a.CRF__r.CreatedDate, a.CRF__r.Owner.Email, a.CRF__c From AE_Detail__c a]){
			if(a.Status__c == a.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(a.id,'AE_Detail__c',a.createdDate,a.lastModifiedDate,a.TrialPatient__r.Subject_Id__c,formNameMap.get('AE_Detail__c'),a.CRF__r.Status__c,a.Status__c);
		}
		if(toSendEmail)buildEmail('','AE_Detail__c',emailBodyRows);
		
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(Chemo_Treatment__c c : [Select c.TrialPatient__r.Subject_Id__c, c.TrialPatient__c, c.Status__c, c.LastModifiedDate, c.CreatedDate, c.CRF__r.Status__c, c.CRF__r.LastModifiedDate, c.CRF__r.CreatedDate, c.CRF__r.Owner.Email, c.CRF__c From Chemo_Treatment__c c]){
			if(c.Status__c == c.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(c.id,'Chemo_Treatment__c',c.createdDate,c.lastModifiedDate,c.TrialPatient__r.Subject_Id__c,formNameMap.get('Chemo_Treatment__c'),c.CRF__r.Status__c,c.Status__c);
		}
		if(toSendEmail)buildEmail('','Chemo_Treatment__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(Lab_and_Test__c l : [Select l.TrialPatient__r.Subject_Id__c, l.TrialPatient__c, l.Status__c, l.LastModifiedDate, l.CreatedDate, l.CRF__r.Status__c, l.CRF__r.LastModifiedDate, l.CRF__r.CreatedDate, l.CRF__r.Owner.Email, l.CRF__c From Lab_and_Test__c l]){
			if(l.Status__c == l.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(l.id,'Lab_and_Test__c',l.createdDate,l.lastModifiedDate,l.TrialPatient__r.Subject_Id__c,formNameMap.get('Lab_and_Test__c'),l.CRF__r.Status__c,l.Status__c);
		}
		if(toSendEmail)buildEmail('','Lab_and_Test__c',emailBodyRows);
		
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(Post_Surgaory_Summary__c p : [Select p.TrialPatient__r.Subject_Id__c, p.TrialPatient__c, p.Status__c, p.LastModifiedDate, p.CreatedDate, p.CRF__r.Status__c, p.CRF__r.LastModifiedDate, p.CRF__r.CreatedDate, p.CRF__r.Owner.Email, p.CRF__c From Post_Surgaory_Summary__c p]){
			if(p.Status__c == p.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(p.id,'Post_Surgaory_Summary__c',p.createdDate,p.lastModifiedDate,p.TrialPatient__r.Subject_Id__c,formNameMap.get('Post_Surgaory_Summary__c'),p.CRF__r.Status__c,p.Status__c);
		}
		if(toSendEmail)buildEmail('','Post_Surgaory_Summary__c',emailBodyRows);
		
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(Lost_to_Follow_Up__c l : [Select l.TrialPatient__r.Subject_Id__c, l.TrialPatient__c, l.Status__c, l.LastModifiedDate, l.CreatedDate, l.CRF__r.Status__c, l.CRF__r.LastModifiedDate, l.CRF__r.CreatedDate, l.CRF__r.Owner.Email, l.CRF__c From Lost_to_Follow_Up__c l]){
			if(l.Status__c == l.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(l.id,'Lost_to_Follow_Up__c',l.createdDate,l.lastModifiedDate,l.TrialPatient__r.Subject_Id__c,formNameMap.get('Lost_to_Follow_Up__c'),l.CRF__r.Status__c,l.Status__c);
		}
		if(toSendEmail)buildEmail('','Lost_to_Follow_Up__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(Followup_Form__c f : [Select f.TrialPatient__r.Subject_Id__c, f.TrialPatient__c, f.Status__c, f.LastModifiedDate, f.CreatedDate, f.CRF__r.Status__c, f.CRF__r.LastModifiedDate, f.CRF__r.CreatedDate, f.CRF__r.Owner.Email, f.CRF__c From Followup_Form__c f]){
			if(f.Status__c == f.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(f.id,'Followup_Form__c',f.createdDate,f.lastModifiedDate,f.TrialPatient__r.Subject_Id__c,formNameMap.get('Followup_Form__c'),f.CRF__r.Status__c,f.Status__c);
		}
		if(toSendEmail)buildEmail('','Followup_Form__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(Chemo_Summary_Form__c c : [Select c.TrialPatient__r.Subject_Id__c, c.TrialPatient__c, c.Status__c, c.LastModifiedDate, c.CreatedDate, c.CRF__r.Status__c, c.CRF__r.LastModifiedDate, c.CRF__r.CreatedDate, c.CRF__r.Owner.Email, c.CRF__c From Chemo_Summary_Form__c c]){
			if(c.Status__c == c.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(c.id,'Chemo_Summary_Form__c',c.createdDate,c.lastModifiedDate,c.TrialPatient__r.Subject_Id__c,formNameMap.get('Chemo_Summary_Form__c'),c.CRF__r.Status__c,c.Status__c);
		}
		if(toSendEmail)buildEmail('','Chemo_Summary_Form__c',emailBodyRows);
		
		
		emailBodyRows = '';
		toSendEmail = false;
		for(BaselineSymptomsForm__c b : [Select b.TrialPatient__r.Subject_Id__c, b.TrialPatient__c, b.Status__c, b.LastModifiedDate, b.CreatedDate, b.CRF__r.Status__c, b.CRF__r.CreatedDate, b.CRF__r.Owner.Email, b.CRF__c From BaselineSymptomsForm__c b]){
			if(b.Status__c == b.CRF__r.Status__c)continue;
			toSendEmail = true;
			emailBodyRows = buildEmailBodyRows(b.id,'BaselineSymptomsForm__c',b.createdDate,b.lastModifiedDate,b.TrialPatient__r.Subject_Id__c,formNameMap.get('BaselineSymptomsForm__c'),b.CRF__r.Status__c,b.Status__c);
		}
		if(toSendEmail)buildEmail('','BaselineSymptomsForm__c',emailBodyRows);
		
		if(!singlEmailMessageList.isEmpty()){
			System.debug('singlEmailMessageList----size------'+singlEmailMessageList.size());
			List<Messaging.Sendemailresult> emailResultList = Messaging.sendEmail(singlEmailMessageList);
			System.debug('emailResultList----------'+emailResultList);
			
			//create email logs
			List<Email_Logs__c> lstEmailLogs = new List<Email_Logs__c>();
			for(Messaging.Singleemailmessage mail : singlEmailMessageList) {
				//build string for email Address
				String emailIdString = '';
				for(String email : mail.getToAddresses()) {
					emailIdString+= email+',';
				}
				if(emailIdString != '') {
					emailIdString = emailIdString.substring(0, (emailIdString.length()-1));
				}
				
				/*Email_Logs__c emailLog = new Email_Logs__c();
				emailLog.Class_Name__c = 'CheckStatusOfMasterCRFWithAllCRFs.cls';
				emailLog.Email_Subject__c = mail.getSubject();
				emailLog.Recipient__c = emailIdString;
				emailLog.Remaining_Email_Invocation__c = (Limits.getLimitEmailInvocations() - Limits.getEmailInvocations())+' remaining out of total' +Limits.getLimitEmailInvocations();
				emailLog.Sender__c = Userinfo.getUserId();*/
				lstEmailLogs.add(EmailLogsManager.createEmailLog('CheckStatusOfMasterCRFWithAllCRFs.cls', mail.getSubject(), emailIdString));
			}
			
			//insert email log's records
			if(!lstEmailLogs.isEmpty()) {
				insert lstEmailLogs;
			}
		}
	}
	
	public string buildEmailBodyRows(string crfRecordId, string objName, datetime createdDate, datetime lastModifiedDate, string trialPatSubjectId, string formName, string masterCrfStatus, string crfStatus){
		string createdDateCrf = createdDate.month()+'/'+createdDate.day()+'/'+createdDate.year();
		string lastModifiedDateCrf = lastModifiedDate.month()+'/'+lastModifiedDate.day()+'/'+lastModifiedDate.year();
		emailBodyRows = emailBodyRows+'<tr>'+'<td align="center">'+crfRecordId+'</td>';
		if(objName != 'PreEligibility_Checklist__c' && objName != 'Registration__c') {emailBodyRows = emailBodyRows +'<td align="center">'+trialPatSubjectId+'</td>';}
		emailBodyRows = emailBodyRows + '<td align="center">'+masterCrfStatus+'</td>'+
							'<td align="center">'+crfStatus+'</td>'+
							'<td align="center">'+createdDateCrf+'</td>'+
							'<td align="center">'+lastModifiedDateCrf+'</td>'+
						'</tr>'	;
		return emailBodyRows;
	}
	
	public void buildEmail(string crfOwnerEmail,string objName,string tableRowsBody){
		Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
		List<String> userEmailIdList = new List<String>();
		System.debug('crf.Owner.Email---------'+crfOwnerEmail);
		//if(crfOwnerEmail == '')return;
		//userEmailIdList.add(crfOwnerEmail);
		//userEmailIdList.add('asc.sfdc.tester3@gmail.com');
		userEmailIdList.add('patelb@opallios.com');
		mail.setToAddresses(userEmailIdList);
		mail.setSubject('CRF Status mismatch summary');
		
		String emailBody = '<b>'+formNameMap.get(objName)+': </b><br/>'+
							'<table width="100%" cellspacing="1" >'+
								'<tr style="font-size: small; background-color: #2e84c5; color: #ffffff;">';
			emailBody = emailBody + '<th>Id</th>';
			if(objName != 'PreEligibility_Checklist__c' && objName != 'Registration__c') {emailBody = emailBody +'<th>Subject Id</th>';}
			emailBody = emailBody + '<th>Master Status</th>'+
									'<th>Status</th>'+
									'<th>Created Date</th>'+
									'<th>Last Modified Date</th>'+
								'</tr>';
		emailBody = emailBody+tableRowsBody+'</table>';
							
		mail.setHtmlBody(emailBody);
		singlEmailMessageList.add(mail);
	}
}