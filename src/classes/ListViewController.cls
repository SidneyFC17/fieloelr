public with sharing class ListViewController {
    
    @auraEnabled
    public static List<sObject> getRecords(String fieldset, String objectType, String whereCondition){
        try{
            whereCondition = String.isNotBlank(whereCondition) ? ' WHERE ' + whereCondition : '';

            SObjectType convertType = Schema.getGlobalDescribe().get(objectType);

            SecurityUtils.checkObjectIsReadable(convertType);
            return database.query('SELECT ' + fieldset + ' FROM ' + objectType + whereCondition);            
        } catch(DMLException e) {
            throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }  
    }
    @auraEnabled
    public static map<String, String> getFieldLabels(String objectAPIName){
        map<String, String> mapFieldLabels = new map<String, String>();
        for(Schema.SObjectField sfield: Schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap().Values()){
            mapFieldLabels.put(sfield.getDescribe().getName(), sfield.getDescribe().getLabel());
        }
        return mapFieldLabels;
    }   
}