## Submit Module Response

### Objectives
This use case describes the module response calculations performed when it is submitted (IsSubmitted = TRUE)

### Preconditions
The module response is submitted (IsSubmitted = TRUE)

### Postconditions
The grade % was calculated for the module response and the approval status was determined

### Flow of Events

### Basic Flow
   1. The system verifies that the module dependency is correct 
   2. The system verifies that the related module status is active
   3. The system verifies that the “Number of Attempts” is equal or less than the “Attempts Allowed” per module
   4. The system verifies that the submission date is within the allowed period for at least one of the the active related courses
   5. The system verifies that not all the related questions are submitted and that the Question Pool is set to “null”
   6. The system sets, for each question response, its “IsSubmitted” field to “true”
   7. The system calls, for each question, the Use Case [Submit Question Response](?name=UC-ELR-002)
   8. The system updates the “Grade Value” field by adding each question “Partial Grade Value”
   9. The system calculates the “Grade %” by dividing the “Grade Value” by the “Total Value”
   10. The system verifies that the “Grade %” is equal or higher than the “Approval Grade”
   11. The system sets the “IsApproved” field to “true”
   12. The system calls the use case [Calculate Course Progress]
   13. End of flow

### Alternative Flows

##### 1. The module fails when not all the related questions are submitted and the Question Pool is set to “null” (step 10 of basic flow)
   1. The system verifies that the “Grade %” is less than the “Approval Grade”
   2. The system sets the “IsApproved” field to “false”
   3. End of flow
   
##### 2. The module is approved when not all the related questions are submitted and the Question Pool is not “null” (step 5 of basic flow)
   1. The system verifies that not all the related questions were already submitted and that the “Question Pool” value is equal or greater than 1
   2. The system sets, for each question response, its “IsSubmitted” field to “true”
   3. The system calls, for each question, the Use Case [Submit Question Response](?name=UC-ELR-002)
   4. The system updates the “Grade Value” field by adding each question “Partial Grade Value”
   5. The system calculates the “Grade %” by dividing the “Grade Value” by the “Question Pool”
   6. Back to step 10 of basic flow
   
##### 7. The module fails when not all the related questions are submitted and the Question Pool is not “null” (step 5 of basic flow)
   1. The system verifies that not all the related questions were already submitted and that the “Question Pool” value is equal or greater than 1
   2. The system sets, for each question response, its “IsSubmitted” field to “true”
   3. The system calls, for each question, the Use Case [Submit Question Response](?name=UC-ELR-002)
   4. The system updates the “Grade Value” field by adding each question “Partial Grade Value”
   5. The system calculates the “Grade %” by dividing the “Grade Value” by the “Question Pool”
   6. The system verifies that the “Grade %” is less than the “Approval Grade”
   7. The system sets the “IsApproved” field to “false”
   8. End of flow   
   
##### 8. The module is approved when all the related questions are submitted and the Question Pool is set to “null” (step 5 of basic flow)
   1. The system verifies that not all the related questions were already submitted and that the “Question Pool” is “null”
   2. Back to step 8 of basic flow
   
##### 9. The module fails when all the related questions are submitted and the Question Pool is set to “null” (step 5 of basic flow)
   1. The system verifies that all the related questions are submitted and that the “Question Pool” is “null”
   2. The system updates the “Grade Value” field by adding each question “Partial Grade Value”  
   3. The system calculates the “Grade %” by dividing the “Grade Value” by the “Total Value”
   4. The system verifies that the “Grade %” is less than the “Approval Grade”
   5. The system sets the “IsApproved” field to “false”
   6. End of flow

##### 10. The module is approved when all the related questions are submitted and the “Question Pool” is not null (step 5 of basic flow)
   1. The system verifies that all the related questions are submitted and that the “Question Pool” value is equal or greater than 1
   2. The system calculates the “Grade Value” field by adding the partial grades of the questions
   3. The system calculates the “Grade %” by dividing the “Grade Value” by the “Question Pool”
   4. Back to step 10 of basic flow
   
##### 11. The module fails when all the related questions are submitted and the “Question Pool” is not null (step 5 of basic flow)
   1. The system verifies that all the related questions are submitted and that the “Question Pool” value is equal or greater than 1
   2. The system calculates the “Grade Value” field by adding the partial grades of the questions
   3. The system calculates the “Grade %” by dividing the “Grade Value” by the “Question Pool”
   4. The system verifies that the “Grade %” is less than the “Approval Grade”
   5. The system sets the “IsApproved” field to “false”
   6. End of flow
