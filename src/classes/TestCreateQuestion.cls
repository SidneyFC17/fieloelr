@isTest
private class TestCreateQuestion{
	private static List<FieloELR__Question__c> questions = new List<FieloELR__Question__c>();
	private static List<FieloELR__Module__c> modules = new List<FieloELR__Module__c>();
    private static List<FieloELR__AnswerOption__c> answers = new List<FieloELR__AnswerOption__c>();
    private static List<FieloPLT__Program__c> programs;
    private static List<FieloPLT__Segment__c> segments;
    private static List<FieloELR__Course__c> courses;

	@testSetup static void setup() {
    	List<FieloELR__Course__c> courses = new List<FieloELR__Course__c>();            
        List<FieloPLT__Member__c> members = new List<FieloPLT__Member__c>();
        List<FieloPLT__Program__c> programs;
        List<FieloPLT__Segment__c> segments;
        List<FieloELR__Module__c> modules = new List<FieloELR__Module__c>();
        List<FieloELR__AnswerOption__c> answersOpList = new List<FieloELR__AnswerOption__c>();            
        List<FieloELR__Answer__c> answersList = new List<FieloELR__Answer__c>();

        programs = MockUpFactory.createPrograms('Default', 1);
        insert programs;

        segments = MockUpFactory.createSegments('Segment',1,'Manual');
        insert segments;

        courses = MockUpFactory.createCourses(programs.get(0).id, segments.get(0).id, 1);
        insert courses;

        members = MockUpFactory.createMembers(programs.get(0).id, 1);
        insert members;

        FieloPLT__MemberSegment__c memberSegment = new FieloPLT__MemberSegment__c(
            FieloPLT__Segment__c = segments.get(0).Id,
            FieloPLT__Member__c = members.get(0).Id
        );
        insert memberSegment;

        //Module
        modules.add(new Module__c(Name = 'Basic', Course__c = courses.get(0).id, ApprovalGrade__c = 0, AttemptsAllowed__c = 2, AttemptsAllowedPerQuestion__c = 2, PenaltyMode__c = 'None'));

        insert modules;

        //Basic Module Questions
        questions.add(new Question__c(Name = 'Q1', Module__c = modules.get(0).Id, QuestionText__c = 'Which one is the most popular programming language?', Type__c = 'Short Answer'));
        questions.add(new Question__c(Name = 'Q2', Module__c = modules.get(0).Id, QuestionText__c = 'Acronymn for Personal Computer', Type__c = 'Short Answer'));
        questions.add(new Question__c(Name = 'Q3', Module__c = modules.get(0).Id, QuestionText__c = 'Name one Family-C programming language?', Type__c = 'Short Answer'));
        questions.add(new Question__c(Name = 'Q4', Module__c = modules.get(0).Id, QuestionText__c = 'C++ is more performatic than java', Type__c = 'Short Answer'));

        insert questions;

        // Answers Q1 - Basic
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(0).Id, IsCorrect__c = false, AnswerOptionText__c = 'JavaScript'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(0).Id, IsCorrect__c = false, AnswerOptionText__c = 'javascript'));

        // Answers Q2 - Basic
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(1).Id, IsCorrect__c = true, AnswerOptionText__c = 'PC'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(1).Id, IsCorrect__c = true, AnswerOptionText__c = 'pc'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(1).Id, IsCorrect__c = true, AnswerOptionText__c = 'p.c.'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(1).Id, IsCorrect__c = true, AnswerOptionText__c = 'P.C.'));

        // Answers Q3 - Basic
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(2).Id, IsCorrect__c = true, AnswerOptionText__c = 'C++'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(2).Id, IsCorrect__c = true, AnswerOptionText__c = 'c++'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(2).Id, IsCorrect__c = true, AnswerOptionText__c = 'Java'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(2).Id, IsCorrect__c = true, AnswerOptionText__c = 'java'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(2).Id, IsCorrect__c = true, AnswerOptionText__c = 'PHP'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(2).Id, IsCorrect__c = true, AnswerOptionText__c = 'php'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(2).Id, IsCorrect__c = true, AnswerOptionText__c = 'Python'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(2).Id, IsCorrect__c = true, AnswerOptionText__c = 'python'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(2).Id, IsCorrect__c = true, AnswerOptionText__c = 'Objective-C'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(2).Id, IsCorrect__c = true, AnswerOptionText__c = 'objective-c'));

        // Answers Q4 - Basic
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(3).Id, IsCorrect__c = true, AnswerOptionText__c = 'True'));
        answersOpList.add(new AnswerOption__c(Question__c = questions.get(3).Id, IsCorrect__c = true, AnswerOptionText__c = 'true'));

        insert answersOpList;

        //Set Module Active
        modules.get(0).IsActive__c = true;
        update modules;

        //Set Course Active
        courses.get(0).Status__c = 'Active';
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
        insert moduleResponses;
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


    /*@isTest
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
        }*/

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