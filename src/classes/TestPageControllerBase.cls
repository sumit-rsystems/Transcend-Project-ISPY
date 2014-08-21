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
private class TestPageControllerBase {

    @isTest static void myUnitTest() {
        // TO DO: implement unit test
        
        ComponentControllerBase ccb = new ComponentControllerBase();
        ccb.key = '1';
        
        PageControllerBase pcb = new PageControllerBase();
        pcb.getComponentControllerMap();
        pcb.getDcisController();
        pcb.getIvtComponentController();
        pcb.getLcisComponentController();
        pcb.getReceptorsComponentController();
        pcb.getAddQuesComponentController();
        pcb.getAddToxicityCompController();
        pcb.getStagingCompController();
        pcb.getRegimenAgentCompController();
        pcb.getThis();
        
        pcb.setComponentControllerMap('1', ccb);
        pcb.setDcisController(ccb);
        pcb.setIvtComponentController(ccb);
        pcb.setLcisComponentController(ccb);
        pcb.setReceptorsComponentController(ccb);
        pcb.setAddQuesComponentController(ccb);
        pcb.setAddToxicityCompController(ccb);
        pcb.setStagingCompController(ccb);
        pcb.setRegimenAgentCompController(ccb);
        
    }
}