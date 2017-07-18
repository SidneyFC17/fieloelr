@isTest
private class TestSubmitQuestionResponse {
	private static List<FieloELR__QuestionResponse__c> questionResponses = new List<FieloELR__QuestionResponse__c>();
    private static List<FieloELR__ModuleResponse__c> moduleResponses = new List<FieloELR__ModuleResponse__c>();
	
	@testSetup
    	static void setup(){
    		List<FieloELR__Course__c> courses = new List<FieloELR__Course__c>();
    		List<FieloELR__Question__c> questions = new List<FieloELR__Question__c>();
    		List<FieloPLT__Member__c> members = new List<FieloPLT__Member__c>();
    		List<FieloPLT__Program__c> programs;
    		List<FieloPLT__Segment__c> segments;
			List<FieloELR__Module__c> modules = new List<FieloELR__Module__c>();
			List<FieloELR__AnswerOption__c> answersList = new List<FieloELR__AnswerOption__c>();
			List<FieloELR__CourseStatus__c> courseStatus = new List<FieloELR__CourseStatus__c>();

			programs = MockUpFactory.createPrograms('testProgram', 2);
       		insert programs;

       		segments = MockUpFactory.createSegments('testSegment',2,'Dynamic');
        	insert segments;

			courses = MockUpFactory.createCourses(programs.get(0).id, segments.get(0).id, 2);
        	insert courses;

    		members = MockUpFactory.createMembers(programs.get(0).id, 3);
    		insert members;


    		//Module
    		FieloELR__Module__c moduleTest1 = new FieloELR__Module__c();
        	moduleTest1.Name = 'testModule1';
        	moduleTest1.FieloELR__Course__c = courses.get(0).id;
       		moduleTest1.FieloELR__ApprovalGrade__c = 1;
       		moduleTest1.FieloELR__PenaltyMode__c = 'None';
            modules.add(moduleTest1);
            
            FieloELR__Module__c moduleTest2 = new FieloELR__Module__c();
            moduleTest2.Name = 'testModule2';
            moduleTest2.FieloELR__Course__c = courses.get(0).id;
            moduleTest2.FieloELR__ApprovalGrade__c = 1;
            moduleTest2.FieloELR__PenaltyMode__c = 'Negative Weight';
        	modules.add(moduleTest2);

            FieloELR__Module__c moduleTest3 = new FieloELR__Module__c();
            moduleTest3.Name = 'testModule3';
            moduleTest3.FieloELR__Course__c = courses.get(0).id;
            moduleTest3.FieloELR__ApprovalGrade__c = 1;
            moduleTest3.FieloELR__PenaltyMode__c = 'Percent Decrease';
            modules.add(moduleTest3);
            insert modules;

        	//Question
        	FieloELR__Question__c question1 = new FieloELR__Question__c();
        	question1.Name = 'question0';
        	question1.FieloELR__Module__c = modules.get(0).Id;
        	question1.FieloELR__QuestionText__c = 'How are you?';
        	question1.FieloELR__Type__c = 'Short Answer';
        	questions.add(question1);

            FieloELR__Question__c question2 = new FieloELR__Question__c();
            question2.Name = 'question1';
            question2.FieloELR__Module__c = modules.get(1).Id;
            question2.FieloELR__QuestionText__c = 'How are you?';
            question2.FieloELR__Type__c = 'Short Answer';
            question2.FieloELR__IncorrectWeight__c = 1;
            questions.add(question2);

            FieloELR__Question__c question3 = new FieloELR__Question__c();
            question3.Name = 'question2';
            question3.FieloELR__Module__c = modules.get(2).Id;
            question3.FieloELR__QuestionText__c = 'How are you?';
            question3.FieloELR__Type__c = 'Short Answer';
            question3.FieloELR__IncorrectWeight__c = 1;
            question3.FieloELR__PenaltyPerAttempt__c  = 2;
            questions.add(question3);
            insert questions;

        	//Answer
        	FieloELR__AnswerOption__c answersOp1 = new FieloELR__AnswerOption__c();
        	answersOp1.FieloELR__Question__c = questions.get(0).Id;
        	answersOp1.FieloELR__IsCorrect__c = true;
        	answersOp1.FieloELR__AnswerOptionText__c = 'Esta es correcta';
        	answersList.add(answersOp1);

            FieloELR__AnswerOption__c answersOp2 = new FieloELR__AnswerOption__c();
            answersOp2.FieloELR__Question__c = questions.get(1).Id;
            answersOp2.FieloELR__IsCorrect__c = true;
            answersOp2.FieloELR__AnswerOptionText__c = 'Esta es correcta';
            answersList.add(answersOp2);

            FieloELR__AnswerOption__c answersOp3 = new FieloELR__AnswerOption__c();
            answersOp3.FieloELR__Question__c = questions.get(2).Id;
            answersOp3.FieloELR__IsCorrect__c = true;
            answersOp3.FieloELR__AnswerOptionText__c = 'Esta es correcta';
            answersList.add(answersOp3);
        	insert answersList;


            //Set Module Active
        	modules.get(0).FieloELR__IsActive__c = true;
            modules.get(1).FieloELR__IsActive__c = true;
            modules.get(2).FieloELR__IsActive__c = true;
        	update modules;
            //Set Course Active
        	courses.get(0).FieloELR__Status__c = 'Active';
        	update courses;

            //Course Status
            FieloELR__CourseStatus__c courseStatusTest = new FieloELR__CourseStatus__c();
            courseStatusTest.FieloELR__Course__c = courses.get(0).id;
            courseStatusTest.FieloELR__Member__c = members.get(0).id;
            courseStatus.add(courseStatusTest);
            insert courseStatus;


            //Module Response
            FieloELR__ModuleResponse__c moduleResponseTest = new FieloELR__ModuleResponse__c();
            moduleResponseTest.FieloELR__Module__c = modules.get(0).id;
            moduleResponseTest.FieloELR__Member__c = members.get(0).id;
            moduleResponses.add(moduleResponseTest);

            FieloELR__ModuleResponse__c moduleResponseTest1 = new FieloELR__ModuleResponse__c();
            moduleResponseTest1.FieloELR__Module__c = modules.get(1).id;
            moduleResponseTest1.FieloELR__Member__c = members.get(0).id;
            moduleResponses.add(moduleResponseTest1);

            FieloELR__ModuleResponse__c moduleResponseTest2 = new FieloELR__ModuleResponse__c();
            moduleResponseTest2.FieloELR__Module__c = modules.get(2).id;
            moduleResponseTest2.FieloELR__Member__c = members.get(0).id;
            moduleResponses.add(moduleResponseTest2);
			insert moduleResponses;

            moduleResponses.get(0).FieloELR__IsSubmitted__c = true;
            moduleResponses.get(1).FieloELR__IsSubmitted__c = true;
            moduleResponses.get(2).FieloELR__IsSubmitted__c = true;
            update moduleResponses;


            //Question Response
            FieloELR__QuestionResponse__c questionResponseTest = new FieloELR__QuestionResponse__c();
            questionResponseTest.FieloELR__Question__c = questions.get(0).id;
            questionResponseTest.FieloELR__ModuleResponse__c = moduleResponses.get(0).id;
            questionResponseTest.FieloELR__IsCorrect__c = true;
            questionResponses.add(questionResponseTest);
            insert questionResponses;
            
            //Answer
            FieloELR__Answer__c answer = new FieloELR__Answer__c();
            answer.FieloELR__AnswerOption__c = answersList.get(0).id;
            answer.FieloELR__QuestionResponse__c = questionResponses.get(0).id;
            answer.FieloELR__TextValue__c = 'Esta es correcta';
            insert answer;

            questionResponses.get(0).FieloELR__IsSubmitted__c = true;
            update questionResponses.get(0);
      	}

	
	/*@isTest static void ELR_0012_FB(){
		questionResponses = new List<FieloELR__QuestionResponse__c>{new FieloELR__QuestionResponse__c(
            FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question0'].id, 
            FieloELR__ModuleResponse__c = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule1'].id,
            FieloELR__IsCorrect__c = true)};
        insert questionResponses;

        questionResponses.get(0).FieloELR__IsSubmitted__c = true;
        update questionResponses;

        questionResponses = [SELECT FieloELR__PartialGradeValue__c,FieloELR__IsSubmitted__c,FieloELR__Question__r.FieloELR__CorrectWeight__c,FieloELR__ModuleResponse__r.FieloELR__Module__r.FieloELR__PenaltyMode__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
        System.assertEquals(questionResponses.get(0).FieloELR__Question__r.FieloELR__CorrectWeight__c, questionResponses.get(0).FieloELR__PartialGradeValue__c);
    }*/

	
	
    @isTest static void ELR_0012_FA1(){
        questionResponses = new List<FieloELR__QuestionResponse__c>{new FieloELR__QuestionResponse__c(
            FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question0'].id, 
            FieloELR__ModuleResponse__c = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule1'].id,
            FieloELR__IsCorrect__c = false)};

        insert questionResponses;

        questionResponses.get(0).FieloELR__IsSubmitted__c = true;
        update questionResponses;

        questionResponses = [SELECT FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
        System.assertEquals(0,questionResponses.get(0).FieloELR__PartialGradeValue__c);
    }


    @isTest static void ELR_0012_FA2(){
        questionResponses = new List<FieloELR__QuestionResponse__c>{new FieloELR__QuestionResponse__c(
            FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question1'].id, 
            FieloELR__ModuleResponse__c = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule2'].id,
            FieloELR__IsCorrect__c = true)};
        insert questionResponses;

        questionResponses.get(0).FieloELR__IsSubmitted__c = true;
        update questionResponses;

        questionResponses = [SELECT FieloELR__PartialGradeValue__c, FieloELR__Question__r.FieloELR__CorrectWeight__c,FieloELR__ModuleResponse__r.FieloELR__Module__r.FieloELR__PenaltyMode__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
        
        System.assertEquals(questionResponses.get(0).FieloELR__Question__r.FieloELR__CorrectWeight__c, questionResponses.get(0).FieloELR__PartialGradeValue__c);
    }


    @isTest static void ELR_0012_FA3(){
         questionResponses = new List<FieloELR__QuestionResponse__c>{new FieloELR__QuestionResponse__c(
            FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question1'].id, 
            FieloELR__ModuleResponse__c = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule2'].id,
            FieloELR__IsCorrect__c = false)};
        
        insert questionResponses;

        questionResponses.get(0).FieloELR__IsSubmitted__c = true;
        update questionResponses;

        questionResponses = [SELECT FieloELR__PartialGradeValue__c, FieloELR__Question__r.FieloELR__CorrectWeight__c,FieloELR__ModuleResponse__r.FieloELR__Module__r.FieloELR__PenaltyMode__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
        
        System.assertEquals(questionResponses.get(0).FieloELR__Question__r.FieloELR__CorrectWeight__c, questionResponses.get(0).FieloELR__PartialGradeValue__c);
    }


    @isTest static void ELR_0012_FA4(){
         questionResponses = new List<FieloELR__QuestionResponse__c>{new FieloELR__QuestionResponse__c(
            FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question2'].id, 
            FieloELR__ModuleResponse__c = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule3'].id,
            FieloELR__IsCorrect__c = true)};
        
        insert questionResponses;

        questionResponses.get(0).FieloELR__IsSubmitted__c = true;
        update questionResponses;

        questionResponses = [SELECT FieloELR__PartialGradeValue__c, FieloELR__Question__r.FieloELR__CorrectWeight__c,FieloELR__ModuleResponse__r.FieloELR__Module__r.FieloELR__PenaltyMode__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
        System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c < questionResponses.get(0).FieloELR__Question__r.FieloELR__CorrectWeight__c);
    }

    @isTest static void ELR_0012_FA5(){
         questionResponses = new List<FieloELR__QuestionResponse__c>{new FieloELR__QuestionResponse__c(
            FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question2'].id, 
            FieloELR__ModuleResponse__c = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule3'].id,
            FieloELR__IsCorrect__c = false)};
        
        insert questionResponses;

        questionResponses.get(0).FieloELR__IsSubmitted__c = true;
        update questionResponses;

        questionResponses = [SELECT FieloELR__PartialGradeValue__c, FieloELR__Question__r.FieloELR__CorrectWeight__c,FieloELR__ModuleResponse__r.FieloELR__Module__r.FieloELR__PenaltyMode__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
        System.assertEquals(0,questionResponses.get(0).FieloELR__PartialGradeValue__c);
    }
}