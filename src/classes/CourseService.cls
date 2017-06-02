public with sharing class CourseService {
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

	//active courses
	/*public static List<Course__c> getCourses(Set<String> fieldsCourse, Set<String> fieldsModule, Set<String> fieldsCourseDependency, Id programId, Id memberId, Boolean filterByDependecies, Boolean filterBySegments, Boolean filterByDone, Integer quantity, Integer offset, String orderBy, String dynamicFilter) {   
		String query = 'SELECT ' + String.join(new List<String>(fieldsCourse), ',');
		query += ' ,(SELECT ' + String.join(new List<String>(fieldsModule), ',') + ' FROM Modules__r) ';
		query += ' ,(SELECT ' + String.join(new List<String>(fieldsCourseDependency), ',') + ' FROM PredecessorCourses__r) ';
		query += ' FROM Course__c WHERE Status__c = \'Active\' ';
		
		if (programId != null) {
			query += 'AND Program__c =: programId ';
		}

		if(memberId != null){
			if(filterBySegments){
				Set<Id> segmentIds = FieloPLT.SegmentService.getMemberSegments(memberId, null);
				query += 'AND (Segment__c = null OR Segment__c in : segmentIds) ';
			}

			if(filterByDone){
				query += 'AND Id NOT in (SELECT Course__c FROM CourseStatus__c WHERE Progress__c = 100 AND Member__c =: memberId) ';
			}

			if(filterByDependecies){				
				Map<Id,Set<String>> cdKeysByCourse = new Map<Id,Set<String>>();
				for(CourseDependency__c cd : [SELECT Course__c, Predecessor__c FROM CourseDependency__c WHERE Predecessor__c in (SELECT Course__c FROM CourseStatus__c WHERE Member__c =: memberId AND Progress__c = 100)]){
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

				query += 'AND (HasDependencies__c = false OR (HasDependencies__c = true AND KeyDependencies__c in : cdStringKeys))';
			}
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

		system.debug(query);
		return Database.query(query);
	}*/

	public class ModuleWrapper{
		public Module__c module {get; set;}
		public List<Question__c> questions {get; set;}
	}

	//active courses
	public static ModuleWrapper getModule(Id moduleId, Set<String> fieldsModule, Set<String> fieldsModuleDependency, Set<String> fieldsQuestion, Set<String> fieldsAnswerOption) {   
		ModuleWrapper moduleWrapper = new ModuleWrapper();
		
		Set<String> fieldsModuleClone = new Set<String>(fieldsModule);
		fieldsModuleClone.add('QuestionPool__c');
		String moduleQuery = 'SELECT ' + String.join(new List<String>(fieldsModuleClone), ',');
		if(fieldsModuleDependency != null){
			moduleQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsModuleDependency), ',') + ' FROM PredecessorModules__r) ';
		}
		moduleQuery += ' FROM Module__c WHERE Id =: moduleId ';
		system.debug('query module: ' + moduleQuery);
		moduleWrapper.module = Database.query(moduleQuery);

		if(fieldsQuestion != null){
			String questionQuery = 'SELECT ' + String.join(new List<String>(fieldsQuestion), ',');
			if(fieldsAnswerOption != null){
				questionQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsAnswerOption), ',') + ' FROM AnswerOptions__r ORDER BY OrderFormula__c)';
			}
			questionQuery += ' FROM Question__c WHERE Module__c =: moduleId ORDER BY OrderFormula__c';
			
			if(moduleWrapper.module.QuestionPool__c != null){
				questionQuery += ' LIMIT ' + moduleWrapper.module.QuestionPool__c;
			}

			system.debug('query questions: ' + questionQuery);
			moduleWrapper.questions = Database.query(questionQuery);
		}

		return moduleWrapper;
	}



	public static List<Question__c> getQuestions(Id moduleId,
									  Set<Id> excludedQuestionIds,
									  Set<String> fieldsQuestion,
									  Set<String> fieldsAnswerOption,
									  Integer quantity,
									  Integer offset) {
		String questionQuery = 'SELECT ' + String.join(new List<String>(fieldsQuestion), ',');
		if(fieldsAnswerOption != null){
			questionQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsAnswerOption), ',') + ' FROM AnswerOptions__r ORDER BY OrderFormula__c)';
		}
		questionQuery += ' FROM Question__c WHERE Module__c =: moduleId';
		if(excludedQuestionIds != null){
			questionQuery += ' AND Id NOT in : excludedQuestionIds';
		}
		questionQuery += ' ORDER BY OrderFormula__c';
		
		Module__c module = [SELECT QuestionPool__c FROM Module__c WHERE Id =: moduleId];

		if(module.QuestionPool__c != null){
			if(quantity != null && quantity < module.QuestionPool__c){
				questionQuery += ' LIMIT ' + quantity;
			}else{
				questionQuery += ' LIMIT ' + module.QuestionPool__c;
			}
		}else{
			if(quantity != null){
				questionQuery += ' LIMIT ' + quantity;
			}
		}

		if(offset != null){
			questionQuery += ' OFFSET ' + offset;
		}

		return Database.query(questionQuery);
	}

	public static QuestionResponse__c submitQuestion (QuestionResponse__c questionResponse, List<Answer__c> answers){
		SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{QuestionResponse__c.SObjectType, Answer__c.SObjectType});
		uow.registerNew(questionResponse);
		for(Answer__c answer : answers){
			uow.registerNew(answer, Answer__c.QuestionResponse__c, questionResponse);
		}

		SavePoint sp = Database.setSavePoint();
		try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}

		uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{QuestionResponse__c.SObjectType});
		questionResponse.IsSubmitted__c = true;
		uow.registerDirty(questionResponse);
		try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}

		return [SELECT Id, Name, ModuleResponse__c, Question__c, IsSubmitted__c, IsCorrect__c FROM QuestionResponse__c WHERE Id =: questionResponse.Id];
	}

	public class QuestionResponseWrapper{
		public QuestionResponse__c questionResponse {get; set;}
		public List<Answer__c> answers {get; set;}
	}

	public static ModuleResponse__c submitModuleResponse (ModuleResponse__c moduleResponse, List<QuestionResponseWrapper> questionWrappers){
		SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{ModuleResponse__c.SObjectType, QuestionResponse__c.SObjectType, Answer__c.SObjectType});
		uow.registerNew(moduleResponse);
		for(QuestionResponseWrapper qw : questionWrappers){
			uow.registerNew(qw.questionResponse, QuestionResponse__c.ModuleResponse__c, moduleResponse);
			for(Answer__c answer : qw.answers){
				uow.registerNew(answer, Answer__c.QuestionResponse__c, qw.questionResponse);
			}
		}

		SavePoint sp = Database.setSavePoint();
		try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}

		uow = new SObjectUnitOfWork(new List<Schema.SobjectType>{ModuleResponse__c.SObjectType});
		moduleResponse.IsSubmitted__c = true;
		uow.registerDirty(moduleResponse);
		try{
			uow.commitWork();
		}catch(Exception e){
			Database.rollback(sp);
			throw e;
		}

		return [SELECT Id, Name, Member__c, Module__c, IsSubmitted__c, IsApproved__c, GradePercent__c FROM ModuleResponse__c WHERE Id =: moduleResponse.Id];
	}

	public class QuestionWrapper{
		public Question__c question;
		public List<QuestionResponse__c> questionResponses;

		public QuestionWrapper(Question__c question, List<QuestionResponse__c> questionResponses){
			this.question = question;
			this.questionResponses = questionResponses;
		}
	}

	public class ModuleResponseWrapper{
		public ModuleResponse__c moduleResponse {get; set;}
		public List<QuestionWrapper> questions {get; set;}

		public ModuleResponseWrapper(ModuleResponse__c moduleResponse){
			this.moduleResponse = moduleResponse;
			this.questions = new List<QuestionWrapper>();
		}
	}

	public static ModuleResponseWrapper getModuleResponse(Id moduleResponseId,
									  Set<String> fieldsModuleResponse,
									  Set<String> fieldsQuestion,
									  Set<String> fieldsQuestionResponse,
									  Set<String> fieldsAnswerOption,
									  Set<String> fieldsAnswer) {

		//sacar module id

		//query de question con answer options

		//query de question responses con answer


		//query moduleresponse con module
		
		String moduleResponseQuery = 'SELECT ' + String.join(new List<String>(fieldsModuleResponse), ',');
		moduleResponseQuery += ' FROM ModuleResponse__c WHERE Id =: moduleResponseId ';
		ModuleResponseWrapper moduleResponseWrapper = new ModuleResponseWrapper(Database.query(moduleResponseQuery));

		if(fieldsQuestionResponse != null){
			Set<String> fieldsQuestionResponseClone = new Set<String>(fieldsQuestionResponse);
			fieldsQuestionResponseClone.add('Question__c');
			String questionResponseQuery = 'SELECT ' + String.join(new List<String>(fieldsQuestionResponseClone), ',');
			if(fieldsAnswer != null){
				questionResponseQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsAnswer), ',') + ' FROM Answers__r)';
			}
			questionResponseQuery += ' FROM QuestionResponse__c WHERE ModuleResponse__c =: moduleResponseId';
			List<QuestionResponse__c> questionResponses = Database.query(questionResponseQuery);

			Map<Id,List<QuestionResponse__c>> responsesByQuestion = new Map<Id,List<QuestionResponse__c>>();
			for(QuestionResponse__c qr : questionResponses){
				if(responsesByQuestion.containsKey(qr.Question__c)){
					responsesByQuestion.get(qr.Question__c).add(qr);
				}else{
					responsesByQuestion.put(qr.Question__c, new List<QuestionResponse__c>{qr});
				}
			}
			
			String questionQuery = 'SELECT ' + String.join(new List<String>(fieldsQuestion), ',');
			if(fieldsAnswerOption != null){
				questionQuery += ' ,(SELECT ' + String.join(new List<String>(fieldsAnswerOption), ',') + ' FROM AnswerOptions__r)';
			}
			Set<Id> questionIds = responsesByQuestion.keySet();
			questionQuery += ' FROM Question__c WHERE Id in : questionIds';
			
			for(Question__c question : Database.query(questionQuery)){
				moduleResponseWrapper.questions.add(new QuestionWrapper(question, responsesByQuestion.get(question.Id)));
			}
		}

		return moduleResponseWrapper;
	}

	public class CourseWrapper{
		public Course__c course;
		public Boolean enabled;
		public List<ModuleRowWrapper> modules;

		public CourseWrapper(Course__c course){
			this.course = course;
			this.modules = new List<ModuleRowWrapper>();
			this.enabled = true;
		}
	}

	public class ModuleRowWrapper{
		public Module__c module;
		public Boolean enabled;
		public Integer numberOfAttempts;

		public ModuleRowWrapper(Module__c module){
			this.module = module;
			this.numberOfAttempts = this.module.ModuleResponses__r.size();
			this.enabled = true;
		}
	}


	public static List<CourseWrapper> getCourses(Set<String> fieldsCourse, 
										Set<String> fieldsModule,
										Set<String> fieldsCourseDependency,
										Set<String> fieldsModuleDependency,
										Set<Id> courseIds,
										Id programId,
										Id memberId,
											Boolean filterByDependecies,
											Boolean filterBySegments,
											Boolean filterByDone,
										Integer quantity,
										Integer offset,
										String orderBy,
										String dynamicFilter) {
		return getCourses(fieldsCourse, 
											null,
											fieldsCourseDependency,
											fieldsModule,
											null, 
											fieldsModuleDependency,
											courseIds, 
											programId, 
											memberId, 
												false,
												filterByDependecies, 
												filterBySegments, 
												filterByDone, 
											quantity, 
											offset, 
											orderBy, 
											dynamicFilter);
	}

	public static List<CourseWrapper> getCourseStatus(Set<String> fieldsCourse,
										Set<String> fieldsCourseStatus, 
										Set<String> fieldsModule,
										Set<String> fieldsModuleResponse,
										Set<Id> courseIds,
										Id memberId,
										Integer quantity,
										Integer offset,
										String orderBy) {
		return getCourses(fieldsCourse, 
											fieldsCourseStatus,
											null,
											fieldsModule,
											fieldsModuleResponse, 
											null,
											courseIds, 
											null, 
											memberId, 
												true,
												false, 
												false, 
												false, 
											quantity, 
											offset, 
											orderBy, 
											null);
	}


	//active courses
	public static List<CourseWrapper> getCourses(Set<String> fieldsCourse, 
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
												Boolean filterByDone, 
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
						ModuleRowWrapper mw = new ModuleRowWrapper(module);
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
						cw.modules.add(new ModuleRowWrapper(module));
					}
				}
				courseWrappers.add(cw);
			}
		}
		return courseWrappers;
	}

	public static Set<String> getCDStringKeys(List<Course__c> courses, Id memberId){
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

	public static Set<String> getMDStringKeys(List<Module__c> modules, Id memberId){
		String mdQuery = 'SELECT Module__c, Predecessor__c FROM ModuleDependency__c WHERE Predecessor__c in (SELECT Module__c FROM ModuleResponse__c WHERE Member__c =: memberId AND IsApproved__c = true';
		if(modules != null){
			mdQuery += ' AND Module__c in : modules) AND Module__c in : modules';
		}else{
			mdQuery += ')';
		}
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

}