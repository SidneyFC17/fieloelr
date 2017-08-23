@isTest
private class TestCreateAnswer{
	
	private static List<FieloPLT__Program__c> listProg;
	private static List<FieloPLT__Segment__c> listSeg;
	private static List<FieloELR__Course__c> listCourse;
	private static List<FieloELR__Module__c> listMod = new List<FieloELR__Module__c>();
	private static List<FieloELR__Question__c> listQuest = new List<FieloELR__Question__c>();
	private static List<FieloELR__AnswerOption__c> listAnsOpt = new List<FieloELR__AnswerOption__c>();

	private static FieloELR__AnswerOption__c answers1 = new FieloELR__AnswerOption__c();
	private static FieloELR__AnswerOption__c answers2 = new FieloELR__AnswerOption__c();
	private static FieloELR__AnswerOption__c answers3 = new FieloELR__AnswerOption__c();
	private static FieloELR__AnswerOption__c answers4 = new FieloELR__AnswerOption__c();
	private static FieloELR__AnswerOption__c answers5 = new FieloELR__AnswerOption__c();
	private static FieloELR__AnswerOption__c answers6 = new FieloELR__AnswerOption__c();

	@testSetup
	static void setup(){

		//////PROGRAMS
		listProg = MockUpFactory.createPrograms('program', 1);

		insert listProg;

		//////SEGMENTS
		listSeg = MockUpFactory.createSegments('segment', 1, 'Dynamic');
		listSeg.get(0).FieloPLT__Program__c = listProg.get(0).Id;

		insert listSeg;

		///////COURSES
		listCourse = MockUpFactory.createCourses(listProg.get(0).Id, listSeg.get(0).Id, 1);

		insert listCourse;

		//////MODULES
		FieloELR__Module__c module1 = new FieloELR__Module__c();
		module1.Name = 'module1';
		module1.FieloELR__Course__c = listCourse.get(0).Id;
		module1.FieloELR__ApprovalGrade__c = 0;
		listMod.add(module1);

		FieloELR__Module__c module2 = new FieloELR__Module__c();
		module2.Name = 'module2';
		module2.FieloELR__Course__c = listCourse.get(0).Id;
		module2.FieloELR__ApprovalGrade__c = 0;
		listMod.add(module2);

		insert listMod;

		/////QUESTIONS
		FieloELR__Question__c question1 = new FieloELR__Question__c();
		question1.Name = 'question1';
		question1.FieloELR__Module__c = module1.Id;
		question1.FieloELR__QuestionText__c = 'How are you?';
		question1.FieloELR__Type__c = 'Multiple Choice';
		listQuest.add(question1);

		FieloELR__Question__c question2 = new FieloELR__Question__c();
		question2.Name = 'question2';
		question2.FieloELR__Module__c = module2.Id;
		question2.FieloELR__QuestionText__c = 'How are you?';
		question2.FieloELR__Type__c = 'Short Answer';
		listQuest.add(question2);

		FieloELR__Question__c question3 = new FieloELR__Question__c();
		question3.Name = 'question3';
		question3.FieloELR__Module__c = module1.Id;
		question3.FieloELR__QuestionText__c = 'How are you?';
		question3.FieloELR__Type__c = 'Single Choice';
		listQuest.add(question3);

		FieloELR__Question__c question4 = new FieloELR__Question__c();
		question4.Name = 'question4';
		question4.FieloELR__Module__c = module1.Id;
		question4.FieloELR__QuestionText__c = 'How are you?';
		question4.FieloELR__Type__c = 'Short Answer';
		listQuest.add(question4);

		FieloELR__Question__c question5 = new FieloELR__Question__c();
		question5.Name = 'question5';
		question5.FieloELR__Module__c = module1.Id;
		question5.FieloELR__QuestionText__c = 'How are you?';
		question5.FieloELR__Type__c = 'Statement';
		listQuest.add(question5);

		FieloELR__Question__c question6 = new FieloELR__Question__c();
		question6.Name = 'question6';
		question6.FieloELR__Module__c = module1.Id;
		question6.FieloELR__QuestionText__c = 'How are you?';
		question6.FieloELR__Type__c = 'Matching Options';
		listQuest.add(question6);

		FieloELR__Question__c question7 = new FieloELR__Question__c();
		question7.Name = 'question7';
		question7.FieloELR__Module__c = module1.Id;
		question7.FieloELR__QuestionText__c = 'How are you?';
		question7.FieloELR__Type__c = 'Statement';
		listQuest.add(question7);

		FieloELR__Question__c question8 = new FieloELR__Question__c();
		question8.Name = 'question8';
		question8.FieloELR__Module__c = module1.Id;
		question8.FieloELR__QuestionText__c = 'How are you?';
		question8.FieloELR__Type__c = 'Single Choice';
		listQuest.add(question8);

		FieloELR__Question__c question9 = new FieloELR__Question__c();
		question9.Name = 'question7';
		question9.FieloELR__Module__c = module1.Id;
		question9.FieloELR__QuestionText__c = 'How are you?';
		question9.FieloELR__Type__c = 'Statement';
		listQuest.add(question9);

		insert listQuest;

		//////ANSWERS
		answers1.FieloELR__Question__c = question2.Id;
		answers1.FieloELR__IsCorrect__c = true;
		answers1.FieloELR__AnswerOptionText__c = 'Esta es correcta y activa';
		listAnsOpt.add(answers1);

		answers2.FieloELR__Question__c = question7.Id;
		answers2.FieloELR__AnswerOptionText__c = 'Esta es incorrecta y de Statement';
		listAnsOpt.add(answers2);

		answers3.FieloELR__Question__c = question7.Id;
		answers3.FieloELR__AnswerOptionText__c = 'Esta es la segunda incorrecta y de Statement';
		listAnsOpt.add(answers3);

		answers4.FieloELR__Question__c = question8.Id;
		answers4.FieloELR__IsCorrect__c = true;
		answers4.FieloELR__AnswerOptionText__c = 'Esta es correcta';
		listAnsOpt.add(answers4);

		answers5.FieloELR__Question__c = question9.Id;
		answers5.FieloELR__IsCorrect__c = true;
		answers5.FieloELR__AnswerOptionText__c = 'Esta es correcta y del segundo Statement';
		listAnsOpt.add(answers5);

		answers6.FieloELR__Question__c = question9.Id;
		answers6.FieloELR__AnswerOptionText__c = 'Esta es incorrecta y del segundo Statement';
		listAnsOpt.add(answers6);

		insert listAnsOpt;


		//////MODULE UPDATE
		module2.FieloELR__IsActive__c = true;
		update listMod;
	}

	@isTest
	static void ELR_0006_FB(){

		answers1.FieloELR__AnswerOptionText__c = 'Esta es incorrecta';
		answers1.FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question1' LIMIT 1].Id;
		answers1.FieloELR__Order__c = 1;
		listAnsOpt.add(answers1);

		answers2.FieloELR__AnswerOptionText__c = 'Esta es correcta';
		answers2.FieloELR__Question__c = answers1.FieloELR__Question__c;
		answers2.FieloELR__Order__c = 2;
		answers2.FieloELR__IsCorrect__c = true;
		listAnsOpt.add(answers2);

		insert listAnsOpt;

		listAnsOpt = [SELECT Id FROM FieloELR__AnswerOption__c WHERE Id IN :listAnsOpt LIMIT 2];

		System.assertEquals(2, listAnsOpt.size());
	}

	@isTest
	static void ELR_0006_FA1(){

		answers1.FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question2' LIMIT 1].Id;
		answers1.FieloELR__AnswerOptionText__c = 'Esta es incorrecta';
		answers1.FieloELR__Order__c = 1;
		listAnsOpt.add(answers1);

		try{
    		insert listAnsOpt;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('Active modules cannot have changes in their set of answer options.'));
		}
	}

	@isTest
	static void ELR_0006_FA2(){

		listQuest = [SELECT Id FROM FieloELR__Question__c 
						WHERE Name = 'question1' OR Name = 'question3' OR Name ='question4' OR Name = 'question5' LIMIT 4];

		for(integer i = 0 ; i < 4 ; i++){

			FieloELR__AnswerOption__c answer = new FieloELR__AnswerOption__c();
			answer.FieloELR__Question__c = listQuest.get(i).Id;
			answer.FieloELR__Order__c = i + 1;
			listAnsOpt.add(answer);
		}

		try{
    		insert listAnsOpt;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('The answer option text is required.'));
		}
	}

	@isTest
	static void ELR_0006_FA3(){

		listQuest = [SELECT Id, Name FROM FieloELR__Question__c 
						WHERE Name = 'question1' OR Name = 'question3' OR Name ='question4' OR Name = 'question5' OR Name = 'question6' LIMIT 5];

		for(integer i = 0 ; i < 5 ; i++){

			FieloELR__AnswerOption__c answer = new FieloELR__AnswerOption__c();
			answer.FieloELR__Question__c = listQuest.get(i).Id;
			answer.FieloELR__AnswerOptionText__c = 'Esta respuesta es correcta';

			if(listQuest.get(i).Name == 'question6'){
				answer.FieloELR__MatchingText__c = 'Va con esta respuesta';
			}
			listAnsOpt.add(answer);
		}

		insert listAnsOpt;

		listAnsOpt = [SELECT FieloELR__Order__c FROM FieloELR__AnswerOption__c WHERE Id IN :listAnsOpt LIMIT 5];

		System.assertEquals(5, listAnsOpt.size());
	}

	@isTest
	static void ELR_0006_FA4(){

		answers1.FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question7' LIMIT 1].Id;
		answers1.FieloELR__AnswerOptionText__c = 'Esta respuesta esta de mas';
		answers1.FieloELR__Order__c = 1;
		listAnsOpt.add(answers1);

		try{
    		insert listAnsOpt;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('For &quot;Statement&quot; questions, no more than two answers can be created.'));
		}
	}

	@isTest
	static void ELR_0006_FA5(){

		answers1.FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name ='question3' LIMIT 1].Id;
		answers1.FieloELR__AnswerOptionText__c = 'Esta es correcta';
		answers1.FieloELR__Order__c = 1;
		answers1.FieloELR__IsCorrect__c = true;
		listAnsOpt.add(answers1);

		insert listAnsOpt;

		listAnsOpt = [SELECT Id FROM FieloELR__AnswerOption__c WHERE Id IN :listAnsOpt LIMIT 1];

		System.assertEquals(1, listAnsOpt.size());
	}

	@isTest
	static void ELR_0006_FA6(){

		answers1.FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name ='question8' LIMIT 1].Id;
		answers1.FieloELR__AnswerOptionText__c = 'Esta es correcta';
		answers1.FieloELR__Order__c = 1;
		answers1.FieloELR__IsCorrect__c = true;
		listAnsOpt.add(answers1);

		try{
    		insert listAnsOpt;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('For &quot;Single Choice&quot; and &quot;Statement&quot; questions, only one answer can be marked as correct.'));
		}
	}

	@isTest
	static void ELR_0006_FA7(){

		answers1.FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question4' LIMIT 1].Id;
		answers1.FieloELR__AnswerOptionText__c = 'Esta es correcta';
		answers1.FieloELR__Order__c = 1;
		listAnsOpt.add(answers1);

		insert listAnsOpt;

		listAnsOpt = [SELECT Id FROM FieloELR__AnswerOption__c WHERE Id IN :listAnsOpt LIMIT 1];

		System.assertEquals(1, listAnsOpt.size());
	}

	@isTest
	static void ELR_0006_FA8(){

		answers1.FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question6' LIMIT 1].Id;
		answers1.FieloELR__AnswerOptionText__c = 'Esta es correcta';
		answers1.FieloELR__MatchingText__c = 'Va con esta';
		answers1.FieloELR__Order__c = 1;
		listAnsOpt.add(answers1);

		insert listAnsOpt;

		listAnsOpt = [SELECT FieloELR__IsCorrect__c FROM FieloELR__AnswerOption__c WHERE Id IN :listAnsOpt LIMIT 1];

		System.assert(listAnsOpt.get(0).FieloELR__IsCorrect__c);
	}

	@isTest
	static void ELR_0006_FA9(){

		answers1.FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question6' LIMIT 1].Id;
		answers1.FieloELR__MatchingText__c = 'No tiene respuesta';
		answers1.FieloELR__Order__c = 1;
		listAnsOpt.add(answers1);

		insert listAnsOpt;

		listAnsOpt = [SELECT FieloELR__IsCorrect__c FROM FieloELR__AnswerOption__c WHERE Id IN :listAnsOpt LIMIT 1];

		System.assert(!listAnsOpt.get(0).FieloELR__IsCorrect__c);
	}

	@isTest
	static void ELR_0006_FA10(){

		listAnsOpt = [SELECT Id FROM FieloELR__AnswerOption__c WHERE FieloELR__AnswerOptionText__c != 'Esta es correcta y activa' LIMIT 1];

    	delete listAnsOpt.get(0);

    	listAnsOpt = [SELECT Id FROM FieloELR__AnswerOption__c WHERE Id IN :listAnsOpt LIMIT 1];

    	System.assertEquals(0, listAnsOpt.size());
	}

	@isTest
	static void ELR_0006_FA11(){

		listAnsOpt = [SELECT Id FROM FieloELR__AnswerOption__c WHERE FieloELR__AnswerOptionText__c = 'Esta es correcta y activa' LIMIT 1];

    	try{
    		delete listAnsOpt.get(0);
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('Questions with active modules cannot be edited.'));
		}
	}

	@isTest
	static void ELR_0006_FA12(){

		listAnsOpt = [SELECT Id FROM FieloELR__AnswerOption__c WHERE FieloELR__AnswerOptionText__c = 'Esta es incorrecta y de Statement' LIMIT 1];

		listAnsOpt.get(0).FieloELR__Order__c = 4;

		update listAnsOpt;

		listAnsOpt = [SELECT FieloELR__Order__c FROM FieloELR__AnswerOption__c WHERE FieloELR__AnswerOptionText__c = 'Esta es incorrecta y de Statement' LIMIT 1];

		System.assertEquals(4, listAnsOpt.get(0).FieloELR__Order__c);
	}

	@isTest
	static void ELR_0006_FA13(){

		listAnsOpt = [SELECT Id FROM FieloELR__AnswerOption__c WHERE FieloELR__AnswerOptionText__c = 'Esta es correcta y activa' LIMIT 1];

		listAnsOpt.get(0).FieloELR__Order__c = 4;

		try{
    		update listAnsOpt;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('Active modules cannot have changes in their set of answer options.'));
		}
	}

	@isTest
	static void ELR_0006_FA14(){

		listAnsOpt = [SELECT Id FROM FieloELR__AnswerOption__c WHERE FieloELR__AnswerOptionText__c = 'Esta es incorrecta y de Statement' LIMIT 1];

		listAnsOpt.get(0).FieloELR__IsCorrect__c = true;

		update listAnsOpt;

		listAnsOpt = [SELECT FieloELR__IsCorrect__c FROM FieloELR__AnswerOption__c WHERE FieloELR__AnswerOptionText__c = 'Esta es incorrecta y de Statement' LIMIT 1];

		System.assert(listAnsOpt.get(0).FieloELR__IsCorrect__c);
	}

	@isTest
	static void ELR_0006_FA15(){

		listAnsOpt = [SELECT Id FROM FieloELR__AnswerOption__c WHERE FieloELR__AnswerOptionText__c = 'Esta es incorrecta y del segundo Statement' LIMIT 1];

		listAnsOpt.get(0).FieloELR__IsCorrect__c = true;

    	try{
    		update listAnsOpt;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains(' For &quot;Single Choice&quot; and &quot;Statement&quot; questions, only one answer can be marked as correct.'));
		}
	}

	@isTest
	static void ELR_0006_FA9A(){

		answers1.FieloELR__Question__c = [SELECT Id FROM FieloELR__Question__c WHERE Name = 'question6' LIMIT 1].Id;
		answers1.FieloELR__AnswerOptionText__c = 'No tiene respuesta';
		answers1.FieloELR__Order__c = 1;
		listAnsOpt.add(answers1);

		try{
    		insert listAnsOpt;
		}catch(System.DmlException d){
			System.assert(d.getMessage().Contains('Matching Text is mandatory in answer options for questions of the type Matching Options.'));
		}
	}
}