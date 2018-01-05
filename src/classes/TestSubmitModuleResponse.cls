@isTest
private class TestSubmitModuleResponse {
    private static List<FieloELR__QuestionResponse__c> questionResponses = new List<FieloELR__QuestionResponse__c>();
    private static List<FieloELR__ModuleResponse__c> moduleResponses = new List<FieloELR__ModuleResponse__c>();
    private static List<FieloELR__Question__c> questions = new List<FieloELR__Question__c>();
    private static List<FieloELR__CourseStatus__c> courseStatus = new List<FieloELR__CourseStatus__c>();

	@testSetup static void setup(){
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
	
	@isTest static void ELR_0010_FB() {
		moduleResponses = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule1' LIMIT 1];
		questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleResponses.get(0).id LIMIT 1];
		courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 1'];

		moduleResponses.get(0).FieloELR__IsSubmitted__c = true;

		update moduleResponses;

		questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c, FieloELR__IsCorrect__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
		moduleResponses = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__TotalValue__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
		courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            System.assertEquals(true, questionResponses.get(0).FieloELR__IsSubmitted__c);
		System.assertEquals(true, questionResponses.get(0).FieloELR__IsCorrect__c);
		System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c != null);
		
            System.assert(moduleResponses.get(0).FieloELR__GradeValue__c >= questionResponses.get(0).FieloELR__PartialGradeValue__c);
		System.assert(moduleResponses.get(0).FieloELR__GradePercent__c == moduleResponses.get(0).FieloELR__GradeValue__c / moduleResponses.get(0).FieloELR__Module__r.FieloELR__TotalValue__c);
            System.assertEquals(true, moduleResponses.get(0).FieloELR__IsApproved__c);
		System.assert(moduleResponses.get(0).FieloELR__NumberofApprove__c > 0);
		
            System.assert(courseStatus.get(0).FieloELR__ApprovedModules__c > 0);
		System.assert(courseStatus.get(0).FieloELR__Progress__c != 0);     
      }


      @isTest static void ELR_0010_FA1(){
            moduleResponses = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule1' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleResponses.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            moduleResponses.get(0).FieloELR__IsSubmitted__c = true;
            update moduleResponses;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleResponses = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__TotalValue__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];
            
            System.assert(moduleResponses.get(0).FieloELR__GradeValue__c >= questionResponses.get(0).FieloELR__PartialGradeValue__c);
            System.assert(moduleResponses.get(0).FieloELR__GradePercent__c == moduleResponses.get(0).FieloELR__GradeValue__c / moduleResponses.get(0).FieloELR__Module__r.FieloELR__TotalValue__c);
            System.assertEquals(true, moduleResponses.get(0).FieloELR__IsApproved__c);
            
            System.assert(courseStatus.get(0).FieloELR__ApprovedModules__c > 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c != 0);
      }


      @isTest static void ELR_0010_FA2(){
            moduleResponses = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule2' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleResponses.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            moduleResponses.get(0).FieloELR__IsSubmitted__c = true;
            update moduleResponses;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleResponses = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__TotalValue__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            System.debug(moduleResponses.get(0).FieloELR__IsApproved__c);

            System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c != null);
            System.assertEquals(false, moduleResponses.get(0).FieloELR__IsApproved__c);
            System.assert(moduleResponses.get(0).FieloELR__NumberofApprove__c == 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c == 0);
      }


      @isTest static void ELR_0010_FA3(){
            moduleResponses = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule1' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleResponses.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 1'];

            moduleResponses.get(0).FieloELR__IsSubmitted__c = true;

            update moduleResponses;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleResponses = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__QuestionPool__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            System.assertEquals(true, questionResponses.get(0).FieloELR__IsSubmitted__c);
            System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c != null);
            
            System.assert(moduleResponses.get(0).FieloELR__GradeValue__c >= questionResponses.get(0).FieloELR__PartialGradeValue__c);
            System.assert(moduleResponses.get(0).FieloELR__GradePercent__c == moduleResponses.get(0).FieloELR__GradeValue__c / moduleResponses.get(0).FieloELR__Module__r.FieloELR__QuestionPool__c);
            System.assertEquals(true, moduleResponses.get(0).FieloELR__IsApproved__c);
            System.assert(moduleResponses.get(0).FieloELR__NumberofApprove__c > 0);
            
            System.assert(courseStatus.get(0).FieloELR__ApprovedModules__c > 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c != 0);     
      }


      @isTest static void ELR_0010_FA4(){
            moduleResponses = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule3' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleResponses.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            moduleResponses.get(0).FieloELR__IsSubmitted__c = true;
            update moduleResponses;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleResponses = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__TotalValue__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c != null);
            System.assertEquals(false, moduleResponses.get(0).FieloELR__IsApproved__c);
            System.assert(moduleResponses.get(0).FieloELR__NumberofApprove__c == 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c == 0); 
      }


      @isTest static void ELR_0010_FA5(){
            moduleResponses = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule2' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleResponses.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 1'];

            moduleResponses.get(0).FieloELR__IsSubmitted__c = true;
            update moduleResponses;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleResponses = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__TotalValue__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 1'];

            System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c != null);
            System.assertEquals(false, moduleResponses.get(0).FieloELR__IsApproved__c);
            System.assert(moduleResponses.get(0).FieloELR__NumberofApprove__c == 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c == 0); 
            
            System.assert(moduleResponses.get(0).FieloELR__NumberofApprove__c == 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c == 0);   
      }


      @isTest static void ELR_0010_FA6(){
            moduleResponses = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule1' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleResponses.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            moduleResponses.get(0).FieloELR__IsSubmitted__c = true;
            update moduleResponses;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleResponses = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__QuestionPool__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c,FieloELR__Course__r.FieloELR__ActiveModules__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];
            
            System.assert(moduleResponses.get(0).FieloELR__GradeValue__c >= questionResponses.get(0).FieloELR__PartialGradeValue__c);
            System.assert(moduleResponses.get(0).FieloELR__GradePercent__c == moduleResponses.get(0).FieloELR__GradeValue__c / moduleResponses.get(0).FieloELR__Module__r.FieloELR__QuestionPool__c);
            System.assert(moduleResponses.get(0).FieloELR__NumberofApprove__c > 0);
            System.assertEquals(true, moduleResponses.get(0).FieloELR__IsApproved__c);
            
            System.assert(courseStatus.get(0).FieloELR__ApprovedModules__c > 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c != 0);
      }


      @isTest static void ELR_0010_FA7(){
            moduleResponses = [SELECT Id FROM FieloELR__ModuleResponse__c WHERE FieloELR__Module__r.Name = 'testModule3' LIMIT 1];
            questionResponses = [SELECT Id FROM FieloELR__QuestionResponse__c WHERE FieloELR__ModuleResponse__r.Id =: moduleResponses.get(0).id LIMIT 1];
            courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            moduleResponses.get(0).FieloELR__IsSubmitted__c = true;
            update moduleResponses;

            questionResponses = [SELECT FieloELR__IsSubmitted__c,FieloELR__PartialGradeValue__c FROM FieloELR__QuestionResponse__c WHERE Id =: questionResponses.get(0).id];
            moduleResponses = [SELECT FieloELR__GradeValue__c,FieloELR__GradePercent__c,FieloELR__Module__r.FieloELR__QuestionPool__c,FieloELR__IsApproved__c,FieloELR__NumberofApprove__c FROM FieloELR__ModuleResponse__c];
            courseStatus = [SELECT FieloELR__ApprovedModules__c,FieloELR__Progress__c FROM FieloELR__CourseStatus__c WHERE FieloELR__Course__r.Name = 'Course 0'];

            System.assert(questionResponses.get(0).FieloELR__PartialGradeValue__c != null);
            System.assertEquals(false, moduleResponses.get(0).FieloELR__IsApproved__c);
            System.assert(moduleResponses.get(0).FieloELR__NumberofApprove__c == 0);
            
            System.assert(courseStatus.get(0).FieloELR__ApprovedModules__c == 0);
            System.assert(courseStatus.get(0).FieloELR__Progress__c == 0); 
      }

}