@isTest
private class TestCreateModuleResponse {
    private static List<FieloELR__ModuleResponse__c> moduleRespList = new List<FieloELR__ModuleResponse__c>();
    
    @testSetup static void setup(){
        MockUpFactory.InsertTestData();
    }
    /*  TEST-1779
        Create Module Response
    */
    @isTest static void ELR_0007_FB() { 
        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        FieloELR__CourseStatus__c courseStatus = new FieloELR__CourseStatus__c(
            Member__c = member.Id,
            Course__c = module.Course__c
        );
        insert courseStatus;

        Test.startTest();

        ModuleService.ModuleWrapper moduleWrapper = FieloELR.ModuleService.takeModule(
            module.Id,
            member.Id,
            new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
            new Set<String> {'FieloELR__QuestionText__c'},
            new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c','FieloELR__IsCorrect__c'}
        );

        System.debug(JSON.serializePretty(moduleWrapper));

        System.assert(moduleWrapper.moduleResponse.Id != null);

        FieloELR__ModuleResponse__c mr = [SELECT Id, FieloELR__NumberOfAttempt__c FROM FieloELR__ModuleResponse__c WHERE Id = :moduleWrapper.moduleResponse.Id];

        System.assertEquals(1, mr.FieloELR__NumberOfAttempt__c);

        Test.stopTest();
    }

    /*  TEST-1780
        Create Module Response
        - Validations
        - Module field is null (NOK)
    */
    @isTest static void ELR_0007_FA1() {
        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        FieloELR__CourseStatus__c courseStatus = new FieloELR__CourseStatus__c(
            Member__c = member.Id,
            Course__c = module.Course__c
        );
        insert courseStatus;

        Test.startTest();

        FieloELR__ModuleResponse__c mr = new FieloELR__ModuleResponse__c(
            Member__c = member.Id,
            CourseStatus__c = courseStatus.Id
        );
        String errorMsg = '';
        try{
            insert mr;    
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }
        System.debug(errorMsg);
        System.assert(errorMsg.contains(Label.ModuleRequiredField));

        Test.stopTest();
    }

    /*  TEST-1781
        Create Module Response
        - Validations
        - Related module is not active (NOK)
    */
    @isTest static void ELR_0007_FA2() {
        delete [SELECT Id From ModuleDependency__c];

        Module__c module = [SELECT Id, Course__c From Module__c WHERE Name = 'Intermediate'];
        module.IsActive__c = true;
        update module;

        CourseService.activateCourses(new Set<Id>{module.Course__c});

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        FieloELR__CourseStatus__c courseStatus = new FieloELR__CourseStatus__c(
            Member__c = member.Id,
            Course__c = module.Course__c
        );
        insert courseStatus;

        Test.startTest();

        String errorMsg = '';
        try {
            ModuleService.ModuleWrapper moduleWrapper = FieloELR.ModuleService.takeModule(
                module.Id,
                member.Id,
                new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
                new Set<String> {'FieloELR__QuestionText__c'},
                new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c','FieloELR__IsCorrect__c'}
            );    
        } catch(Exception e) {
            errorMsg = e.getMessage();
        }
        
        System.assert(errorMsg.contains('The related module must be active'));
    }

    /*  TEST-1782
        Create Module Response
        - Validations
        - Member field is null (NOK)
    */
    @isTest static void ELR_0007_FA3() {
        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        FieloELR__CourseStatus__c courseStatus = new FieloELR__CourseStatus__c(
            Member__c = member.Id,
            Course__c = module.Course__c
        );
        insert courseStatus;

        Test.startTest();
        FieloELR__ModuleResponse__c mr = new FieloELR__ModuleResponse__c(
            Module__c = module.Id,
            CourseStatus__c = courseStatus.Id
        );
        String errorMsg = '';
        try{
            insert mr;    
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }
        System.debug(errorMsg);
        System.assert(errorMsg.contains(Label.MemberRequiredField));

        Test.stopTest();
    }

    /*  TEST-1783
        Create Module Response
        - Validations
        - Member is not approved in the predecessors modules (NOK)
    */
    @isTest static void ELR_0007_FA7() {
        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Intermediate'];

        FieloELR__CourseStatus__c courseStatus = new FieloELR__CourseStatus__c(
            Member__c = member.Id,
            Course__c = module.Course__c
        );
        insert courseStatus;

        Test.startTest();
        FieloELR__ModuleResponse__c mr = new FieloELR__ModuleResponse__c(
            Module__c = module.Id,
            Member__c = member.Id,
            CourseStatus__c = courseStatus.Id
        );
        String errorMsg = '';
        try{
            insert mr;    
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }
        System.debug(errorMsg);
        System.assert(errorMsg.contains(Label.ValidateModuleResponseMemberApproved));

        Test.stopTest();
    }

    /*  TEST-1784
        Create Module Response
        - Validations
        - The date of the response is not within the period of the course (NOK)
    */
    @isTest static void ELR_0007_FA8() {
        Course__c course = [SELECT Id FROM Course__c LIMIT 1];

        course.StartDate__c = System.today();
        course.EndDate__c = System.today().addDays(30);

        update course;

        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        FieloELR__CourseStatus__c courseStatus = new FieloELR__CourseStatus__c(
            Member__c = member.Id,
            Course__c = module.Course__c
        );
        insert courseStatus;

        Test.startTest();

        FieloELR__ModuleResponse__c mr = new FieloELR__ModuleResponse__c(
            Module__c = module.Id,
            Member__c = member.Id,
            CourseStatus__c = courseStatus.Id,
            Date__c = System.today().addDays(-1)
        );

        String errorMsg = '';
        try{
            insert mr;
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }

        System.assert(errorMsg.contains('The course is not available in this period'));

        mr = new FieloELR__ModuleResponse__c(
            Module__c = module.Id,
            Member__c = member.Id,
            CourseStatus__c = courseStatus.Id,
            Date__c = System.today().addDays(40)
        );

        errorMsg = '';
        try{
            insert mr;
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }

        System.assert(errorMsg.contains('The course is not available in this period'));

        Test.stopTest();
    }

    /*  TEST-1785
        Create Module Response
        - The Number of Attempt is equal to the “Attempts Allowed” of the related module (OK)
    */
    @isTest static void ELR_0007_FA9() {
        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        FieloELR__CourseStatus__c courseStatus = new FieloELR__CourseStatus__c(
            Member__c = member.Id,
            Course__c = module.Course__c
        );
        insert courseStatus;

        Test.startTest();

        ModuleService.ModuleWrapper moduleWrapper = FieloELR.ModuleService.takeModule(
            module.Id,
            member.Id,
            new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
            new Set<String> {'FieloELR__QuestionText__c'},
            new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c','FieloELR__IsCorrect__c'}
        );

        System.debug(JSON.serializePretty(moduleWrapper));

        System.assert(moduleWrapper.moduleResponse.Id != null);

        moduleWrapper = FieloELR.ModuleService.takeModule(
            module.Id,
            member.Id,
            new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
            new Set<String> {'FieloELR__QuestionText__c'},
            new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c','FieloELR__IsCorrect__c'}
        );

        FieloELR__ModuleResponse__c mr = [SELECT Id, NumberOfAttempt__c, LastChance__c FROM FieloELR__ModuleResponse__c WHERE Id = :moduleWrapper.moduleResponse.Id];

        System.assertEquals(mr.NumberOfAttempt__c, moduleWrapper.module.AttemptsAllowed__c);

        System.assertEquals(mr.NumberOfAttempt__c, moduleWrapper.module.AttemptsAllowed__c);

        System.assertEquals(true,mr.LastChance__c);

        Test.stopTest();
    }

    /*  TEST-1786
        Create Module Response
        - Validations
        - The Number of Attempt is greater than the “Attempts Allowed” of the related module (NOK)
    */
    @isTest static void ELR_0007_FA10() {
        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        FieloELR__CourseStatus__c courseStatus = new FieloELR__CourseStatus__c(
            Member__c = member.Id,
            Course__c = module.Course__c
        );
        insert courseStatus;

        Test.startTest();

        ModuleService.ModuleWrapper moduleWrapper = FieloELR.ModuleService.takeModule(
            module.Id,
            member.Id,
            new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
            new Set<String> {'FieloELR__QuestionText__c'},
            new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c','FieloELR__IsCorrect__c'}
        );

        System.assert(moduleWrapper.moduleResponse.Id != null);

        moduleWrapper = FieloELR.ModuleService.takeModule(
            module.Id,
            member.Id,
            new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
            new Set<String> {'FieloELR__QuestionText__c'},
            new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c','FieloELR__IsCorrect__c'}
        );

        FieloELR__ModuleResponse__c mr = [SELECT Id, NumberOfAttempt__c, LastChance__c FROM FieloELR__ModuleResponse__c WHERE Id = :moduleWrapper.moduleResponse.Id];

        System.assertEquals(mr.NumberOfAttempt__c, moduleWrapper.module.AttemptsAllowed__c);

        System.assertEquals(mr.NumberOfAttempt__c, moduleWrapper.module.AttemptsAllowed__c);

        System.assertEquals(true,mr.LastChance__c);

        String errorMsg = '';
        try{
            moduleWrapper = FieloELR.ModuleService.takeModule(
                module.Id,
                member.Id,
                new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
                new Set<String> {'FieloELR__QuestionText__c'},
                new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c','FieloELR__IsCorrect__c'}
            );
        } catch(Exception e) {
            errorMsg = e.getMessage();
        }

        System.debug(errorMsg);

        System.assert(errorMsg.contains('You have reached the limit of attempts for this module'));

        Test.stopTest();
    }

    /*  TEST-1787
        Create Module Response
        - The related course subscription mode is manual and the related course status does not exist (NOK)
    */
    @isTest static void ELR_0007_FA11() {
        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        Test.startTest();

        String errorMsg = '';
        try{
            ModuleService.ModuleWrapper moduleWrapper = FieloELR.ModuleService.takeModule(
                module.Id,
                member.Id,
                new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
                new Set<String> {'FieloELR__QuestionText__c'},
                new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c','FieloELR__IsCorrect__c'}
            );    
        } catch (Exception e) {
            errorMsg = e.getMessage();
        }

        System.debug(errorMsg);

        System.assert(errorMsg.contains('The member is not registered in the related course'));

        Test.stopTest();
    }

    /*  TEST-1788
        Create Module Response - The related course subscription mode is automatic and the related course status already exists (OK)
    */
    @isTest static void ELR_0007_FA12() {
        Course__c course = [SELECT Id FROM Course__c LIMIT 1];

        course.SubscriptionMode__c = 'Automatic';

        update course;

        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        FieloELR__CourseStatus__c courseStatus = new FieloELR__CourseStatus__c(
            Member__c = member.Id,
            Course__c = module.Course__c
        );
        CourseService.enableAdminPermission(true);
        insert courseStatus;
        CourseService.enableAdminPermission(false);

        Test.startTest();

        ModuleService.ModuleWrapper moduleWrapper = FieloELR.ModuleService.takeModule(
            module.Id,
            member.Id,
            new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
            new Set<String> {'FieloELR__QuestionText__c'},
            new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c','FieloELR__IsCorrect__c'}
        );

        System.debug(JSON.serializePretty(moduleWrapper));

        System.assert(moduleWrapper.moduleResponse.Id != null);

        FieloELR__ModuleResponse__c mr = [SELECT Id, FieloELR__NumberOfAttempt__c FROM FieloELR__ModuleResponse__c WHERE Id = :moduleWrapper.moduleResponse.Id];

        System.assertEquals(1, mr.FieloELR__NumberOfAttempt__c);

        Test.stopTest();
    }

    /*  TEST-1789
        Create Module Response
        - The related course subscription mode is automatic and the related course status does not exist (OK)
    */
    @isTest static void ELR_0007_FA13() {
        Course__c course = [SELECT Id FROM Course__c LIMIT 1];

        course.SubscriptionMode__c = 'Automatic';

        update course;

        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        Test.startTest();

        ModuleService.ModuleWrapper moduleWrapper = FieloELR.ModuleService.takeModule(
            module.Id,
            member.Id,
            new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
            new Set<String> {'FieloELR__QuestionText__c'},
            new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c','FieloELR__IsCorrect__c'}
        );

        System.debug(JSON.serializePretty(moduleWrapper));

        System.assert(moduleWrapper.moduleResponse.Id != null);

        FieloELR__ModuleResponse__c mr = [SELECT Id, FieloELR__NumberOfAttempt__c FROM FieloELR__ModuleResponse__c WHERE Id = :moduleWrapper.moduleResponse.Id];

        System.assertEquals(1, mr.FieloELR__NumberOfAttempt__c);

        Test.stopTest();
    }

    /*  TEST-1790
        Create Module Response - The administrator sets the “IsApproved” field to “true” (OK)
    */
    @isTest static void ELR_0007_FA14() {
        Course__c course = [SELECT Id FROM Course__c LIMIT 1];

        update course;

        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        FieloELR__CourseStatus__c courseStatus = new FieloELR__CourseStatus__c(
            Member__c = member.Id,
            Course__c = module.Course__c
        );
        insert courseStatus;

        Test.startTest();

        FieloELR__ModuleResponse__c mr = new FieloELR__ModuleResponse__c(
            Module__c = module.Id,
            Member__c = member.Id,
            CourseStatus__c = courseStatus.Id,
            Date__c = System.today().addDays(-1),
            IsApproved__c = true
        );

        insert mr;

        mr = [SELECT Id, IsApproved__c FROM ModuleResponse__c WHERE Id = :mr.Id];

        System.assertEquals(false, mr.IsApproved__c);

        Test.stopTest();
    }

    /*  TEST-1791
        Create Module Response
        - Delete a module response not submitted (OK)
    */
    @isTest static void ELR_0007_FA15() {
        Course__c course = [SELECT Id FROM Course__c LIMIT 1];

        course.SubscriptionMode__c = 'Automatic';

        update course;

        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        Test.startTest();

        ModuleService.ModuleWrapper moduleWrapper = FieloELR.ModuleService.takeModule(
            module.Id,
            member.Id,
            new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
            new Set<String> {'FieloELR__QuestionText__c'},
            new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c','FieloELR__IsCorrect__c'}
        );

        System.assert(moduleWrapper.moduleResponse.Id != null);

        FieloELR__ModuleResponse__c mr = [SELECT Id, FieloELR__NumberOfAttempt__c FROM FieloELR__ModuleResponse__c WHERE Id = :moduleWrapper.moduleResponse.Id];

        System.assertEquals(1, mr.FieloELR__NumberOfAttempt__c);

        delete [SELECT Id, FieloELR__NumberOfAttempt__c FROM FieloELR__ModuleResponse__c WHERE Id = :moduleWrapper.moduleResponse.Id];

        System.assertEquals(0, [SELECT Id FROM ModuleResponse__c WHERE Id = :moduleWrapper.moduleResponse.Id].size());

        Test.stopTest();
    }

    /*  TEST-1792
        Create Module Response
        - Delete a module response already submitted (OK)
    */
    @isTest static void ELR_0007_FA16() {
        Course__c course = [SELECT Id FROM Course__c LIMIT 1];

        course.SubscriptionMode__c = 'Automatic';

        update course;

        MockUpFactory.activateCourse();

        FieloPLT__Member__c member = [SELECT Id, FieloPLT__Program__c FROM FieloPLT__Member__c];
        FieloELR__Module__c module = [SELECT Id, Course__c FROM Module__c WHERE Name = 'Basic'];

        Test.startTest();

        ModuleService.ModuleWrapper moduleWrapper = FieloELR.ModuleService.takeModule(
            module.Id,
            member.Id,
            new Set<String> {'Id', 'FieloELR__AttemptsAllowed__c'},
            new Set<String> {'FieloELR__QuestionText__c'},
            new Set<String> {'FieloELR__AnswerOptionText__c','FieloELR__MatchingText__c','FieloELR__IsCorrect__c'}
        );

        System.assert(moduleWrapper.moduleResponse.Id != null);

        FieloELR__ModuleResponse__c mr = [SELECT Id, FieloELR__NumberOfAttempt__c FROM FieloELR__ModuleResponse__c WHERE Id = :moduleWrapper.moduleResponse.Id];

        mr.IsSubmitted__c = true;

        update mr;

        delete [SELECT Id, FieloELR__NumberOfAttempt__c FROM FieloELR__ModuleResponse__c WHERE Id = :moduleWrapper.moduleResponse.Id];

        System.assertEquals(0, [SELECT Id FROM ModuleResponse__c WHERE Id = :moduleWrapper.moduleResponse.Id].size());

        Test.stopTest();
    }

}