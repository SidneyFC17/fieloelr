public with sharing class CourseModulesController {
	@AuraEnabled
	public static String getCourseMap(FieloPLT__Member__c member, Id courseId, String courseFields, String modulesFieldset) {
		try{
			Id memberId = member.Id;
			Id programId = member.FieloPLT__Program__c;
			
			Set<String> fieldsCourse = new Set<String> ( courseFields.split(',') );
			Set<String> fieldsModule = new Set<String> ( modulesFieldset.split(',') );

			fieldsModule.add('Id');
			fieldsModule.add('FieloELR__AttemptsAllowed__c');
			fieldsModule.add('FieloELR__IsActive__c');
			fieldsModule.add('FieloELR__KeyDependencies__c');

			fieldsCourse.add('Id');
			fieldsCourse.add('FieloELR__SubscriptionMode__c');
			fieldsCourse.add('FieloELR__Description__c');
			fieldsCourse.add('FieloELR__Status__c');

			List<CourseService.CourseWrapper> coursesMap;
			
			coursesMap = CourseService.getCoursesMap(
				fieldsCourse,
				new Set<String>{'Id','Name','FieloELR__Predecessor__r.Name'},
				fieldsModule,
				new Set<String>{'Id','FieloELR__Predecessor__r.Name'},
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
			fieldsModuleResponse.add('FieloELR__CourseStatus__r.Id');
			fieldsModuleResponse.add('FieloELR__CourseStatus__r.FieloELR__Progress__c');

			if (includePoints != null && includePoints) {
				fieldsModuleResponse.add('(SELECT Id, FieloPLT__Points__c FROM FieloELR__Transactions__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) FieloELR__Transactions__r');
                fieldsModuleResponse.add('(SELECT Id, FieloPLT__Transaction__r.FieloPLT__Points__c FROM FieloELR__Trackers__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) FieloELR__Trackers__r');
			}
			
			String queryModuleResponse = 'SELECT ' + String.join(new List<String>(fieldsModuleResponse), ',');
			queryModuleResponse += ' FROM FieloELR__ModuleResponse__c WHERE FieloELR__CourseStatus__r.FieloELR__ExternalKey__c = :key';

			return JSON.serialize(Database.query(queryModuleResponse));
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