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

			List<CourseService.ModuleWrapper> mws = new List<CourseService.ModuleWrapper>();
			
			Set<Id> mrIds = new Set<Id>();

			for( CourseService.ModuleWrapper mw:coursesMap[0].modules) {
				if (mw.moduleResponses != null) {
					if (!mw.moduleResponses.isEmpty()) {
						mrIds.addAll(new Map<Id,ModuleResponse__c>(mw.moduleResponses).keySet());
					}
				}
			}

			if (!mrIds.isEmpty()) {
				Map<Id,ModuleResponse__c> mrMap = new Map<Id,ModuleResponse__c>(new ModuleResponsesSelector(fieldsModuleResponse).selectById(mrIds));
				Map<Id,List<ModuleResponse__c>> mrMapByModule = new Map<Id,List<ModuleResponse__c>>();
				for( ModuleResponse__c mr: mrMap.values()) {
					if (!mrMapByModule.containsKey(mr.Module__c)) {
						mrMapByModule.put(mr.Module__c, new List<ModuleResponse__c>());
					}
					mrMapByModule.get(mr.Module__c).add(mr);
				}

				for( CourseService.ModuleWrapper mw:coursesMap[0].modules) {
					if (!mw.moduleResponses.isEmpty()) {
						mws.add(new CourseService.ModuleWrapper(mw.module, mrMapByModule.get(mw.module.Id)));
					}
				}

				coursesMap[0].modules.clear();
				coursesMap[0].modules.addAll(mws);
			}

			return JSON.serialize(coursesMap);
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
	}

	@AuraEnabled
	public static String getCourseMap(FieloPLT__Member__c member, Id courseId, String modulesFieldset, Boolean includePoints, Boolean includeQuestions) {
		try{

			return JSON.serialize(coursesMap);
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
	}
}