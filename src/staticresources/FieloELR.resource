
{
  "exportType" : "update",
  "configObjects" : [ {
    "apiName" : "fieloplt__library__c",
    "fieldsToExclude" : "fieloplt__resourceid__c"
  }, {
    "apiName" : "fieloplt__ruletrigger__c",
    "fieldsToExclude" : "fieloplt__prefix__c"
  }, {
    "apiName" : "fieloplt__action__c",
    "fieldsToExclude" : "fieloplt__rulesquantity__c,fieloplt__missionsquantity__c,fieloplt__criteriafields__c"
  } ],
  "migrationRecords" : [ {
    "objectAPIName" : "fieloplt__library__c",
    "records" : [ {
      "fieldsValues" : [ {
        "apiName" : "name",
        "value" : "FieloELR"
      }, {
        "apiName" : "fieloplt__version__c",
        "value" : "1.003"
      }, {
        "apiName" : "fieloplt__externalid__c",
        "value" : "FieloELR"
      } ],
      "relatedList" : [ {
        "objectAPIName" : "fieloplt__ruletrigger__c",
        "records" : [ {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Course Status"
          }, {
            "apiName" : "fieloplt__date__c",
            "value" : "CreatedDate"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloELR",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__lookupfromtransaction__c",
            "value" : "FieloELR__CourseStatus__c"
          }, {
            "apiName" : "fieloplt__lookupfromtracker__c",
            "value" : "FieloELR__CourseStatus__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloELR__CourseStatus__c"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "CourseStatus"
          }, {
            "apiName" : "fieloplt__lookupfromemailalert__c",
            "value" : "FieloELR__CourseStatus__c"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__action__c",
            "records" : [ {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Course Status > FieloELR__Member__c"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "CourseStatus",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__targetmember__c",
                "value" : "FieloELR__Member__c"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "CourseStatusFieloELRMemberc"
              }, {
                "apiName" : "fieloplt__targetemailfield__c",
                "value" : "FieloELR__Member__r.FieloPLT__Email__c"
              }, {
                "apiName" : "fieloplt__targetemailobject__c",
                "value" : "FieloPLT__Member__c"
              } ],
              "relatedList" : [ {
                "objectAPIName" : "fieloplt__programassignment__c",
                "records" : [ ]
              } ]
            } ]
          }, {
            "objectAPIName" : "fieloplt__kpi__c",
            "records" : [ {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Training - Available Courses By Program"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "00D6A0000001u5v-a0w6A000001jTVH"
              }, {
                "apiName" : "fieloplt__iscustom__c",
                "value" : "false"
              }, {
                "apiName" : "fieloplt__reportfilter__c",
                "value" : "[{ \"Report Field\" : \"FK_CUSTENT_ID\", \"Operator\" : \"equals\", \"Value\" : \"a0Q6A0000005OITUA2\" }]"
              }, {
                "apiName" : "fieloplt__reportmetadata__c",
                "value" : "{\"size\":\"small\",\"styleClass\":\"\",\"cacheResults\":true,\"hideOnError\":false,\"rendered\":true,\"showRefreshButton\":true}"
              }, {
                "apiName" : "fieloplt__reportobjectivefield__c",
                "value" : "RowCount"
              }, {
                "apiName" : "fieloplt__reporttype__c",
                "value" : "Standard"
              }, {
                "apiName" : "fieloplt__reportuniquename__c",
                "value" : "fieloelr__AvailableCourses"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "CourseStatus",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__type__c",
                "value" : "Program"
              } ],
              "relatedList" : [ ]
            }, {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Training - Members That Doesn't Finished a Course By Program"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "00D6A0000001u5v-a0w6A000001jTUx"
              }, {
                "apiName" : "fieloplt__iscustom__c",
                "value" : "false"
              }, {
                "apiName" : "fieloplt__reportfilter__c",
                "value" : "[{ \"Report Field\" : \"FieloPLT__Program__c.Id\", \"Operator\" : \"equals\", \"Record Field\": \"FieloPLT__Program__r.Id\" }]"
              }, {
                "apiName" : "fieloplt__reportmetadata__c",
                "value" : "{\"size\":\"small\",\"styleClass\":\"\",\"cacheResults\":true,\"hideOnError\":false,\"rendered\":true,\"showRefreshButton\":true}"
              }, {
                "apiName" : "fieloplt__reportobjectivefield__c",
                "value" : "s!FieloPLT__Member__c.FieloPLT__MemberRecord__c"
              }, {
                "apiName" : "fieloplt__reporttype__c",
                "value" : "Standard"
              }, {
                "apiName" : "fieloplt__reportuniquename__c",
                "value" : "fieloelr__MembersThatDoesntFinishedACourse"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "CourseStatus",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__type__c",
                "value" : "Program"
              } ],
              "relatedList" : [ ]
            }, {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Training - Members That Doesn't Finished a Course By Promotion's Program"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "00D6A0000001u5v-a0w6A000001jTVC"
              }, {
                "apiName" : "fieloplt__iscustom__c",
                "value" : "false"
              }, {
                "apiName" : "fieloplt__reportfilter__c",
                "value" : "[{ \"Report Field\" : \"FieloPLT__Program__c.Id\", \"Operator\" : \"equals\", \"Record Field\": \"FieloPLT__Promotion__r.FieloPLT__Program__c\" }]"
              }, {
                "apiName" : "fieloplt__reportmetadata__c",
                "value" : "{\"size\":\"small\",\"styleClass\":\"\",\"cacheResults\":true,\"hideOnError\":false,\"rendered\":true,\"showRefreshButton\":true}"
              }, {
                "apiName" : "fieloplt__reportobjectivefield__c",
                "value" : "s!FieloPLT__Member__c.FieloPLT__MemberRecord__c"
              }, {
                "apiName" : "fieloplt__reporttype__c",
                "value" : "Standard"
              }, {
                "apiName" : "fieloplt__reportuniquename__c",
                "value" : "fieloelr__MembersThatDoesntFinishedACourse"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "CourseStatus",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__type__c",
                "value" : "Promotion"
              } ],
              "relatedList" : [ ]
            }, {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Training - Members That Started a Course By Program"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "00D6A0000001u5v-a0w6A000001jTV2"
              }, {
                "apiName" : "fieloplt__iscustom__c",
                "value" : "false"
              }, {
                "apiName" : "fieloplt__reportfilter__c",
                "value" : "[{ \"Report Field\" : \"FieloPLT__Program__c.Id\", \"Operator\" : \"equals\", \"Record Field\": \"FieloPLT__Program__r.Id\" }]"
              }, {
                "apiName" : "fieloplt__reportmetadata__c",
                "value" : "{\"size\":\"small\",\"styleClass\":\"\",\"cacheResults\":true,\"hideOnError\":false,\"rendered\":true,\"showRefreshButton\":true}"
              }, {
                "apiName" : "fieloplt__reportobjectivefield__c",
                "value" : "s!FieloPLT__Member__c.FieloPLT__MemberRecord__c"
              }, {
                "apiName" : "fieloplt__reporttype__c",
                "value" : "Standard"
              }, {
                "apiName" : "fieloplt__reportuniquename__c",
                "value" : "fieloelr__MembersThatStartedACourse"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "CourseStatus",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__type__c",
                "value" : "Program"
              } ],
              "relatedList" : [ ]
            }, {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Training - Members That Started a Course By Promotion's Program"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "00D6A0000001u5v-a0w6A000001jTV7"
              }, {
                "apiName" : "fieloplt__iscustom__c",
                "value" : "false"
              }, {
                "apiName" : "fieloplt__reportfilter__c",
                "value" : "[{ \"Report Field\" : \"FieloPLT__Program__c.Id\", \"Operator\" : \"equals\", \"Record Field\": \"FieloPLT__Promotion__r.FieloPLT__Program__c\" }]"
              }, {
                "apiName" : "fieloplt__reportmetadata__c",
                "value" : "{\"size\":\"small\",\"styleClass\":\"\",\"cacheResults\":true,\"hideOnError\":false,\"rendered\":true,\"showRefreshButton\":true}"
              }, {
                "apiName" : "fieloplt__reportobjectivefield__c",
                "value" : "s!FieloPLT__Member__c.FieloPLT__MemberRecord__c"
              }, {
                "apiName" : "fieloplt__reporttype__c",
                "value" : "Standard"
              }, {
                "apiName" : "fieloplt__reportuniquename__c",
                "value" : "fieloelr__MembersThatStartedACourse"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "CourseStatus",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__type__c",
                "value" : "Promotion"
              } ],
              "relatedList" : [ ]
            } ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Module Response"
          }, {
            "apiName" : "fieloplt__conditionfield__c",
            "value" : "FieloELR__IsApproved__c"
          }, {
            "apiName" : "fieloplt__conditiontype__c",
            "value" : "Text"
          }, {
            "apiName" : "fieloplt__conditionvalue__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__date__c",
            "value" : "CreatedDate"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloELR",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__lookupfromtransaction__c",
            "value" : "FieloELR__ModuleResponse__c"
          }, {
            "apiName" : "fieloplt__lookupfromtracker__c",
            "value" : "FieloELR__ModuleResponse__c"
          }, {
            "apiName" : "fieloplt__object__c",
            "value" : "FieloELR__ModuleResponse__c"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "ModuleResponse"
          }, {
            "apiName" : "fieloplt__lookupfromemailalert__c",
            "value" : "FieloELR__ModuleResponse__c"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__action__c",
            "records" : [ {
              "fieldsValues" : [ {
                "apiName" : "name",
                "value" : "Module Response > FieloELR__Member__c"
              }, {
                "apiName" : "fieloplt__ruletrigger__c.fieloplt__externalid__c",
                "value" : "ModuleResponse",
                "refObject" : "fieloplt__ruletrigger__c"
              }, {
                "apiName" : "fieloplt__targetmember__c",
                "value" : "FieloELR__Member__c"
              }, {
                "apiName" : "fieloplt__externalid__c",
                "value" : "ModuleResponseFieloELRMemberc"
              }, {
                "apiName" : "fieloplt__targetemailfield__c",
                "value" : "FieloELR__Member__r.FieloPLT__Email__c"
              }, {
                "apiName" : "fieloplt__targetemailobject__c",
                "value" : "FieloPLT__Member__c"
              } ],
              "relatedList" : [ {
                "objectAPIName" : "fieloplt__programassignment__c",
                "records" : [ ]
              } ]
            } ]
          }, {
            "objectAPIName" : "fieloplt__kpi__c",
            "records" : [ ]
          } ]
        } ]
      }, {
        "objectAPIName" : "fieloplt__model__c",
        "records" : [ {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Basic Course"
          }, {
            "apiName" : "fieloplt__category__c",
            "value" : "Miscelaneas"
          }, {
            "apiName" : "fieloplt__icon__c",
            "value" : "fielosf-icon-content"
          }, {
            "apiName" : "fieloplt__json__c",
            "value" : "{  \"courses\" : [ {    \"reference\" : \"a0j6A00000060TXQAY\",    \"segments\" : [ {      \"segmentName\" : \"Segment A for Training Center\"    }, {      \"segmentName\" : \"Segment B for Training Center\"    } ],    \"Name\" : \"Complete Course - Subscription Mode is Manual\",    \"FieloELR__Description__c\" : \"This is the first course to be completed\",    \"FieloELR__SubscriptionMode__c\" : \"Manual\",    \"modules\" : [ {      \"reference\" : \"a0m6A000001EE0XQAW\",      \"Name\" : \"MA-First Module\",      \"FieloELR__ApprovalGrade__c\" : 50.00,      \"FieloELR__AttemptsAllowed__c\" : 2,      \"FieloELR__Description__c\" : \"Module with all types of questions\",      \"FieloELR__Order__c\" : 3,      \"FieloELR__PenaltyMode__c\" : \"None\",      \"FieloELR__ShuffleQuestions__c\" : false,      \"FieloELR__WeightedQuestions__c\" : true,      \"questions\" : [ {        \"Name\" : \"MA-FM-Matching Options\",        \"FieloELR__CorrectWeight__c\" : 30.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 5,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"Match the columns\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Matching Options\",        \"answerOptions\" : [ {          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3,          \"FieloELR__MatchingText__c\" : \"z\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"A\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1,          \"FieloELR__MatchingText__c\" : \"a\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"B\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2,          \"FieloELR__MatchingText__c\" : \"b\"        } ]      }, {        \"Name\" : \"MA-FM-Multiple Choice\",        \"FieloELR__CorrectWeight__c\" : 20.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 2,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"In trigonometry, sin and cos are short for which words?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Multiple Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"Tangent\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"Cosine\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"Sine\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-FM-Short Answer\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 3,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"What is the square root of 100?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Short Answer\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"ten\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"Ten\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"10\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-FM-Single Choice\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 1,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"What is the term given to the perimeter around a circle?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Single Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"Hyperbole\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"Circumference\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-FM-Statement\",        \"FieloELR__CorrectWeight__c\" : 30.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 4,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"A right angle has 90 degrees.\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Statement\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"True\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        }, {          \"FieloELR__AnswerOptionText__c\" : \"False\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        } ]      } ]    }, {      \"reference\" : \"a0m6A000001EGt3QAG\",      \"Name\" : \"MA-Second Module\",      \"FieloELR__ApprovalGrade__c\" : 50.00,      \"FieloELR__AttemptsAllowedPerQuestion__c\" : 2,      \"FieloELR__Description__c\" : \"Description\",      \"FieloELR__Order__c\" : 2,      \"FieloELR__PenaltyMode__c\" : \"Negative Weight\",      \"FieloELR__QuestionPool__c\" : 3,      \"FieloELR__ShuffleQuestions__c\" : false,      \"FieloELR__WeightedQuestions__c\" : false,      \"FieloELR__KeyDependencies__c\" : \"a0m6A000001EE0XQAW\",      \"predecessors\" : [ {        \"moduleReference\" : \"a0m6A000001EE0XQAW\"      } ],      \"questions\" : [ {        \"Name\" : \"MA-SM-Multiple Choice\",        \"FieloELR__CorrectWeight__c\" : 1.00,        \"FieloELR__IncorrectWeight__c\" : -2.00,        \"FieloELR__Order__c\" : 4,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"How many straight edges does a cube have?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Multiple Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"8\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"16\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"12\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-SM-Short Answer\",        \"FieloELR__CorrectWeight__c\" : 1.00,        \"FieloELR__IncorrectWeight__c\" : 0.10,        \"FieloELR__Order__c\" : 1,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"How many inches are there in a foot?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Short Answer\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"twelve\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 4        }, {          \"FieloELR__AnswerOptionText__c\" : \"Twelve\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"12 inches\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"12\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-SM-Single Choice\",        \"FieloELR__CorrectWeight__c\" : 1.00,        \"FieloELR__IncorrectWeight__c\" : -0.20,        \"FieloELR__Order__c\" : 2,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"What is the missing number from the sequence: 0, 1, 1, 2, 3, 5, 8, ..., 21, 34?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Single Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"20\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"13\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        }, {          \"FieloELR__AnswerOptionText__c\" : \"14\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        } ]      }, {        \"Name\" : \"MA-SM-Statement\",        \"FieloELR__CorrectWeight__c\" : 1.00,        \"FieloELR__IncorrectWeight__c\" : -1.00,        \"FieloELR__Order__c\" : 3,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"True or False: The square route of 144 is twelve.\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Statement\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"False\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"True\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      } ]    }, {      \"reference\" : \"a0m6A000001EH5bQAG\",      \"Name\" : \"MA-Third Module\",      \"FieloELR__ApprovalGrade__c\" : 50.00,      \"FieloELR__AttemptsAllowedPerQuestion__c\" : 3,      \"FieloELR__Order__c\" : 1,      \"FieloELR__PenaltyMode__c\" : \"Percent Decrease\",      \"FieloELR__ShuffleQuestions__c\" : false,      \"FieloELR__WeightedQuestions__c\" : true,      \"FieloELR__KeyDependencies__c\" : \"a0m6A000001EE0XQAW,a0m6A000001EGt3QAG\",      \"predecessors\" : [ {        \"moduleReference\" : \"a0m6A000001EGt3QAG\"      }, {        \"moduleReference\" : \"a0m6A000001EE0XQAW\"      } ],      \"questions\" : [ {        \"Name\" : \"MA-TM-Matching Options\",        \"FieloELR__CorrectWeight__c\" : 30.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 5,        \"FieloELR__PenaltyPerAttempt__c\" : 10.00,        \"FieloELR__QuestionText__c\" : \"Matching Options\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Matching Options\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"Up\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 4,          \"FieloELR__MatchingText__c\" : \"Down\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"Yes\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 3,          \"FieloELR__MatchingText__c\" : \"No\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"Stop\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2,          \"FieloELR__MatchingText__c\" : \"Go\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"In\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 5,          \"FieloELR__MatchingText__c\" : \"Out\"        }, {          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 6,          \"FieloELR__MatchingText__c\" : \"Low\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"Dark\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1,          \"FieloELR__MatchingText__c\" : \"Clear\"        } ]      }, {        \"Name\" : \"MA-TM-Multiple Choice\",        \"FieloELR__CorrectWeight__c\" : 20.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 2,        \"FieloELR__PenaltyPerAttempt__c\" : 30.00,        \"FieloELR__QuestionText__c\" : \"These numbers can be arranged into a stacked triangle:\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Multiple Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"18\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"6\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"3\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-TM-Short Answer\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 3,        \"FieloELR__PenaltyPerAttempt__c\" : 50.00,        \"FieloELR__QuestionText__c\" : \"What is 4 x 9?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Short Answer\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"thirty-six\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"thirty six\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"36\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-TM-Single Choice\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 1,        \"FieloELR__PenaltyPerAttempt__c\" : 50.00,        \"FieloELR__QuestionText__c\" : \"What is the name of the manual calculating device which consists of beads?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Single Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"Hibiscus\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"Abacus\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 4        }, {          \"FieloELR__AnswerOptionText__c\" : \"Acarus\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        } ]      }, {        \"Name\" : \"MA-TM-Statement\",        \"FieloELR__CorrectWeight__c\" : 30.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 4,        \"FieloELR__PenaltyPerAttempt__c\" : 10.00,        \"FieloELR__QuestionText__c\" : \"We use a protractor to measure angles.\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Statement\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"False\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"True\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      } ]    } ]  } ]}"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloELR",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Course"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "BasicCourse"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Course Promotion"
          }, {
            "apiName" : "fieloplt__category__c",
            "value" : "Miscelaneas"
          }, {
            "apiName" : "fieloplt__icon__c",
            "value" : "fielosf-icon-content"
          }, {
            "apiName" : "fieloplt__json__c",
            "value" : "{  \"promotions\" : [ {    \"Name\" : \"Course Promotion\",    \"rules\" : [ {      \"actionName\" : \"FieloELR__CourseStatus__c>FieloELR__Member__c\",      \"pointTypeName\" : \"Point\",      \"Name\" : \"Progress = 100% > 100pts\",      \"FieloPLT__ConversionValue__c\" : 100.00,      \"FieloPLT__LogicalExpression__c\" : \"ALL\",      \"FieloPLT__PointConversionMode__c\" : \"Fixed Value\",      \"FieloPLT__RelatedList__c\" : \"FieloELR__CourseStatus__c\",      \"FieloPLT__StockControl__c\" : false,      \"FieloPLT__Type__c\" : \"No Competition\",      \"criteria\" : [ {        \"FieloPLT__BooleanValue__c\" : false,        \"FieloPLT__Description__c\" : \"FieloELR__Progress__c = 100.00\",        \"FieloPLT__FieldName__c\" : \"FieloELR__Progress__c\",        \"FieloPLT__FieldType__c\" : \"Number\",        \"FieloPLT__IsField__c\" : false,        \"FieloPLT__NumberValue__c\" : 100.00,        \"FieloPLT__Operator__c\" : \"equals\",        \"FieloPLT__Order__c\" : 1      } ]    } ]  } ]}"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloELR",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Promotion"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "CoursePromotion"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Intermediate Course"
          }, {
            "apiName" : "fieloplt__category__c",
            "value" : "Miscelaneas"
          }, {
            "apiName" : "fieloplt__icon__c",
            "value" : "fielosf-icon-content"
          }, {
            "apiName" : "fieloplt__json__c",
            "value" : "{  \"courses\" : [ {    \"reference\" : \"a0j6A0000006B3gQAE\",    \"Name\" : \"Complete Course - Subscription Mode is Automatic\",    \"FieloELR__Description__c\" : \"This is the second course to be completed\",    \"FieloELR__SubscriptionMode__c\" : \"Automatic\",    \"FieloELR__KeyDependencies__c\" : \"a0j6A00000060TXQAY\",    \"predecessors\" : [ {      \"courseName\" : \"Complete Course - Subscription Mode is Manual\"    } ],    \"modules\" : [ {      \"reference\" : \"a0m6A000001F0b8QAC\",      \"Name\" : \"AU-First Module\",      \"FieloELR__ApprovalGrade__c\" : 50.00,      \"FieloELR__Description__c\" : \"This is the first module to be completed\",      \"FieloELR__Order__c\" : 1,      \"FieloELR__PenaltyMode__c\" : \"Percent Decrease\",      \"FieloELR__ShuffleQuestions__c\" : false,      \"FieloELR__WeightedQuestions__c\" : true,      \"questions\" : [ {        \"Name\" : \"AU-FM-Matching Options\",        \"FieloELR__CorrectWeight__c\" : 30.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 4,        \"FieloELR__PenaltyPerAttempt__c\" : 10.00,        \"FieloELR__QuestionText__c\" : \"Match the values\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Matching Options\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"W\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2,          \"FieloELR__MatchingText__c\" : \"white\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"Y\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1,          \"FieloELR__MatchingText__c\" : \"yellow\"        }, {          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3,          \"FieloELR__MatchingText__c\" : \"black\"        } ]      }, {        \"Name\" : \"AU-FM-Multiple Choice\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 3,        \"FieloELR__PenaltyPerAttempt__c\" : 50.00,        \"FieloELR__QuestionText__c\" : \"What is the smallest prime number?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Multiple Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"2\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        }, {          \"FieloELR__AnswerOptionText__c\" : \"1\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"3\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        } ]      }, {        \"Name\" : \"AU-FM-Short Answer\",        \"FieloELR__CorrectWeight__c\" : 30.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 5,        \"FieloELR__PenaltyPerAttempt__c\" : 10.00,        \"FieloELR__QuestionText__c\" : \"Who is the current number one on Men's Tennis ATP Rankings?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Short Answer\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"Andy Murray\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        }, {          \"FieloELR__AnswerOptionText__c\" : \"Murray\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2        } ]      }, {        \"Name\" : \"AU-FM-Single Choice\",        \"FieloELR__CorrectWeight__c\" : 20.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 2,        \"FieloELR__PenaltyPerAttempt__c\" : 30.00,        \"FieloELR__QuestionText__c\" : \"What's the color of napoleon's white horse?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Single Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"Black\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"White\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        }, {          \"FieloELR__AnswerOptionText__c\" : \"Gray\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        } ]      }, {        \"Name\" : \"AU-FM-Statement\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 1,        \"FieloELR__PenaltyPerAttempt__c\" : 50.00,        \"FieloELR__QuestionText__c\" : \"Say if it's true or false.\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Statement\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"False\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"True\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      } ]    }, {      \"reference\" : \"a0m6A000001F0iAQAS\",      \"Name\" : \"AU-Second Module\",      \"FieloELR__ApprovalGrade__c\" : 50.00,      \"FieloELR__AttemptsAllowedPerQuestion__c\" : 3,      \"FieloELR__AttemptsAllowed__c\" : 3,      \"FieloELR__Order__c\" : 2,      \"FieloELR__PenaltyMode__c\" : \"Negative Weight\",      \"FieloELR__ShuffleQuestions__c\" : false,      \"FieloELR__WeightedQuestions__c\" : true,      \"questions\" : [ {        \"Name\" : \"AU-SM-Multiple Choice\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : -2.00,        \"FieloELR__Order__c\" : 2,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"How many sides does a decagon have?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Multiple Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"12\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"10\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        }, {          \"FieloELR__AnswerOptionText__c\" : \"8\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        } ]      }, {        \"Name\" : \"AU-SM-Single Choice\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : -2.00,        \"FieloELR__Order__c\" : 3,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"What is one sixth of 6?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Single Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"1\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        }, {          \"FieloELR__AnswerOptionText__c\" : \"36\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"16\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        } ]      }, {        \"Name\" : \"AU-SM-Statement\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : -2.00,        \"FieloELR__Order__c\" : 1,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"20% of 2 is equal to 0.4\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Statement\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"True\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        }, {          \"FieloELR__AnswerOptionText__c\" : \"False\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        } ]      } ]    } ]  } ]}"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloELR",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Course"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "IntermediateCourse"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "name",
            "value" : "Module Promotion"
          }, {
            "apiName" : "fieloplt__category__c",
            "value" : "Miscelaneas"
          }, {
            "apiName" : "fieloplt__icon__c",
            "value" : "fielosf-icon-content"
          }, {
            "apiName" : "fieloplt__json__c",
            "value" : "{  \"promotions\" : [ {    \"Name\" : \"Module Promotion\",    \"rules\" : [ {      \"actionName\" : \"FieloELR__ModuleResponse__c.FieloELR__IsApproved__c[true]>FieloELR__Member__c\",      \"pointTypeName\" : \"Point\",      \"Name\" : \"GradeValue x 2\",      \"FieloPLT__ConversionValue__c\" : 2.00,      \"FieloPLT__LogicalExpression__c\" : \"ALL\",      \"FieloPLT__PointConversionMode__c\" : \"Multiplier\",      \"FieloPLT__RecordFieldName__c\" : \"FieloELR__GradeValue__c\",      \"FieloPLT__RelatedList__c\" : \"FieloELR__ModuleResponse__c\",      \"FieloPLT__StockControl__c\" : false,      \"FieloPLT__Type__c\" : \"No Competition\",      \"criteria\" : [ {        \"FieloPLT__BooleanValue__c\" : true,        \"FieloPLT__Description__c\" : \"FieloELR__IsApproved__c = true\",        \"FieloPLT__FieldName__c\" : \"FieloELR__IsApproved__c\",        \"FieloPLT__FieldType__c\" : \"Boolean\",        \"FieloPLT__IsField__c\" : false,        \"FieloPLT__Operator__c\" : \"equals\",        \"FieloPLT__Order__c\" : 1      }, {        \"FieloPLT__BooleanValue__c\" : false,        \"FieloPLT__Description__c\" : \"FieloELR__NumberofApprove__c = 1.00\",        \"FieloPLT__FieldName__c\" : \"FieloELR__NumberofApprove__c\",        \"FieloPLT__FieldType__c\" : \"Number\",        \"FieloPLT__IsField__c\" : false,        \"FieloPLT__NumberValue__c\" : 1.00,        \"FieloPLT__Operator__c\" : \"equals\",        \"FieloPLT__Order__c\" : 2      } ]    } ]  } ]}"
          }, {
            "apiName" : "fieloplt__library__c.fieloplt__externalid__c",
            "value" : "FieloELR",
            "refObject" : "fieloplt__library__c"
          }, {
            "apiName" : "fieloplt__type__c",
            "value" : "Promotion"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "ModulePromotion"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        } ]
      }, {
        "objectAPIName" : "fieloplt__pagesettings__c",
        "records" : [ {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2l"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU34"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2r"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2o"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2p"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2t"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU38"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2q"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2s"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2n"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2u"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A0000015xcN"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2j"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU35"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2z"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2v"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2m"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU36"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2y"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU30"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2w"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2x"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A0000015xcX"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU39"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2i"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU33"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU31"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU32"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        }, {
          "fieldsValues" : [ {
            "apiName" : "fieloplt__isactive__c",
            "value" : "true"
          }, {
            "apiName" : "fieloplt__externalid__c",
            "value" : "00D6A0000001u5v-a0L6A000000BU2k"
          } ],
          "relatedList" : [ {
            "objectAPIName" : "fieloplt__programassignment__c",
            "records" : [ ]
          } ]
        } ]
      } ]
    } ]
  } ],
  "segmentsCombinations" : [ ]
}