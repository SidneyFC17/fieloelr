@isTest
private class TestCreateQuestionResponse {
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
        	segments.get(0).FieloPLT__Program__c = programs.get(0).id;
        	segments.get(1).FieloPLT__Program__c = programs.get(1).id;
        	insert segments;

			courses = MockUpFactory.createCourses(programs.get(0).id, segments.get(0).id, 3);
        	courses.get(0).FieloELR__Description__c = 'aTestCourse';
            
            courses.get(1).FieloELR__Program__c = programs.get(1).id;
            courses.get(1).FieloELR__Segment__c = segments.get(1).id;

            courses.get(2).FieloELR__Program__c = programs.get(1).id;
            courses.get(2).FieloELR__Segment__c = segments.get(1).id;
        	insert courses;

    		members = MockUpFactory.createMembers(programs.get(0).id, 3);
            members.get(1).FieloPLT__Program__c = programs.get(1).id;
            members.get(2).FieloPLT__Program__c = programs.get(1).id;
    		insert members;


    		//Module
    		FieloELR__Module__c moduleTest1 = new FieloELR__Module__c();
        	moduleTest1.Name = 'testModule1';
        	moduleTest1.FieloELR__Course__c = courses.get(0).id;
       		moduleTest1.FieloELR__ApprovalGrade__c = 0;
        	modules.add(moduleTest1);

            FieloELR__Module__c moduleTest2 = new FieloELR__Module__c();
            moduleTest2.Name = 'testModule2';
            moduleTest2.FieloELR__Course__c = courses.get(1).id;
            moduleTest2.FieloELR__ApprovalGrade__c = 0;
            modules.add(moduleTest2);

            FieloELR__Module__c moduleTest3 = new FieloELR__Module__c();
            moduleTest3.Name = 'testModule3';
            moduleTest3.FieloELR__Course__c = courses.get(1).id;
            moduleTest3.FieloELR__ApprovalGrade__c = 0;
            moduleTest3.FieloELR__AttemptsAllowedPerQuestion__c = 1;
             modules.add(moduleTest3);

            FieloELR__Module__c moduleTest4 = new FieloELR__Module__c();
            moduleTest4.Name = 'testModule4';
            moduleTest4.FieloELR__Course__c = courses.get(2).id;
            moduleTest4.FieloELR__ApprovalGrade__c = 0;
            moduleTest4.FieloELR__AttemptsAllowedPerQuestion__c = 1;
            modules.add(moduleTest4);
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
            questions.add(question2);

            FieloELR__Question__c question3 = new FieloELR__Question__c();
            question3.Name = 'question2';
            question3.FieloELR__Module__c = modules.get(1).Id;
            question3.FieloELR__QuestionText__c = 'How are you?';
            question3.FieloELR__Type__c = 'Short Answer';
            questions.add(question3);

            FieloELR__Question__c question4 = new FieloELR__Question__c();
            question4.Name = 'question3';
            question4.FieloELR__Module__c = modules.get(2).Id;
            question4.FieloELR__QuestionText__c = 'How are you?';
            question4.FieloELR__Type__c = 'Short Answer';
            questions.add(question4);

            FieloELR__Question__c question5 = new FieloELR__Question__c();
            question5.Name = 'question4';
            question5.FieloELR__Module__c = modules.get(3).Id;
            question5.FieloELR__QuestionText__c = 'How are you?';
            question5.FieloELR__Type__c = 'Short Answer';
            questions.add(question5);
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

            FieloELR__AnswerOption__c answersOp4 = new FieloELR__AnswerOption__c();
            answersOp4.FieloELR__Question__c = questions.get(3).Id;
            answersOp4.FieloELR__IsCorrect__c = true;
            answersOp4.FieloELR__AnswerOptionText__c = 'Esta es correcta';
            answersList.add(answersOp4);


            FieloELR__AnswerOption__c answersOp5 = new FieloELR__AnswerOption__c();
            answersOp5.FieloELR__Question__c = questions.get(4).Id;
            answersOp5.FieloELR__IsCorrect__c = true;
            answersOp5.FieloELR__AnswerOptionText__c = 'Esta es correcta';
            answersList.add(answersOp5);
        	insert answersList;


            //Set Module Active
        	modules.get(0).FieloELR__IsActive__c = true;
            modules.get(1).FieloELR__IsActive__c = true;
            modules.get(2).FieloELR__IsActive__c = true;
            modules.get(3).FieloELR__IsActive__c = true;
        	update modules;
            //Set Course Active
        	courses.get(0).FieloELR__Status__c = 'Active';
            courses.get(1).FieloELR__Status__c = 'Active';
            courses.get(2).FieloELR__Status__c = 'Active';
        	update courses;

            //Course Status
            FieloELR__CourseStatus__c courseStatusTest = new FieloELR__CourseStatus__c();
            courseStatusTest.FieloELR__Course__c = courses.get(0).id;
            courseStatusTest.FieloELR__Member__c = members.get(0).id;
            courseStatus.add(courseStatusTest);
            
            FieloELR__CourseStatus__c courseStatusTest2 = new FieloELR__CourseStatus__c();
            courseStatusTest2.FieloELR__Course__c = courses.get(1).id;
            courseStatusTest2.FieloELR__Member__c = members.get(1).id;
            courseStatus.add(courseStatusTest2);

            FieloELR__CourseStatus__c courseStatusTest3 = new FieloELR__CourseStatus__c();
            courseStatusTest3.FieloELR__Course__c = courses.get(2).id;
            courseStatusTest3.FieloELR__Member__c = members.get(2).id;
            courseStatus.add(courseStatusTest3);
            insert courseStatus;


            //Module Response
            FieloELR__ModuleResponse__c moduleResponseTest = new FieloELR__ModuleResponse__c();
            moduleResponseTest.FieloELR__Module__c = modules.get(0).id;
            moduleResponseTest.FieloELR__Member__c = members.get(0).id;
            moduleResponses.add(moduleResponseTest);

            FieloELR__ModuleResponse__c moduleResponseTest2 = new FieloELR__ModuleResponse__c();
            moduleResponseTest2.FieloELR__Module__c = modules.get(1).id;
            moduleResponseTest2.FieloELR__Member__c = members.get(1).id;
            moduleResponses.add(moduleResponseTest2);
            

            FieloELR__ModuleResponse__c moduleResponseTest3 = new FieloELR__ModuleResponse__c();
            moduleResponseTest3.FieloELR__Module__c = modules.get(3).id;
            moduleResponseTest3.FieloELR__Member__c = members.get(2).id;
            moduleResponses.add(moduleResponseTest3);

            FieloELR__ModuleResponse__c moduleResponseTest4 = new FieloELR__ModuleResponse__c();
            moduleResponseTest4.FieloELR__Module__c = modules.get(2).id;
            moduleResponseTest4.FieloELR__Member__c = members.get(1).id;
            moduleResponses.add(moduleResponseTest4);
            insert moduleResponses;

            moduleResponses.get(0).FieloELR__IsSubmitted__c = true;
            moduleResponses.get(2).FieloELR__IsSubmitted__c = true;
            update moduleResponses.get(0);
            update moduleResponses.get(2);

            //Question Response
            FieloELR__QuestionResponse__c questionResponseTest = new FieloELR__QuestionResponse__c();
            questionResponseTest.FieloELR__Question__c = questions.get(1).id;
            questionResponseTest.FieloELR__ModuleResponse__c = moduleResponses.get(1).id;
            questionResponses.add(questionResponseTest);

            FieloELR__QuestionResponse__c questionResponseTest2 = new FieloELR__QuestionResponse__c();
            questionResponseTest2.FieloELR__Question__c = questions.get(4).id;
            questionResponseTest2.FieloELR__ModuleResponse__c = moduleResponses.get(2).id;
            questionResponses.add(questionResponseTest2);
            insert questionResponses;
            
            //Answer
            FieloELR__Answer__c answer = new FieloELR__Answer__c();
            answer.FieloELR__AnswerOption__c = answersList.get(1).id;
            answer.FieloELR__QuestionResponse__c = questionResponses.get(0).id;
            answer.FieloELR__TextValue__c = 'Esta es correcta';
            insert answer;

            questionResponses.get(1).FieloELR__IsSubmitted__c = true;
            update questionResponses.get(1);

    	}


	@isTest static void ELR_0008_FB() {
        questionResponses = new List<FieloELR__QuestionResponse__c>{new FieloELR__QuestionResponse__c(FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question2' LIMIT 1].id,
        FieloELR__ModuleResponse__c = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__IsSubmitted__c  = false LIMIT 1].id)};
        
        insert questionResponses; 

        questionResponses = [SELECT FieloELR__NumberOfAttempt__c FROM FieloELR__QuestionResponse__c WHERE Id =:questionResponses.get(0).id];

        System.assertEquals(1,questionResponses.get(0).FieloELR__NumberOfAttempt__c);

    } 
	

    @isTest static void ELR_0008_FA1(){
        questionResponses = new List<FieloELR__QuestionResponse__c>{new FieloELR__QuestionResponse__c(FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question0' LIMIT 1].id,
        FieloELR__ModuleResponse__c = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__IsSubmitted__c = true AND FieloELR__Module__r.Name = 'testModule1'].id)};
        
        insert questionResponses;

        System.assertEquals(false , questionResponses.get(0).FieloELR__ModuleResponse__r.FieloELR__IsSubmitted__c);

    }


    @isTest static void ELR_0008_FA2(){
        questionResponses = new List<FieloELR__QuestionResponse__c>{new FieloELR__QuestionResponse__c(FieloELR__ModuleResponse__c = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__IsSubmitted__c  = false LIMIT 1].id)};
        
        try{
            insert questionResponses;
        }catch(System.DmlException e){
            //no validation to assert
            System.assert(e.getMessage().Contains('Attempt to de-reference a null object'));
        }
    }


    @isTest static void ELR_0008_FA3(){
        questionResponses = new List<FieloELR__QuestionResponse__c>{new FieloELR__QuestionResponse__c(FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question0' LIMIT 1].id,
        FieloELR__ModuleResponse__c = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__IsSubmitted__c  = false LIMIT 1].id)};
        
        try{
            insert questionResponses;
        }catch(System.DmlException e){
            System.assert(e.getMessage().Contains(' The related question doesn\'t belong to this module.'));
        } 

    }


    @isTest static void ELR_0008_FA4(){
        questionResponses = new List<FieloELR__QuestionResponse__c>{new FieloELR__QuestionResponse__c(FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question3' LIMIT 1].id,
        FieloELR__ModuleResponse__c = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule3' LIMIT 1].id)};

        FieloELR__QuestionResponse__c newQuestTest = new FieloELR__QuestionResponse__c();
        newQuestTest.FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question3' LIMIT 1].id;
        newQuestTest.FieloELR__ModuleResponse__c  = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule3' LIMIT 1].id;
       
       questionResponses.add(newQuestTest);

       try{
            insert questionResponses;
        }catch(System.Dmlexception e){
            System.assert(e.getMessage().Contains('You have reached the limit of attempts for this question.'));
        }

    }


    @isTest static void ELR_0008_FA5(){
        questionResponses = [SELECT Id,FieloELR__IsSubmitted__c FROM FieloELR__QuestionResponse__c WHERE FieloELR__Question__r.Name = 'question0' LIMIT 1];

        delete questionResponses;

        questionResponses = [SELECT Id,FieloELR__IsSubmitted__c FROM FieloELR__QuestionResponse__c WHERE FieloELR__Question__r.Name = 'question0' LIMIT 1];
        System.assertEquals(0, questionResponses.size());
    }


    @isTest static void ELR_0008_FA6(){
        questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__IsSubmitted__c = true];
        
        try{
            delete questionResponses;
        }catch(System.Dmlexception e){    
            System.assert(e.getMessage().Contains('Cannot delete question responses from a module that was already submitted.'));
        }

    }


    @isTest static void ELR_0008_FA7(){
        questionResponses = [SELECT Id,FieloELR__Question__c FROM FieloELR__QuestionResponse__c WHERE FieloELR__IsSubmitted__c = false];
        questionResponses.get(0).FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question1'].id;

        update questionResponses;

        questionResponses = [SELECT FieloELR__Question__r.Name FROM FieloELR__QuestionResponse__c];

        System.assertEquals('question1', questionResponses.get(0).FieloELR__Question__r.Name);


        questionResponses = [SELECT Id,FieloELR__TextValue__c FROM FieloELR__QuestionResponse__c WHERE FieloELR__IsSubmitted__c = false];
        questionResponses.get(0).FieloELR__TextValue__c = 'newTextValue';

        update questionResponses;

        questionResponses = [SELECT FieloELR__TextValue__c FROM FieloELR__QuestionResponse__c];

        System.assertEquals('newTextValue',questionResponses.get(0).FieloELR__TextValue__c);

    }


    @isTest static void ELR_0008_FA8(){
        questionResponses = [SELECT Id,FieloELR__IsSubmitted__c,FieloELR__TextValue__c FROM FieloELR__QuestionResponse__c WHERE FieloELR__IsSubmitted__c = true];
        questionResponses.get(0).FieloELR__TextValue__c = 'aNewText';

        try{
            update questionResponses;
        }catch(System.Dmlexception e){
            System.assert(e.getMessage().Contains('Cannot modify a question response already submitted'));
        } 

    }


    @isTest static void ELR_0008_FA10(){
        questionResponses = [SELECT Id,FieloELR__IsSubmitted__c FROM FieloELR__QuestionResponse__c WHERE FieloELR__IsSubmitted__c = true];

        questionResponses.get(0).FieloELR__IsSubmitted__c = false;

        try{
            update questionResponses;
        }catch(System.Dmlexception e){
            System.assert(e.getMessage().Contains( 'Cannot modify a question response already submitted'));
        }
        
    }

}