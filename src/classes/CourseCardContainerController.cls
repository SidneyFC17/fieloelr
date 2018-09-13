public class CourseCardContainerController {
    @AuraEnabled
    public static String getCourseRecord(String recordId, String fields) {
        try{
            Set<String> fieldNames = new Set<String>();
            fieldNames.addAll(fields.split(','));
            Set<String> queryableFields = new Set<String>();
            
            for(String fieldName:fieldNames) {
                if (fieldName == 'FieloELR__Modules__r') {
                    queryableFields.add('(SELECT Id, Name, FieloELR__Order__c FROM FieloELR__Modules__r WHERE FieloELR__IsActive__c = true) FieloELR__Modules__r');
                } else {
                    queryableFields.add(fieldName);
                }
            }
            CoursesSelector selector = new CoursesSelector(queryableFields);
            return JSON.serialize(selector.selectByIdCustom(new Set<Id>{recordId})[0]);
        } catch(DMLException e) {
            throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getConfig(String courseId, String memberId, String csFields) {
        try{
            Map<String,String> lcConfig = new Map<String,String>();
            String baseURL = Network.getLoginUrl(Network.getNetworkId());
            String uselessString = baseURL.substring(baseURL.lastIndexOf('/')+1);
            baseURL = baseURL.replace(uselessString, '');
            
            Set<String> queryableFields = new Set<String>();
            Set<String> fieldNames = new Set<String>();
            if (csFields != null) {
                fieldNames.addAll(csFields.split(','));
                for(String fieldName:fieldNames) {
                    if (fieldName == 'FieloELR__Transactions__r') {
                        queryableFields.add('(SELECT Id, FieloPLT__Points__c FROM FieloELR__Transactions__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) FieloELR__Transactions__r');
                    } else if (fieldName == 'FieloELR__Trackers__r') {
                        queryableFields.add('(SELECT Id, FieloPLT__Transaction__r.FieloPLT__Points__c FROM FieloELR__Trackers__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) FieloELR__Trackers__r');
                    }
                }
            }

            List<CourseStatus__c> csList = new List<CourseStatus__c>(new CourseStatusSelector(queryableFields).selectByKey(new Set<String>{String.valueOf(courseId) + String.valueOf(memberId)}));
            
            lcConfig.put('orgId', UserInfo.getOrganizationId());
            lcConfig.put('locale', UserInfo.getLocale());
            lcConfig.put('profileId', UserInfo.getProfileId());
            lcConfig.put('communityURL', baseURL);
            lcConfig.put('joinedCourse', String.valueOf(!csList.isEmpty()));
            if (!csList.isEmpty()) {
                lcConfig.put('courseStatus', JSON.serialize(csList[0]));
            }
            return JSON.serialize(lcConfig);
        } catch(DMLException e) {
            throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}