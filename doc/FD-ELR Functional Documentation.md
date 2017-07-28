# ELR Functional Documentation
## Creating the course
In the Courses Landing Page, click the New button and fill in the fields below:
 - **Course Name** - This field has a maximum limit of 80 characters.
 - **Program** - By default, this field is automatically filled with the program already chosen in the Program selector. If there is more than one program, the administrator can select another one. If the field is left in blank, it wil be set automatically to the program already chosen in the Program selector.
 - **Segment** - Select in the left area the segments that must apply for the course, so that only members that match the conditions under the segments are elegible to join the course. After selecting each desired segment, press the right arrow.
 - **Subscription Mode** - When selecting the *Manual* option, the member is required to subscribe the Course before taking any of its modules. Selecting *Automatic* option, allows the member to directly take any of the modules, respecting their dependencies. In case that the Automatic subscription mode is selected, the system automatically subscribes the member to the course.
 > At CMS, the **Manual** subscription mode will is represented by a Join action button for the course. If the member tries to take a module before joining the course, he'll receive a message. For the **Automatic** subscription mode, the course has a View action button. The course is joined automatically when the member presses the Take button of the one of its modules. 
 - **Description** - This field has a maximum limit of 255 characters.
 - **Start Date** - This field must be filled in if the course has a specific date to start. This date can not be earlier than the current date.
 - **End Date** - This field must be filled in if the course has a specific date to finish. This date can not be earlier than the current date nor earlier than the Start Date, if a period is defined.
 
 After pressing the Save button, the administrator will be directed to the course detail page, Where he can proceed with the creation of course structure. 

## Creating the modules
In the Course details page, go to the Modules related list and click the New button. Fill in the following fields:
- **Module Name** - This field has a maximum limit of 80 characters.
- **Description** - This field has a maximum limit of 255 characters.
- **Approval Grade** - This is the minimum percentage of module grade that member should receive in order to be approved, after finishing the module. This value may vary from 0 to 100.
- **Attempts Allowed** - Number of attempts that member can take the module. If left blank, this means that the member can resume the module indefinitely, until the course is inactivated or has reached its end date.

 After pressing the Save button, the administrator will be directed to the module detail page. At this point, the administrator can go back to the course details page to create the basic details for the remaining modules or stay on the module details page in order to continuing the module creation process, creating its questions and completing the residual settings.
 
## Creating the questions
 In the Module details page, go to the Questions related list and click the New button.
 The first page of the Question Wizard will be displayed for type selection.
 There are five types of questions:
- *Multiple Choice* - Multiple answer options can be defined as correct. 
- *Single Choice* - One and only one answer option can be defined as correct.  
  :point_right: If no answer option is defined as correct, the module can not be activated.
- *Short Answer* - In this type of question, all the possible answers for the question must be configured. For example, if you have a question that can be answered with a number, set as answer options the number written in figures, in word form, in capitals and so on. All the included answer options are automatically considered as correct, so there is no need to configure this.
- *Statement* - This type of question admits only two answer options: True or False. They cannot be changed, but they can have its correction defined.  
  :point_right: If no answer option is defined as correct, the module can not be activated.
- *Matching Options* - For each answer option, there is a matching pair. Each combination of answer option x matching pair is considered as correct. It's possible to set a matching pair without an answer option, in order to give the member more alternatives of combination. In this case, the combination of "no answer option" x "existing matching pair" is not considered as correct.
 
### Creating the Multiple Choice question
In the first page of the Question Wizard, select the *Multiple Choice* option and fill in the following fields:
- **Question Name** - This field is intended to identify the question. It has a maximum limit of 80 characters.  
  :point_right: If this field is left blank, the system will automatically set the Question Name field with the 20 first characters of the Question Text.
- **Shuffle Answer Options** - When this field is set to "true", the system will display the answer options in a different order each time the member makes a new allowed attempt for the question.
- **Question Text** - This is the wording of the question. This is a rich text field.
- **Answer Option Text** - For the Multiple Choice questions, the answer option text fields represent the alternatives of answers that will be displayed for the member. This field has a maximum limit of 255 characters.  
 > At CMS, these alternatives are preceded by checkboxes, enabling the member to select one or more answers.
- **Is Correct** - When set to "true", indicates that the answer option is correct. When set to "false", indicates that the answer is not correct.  

:point_right: 1. It's possible to create as many answer option text fields as desired by clicking the New button in the right upper corner of the Answer Options frame.  
:point_right: 2. Any of the included answer options can be removed by clicking the remove icon (:heavy_multiplication_x:) in its right side.  
:point_right: 3. It's possible to reorder the answer option text fields and their corresponding corrections by dragging them and dropping them in the desired order.

It's possible to press the **Save and new** button which saves the question and its answer options and automatically displays the first question wizard page or the **Save** button that saves all data and just refreshes the module details page.

### Creating the Single Choice question
In the first page of the Question Wizard, select the *Single Choice* option and fill in the following fields:
- **Question Name** - This field is intended to identify the question. It has a maximum limit of 80 characters.  
  :point_right: If this field is left blank, the system will automatically set the Question Name field with the 20 first characters of the Question Text.
- **Shuffle Answer Options** - When this field is set to "true", the system will display the answer options in a different order each time the member makes a new allowed attempt for the question.
- **Question Text** - This is the wording of the question. This is a rich text field.
- **Answer Option Text** - For the Single Choice questions, the answer option text fields represent the alternatives of answers that will be displayed for the member. This field has a maximum limit of 255 characters.  
 > At CMS, these alternatives are preceded by radio buttons, enabling the member to select only one answer.
- **Is Correct** - When set to "true", indicates that the answer option is correct. When set to "false", indicates that the answer is not correct.

:point_right: 1. As already mentioned, for Single Choice questions only one answer option can be defined as correct.  
:point_right: 2. It's possible to create as many answer option text fields as desired by clicking the New button in the right upper corner of the Answer Options frame.  
:point_right: 3. Any of the included answer options can be removed by clicking the remove icon (:heavy_multiplication_x:) in its right side.  
:point_right: 4. It's possible to reorder the answer option text fields and their corresponding corrections by dragging them and dropping them in the desired order.

It's possible to press the **Save and new** button which saves the question and its answer options and automatically displays the first question wizard page or the **Save** button that saves all data and just refreshes the module details page.

### Creating the Short Answer question
In the first page of the Question Wizard, select the *Short Answer* option and fill in the following fields:
- **Question Name** - This field is intended to identify the question. It has a maximum limit of 80 characters.  
  :point_right: If this field is left blank, the system will automatically set the Question Name field with the 20 first characters of the Question Text.
- **Question Text** - This is the wording of the question. This is a rich text field.
- **Answer Option Text** - For the Short Answer questions, the answer option text fields represent the possible ways of response. It must be included all the alternatives of answers that will be accepted as correct. This field has a maximum limit of 255 characters.  
 > At CMS, these alternatives are not shown, but a field for the member to input the answer.

:point_right: 1. In the Short Answer question, the option *Shuffle Answer Options* is not displayed since the answer options are not available to the member.  
:point_right: 2. In this type of question, the *Is Correct* field is not displayed as well, because all the answer options are automatically set as "true" by the system.  
:point_right: 3. It's possible to create as many answer option text fields as desired by clicking the New button in the right upper corner of the Answer Options frame.  
:point_right: 4. Any of the included answer options can be removed by clicking the remove icon (:heavy_multiplication_x:) in its right side.  
:point_right: 5. Since the answer options are not displayed to the member, the reorder functionality is not available for this type of question.

It's possible to press the **Save and new** button which saves the question and its answer options and automatically displays the first question wizard page or the **Save** button that saves all data and just refreshes the module details page.

### Creating the Statement question
In the first page of the Question Wizard, select the *Statement* option and fill in the following fields:
- **Question Name** - This field is intended to identify the question. It has a maximum limit of 80 characters.  
  :point_right: If this field is left blank, the system will automatically set the Question Name field with the 20 first characters of the Question Text.
- **Question Text** - This is the wording of the question. This is a rich text field.
- **Answer Option Text** - For the Statement questions, the two possible answer option text fields are automatically created: True and False.    
 > At CMS, these alternatives are preceded by radio buttons, enabling the member to select only one answer.
- **Is Correct** - When set to "true", indicates that the answer option is correct. When set to "false", indicates that the answer is not correct.

:point_right: In the Statement question, the option *Shuffle Answer Options* is not displayed.  

It's possible to press the **Save and new** button which saves the question and its answer options and automatically displays the first question wizard page or the **Save** button that saves all data and just refreshes the module details page.

### Creating the Matching Options question
In the first page of the Question Wizard, select the *Matching Options* option and fill in the following fields:
- **Question Name** - This field is intended to identify the question. It has a maximum limit of 80 characters.  
  :point_right: If this field is left blank, the system will automatically set the Question Name field with the 20 first characters of the Question Text.
- **Shuffle Answer Options** - When this field is set to "true", both answer option text and matching text fields will be randomly displayed by the system, at CMS. If set to "false", only the matching text fields will be randomly displayed.
- **Question Text** - This is the wording of the question. This is a rich text field.
- **Answer Option Text** - For the Matching Options questions, these fields represent the items that demand correlation. This field has a maximum limit of 255 characters.  
- **Matching Text** - These are the options that will be provided for correlation. This field has a maximum limit of 255 characters.
 
:point_right: 1. The system automatically sets to true the Is Correct field of the pairs having answer option text field filled in. On the other hand, pairs which have no answer option text field filled in have their Is Correct field set to "false".  
:point_right: 2. It's possible to create as many answer option text fields x matching text as desired by clicking the New button in the right upper corner of the Answer Options frame.  
:point_right: 3. It's possible to have pairs which contains only the matching text, but the opposite is not allowed.  
:point_right: 4. Any of the included answer options (meaning the pair answer option text x matching text) can be removed by clicking the remove icon (:heavy_multiplication_x:) in its right side.  
:point_right: 5. The reorder functionality is not available for this type of question.

It's possible to press the **Save and new** button which saves the question and its answer options and automatically displays the first question wizard page or the **Save** button that saves all data and just refreshes the module details page.

## Managing questions
By using this functionality, the administrator will be able to settle some configurations to the Module, define few Global Question setup and assign some parameters values to individual questions.

### Choosing the Penalty Mode
Every time the member incorrectly answers a question, the system may penalize him or not for the wrong answer. There are three possible ways to deal with wrong answers:

- **None**: In this mode, no penalty is applied to the member when he incorrectly answers a question. That means that his grade for that question will be 0 (zero) every time he answers wrongly. As soon as he answers the question correctly, the grade of the question will be the full value defined for the field *Correct Weight*. 
  - Example: Suppose that a question has a Correct Weight set to 10. If it has 3 (three) attempts allowed per question and the member incorrectly answers the first 2 (two) attempts and correctly answers the third one, he will have the following partial grades:  
    0 + 0 + 10 = 10
- **Percent Decrease**: In this mode, the member is penalized for each attempt when he gives an incorrect answer for the question. When he finally answers correctly, his grade is given by diminishing, for each wrong attempt, a percentage value of his partial grade.  
   When selecting this mode, the system enables the global question *Penalty per Attempt* field, allowing the administrator to give the same penalty value to all questions of the module. This option applies to a module with non weighted questions - all questions have the same *Correct Weight* that equals to 1 (one).  
   For the modules where each question needs to have different weights, the administrator has to set the *Weighted Questions* field to "true". This way, the system enables the fields *Correct Weight* and *Penalty per Attempt* for each individual question.  
   The value inputted in the Penalty per Attempt field (global or individual) defines the percentage value to be decreased and must be between 0 and 100. 
   
        The formula used to calculate the grade is:
              CW x (1 - PA (%)) ⌃ (AN - 1)
       where: 
       CW = Correct Weight
       PA = Penalty per Attempt
       AN = Attempt Number
  - Example 1: Weighted Questions is "false". Global Penalty per Attempt is 10. Three attempts allowed per question. The member incorrectly answers the first 2 (two) attempts and correctly answers the third one. He will have the following partial grades:  
    0 + 0 + 0.81 = 0.81

  - Example 2: Weighted Questions is "true". Correct Weight is 10. Individual Penalty per Attempt is 20. Three attempts allowed per question. The member incorrectly answers the first attempt and correctly answers the second one. He will have the following partial grades:  
   0 + 8 = 8  

:point_right: If the member incorrectly answers all attempts allowed, his grade will be 0 (zero).
- **Negative Weight**: In this mode, the member is immediately penalized for each attempt when he gives an incorrect answer for the question. For each attempt he will receive as partial grade:  
    Correct Weight - if the member correctly answers the question  
    Incorrect weight - if the member incorrectly answers the question  
When selecting this mode, the system enables the global question *Incorrect Weight* field, allowing the administrator to give the same incorrectness value to all questions of the module. This option applies to a module with non weighted questions - all questions have the same *Correct Weight* that equals to 1 (one).  
   For the modules where each question needs to have different weights, the administrator has to set the *Weighted Questions* field to "true". This way, the system enables the fields *Correct Weight* and *Incorrect Weight* for each individual question.  
   - Example 1: - Weighted Questions is "false". Global Incorrect Weight is -0.01. Three attempts allowed per question. The member incorrectly answers the first 2 (two) attempts and correctly answers the third one. He will have the following partial grades:  
    \- 0.01 - 0.01 + 1 = 0.98

   - Example 2: - Weighted Questions is "true". Correct Weight is 10. Individual Incorrect Weight is 0.5. Three attempts allowed per question. The member incorrectly answers the first attempt and correctly answers the second one. He will have the following partial grades:  
   0.5 + 10 = 10.5

### Setting the Attempts Allowed per Question


### Configuring the Question Pool


### Shuffling Questions


### Setting Weighetd Questions


### Ordering Questions


## Activating a Module

## Reordering Modules

## Creating Module Dependencies

## Activating a Course

## Creating Course Dependencies
