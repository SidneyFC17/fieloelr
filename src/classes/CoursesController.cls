public with sharing class CoursesController {
    @AuraEnabled
	public static String getFilterFieldset(String objectName, String fieldNames, String rangedFields, Boolean useStandardStatusList) {
		try{
			Set<String> rangedFieldSet = new Set<String>(rangedFields != '' && rangedFields != null ? rangedFields.split(',') : new List<String>());
			Map<String, Object> objectInfo = new Map<String, Object>();
			List<Object> fieldsInfoObj = new List<Object>();
            List<Map<String, String>> picklistEntries;
			List<Map<String, Object>> newfieldsInfo = new List<Map<String, Object>>();
			Map<String, Object> fieldMeta;
			Map<String, Object> fieldAttributes;
			Map<String, Object> fieldToMeta;
			Map<String, Object> fieldToAttributes;

			objectInfo = (Map<String, Object>) JSON.deserializeUntyped(AuraService.getFieldData(objectName,fieldNames));
			fieldsInfoObj = (List<Object>) objectInfo.get('fields');

			for (Object fieldMetaObject: fieldsInfoObj) {
				fieldMeta = (Map<String, Object>) fieldMetaObject;
				fieldAttributes = (Map<String, Object>) fieldMeta.get('attributes');
				if (!fieldAttributes.containsKey('isRanged')) {
					fieldAttributes.put('isRanged', (Object) String.valueOf(rangedFieldSet.contains(String.valueOf(fieldAttributes.get('name')))));
					if (rangeLabel.containsKey(String.valueOf(fieldAttributes.get('type')))) {
						fieldAttributes.put('rangeLabel', (Object) String.valueOf(rangeLabel.get(String.valueOf(fieldAttributes.get('type')))));	
					} else {
						fieldAttributes.put('rangeLabel', (Object) Label.RangeSuffix);
					}
				}
				if (String.valueOf(fieldAttributes.get('type')) == 'picklist' ) {
					fieldMeta.put('firstOptionLabel', (Object) Label.All);
				}

                if (objectName.toLowerCase() == 'fieloelr__course__c' && String.valueOf(fieldAttributes.get('name')).toLowerCase() == 'fieloelr__status__c' && !useStandardStatusList) {
					picklistEntries = new List<Map<String, String>>();
                    picklistEntries.add(new Map<String, String>{'value' => 'Active','label'=> Label.ActiveOption});
                    picklistEntries.add(new Map<String, String>{'value' => 'Scheduled','label'=> Label.ScheduledOption});
                    picklistEntries.add(new Map<String, String>{'value' => 'Completed','label'=> Label.CompletedOption});
					if (!picklistEntries.isEmpty()) {
						fieldMeta.put('picklistentries', (Object) picklistEntries);
					}
                    fieldMeta.put('firstOptionLabel', (Object) Label.All);
				}
				fieldMeta.put('attributes', (Object) fieldAttributes);
				newfieldsInfo.add(fieldMeta);

				// Add Field-To value
				if (Boolean.valueOf(fieldAttributes.get('isRanged'))) {
					fieldToMeta = new Map<String, Object>(fieldMeta);
					fieldToAttributes = new Map<String, Object>(fieldAttributes);
					fieldToAttributes.put('isToField', (Object) 'true');
					fieldToAttributes.put('name', (Object) String.valueOf(String.valueOf(fieldToAttributes.get('name') + '-to')));
					fieldToAttributes.put('label', (Object) ' ');
					fieldToMeta.put('attributes', (Object) fieldToAttributes);
					
					if (rangeLabel.containsKey(String.valueOf(fieldToAttributes.get('type')))) {
						fieldToAttributes.put('rangeLabel', (Object) String.valueOf(rangeLabel.get(String.valueOf(fieldToAttributes.get('type')))));	
					} else {
						fieldToAttributes.put('rangeLabel', (Object) Label.RangeSuffix);
					}
					
					newfieldsInfo.add(fieldToMeta);
				}
			}
			objectInfo.put('fields', (Object) newfieldsInfo);
            return JSON.serialize(objectInfo);
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
	}
    
    @AuraEnabled
    public static String getCourses(FieloPLT__Member__c member, List<String> coursesFieldset, List<String> modulesFieldset, Integer quantity, Integer offset, String status, String sortByClause, String dynamicFilter){
        try{
            Set<String> fieldsCourse = new Set<String>(coursesFieldset); 
            Set<String> fieldsModule = new Set<String>(modulesFieldset);
            Set<String> fieldsCourseStatus = new Set<String>{'Name'};
            Set<String> fieldsModuleResponse = new Set<String>{'Name'};
            Set<String> statusList = new Set<String>();
            if ( status == '' || status == null) {
                statusList.add('Active');
				statusList.add('Scheduled');
				statusList.add('Completed');
            }
            Id memberId = member.Id;

			fieldsModule.add('FieloELR__Order__c');

			Set<String> courseFieldsToQuery = new Set<String>();
			for(String fieldName:fieldsCourse) {
				if (fieldName == 'FieloELR__Transactions__r') {
                    courseFieldsToQuery.add('(SELECT Id, FieloPLT__Points__c FROM FieloELR__Transactions__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true)');
                } else if (fieldName == 'FieloELR__Trackers__r') {
                    courseFieldsToQuery.add('(SELECT Id, FieloPLT__Transaction__r.FieloPLT__Points__c FROM FieloELR__Trackers__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true)');
                } else {
					courseFieldsToQuery.add(fieldName);
				}
			}
            
            List<FieloELR__Course__c> courses = CourseService.getCourses(
                                            courseFieldsToQuery, 
											new Set<String>{'Id','Name'},
											fieldsModule,
											null,
											statusList,
											member.FieloPLT__Program__c,
                                            memberId,
											false,
											true,
											true,
											quantity,
											offset,
											sortByClause != null && sortByClause != '' ? sortByClause : 'LastModifiedDate DESC',
											dynamicFilter != null && dynamicFilter != '' ? dynamicFilter : '');
            return JSON.serialize(courses);
       } catch(DMLException e) {
           throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
             throw new AuraHandledException(e.getMessage());
        }
    }

    public static Map<String, String> rangeLabel {get{
		if (rangeLabel == null) {
			rangeLabel = new Map<String, String>{
				'currency' => Label.CurrencyRangeSuffix,
        		'double' => Label.DoubleRangeSuffix,
        		'percent' => Label.PercentRangeSuffix,
        		'date' => Label.DateRangeSuffix,
        		'datetime' => Label.DatetimeRangeSuffix
			};
		}
		return rangeLabel;
	} set; }

	@AuraEnabled
	public static String getConfig() {
		try{
            Map<String,String> lcConfig = new Map<String,String>();

			String baseURL = Network.getLoginUrl(Network.getNetworkId());
			String uselessString = baseURL.substring(baseURL.lastIndexOf('/')+1);
			baseURL = baseURL.replace(uselessString, '');
			baseURL = baseURL.replace('/s/','/');

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

	@AuraEnabled
	public static String getCourseFieldsData(String objectName, String fieldNames) {
		try{
            return AuraService.getFieldData(objectName,fieldNames);
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return null;
	}

	@AuraEnabled
	public static String getCourseByCourseStatus(FieloPLT__Member__c member, List<String> coursesFieldset, List<String> modulesFieldset, Integer quantity, Integer offset, String status, String sortByClause, String dynamicFilter, Boolean showPointsEarned) {
		try{
			Set<String> courseStatusFields = new Set<String>();
			if (showPointsEarned != null && showPointsEarned) {
				courseStatusFields.add('(SELECT Id, FieloPLT__Points__c FROM FieloELR__Transactions__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) FieloELR__Transactions__r');
				courseStatusFields.add('(SELECT Id, FieloPLT__Transaction__r.FieloPLT__Points__c FROM FieloELR__Trackers__r WHERE FieloPLT__IsReverted__c = false AND FieloPLT__IsProcessed__c = true) FieloELR__Trackers__r');
			}
			courseStatusFields.add('Id');
			courseStatusFields.add('FieloELR__Course__c');
            CourseStatusSelector selector = new CourseStatusSelector(courseStatusFields);
			selector.setLimit(quantity);
			selector.setOffset(offset);
			List<CourseStatus__c> courseStatusList = selector.selectByMemberId(new Set<Id>{member.Id});
			Set<Id> courseIds = new Set<Id>();

			for(CourseStatus__c cs: courseStatusList) {
				courseIds.add(cs.Course__c);
			}

			Set<String> courseFieldsToQuery = new Set<String>();
			Set<String> fieldsCourse = new Set<String>(coursesFieldset);
            Set<String> fieldsModule = new Set<String>(modulesFieldset);

			for(String fieldName: fieldsCourse) {
				if (fieldName == 'FieloELR__Modules__r') {
                    courseFieldsToQuery.add('(SELECT Id, Name, FieloELR__Order__c FROM FieloELR__Modules__r WHERE FieloELR__IsActive__c = true) FieloELR__Modules__r');
				} else {
					courseFieldsToQuery.add(fieldName);
				}
			}
			
			fieldsModule.add('FieloELR__Order__c');
            
            List<FieloELR__Course__c> courses = CourseService.getCourses(
                                            courseFieldsToQuery, 
											new Set<String>{'Id','Name'},
											fieldsModule,
											courseIds,
											null,
											member.FieloPLT__Program__c,
                                            member.Id,
											false,
											false,
											false,
											quantity,
											offset,
											sortByClause != null && sortByClause != '' ? sortByClause : 'LastModifiedDate DESC' ,
											dynamicFilter != null && dynamicFilter != '' ? dynamicFilter : '');
			
			Map<String, String> result = new Map<String, String>{
				'courses' => JSON.serialize(courses),
				'courseStatus' => JSON.serialize(courseStatusList[0])
			};
            return JSON.serialize(result);
       } catch(DMLException e) {
           throw new AuraHandledException(e.getDMLMessage(0));
        } catch(Exception e){
             throw new AuraHandledException(e.getMessage());
        }
	}
}