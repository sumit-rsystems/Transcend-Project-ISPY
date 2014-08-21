public with sharing class XLSParser {
	public String[] filelines {get;set;}
	public Blob fileBody {get;set;}
	public String fileName {get;set;}
	public void parseXLS() {
		String xlsFile = fileBody.toString();
		List<List<String>> parsedContent = CSVParser.parseCSV(xlsFile, false);
		system.debug('Result size : '+parsedContent.size());
	}
}