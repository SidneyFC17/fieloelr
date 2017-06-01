## Create Answer Option

### Objectives 
This use case describes the creation of an Answer Option

### Preconditions
The administrator must be logged in  
The related question is already created (Use Case [*Create Question*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0005-Create%20Question.md) already run)

### Postconditions
An answer option was created

### Flow of Events

### Basic Flow
   1. The The system receives the field values for the answer option
   2. The administrator presses the Save button
   3. The system verifies that the related module is not active
   4. The system verifies that the “Answer Text” field is not null
   5. The system verifies that the “Order” field is valid
   6. The system verifies that the related question “Type” is “Multiple Choice”
   7. The system saves the answer option
   8. The system displays the answer option detail page
   9. End of flow

### Alternative flows

##### 1. The related module is active (step 3 of basic flow)
   1. The system verifies that the related module is active
   2. The system does not create the answer option
   3. The system displays an error message
   4. End of flow

##### 2. “Answer Text” field is null (step 4 of basic flow)
   1. The system verifies that the “Answer Text” field is null
   2. The system does not create the answer option
   3. The system displays an error message
   4. End of flow

##### 3. “Order” field is null (step 5 of basic flow)
   1. The system verifies that the Order field is null
   2. The system automatically numbers the Order field
   3. Back to step 6 of basic flow

##### 4. Related question “Type” is “Statement” and it has already two answer options (step 6 of basic flow)
   1. The system verifies that the related question “Type” is “Statement”
   2. The system verifies that there are already two answer options for the related question
   2. The system does not create the answer option
   3. The system displays an error message
   4. End of flow

##### 5. Related question “Type” is “Single Choice” and no other answer option was defined as correct (step 6 of basic flow)
   1. The system verifies that the related question “Type” is “Single Choice”
   2. The system verifies that the “IsCorrect” field is set to “true”
   3. The system verifies that no other answer option of the same related question has its “IsCorrect” field set to “true”
   4. Back to step 7 of basic flow
   
##### 6. Related question “Type” is “Single Choice” and another answer option was defined as correct (step 6 of basic flow)
   1. The system verifies that the related question “Type” is “Single Choice”
   2. The system verifies that the “IsCorrect” field is set to “true”
   3. The system verifies that there is another answer option of the same related question that has its “IsCorrect” field set to “true”
   4. The system does not create the answer option
   5. The system displays an error message
   6. End of flow

##### 7. Related question “Type” is “Short Answer” (step 6 of basic flow)
   1. The system verifies that the related question “Type” is “Short Answer”
   2. Back to step 7 of basic flow

##### 8. Related question “Type” is “Matching Options” and “Answer Text” format is correct (step 6 of basic flow)
   1. The system verifies that the related question “Type” is “Matching Options”
   2. The system verifies that the format of “Answer Text” field is correct (validates {"xx":"yy"})
   3. Back to step 7 of basic flow

##### 9. Related question “Type” is “Matching Options” and “Answer Text” format is incorrect (step 6 of basic flow)
   1. The system verifies that the related question “Type” is “Matching Options”
   2. The system verifies that the format of “Answer Text” field is incorrect
   3. The system does not create the answer option
   4. The system displays an error message
   5. End of flow

##### 10. Delete answer option when related module is not active (step 8 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related module is not active
   3. The system deletes the answer option
   4. End of flow

##### 11. Delete answer option when related module is active (step 8 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related module is active
   3. The system does not delete the answer option
   4. The system displays an error message
   5. End of flow

##### 12. Edit answer option when related module is not active (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the related module is not active
   5. The system verifies that all other validations succeed
   6. The system updates the answer option
   7. The system displays the answer option detail page
   8. End of flow

##### 13. Edit answer option when related module is active (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the related module is active
   5. The system does not save the answer option 
   6. The system displays an error message
   7. End of flow
   
##### 14. Set correct answer option for question Type “Statement” and no other answer option is defined as correct (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsCorrect” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the related question “Type” is “Statement”
   5. The system verifies that no other answer option of the same related question has its “IsCorrect” field set to “true”
   6. The system updates the answer option
   7. The system displays the answer option detail page
   8. End of flow

##### 15. Set correct answer option for question Type “Statement” and another answer option is defined as correct (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsCorrect” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the related question “Type” is “Statement”
   5. The system verifies that there is another answer option of the same related question that has its “IsCorrect” field set to “true”
   6. The system does not create the answer option
   7. The system displays an error message
   8. End of flow
