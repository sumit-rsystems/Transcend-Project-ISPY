public with sharing class CrfXMLSelection {
	String[] XML = new String[]{};
	
        public PageReference test() {
            return null;
        }
            
        public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('','- - - -None- - - - '));
            options.add(new SelectOption('Registration XML','Registration XML'));
            options.add(new SelectOption('Adverse Event XML','Adverse Event XML'));
            return options;
        } 
        public String[] getXML() {
            return XML;
        }
        public void setXML(String[] XML) {
            this.XML = XML;
        }
}