public with sharing class FileUploader {
	public Blob fileBody {get;set;}
	public String fileName {get;set;}
	public String csvContent {get;set;} 
	public String msg {get;set;} 
	public boolean showMsg {get;set;}
	public String severity {get;set;}
	public FileUploader() {
		showMsg = false;
	}
	
	public void uploadCSV() {
		showMsg = true;
		List<String> fileNameSplit = fileName.split('\\.');
		if(fileNameSplit != null && fileNameSplit.size() > 1) {
			if(fileNameSplit[1] != 'csv') {
				msg = 'Please upload file with ".csv" extension only.';
				severity = 'error';
				return;
			}
		} else {
			msg = 'Please upload file with ".csv" extension only.';
			severity = 'error';
			return;
		}
		try {
			csvContent = fileBody.toString();	
		} catch (Exception e) {
			msg = 'There is some problem with csv data. Please ensure that the file you have uploaded is in correct format.';
			severity = 'error';
			return;
		}
		
		system.debug('csvContent.length() : '+csvContent.length());
		List<RandomizationTestingDetail__c> lstRandomizationDetails = new List<RandomizationTestingDetail__c>();
		List<List<String>> lstCSVData = CSVParser.parseCSV(csvContent, true);
		System.debug('lstCSVData : '+lstCSVData);
		for(List<String> lstStr : lstCSVData) {
			if(!(lstStr != null && lstStr.size() > 13)) {
				msg = 'Number of column headers does not Match with database schema. Please ensure that the file you have uploaded has sufficient number of column.';
				severity = 'error';
				return;
			}
			RandomizationTestingDetail__c randDetails = new RandomizationTestingDetail__c();
			randDetails.FirstName__c = lstStr[0];
			randDetails.MiddleName__c = lstStr[1];
			randDetails.LastName__c = lstStr[2];
			randDetails.Gender__c = lstStr[3];
			if(lstStr[4] != null || lstStr[4] != '') {
				String dateString = lstStr[4];
				List<String> lstDate = dateString.split('/');
				if(lstDate != null && lstDate.size() == 3) {
					randDetails.DOB__c = Date.newinstance(Integer.valueOf(lstDate[2]), Integer.valueOf(lstDate[1]), Integer.valueOf(lstDate[0]));
				}
			} else {
				randDetails.DOB__c = null;
			}
			randDetails.Race__c = lstStr[5];
			randDetails.Ethnicity__c = lstStr[6];
			randDetails.Laterality__c = lstStr[7];
			randDetails.ER__c = lstStr[8];
			randDetails.PR__c = lstStr[9];
			randDetails.HER2ByIHC__c = lstStr[10];
			randDetails.HER2ByFISH__c = lstStr[11];
			randDetails.HER2ByTargetPrint__c = lstStr[12];
			randDetails.MP__c = lstStr[13];
			lstRandomizationDetails.add(randDetails);
		}
		insert lstRandomizationDetails;
		if(lstRandomizationDetails != null && lstRandomizationDetails.size() > 0) {
			msg = 'File uploaded successfully.\nTotal number of record uploaded - '+lstRandomizationDetails.size();
			severity = 'confirm';
		} else {
			msg = 'No record found in uploaded csv file.';
			severity = 'warning';
		}
		
	}
}