public class Dashboard{
    
   public List<wrap> wrapList{get; set;}
  // public List<wrap> getPieData() {
   
   public Dashboard(){
   System.debug('darshan01');
       wrapList = new List<wrap>();
    //  showRecords(); 
   }
    
   // public void showRecords(){
   public List<wrap> getPieData() {
      System.debug('darshan01');
        //String  selectedId = ApexPages.currentPage().getParameters().get('pid');
           List<Phase_Master__c> accList = [select id,(select id, Name  from Patients__r) , Name,Order__c from Phase_Master__c ];
            for(Phase_Master__c c :accList){
               System.debug('darshan02');
               
               if(c.Name != Null){
                  System.debug('darshan03');
                        system.debug('====c.name====='+c.name);
                        List<Patient_Custom__c>contList = c.Patients__r;
                        wrapList.add(new wrap(c,contList));
                        system.debug('====wrapList====='+wrapList);
                }
            
            }
               System.debug('darshan04');
           return wrapList;
        
    }
    
    public class wrap{
        public Phase_Master__c acc{get; set;}
        public List<Patient_Custom__c> conList{get; set;}
        
        public wrap(Phase_Master__c acc, List<Patient_Custom__c> conList){
       System.debug('darshan06');
            this.acc = acc;
            this.conList = conList;
        }
    } 
}