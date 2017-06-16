## Manage Questions
 
### Objectives
The present use case describes how the system displays the Manage Questions page
 
### Preconditions
- The administrator must be logged in
 
### Postconditions
- The system updated the changes on questions and module settings
 
### Flow of Events
 
### Basic Flow
   1.  The administrator goes to the Course view backend page
   2. The administrator presses the Name of the desired module
   3. The system displays the Module details page
   4. The administrator presses the Manage button on the Questions related list
   5. The system displays the Manage Questions page, containing the following fields:
       - Penalty Mode, with the options None, Percent Decrease and Negative Weight
       - Attempts Allowed per Question, with the options 1 to 10 and Unlimited
       - Question Pool
       - Shuffle Questions
       - Weighted Questions
       - Field in Global Question Setup area, according to previous selections
   6. The system displays the Questions area, containing the Name of questions, their types and questions text and other information, according to the questions settings
   7. The system displays the Cancel and Save buttons
   8. End of flow
 
##### 1. Reorder questions (step 6 of basic flow)
   1. The system verifies that the Question Pool field is null
   2. The system verifies that the Shuffle Questions field is set to false
   3. The administrator uses the drag&drop functionality in the Questions area to position the question in the desired order
   4. The administrator presses the Save button
   5. The system sets the Order field of each question as defined by the administrator in the Manage Questions page
   6. End of flow
 
##### 2. Weighted Questions is true and Penalty Mode is None (step 5 of basic flow)
   1. The administrator sets the Weighted Questions field to true
   2. The administrator sets the Penalty Mode to None
   3. The system does not display any field in the Global Question Setup area
   4. The system displays the column Correct Weight in the Questions area
   5. The administrator sets the Correct Weight values for each question
   6. The administrator presses the Save button
   7. The system sets the Correct Weight field of each question as defined
   8. End of flow
 
##### 3. Weighted Questions is true and Penalty Mode is Percent Decrease (step 5 of basic flow)
   1. The administrator sets the Weighted Questions field to true
   2. The administrator sets the Penalty Mode to Percent Decrease
   3. The system does not display any field in the Global Question Setup area
   4. The system displays the columns Penalty per Attempt % and Correct Weight in the Questions area
   5. The administrator sets the Penalty per Attempt % and Correct Weight values for each question
   6. The administrator presses the Save button
   7. The system sets the Penalty per Attempt % and Correct Weight fields of each question as defined
   8. End of flow
 
##### 4. Weighted Questions is true and Penalty Mode is Negative Weight (step 5 of basic flow)
   1. The administrator sets the Weighted Questions field to true
   2. The administrator sets the Penalty Mode to Negative Weight
   3. The system does not display any field in the Global Question Setup area
   4. The system displays the columns Correct Weight and Incorrect Weight in the Questions area
   5. The administrator sets the Correct Weight and Incorrect Weight values for each question
   6. The administrator presses the Save button
   7. The system sets the Correct Weight and Incorrect Weight fields of each question as defined
   8. End of flow
 
##### 5. Weighted Questions is false and Penalty Mode is None (step 5 of basic flow)
   1. The administrator sets the Weighted Questions field to false
   2. The administrator sets the Penalty Mode to None
   3. The system does not display any field in the Global Question Setup area
   4. The system does not display the columns Correct Weight, Incorrect Weight or Penalty per Attempt % in the Questions area
   5. The administrator presses the Save button
   6. The system sets the Correct Weight to 1 for all questions
   7. The system sets the Penalty per Attempt % to 0 for all questions 
   8. The system sets the Incorrect Weight to 0 for all questions
   9. End of flow
 
##### 6. Weighted Questions is false and Penalty Mode is Percent Decrease (step 5 of basic flow)
   1. The administrator sets the Weighted Questions field to false
   2. The administrator sets the Penalty Mode to Percent Decrease
   3. The system displays the Penalty per Attempt % field in the Global Question Setup area
   4. The system does not display the columns Correct Weight, Incorrect Weight or Penalty per Attempt % in the Questions area
   5. The administrator sets the Penalty per Attempt % global value
   6. The administrator presses the Save button
   7. The system sets the Penalty per Attempt % field for all questions
   8. End of flow
 
##### 7. Weighted Questions is false and Penalty Mode is Negative Weight (step 5 of basic flow)
   1. The administrator sets the Weighted Questions field to false
   2. The administrator sets the Penalty Mode to Negative Weight
   3. The system displays the Incorrect Weight field in the Global Question Setup area
   4. The system does not display the columns Correct Weight, Incorrect Weight or Penalty per Attempt % in the Questions area
   5. The administrator sets the Incorrect Weight global value
   6. The administrator presses the Save button
   7. The system sets the Incorrect Weight field for all questions
   8. End of flow
 
##### 8. Question Pool is not null (step 5 of basic flow)
   1. The administrator sets the Question Pool to a value greater than 0
   2. The system disables the Shuffle Questions field
   3. The system sets the Weighted Questions field to false and disables it
   4. The system disables the drag&drop functionality
   5. The administrator presses the Save button
   6. The system sets the Question Pool for the module
   7. End of flow
