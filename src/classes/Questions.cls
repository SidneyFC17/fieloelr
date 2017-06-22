public class Questions extends SObjectDomain {

	public static Boolean validateAdminFields = true;
	public static Boolean isDelete = true;

	public Questions(List<Question__c> records) {
        super(records);
    }

    public class Constructor implements SObjectDomain.IConstructable {
        public SObjectDomain construct(List<Question__c> sObjectList) {
            //If has Admin Permission allow "validateAdminFields"
            if(FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()) != null && FieloPLT__AdminPermission__c.getInstance(UserInfo.getUserId()).FieloPLT__To__c >= system.now()){
                validateAdminFields = false;
            }

            return new Questions(sObjectList);
        }
    }

    public override void onApplyDefaults() {
    	// If both IncorrectWeight or PenaltyPerAttempt are null, replace them by 0 (zero)
    	checkNullValues(records);

    	// If Order is null, calculate it automatically
		Set<Id> moduleIds = new Set<Id>();
		for(Question__c question : (List<Question__c>)records){
			if(question.Order__c == null) {
				moduleIds.add(question.Module__c);
			}
		}
        
        List<AggregateResult> aggResult = new QuestionsSelector().selectByModuleGroupByModule(moduleIds);
        Map<String,Decimal> maxNumbByModule = new Map<String,Decimal>();
        for(AggregateResult mr : aggResult){
            maxNumbByModule.put((String)mr.get('FieloELR__Module__c'), (Decimal)mr.get('order'));
        }
        
        for(Question__c question : (List<Question__c>)records){
			if(question.Order__c == null) {
	            if(maxNumbByModule.containsKey(question.Module__c)){
	                Decimal maxOrder = maxNumbByModule.get(question.Module__c);
	                question.Order__c = ++maxOrder;
	                maxNumbByModule.put(question.Module__c, maxOrder);
	            }else{
	                question.Order__c = 1;
	                maxNumbByModule.put(question.Module__c, 1);
	            }
	        }
        }	    	
    }

    public override void onValidate(){
    	// If the module is active, questions cannot be deleted, updated or added.
    	checkModule(records);
    }

    public override void onBeforeInsert() {
		// Do some module related actions upon insert
		onInsertModuleRelatedActions(records);

		// If the question is updated or inserted and the weigth is null or the question pool is != null then the weight will be 1 
    	updateWeights(records);

	    // If the type is "Fill in the blanks", must validate {} and []
    	//validateFormat(records);

    	//If the MetadataAnswer field is set, convert it to plain text.
    	/*for(Question__c record: (List<Question__c>) records) {
    		formatAnswer(record);
    	}*/
    }

    public override void onValidate(Map<Id,SObject> existingRecords){
		// If the module is active, questions cannot be deleted, updated or added.																		
		checkModule(records);
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {
		// If both IncorrectWeight or PenaltyPerAttempt are null, replace them by 0 (zero)
    	checkNullValues(records);

		// If the question is updated or inserted and the weigth is null or the question pool is != null then the weight will be 1 
    	updateWeights(records);

	    // If the type is "Fill in the blanks", must validate {} and []
    	//validateFormat(records);

    	//If the MetadataAnswer field is set, convert it to plain text.
    	/*for(Question__c record: (List<Question__c>) records) {
    		if(record.MetadataAnswer__c != ((Question__c)existingRecords.get(record.Id)).MetadataAnswer__c  ) {
    			formatAnswer(record);
    		}
    	}*/
    }

	public override void onBeforeDelete() {
		isDelete = true;
		if(validateAdminFields && !Modules.isDelete){
			// If the module is active, questions cannot be deleted, updated or added.																		
	    	checkModule(records);
	    }
    }

    public override void onAfterDelete() {
    	isDelete = true;
    	// Delete related answers upon question delete
    	deleteRelatedAnswers(records);
    }

    private void updateWeights(List<Question__c> questions) {
	    Set<Id> modules = new Set<Id>();
	    for(Question__c question : questions) {
			modules.add(question.Module__c);
	    }

		Map<Id, Module__c> modulesMap = new Map<Id, Module__c>(new ModulesSelector(new Set<String> {'Id', 'QuestionPool__c'}).selectById(modules));

	    for(Question__c question : questions) {
	    	if(question.CorrectWeight__c == null || (modulesMap.containsKey(question.Module__c) && modulesMap.get(question.Module__c).QuestionPool__c != null)) {
	        	question.CorrectWeight__c = 1;             
	    	}
	    }
	}

	// Check the modules
    private void checkModule(List<Question__c> questions) {

	    Set<Id> modules = new Set<Id>();
	    for(Question__c question : questions) {
			modules.add(question.Module__c);
	    }

		Map<Id, Module__c> modulesMap = new Map<Id, Module__c>(new ModulesSelector(new Set<String> {'Id','IsActive__c'}).selectByIdHavingModuleResponses(modules));

		// If the module is active, questions cannot be deleted or added.															
	    for(Question__c question : questions) {
	    	if(modulesMap.containsKey(question.Module__c)) {
	    		if (modulesMap.get(question.Module__c).IsActive__c) {
	    			if (Trigger.isInsert || Trigger.isDelete) {
	    				question.addError(Label.ValidateQuestionActiveModulesQuestions);
	    			} else {
	    				question.addError(Label.ActiveModuleQuestionNotEditable);	
	    			}
	    		} else {
	    			if (!modulesMap.get(question.Module__c).ModuleResponses__r.isEmpty()) {
	    				if (Trigger.isInsert || Trigger.isDelete) {
		    				question.addError(Label.ValidateQuestionActiveModulesQuestions);
		    			}	
	    			}
	    		}
	    	}
	    }
    }

    // Set fields to zero if null
    private void checkNullValues(List<Question__c> questions) {
    	for (Question__c question: questions) {
    		question.IncorrectWeight__c = question.IncorrectWeight__c == null ?
    			0.0 :
    			question.IncorrectWeight__c;
    		question.PenaltyPerAttempt__c = question.PenaltyPerAttempt__c == null ?
    			0.0 :
    			question.PenaltyPerAttempt__c;
    	}
    }

    //Module related actions on Insert
    private void onInsertModuleRelatedActions(List<Question__c> questions) {

    	Set<Id> moduleIds = new Set<Id>();
	    for(Question__c question : questions) {
			moduleIds.add(question.Module__c);
	    }

		Map<Id, Module__c> modulesMap = new Map<Id, Module__c>(
			new ModulesSelector(new Set<String> {'Id','WeightedQuestions__c'}).selectById(moduleIds));

    	for (Question__c question: questions) {
    		// If Module.WeightedQuestions is false, CorrectWeight = 1
    		question.CorrectWeight__c = modulesMap.get(question.Module__c).WeightedQuestions__c ?
    			question.CorrectWeight__c :
    			1;
    	}
    }

    private void deleteRelatedAnswers(List<Question__c> questions) {
    	Map<Id, Question__c> existingQuestions = new Map<Id, Question__c>(
    		new QuestionsSelector().selectByModuleHavingAnswers(new Map<Id,Question__c>(questions).keySet()));

    	List<AnswerOption__c> existingAnswerOptions = new List<AnswerOption__c>();

    	for (Question__c question: questions) {
    		if(existingQuestions.get(question.Id).AnswerOptions__r.size()>0) {
    			existingAnswerOptions.addAll(existingQuestions.get(question.Id).AnswerOptions__r);
    		}
    	}

    	if (!existingAnswerOptions.isEmpty()) {
    		delete existingAnswerOptions;
    	}
    }

    // If the type is "Fill in the blanks", must validate {} and []
    /*private void validateFormat(List<Question__c> questions) {
    	String questionText;
    	for(Question__c question : questions) {
	    	if(question.Type__c == 'Fill in the Blanks') {
	    		// Validate format
	    		//questionText = question.QuestionText__c;

				String regex = '(?<=\\{\\!)(.*?)(?=\\})';
				Pattern regexPattern = Pattern.compile(regex);
				Matcher regexMatcher = regexPattern.matcher(questionText);

				String error = '';

				while(regexMatcher.find()) {
				    			    
				    if(regexMatcher.group().contains('{') || regexMatcher.group().contains('}')) {
						error = 'nested bracket';
				    } else {
				    	List<String> words = regexMatcher.group().split(',');
				        if(words.size() == 1) {
							if(String.IsBlank(words[0])) {
				                error = 'empty answer';
				            }
				        } else {
				            Integer correctWords = 0;
				            for(String word : words) {
				                if(String.IsBlank(word)) {
				                	error = 'empty answer';
				                } else {
				                    if(word.substring(0,1) == '(' && word.substring(word.length() - 1, word.length()) == ')') {
				                        if(correctwords == 0) {
				                			correctwords++;
				                        } else {
				                			error = 'more than one correct answer';
				                        }
				                    }
				                }
							}
				            if(correctWords == 0) {
								error = 'missing correct answer';
				            }
				        }
				    }
				    if(!String.IsBlank(error)) {
				        break;
					}
				}
				if(!String.IsBlank(error)) {
					question.addError('Question text is in the wrong format for a question of the type "Fill in the Blanks". Error: ' + error + '.');             
				} 
	    	}
		}
	}

	// Convert an answer with markups to an plain text answer.
	/*private void formatAnswer(Question__c question) {
		if ( question.MetadataAnswer__c != null && question.MetadataAnswer__c != '') {
			String answer = question.MetadataAnswer__c;
			String regex = '(?<=\\{\\!)(.*?)(?=\\})';
			Pattern regexPattern = Pattern.compile(regex);
			Matcher regexMatcher = regexPattern.matcher(answer);

			List<String> subquestions = new List<String>();
			List<String> answers = new List<String>();
			List<String> correctOption = new List<String>();
			String answerText;

			while(regexMatcher.find()){
				subquestions.add(regexMatcher.group());
				answers = (regexMatcher.group()).split(',');
				if(answers.size()==1){
					correctOption.add(answers[0]);
				} else if (answers.size() > 1) {
					for (String option:answers) {
						if (option.length() < 3)
							continue;
						if (option.substring(0,1)=='(' && option.substring(option.length()-1)==')') {
							correctOption.add(option.substring(1,option.length()-1));
						}
					}
				}
			}

			if(subquestions.size() != correctOption.size()) {
				question.addError('Mismatch of number of questions and number of correct answers.');
			}

			for(String option: correctOption){
				answer = answer.replaceFirst(regex,option);
				answer = answer.replaceFirst('\\{\\!','');
				answer = answer.replaceFirst('\\}','');
			}
			question.AnswerText__c = answer;
		} else {
			question.AnswerText__c = null;
		}
    }*/
}