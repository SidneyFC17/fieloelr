# ELR Functional Documentation
## Creating the course
In the Courses Landing Page, click the New button and fill in the fields below:
 - **Course Name** - This field has a maximum limit of 80 characters.
 - **Program** - By default, this field is automatically filled with the program already chosen in the Program selector. If there is more than one program, the administrator can select another one. If the field is left in blank, it wil be set automatically to the program already chosen in the Program selector.
 - **Segment** - Select in the left area the segments that must apply for the course, so that only members that match the conditions under the segments are elegible to join the course. After selecting each desired segment, press the right arrow.
 - **Subscription Mode** - When selecting the *Manual* option, the member is required to subscribe the Course before taking any of its modules. Selecting *Automatic* option, allows the member to directly take any of the modules, respecting their dependencies. In case that the Automatic subscription mode is selected, the system automatically subscribes the member to the course.
 > In the CMS, the **Manual** subscription mode will is represented by a Join action button for the course. If the member tries to take a module before joining the course, he'll receive a message. For the **Automatic** subscription mode, the course has a View action button. The course is joined automatically when the member presses the Take button of the one of its modules. 
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
- **Answer Option Text** - For the Multiple Choice questions, the answer option text fields represent the alternatives of answers that will be displayed for the member. 
 > In the CMS, these alternatives are preceded by checkboxes, enabling the member to select one or more answers.
- **Is Correct** - When set to "true", indicates that the answer option is correct. When set to "false", indicates that the answer is not correct.  

:point_right: 1. It's possible to create as many answer option text fields as desired by clicking the New button in the right upper corner of the Answer Options frame.  
:point_right: 2. It's possible to reorder the answer option text fields and their corresponding corrections by dragging them and dropping them in the desired order.




