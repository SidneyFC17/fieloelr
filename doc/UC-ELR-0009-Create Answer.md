## Create Answer
 
### Objectives 
This use case describes the creation of an Answer
 
### Preconditions
The administrator must be logged in  
The question response was already created (Use Case [*Create Question Response*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0008-Create%20Question%20Response.md) already run)  
The answer option was already created (USe Case [*Create Answer Option*]() already run)
 
### Postconditions
An Answer was created
 
### Flow of Events
 
### Basic Flow
   1. The system receives the field values for the answer
   2. The administrator presses the Save button
   3. The system verifies that the “Question Response” is not submitted 
   4. The system verifies that the related question type is not “Matching Options”
   5. The system verifies that the “Answer Option” lookup field is not null
   6. The system verifies that  the “Answer Option” and the “Question Response” belong to the same related question
   7. The system verifies that there is no equal answer already created (Question Response + Answer Option)
   8. The system saves the answer
   9. The system displays the answer detail page with the options to Edit or Delete
   10. End of flow
 
### Alternative flows
 
##### 1. The “Question Response” is submitted (step 3 of basic flow)
   1. The system verifies that the “Question Response” is submitted
   2. The system does not create the answer
   3. The system displays an error message
   4. End of flow
 
##### 2. The related question type is “Matching Options” (step 4 of basic flow)
   1. The system verifies that the related question type is “Matching Options”
   2. Back to step 6 of basic flow
 
##### 3. The “Answer Option” field is null (step 5 of basic flow)
   1. The system verifies that the “Answer Option” field is null
   2. The system does not create the answer
   3. The system displays an error message
   4. End of flow
 
##### 4. The “Answer “Option” and the “Question Response” don’t belong to the same question (step 6 of basic flow)
   1. The system verifies that the answer option and the question response don’t belong to the same question
   2. The system does not create the answer
   3. The system displays an error message
   4. End of flow
 
##### 5. There is an Answer with the same question response and answer option (step 7 of basic flow)
   1. The system verifies that there is already an answer with the same question response and answer option
   2. The system does not create the answer
   3. The system displays an error message
   4. End of flow
 
##### 6. Delete answer when the related question response is not submitted (step 9 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related question response is not submitted
   3. The system deletes the answer 
   4. End of flow
 
##### 7. Delete answer when the related question response is already submitted (step 9 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the related question response is submitted
   3. The system does not delete the answer 
   4. The system displays an error message
   5. End of flow
 
##### 8. Edit answer (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system does not update the answer 
   5. The system displays an error message
   6. End of flow
