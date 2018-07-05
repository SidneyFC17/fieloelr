@isTest
public class TestUpdateActiveModulesBatchSchedule {

    @testSetup static void setup(){
        MockUpFactory.InsertTestData();
    }
    
    @isTest
    static void runUpdate(){
        List<Module__c> modules = [SELECT Id FROM Module__c WHERE IsActive__c != true];

        for (Module__c module: modules) {
            module.IsActive__c = true;
        }

        update modules;
        
        Test.startTest();
        DataBase.executeBatch(new UpdateActiveModulesBatchSchedule());
        Test.stopTest();
        
    }
}