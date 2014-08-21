public with sharing class TestHarnessRandomizationResultController {
	
	public List<List<RandomizationResultWrapper>> lstRandResultWrapperList {get;set;}
	
	private String sortDirection = 'ASC';
    private String sortExp = 'name';

    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
            sortDirection = 'ASC';
            sortExp = value;
        }
   }

    public String getSortDirection()
    {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }

    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    
    public void displayRandomizationResult() {
        TestHarnessService service = new TestHarnessService();
        lstRandResultWrapperList = service.getRandomizationResult(sortExpression  + ' ' + sortDirection);
    }
    
    public void sortResult() {
        TestHarnessService service = new TestHarnessService();
        lstRandResultWrapperList = service.getRandomizationResult(sortExpression  + ' ' + sortDirection);
        system.debug('lstRandResultWrapperList.size() : '+lstRandResultWrapperList.size());
        
        for(List<RandomizationResultWrapper> lstRR : lstRandResultWrapperList) {
            system.debug('lstRR.size() : '+lstRR.size());
        }
    }
}