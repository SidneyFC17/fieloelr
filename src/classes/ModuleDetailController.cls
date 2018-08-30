public with sharing class ModuleDetailController {
	@AuraEnabled
	public static String getModule(FieloPLT__Member__c member, String moduleId, String moduleFields, String moduleResponseFields) {
		try{
			String memberId = member.Id;

			Set<String> moduleFieldSet = new Set<String>();
			if (moduleFields != '' && moduleFields != null) {
				moduleFieldSet.addAll(moduleFields.split(','));
			}

			moduleFieldSet.add('FieloELR__KeyDependencies__c');
			moduleFieldSet.add('FieloELR__Course__c');

			String modulesQuery = 'SELECT ' +
				String.join(new List<String>(moduleFieldSet), ',') +
				' FROM FieloELR__Module__c WHERE Id = :moduleId';

			List<Module__c> modules = (List<Module__c>) Database.query(modulesQuery);
			
			Set<String> moduleResponseFieldSet = new Set<String>();
			if (moduleResponseFields != '' && moduleResponseFields != null) {
				moduleResponseFieldSet.addAll(moduleResponseFields.split(','));
			}

			moduleResponseFieldSet.add('FieloELR__Member__c');

			String modulesResponseQuery = 'SELECT ' +
				String.join(new List<String>(moduleResponseFieldSet), ',') +
				' FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__c = :moduleId AND FieloELR__Member__c = :memberId AND FieloELR__IsSubmitted__c = true ORDER BY CreatedDate DESC';

			List<ModuleResponse__c> moduleResponses = (List<ModuleResponse__c>) Database.query(modulesResponseQuery);

			String moduleDependencyQuery = 'SELECT Id, ' +
				'FieloELR__Predecessor__r.Name ' +
				' FROM FieloELR__ModuleDependency__c ' +
				' WHERE FieloELR__Module__c = :moduleId AND FieloELR__Predecessor__r.FieloELR__IsActive__c = true';

			List<ModuleDependency__c> dependencies = (List<ModuleDependency__c>) Database.query(moduleDependencyQuery);

			CourseService.ModuleWrapper mw;
			
			if (!moduleResponses.isEmpty()) {
				mw = new CourseService.ModuleWrapper(modules[0], moduleResponses, dependencies);
			} else {
				mw = new CourseService.ModuleWrapper(modules[0], dependencies, member.Id);
			}

			return JSON.serialize(mw);
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

	@AuraEnabled
	public static String getCourseData(FieloPLT__Member__c member, String courseId) {
		try{
			String key = courseId + member.Id;
			String courseStatusQuery = 'SELECT Id, Name, FieloELR__Course__c, (SELECT Id, Name, FieloELR__Module__c, FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponses__r ORDER BY FieloELR__Module__r.FieloELR__Order__c, FieloELR__NumberOfAttempt__c ) FROM FieloELR__CourseStatus__c WHERE FieloELR__ExternalKey__c = :key';

			List<FieloELR__CourseStatus__c> courseStatus = (List<FieloELR__CourseStatus__c>) Database.query(courseStatusQuery);

			List<CourseService.CourseWrapper> courseWrappers = CourseService.getCoursesMap(
											new Set<String>{'Id','FieloELR__SubscriptionMode__c','FieloELR__Status__c'},
											new Set<String>{'Id','Name'},
											new Set<String>{'Id','Name'},
											null,
											new Set<Id>{courseId},
											member.FieloPLT__Program__c,
                                            member.Id,
											false,
											false,
											null, 
											null, 
											'LastModifiedDate DESC' ,
											'');

			return JSON.serialize(new Map<String, Object>{
				'courseStatus' => courseStatus,
				'courseWrapper' => courseWrappers
			});
		} catch(DMLException e) {
           	throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
	}

	@AuraEnabled
	public static String getConfig() {
		try{
            Map<String,String> lcConfig = new Map<String,String>();

			String baseURL = '';
			if (!Test.isRunningTest()) {
				baseURL = Network.getLoginUrl(Network.getNetworkId());
				String uselessString = baseURL.substring(baseURL.lastIndexOf('/')+1);
				baseURL = baseURL.replace(uselessString, '');
			}

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
	}
}