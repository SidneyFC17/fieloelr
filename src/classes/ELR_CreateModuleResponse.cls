@isTest
private class ELR_CreateModuleResponse {
	private static List<FieloELR__ModuleResponse__c> moduleRespList = new List<FieloELR__ModuleResponse__c>();
	
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
            List<FieloELR__QuestionResponse__c> questionResponses = new List<FieloELR__QuestionResponse__c>();

            programs = MockUpFactory.createPrograms('testProgram', 3);
            insert programs;

            segments = MockUpFactory.createSegments('testSegment',3,'Dynamic');
            insert segments;

            courses = MockUpFactory.createCourses(programs.get(0).id, segments.get(0).id, 8);
            courses.get(0).FieloELR__StartDate__c = Date.today();
            courses.get(0).FieloELR__EndDate__c = Date.today().addDays(5);
            courses.get(3).FieloELR__SubscriptionMode__c = 'Manual';
            courses.get(4).FieloELR__SubscriptionMode__c = 'Manual';
            courses.get(5).FieloELR__SubscriptionMode__c = 'Manual';
            courses.get(6).FieloELR__Segment__c = segments.get(1).id;
            courses.get(7).FieloELR__SubscriptionMode__c = 'Manual';
            insert courses;

            members = MockUpFactory.createMembers(programs.get(0).id, 6);
            insert members;


            //Module
            FieloELR__Module__c moduleTest1 = new FieloELR__Module__c();
            moduleTest1.Name = 'testModule1';
            moduleTest1.FieloELR__Course__c = courses.get(0).id;
            moduleTest1.FieloELR__ApprovalGrade__c = 0;
            moduleTest1.FieloELR__AttemptsAllowed__c = 2;
            moduleTest1.FieloELR__AttemptsAllowedPerQuestion__c = 1;
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
            modules.add(moduleTest3);

            FieloELR__Module__c moduleTest4 = new FieloELR__Module__c();
            moduleTest4.Name = 'testModule4';
            moduleTest4.FieloELR__Course__c = courses.get(2).id;
            moduleTest4.FieloELR__ApprovalGrade__c = 0;
            moduleTest4.FieloELR__AttemptsAllowed__c = 1;
            moduleTest4.FieloELR__AttemptsAllowedPerQuestion__c = 1;
            modules.add(moduleTest4);

            FieloELR__Module__c moduleTest5 = new FieloELR__Module__c();
            moduleTest5.Name = 'testModule5';
            moduleTest5.FieloELR__Course__c = courses.get(3).id;
            moduleTest5.FieloELR__ApprovalGrade__c = 0;
            moduleTest5.FieloELR__AttemptsAllowed__c = 2;
            moduleTest5.FieloELR__AttemptsAllowedPerQuestion__c = 1;
            modules.add(moduleTest5);

            FieloELR__Module__c moduleTest6 = new FieloELR__Module__c();
            moduleTest6.Name = 'testModule6';
            moduleTest6.FieloELR__Course__c = courses.get(4).id;
            moduleTest6.FieloELR__ApprovalGrade__c = 0;
            moduleTest6.FieloELR__AttemptsAllowed__c = 2;
            moduleTest6.FieloELR__AttemptsAllowedPerQuestion__c = 1;
            modules.add(moduleTest6);

            FieloELR__Module__c moduleTest7  = new FieloELR__Module__c();
            moduleTest7.Name = 'testModule7';
            moduleTest7.FieloELR__Course__c = courses.get(5).id;
            moduleTest7.FieloELR__ApprovalGrade__c = 0;
            moduleTest7.FieloELR__AttemptsAllowed__c = 2;
            moduleTest7.FieloELR__AttemptsAllowedPerQuestion__c = 1;
            modules.add(moduleTest7);

            FieloELR__Module__c moduleTest8  = new FieloELR__Module__c();
            moduleTest8.Name = 'testModule8';
            moduleTest8.FieloELR__Course__c = courses.get(6).id;
            moduleTest8.FieloELR__ApprovalGrade__c = 0;
            moduleTest8.FieloELR__AttemptsAllowed__c = 2;
            moduleTest8.FieloELR__AttemptsAllowedPerQuestion__c = 1;
            modules.add(moduleTest8);

            FieloELR__Module__c moduleTest9  = new FieloELR__Module__c();
            moduleTest9.Name = 'testModule9';
            moduleTest9.FieloELR__Course__c = courses.get(7).id;
            moduleTest9.FieloELR__ApprovalGrade__c = 0;
            moduleTest9.FieloELR__AttemptsAllowed__c = 2;
            moduleTest9.FieloELR__AttemptsAllowedPerQuestion__c = 1;
            moduleTest9.FieloELR__ApprovalGrade__c = 10;
            modules.add(moduleTest9);
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
            question3.FieloELR__Module__c = modules.get(2).Id;
            question3.FieloELR__QuestionText__c = 'How are you?';
            question3.FieloELR__Type__c = 'Short Answer';
            questions.add(question3);

            FieloELR__Question__c question4 = new FieloELR__Question__c();
            question4.Name = 'question3';
            question4.FieloELR__Module__c = modules.get(3).Id;
            question4.FieloELR__QuestionText__c = 'How are you?';
            question4.FieloELR__Type__c = 'Short Answer';
            questions.add(question4);

            FieloELR__Question__c question5 = new FieloELR__Question__c();
            question5.Name = 'question4';
            question5.FieloELR__Module__c = modules.get(4).Id;
            question5.FieloELR__QuestionText__c = 'How are you?';
            question5.FieloELR__Type__c = 'Short Answer';
            questions.add(question5);

            FieloELR__Question__c question6 = new FieloELR__Question__c();
            question6.Name = 'question6';
            question6.FieloELR__Module__c = modules.get(5).Id;
            question6.FieloELR__QuestionText__c = 'How are you?';
            question6.FieloELR__Type__c = 'Short Answer';
            questions.add(question6);

            FieloELR__Question__c question7 = new FieloELR__Question__c();
            question7.Name = 'question7';
            question7.FieloELR__Module__c = modules.get(6).Id;
            question7.FieloELR__QuestionText__c = 'How are you?';
            question7.FieloELR__Type__c = 'Short Answer';
            questions.add(question7);

            FieloELR__Question__c question8 = new FieloELR__Question__c();
            question8.Name = 'question8';
            question8.FieloELR__Module__c = modules.get(7).Id;
            question8.FieloELR__QuestionText__c = 'How are you?';
            question8.FieloELR__Type__c = 'Short Answer';
            questions.add(question8);

            FieloELR__Question__c question9 = new FieloELR__Question__c();
            question9.Name = 'question9';
            question9.FieloELR__Module__c = modules.get(8).Id;
            question9.FieloELR__QuestionText__c = 'How are you?';
            question9.FieloELR__Type__c = 'Short Answer';
            questions.add(question9);
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

            FieloELR__AnswerOption__c answersOp6 = new FieloELR__AnswerOption__c();
            answersOp6.FieloELR__Question__c = questions.get(5).Id;
            answersOp6.FieloELR__IsCorrect__c = true;
            answersOp6.FieloELR__AnswerOptionText__c = 'Esta es correcta';
            answersList.add(answersOp6);

            FieloELR__AnswerOption__c answersOp7 = new FieloELR__AnswerOption__c();
            answersOp7.FieloELR__Question__c = questions.get(6).Id;
            answersOp7.FieloELR__IsCorrect__c = true;
            answersOp7.FieloELR__AnswerOptionText__c = 'Esta es correcta';
            answersList.add(answersOp7);

            FieloELR__AnswerOption__c answersOp8 = new FieloELR__AnswerOption__c();
            answersOp8.FieloELR__Question__c = questions.get(7).Id;
            answersOp8.FieloELR__IsCorrect__c = true;
            answersOp8.FieloELR__AnswerOptionText__c = 'Esta es correcta';
            answersList.add(answersOp8);

            FieloELR__AnswerOption__c answersOp9 = new FieloELR__AnswerOption__c();
            answersOp9.FieloELR__Question__c = questions.get(8).Id;
            answersOp9.FieloELR__IsCorrect__c = true;
            answersOp9.FieloELR__AnswerOptionText__c = 'Esta es correcta';
            answersList.add(answersOp9);
            insert answersList;


            //Set Module Active
            modules.get(0).FieloELR__IsActive__c = true;
            modules.get(1).FieloELR__IsActive__c = true;
            modules.get(3).FieloELR__IsActive__c = true;
            modules.get(4).FieloELR__IsActive__c = true;
            modules.get(5).FieloELR__IsActive__c = true;
            modules.get(6).FieloELR__IsActive__c = true;
            modules.get(7).FieloELR__IsActive__c = true;
            modules.get(8).FieloELR__IsActive__c = true;
            update modules;

            //Set Course Active
            courses.get(0).FieloELR__Status__c = 'Active';
            courses.get(1).FieloELR__Status__c = 'Active';
            courses.get(2).FieloELR__Status__c = 'Active';
            courses.get(3).FieloELR__Status__c = 'Active';
            courses.get(4).FieloELR__Status__c = 'Active';
            courses.get(5).FieloELR__Status__c = 'Active';
            courses.get(6).FieloELR__Status__c = 'Active';
            courses.get(7).FieloELR__Status__c = 'Active';
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
            courseStatusTest3.FieloELR__Member__c = members.get(1).id;
            courseStatus.add(courseStatusTest3);

            FieloELR__CourseStatus__c courseStatusTest4 = new FieloELR__CourseStatus__c();
            courseStatusTest4.FieloELR__Member__c = members.get(2).id;
            courseStatusTest4.FieloELR__Course__c = courses.get(4).id;
            courseStatus.add(courseStatusTest4);

            FieloELR__CourseStatus__c courseStatusTest5 = new FieloELR__CourseStatus__c();
            courseStatusTest5.FieloELR__Member__c = members.get(3).id;
            courseStatusTest5.FieloELR__Course__c = courses.get(5).id;
            courseStatus.add(courseStatusTest5);

            FieloELR__CourseStatus__c courseStatusTest6 = new FieloELR__CourseStatus__c();
            courseStatusTest6.FieloELR__Member__c = members.get(4).id;
            courseStatusTest6.FieloELR__Course__c = courses.get(6).id;
            courseStatus.add(courseStatusTest6);

            FieloELR__CourseStatus__c courseStatusTest7 = new FieloELR__CourseStatus__c();
            courseStatusTest7.FieloELR__Member__c = members.get(5).id;
            courseStatusTest7.FieloELR__Course__c = courses.get(7).id;
            courseStatus.add(courseStatusTest7);
            insert courseStatus;

            courses.get(4).FieloELR__SubscriptionMode__c = 'Automatic';
            update courses.get(4);

            courses.get(5).FieloELR__SubscriptionMode__c = 'Automatic';
            update courses.get(5);

            //Module Response
            FieloELR__ModuleResponse__c moduleResponseTest = new FieloELR__ModuleResponse__c();
            moduleResponseTest.FieloELR__Module__c = modules.get(0).id;
            moduleResponseTest.FieloELR__Member__c = members.get(0).id;
            moduleRespList.add(moduleResponseTest);

            FieloELR__ModuleResponse__c moduleResponseTest2 = new FieloELR__ModuleResponse__c();
            moduleResponseTest2.FieloELR__Module__c = modules.get(1).id;
            moduleResponseTest2.FieloELR__Member__c = members.get(1).id;
            moduleRespList.add(moduleResponseTest2);

            FieloELR__ModuleResponse__c moduleResponseTest3 = new FieloELR__ModuleResponse__c();
            moduleResponseTest3.FieloELR__Module__c = modules.get(6).id;
            moduleResponseTest3.FieloELR__Member__c = members.get(1).id;
            moduleRespList.add(moduleResponseTest3);

            FieloELR__ModuleResponse__c moduleResponseTest4 = new FieloELR__ModuleResponse__c();
            moduleResponseTest4.FieloELR__Module__c = modules.get(8).id;
            moduleResponseTest4.FieloELR__Member__c = members.get(5).id;
            moduleResponseTest4.FieloELR__IsApproved__c = false;
            moduleRespList.add(moduleResponseTest4);
            insert moduleRespList;

            moduleRespList.get(0).FieloELR__IsSubmitted__c = true;
            moduleRespList.get(1).FieloELR__IsSubmitted__c = true;
            moduleRespList.get(3).FieloELR__IsSubmitted__c = true;
            update moduleRespList.get(0);
            update moduleRespList.get(1);
            update moduleRespList.get(3);

            //Question Response
            FieloELR__QuestionResponse__c questionResponseTest = new FieloELR__QuestionResponse__c();
            questionResponseTest.FieloELR__Question__c = questions.get(1).id;
            questionResponseTest.FieloELR__ModuleResponse__c = moduleRespList.get(1).id;
            questionResponses.add(questionResponseTest);
            insert questionResponses;
            
            //Answer
            FieloELR__Answer__c answer = new FieloELR__Answer__c();
            answer.FieloELR__AnswerOption__c = answersList.get(1).id;
            answer.FieloELR__QuestionResponse__c = questionResponses.get(0).id;
            answer.FieloELR__TextValue__c = 'Esta es correcta';
            insert answer;

            questionResponses.get(0).FieloELR__IsSubmitted__c = true;
            update questionResponses.get(0);
	     }

      @isTest static void ELR_0007_FB() { 
            moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule1'].id,
                  FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 0'].id,
                  FieloELR__Date__c = Date.today())};

            insert moduleRespList;

            moduleRespList = [SELECT FieloELR__NumberOfAttempt__c,FieloELR__CourseStatus__c FROM FieloELR__ModuleResponse__c];

            System.assert(moduleRespList.get(0).FieloELR__NumberOfAttempt__c != 0);
            System.assert(moduleRespList.get(0).FieloELR__CourseStatus__c != null);
      }


      @isTest static void ELR_0007_FA1(){
            moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 0'].id,
            FieloELR__IsApproved__c = true, FieloELR__Date__c = Date.today())};

            try{
                  insert moduleRespList;
            }catch(System.Dmlexception e){
                  System.assert(e.getMessage() != null);
            }
      }


      @isTest static void ELR_0007_FA2(){
            moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 1'].id,
            FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule3'].id,
            FieloELR__Date__c = Date.today())};

            try{
            insert moduleRespList;
        }catch(System.Dmlexception e){
            System.assert(e.getMessage().Contains('The related module must be active'));
        }
      }


      @isTest static void ELR_0007_FA3(){
            moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule2'].id,
            FieloELR__Date__c = Date.today())};

            try{
                  insert moduleRespList;
            }catch(System.Dmlexception e){
                  System.assert(e.getMessage() != null);
            }
      }


      @isTest static void ELR_0007_FA4(){
            moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 1'].id,
            FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule2'].id,FieloELR__Date__c = Date.today(),FieloELR__IsApproved__c = true)};

            try{
                  insert moduleRespList;
            }catch(System.Dmlexception e){
                  System.assert(e.getMessage().Contains(' The member didn\'t approve the dependent Modules'));
            }
      }


      @isTest static void ELR_0007_FA8() {   
        moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule1'].id,
            FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 0'].id,
            FieloELR__Date__c = Date.today().addDays(-50))};

        try{
            insert moduleRespList;
        }catch(System.Dmlexception e){
            System.assert(e.getMessage().Contains('The course is not available in this period.'));
        }

        moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule1'].id,
            FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 0'].id,
            FieloELR__Date__c = Date.today().addDays(50))};

        try{
            insert moduleRespList;
        }catch(System.Dmlexception e){
            System.assert(e.getMessage().Contains('The course is not available in this period.'));
        }
      }

      @isTest static void ELR_0007_FA10(){
            moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule4'].id,
            FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 1'].id)};
            insert moduleRespList;

            moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule4'].id,
            FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 1'].id)};
            

            try{
                insert moduleRespList;
            }catch(System.Dmlexception e){
                System.assert(e.getMessage().Contains(' You have reached the limit of attempts for this module.'));
            }
      }

      @isTest static void ELR_0007_FA11(){
            moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule5'].id,
            FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 2'].id)};
            

            try{
              insert moduleRespList;
            }catch(System.Dmlexception e){
                System.assert(e.getMessage().Contains(' The member is not registered in the related course.'));
            }     
      }

      @isTest static void ELR_0007_FA12(){
        moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule6'].id,
        FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 2'].id)};
        
        insert moduleRespList; 

        moduleRespList = [SELECT FieloELR__NumberOfAttempt__c,FieloELR__CourseStatus__c FROM FieloELR__ModuleResponse__c];

        System.assert(moduleRespList.get(0).FieloELR__NumberOfAttempt__c != 0);
        System.assert(moduleRespList.get(0).FieloELR__CourseStatus__c != null);
      }

      @isTest static void ELR_0007_FA13(){
        moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule7'].id,
        FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 2'].id)};
        
        insert moduleRespList; 

        moduleRespList = [SELECT FieloELR__NumberOfAttempt__c,FieloELR__CourseStatus__c FROM FieloELR__ModuleResponse__c];
        System.assert(moduleRespList.get(0).FieloELR__NumberOfAttempt__c != 0);
        System.assert(moduleRespList.get(0).FieloELR__CourseStatus__c != null);
      }

      @isTest static void ELR_0007_FA14(){
        moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule6'].id,
        FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 2'].id, FieloELR__IsApproved__c = true)};
        
        insert moduleRespList; 

        moduleRespList = [SELECT FieloELR__NumberOfAttempt__c,FieloELR__CourseStatus__c,FieloELR__IsApproved__c FROM FieloELR__ModuleResponse__c WHERE Id =: moduleRespList.get(0).id];

        System.assert(moduleRespList.get(0).FieloELR__NumberOfAttempt__c != 0);
        System.assert(moduleRespList.get(0).FieloELR__CourseStatus__c != null);
        System.assertEquals(false ,moduleRespList.get(0).FieloELR__IsApproved__c);
      }

      @isTest static void ELR_0007_FA15(){
        moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__IsSubmitted__c = false AND FieloELR__Module__r.Name = 'testModule7' LIMIT 1];
        
        delete moduleRespList;

         moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__IsSubmitted__c = false AND FieloELR__Module__r.Name = 'testModule7' LIMIT 1];

            System.assertEquals(0, moduleRespList.size());
      }

      @isTest static void ELR_0007_FA16(){
        moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__IsSubmitted__c = true AND FieloELR__Module__r.Name = 'testModule1' LIMIT 1];
        
        delete moduleRespList;

         moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__IsSubmitted__c = true AND FieloELR__Module__r.Name = 'testModule1' LIMIT 1];

            System.assertEquals(0, moduleRespList.size());
      }

      @isTest static void ELR_0007_FA17(){
        moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__IsSubmitted__c = false AND FieloELR__Module__r.Name = 'testModule7' LIMIT 1];

        moduleRespList.get(0).FieloELR__CourseStatus__c = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.FieloELR__Status__c = 'Active' LIMIT 1].id;

            try{
                  update moduleRespList;
            }catch(System.Dmlexception e){
                  System.assert(e.getMessage().Contains('Course Status can\'t be modified.'));
            }
      }

      @isTest static void ELR_0007_FA21(){
            moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__IsSubmitted__c = true LIMIT 1];
            moduleRespList.get(0).FieloELR__GradeValue__c = 1;

            try{
                  update moduleRespList;
            }catch(System.Dmlexception e){
                  System.assert(e.getMessage().Contains(' Cannot modify a moduleResponse that was already submitted.'));
            }
      }

      @isTest static void ELR_0007_FA5(){
            moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule8'].id,
            FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 3'].id)};
            try{
                  insert moduleRespList;
            }catch(System.Dmlexception e){
                  System.assert(e.getMessage().Contains(' The member is not registered in the related course.'));
            }
      }

      /*@isTest static void ELR_0007_FA6(){
            moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule9'].id,
            FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 5'].id)};

            insert moduleRespList;
      }*/


      /*@isTest static void ELR_0007_FA7(){
            //The member must not be approved in the predecessors modules
            moduleRespList = new List<FieloELR__ModuleResponse__c>{new FieloELR__ModuleResponse__c(FieloELR__Module__c = [SELECT Id FROM FieloELR__Module__c WHERE Name = 'testModule9'].id,
            FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 5'].id, FieloELR__IsApproved__c = false,FieloELR__IsSubmitted__c = true)};

            insert moduleRespList;

            System.debug(moduleRespList.get(0).FieloELR__IsApproved__c);
      }*/
}