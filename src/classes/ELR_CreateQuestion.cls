@isTest
private class ELR_CreateQuestion{
	private static List<FieloELR__Question__c> questions = new List<FieloELR__Question__c>();
	private static List<FieloELR__Module__c> modules = new List<FieloELR__Module__c>();
    private static List<FieloELR__AnswerOption__c> answers = new List<FieloELR__AnswerOption__c>();
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Segment__c> segments;
    private static List<FieloELR__Course__c> courses;

	@testSetup
    	static void setup(){ 
    	programs = MockUpFactory.createPrograms('testProgram', 2);
        insert programs;

        //Segments
        segments = MockUpFactory.createSegments('testSegment',2,'Dynamic');
        segments.get(0).FieloPLT__Program__c = programs.get(0).id;
        segments.get(1).FieloPLT__Program__c = programs.get(1).id;
        insert segments;

    	//Courses 
        courses = MockUpFactory.createCourses(programs.get(0).id, segments.get(0).id, 3);
        courses.get(0).FieloELR__Description__c = 'aTestCourse';

        insert courses;

    	//Module
        FieloELR__Module__c moduleTest = new FieloELR__Module__c();
        moduleTest.Name = 'testModule';
        moduleTest.FieloELR__Course__c = courses.get(0).id;
        moduleTest.FieloELR__ApprovalGrade__c = 0;
        moduleTest.FieloELR__QuestionPool__c = 2;
        modules.add(moduleTest);

        //active module
        FieloELR__Module__c moduleTest1 = new FieloELR__Module__c();
        moduleTest1.Name = 'testModule1';
        moduleTest1.FieloELR__Course__c = courses.get(1).id;
        moduleTest1.FieloELR__ApprovalGrade__c = 0;

        modules.add(moduleTest1);
        
        //module with penaltymode = 'none'
        FieloELR__Module__c moduleTest2 = new FieloELR__Module__c();
        moduleTest2.Name = 'testModule2';
        moduleTest2.FieloELR__Course__c = courses.get(1).id;
        moduleTest2.FieloELR__ApprovalGrade__c = 0;
        moduleTest2.FieloELR__PenaltyMode__c = 'None';
        moduleTest2.FieloELR__QuestionPool__c = 2;
        modules.add(moduleTest2);

        FieloELR__Module__c moduleTest3 = new FieloELR__Module__c();
        moduleTest3.Name = 'testModule3';
        moduleTest3.FieloELR__Course__c = courses.get(1).id;
        moduleTest3.FieloELR__ApprovalGrade__c = 0;
        moduleTest3.FieloELR__WeightedQuestions__c = true;
        modules.add(moduleTest3);

        FieloELR__Module__c moduleTest4 = new FieloELR__Module__c();
        moduleTest4.Name = 'testModule4';
        moduleTest4.FieloELR__Course__c = courses.get(1).id;
        moduleTest4.FieloELR__ApprovalGrade__c = 0;
        moduleTest4.FieloELR__WeightedQuestions__c = false;
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

        //question to delete
        FieloELR__Question__c question3 = new FieloELR__Question__c();
        question3.Name = 'question3';
        question3.FieloELR__Module__c = modules.get(3).Id;
        question3.FieloELR__QuestionText__c = 'How are you?';
        question3.FieloELR__Type__c = 'Short Answer';
        question3.FieloELR__CorrectWeight__c = 1;
        question3.FieloELR__IncorrectWeight__c = 0;
        question3.FieloELR__Order__c = 1;
        question3.FieloELR__PenaltyPerAttempt__c = 0;
        questions.add(question3);

        insert questions;

        //Answer
        FieloELR__AnswerOption__c answers1 = new FieloELR__AnswerOption__c();
        answers1.FieloELR__Question__c = questions.get(0).Id;
        answers1.FieloELR__IsCorrect__c = true;
        answers1.FieloELR__AnswerOptionText__c = 'Esta es correcta';
        answers.add(answers1);

        FieloELR__AnswerOption__c answers2 = new FieloELR__AnswerOption__c();
        answers2.FieloELR__Question__c = questions.get(1).Id;
        answers2.FieloELR__IsCorrect__c = true;
        answers2.FieloELR__AnswerOptionText__c = 'Esta es correcta';
        answers.add(answers2);
        insert answers;

        modules.get(1).FieloELR__IsActive__c = true;
        update modules;
	}

	@isTest
		static void ELR_0005_FB(){
			
			questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'Quest1',
				FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule' LIMIT 1].id,
				FieloELR__Type__c = 'Single Choice',FieloELR__Order__c = 1,FieloELR__CorrectWeight__c = 1,
				FieloELR__IncorrectWeight__c = 0,
				FieloELR__PenaltyPerAttempt__c = 0,
				FieloELR__QuestionText__c = 'someQuest')};

			insert questions.get(0);
			
			questions = [SELECT Id FROM FieloELR__Question__c  WHERE Name = 'Quest1' LIMIT 1];

			System.assertEquals(1, questions.size());
		}

	@isTest
		static void ELR_0005_FA1(){
			questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'Quest1',
				FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule1' LIMIT 1].id,
				FieloELR__Type__c = 'Single Choice')};
			try{
				insert questions;
			}catch(System.Dmlexception e){
					System.assert(e.getMessage().Contains('Active modules or modules with module responses cannot have changes in their set of questions.'));
			}
		}

	/*@isTest 
		static void ELR_0005_FA2(){
			FieloELR__Question__c quest = new FieloELR__Question__c();
            quest.FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule2' LIMIT 1].id;
            quest.Name = 'QuestName';
            quest.FieloELR__Type__c = 'Short Answer';
			insert quest;
			
		} validation is not working*/ 


    @isTest
        static void ELR_0005_FA3(){
            questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'QuestTest',
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule2' LIMIT 1].id,
                FieloELR__Type__c = 'Single Choice')};

            insert questions;

            questions = [SELECT FieloELR__Order__c FROM FieloELR__Question__c WHERE Name = 'QuestTest' LIMIT 1];
            System.assert(questions.get(0).FieloELR__Order__c != 0);

        }

    @isTest
        static void ELR_0005_FA4(){
            questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'QuestTest',
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule2' LIMIT 1].id,
                FieloELR__Type__c = 'Short Answer')};

            insert questions;

            questions = [SELECT FieloELR__CorrectWeight__c FROM FieloELR__Question__c WHERE Name = 'QuestTest' LIMIT 1];
            System.assert(questions.get(0).FieloELR__CorrectWeight__c != 0);
        }

    @isTest
        static void ELR_0005_FA5(){
            questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'QuestTest',
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule2' LIMIT 1].id,
                FieloELR__Type__c = 'Short Answer')};

            questions.get(0).FieloELR__CorrectWeight__c = 5;

            insert questions;

            questions = [SELECT FieloELR__CorrectWeight__c FROM FieloELR__Question__c WHERE Name = 'QuestTest' LIMIT 1];
            System.assertEquals(1, questions.get(0).FieloELR__CorrectWeight__c);
        }

    @isTest 
        static void ELR_0005_FA6(){
            questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'QuestTest',
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule2' LIMIT 1].id,
                FieloELR__Type__c = 'Short Answer')};
            
            questions.get(0).FieloELR__CorrectWeight__c = -1;

            try{
                insert questions;
            }catch(System.Dmlexception e){
                System.assert(e.getMessage().Contains('The correct weight must be a positive number.'));
            } 
        }

    @isTest
        static void ELR_0005_FA7(){
             questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'QuestTest',
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule4' LIMIT 1].id,
                FieloELR__Type__c = 'Short Answer')};

             questions.get(0).FieloELR__CorrectWeight__c  = 5;

             insert questions;

             questions = [SELECT FieloELR__CorrectWeight__c FROM FieloELR__Question__c WHERE Name = 'QuestTest' LIMIT 1];

             System.assertEquals(1, questions.get(0).FieloELR__CorrectWeight__c);

        }

    @isTest
        static void ELR_0005_FA8(){
             questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'QuestTest',
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule' LIMIT 1].id,
                FieloELR__Type__c = 'Short Answer')};

             insert questions;

             questions = [SELECT FieloELR__IncorrectWeight__c FROM FieloELR__Question__c WHERE Name = 'QuestTest'];

             System.assertEquals(0,questions.get(0).FieloELR__IncorrectWeight__c);

        }

    @isTest
        static void ELR_0005_FA9(){
            questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'QuestTest',
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule' LIMIT 1].id,
                FieloELR__Type__c = 'Multiple Choice')};

            insert questions;

            questions = [SELECT FieloELR__PenaltyPerAttempt__c FROM FieloELR__Question__c WHERE Name = 'QuestTest' LIMIT 1];

            System.assertEquals(0,questions.get(0).FieloELR__PenaltyPerAttempt__c);
        }

    @isTest
        static void ELR_0005_FA10(){
             questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'QuestTest',
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule' LIMIT 1].id,
                FieloELR__Type__c = 'Multiple Choice')};

             questions.get(0).FieloELR__PenaltyPerAttempt__c = -1;

            try{
                insert questions;
            }catch(System.Dmlexception e){
                System.assert(e.getMessage().Contains(' The penalty per attempt must have a value  between 0 and 100.'));
            }

            questions.get(0).FieloELR__PenaltyPerAttempt__c = 200;
            
            try{
                insert questions;
            }catch(System.Dmlexception e){
                System.assert(e.getMessage().Contains(' The penalty per attempt must have a value  between 0 and 100.'));
            }

        }

    @isTest
        static void ELR_0005_FA11(){
            questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'QuestTest',
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule' LIMIT 1].id)};

            try{
                insert questions;
            }catch(System.Dmlexception e){
                System.assert(e.getMessage().Contains('Required fields are missing'));
            }
        }

    @isTest
        static void ELR_0005_FA12(){
            questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'QuestTestName',
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule' LIMIT 1].id,
                FieloELR__Type__c = 'Statement',FieloELR__Order__c = 1,FieloELR__CorrectWeight__c = 1,
                FieloELR__IncorrectWeight__c = 0,
                FieloELR__PenaltyPerAttempt__c = 0,
                FieloELR__QuestionText__c = 'someQuest')};

            insert questions;

            questions = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'QuestTestName'];

            System.assertEquals(1, questions.size());
        }

    @isTest
        static void ELR_0005_FA13(){
            questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'newQuestion', 
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule' LIMIT 1].id,
                FieloELR__Type__c = 'Multiple Choice', FieloELR__Order__c = 1, FieloELR__CorrectWeight__c = 1,
                FieloELR__IncorrectWeight__c = 0, FieloELR__PenaltyPerAttempt__c = 0, FieloELR__QuestionText__c = 'Is null?')};

            insert questions;

            questions = [SELECT FieloELR__Type__c FROM FieloELR__Question__c WHERE Name = 'newQuestion' LIMIT 1];
            System.assertEquals('Multiple Choice', questions.get(0).FieloELR__Type__c);

        }

    @isTest
        static void ELR_0005_FA14(){
            questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'newQuestion', 
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule' LIMIT 1].id,
                FieloELR__Type__c = 'Short Answer', FieloELR__Order__c = 1, FieloELR__CorrectWeight__c = 1,
                FieloELR__IncorrectWeight__c = 0, FieloELR__PenaltyPerAttempt__c = 0, FieloELR__QuestionText__c = 'How do you do?')};

            insert questions;

            questions = [SELECT FieloELR__Type__c FROM FieloELR__Question__c WHERE Name = 'newQuestion' LIMIT 1];
            System.assertEquals('Short Answer', questions.get(0).FieloELR__Type__c);
        }

    
    @isTest
        static void ELR_0005_FA15(){
            questions = new List<FieloELR__Question__c>{new FieloELR__Question__c(Name = 'newQuestion', 
                FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule' LIMIT 1].id,
                FieloELR__Type__c = 'Matching Options', FieloELR__Order__c = 1, FieloELR__CorrectWeight__c = 1,
                FieloELR__IncorrectWeight__c = 0, FieloELR__PenaltyPerAttempt__c = 0, FieloELR__QuestionText__c = 'A new Question')};

            insert questions;

            questions = [SELECT FieloELR__Type__c FROM FieloELR__Question__c WHERE Name = 'newQuestion' LIMIT 1];
            System.assertEquals('Matching Options', questions.get(0).FieloELR__Type__c);
        }

   @isTest
        static void ELR_0005_FA16(){
            questions = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question3'];

            delete questions;

            questions = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question3'];

            System.assertEquals(0,questions.size());
        }

    @IsTest 
        static void ELR_0005_FA17(){
            questions = [SELECT Id,FieloELR__Module__c FROM FieloELR__Question__c WHERE Name = 'question1'];

            try{
                delete questions;
            }catch(System.DmlException e){
                e.getMessage().Contains('Active modules cannot have changes in their set of questions.');
            }
            
        }

    @isTest
        static void ELR_0005_FA18(){
            questions = [SELECT Id,FieloELR__Module__c,FieloELR__QuestionText__c FROM FieloELR__Question__c WHERE Name = 'question0'];
           
            questions.get(0).FieloELR__QuestionText__c = 'New question';
           
            update questions;

            questions = [SELECT Id,FieloELR__Module__c,FieloELR__QuestionText__c FROM FieloELR__Question__c WHERE Name = 'question0'];

            System.assertEquals('New question', questions.get(0).FieloELR__QuestionText__c);
        }

    @isTest
        static void ELR_0005_FA19(){
            questions = [SELECT Id,FieloELR__Module__c,FieloELR__QuestionText__c FROM FieloELR__Question__c WHERE Name = 'question1'];
           
            questions.get(0).FieloELR__QuestionText__c = 'Question Text';
              
            try{  
                update questions;
            }catch(System.DmlException e){
                e.getMessage().Contains('Active modules cannot have changes in their set of questions.');
            }
            
        }

    @isTest
        static void ELR_0005_FA20(){
            questions = [SELECT Id, FieloELR__Module__c, FieloELR__CorrectWeight__c FROM FieloELR__Question__c WHERE Name = 'question0'];
            questions.get(0).FieloELR__CorrectWeight__c = 5;

            update questions;

            questions = [SELECT FieloELR__CorrectWeight__c FROM FieloELR__Question__c WHERE Name ='question0'];

            System.assertEquals(1, questions.get(0).FieloELR__CorrectWeight__c);
        }

   /*@isTest
        static void ELR_0005_FA21(){
            questions = [SELECT Id, FieloELR__Module__c, FieloELR__Type__c FROM FieloELR__Question__c WHERE Name = 'question0'];
            questions.get(0).FieloELR__Type__c = 'Multiple Choice';
            
            update questions;
 
            //questions = [SELECT FieloELR__Type__c FROM FieloELR__Question__c WHERE Name ='question0'];
        } */
}