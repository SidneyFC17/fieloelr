@isTest
private class TestSubmitModuleResponse {
		private static List<FieloELR__ModuleResponse__c> moduleRespList = new List<FieloELR__ModuleResponse__c>();
		private static List<FieloELR__QuestionResponse__c> questionResponses = new List<FieloELR__QuestionResponse__c>();
		private static List<FieloELR__CourseStatus__c> courseStatus = new List<FieloELR__CourseStatus__c>();

	@testSetup
		static void setup(){
            List<FieloELR__Course__c> courses = new List<FieloELR__Course__c>();            
            List<FieloELR__Question__c> questions = new List<FieloELR__Question__c>();
            List<FieloPLT__Member__c> members = new List<FieloPLT__Member__c>();
            List<FieloPLT__Program__c> programs;
            List<FieloPLT__Segment__c> segments;
            List<FieloELR__Module__c> modules = new List<FieloELR__Module__c>();
            List<FieloELR__AnswerOption__c> answersOpList = new List<FieloELR__AnswerOption__c>();            
            List<FieloELR__Answer__c> answersList = new List<FieloELR__Answer__c>();

            programs = MockUpFactory.createPrograms('testProgram', 1);
            insert programs;

            segments = MockUpFactory.createSegments('testSegment',1,'Dynamic');
            insert segments;

            courses = MockUpFactory.createCourses(programs.get(0).id, segments.get(0).id, 2);
            insert courses;

            members = MockUpFactory.createMembers(programs.get(0).id, 1);
            insert members;


            //Module
            FieloELR__Module__c moduleTest1 = new FieloELR__Module__c();
            moduleTest1.Name = 'testModule1';
            moduleTest1.FieloELR__Course__c = courses.get(0).id;
            moduleTest1.FieloELR__ApprovalGrade__c = 0;
            moduleTest1.FieloELR__AttemptsAllowed__c = 2;
            moduleTest1.FieloELR__AttemptsAllowedPerQuestion__c = 2;
            moduleTest1.FieloELR__PenaltyMode__c = 'None';
            moduleTest1.FieloELR__QuestionPool__c = 1;
            modules.add(moduleTest1);

            FieloELR__Module__c moduleTest2 = new FieloELR__Module__c();
            moduleTest2.Name = 'testModule2';
            moduleTest2.FieloELR__Course__c = courses.get(0).id;
            moduleTest2.FieloELR__ApprovalGrade__c = 1;
            moduleTest2.FieloELR__AttemptsAllowed__c = 1;
            moduleTest2.FieloELR__AttemptsAllowedPerQuestion__c = 2;
            modules.add(moduleTest2);
            

            FieloELR__Module__c moduleTest3 = new FieloELR__Module__c();
            moduleTest3.Name = 'testModule3';
            moduleTest3.FieloELR__Course__c = courses.get(1).id;
            moduleTest3.FieloELR__ApprovalGrade__c = 0;
            moduleTest3.FieloELR__AttemptsAllowed__c = 1;
            moduleTest3.FieloELR__AttemptsAllowedPerQuestion__c = 1;
            moduleTest3.FieloELR__PenaltyMode__c = 'None';
            moduleTest3.FieloELR__QuestionPool__c = 1;
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
            questions.add(question2);

            FieloELR__Question__c question3 = new FieloELR__Question__c();
            question3.Name = 'question3';
            question3.FieloELR__Module__c = modules.get(2).Id;
            question3.FieloELR__QuestionText__c = 'How are you?';
            question3.FieloELR__Type__c = 'Short Answer';
            questions.add(question3);
            insert questions;

            //Answer
            FieloELR__AnswerOption__c answersOp1 = new FieloELR__AnswerOption__c();
            answersOp1.FieloELR__Question__c = questions.get(0).Id;
            answersOp1.FieloELR__IsCorrect__c = true;
            answersOp1.FieloELR__AnswerOptionText__c = 'Esta es correcta';
            answersOpList.add(answersOp1);

            FieloELR__AnswerOption__c answersOp2 = new FieloELR__AnswerOption__c();
            answersOp2.FieloELR__Question__c = questions.get(1).Id;
            answersOp2.FieloELR__IsCorrect__c = true;
            answersOp2.FieloELR__AnswerOptionText__c = 'Esta es correcta';
            answersOpList.add(answersOp2);

            FieloELR__AnswerOption__c answersOp3 = new FieloELR__AnswerOption__c();
            answersOp3.FieloELR__Question__c = questions.get(2).Id;
            answersOp3.FieloELR__IsCorrect__c = true;
            answersOp3.FieloELR__AnswerOptionText__c = 'Esta es correcta';
            answersOpList.add(answersOp3);
            insert answersOpList;


            //Set Module Active
            modules.get(0).FieloELR__IsActive__c = true;
            modules.get(1).FieloELR__IsActive__c = true;
            modules.get(2).FieloELR__IsActive__c = true;
            update modules;

            //Set Course Active
            courses.get(0).FieloELR__Status__c = 'Active';
            courses.get(1).FieloELR__Status__c = 'Active';
            update courses;

            //Course Status
            FieloELR__CourseStatus__c courseStatusTest = new FieloELR__CourseStatus__c();
            courseStatusTest.FieloELR__Course__c = courses.get(0).id;
            courseStatusTest.FieloELR__Member__c = members.get(0).id;
            courseStatus.add(courseStatusTest);

            FieloELR__CourseStatus__c courseStatusTest2 = new FieloELR__CourseStatus__c();
            courseStatusTest2.FieloELR__Course__c = courses.get(1).id;
            courseStatusTest2.FieloELR__Member__c = members.get(0).id;
            courseStatus.add(courseStatusTest2);
            insert courseStatus;

            //Module Response
            FieloELR__ModuleResponse__c moduleResponseTest = new FieloELR__ModuleResponse__c();
            moduleResponseTest.FieloELR__Module__c = modules.get(0).id;
            moduleResponseTest.FieloELR__Member__c = members.get(0).id;
            moduleRespList.add(moduleResponseTest);

            FieloELR__ModuleResponse__c moduleResponseTest1 = new FieloELR__ModuleResponse__c();
            moduleResponseTest1.FieloELR__Module__c = modules.get(1).id;
            moduleResponseTest1.FieloELR__Member__c = members.get(0).id;
            moduleRespList.add(moduleResponseTest1);

            FieloELR__ModuleResponse__c moduleResponseTest2 = new FieloELR__ModuleResponse__c();
            moduleResponseTest2.FieloELR__Module__c = modules.get(2).id;
            moduleResponseTest2.FieloELR__Member__c = members.get(0).id;
            moduleRespList.add(moduleResponseTest2);
            insert moduleRespList;

            //Question Response
            FieloELR__QuestionResponse__c questionResponseTest = new FieloELR__QuestionResponse__c();
            questionResponseTest.FieloELR__Question__c = questions.get(0).id;
            questionResponseTest.FieloELR__ModuleResponse__c = moduleRespList.get(0).id;
            questionResponses.add(questionResponseTest);

            FieloELR__QuestionResponse__c questionResponseTest2 = new FieloELR__QuestionResponse__c();
            questionResponseTest2.FieloELR__Question__c = questions.get(1).id;
            questionResponseTest2.FieloELR__ModuleResponse__c = moduleRespList.get(1).id;
            questionResponses.add(questionResponseTest2);

            FieloELR__QuestionResponse__c questionResponseTest3 = new FieloELR__QuestionResponse__c();
            questionResponseTest3.FieloELR__Question__c = questions.get(2).id;
            questionResponseTest3.FieloELR__ModuleResponse__c = moduleRespList.get(2).id;
            questionResponses.add(questionResponseTest3);
            insert questionResponses;
            
            //Answer
            FieloELR__Answer__c answer = new FieloELR__Answer__c();
            answer.FieloELR__AnswerOption__c = answersOpList.get(0).id;
            answer.FieloELR__QuestionResponse__c = questionResponses.get(0).id;
            answer.FieloELR__TextValue__c = 'Esta es correcta';
            answersList.add(answer);
            
            FieloELR__Answer__c answer2 = new FieloELR__Answer__c();
            answer2.FieloELR__AnswerOption__c = answersOpList.get(1).id;
            answer2.FieloELR__QuestionResponse__c = questionResponses.get(1).id;
            answer2.FieloELR__TextValue__c = 'Esta no es correcta';
            answersList.add(answer2);

            FieloELR__Answer__c answer3 = new FieloELR__Answer__c();
            answer3.FieloELR__AnswerOption__c = answersOpList.get(2).id;
            answer3.FieloELR__QuestionResponse__c = questionResponses.get(2).id;
            answer3.FieloELR__TextValue__c = 'Esta no es correcta';
            answersList.add(answer3);
            insert answersList;
	     }
	

	@isTest static void ELR_0010_FB() {
		moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule1' LIMIT 1];
		questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleRespList.get(0).id LIMIT 1];
		courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 1'];

		moduleRespList.get(0).FieloELR__IsSubmitted__c = true;

		update moduleRespList;

		questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
		moduleRespList = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__TotalValue__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
		courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

		System.assertEquals(true, questionResponses.get(0).FieloELR__IsSubmitted__c);
		System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c != null);
		
            System.assert(moduleRespList.get(0).FieloELR__GradeValue__c >= questionResponses.get(0).FieloELR__PartialGradeValue__c);
		System.assert(moduleRespList.get(0).FieloELR__GradePercent__c == moduleRespList.get(0).FieloELR__GradeValue__c / moduleRespList.get(0).FieloELR__Module__r.FieloELR__TotalValue__c);
            System.assertEquals(true, moduleRespList.get(0).FieloELR__IsApproved__c);
		System.assert(moduleRespList.get(0).FieloELR__NumberofApprove__c > 0);
		
            System.assert(courseStatus.get(0).FieloELR__ApprovedModules__c > 0);
		System.assert(courseStatus.get(0).FieloELR__Progress__c != 0);     
      }


      @isTest static void ELR_0010_FA1(){
            moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule1' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleRespList.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            moduleRespList.get(0).FieloELR__IsSubmitted__c = true;
            update moduleRespList;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleRespList = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__TotalValue__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];
            
            System.assert(moduleRespList.get(0).FieloELR__GradeValue__c >= questionResponses.get(0).FieloELR__PartialGradeValue__c);
            System.assert(moduleRespList.get(0).FieloELR__GradePercent__c == moduleRespList.get(0).FieloELR__GradeValue__c / moduleRespList.get(0).FieloELR__Module__r.FieloELR__TotalValue__c);
            System.assertEquals(true, moduleRespList.get(0).FieloELR__IsApproved__c);
            
            System.assert(courseStatus.get(0).FieloELR__ApprovedModules__c > 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c != 0);
      }


      @isTest static void ELR_0010_FA2(){
            moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule2' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleRespList.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            moduleRespList.get(0).FieloELR__IsSubmitted__c = true;
            update moduleRespList;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleRespList = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__TotalValue__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            System.debug(moduleRespList.get(0).FieloELR__IsApproved__c);

            System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c != null);
            System.assertEquals(false, moduleRespList.get(0).FieloELR__IsApproved__c);
            System.assert(moduleRespList.get(0).FieloELR__NumberofApprove__c == 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c == 0);
      }


      @isTest static void ELR_0010_FA3(){
            moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule1' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleRespList.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 1'];

            moduleRespList.get(0).FieloELR__IsSubmitted__c = true;

            update moduleRespList;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleRespList = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__QuestionPool__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            System.assertEquals(true, questionResponses.get(0).FieloELR__IsSubmitted__c);
            System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c != null);
            
            System.assert(moduleRespList.get(0).FieloELR__GradeValue__c >= questionResponses.get(0).FieloELR__PartialGradeValue__c);
            System.assert(moduleRespList.get(0).FieloELR__GradePercent__c == moduleRespList.get(0).FieloELR__GradeValue__c / moduleRespList.get(0).FieloELR__Module__r.FieloELR__QuestionPool__c);
            System.assertEquals(true, moduleRespList.get(0).FieloELR__IsApproved__c);
            System.assert(moduleRespList.get(0).FieloELR__NumberofApprove__c > 0);
            
            System.assert(courseStatus.get(0).FieloELR__ApprovedModules__c > 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c != 0);     
      }


      @isTest static void ELR_0010_FA4(){
            moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule3' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleRespList.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            moduleRespList.get(0).FieloELR__IsSubmitted__c = true;
            update moduleRespList;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleRespList = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__TotalValue__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c != null);
            System.assertEquals(false, moduleRespList.get(0).FieloELR__IsApproved__c);
            System.assert(moduleRespList.get(0).FieloELR__NumberofApprove__c == 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c == 0); 
      }


      @isTest static void ELR_0010_FA5(){
            moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule2' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleRespList.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 1'];

            moduleRespList.get(0).FieloELR__IsSubmitted__c = true;
            update moduleRespList;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleRespList = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__TotalValue__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 1'];

            System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c != null);
            System.assertEquals(false, moduleRespList.get(0).FieloELR__IsApproved__c);
            System.assert(moduleRespList.get(0).FieloELR__NumberofApprove__c == 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c == 0); 
            
            System.assert(moduleRespList.get(0).FieloELR__NumberofApprove__c == 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c == 0);   
      }


      @isTest static void ELR_0010_FA6(){
            moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule1' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleRespList.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            moduleRespList.get(0).FieloELR__IsSubmitted__c = true;
            update moduleRespList;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleRespList = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__QuestionPool__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];
            
            System.assert(moduleRespList.get(0).FieloELR__GradeValue__c >= questionResponses.get(0).FieloELR__PartialGradeValue__c);
            System.assert(moduleRespList.get(0).FieloELR__GradePercent__c == moduleRespList.get(0).FieloELR__GradeValue__c / moduleRespList.get(0).FieloELR__Module__r.FieloELR__QuestionPool__c);
            System.assert(moduleRespList.get(0).FieloELR__NumberofApprove__c > 0);
            System.assertEquals(true, moduleRespList.get(0).FieloELR__IsApproved__c);
            
            System.assert(courseStatus.get(0).FieloELR__ApprovedModules__c > 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c != 0);
      }


      @isTest static void ELR_0010_FA7(){
            moduleRespList = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule3' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleRespList.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            moduleRespList.get(0).FieloELR__IsSubmitted__c = true;
            update moduleRespList;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleRespList = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__QuestionPool__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c != null);
            System.assertEquals(false, moduleRespList.get(0).FieloELR__IsApproved__c);
            System.assert(moduleRespList.get(0).FieloELR__NumberofApprove__c == 0);
            
            System.assert(courseStatus.get(0).FieloELR__ApprovedModules__c == 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c == 0); 
      }

}