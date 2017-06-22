public class Modules extends SObjectDomain {

	public static Boolean validateAdminFields = true;

	public Modules(List<Module__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<Module__c> sObjectList) {
            //If has Admin Permission allow "validateAdminFields"
            if(FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()) != null && FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()).FieloPLT__To__c >= system.now()){
                validateAdminFields = false;
            }

            return new Modules(sObjectList);
        }
    }

	public override void onApplyDefaults() {
		
		Set<Id> courseIds = new Set<Id>();
		for(Module__c module : (List<Module__c>)records){
        	module.IsActive__c = false;
			if(module.Order__c == null) {
	        	courseIds.add(module.Course__c);
	        }
		}
    	
		List<AggregateResult> aggResult = new ModulesSelector().selectByCourseGroupByCourse(courseIds);
        Map<String, Decimal> maxOrderByCourse = new Map<String, Decimal>();
        for(AggregateResult ar : aggResult){
            maxOrderByCourse.put((String)ar.get('FieloELR__Course__c'), (Decimal)ar.get('orderNumber'));
        }
        
		for(Module__c module : (List<Module__c>)records) {
			if(module.Order__c == null) {
	            if(maxOrderByCourse.containsKey(module.Course__c)){
	                Decimal maxOrder = maxOrderByCourse.get(module.Course__c);
	                maxOrder = (maxOrder == null ? 0 : maxOrder);
	                module.Order__c = ++maxOrder;
	                maxOrderByCourse.put(module.Course__c, maxOrder);
	            }else{
	                module.Order__c = 1;
	                maxOrderByCourse.put(module.Course__c, 1);
	            }
			}
		}
    }    

    public override void onValidate(Map<Id,SObject> existingRecords) {

    	if(validateAdminFields){
	   		List<Module__c> activatedModules = new List<Module__c>();
	    	List<Module__c> updatedModules = new List<Module__c>();
	    	Module__c oldModule;

			for(Module__c module : (List<Module__c>)records) {

				oldModule = (Module__c)(existingRecords.get(module.Id));

				// Select only modules that are being activated
				if(!(oldModule.IsActive__c) && module.IsActive__c) {
					activatedModules.add(module);
				}
				// When Active, no field can be edited
				if(oldModule.IsActive__c && module.IsActive__c) {
					addError(module, Label.ActiveModuleCannotBeEdited);
				}
				/* 
					Check if any of these fields were modified:
					IsActive / Attempts Allowed / Approval Grade / Penalty Mode
					Question Pool / Attempts Allowed per question / Weighted questions
				*/
				else if(oldModule.AttemptsAllowed__c != module.AttemptsAllowed__c || 
					oldModule.ApprovalGrade__c != module.ApprovalGrade__c || 
					oldModule.PenaltyMode__c != module.PenaltyMode__c || 
					oldModule.QuestionPool__c != module.QuestionPool__c || 
					oldModule.AttemptsAllowedPerQuestion__c != module.AttemptsAllowedPerQuestion__c ||
					oldModule.WeightedQuestions__c != module.WeightedQuestions__c) {
					updatedModules.add(module);
				}
			}

			// When the module is changed to active, must validate that has at least one question.
	   		checkQuestions(activatedModules);

		    // If the Module is active, has at least 1 related Module response, and any of the following fields was modified the Module cannot be edited or deleted 
			checkModule(updatedModules);

	   		// When the module is activated, should verify, for the question types "statement" and "single choice", that it has a correct answer.
	   		checkAnswers(activatedModules);
	   	}
    }

    public override void onBeforeInsert() {
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords){
    	List<Module__c> activatedModules = new List<Module__c>();
    	List<Module__c> inactivatedModules = new List<Module__c>();
		Set<Module__c> modulesToChangeQuestions = new Set<Module__c>();

		Set<Id> modulesToChangeCorrectWeight = new Set<Id>();
		Set<Id> modulesToChangeIncorrectWeight = new Set<Id>();
		Set<Id> modulesToChangePenaltyPerAttempt = new Set<Id>();

    	Module__c oldModule;		

		for(Module__c module : (List<Module__c>)records) {

			oldModule = (Module__c)(existingRecords.get(module.Id));

			// Select only modules that are being activated
			if(!(oldModule.IsActive__c) && module.IsActive__c) {
				activatedModules.add(module);
			}
			// Select only modules that are being inactivated
			if(oldModule.IsActive__c && !(module.IsActive__c)) {
				inactivatedModules.add(module);
			}	
			// Select modules whose question pool is changed from null to != null or weighted questions is set to false
			if((oldModule.QuestionPool__c == null && module.QuestionPool__c != null) || 
			   (oldModule.WeightedQuestions__c && !(module.WeightedQuestions__c))) {
				modulesToChangeQuestions.add(module);
				modulesToChangeCorrectWeight.add(module.Id);
			}				
			// Select modules whose Penalty mode is changed from "Negative weight" to "Percent decrease" or "None"
			if((oldModule.PenaltyMode__c == 'Negative Weight' && (module.PenaltyMode__c == 'Percent Decrease' || module.PenaltyMode__c == 'None'))) {
				modulesToChangeQuestions.add(module);
				modulesToChangeIncorrectWeight.add(module.Id);
			}	
			// Select modules whose Penalty mode is changed from "Percent decrease" to "Negative weight" or "None"
			if((oldModule.PenaltyMode__c == 'Percent Decrease' && (module.PenaltyMode__c == 'Negative Weight' || module.PenaltyMode__c == 'None'))) {
				modulesToChangeQuestions.add(module);
				modulesToChangePenaltyPerAttempt.add(module.Id);
			}			
		}

		SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Course__c.SObjectType, Question__c.SObjectType});
		updateCourses(activatedModules, inactivatedModules, uow);
		//If the question pool is changed from null to != null or weighted questions is set to false, then will update all the related questions will have weight = 1. (Trigger) 
		updateQuestions(new List<Module__c>(modulesToChangeQuestions), modulesToChangeCorrectWeight, modulesToChangeIncorrectWeight, modulesToChangePenaltyPerAttempt, uow);
		uow.commitWork();
    }

    // Check the responses for a list of modules
    private void updateCourses(List<Module__c> activatedModules, List<Module__c> inactivatedModules, SObjectUnitOfWork uow) {
	    
	    Set<Id> courseIds = new Set<Id>();
	    if(activatedModules != null){
		    for(Module__c module : activatedModules) {
		    	if(!hasError(module.Id)) {
					courseIds.add(module.Course__c);
 				}		        
		    }
		}

		if(inactivatedModules != null){
		    for(Module__c module : inactivatedModules) {
				if(!hasError(module.Id)) {
		        	courseIds.add(module.Course__c);
		    	}
		    }
		}

	    Map<Id,Course__c> coursesMap = new Map<Id,Course__c>(new CoursesSelector(new Set<String> {'Id','ActiveModules__c'}).selectById(courseIds));
	    if(activatedModules != null){
		    for(Module__c module : activatedModules) {
				if(!hasError(module.Id)) {
			        Course__c course = coursesMap.get(module.Course__c);
			        course.ActiveModules__c++;
			    }
		    }
		}

		if(inactivatedModules != null){
		    for(Module__c module : inactivatedModules) {
				if(!hasError(module.Id)) {
			        Course__c course = coursesMap.get(module.Course__c);
			        course.ActiveModules__c--;
				}			        
		    }
		}

		uow.registerDirty(coursesMap.values());
		Courses.validateAdminFields = false;
    }

    private void updateQuestions(List<Module__c> modulesToChangeQuestions, Set<Id> modulesToChangeCorrectWeight, Set<Id> modulesToChangeIncorrectWeight, 
    								Set<Id> modulesToChangePenaltyPerAttempt, SObjectUnitOfWork uow) {
	    
	    Map<Id,Module__c> modulesMap = new Map<Id, Module__c>(modulesToChangeQuestions);

	    for(Question__c question : new QuestionsSelector(new Set<String> {'Id','Module__c'}).selectByModule(modulesMap.keySet())) {
	    	// If the question pool is changed from null to != null or weighted questions is set to false, then will update all the related questions will have weight = 1. 
	        if(modulesToChangeCorrectWeight.contains(question.Module__c)) {
		        question.CorrectWeight__c = 1;
	        }
	        // If the Penalty mode is changed from "Incorrect weight" to "Percent decrease" or "None" then will update the related questions with Incorrect weight to 0.
	        if(modulesToChangeIncorrectWeight.contains(question.Module__c)) {
				question.IncorrectWeight__c = 0;
			}
			// If the Penalty mode is changed from "Percent decrease" to "Negative weight" or "None" then will update the related questions with Penalty per Attempt to 0.
			if(modulesToChangePenaltyPerAttempt.contains(question.Module__c)) {
				question.PenaltyPerAttempt__c = 0;
			}

	    	uow.registerDirty(question);
	    }	
	}  

	public override void onBeforeDelete() {

   		List<Module__c> activeModules = new List<Module__c>();

		for(Module__c module : (List<Module__c>)records) {
   			// Select only active modules
			if(module.IsActive__c) {
				activeModules.add(module);
			}
		}

		// An active module with related module responses cannot be deleted.
     	checkModule((List<Module__c>)records);

     	SObjectUnitOfWork uow = new SObjectUnitOfWork(new List<Schema.SObjectType>{Course__c.SObjectType, ModuleDependency__c.SObjectType, Question__c.SObjectType});
     	deleteModuleDependencies(uow);
     	deleteQuestions(uow);
     	if(!Courses.isDelete)
     		updateCourses(null, activeModules, uow);
     	Courses.validateAdminFields = false;
     	Questions.validateAdminFields = false;
     	uow.commitWork();
    }


	// Check the questions for a list of modules
    private void checkQuestions(List<Module__c> activatedModules) {
		
	    Map<Id,Module__c> modulesMap = new Map<Id, Module__c>(activatedModules);

	    List<Module__c> modulesWithQuestion = new ModulesSelector(new Set<String> {'Id'}).selectByIdHavingQuestions(modulesMap.KeySet()); 
	    																		
	    for(Module__c module : modulesWithQuestion) {
	        if(module.Questions__r.isEmpty()){
	        	modulesMap.get(module.Id).addError(Label.ValidateModuleActive);        
	        }        
	    }
    }

    // If the Module is active, has at least 1 related Module response, and any of the following fields (see error message) was modified the Module cannot be edited or deleted 
    private void checkModule(List<Module__c> modules) {
	    Map<Id,Module__c> modulesMap = new Map<Id, Module__c>(modules);

	   	List<Module__c> modulesWithResponse = new ModulesSelector().selectByIdHavingModuleResponses(modulesMap.KeySet()); 
	    for(Module__c module : modulesWithResponse) {
        	if (!module.ModuleResponses__r.isEmpty()) {
				addError(modulesMap.get(module.Id), Label.ValidateModuleEditableFields);
	        }
	    }
    }

    private void deleteModuleDependencies(SObjectUnitOfWork uow) {
		Map<Id, Module__c> modulesMap = new Map<Id, Module__c>((List<Module__c>)records);
    	Set<Id> moduleIds = modulesMap.KeySet();
        moduleIds.removeAll(new List<Id>(RecordErrors));
    	List<ModuleDependency__c> moduleDependencies = new ModuleDependenciesSelector(new Set<String> {'Id'}).selectByModule(moduleIds);
    	uow.registerDeleted(moduleDependencies);
    }

    private void deleteQuestions(SObjectUnitOfWork uow) {
		Map<Id, Module__c> modulesMap = new Map<Id, Module__c>((List<Module__c>)records);
		Set<Id> moduleIds = modulesMap.KeySet();
        moduleIds.removeAll(new List<Id>(RecordErrors));
    	List<Question__c> questions = new QuestionsSelector(new Set<String> {'Id'}).selectByModule(moduleIds);
    	uow.registerDeleted(questions);
    }


	// Check the answers for a list of modules
    private void checkAnswers(List<Module__c> activatedModules) {

    	Map<Id,Module__c> modulesMap = new Map<Id, Module__c>(activatedModules);

		// Then check for answers for those questions
	    List<Question__c> questionsWithCorrectAnswer = new QuestionsSelector(new Set<String> {'Id', 'Name', 'Module__c', 'Type__c'}).selectByModuleHavingAnswers(modulesMap.KeySet()); 
	    																		
	    for(Question__c question : questionsWithCorrectAnswer) {
	        if((question.Type__c == 'Statement' || question.Type__c == 'Single Choice' || question.Type__c == 'Multiple Choice' || question.Type__c == 'Matching Options' || question.Type__c == 'Short Answer') && question.AnswerOptions__r.isEmpty()) {
    		// Question types "statement", "single choice","multiple choice", "Matching" and "Short Answer" must have at least one answer option.
				addError(modulesMap.get(question.Module__c),Label.ValidateModuleActiveQuestion +' '+ question.Type__c +' '+ Label.ValidateModuleActiveQuestionAnswer +' '+ question.Name);    
        	} else if((question.Type__c == 'Statement' || question.Type__c == 'Single Choice') && (question.AnswerOptions__r[0].IsCorrect__c != true)) {
				// Question types "statement" and "single choice" must have a correct answer option.
				addError(modulesMap.get(question.Module__c),Label.ValidateModuleActiveQuestion +' '+ question.Type__c +' '+ Label.ValidateModuleActiveAnswer +' '+ question.Name);
	        } 
	    }
    }
}