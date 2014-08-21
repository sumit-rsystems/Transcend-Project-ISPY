public  with sharing  class Chart {

    public Widget__c widget{get;set;}
    private IChart chart;
    
    public Chart(IChart chart)
    {
        this.chart = chart;
        //widget = new Widget__c();
    }

    public String getChartData(){
    
         return chart.getData(widget);
    }
}