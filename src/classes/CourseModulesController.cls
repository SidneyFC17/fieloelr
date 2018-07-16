public with sharing class CourseModulesController {
	@AuraEnabled
	public static String getCourseMap(FieloPLT__Member__c member, Id courseId, String modulesFieldset, Boolean includePoints, Boolean includeQuestions) {
		try{
			Id memberId = member.Id;
			Id programId = member.FieloPLT__Program__c;
			Set<String> fieldsModule = new Set<String> ( modulesFieldset.split(',') );

			if (includeQuestions) {
				fieldsModule.add('FieloELR__NumberOfQuestions__c');
			}

			Set<String> fieldsModuleResponse = new Set<String>();
			fieldsModuleResponse.add('Id');
			fieldsModuleResponse.add('FieloELR__Module__c');
			fieldsModuleResponse.add('FieloELR__IsApproved__c');

			if (includePoints != null && includePoints) {
				fieldsModuleResponse.add('(SELECT Id, FieloPLT__Points__c FROM FieloELR__Transactions__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) FieloELR__Transactions__r');
                fieldsModuleResponse.add('(SELECT Id, FieloPLT__Transaction__r.FieloPLT__Points__c FROM FieloELR__Trackers__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) FieloELR__Trackers__r');
			}

			List<CourseService.CourseWrapper> coursesMap;
			
			coursesMap = CourseService.getCoursesMap(
				new Set<String>{'Id','FieloELR__SubscriptionMode__c','FieloELR__Status__c'},
				new Set<String>{'Id','Name'},
				fieldsModule,
				null,
				new Set<Id>{courseId},
				programId,
				memberId,
				false,
				true,
				100,
				0,
				'FieloELR__Order__c',
				''
			);

			return JSON.serialize(coursesMap);
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
	}

	@AuraEnabled
	public static String getCourseStatus(FieloPLT__Member__c member, Id courseId) {
		try{
			Id memberId = member.Id;

			List<FieloELR__CourseStatus__c> courseStatus = CourseService.getCourseStatus(
				new Set<String>{'Id','FieloELR__Progress__c','FieloELR__Course__c'},
				new Set<String>{'Id','FieloELR__IsApproved__c','FieloELR__Module__c'},
				new Set<Id>{courseId},
				memberId,
				100,
				0,
				'FieloELR__Course__r.FieloELR__Order__c'
			);

			return JSON.serialize(courseStatus[0]);
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
	}

	@AuraEnabled
	public static String getFieldData(String sObjectName, String fields) {
		try{
			return AuraService.getFieldData(sObjectName, fields);
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
	}
}