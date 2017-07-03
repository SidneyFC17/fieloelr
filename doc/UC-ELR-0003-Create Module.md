## Create Module

### Objectives 
This use case describes the creation of a Module

### Preconditions
The administrator must be logged in  
The related course is already created (Use Case [*Create Course*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0001-Create%20Course.md) already run)

### Postconditions
A module was created

### Flow of Events

### Basic Flow

1. The system receives the fields for the module
2. The administrator presses the Save button
3. The system verifies that the module has a related Course in status “Draft” or "Inactive"
4. The system verifies that the Approval Grade is between 0 and 100
5. The system verifies that the “Question Pool” is greater than zero and the “Weighted Questions” is set to false
6. The system verifies that the “IsActive” field is set to “false”
7. The system verifies that the “Attempts Allowed” is “null” or greater than 0
8. The system verifies that the “Attempts Allowed per Question” is “null” or greater than 0
9. The system verifies that the “Order” is not null
10. The system saves the module
11. The system displays the module detail page with the options to Edit or Delete
12. End of flow

### Alternative flows

##### 1. The related course is null (step 3 of basic flow)
   1. The system verifies that the Course field is null
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow

##### 2. The related course is “Active” (step 3 of basic flow)
   1. The system verifies that the related Course is in status “Active”
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow

##### 3. The Approval Grade is invalid (step 4 of basic flow)
   1. The system verifies that the Approval Grade is not between 0 and 100
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow
   
##### 4. "Question Pool" is greater than zero and "Weighted Questions" is true (step 5 of basic flow)
   1. The system verifies that "Question Pool" is greater than zero and "Weighted Questions" is set to true
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow
   
##### 5. "Question Pool" is null (step 5 of basic flow)
   1. The system verifies that "Question Pool" is null 
   2. Back to step 6 of basic flow

##### 6. Question Pool is zero or negative (step 5 of basic flow)
   1. The system verifies that the Question Pool is 0 (zero) or negative
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow
   
##### 7. Create a module in status “Active” (step 6 of basic flow)
   1. The system verifies that “IsActive” field is set to “true”
   2. The system automatically sets the “IsActive” field to “false”
   3. Back to step 7 of basic flow

##### 8. “Attempts Allowed” is negative (step 7 of basic flow)
   1. The system verifies that the “Attempts Allowed” field value is negative
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow

##### 9. “Attempts Allowed per Question” is negative (step 8 of basic flow)
   1. The system verifies that the “Attempts Allowed per Question” field value is negative
   2. The system does not create the module
   3. The system displays an error message
   4. End of flow

##### 10. “Order” field is null (step 9 of basic flow)
   1. The system verifies that the Order field is null
   2. The system automatically numbers the Order field
   3. Back to step 10 of basic flow

##### 11. Edit an inactive module that has no related module response without changing the “Question Pool”, “Weighted Questions” or “Penalty Mode” fields (step 11 of basic module)
   1. The administrator presses the Edit button
   2. The administrator changes any field, except Course, “Question Pool”, “Weighted Questions” and “Penalty Mode”, keeping them valid
   3. The administrator presses the Save button
   4. The system verifies that the IsActive field is set to “false”
   5. The system verifies that the related course was not changed
   6. The system verifies that the Approval Grade is between 0 and 100
   7. The system verifies that Question Pool was not changed
   8. The system verifies that the “Attempts Allowed” is “null” or greater than 0
   9. The system verifies that the “Attempts Allowed per Question” is “null” or greater than 0
   10. The system verifies that the “Weighted Questions” field was not changed
   11. The system verifies that the “Penalty Mode” field was not changed
   12. The system updates the module
   13. The system displays the module detail page
   14. End of flow

##### 12. Edit a non active module that has no related module response changing the “Question Pool” field from “null” to “not null” (step 11 of basic module) 
   1. The administrator presses the Edit button
   2. The administrator changes the “Question Pool” field from “null” to a number greater than 0
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system updates all the “Correct Weight” fields from the related questions with the value 1
   6. The system displays the module detail page
   7. End of flow

##### 13. Edit a non active module that has no related module response changing the “Weighted Questions” field from “true” to “false” (step 11 of basic module) 
   1. The administrator presses the Edit button
   2. The administrator changes the “Weighted Questions” field from “true” to “false”
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system updates all the “Correct Weight” fields from the related questions with the value 1
   6. The system displays the module detail page
   7. End of flow

##### 14. Edit a non active module that has no related module response changing the “Penalty Mode” field from "Percent Decrease" to "Incorrect Weight" (step 11 of basic module) 
   1. The administrator presses the Edit button
   2. The administrator changes the “Penalty Mode” field from "Percent Decrease" to "Incorrect Weight"
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system updates all the “Percent decrease” fields from the related questions with the value 0
   6. The system displays the module detail page
   7. End of flow

##### 15. Edit a non active module that has no related module response changing the “Penalty Mode” field from "Percent Decrease" to "None" (step 11 of basic module) 
   1. The administrator presses the Edit button
   2. The administrator changes the “Penalty Mode” field from "Percent Decrease" to "None"
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system updates all the “Percent decrease” fields from the related questions with the value 0
   6. The system displays the module detail page
   7. End of flow

##### 16. Edit a non active module that has no related module response changing the “Penalty Mode” field from "Incorrect Weight" to "Percent decrease" (step 11 of basic module) 
   1. The administrator presses the Edit button
   2. The administrator changes the “Penalty Mode” field from "Incorrect Weight" to "Percent Decrease"
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system updates all the “Incorrect Weight” fields from the related questions with the value 0
   6. The system displays the module detail page
   7. End of flow

##### 17. Edit a non active module that has no related module response changing the “Penalty Mode” field from "Incorrect Weight" to "None" (step 11 of basic module) 
   1. The administrator presses the Edit button
   2. The administrator changes the “Penalty Mode” field from "Incorrect Weight" to "None"
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system updates all the “Incorrect Weight” fields from the related questions with the value 0
   6. The system displays the module detail page
   7. End of flow

##### 18. Edit the name of an inactive module with related module response (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the module “Name”
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system displays the module detail page
   6. End of flow

##### 19. Edit the description of an inactive module with related module response (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the module “Description”
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system displays the module detail page
   6. End of flow

##### 20. Edit the order of an inactive module with related module response (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the module “Order”
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system displays the module detail page
   6. End of flow

##### 21. Edit the shuffle questions of an inactive module with related module response (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Shuffle Questions”
   3. The administrator presses the Save button
   4. The system updates the module
   5. The system displays the module detail page
   6. End of flow

##### 22. Edit the attempts allowed of an inactive module with related module response (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Attempts Allowed” field
   3. The administrator presses the Save button
   4. The system verifies that the module has related module response
   5. The system does not update the module
   6. The system displays an error message
   7. End of flow

##### 23. Edit the attempts allowed per question of an inactive module with related module response (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Attempts Allowed per Question” field
   3. The administrator presses the Save button
   4. The system verifies that the module has related module response
   5. The system does not update the module
   6. The system displays an error message
   7. End of flow

##### 24. Edit the approval grade of an inactive module with related module response (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Approval Grade” field
   3. The administrator presses the Save button
   4. The system verifies that the module has related module response
   5. The system does not update the module
   6. The system displays an error message
   7. End of flow

##### 25. Edit the penalty mode of an inactive module with related module response (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Penalty Mode” field
   3. The administrator presses the Save button
   4. The system verifies that the module has related module response
   5. The system does not update the module
   6. The system displays an error message
   7. End of flow

##### 26. Edit the question pool of an inactive module with related module response (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Question Pool” field
   3. The administrator presses the Save button
   4. The system verifies that the module has related module response
   5. The system does not update the module
   6. The system displays an error message
   7. End of flow

##### 27. Edit the weighted questions of an inactive module with related module response (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Weighted Questions” field
   3. The administrator presses the Save button
   4. The system verifies that the module has related module response
   5. The system does not update the module
   6. The system displays an error message
   7. End of flow

##### 28. Activate a module (step 11 of basic module)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsActive” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the module has a related course
   5. The system verifies that the “Approval Grade” is between 0 and 100
   6. The system verifies that question pool is not used used when the questions have weighted questions
   7. The system verifies that the “Attempts Allowed” is “null” or greater than 0
   8. The system verifies that the “Attempts Allowed per Question” is “null” or greater than 0
   9. The system verifies that the “Weighted Questions” field was not changed
   10. The system verifies that the “Penalty mode” field was not changed
   11. The system verifies that the module has, at least, one related question
   12. The system verifies that the related questions from type “Statement”, “Single Choice”, “Short Answer”, “Multiple Choice” and “Matching Options” have at least one related answer
   13. The system verifies that the related questions from type “Statement” and “Single Choice” have a correct answer
   14. The system updates the module
   15. The system updates the “ActiveModules” field in the related course 
   16. The system displays the module detail page
   17. End of flow

##### 29. Activate a module with “Approval Grade” null (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsActive” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the “Approval” Grade is null
   5. The system verifies that all other validations succeed
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow

##### 30. Activate a module with no related questions (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsActive” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the module has no related questions
   5. The system verifies that all other validations succeed
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow

##### 31. Activate a module that has a question from type “Statement” with no correct answer (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsActive” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the module has a question from type “Statement” with no correct answer
   5. The system verifies that all other validations succeed
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow

##### 32. Activate a module that has a question from type “Single Choice” with no correct answer (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsActive” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the module has a question from type “Single Choice” with no correct answer
   5. The system verifies that all other validations succeed
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow

##### 33. Activate a module that has a question from type “Statement” with no answers (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsActive” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the module has a question from type “Statement” with no answers
   5. The system verifies that all other validations succeed
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow

##### 34. Activate a module that has a question from type “Single Choice” with no answers (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsActive” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the module has a question from type “Single Choice” with no answers
   5. The system verifies that all other validations succeed
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow

##### 35. Activate a module that has a question from type “Multiple Choice” with no answers (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsActive” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the module has a question from type “Multiple Choice” with no answers
   5. The system verifies that all other validations succeed
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow

##### 36. Activate a module that has a question from type “Matching Options” with no answers (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsActive” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the module has a question from type “Matching Options” with no answers
   5. The system verifies that all other validations succeed
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow

##### 37. Activate a module that has a question from type “Short Answer” with no answers (step 11 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the “IsActive” field to “true”
   3. The administrator presses the Save button
   4. The system verifies that the module has a question from type “Short Answer” with no answers
   5. The system verifies that all other validations succeed
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow

##### 38. Delete a non active module (step 11 of basic module)8
   1. The administrator presses the Delete button of a non active module
   2. The system deletes the module
   3. The system deletes the related module dependencies
   4. The system deletes all related questions and answers
   5. End of flow

##### 39. Delete an active module without related module responses and that has the related course not in status "Active" (step 11 of basic flow)
   1. The administrator presses the Delete button of an active module
   2. The system verifies that the module has no related module responses
   3. The system verifies that the related course is in status "Inactive"
   4. The system deletes the module
   5. The system deletes the related module dependencies
   6. The system deletes all related questions and answers
   7. The system updates the “ActiveModules” field in the related course
   8. End of flow

##### 40. Delete an active module that has related module responses and that has the related course in status "Active" (step 11 of basic flow)
   1. The administrator presses the Delete button of an active module
   2. The system verifies that the module has related module responses
   3. The system verifies that the related course is in status "Inactive"
   4. The system does not delete the module
   5. The system displays an error message
   6. End of flow
   
#### 41. Delete an active module that has related module responses and that has the related course not in status "Active" (step 11 of basic flow)
   1. The administrator presses the Delete button of an active module
   2. The system verifies that the module has no related module responses
   3. The system verifies that the related course is in status "Inactive"
   4. The system deletes the module
   5. The system deletes the related module dependencies
   6. The system deletes all related questions and answers
   7. The system updates the “ActiveModules” field in the related course
   8. End of flow

##### 42. Inactivate a module without related module responses and that has the related course not in status "Active" (step 11 of basic flow)
   1. The administrator presses the Edit button of an active module
   2. The administrator changes the “IsActive” field from “true” to “false”
   3. The administrator presses the Save button
   4. The system verifies that the module has no related module responses
   5. The system verifies that the related course is not in status "Active"
   6. The system updates the module
   7. The system updates the “ActiveModules” field in the related course
   8. The system displays the module detail page
   9. End of flow

##### 43. Inactivate a module that has related module responses and that has the related course in status "Inactive" (step 11 of basic flow)
   1. The administrator presses the Edit button of an active module
   2. The administrator changes the “IsActive” field from “true” to “false”
   3. The administrator presses the Save button
   4. The system verifies that the module has related module responses
   5. The system verifies that the related course is in status "Inactive"
   6. The system updates the module
   7. The system updates the “ActiveModules” field in the related course
   8. The system displays the module detail page
   9. End of flow
   
##### 44. Inactivate a module that has the related course in status "Active" (step 11 of basic flow)
   1. The administrator presses the Edit button of an active module
   2. The administrator changes the “IsActive” field from “true” to “false”
   3. The administrator presses the Save button
   4. The system verifies that the related course is in status "Active"
   5. The system does not update the module
   6. The system displays an error message
   7. End of flow

##### 45. Change the course of the module (step 11 of basic flow)
   1. The administrator presses the Edit button of a module that can be edited
   2. The administrator changes the related course
   3. The administrator presses the Save button
   4. The system does not update the module
   5. The system displays an error message
   6. End of flow

