## Create Answer Option
 
### Objectives 
This use case describes the creation of an Answer Option
 
### Preconditions
The administrator must be logged in
The related question was already created (Use Case [*Create Question*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0005-Create%20Question.md) already run)
 
### Postconditions
An answer option was created
 
### Flow of Events
 
### Basic Flow
   1. The system receives the field values for the answer option
   2. The administrator presses the Save button
   3. The system verifies that the related module is inactive
   4. The system verifies that the related module does not have module responses
   5. The system verifies that the related question “Type” is “Multiple Choice”
   6. The system verifies that the “Answer Option Text” field is not null
   7. The system verifies that the “Order” field is not null
   8. The system saves the answer option
   9. The system displays the answer option detail page with the options to Edit or Delete
   10. End of flow
 
### Alternative flows
 
##### 1. The related module is active (step 3 of basic flow)
   1. The system verifies that the related module is active
   2. The system does not create the answer option
   3. The system displays an error message
   4. End of flow
   
##### 2. The related module has module response (step 4 of basic flow)
   1. The system verifies that the related module has module response
   2. The system does not create the answer option
   3. The system displays an error message
   4. End of flow
 
##### 3. “Answer Option Text” field is null (step 6 of basic flow)
   1. The system verifies that the “Answer Option Text” field is null
   2. The system does not create the answer
   3. The system displays an error message
   4. End of flow
 
##### 4. “Order” field is null (step 7 of basic flow)
   1. The system verifies that the “Order” field is null
   2. The system automatically numbers the “Order” field
   3. Back to step 8 of basic flow
   
##### 5. Related question “Type” is “Statement” and it doesn't have already two answer options (step 5 of basic flow)
   1. The system verifies that the related question “Type” is “Statement”
   2. The system verifies that there aren't already two answer options for the related question
   3. Back to step 6 of basic flow
 
##### 6. Related question “Type” is “Statement” and it has already two answer options (step 5 of basic flow)
   1. The system verifies that the related question “Type” is “Statement”
   2. The system verifies that there are already two answer options for the related question
   3. The system does not create the answer option
   4. The system displays an error message
   5. End of flow
   
##### 7. Related question “Type” is “Statement” and no other answer option was defined as correct (step 5 of basic flow)
   1. The system verifies that the related question “Type” is “Statement”
   2. The system verifies that the “IsCorrect” field is set to “true”
   3. The system verifies that the related question doesn't have already two answer options
   4. The system verifies that no other answer option of the same related question has its “IsCorrect” field set to “true”
   5. Back to step 6 of basic flow
   
##### 8. Related question “Type” is “Statement” and another answer option was defined as correct (step 5 of basic flow)
   1. The system verifies that the related question “Type” is “Statement”
   2. The system verifies that the “IsCorrect” field is set to “true”
   3. The system verifies that the related question doesn't have already two answer options
   4. The system verifies that there is another answer option of the same related question that has its “IsCorrect” field set to “true”
   5. The system does not create the answer option
   6. The system displays an error message
   7. End of flow
 
##### 9. Related question “Type” is “Single Choice” and no other answer option was defined as correct (step 5 of basic flow)
   1. The system verifies that the related question “Type” is “Single Choice”
   2. The system verifies that the “IsCorrect” field is set to “true”
   3. The system verifies that no other answer option of the same related question has its “IsCorrect” field set to “true”
   4. Back to step 6 of basic flow
 
##### 10. Related question “Type” is “Single Choice” and another answer option was defined as correct (step 5 of basic flow)
   1. The system verifies that the related question “Type” is “Single Choice”
   2. The system verifies that the “IsCorrect” field is set to “true”
   3. The system verifies that there is another answer option of the same related question that has its “IsCorrect” field set to “true”
   4. The system does not create the answer option
   5. The system displays an error message
   6. End of flow
 
##### 11. Related question “Type” is “Short Answer” (step 5 of basic flow)
   1. The system verifies that the related question “Type” is “Short Answer”
   2. Back to step 6 of basic flow
 
##### 12. Related question “Type” is “Matching Options” and there is a matching pair (step 5 of basic flow)
   1. The system verifies that the related question “Type” is “Matching Options”
   2. The system verifies that the “Matching Text” field is not null
   3. The system verifies that the “Answer Option Text” is not null
   4. The system sets the “IsCorrect” field to “true”
   5. Back to step 7 of basic flow
 
##### 13. Related question “Type” is “Matching Options” and there is not a matching pair (step 5 of basic flow)
   1. The system verifies that the related question “Type” is “Matching Options”
   2. The system verifies that the “Matching Text” field is not null
   3. The system verifies that the “Answer Option Text” is null
   4. The system sets the “IsCorrect” field to “false”
   5. Back to step 7 of basic flow
 
##### 14. Related question “Type” is “Matching Options” and “Matching Text” field is null (step 5 of basic flow)
   1. The system verifies that the related question “Type” is “Matching Options”
   2. The system verifies that the “Matching Text” field is null
   3. The system does not create the answer option
   4. The system displays an error message
   5. End of flow
 
##### 15. Delete answer option when related module is inactive and the related question does not have question response (step 9 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related module is inactive and that the related question doesn't have question response
   3. The system deletes the answer option
   4. End of flow
   
##### 16. Delete answer option when related module is inactive and the related question has question response (step 9 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related module is inactive and that the related question has question response
   3. The system does not delete the answer option
   4. The system displays an error message
   5. End of flow
 
##### 17. Delete answer option when related module is active (step 9 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related module is active
   3. The system does not delete the answer option
   4. The system displays an error message
   5. End of flow
   
##### 18. Edit answer option when related module is active (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes (except the Question field)
   3. The administrator presses the Save button
   4. The system verifies that the related module is active
   5. The system does not save the answer option 
   6. The system displays an error message
   7. End of flow
 
##### 19. Edit answer option when related module is inactive and the related question does not have question response (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes (except the Question field)
   3. The administrator presses the Save button
   4. The system verifies that the related module is inactive and that the related question doesn't have question response
   5. The system updates the answer option
   6. The system displays the answer option detail page
   7. End of flow
 
##### 20. Edit answer option when related module is inactive and the related question has question response (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes (except the Question field)
   3. The administrator presses the Save button
   4. The system verifies that the related module is inactive and that the related question has question response
   5. The system does not save the answer option 
   6. The system displays an error message
   7. End of flow

##### 21. Edit answer opting setting correct answer option for question Type “Statement” when no other answer option is defined as correct (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsCorrect” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the related question “Type” is “Statement”
   5. The system verifies that no other answer option of the same related question has its “IsCorrect” field set to “true”
   6. The system updates the answer option
   7. The system displays the answer option detail page
   8. End of flow
 
##### 22. Edit answer opting setting correct answer option for question Type “Statement” when another answer option is defined as correct (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsCorrect” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the related question “Type” is “Statement”
   5. The system verifies that there is another answer option of the same related question that has its “IsCorrect” field set to “true”
   6. The system does not create the answer option
   7. The system displays an error message
   8. End of flow
