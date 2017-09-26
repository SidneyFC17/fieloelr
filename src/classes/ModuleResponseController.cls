public with sharing class ModuleResponseController {
     @auraEnabled
    public static String getModuleResponse(String moduleResponseId){        
        try{
            Set<String> fieldsModuleResponse = new Set<String>{'Name','FieloELR__GradeValue__c', 'FieloELR__Module__r.Name'}; 
            Set<String> fieldsQuestion = new Set<String>{'Name','FieloELR__QuestionText__c','FieloELR__Type__c'}; 
            Set<String> fieldsAnswerOption = new Set<String>{'Name','FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c'}; 
            FieloELR.ModuleService.ModuleResponseResult mrWrapper = FieloELR.ModuleService.getModuleResponse(moduleResponseId, fieldsModuleResponse, fieldsQuestion, fieldsAnswerOption);
            return JSON.serialize(mrWrapper);              
   } catch(DMLException e) {
          return e.getDMLMessage(0);
        } catch(Exception e){
          return e.getMessage();
        }     
    }
}