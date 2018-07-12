public with sharing class CourseDetailsController {
	
	@AuraEnabled
    public static FieloELR__Course__c getCourse(ID courseId){
        
        //String idFixo = 'a0r6A000001NIGNQA4'; 

       try{
       List <FieloELR__Course__c> courses = (List <FieloELR__Course__c>)[SELECT Name, Description__c, StartDate__c, EndDate__c, Image__c, ActiveModules__c FROM Course__c WHERE Id =: courseId LIMIT 1];
		if(courses.size() > 0){
			System.debug(courses[0]);
			return courses[0];
			} 
			//AuraService.getFieldData(objectName,fieldNames);
		} 
		catch (DmlException e) {
			throw new AuraHandledException(e.getDmlMessage(0));
		} 
		catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
		return null;
	}

	/*

	@AuraEnabled
	public static String getConfig() {
		try{
            Map<String,String> lcConfig = new Map<String,String>();

			String baseURL = Network.getLoginUrl(Network.getNetworkId());
			String uselessString = baseURL.substring(baseURL.lastIndexOf('/')+1);
			baseURL = baseURL.replace(uselessString, '');

			lcConfig.put('orgId', UserInfo.getOrganizationId());
			lcConfig.put('locale', UserInfo.getLocale());
			lcConfig.put('profileId', UserInfo.getProfileId());
			lcConfig.put('communityURL', baseURL);

            return JSON.serialize(lcConfig);
       } catch(DMLException e) {
           throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
             throw new AuraHandledException(e.getMessage());
        }
	} */

}
      

/*

public with sharing class CourseDetailsController {
	@AuraEnabled
    
    public static sObject getFieldData(String objectName){
        try{
        	[SELECT Id, Name, Description__c, StartDate__c, EndDate__c, Image__c, ActiveModules__c FROM Course__c LIMIT 1];
			return AuraService.getFieldData(objectName,fieldNames);
		} 
		catch (DmlException e) {
			throw new AuraHandledException(e.getDmlMessage(0));
		} 
		catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
		return null;
	}

}
      
    
}

@AuraEnabled
public static String getFieldData(String objectName, String fieldNames) {
*/