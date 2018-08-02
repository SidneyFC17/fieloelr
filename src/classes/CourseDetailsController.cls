public with sharing class CourseDetailsController {
		
		@AuraEnabled
		public static FieloELR__Course__c getCourse(ID courseId){
			try{
				List <FieloELR__Course__c> courses = (List <FieloELR__Course__c>)[SELECT Name, Description__c, StartDate__c, EndDate__c, Image__c, ActiveModules__c, Status__c, SubscriptionMode__c FROM Course__c WHERE Id =: courseId LIMIT 1];
				if (courses.size() > 0) {
					System.debug(courses[0]);
					return courses[0];
				}
			} 
			catch (DmlException e) {
				throw new AuraHandledException(e.getDmlMessage(0));
			} 
			catch (Exception e) {
				throw new AuraHandledException(e.getMessage());
			}
			return null;
		}

		@AuraEnabled
		public static String getConfig(String recordId, String memberId, String csFields){
			try {
				Map<String,String> lcConfig = new Map<String,String>();
				String baseUrl = Network.getLoginUrl(Network.getNetworkId());
				System.debug(baseUrl);
				String uselessString = baseURL.substring(baseURL.lastIndexOf('/')+1);
				System.debug(uselessString);
				baseURL = baseURL.replace(uselessString, '').replace('/s/','/');
				System.debug(baseUrl);
				System.debug(JSON.serialize(csFields));
				Set<String> queryableFields = new Set<String>();
				Set<String> fieldNames = new Set<String>();
				if (csFields != null) {
					fieldNames.addAll(csFields.split(','));
					for(String fieldName:fieldNames) {
						if (fieldName == 'FieloELR__Transactions__r') {
							queryableFields.add('(SELECT Id, FieloPLT__Points__c FROM FieloELR__Transactions__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) FieloELR__Transactions__r');
						} else if (fieldName == 'FieloELR__Trackers__r') {
							queryableFields.add('(SELECT Id, FieloPLT__Transaction__r.FieloPLT__Points__c FROM FieloELR__Trackers__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) FieloELR__Trackers__r');
						} else {
							queryableFields.add(fieldName);
						}
					}
				}
				List<CourseStatus__c> csList = new List<CourseStatus__c>(new CourseStatusSelector(queryableFields).selectByKey(new Set<String>{String.valueOf(recordId) + String.valueOf(memberId)}));
				System.debug(JSON.serialize(csList));

				lcConfig.put('orgId', UserInfo.getOrganizationId());
				lcConfig.put('locale', UserInfo.getLocale());
				lcConfig.put('profileId', UserInfo.getProfileId());
				lcConfig.put('communityURL', baseURL);
				lcConfig.put('joinedCourse', String.valueOf(!csList.isEmpty()));
				lcConfig.put('orgId', UserInfo.getOrganizationId());
				
				System.debug(JSON.serialize(lcConfig));
				return JSON.serialize(lcConfig);
				
			}
			catch(DMLException e){
				throw new AuraHandledException(e.getDMLMessage(0));	
			} 
			catch (Exception e) {
				throw new AuraHandledException(e.getMessage());
			}


		}

		@AuraEnabled
		public static String getCourseStatus(FieloPLT__Member__c member, Id courseId, Boolean includePoints) {
		try{
			Id memberId = member.Id;
			String key = String.valueOf(courseId) + String.valueOf(memberId);

			Set<String> fieldsModuleResponse = new Set<String>();
			fieldsModuleResponse.add('Id');
			fieldsModuleResponse.add('FieloELR__Module__c');
			fieldsModuleResponse.add('FieloELR__IsApproved__c');
			fieldsModuleResponse.add('FieloELR__NumberOfAttempt__c');
			fieldsModuleResponse.add('FieloELR__NumberofApprove__c');
			fieldsModuleResponse.add('FieloELR__GradePercent__c');
			fieldsModuleResponse.add('FieloELR__SubmitDate__c');
			fieldsModuleResponse.add('FieloELR__CorrectQuestions__c');
			fieldsModuleResponse.add('FieloELR__IncorrectQuestions__c');
			fieldsModuleResponse.add('FieloELR__CourseStatus__r.FieloELR__Progress__c');
			fieldsModuleResponse.add('FieloELR__CourseStatus__r.FieloELR__Course_Accomplished__c');

			if (includePoints != null && includePoints) {
				fieldsModuleResponse.add('(SELECT Id, FieloPLT__Points__c FROM FieloELR__Transactions__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) FieloELR__Transactions__r');
                fieldsModuleResponse.add('(SELECT Id, FieloPLT__Transaction__r.FieloPLT__Points__c FROM FieloELR__Trackers__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) FieloELR__Trackers__r');
			}
			
			String queryModuleResponse = 'SELECT ' + String.join(new List<String>(fieldsModuleResponse), ',');
			queryModuleResponse += ' FROM FieloELR__ModuleResponse__c WHERE FieloELR__CourseStatus__r.FieloELR__ExternalKey__c = :key';

			System.debug(JSON.serialize(Database.query(queryModuleResponse)));

			return JSON.serialize(Database.query(queryModuleResponse));
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
	}
}