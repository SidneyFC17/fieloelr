global with sharing class CourseService {
	
	public static List<Course__c> getCourses(Set<String> fields, Set<String> status, Id programId, Integer quantity, Integer offset, String orderBy) {   
		String query = 'SELECT ' + String.join(new List<String>(fields), ',') + ' FROM Course__c ';
		// WHERE CONDITION 
		String whereCondition = '';
		if (programId != null) {
			whereCondition += 'AND Program__c =: programId ';
		}
		if (status != null) {
			whereCondition += 'AND Status__c IN :status ';
		}
		if ( whereCondition != '' ) {
			query += ' WHERE ' + whereCondition.substring(4);
		}
		// ORDER BY,  LIMIT & OFFSET
		if( String.isNotBlank(orderBy) ){
			query += ' ORDER BY ' + orderBy;
		}
		if(quantity != null){
			query += ' LIMIT ' + quantity;

			if(offset != null){
				query += ' OFFSET ' + offset;
			}
		}

		return Database.query(query);
	}

	global static List<Course__c> getCourses(Set<String> fieldsCourse, 
											Set<String> fieldsCourseDependency,
											Set<String> fieldsModule,
											Set<Id> courseIds, 
											Id programId, 
											Id memberId, 
												Boolean filterByDependecies, 
												Boolean filterBySegments, 
												Boolean filterByNotTaken, 
											Integer quantity, 
											Integer offset, 
											String orderBy, 
											String dynamicFilter) {
		String queryCourses = 'SELECT ' + String.join(new List<String>(fieldsCourse), ',');
		if(fieldsCourseDependency != null){
			queryCourses += ' ,(SELECT ' + String.join(new List<String>(fieldsCourseDependency), ',') + ' FROM PredecessorCourses__r) ';
		}
		if(fieldsModule != null){
			queryCourses += ' ,(SELECT ' + String.join(new List<String>(fieldsModule), ',') + ' FROM Modules__r) ';
		}
		
		queryCourses += ' FROM Course__c WHERE ';
		if (courseIds != null) {
			queryCourses += ' Id in : courseIds ';
		}else{
			queryCourses += ' Status__c = \'Active\' ';
		}
		
		if (programId != null) {
			queryCourses += ' AND Program__c =: programId ';
		}

		if(memberId != null){
			if(filterBySegments){
				Set<Id> segmentIds = FieloPLT.SegmentService.getMemberSegments(memberId, null);
				queryCourses += ' AND (Segment__c = null OR Segment__c in : segmentIds) ';
			}

			if(filterByNotTaken){
				queryCourses += ' AND Id NOT in (SELECT Course__c FROM CourseStatus__c WHERE Member__c =: memberId) ';
			}

			if(filterByDependecies){
				Set<String> cdStringKeys = getCDStringKeys(null, memberId);
				queryCourses += ' AND (HasDependencies__c = false OR (HasDependencies__c = true AND KeyDependencies__c in : cdStringKeys))';
			}
		}	
	
		if(String.isNotBlank(dynamicFilter)){
			queryCourses += ' AND ' + getDynamicWhereCondition(dynamicFilter);
		}

		if( String.isNotBlank(orderBy) ){
			queryCourses += ' ORDER BY ' + orderBy;
		}
		if(quantity != null){
			queryCourses += ' LIMIT ' + quantity;

			if(offset != null){
				queryCourses += ' OFFSET ' + offset;
			}
		}

		system.debug(queryCourses);
		return Database.query(queryCourses);
	}

	private static String getDynamicWhereCondition(String jsonCondition){
		List<FilterWrapper> filterWrappers;
		try{
			filterWrappers = (List<FilterWrapper>)JSON.deserializeStrict(jsonCondition, List<FilterWrapper>.class);
		}catch(Exception e){
			throw new FieloPLT.FieloException('JSON wrong format');
		}
		
		if(filterWrappers.isEmpty()){
			return '';
		}

		Map<String,String> operatorsMap = new Map<String,String>{'eq'=>'=','gt'=>'>'};
		Set<String> andoroperators = new Set<String>{'and','or'};
		Set<String> nonQuotedTypes = new Set<String>{'DOUBLE','DATETIME','DATE','CURRENCY','INTEGER','BOOLEAN','PERCENT','TIME'};
		Map<String,Schema.SObjectField> fieldsTypeMap = Course__c.getSObjectType().getDescribe().fields.getMap();
		
		if(!String.isBlank(filterWrappers[0].andOrOperator)){
			throw new FieloPLT.FieloException('And_Or Operator for the first condition must be blank.');
		}

		String whereCondition = '(';
		Integer position = 0;
		for(FilterWrapper filter : filterWrappers){
			if(String.isBlank(filter.field) || !fieldsTypeMap.containsKey(filter.field)){
				throw new FieloPLT.FieloException('Field ' + filter.field + ' not found in object.');
			}

			if(String.isBlank(filter.operator) || !operatorsMap.containsKey(filter.operator)){
				throw new FieloPLT.FieloException('Operator ' + filter.operator + ' not found.');
			}

			if(!String.isBlank(filter.andOrOperator) && !andoroperators.contains(filter.andOrOperator)){
				throw new FieloPLT.FieloException('And_Or Operator ' + filter.andOrOperator + ' not found.');
			}

			if(position != 0 && String.isBlank(filter.andOrOperator)){
				throw new FieloPLT.FieloException('And_Or Operator must be null only for the first condition.');
			}

			//whereCondition = '(' + whereCondition;
			
			if(!String.isBlank(filter.andOrOperator)){
				whereCondition += ' ' + filter.andOrOperator + ' ';
			}
			
			String fieldType = fieldsTypeMap.get(filter.field).getDescribe().getType().name();
            if(nonQuotedTypes.contains(fieldType)){
                whereCondition += filter.field + ' = ' + filter.value;
            } else {
                whereCondition += filter.field + ' = \'' + filter.value + '\'';
            }
            //whereCondition += ')';
            position++;
		}

		whereCondition += ')';
		return whereCondition;
	}

	private class FilterWrapper{
		public String field;
		public String value;
		public String operator;
		public String andOrOperator;
	}

	//active courses
	global static List<CourseStatus__c> getCourseStatus(Set<String> fieldsCourseStatus,
											Set<String> fieldsModuleResponse, 
											Set<Id> courseIds, 
											Id memberId, 
											Integer quantity, 
											Integer offset, 
											String orderBy) {
		String queryCourseStatus = 'SELECT ' + String.join(new List<String>(fieldsCourseStatus), ',');
		if(fieldsModuleResponse != null){
			queryCourseStatus += ' ,(SELECT ' + String.join(new List<String>(fieldsModuleResponse), ',') + ' FROM ModuleResponses__r WHERE Member__c =: memberId) ';
		}
		queryCourseStatus += ' FROM CourseStatus__c WHERE Member__c =: memberId ';		
		if (courseIds != null) {
			queryCourseStatus += ' AND Course__c in : courseIds ';
		}

		if( String.isNotBlank(orderBy) ){
			queryCourseStatus += ' ORDER BY ' + orderBy;
		}
		if(quantity != null){
			queryCourseStatus += ' LIMIT ' + quantity;

			if(offset != null){
				queryCourseStatus += ' OFFSET ' + offset;
			}
		}

		return Database.query(queryCourseStatus);
	}

	global class CourseWrapper{
		global Course__c course {get; private set;}
		global CourseStatus__c courseStatus {get; private set;}
		global Boolean allowedForSegment {get; private set;}
		global Boolean allowedForDependency {get; private set;}
		global List<ModuleWrapper> modules {get; private set;}

		public CourseWrapper(Course__c course, CourseStatus__c courseStatus){
			this.course = course;
			this.modules = new List<ModuleWrapper>();
			this.allowedForSegment = true;
			this.allowedForSegment = allowedForDependency;
			this.courseStatus = courseStatus;
		}
	}

	global class ModuleWrapper{
		global Module__c module {get; private set;}
		global Boolean allowedForDependency {get; private set;}
		global Integer numberOfAttempts {get; private set;}
		//public Integer average;
		global List<ModuleResponse__c> moduleResponses {get; private set;}
		global List<ModuleDependency__c> dependencies {get; private set;}

		public ModuleWrapper(Module__c module, List<ModuleResponse__c> moduleResponses){
			this(module);
			this.moduleResponses = moduleResponses;
			this.numberOfAttempts = this.moduleResponses.size();
		}

		public ModuleWrapper(Module__c module){
			this.module = module;
			this.allowedForDependency = true;
		}
	}

	//active courses
	global static List<CourseWrapper> getCoursesMap(Set<String> fieldsCourse, 
											Set<String> fieldsCourseStatus,
											Set<String> fieldsCourseDependency,
											Set<String> fieldsModule,
											Set<String> fieldsModuleResponse, 
											Set<String> fieldsModuleDependency,
											Set<Id> courseIds, 
											Id programId, 
											Id memberId, 
												Boolean filterByDependecies, 
												Boolean filterBySegments, 
											Integer quantity, 
											Integer offset, 
											String orderBy, 
											String dynamicFilter) {
		
		Set<String> fieldsCourseClone = new Set<String>(fieldsCourse);
		fieldsCourseClone.add('Segment__c');
		fieldsCourseClone.add('HasDependencies__c');
		fieldsCourseClone.add('KeyDependencies__c');
		Set<String> fieldsModuleClone = new Set<String>(fieldsModule);
		fieldsModuleClone.add('HasDependencies__c');
		fieldsModuleClone.add('KeyDependencies__c');
		List<Course__c> courses = getCourses(fieldsCourseClone, fieldsCourseDependency, fieldsModuleClone, courseIds, programId, memberId, filterByDependecies, filterBySegments, false, quantity, offset, orderBy, dynamicFilter);
		Map<Id,CourseStatus__c> coursesStatusMap = new Map<Id,CourseStatus__c>();
		Set<String> fieldsCourseStatusClone = new Set<String>(fieldsCourseStatus);
		fieldsCourseStatusClone.add('Course__c');
		for(CourseStatus__c cs : getCourseStatus(fieldsCourseStatusClone, fieldsModuleResponse, new Map<Id,Course__c>(courses).keySet(), memberId, null, null, null)){
			coursesStatusMap.put(cs.Course__c, cs);		
		}

		List<CourseWrapper> courseWrappers = new List<CourseWrapper>();
		Set<Id> segmentIds;
		if(!filterBySegments){
			segmentIds = FieloPLT.SegmentService.getMemberSegments(memberId, null);
		}

		Set<String> cdStringKeys;
		Set<String> mdStringKeys;
		Map<Id,List<ModuleDependency__c>> dependenciesByModule;
		if((fieldsModule != null && fieldsModuleDependency != null) || !filterByDependecies){
			List<Module__c> modules = new List<Module__c>();
			for(Course__c c : courses){
				modules.addAll(c.Modules__r);
			}

			if(fieldsModule != null && fieldsModuleDependency != null){
				dependenciesByModule = new Map<Id,List<ModuleDependency__c>>();

				Set<String> fieldsModuleDependencyClone = new Set<String>(fieldsModuleDependency);
				fieldsModuleDependencyClone.add('Module__c');
				String queryModuleDependencies = 'SELECT ' + String.join(new List<String>(fieldsModuleDependencyClone), ',') + ' FROM ModuleDependency__c WHERE Module__c in : modules';
				for(ModuleDependency__c md : Database.query(queryModuleDependencies)){
					if(dependenciesByModule.containsKey(md.Module__c)){
						dependenciesByModule.get(md.Module__c).add(md);
					}else{
						dependenciesByModule.put(md.Module__c, new List<ModuleDependency__c>{md});
					}
				}
			}

			if(!filterByDependecies){
				cdStringKeys = getCDStringKeys(courses, memberId);
				cdStringKeys = getMDStringKeys(modules, memberId);
			}
		}

		for(Course__c c : courses){
			CourseStatus__c cs = coursesStatusMap.get(c.Id);
			CourseWrapper cw = new CourseWrapper(c,cs);
			//cw.enabled = true;
			if(!filterBySegments && c.Segment__c != null){
				cw.allowedForSegment = segmentIds.contains(c.Segment__c);
			}

			if(!filterByDependecies && c.HasDependencies__c){
				cw.allowedForDependency = cdStringKeys.contains(c.KeyDependencies__c);
			}

			if(!c.Modules__r.isEmpty()){
				for(Module__c module : c.Modules__r){
					ModuleWrapper mw = cs != null ? new ModuleWrapper(module, cs.ModuleResponses__r) : new ModuleWrapper(module);
					if(!filterByDependecies && module.HasDependencies__c){
						mw.allowedForDependency = mdStringKeys.contains(module.KeyDependencies__c);
					}
					if(dependenciesByModule != null){
						mw.dependencies = dependenciesByModule.get(module.Id);
					}
					cw.modules.add(mw);
				}
			}
			courseWrappers.add(cw);
		}
		
		return courseWrappers;
	}

	private static Set<String> getCDStringKeys(List<Course__c> courses, Id memberId){
		String cdQuery = 'SELECT Course__c, Predecessor__c FROM CourseDependency__c WHERE Predecessor__c in (SELECT Course__c FROM CourseStatus__c WHERE Member__c =: memberId AND Progress__c = 100';
		if(courses != null){
			cdQuery += ' AND Course__c in : courses) AND Course__c in : courses';
		}else{
			cdQuery += ')';
		}
		Map<Id,Set<String>> cdKeysByCourse = new Map<Id,Set<String>>();
		for(CourseDependency__c cd : Database.query(cdQuery)){
			if(cdKeysByCourse.containsKey(cd.Course__c)){
				cdKeysByCourse.get(cd.Course__c).add(String.valueOf(cd.Predecessor__c).subString(0,15));
			}else{
				cdKeysByCourse.put(cd.Course__c, new Set<String>{String.valueOf(cd.Predecessor__c).subString(0,15)});
			}
		}

		Set<String> cdStringKeys = new Set<String>();
		for(Id courseId : cdKeysByCourse.keySet()){
			List<String> listKeys = new List<String>(cdKeysByCourse.get(courseId));
			listKeys.sort();
			cdStringKeys.add(String.join(listKeys,''));
		}
		return cdStringKeys;
	}

	private static Set<String> getMDStringKeys(List<Module__c> modules, Id memberId){
		String mdQuery = 'SELECT Module__c, Predecessor__c FROM ModuleDependency__c WHERE Predecessor__c in (SELECT Module__c FROM ModuleResponse__c WHERE Member__c =: memberId AND IsApproved__c = true AND Module__c in : modules) AND Module__c in : modules';
		Map<Id,Set<String>> mdKeysByCourse = new Map<Id,Set<String>>();
		for(ModuleDependency__c md : Database.query(mdQuery)){
			if(mdKeysByCourse.containsKey(md.Module__c)){
				mdKeysByCourse.get(md.Module__c).add(String.valueOf(md.Predecessor__c).subString(0,15));
			}else{
				mdKeysByCourse.put(md.Module__c, new Set<String>{String.valueOf(md.Predecessor__c).subString(0,15)});
			}
		}

		Set<String> mdStringKeys = new Set<String>();
		for(Id moduleId : mdKeysByCourse.keySet()){
			List<String> listKeys = new List<String>(mdKeysByCourse.get(moduleId));
			listKeys.sort();
			mdStringKeys.add(String.join(listKeys,''));
		}
		return mdStringKeys;
	}

	public static void setCourseStatus(Set<Id> courseIds, String newStatus) {
		SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{Course__c.SObjectType});
		Course__c course;
		for(Id courseId : courseIds) {
			course = new Course__c(Id = courseId, Status__c = newStatus);
			uow.registerDirty(course);
		}
		SavePoint sp = Database.setSavePoint();
		try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}
	}
		
	//active courses
	/*public static List<CourseWrapper> getCourses(Set<String> fieldsCourse, 
											Set<String> fieldsCourseStatus,
											Set<String> fieldsCourseDependency,
											Set<String> fieldsModule,
											Set<String> fieldsModuleResponse, 
											Set<String> fieldsModuleDependency,
											Set<Id> courseIds, 
											Id programId, 
											Id memberId, 
												Boolean myCourses,
												Boolean filterByDependecies, 
												Boolean filterBySegments, 
												Boolean filterByNotTake, 
											Integer quantity, 
											Integer offset, 
											String orderBy, 
											String dynamicFilter) {
		
		Set<String> fieldsCourseClone = new Set<String>(fieldsCourse);
		fieldsCourseClone.add('Segment__c');
		fieldsCourseClone.add('HasDependencies__c');
		fieldsCourseClone.add('KeyDependencies__c');
		String queryCourses = 'SELECT ' + String.join(new List<String>(fieldsCourseClone), ',');
		if(memberId != null){
			queryCourses += ' ,(SELECT ' + String.join(new List<String>(fieldsCourseStatus), ',') + ' FROM CoursesStatus__r WHERE Member__c =: memberId) ';
		}
		queryCourses += ' ,(SELECT ' + String.join(new List<String>(fieldsCourseDependency), ',') + ' FROM PredecessorCourses__r) ';
		queryCourses += ' FROM Course__c WHERE Status__c = \'Active\' ';
		
		if (programId != null) {
			queryCourses += 'AND Program__c =: programId ';
		}

		if (courseIds != null) {
			queryCourses += 'AND Id in : courseIds ';
		}

		if (myCourses != null) {
			queryCourses += 'AND Id in (SELECT Course__c FROM CourseStatus__c WHERE Member__c =: memberId) ';
		}

		if(memberId != null){
			if(filterBySegments){
				Set<Id> segmentIds = FieloPLT.SegmentService.getMemberSegments(memberId, null);
				queryCourses += 'AND (Segment__c = null OR Segment__c in : segmentIds) ';
			}

			if(filterByDone){
				queryCourses += 'AND Id NOT in (SELECT Course__c FROM CourseStatus__c WHERE Progress__c = 100 AND Member__c =: memberId) ';
			}

			if(filterByDependecies){
				Set<String> cdStringKeys = getCDStringKeys(null, memberId);
				queryCourses += 'AND (HasDependencies__c = false OR (HasDependencies__c = true AND KeyDependencies__c in : cdStringKeys))';
			}
		}	
	
		if( String.isNotBlank(orderBy) ){
			queryCourses += ' ORDER BY ' + orderBy;
		}
		if(quantity != null){
			queryCourses += ' LIMIT ' + quantity;

			if(offset != null){
				queryCourses += ' OFFSET ' + offset;
			}
		}

		system.debug(queryCourses);
		List<Course__c> courses = Database.query(queryCourses);

		Set<String> fieldsModuleClone = new Set<String>(fieldsModule);
		fieldsModuleClone.add('Course__c');
		fieldsModuleClone.add('HasDependencies__c');
		fieldsModuleClone.add('KeyDependencies__c');
		String queryModules = 'SELECT ' + String.join(new List<String>(fieldsModuleClone), ',');
		if(memberId != null){
			queryModules += ' ,(SELECT ' + String.join(new List<String>(fieldsModuleResponse), ',') + ' FROM ModuleResponses__r WHERE Member__c =: memberId) ';
		}
		queryModules += ' ,(SELECT ' + String.join(new List<String>(fieldsModuleDependency), ',') + ' FROM PredecessorModules__r) ';
		queryModules += ' FROM Module__c WHERE Course__c in : courses ';
		
		system.debug('list modules query: ' + queryModules);
		List<Module__c> modules = Database.query(queryModules);

		Map<Id,Course__c> coursesMap = new Map<Id,Course__c>();
		Map<Id,Module__c> modulesMap = new Map<Id,Module__c>();
		Map<Id,List<Module__c>> modulesByCourse = new Map<Id,List<Module__c>>();
		for(Module__c module : modules){
			if(modulesByCourse.containsKey(module.Course__c)){
				modulesByCourse.get(module.Course__c).add(module);
			}else{
				modulesByCourse.put(module.Course__c, new List<Module__c>{module});
			}
		}

		List<CourseWrapper> courseWrappers = new List<CourseWrapper>();
		if(memberId != null){
			Set<Id> segmentIds;
			if(!filterBySegments){
				segmentIds = FieloPLT.SegmentService.getMemberSegments(memberId, null);
			}

			Set<String> cdStringKeys;
			Set<String> mdStringKeys;
			if(!filterByDependecies){				
				cdStringKeys = getCDStringKeys(courses, memberId);
				cdStringKeys = getMDStringKeys(modules, memberId);
			}

			for(Course__c c : courses){
				CourseWrapper cw = new CourseWrapper(c);
				if(memberId != null){
					//cw.enabled = true;
					if(!filterBySegments && c.Segment__c != null){
						cw.enabled = segmentIds.contains(c.Segment__c);
					}

					if(cw.enabled && !filterByDependecies){
						if(c.HasDependencies__c){
							cw.enabled = cdStringKeys.contains(c.KeyDependencies__c);
						}
					}
				}

				if(modulesByCourse.containsKey(c.Id)){
					for(Module__c module : modulesByCourse.get(c.Id)){
						ModuleWrapper mw = new ModuleWrapper(module);
						if(!filterByDependecies){
							if(module.HasDependencies__c){
								mw.enabled = mdStringKeys.contains(module.KeyDependencies__c);
							}
						}
						cw.modules.add(mw);
					}
				}
				courseWrappers.add(cw);
			}
		}else{
			for(Course__c c : courses){
				CourseWrapper cw = new CourseWrapper(c);
				if(modulesByCourse.containsKey(c.Id)){
					for(Module__c module : modulesByCourse.get(c.Id)){
						cw.modules.add(new ModuleWrapper(module));
					}
				}
				courseWrappers.add(cw);
			}
		}
		return courseWrappers;
	}*/

}