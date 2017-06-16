
{
  "Libraries" : [ {
    "Name" : "FieloELR",
    "ruletriggers" : [ {
      "Name" : "Module Response",
      "FieloPLT__ConditionField__c" : "FieloELR__IsApproved__c",
      "FieloPLT__ConditionType__c" : "Text",
      "FieloPLT__ConditionValue__c" : "true",
      "FieloPLT__Date__c" : "CreatedDate",
      "FieloPLT__LookupFromTransaction__c" : "FieloELR__ModuleResponse__c",
      "FieloPLT__LookupfromTracker__c" : "FieloELR__ModuleResponse__c",
      "FieloPLT__Object__c" : "FieloELR__ModuleResponse__c",
      "actions" : [ {
        "Name" : "Module Response > FieloELR__Member__c",
        "FieloPLT__TargetMember__c" : "FieloELR__Member__c"
      } ]
    }, {
      "Name" : "Course Status",
      "FieloPLT__Date__c" : "CreatedDate",
      "FieloPLT__LookupFromTransaction__c" : "FieloELR__CourseStatus__c",
      "FieloPLT__Object__c" : "FieloELR__CourseStatus__c",
      "actions" : [ {
        "Name" : "Course Status > FieloELR__Member__c",
        "FieloPLT__TargetMember__c" : "FieloELR__Member__c"
      } ]
    } ],
    "models" : [ {
      "Name" : "Module Promotion",
      "FieloPLT__Category__c" : "Miscelaneas",
      "FieloPLT__Icon__c" : "fielosf-icon-content",
      "FieloPLT__JSON__c" : "{  \"promotions\" : [ {    \"Name\" : \"Module Promotion\",    \"rules\" : [ {      \"actionName\" : \"FieloELR__ModuleResponse__c.FieloELR__IsApproved__c[true]>FieloELR__Member__c\",      \"pointTypeName\" : \"Point\",      \"Name\" : \"GradeValue x 2\",      \"FieloPLT__ConversionValue__c\" : 2.00,      \"FieloPLT__LogicalExpression__c\" : \"ALL\",      \"FieloPLT__PointConversionMode__c\" : \"Multiplier\",      \"FieloPLT__RecordFieldName__c\" : \"FieloELR__GradeValue__c\",      \"FieloPLT__RelatedList__c\" : \"FieloELR__ModuleResponse__c\",      \"FieloPLT__StockControl__c\" : false,      \"FieloPLT__Type__c\" : \"No Competition\",      \"criteria\" : [ {        \"FieloPLT__BooleanValue__c\" : true,        \"FieloPLT__Description__c\" : \"FieloELR__IsApproved__c = true\",        \"FieloPLT__FieldName__c\" : \"FieloELR__IsApproved__c\",        \"FieloPLT__FieldType__c\" : \"Boolean\",        \"FieloPLT__IsField__c\" : false,        \"FieloPLT__Operator__c\" : \"equals\",        \"FieloPLT__Order__c\" : 1      }, {        \"FieloPLT__BooleanValue__c\" : false,        \"FieloPLT__Description__c\" : \"FieloELR__NumberofApprove__c = 1.00\",        \"FieloPLT__FieldName__c\" : \"FieloELR__NumberofApprove__c\",        \"FieloPLT__FieldType__c\" : \"Number\",        \"FieloPLT__IsField__c\" : false,        \"FieloPLT__NumberValue__c\" : 1.00,        \"FieloPLT__Operator__c\" : \"equals\",        \"FieloPLT__Order__c\" : 2      } ]    } ]  } ]}",
      "FieloPLT__Type__c" : "Promotion"
    }, {
      "Name" : "Course Promotion",
      "FieloPLT__Category__c" : "Miscelaneas",
      "FieloPLT__Icon__c" : "fielosf-icon-content",
      "FieloPLT__JSON__c" : "{  \"promotions\" : [ {    \"Name\" : \"Course Promotion\",    \"rules\" : [ {      \"actionName\" : \"FieloELR__CourseStatus__c>FieloELR__Member__c\",      \"pointTypeName\" : \"Point\",      \"Name\" : \"Progress = 100% > 100pts\",      \"FieloPLT__ConversionValue__c\" : 100.00,      \"FieloPLT__LogicalExpression__c\" : \"ALL\",      \"FieloPLT__PointConversionMode__c\" : \"Fixed Value\",      \"FieloPLT__RelatedList__c\" : \"FieloELR__CourseStatus__c\",      \"FieloPLT__StockControl__c\" : false,      \"FieloPLT__Type__c\" : \"No Competition\",      \"criteria\" : [ {        \"FieloPLT__BooleanValue__c\" : false,        \"FieloPLT__Description__c\" : \"FieloELR__Progress__c = 100.00\",        \"FieloPLT__FieldName__c\" : \"FieloELR__Progress__c\",        \"FieloPLT__FieldType__c\" : \"Number\",        \"FieloPLT__IsField__c\" : false,        \"FieloPLT__NumberValue__c\" : 100.00,        \"FieloPLT__Operator__c\" : \"equals\",        \"FieloPLT__Order__c\" : 1      } ]    } ]  } ]}",
      "FieloPLT__Type__c" : "Promotion"
    }, {
      "Name" : "Basic Course",
      "FieloPLT__Category__c" : "Miscelaneas",
      "FieloPLT__Icon__c" : "fielosf-icon-content",
      "FieloPLT__JSON__c" : "{  \"courses\" : [ {    \"reference\" : \"a0j6A00000060TXQAY\",    \"segments\" : [ {      \"segmentName\" : \"Segment A for Training Center\"    }, {      \"segmentName\" : \"Segment B for Training Center\"    } ],    \"Name\" : \"Complete Course - Subscription Mode is Manual\",    \"FieloELR__Description__c\" : \"This is the first course to be completed\",    \"FieloELR__SubscriptionMode__c\" : \"Manual\",    \"modules\" : [ {      \"reference\" : \"a0m6A000001EE0XQAW\",      \"Name\" : \"MA-First Module\",      \"FieloELR__ApprovalGrade__c\" : 50.00,      \"FieloELR__AttemptsAllowed__c\" : 2,      \"FieloELR__Description__c\" : \"Module with all types of questions\",      \"FieloELR__Order__c\" : 3,      \"FieloELR__PenaltyMode__c\" : \"None\",      \"FieloELR__ShuffleQuestions__c\" : false,      \"FieloELR__WeightedQuestions__c\" : true,      \"questions\" : [ {        \"Name\" : \"MA-FM-Matching Options\",        \"FieloELR__CorrectWeight__c\" : 30.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 5,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"Match the columns\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Matching Options\",        \"answerOptions\" : [ {          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3,          \"FieloELR__MatchingText__c\" : \"z\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"A\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1,          \"FieloELR__MatchingText__c\" : \"a\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"B\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2,          \"FieloELR__MatchingText__c\" : \"b\"        } ]      }, {        \"Name\" : \"MA-FM-Multiple Choice\",        \"FieloELR__CorrectWeight__c\" : 20.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 2,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"In trigonometry, sin and cos are short for which words?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Multiple Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"Tangent\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"Cosine\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"Sine\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-FM-Short Answer\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 3,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"What is the square root of 100?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Short Answer\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"ten\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"Ten\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"10\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-FM-Single Choice\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 1,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"What is the term given to the perimeter around a circle?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Single Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"Hyperbole\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"Circumference\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-FM-Statement\",        \"FieloELR__CorrectWeight__c\" : 30.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 4,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"A right angle has 90 degrees.\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Statement\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"True\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        }, {          \"FieloELR__AnswerOptionText__c\" : \"False\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        } ]      } ]    }, {      \"reference\" : \"a0m6A000001EGt3QAG\",      \"Name\" : \"MA-Second Module\",      \"FieloELR__ApprovalGrade__c\" : 50.00,      \"FieloELR__AttemptsAllowedPerQuestion__c\" : 2,      \"FieloELR__Description__c\" : \"Description\",      \"FieloELR__Order__c\" : 2,      \"FieloELR__PenaltyMode__c\" : \"Negative Weight\",      \"FieloELR__QuestionPool__c\" : 3,      \"FieloELR__ShuffleQuestions__c\" : false,      \"FieloELR__WeightedQuestions__c\" : false,      \"FieloELR__KeyDependencies__c\" : \"a0m6A000001EE0XQAW\",      \"predecessors\" : [ {        \"moduleReference\" : \"a0m6A000001EE0XQAW\"      } ],      \"questions\" : [ {        \"Name\" : \"MA-SM-Multiple Choice\",        \"FieloELR__CorrectWeight__c\" : 1.00,        \"FieloELR__IncorrectWeight__c\" : -2.00,        \"FieloELR__Order__c\" : 4,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"How many straight edges does a cube have?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Multiple Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"8\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"16\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"12\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-SM-Short Answer\",        \"FieloELR__CorrectWeight__c\" : 1.00,        \"FieloELR__IncorrectWeight__c\" : 0.10,        \"FieloELR__Order__c\" : 1,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"How many inches are there in a foot?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Short Answer\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"twelve\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 4        }, {          \"FieloELR__AnswerOptionText__c\" : \"Twelve\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"12 inches\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"12\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-SM-Single Choice\",        \"FieloELR__CorrectWeight__c\" : 1.00,        \"FieloELR__IncorrectWeight__c\" : -0.20,        \"FieloELR__Order__c\" : 2,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"What is the missing number from the sequence: 0, 1, 1, 2, 3, 5, 8, ..., 21, 34?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Single Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"20\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"13\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        }, {          \"FieloELR__AnswerOptionText__c\" : \"14\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        } ]      }, {        \"Name\" : \"MA-SM-Statement\",        \"FieloELR__CorrectWeight__c\" : 1.00,        \"FieloELR__IncorrectWeight__c\" : -1.00,        \"FieloELR__Order__c\" : 3,        \"FieloELR__PenaltyPerAttempt__c\" : 0.00,        \"FieloELR__QuestionText__c\" : \"True or False: The square route of 144 is twelve.\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Statement\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"False\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"True\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      } ]    }, {      \"reference\" : \"a0m6A000001EH5bQAG\",      \"Name\" : \"MA-Third Module\",      \"FieloELR__ApprovalGrade__c\" : 50.00,      \"FieloELR__AttemptsAllowedPerQuestion__c\" : 3,      \"FieloELR__Order__c\" : 1,      \"FieloELR__PenaltyMode__c\" : \"Percent Decrease\",      \"FieloELR__ShuffleQuestions__c\" : false,      \"FieloELR__WeightedQuestions__c\" : true,      \"FieloELR__KeyDependencies__c\" : \"a0m6A000001EE0XQAW,a0m6A000001EGt3QAG\",      \"predecessors\" : [ {        \"moduleReference\" : \"a0m6A000001EGt3QAG\"      }, {        \"moduleReference\" : \"a0m6A000001EE0XQAW\"      } ],      \"questions\" : [ {        \"Name\" : \"MA-TM-Matching Options\",        \"FieloELR__CorrectWeight__c\" : 30.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 5,        \"FieloELR__PenaltyPerAttempt__c\" : 10.00,        \"FieloELR__QuestionText__c\" : \"Matching Options\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Matching Options\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"Up\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 4,          \"FieloELR__MatchingText__c\" : \"Down\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"Yes\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 3,          \"FieloELR__MatchingText__c\" : \"No\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"Stop\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2,          \"FieloELR__MatchingText__c\" : \"Go\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"In\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 5,          \"FieloELR__MatchingText__c\" : \"Out\"        }, {          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 6,          \"FieloELR__MatchingText__c\" : \"Low\"        }, {          \"FieloELR__AnswerOptionText__c\" : \"Dark\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1,          \"FieloELR__MatchingText__c\" : \"Clear\"        } ]      }, {        \"Name\" : \"MA-TM-Multiple Choice\",        \"FieloELR__CorrectWeight__c\" : 20.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 2,        \"FieloELR__PenaltyPerAttempt__c\" : 30.00,        \"FieloELR__QuestionText__c\" : \"These numbers can be arranged into a stacked triangle:\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Multiple Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"18\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"6\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"3\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-TM-Short Answer\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 3,        \"FieloELR__PenaltyPerAttempt__c\" : 50.00,        \"FieloELR__QuestionText__c\" : \"What is 4 x 9?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Short Answer\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"thirty-six\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"thirty six\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"36\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      }, {        \"Name\" : \"MA-TM-Single Choice\",        \"FieloELR__CorrectWeight__c\" : 10.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 1,        \"FieloELR__PenaltyPerAttempt__c\" : 50.00,        \"FieloELR__QuestionText__c\" : \"What is the name of the manual calculating device which consists of beads?\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Single Choice\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"Hibiscus\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 3        }, {          \"FieloELR__AnswerOptionText__c\" : \"Abacus\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 4        }, {          \"FieloELR__AnswerOptionText__c\" : \"Acarus\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        } ]      }, {        \"Name\" : \"MA-TM-Statement\",        \"FieloELR__CorrectWeight__c\" : 30.00,        \"FieloELR__IncorrectWeight__c\" : 0.00,        \"FieloELR__Order__c\" : 4,        \"FieloELR__PenaltyPerAttempt__c\" : 10.00,        \"FieloELR__QuestionText__c\" : \"We use a protractor to measure angles.\",        \"FieloELR__ShuffleAnswerOptions__c\" : false,        \"FieloELR__Type__c\" : \"Statement\",        \"answerOptions\" : [ {          \"FieloELR__AnswerOptionText__c\" : \"False\",          \"FieloELR__IsCorrect__c\" : false,          \"FieloELR__Order__c\" : 2        }, {          \"FieloELR__AnswerOptionText__c\" : \"True\",          \"FieloELR__IsCorrect__c\" : true,          \"FieloELR__Order__c\" : 1        } ]      } ]    } ]  } ]}",
      "FieloPLT__Type__c" : "Course"
    }, {
      "Name" : "Intermediate Course",
      "FieloPLT__Category__c" : "Miscelaneas",
      "FieloPLT__Icon__c" : "fielosf-icon-content",
      "FieloPLT__JSON__c" : "{  &quot;courses&quot; : [ {    &quot;reference&quot; : &quot;a0j6A0000006B3gQAE&quot;,    &quot;Name&quot; : &quot;Complete Course - Subscription Mode is Automatic&quot;,    &quot;FieloELR__Description__c&quot; : &quot;This is the second course to be completed&quot;,    &quot;FieloELR__SubscriptionMode__c&quot; : &quot;Automatic&quot;,    &quot;FieloELR__KeyDependencies__c&quot; : &quot;a0j6A00000060TXQAY&quot;,    &quot;predecessors&quot; : [ {      &quot;courseName&quot; : &quot;Complete Course - Subscription Mode is Manual&quot;    } ],    &quot;modules&quot; : [ {      &quot;reference&quot; : &quot;a0m6A000001F0b8QAC&quot;,      &quot;Name&quot; : &quot;AU-First Module&quot;,      &quot;FieloELR__ApprovalGrade__c&quot; : 50.00,      &quot;FieloELR__Description__c&quot; : &quot;This is the first module to be completed&quot;,      &quot;FieloELR__Order__c&quot; : 1,      &quot;FieloELR__PenaltyMode__c&quot; : &quot;Percent Decrease&quot;,      &quot;FieloELR__ShuffleQuestions__c&quot; : false,      &quot;FieloELR__WeightedQuestions__c&quot; : true,      &quot;questions&quot; : [ {        &quot;Name&quot; : &quot;AU-FM-Matching Options&quot;,        &quot;FieloELR__CorrectWeight__c&quot; : 30.00,        &quot;FieloELR__IncorrectWeight__c&quot; : 0.00,        &quot;FieloELR__Order__c&quot; : 4,        &quot;FieloELR__PenaltyPerAttempt__c&quot; : 10.00,        &quot;FieloELR__QuestionText__c&quot; : &quot;Match the values&quot;,        &quot;FieloELR__ShuffleAnswerOptions__c&quot; : false,        &quot;FieloELR__Type__c&quot; : &quot;Matching Options&quot;,        &quot;answerOptions&quot; : [ {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;W&quot;,          &quot;FieloELR__IsCorrect__c&quot; : true,          &quot;FieloELR__Order__c&quot; : 2,          &quot;FieloELR__MatchingText__c&quot; : &quot;white&quot;        }, {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;Y&quot;,          &quot;FieloELR__IsCorrect__c&quot; : true,          &quot;FieloELR__Order__c&quot; : 1,          &quot;FieloELR__MatchingText__c&quot; : &quot;yellow&quot;        }, {          &quot;FieloELR__IsCorrect__c&quot; : false,          &quot;FieloELR__Order__c&quot; : 3,          &quot;FieloELR__MatchingText__c&quot; : &quot;black&quot;        } ]      }, {        &quot;Name&quot; : &quot;AU-FM-Multiple Choice&quot;,        &quot;FieloELR__CorrectWeight__c&quot; : 10.00,        &quot;FieloELR__IncorrectWeight__c&quot; : 0.00,        &quot;FieloELR__Order__c&quot; : 3,        &quot;FieloELR__PenaltyPerAttempt__c&quot; : 50.00,        &quot;FieloELR__QuestionText__c&quot; : &quot;What is the smallest prime number?&quot;,        &quot;FieloELR__ShuffleAnswerOptions__c&quot; : false,        &quot;FieloELR__Type__c&quot; : &quot;Multiple Choice&quot;,        &quot;answerOptions&quot; : [ {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;2&quot;,          &quot;FieloELR__IsCorrect__c&quot; : true,          &quot;FieloELR__Order__c&quot; : 1        }, {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;1&quot;,          &quot;FieloELR__IsCorrect__c&quot; : false,          &quot;FieloELR__Order__c&quot; : 2        }, {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;3&quot;,          &quot;FieloELR__IsCorrect__c&quot; : false,          &quot;FieloELR__Order__c&quot; : 3        } ]      }, {        &quot;Name&quot; : &quot;AU-FM-Short Answer&quot;,        &quot;FieloELR__CorrectWeight__c&quot; : 30.00,        &quot;FieloELR__IncorrectWeight__c&quot; : 0.00,        &quot;FieloELR__Order__c&quot; : 5,        &quot;FieloELR__PenaltyPerAttempt__c&quot; : 10.00,        &quot;FieloELR__QuestionText__c&quot; : &quot;Who is the current number one on Men&amp;#39;s Tennis ATP Rankings?&quot;,        &quot;FieloELR__ShuffleAnswerOptions__c&quot; : false,        &quot;FieloELR__Type__c&quot; : &quot;Short Answer&quot;,        &quot;answerOptions&quot; : [ {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;Andy Murray&quot;,          &quot;FieloELR__IsCorrect__c&quot; : true,          &quot;FieloELR__Order__c&quot; : 1        }, {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;Murray&quot;,          &quot;FieloELR__IsCorrect__c&quot; : true,          &quot;FieloELR__Order__c&quot; : 2        } ]      }, {        &quot;Name&quot; : &quot;AU-FM-Single Choice&quot;,        &quot;FieloELR__CorrectWeight__c&quot; : 20.00,        &quot;FieloELR__IncorrectWeight__c&quot; : 0.00,        &quot;FieloELR__Order__c&quot; : 2,        &quot;FieloELR__PenaltyPerAttempt__c&quot; : 30.00,        &quot;FieloELR__QuestionText__c&quot; : &quot;What&amp;#39;s the color of napoleon&amp;#39;s white horse?&quot;,        &quot;FieloELR__ShuffleAnswerOptions__c&quot; : false,        &quot;FieloELR__Type__c&quot; : &quot;Single Choice&quot;,        &quot;answerOptions&quot; : [ {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;Black&quot;,          &quot;FieloELR__IsCorrect__c&quot; : false,          &quot;FieloELR__Order__c&quot; : 2        }, {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;White&quot;,          &quot;FieloELR__IsCorrect__c&quot; : true,          &quot;FieloELR__Order__c&quot; : 1        }, {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;Gray&quot;,          &quot;FieloELR__IsCorrect__c&quot; : false,          &quot;FieloELR__Order__c&quot; : 3        } ]      }, {        &quot;Name&quot; : &quot;AU-FM-Statement&quot;,        &quot;FieloELR__CorrectWeight__c&quot; : 10.00,        &quot;FieloELR__IncorrectWeight__c&quot; : 0.00,        &quot;FieloELR__Order__c&quot; : 1,        &quot;FieloELR__PenaltyPerAttempt__c&quot; : 50.00,        &quot;FieloELR__QuestionText__c&quot; : &quot;Say if it&amp;#39;s true or false.&quot;,        &quot;FieloELR__ShuffleAnswerOptions__c&quot; : false,        &quot;FieloELR__Type__c&quot; : &quot;Statement&quot;,        &quot;answerOptions&quot; : [ {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;False&quot;,          &quot;FieloELR__IsCorrect__c&quot; : false,          &quot;FieloELR__Order__c&quot; : 2        }, {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;True&quot;,          &quot;FieloELR__IsCorrect__c&quot; : true,          &quot;FieloELR__Order__c&quot; : 1        } ]      } ]    }, {      &quot;reference&quot; : &quot;a0m6A000001F0iAQAS&quot;,      &quot;Name&quot; : &quot;AU-Second Module&quot;,      &quot;FieloELR__ApprovalGrade__c&quot; : 50.00,      &quot;FieloELR__AttemptsAllowedPerQuestion__c&quot; : 3,      &quot;FieloELR__AttemptsAllowed__c&quot; : 3,      &quot;FieloELR__Order__c&quot; : 2,      &quot;FieloELR__PenaltyMode__c&quot; : &quot;Negative Weight&quot;,      &quot;FieloELR__ShuffleQuestions__c&quot; : false,      &quot;FieloELR__WeightedQuestions__c&quot; : true,      &quot;questions&quot; : [ {        &quot;Name&quot; : &quot;AU-SM-Multiple Choice&quot;,        &quot;FieloELR__CorrectWeight__c&quot; : 10.00,        &quot;FieloELR__IncorrectWeight__c&quot; : -2.00,        &quot;FieloELR__Order__c&quot; : 2,        &quot;FieloELR__PenaltyPerAttempt__c&quot; : 0.00,        &quot;FieloELR__QuestionText__c&quot; : &quot;How many sides does a decagon have?&quot;,        &quot;FieloELR__ShuffleAnswerOptions__c&quot; : false,        &quot;FieloELR__Type__c&quot; : &quot;Multiple Choice&quot;,        &quot;answerOptions&quot; : [ {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;12&quot;,          &quot;FieloELR__IsCorrect__c&quot; : false,          &quot;FieloELR__Order__c&quot; : 2        }, {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;10&quot;,          &quot;FieloELR__IsCorrect__c&quot; : true,          &quot;FieloELR__Order__c&quot; : 1        }, {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;8&quot;,          &quot;FieloELR__IsCorrect__c&quot; : false,          &quot;FieloELR__Order__c&quot; : 3        } ]      }, {        &quot;Name&quot; : &quot;AU-SM-Single Choice&quot;,        &quot;FieloELR__CorrectWeight__c&quot; : 10.00,        &quot;FieloELR__IncorrectWeight__c&quot; : -2.00,        &quot;FieloELR__Order__c&quot; : 3,        &quot;FieloELR__PenaltyPerAttempt__c&quot; : 0.00,        &quot;FieloELR__QuestionText__c&quot; : &quot;What is one sixth of 6?&quot;,        &quot;FieloELR__ShuffleAnswerOptions__c&quot; : false,        &quot;FieloELR__Type__c&quot; : &quot;Single Choice&quot;,        &quot;answerOptions&quot; : [ {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;1&quot;,          &quot;FieloELR__IsCorrect__c&quot; : true,          &quot;FieloELR__Order__c&quot; : 1        }, {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;36&quot;,          &quot;FieloELR__IsCorrect__c&quot; : false,          &quot;FieloELR__Order__c&quot; : 2        }, {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;16&quot;,          &quot;FieloELR__IsCorrect__c&quot; : false,          &quot;FieloELR__Order__c&quot; : 3        } ]      }, {        &quot;Name&quot; : &quot;AU-SM-Statement&quot;,        &quot;FieloELR__CorrectWeight__c&quot; : 10.00,        &quot;FieloELR__IncorrectWeight__c&quot; : -2.00,        &quot;FieloELR__Order__c&quot; : 1,        &quot;FieloELR__PenaltyPerAttempt__c&quot; : 0.00,        &quot;FieloELR__QuestionText__c&quot; : &quot;20% of 2 is equal to 0.4&quot;,        &quot;FieloELR__ShuffleAnswerOptions__c&quot; : false,        &quot;FieloELR__Type__c&quot; : &quot;Statement&quot;,        &quot;answerOptions&quot; : [ {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;True&quot;,          &quot;FieloELR__IsCorrect__c&quot; : true,          &quot;FieloELR__Order__c&quot; : 1        }, {          &quot;FieloELR__AnswerOptionText__c&quot; : &quot;False&quot;,          &quot;FieloELR__IsCorrect__c&quot; : false,          &quot;FieloELR__Order__c&quot; : 2        } ]      } ]    } ]  } ]}",
      "FieloPLT__Type__c" : "Course"
    } ],
    "pageSettings" : [ {
      "Name" : "Course Status > View",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"Name\"},  {\"Name\":\"FieloELR__Course__r.Name\"}, {\"Name\":\"FieloELR__Member__r.Name\"}, {\"Name\":\"FieloELR__Progress__c\"}",
      "FieloPLT__Object__c" : "FieloELR__CourseStatus__c",
      "FieloPLT__StandardActions__c" : "Delete;View;Settings",
      "FieloPLT__Type__c" : "View"
    }, {
      "Name" : "Question > View",
      "FieloPLT__Buttons__c" : "{\"Label\":\"Edit\",\"Type\":\"Modal\",\"Action\":\"FieloELR__Question__cForm-multiplechoice\"}",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"FieloELR__Type__c\"}, {\"Name\":\"FieloELR__Module__r.Name\"}",
      "FieloPLT__Object__c" : "FieloELR__Question__c",
      "FieloPLT__StandardActions__c" : "Delete;View;Settings",
      "FieloPLT__Type__c" : "View"
    }, {
      "Name" : "Answer Option > Edit",
      "FieloPLT__Object__c" : "FieloELR__AnswerOption__c",
      "FieloPLT__Sections__c" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":[\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Order__c\", \"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__AnswerOptionText__c\", \"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__IsCorrect__c\", \"Type\":\"checkbox\"}\r\n\t\t]\r\n\t]\r\n}",
      "FieloPLT__Type__c" : "Edit"
    }, {
      "Name" : "Module > Related > Module Dependency",
      "FieloPLT__Actions__c" : "{\"Label\":\"Delete\",\"Type\":\"Remote\",\"Action\":\"FieloELR.RelatedListController.deleteRecord\",\"CssClass\":\"slds-button--destructive\",\"Confirm\":true}",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"FieloELR__Predecessor__r.Name\"}",
      "FieloPLT__Object__c" : "FieloELR__Module__c",
      "FieloPLT__OrderBy__c" : "Name",
      "FieloPLT__Order__c" : 2,
      "FieloPLT__Sections__c" : "{ \t\"Name\":\"Information\", \t\"Rows\": \t[ \t\t[ \t\t\t{\"Name\":\"FieloELR__Module__c\",\"Type\":\"lookup\"} \t\t], \t\t[ \t\t\t{\"Name\":\"FieloELR__Predecessor__c\",\"Type\":\"lookup\"} \t\t] \t] }",
      "FieloPLT__StandardActions__c" : "New",
      "FieloPLT__TargetField__c" : "FieloELR__Module__c",
      "FieloPLT__TargetObject__c" : "FieloELR__ModuleDependency__c",
      "FieloPLT__Type__c" : "Related"
    }, {
      "Name" : "Course Dependency > Edit",
      "FieloPLT__Object__c" : "FieloELR__CourseDependency__c",
      "FieloPLT__Sections__c" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":\r\n\t[\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Course__c\",\"Type\":\"lookup\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Predecessor__c\",\"Type\":\"lookup\"}\r\n\t\t]\r\n\t]\r\n}",
      "FieloPLT__Type__c" : "Edit"
    }, {
      "Name" : "Course > Landing",
      "FieloPLT__Buttons__c" : "{'Label': 'New', 'Type': 'Modal', 'Action': 'FieloELR__Course__cForm' }",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"FieloELR__SubscriptionMode__c\"},{\"Name\":\"FieloELR__Status__c\"},{\"Name\":\"FieloELR__Program__r.Name\"}",
      "FieloPLT__Object__c" : "FieloELR__Course__c",
      "FieloPLT__StandardActions__c" : "View;Settings",
      "FieloPLT__Type__c" : "Landing"
    }, {
      "Name" : "Course > New",
      "FieloPLT__Object__c" : "FieloELR__Course__c",
      "FieloPLT__Sections__c" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":\r\n\t[\r\n\t\t[\r\n\t\t\t{\"Name\":\"Name\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Program__c\",\"Type\":\"lookup\",\"onchange\":\"RefreshSegments\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Segment__c\",\"Type\":\"multiselect\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__SubscriptionMode__c\",\"Type\":\"radio\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Description__c\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__StartDate__c\",\"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"FieloELR__EndDate__c\",\"Type\":\"input\"}\r\n\t\t]\r\n\t]\r\n}, \r\n{ \"Name\": \"Model\", \"Rows\": [[ { \"Label\": \"Course\", \"Type\": \"model\" }]]}",
      "FieloPLT__Type__c" : "New"
    }, {
      "Name" : "Course > Related > Module",
      "FieloPLT__Actions__c" : "{\"Label\":\"Delete\",\"Type\":\"Remote\",\"Action\":\"FieloELR.RelatedListController.deleteRecord\",\"CssClass\":\"slds-button--destructive\",\"Confirm\":true}",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"FieloELR__ApprovalGrade__c\"},\r\n{\"Name\":\"FieloELR__IsActive__c\"},\r\n{\"Name\":\"FieloELR__Order__c\"},\r\n{\"Name\":\"FieloELR__PenaltyMode__c\"},\r\n{\"Name\":\"FieloELR__QuestionPool__c\"},\r\n{\"Name\":\"FieloELR__WeightedQuestions__c\"}",
      "FieloPLT__Object__c" : "FieloELR__Course__c",
      "FieloPLT__OrderBy__c" : "FieloELR__Order__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__StandardActions__c" : "Edit;New",
      "FieloPLT__TargetField__c" : "FieloELR__Course__c",
      "FieloPLT__TargetObject__c" : "FieloELR__Module__c",
      "FieloPLT__Type__c" : "Related"
    }, {
      "Name" : "Course > Edit",
      "FieloPLT__Object__c" : "FieloELR__Course__c",
      "FieloPLT__Sections__c" : "{ \t\r\n\t\"Name\":\"Information\",\r\n \t\"Rows\": \t\r\n\t[ \t\t\r\n\t\t[ \t\t\t\r\n\t\t\t{\"Name\":\"Name\",\"Type\":\"input\"}\r\n \t\t], \t\t\r\n\t\t[ \t\t\t\t\t\t\t\t\t{\"Name\":\"FieloELR__Program__c\",\"Type\":\"lookup\"}\r\n \t\t],\r\n \t\t[ \t\t\t\t\t\t\t\t\t{\"Name\":\"FieloELR__Segment__c\",\"Type\":\"multiselect\"}\r\n \t\t],\r\n \t\t[ \t\t\t\t\t\t{\"Name\":\"FieloELR__SubscriptionMode__c\",\"Type\":\"radio\"}\r\n\t\t],\r\n \t\t[ \t\t\t\t\t\t{\"Name\":\"FieloELR__Description__c\",\"Type\":\"input\"}\r\n \t\t],\r\n \t\t[ \t\t\t\t\t\t{\"Name\":\"FieloELR__StartDate__c\",\"Type\":\"input\"},\r\n \t\t\t{\"Name\":\"FieloELR__EndDate__c\",\"Type\":\"input\"}\r\n \t\t]\r\n \t]\r\n}",
      "FieloPLT__Type__c" : "Edit"
    }, {
      "Name" : "Course > View",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"Name\"}, {\"Name\":\"FieloELR__Program__r.Name\"}, {\"Name\":\"FieloELR__Status__c\"}, {\"Name\":\"FieloELR__Segment__r.Name\"}, {\"Name\":\"FieloELR__StartDate__c\"}, {\"Name\":\"FieloELR__EndDate__c\"}",
      "FieloPLT__Object__c" : "FieloELR__Course__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__StandardActions__c" : "Edit;Delete;View;Settings",
      "FieloPLT__Type__c" : "View"
    }, {
      "Name" : "Course > Related > Course Dependency",
      "FieloPLT__Actions__c" : "{\"Label\":\"Delete\",\"Type\":\"Remote\",\"Action\":\"FieloELR.RelatedListController.deleteRecord\",\"CssClass\":\"slds-button--destructive\",\"Confirm\":true}",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"FieloELR__Predecessor__r.Name\"}",
      "FieloPLT__Object__c" : "FieloELR__Course__c",
      "FieloPLT__OrderBy__c" : "Name",
      "FieloPLT__Order__c" : 2,
      "FieloPLT__Sections__c" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":\r\n\t[\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Course__c\",\"Type\":\"lookup\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Predecessor__c\",\"Type\":\"lookup\"}\r\n\t\t]\r\n\t]\r\n}",
      "FieloPLT__StandardActions__c" : "New",
      "FieloPLT__TargetField__c" : "FieloELR__Course__c",
      "FieloPLT__TargetObject__c" : "FieloELR__CourseDependency__c",
      "FieloPLT__Type__c" : "Related"
    }, {
      "Name" : "Course Dependency > New",
      "FieloPLT__Object__c" : "FieloELR__CourseDependency__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__Sections__c" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":\r\n\t[\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Course__c\",\"Type\":\"lookup\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Predecessor__c\",\"Type\":\"lookup\"}\r\n\t\t]\r\n\t]\r\n}",
      "FieloPLT__Type__c" : "New"
    }, {
      "Name" : "Module > New",
      "FieloPLT__Object__c" : "FieloELR__Module__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__Sections__c" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":\r\n\t[\r\n\t\t[\r\n\t\t\t{\"Name\":\"Name\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Description__c\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Course__c\",\"Type\":\"lookup\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__ApprovalGrade__c\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__AttemptsAllowed__c\",\"Type\":\"input\"}\r\n\t\t]\r\n\t]\r\n}",
      "FieloPLT__Type__c" : "New"
    }, {
      "Name" : "Module Dependency > Edit",
      "FieloPLT__Object__c" : "FieloELR__ModuleDependency__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__Sections__c" : "{ \t\"Name\":\"Information\", \t\"Rows\": \t[ \t\t[ \t\t\t{\"Name\":\"FieloELR__Module__c\",\"Type\":\"lookup\"} \t\t], \t\t[ \t\t\t{\"Name\":\"FieloELR__Predecessor__c\",\"Type\":\"lookup\"} \t\t] \t] }",
      "FieloPLT__Type__c" : "Edit"
    }, {
      "Name" : "Module Dependency > New",
      "FieloPLT__Object__c" : "FieloELR__ModuleDependency__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__Sections__c" : "{ \t\"Name\":\"Information\", \t\"Rows\": \t[ \t\t[ \t\t\t{\"Name\":\"FieloELR__Module__c\",\"Type\":\"lookup\"} \t\t], \t\t[ \t\t\t{\"Name\":\"FieloELR__Predecessor__c\",\"Type\":\"lookup\"} \t\t] \t] }",
      "FieloPLT__Type__c" : "New"
    }, {
      "Name" : "Module > Related > Question",
      "FieloPLT__Actions__c" : "{\"Label\":\"Edit\",\"Type\":\"Modal\",\"Action\":\"FieloELR__Question__cForm-multiplechoice\"},{\"Label\":\"Delete\",\"Type\":\"Remote\",\"Action\":\"FieloELR.RelatedListController.deleteRecord\",\"CssClass\":\"slds-button--destructive\",\"Confirm\":true}",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"FieloELR__Type__c\"},\r\n{\"Name\":\"FieloELR__QuestionText__c\"},\r\n{\"Name\":\"FieloELR__PenaltyPerAttempt__c\"},\r\n{\"Name\":\"FieloELR__CorrectWeight__c\"},\r\n{\"Name\":\"FieloELR__IncorrectWeight__c\"},\r\n{\"Name\":\"FieloELR__Order__c\"},\r\n{\"Name\":\"FieloELR__ShuffleAnswerOptions__c\"}",
      "FieloPLT__Object__c" : "FieloELR__Module__c",
      "FieloPLT__OrderBy__c" : "FieloELR__Order__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__StandardActions__c" : "New",
      "FieloPLT__TargetField__c" : "FieloELR__Module__c",
      "FieloPLT__TargetObject__c" : "FieloELR__Question__c",
      "FieloPLT__Type__c" : "Related"
    }, {
      "Name" : "Module > Edit",
      "FieloPLT__Object__c" : "FieloELR__Module__c",
      "FieloPLT__Sections__c" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\": [ \t\t\r\n\t\t\t[ \t\t\t\r\n\t\t\t\t{\"Name\":\"Name\",\"Type\":\"input\"} \t\t\r\n\t\t\t],\r\n\t\t\t[\r\n\t\t\t\t{\"Name\":\"FieloELR__Description__c\",\"Type\":\"input\"}\t\t\r\n\t\t\t],\r\n\t\t\t[\t\r\n\t\t\t\t{\"Name\":\"FieloELR__Course__c\",\"Type\":\"lookup\"}\r\n\t\t\t],\r\n\t\t\t[ \t\t\t\t\t\t\t\r\n\t\t\t\t{\"Name\":\"FieloELR__ApprovalGrade__c\",\"Type\":\"input\"}\t\t\t\t\r\n\t\t\t],\r\n\t\t\t[\r\n\t\t\t\t{\"Name\":\"FieloELR__AttemptsAllowed__c\",\"Type\":\"input\"}\r\n\t\t\t]\r\n\t] \r\n}",
      "FieloPLT__Type__c" : "Edit"
    }, {
      "Name" : "Module > View",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"Name\"},  {\"Name\":\"FieloELR__Course__r.Name\"}, {\"Name\":\"FieloELR__IsActive__c\"}, {\"Name\":\"FieloELR__WeightedQuestions__c\"}, {\"Name\":\"FieloELR__PenaltyMode__c\"}",
      "FieloPLT__Object__c" : "FieloELR__Module__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__StandardActions__c" : "Edit;Delete;View;Settings",
      "FieloPLT__Type__c" : "View"
    }, {
      "Name" : "Question > Edit",
      "FieloPLT__Object__c" : "FieloELR__Question__c",
      "FieloPLT__Sections__c" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":[\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Module__c\",\"Type\":\"lookup\"},\r\n\t\t\t{\"Name\":\"Name\",\"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"FieloELR__ShuffleAnswerOptions__c\",\"Type\":\"checkbox\"},\r\n\t\t\t{\"Name\":\"FieloELR__CorrectWeight__c\",\"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"FieloELR__IncorrectWeight__c\",\"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"FieloELR__PenaltyPerAttempt__c\",\"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"FieloELR__Type__c\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__QuestionText__c\",\"Type\":\"input\"}\r\n\t\t]\r\n\t]\r\n}",
      "FieloPLT__Type__c" : "Edit"
    }, {
      "Name" : "Question > Related > Answer Option",
      "FieloPLT__Fieldset__c" : "{'Name':'FieloELR__IsCorrect__c', 'Type':'checkbox'},{'Name':'FieloELR__Order__c', 'Type': 'input'},{'Name':'FieloELR__AnswerOptionText__c', 'Type':'input'},\r\n{'Name':'FieloELR__MatchingText__c', 'Type':'input'}",
      "FieloPLT__Object__c" : "FieloELR__Question__c",
      "FieloPLT__OrderBy__c" : "FieloELR__Order__c",
      "FieloPLT__Sections__c" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":\r\n\t[\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__QuestionText__c\", \"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__CorrectWeight__c\", \"Type\":\"input\"}, \r\n\t\t\t{\"Name\":\"FieloELR__PenaltyPerAttempt__c\", \"Type\":\"input\"}, \r\n\t\t\t{\"Name\":\"FieloELR__IncorrectWeight__c\", \"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Order__c\", \"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"FieloELR__ShuffleAnswerOptions__c\", \"Type\":\"checkbox\"}\r\n\t\t]\r\n\t]\r\n}",
      "FieloPLT__TargetField__c" : "FieloELR__Question__c",
      "FieloPLT__TargetObject__c" : "FieloELR__AnswerOption__c",
      "FieloPLT__Type__c" : "Related"
    }, {
      "Name" : "Question > Detail",
      "FieloPLT__Object__c" : "FieloELR__Question__c",
      "FieloPLT__Sections__c" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":\r\n\t[\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__QuestionText__c\", \"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__CorrectWeight__c\", \"Type\":\"input\"}, \r\n\t\t\t{\"Name\":\"FieloELR__PenaltyPerAttempt__c\", \"Type\":\"input\"}, \r\n\t\t\t{\"Name\":\"FieloELR__IncorrectWeight__c\", \"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Order__c\", \"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"FieloELR__ShuffleAnswerOptions__c\", \"Type\":\"checkbox\"}\r\n\t\t]\r\n\t]\r\n}",
      "FieloPLT__Type__c" : "Detail"
    }, {
      "Name" : "Course > Detail",
      "FieloPLT__Object__c" : "FieloELR__Course__c",
      "FieloPLT__Sections__c" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":\r\n\t[\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__SubscriptionMode__c\",\"Type\":\"picklist\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Description__c\",\"Type\":\"input\"}\r\n\t\t]\r\n\t]\r\n}",
      "FieloPLT__Type__c" : "Detail"
    }, {
      "Name" : "Module > Detail",
      "FieloPLT__Object__c" : "FieloELR__Module__c",
      "FieloPLT__Sections__c" : "{\r\n\t\"Name\":\"Information\",\r\n\t\"Rows\":\r\n\t[\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__Description__c\",\"Type\":\"input\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__ApprovalGrade__c\",\"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"FieloELR__QuestionPool__c\",\"Type\":\"checkbox\"}\r\n\t\t],\r\n\t\t[\r\n\t\t\t{\"Name\":\"FieloELR__AttemptsAllowed__c\",\"Type\":\"input\"},\r\n\t\t\t{\"Name\":\"FieloELR__AttemptsAllowedPerQuestion__c\",\"Type\":\"input\"}\r\n\t\t]\r\n\t]\r\n}",
      "FieloPLT__Type__c" : "Detail"
    }, {
      "Name" : "Module > Related > Module Response",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"FieloELR__Date__c\"},  {\"Name\":\"FieloELR__GradePercent__c\"},  {\"Name\":\"FieloELR__IsApproved__c\"},  {\"Name\":\"FieloELR__IsSubmitted__c\"}, {\"Name\":\"FieloELR__NumberOfAttempt__c\"}, {\"Name\":\"FieloELR__NumberofApprove__c\"}",
      "FieloPLT__Object__c" : "FieloELR__Module__c",
      "FieloPLT__Order__c" : 3,
      "FieloPLT__TargetField__c" : "FieloELR__Module__c",
      "FieloPLT__TargetObject__c" : "FieloELR__ModuleResponse__c",
      "FieloPLT__Type__c" : "Related"
    }, {
      "Name" : "Course Status > Related > Module Response",
      "FieloPLT__Actions__c" : "{\"Label\":\"Delete\",\"Type\":\"Remote\",\"Action\":\"FieloELR.RelatedListController.deleteRecord\",\"CssClass\":\"slds-button--destructive\",\"Confirm\":true}",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"FieloELR__Module__r.Name\"},{\"Name\":\"FieloELR__Date__c\"},  {\"Name\":\"FieloELR__GradePercent__c\"},  {\"Name\":\"FieloELR__IsApproved__c\"},  {\"Name\":\"FieloELR__IsSubmitted__c\"}, {\"Name\":\"FieloELR__NumberOfAttempt__c\"}, {\"Name\":\"FieloELR__NumberofApprove__c\"}",
      "FieloPLT__Object__c" : "FieloELR__CourseStatus__c",
      "FieloPLT__OrderBy__c" : "FieloELR__Date__c",
      "FieloPLT__Order__c" : 1,
      "FieloPLT__Sections__c" : "{ \t\"Name\":\"Information\", \t\"Rows\": \t[ \t\t[ \t\t\t{\"Name\":\"Name\",\"Type\":\"input\"} \t\t], \t\t[ \t\t\t{\"Name\":\"FieloELR__CourseStatus__c\",\"Type\":\"lookup\"} \t\t], \t\t[ {\"Name\":\"FieloELR__Date__c\",\"Type\":\"input\"},\t \t\t{\"Name\":\"FieloELR__GradePercent__c\",\"Type\":\"input\"} \t\t], \t\t[ {\"Name\":\"FieloELR__IsApproved__c\",\"Type\":\"checkbox\"}, {\"Name\":\"FieloELR__IsSubmitted__c\",\"Type\":\"checkbox\"}, \t\t], \t\t[ {\"Name\":\"FieloELR__NumberOfAttempt__c\",\"Type\":\"input\"},\t\t\t {\"Name\":\"FieloELR__NumberOFApprove__c\",\"Type\":\"picklist\"} \t\t] \t] }",
      "FieloPLT__TargetField__c" : "FieloELR__CourseStatus__c",
      "FieloPLT__TargetObject__c" : "FieloELR__ModuleResponse__c",
      "FieloPLT__Type__c" : "Related"
    }, {
      "Name" : "Course > Related > Course Status",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"FieloELR__Progress__c\"}",
      "FieloPLT__Object__c" : "FieloELR__Course__c",
      "FieloPLT__Order__c" : 3,
      "FieloPLT__TargetField__c" : "FieloELR__Course__c",
      "FieloPLT__TargetObject__c" : "FieloELR__CourseStatus__c",
      "FieloPLT__Type__c" : "Related"
    }, {
      "Name" : "Module Response > View",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"Name\"},  {\"Name\":\"FieloELR__CourseStatus__r.Name\"}, {\"Name\":\"FieloELR__Module__r.Name\"}, {\"Name\":\"FieloELR__Member__r.Name\"}, {\"Name\":\"FieloELR__GradePercent__c\"}, {\"Name\":\"FieloELR__IsApproved__c\"}, {\"Name\":\"FieloELR__IsSubmitted__c\"}, {\"Name\":\"FieloELR__NumberofApprove__c\"}, {\"Name\":\"FieloELR__NumberOfAttempt__c\"}",
      "FieloPLT__Object__c" : "FieloELR__ModuleResponse__c",
      "FieloPLT__StandardActions__c" : "Delete;View;Settings",
      "FieloPLT__Type__c" : "View"
    }, {
      "Name" : "Module Response > Related > Question Response",
      "FieloPLT__Actions__c" : "{\"Label\":\"Delete\",\"Type\":\"Remote\",\"Action\":\"FieloELR.RelatedListController.deleteRecord\",\"CssClass\":\"slds-button--destructive\",\"Confirm\":true}",
      "FieloPLT__Fieldset__c" : "{\"Name\":\"FieloELR__Question__r.Name\"}, {\"Name\":\"FieloELR__IsCorrect__c\"},  {\"Name\":\"FieloELR__IsSubmitted__c\"},  {\"Name\":\"FieloELR__PartialGradeValue__c\"},  {\"Name\":\"FieloELR__NumberOfAttempt__c\"}",
      "FieloPLT__Object__c" : "FieloELR__ModuleResponse__c",
      "FieloPLT__OrderBy__c" : "FieloELR__Question__c",
      "FieloPLT__Sections__c" : "{ \t\"Name\":\"Information\", \t\"Rows\": \t[ \t\t[ \t\t\t{\"Name\":\"Name\",\"Type\":\"input\"} \t\t], \t\t[ {\"Name\":\"FieloELR__ModuleStatus__c\",\"Type\":\"lookup\"}, {\"Name\":\"FieloELR__Question__c\",\"Type\":\"lookup\"} \t\t], \t\t[ {\"Name\":\"FieloELR__IsCorrect__c\",\"Type\":\"checkbox\"}, {\"Name\":\"FieloELR__IsSubmitted__c\",\"Type\":\"checkbox\"}, \t\t], \t\t[ {\"Name\":\"FieloELR__PartialGradeValue__c\",\"Type\":\"input\"},\t\t\t {\"Name\":\"FieloELR__NumberOfAttempt__c\",\"Type\":\"input\"} \t\t] \t] }",
      "FieloPLT__TargetField__c" : "FieloELR__ModuleResponse__c",
      "FieloPLT__TargetObject__c" : "FieloELR__QuestionResponse__c",
      "FieloPLT__Type__c" : "Related"
    } ]
  } ]
}