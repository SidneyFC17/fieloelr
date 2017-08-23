@isTest
private class TestCreateCourseStatus{

	private static List<FieloPLT__Program__c> listProg;
	private static List<FieloPLT__Segment__c> listSeg;
	private static List<FieloELR__Course__c> listCourse;
	private static List<FieloPLT__Member__c> listMemb;
	private static List<FieloPLT__Promotion__c> listProm;
	private static List<FieloPLT__Rule__c> listRule;
	private static List<FieloPLT__CriterionGroup__c> listCGroup;
	private static List<FieloPLT__Criterion__c> listCriterion;
	private static List<FieloELR__CourseStatus__c> listCourseStatus = new List<FieloELR__CourseStatus__c>();
	private static List<FieloELR__CourseDependency__c> listCourseDepen = new List<FieloELR__CourseDependency__c>();
	private static List<FieloELR__Module__c> listMod = new List<FieloELR__Module__c>();
	private static List<FieloELR__Question__c> listQuest = new List<FieloELR__Question__c>();
	private static List<FieloELR__AnswerOption__c> listAnsOpt = new List<FieloELR__AnswerOption__c>();
	private static List<FieloELR__ModuleResponse__c> listModResp = new List<FieloELR__ModuleResponse__c>();

	private static FieloELR__CourseStatus__c courseStatus = new FieloELR__CourseStatus__c();

	@testSetup
	static void setup(){

		//////PROGRAMS
		listProg = MockUpFactory.createPrograms('program', 5);
		insert listProg;

		//////SEGMENTS
		listSeg = MockUpFactory.createSegments('segment', 5, 'Dynamic');
		listSeg.get(0).FieloPLT__Program__c = listProg.get(0).Id;
		listSeg.get(1).FieloPLT__Program__c = listProg.get(1).Id;
		listSeg.get(2).FieloPLT__Program__c = listProg.get(2).Id;
		listSeg.get(2).FieloPLT__LogicalExpression__c = 'ALL';
		listSeg.get(3).FieloPLT__Program__c = listProg.get(3).Id;
		listSeg.get(4).FieloPLT__Program__c = listProg.get(4).Id;

		insert listSeg;

		///////COURSES
		listCourse = MockUpFactory.createCourses(listProg.get(0).Id, listSeg.get(0).Id, 7);
		listCourse.get(2).FieloELR__SubscriptionMode__c = 'Automatic';
		listCourse.get(3).FieloELR__Program__c = listProg.get(2).Id;
		listCourse.get(3).FieloELR__Segment__c = listSeg.get(2).Id;
		listCourse.get(4).FieloELR__Program__c = listProg.get(3).Id;
		listCourse.get(4).FieloELR__Segment__c = listSeg.get(3).Id;
		listCourse.get(5).FieloELR__Program__c = listProg.get(3).Id;
		listCourse.get(5).FieloELR__Segment__c = listSeg.get(3).Id;
		listCourse.get(6).FieloELR__Program__c = listProg.get(4).Id;
		listCourse.get(6).FieloELR__Segment__c = listSeg.get(4).Id;

		insert listCourse;

		//////MEMBERS
		listMemb = MockUpFactory.createMembers(listProg.get(0).Id, 6);
		listMemb.get(1).FieloPLT__Program__c = listProg.get(1).Id;
		listMemb.get(2).FieloPLT__Program__c = listProg.get(2).Id;
		listMemb.get(2).FieloPLT__Points__c = 10;
		listMemb.get(3).FieloPLT__Program__c = listProg.get(3).Id;
		listMemb.get(4).FieloPLT__Program__c = listProg.get(4).Id;
		listMemb.get(5).FieloPLT__Program__c = listProg.get(3).Id;

		insert listMemb;

		//////MODULES
		FieloELR__Module__c module1 = new FieloELR__Module__c();
		module1.Name = 'module1';
		module1.FieloELR__Course__c = listCourse.get(0).Id;
		module1.FieloELR__ApprovalGrade__c = 0;
		listMod.add(module1);

		FieloELR__Module__c module2 = new FieloELR__Module__c();
		module2.Name = 'module2';
		module2.FieloELR__Course__c = listCourse.get(2).Id;
		module2.FieloELR__ApprovalGrade__c = 0;
		listMod.add(module2);

		FieloELR__Module__c module3 = new FieloELR__Module__c();
		module3.Name = 'module3';
		module3.FieloELR__Course__c = listCourse.get(3).Id;
		module3.FieloELR__ApprovalGrade__c = 0;
		listMod.add(module3);

		FieloELR__Module__c module4 = new FieloELR__Module__c();
		module4.Name = 'module4';
		module4.FieloELR__Course__c = listCourse.get(4).Id;
		module4.FieloELR__ApprovalGrade__c = 0;
		listMod.add(module4);

		FieloELR__Module__c module5 = new FieloELR__Module__c();
		module5.Name = 'module5';
		module5.FieloELR__Course__c = listCourse.get(5).Id;
		module5.FieloELR__ApprovalGrade__c = 0;
		listMod.add(module5);

		FieloELR__Module__c module6 = new FieloELR__Module__c();
		module6.Name = 'module6';
		module6.FieloELR__Course__c = listCourse.get(6).Id;
		module6.FieloELR__ApprovalGrade__c = 0;
		listMod.add(module6);

		insert listMod;

		/////QUESTIONS
		FieloELR__Question__c question1 = new FieloELR__Question__c();
		question1.Name = 'question1';
		question1.FieloELR__Module__c = module1.Id;
		question1.FieloELR__QuestionText__c = 'How are you?';
		question1.FieloELR__Type__c = 'Short Answer';
		listQuest.add(question1);

		FieloELR__Question__c question2 = new FieloELR__Question__c();
		question2.Name = 'question2';
		question2.FieloELR__Module__c = module2.Id;
		question2.FieloELR__QuestionText__c = 'How are you?';
		question2.FieloELR__Type__c = 'Short Answer';
		listQuest.add(question2);

		FieloELR__Question__c question3 = new FieloELR__Question__c();
		question3.Name = 'question3';
		question3.FieloELR__Module__c = module3.Id;
		question3.FieloELR__QuestionText__c = 'How are you?';
		question3.FieloELR__Type__c = 'Short Answer';
		listQuest.add(question3);

		FieloELR__Question__c question4 = new FieloELR__Question__c();
		question4.Name = 'question4';
		question4.FieloELR__Module__c = module4.Id;
		question4.FieloELR__QuestionText__c = 'How are you?';
		question4.FieloELR__Type__c = 'Short Answer';
		listQuest.add(question4);

		FieloELR__Question__c question5 = new FieloELR__Question__c();
		question5.Name = 'question5';
		question5.FieloELR__Module__c = module5.Id;
		question5.FieloELR__QuestionText__c = 'How are you?';
		question5.FieloELR__Type__c = 'Short Answer';
		listQuest.add(question5);

		FieloELR__Question__c question6 = new FieloELR__Question__c();
		question6.Name = 'question6';
		question6.FieloELR__Module__c = module6.Id;
		question6.FieloELR__QuestionText__c = 'How are you?';
		question6.FieloELR__Type__c = 'Short Answer';
		listQuest.add(question6);

		insert listQuest;

		//////ANSWERS
		FieloELR__AnswerOption__c answers1 = new FieloELR__AnswerOption__c();
		answers1.FieloELR__Question__c = question1.Id;
		answers1.FieloELR__IsCorrect__c = true;
		answers1.FieloELR__AnswerOptionText__c = 'Esta es correcta';
		listAnsOpt.add(answers1);

		FieloELR__AnswerOption__c answers2 = new FieloELR__AnswerOption__c();
		answers2.FieloELR__Question__c = question2.Id;
		answers2.FieloELR__IsCorrect__c = true;
		answers2.FieloELR__AnswerOptionText__c = 'Esta es correcta';
		listAnsOpt.add(answers2);

		FieloELR__AnswerOption__c answers3 = new FieloELR__AnswerOption__c();
		answers3.FieloELR__Question__c = question3.Id;
		answers3.FieloELR__IsCorrect__c = true;
		answers3.FieloELR__AnswerOptionText__c = 'Esta es correcta';
		listAnsOpt.add(answers3);

		FieloELR__AnswerOption__c answers4 = new FieloELR__AnswerOption__c();
		answers4.FieloELR__Question__c = question4.Id;
		answers4.FieloELR__IsCorrect__c = true;
		answers4.FieloELR__AnswerOptionText__c = 'Esta es correcta';
		listAnsOpt.add(answers4);

		FieloELR__AnswerOption__c answers5 = new FieloELR__AnswerOption__c();
		answers5.FieloELR__Question__c = question5.Id;
		answers5.FieloELR__IsCorrect__c = true;
		answers5.FieloELR__AnswerOptionText__c = 'Esta es correcta';
		listAnsOpt.add(answers5);

		FieloELR__AnswerOption__c answers6 = new FieloELR__AnswerOption__c();
		answers6.FieloELR__Question__c = question6.Id;
		answers6.FieloELR__IsCorrect__c = true;
		answers6.FieloELR__AnswerOptionText__c = 'Esta es correcta';
		listAnsOpt.add(answers6);

		insert listAnsOpt;

		//////PROMOTIONS
		listProm = MockUpFactory.createPromotions('promotion', 1, listProg.get(0).Id);

		//insert listProm;

		//////RULES
		listRule = MockUpFactory.createRules('rule', 1, listProm.get(0).Id);

		//insert listRule;

		//////CRITERION GROUP
		listCGroup = MockUpFactory.createRulesCriteriaGroup(listRule.get(0).Id, 1);

		//insert listCGroup;

		//////CRITERION
		listCriterion = MockUpFactory.createCriteria(listCGroup.get(0).Id, 1);
		listCriterion.get(0).FieloPLT__Segment__c = listSeg.get(0).Id;
		listCriterion.get(0).FieloPLT__FieldName__c = 'FieloPLT__Points__c';
		listCriterion.get(0).FieloPLT__Operator__c = 'greater than';		
		listCriterion.get(0).FieloPLT__NumberValue__c = 100;
		listCriterion.get(0).FieloPLT__FieldType__c = 'Number';
		listCriterion.get(0).FieloPLT__Order__c = 1;

		insert listCriterion;

		///////COURSES DEPENDENCIES
		FieloELR__CourseDependency__c cDepen = new FieloELR__CourseDependency__c();
		cDepen.FieloELR__Predecessor__c = listCourse.get(4).Id;
		cDepen.FieloELR__Course__c = listCourse.get(5).Id;
		listCourseDepen.add(cDepen);

		insert listCourseDepen;


		//////MODULES UPDATE
		module1.FieloELR__IsActive__c = true;
		module2.FieloELR__IsActive__c = true;
		module3.FieloELR__IsActive__c = true;
		module4.FieloELR__IsActive__c = true;
		module5.FieloELR__IsActive__c = true;
		module6.FieloELR__IsActive__c = true;
		update listMod;

		//////COURSES UPDATE
		listCourse.get(0).FieloELR__Status__c = 'Active';
		listCourse.get(2).FieloELR__Status__c = 'Active';
		listCourse.get(3).FieloELR__Status__c = 'Active';
		listCourse.get(4).FieloELR__Status__c = 'Active';
		listCourse.get(5).FieloELR__Status__c = 'Active';
		listCourse.get(6).FieloELR__Status__c = 'Active';
		update listCourse;


		//////COURSES STATUS
		FieloELR__CourseStatus__c cStatus1 = new FieloELR__CourseStatus__c();
		cStatus1.FieloELR__Member__c = listMemb.get(3).Id;
		cStatus1.FieloELR__Course__c = listCourse.get(4).Id;
		listCourseStatus.add(cStatus1);

		FieloELR__CourseStatus__c cStatus2 = new FieloELR__CourseStatus__c();
		cStatus2.FieloELR__Member__c = listMemb.get(4).Id;
		cStatus2.FieloELR__Course__c = listCourse.get(6).Id;
		listCourseStatus.add(cStatus2);

		insert listCourseStatus;

		//////MODULE RESPONSES
		FieloELR__ModuleResponse__c modResp1 = new FieloELR__ModuleResponse__c();
		modResp1.FieloELR__CourseStatus__c = listCourseStatus.get(0).Id;
		modResp1.FieloELR__Module__c = listMod.get(3).Id;
		modResp1.FieloELR__Member__c = listMemb.get(3).Id;
		listModResp.add(modResp1);

		insert listModResp;
	}

    /*@isTest
    static void ELR_0013_FB(){

		courseStatus.FieloELR__Course__c = [SELECT Id FROM FieloELR__Course__c WHERE Name = 'Course 0' LIMIT 1].Id;
		courseStatus.FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 0' LIMIT 1].Id;

		insert courseStatus;

		courseStatus = [SELECT FieloELR__ApprovedModules__c FROM FieloELR__CourseStatus__c LIMIT 1];

		System.assertEquals(0, courseStatus.FieloELR__ApprovedModules__c);
    }

    @isTest
    static void ELR_0013_FA2(){
    	
    	courseStatus.FieloELR__Course__c = [SELECT Id FROM FieloELR__Course__c WHERE Name = 'Course 1' LIMIT 1].Id;
    	courseStatus.FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 0' LIMIT 1].Id;

    	try{
    		insert courseStatus;
    	}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('Course Status must be related to a Course with the Status Active'));
		}
    }

    @isTest
    static void ELR_0013_FA3(){

    	courseStatus.FieloELR__Course__c = [SELECT Id FROM FieloELR__Course__c WHERE Name = 'Course 2' LIMIT 1].Id;
    	courseStatus.FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 0' LIMIT 1].Id;

    	try{
    		insert courseStatus;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('The course status cannot be created if the subscription mode of the course is ""Automatic""'));
		}
    }

    @isTest
    static void ELR_0013_FA4(){

    	courseStatus.FieloELR__Course__c = [SELECT Id FROM FieloELR__Course__c WHERE Name = 'Course 0' LIMIT 1].Id;

    	try{
    		insert courseStatus;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('Attempt to de-reference a null object'));
		}
    }

    @isTest
    static void ELR_0013_FA6(){

    	courseStatus.FieloELR__Course__c = [SELECT Id FROM FieloELR__Course__c WHERE Name = 'Course 3' LIMIT 1].Id;
    	courseStatus.FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 2' LIMIT 1].Id;

    	try{
    		insert courseStatus;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('The member does not apply to the course\'s segment'));
		}
    }

    @isTest
    static void ELR_0013_FA7(){

    	courseStatus.FieloELR__Course__c = [SELECT Id FROM FieloELR__Course__c WHERE Name = 'Course 0' LIMIT 1].Id;
    	courseStatus.FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 1' LIMIT 1].Id;

    	try{
    		insert courseStatus;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('The member should belong to the course\'s program'));
		}
    }

    @isTest
    static void ELR_0013_FA8(){
    	
    	courseStatus.FieloELR__Course__c = [SELECT Id FROM FieloELR__Course__c WHERE Name = 'Course 5' LIMIT 1].Id;
    	courseStatus.FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 3' LIMIT 1].Id;

    	try{
    		insert courseStatus;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('Course Predecessor was not completed at 100 per cent'));
		}
    }

    @isTest
    static void ELR_0013_FA9(){

    	courseStatus.FieloELR__Course__c = [SELECT Id FROM FieloELR__Course__c WHERE Name = 'Course 6' LIMIT 1].Id;
    	courseStatus.FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 4' LIMIT 1].Id;

    	try{
    		insert courseStatus;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('This course status already exists'));
		}
    }

    @isTest
    static void ELR_0013_FA10(){

    	courseStatus = [SELECT Id FROM FieloELR__CourseStatus__c LIMIT 1];

    	delete courseStatus;

    	listCourseStatus = [SELECT Id FROM FieloELR__CourseStatus__c WHERE Id = :courseStatus.Id LIMIT 1];

    	System.assertEquals(0, listCourseStatus.size());
    }

    @isTest
    static void ELR_0013_FA11(){

    	courseStatus = [SELECT Id, FieloELR__Member__c, FieloELR__Course__c FROM FieloELR__CourseStatus__c LIMIT 1];
    	courseStatus.FieloELR__Course__c = [SELECT Id FROM FieloELR__Course__c WHERE Name = 'Course 0' LIMIT 1].Id;
		courseStatus.FieloELR__Member__c = [SELECT Id FROM FieloPLT__Member__c WHERE Name = 'Member 0' LIMIT 1].Id;

		update courseStatus;
    }*/
}