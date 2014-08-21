public with sharing virtual class PageControllerBase {
	
  private ComponentControllerBase dcisController;
  private ComponentControllerBase lcisComponentController;
  private ComponentControllerBase ivtComponentController;
  private ComponentControllerBase receptorsComponentController;
  private ComponentControllerBase addQuesComponentController;
  private ComponentControllerBase addToxicityCompController;
  private ComponentControllerBase regimenAgentCompController;
  private ComponentControllerBase stagingCompController;
  
  private Map<String, ComponentControllerBase>componentControllerMap; //new
	
  public virtual ComponentControllerBase getDcisController() {
    return dcisController;
  }
  
  public virtual ComponentControllerBase getStagingCompController() {
    return stagingCompController;
  }
  
  public virtual ComponentControllerBase getLcisComponentController() {
    return lcisComponentController;
  }
  
  public virtual ComponentControllerBase getIvtComponentController() {
    return ivtComponentController;
  }
  
  public virtual ComponentControllerBase getReceptorsComponentController() {
    return receptorsComponentController;
  }
  
  public virtual ComponentControllerBase getAddQuesComponentController() {
    return addQuesComponentController;
  }
  
  public virtual ComponentControllerBase getRegimenAgentCompController() {
    return regimenAgentCompController;
  }
  
   public virtual ComponentControllerBase getAddToxicityCompController() {
    return addToxicityCompController;
  }

  //new getter for the hashmap
  public virtual Map<String, ComponentControllerBase> getComponentControllerMap(){
    return componentControllerMap;
  }
  //new method for putting value in the hashmap
  public virtual void setComponentControllerMap(String key, ComponentControllerBase compController){
    if(componentControllerMap == null)
      componentControllerMap = new Map<String, ComponentControllerBase>();
    componentControllerMap.put(key,compController); 
  }
  
  public virtual void setDcisController(ComponentControllerBase compController) {
    dcisController = compController;
  }
  
  public virtual void setStagingCompController(ComponentControllerBase compController) {
    stagingCompController = compController;
  }
  
  public virtual void setLcisComponentController(ComponentControllerBase compController) {
    lcisComponentController = compController;
  }
  
  public virtual void setIvtComponentController(ComponentControllerBase compController) {
    ivtComponentController = compController;
  }
  
  public virtual void setReceptorsComponentController(ComponentControllerBase compController) {
    receptorsComponentController = compController;
  }
  
  public virtual void setAddQuesComponentController(ComponentControllerBase compController) {
    addQuesComponentController = compController;
  }
  
  public virtual void setAddToxicityCompController(ComponentControllerBase compController) {
    addToxicityCompController = compController;
  }
  
   public virtual void setRegimenAgentCompController(ComponentControllerBase compContoller) {
   	regimenAgentCompController = compContoller;
  }
	
  public PageControllerBase getThis() {
    return this;
  }
	
}