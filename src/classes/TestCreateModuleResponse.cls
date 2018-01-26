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
        Create Module Response - Validations - Related module is not active (NOK)
    */
    @isTest static void ELR_0007_FA2(){
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

    /*
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