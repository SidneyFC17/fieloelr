## Submit Module Response
 
### Objectives
This use case describes the module response calculations performed when it was submitted (IsSubmitted = TRUE)
 
### Preconditions
The related module must be active  
The related course must be active  
 
### Postconditions
The grade value was calculated for the module response  
The grade % was calculated for the module response  
The approval status was determined for the module  
The progress was calculated for the related course status 
 
### Flow of Events
 
### Basic Flow
   1. The administrator/system edits the module response changing the "IsSubmitted" field to "true"
   2. The system verifies that there are unsubmitted related questions responses and that the Question Pool is “null”
   3. The system sets, for each question response, its “IsSubmitted” field to “true”
   4. The system calls, for each question, the Use Case [*Determine Question Response Correction*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0011-Determine%20Question%20Response%20Correction.md)
   5. The system calls, for each question, the Use Case [*Submit Question Response*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0012-Submit%20Question%20Response.md)
   6. The system updates the “Grade Value” field with the addition of “Partial Grade Value” of all question responses
   7. The system calculates the “Grade %” by dividing the “Grade Value” by the value of “Total Value” field in the related module
   8. The system verifies that the “Grade %” is equal or higher than the “Approval Grade” field in the related module
   9. The system sets the “IsApproved” field to “true”
   10. The system calculates the quantity of approved module responses for the related module
   11. The system updates the “Number of Approve” field
   12. The system saves the module response
   13. The system updates the “Approved Modules” field in the related "Course Status" with the quantity of approved modules, by considering for each module only the first approval of its related "module responses".
   14. The system calculates the course progress by dividing the “Approved Modules” value by the course total number of modules
   15. The system verifies that the number of “Approved Modules” is different from the number of “Active Modules” of the related course
   16. The system updates the “Progress” field in the related Course Status with the previous step calculated value
   17. The system verifies that the “Progress” is less than 100%
   18. End of flow
 
### Alternative Flows
 
##### 1. The module response is approved when all the related question responses were submitted and the Question Pool is “null” (step 2 of basic flow)
   1. The system verifies that all the related questions were already submitted and that the “Question Pool” is “null”
   2. Back to step 5 of basic flow

##### 2. The module response is not approved when there are unsubmitted related question responses and the Question Pool is “null” (step 8 of basic flow)
   1. The system verifies that the “Grade %” is less than the “Approval Grade”
   2. The system sets the “IsApproved” field to “false”
   3. The system saves the module response
   4. End of flow
   
##### 3. The module response is approved when there are unsubmitted related question responses and the Question Pool is not “null” (step 2 of basic flow)
   1. The system verifies that not all the related questions were already submitted and that the “Question Pool” value is equal or greater than 1
   2. The system sets, for each question response, its “IsSubmitted” field to “true”
   3. The system calls, for each question, the Use Case [*Determine Question Response Correction*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0011-Determine%20Question%20Response%20Correction.md)
   4. The system calls, for each question, the Use Case [Submit Question Response](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0012-Submit%20Question%20Response.md)
   5. The system updates the “Grade Value” field with the addition of “Partial Grade Value” of all question responses
   6. The system calculates the “Grade %” by dividing the “Grade Value” by the “Question Pool” field in the related module
   7. Back to step 7 of basic flow
   
##### 4. The module response is not approved when there are unsubmitted related question responses and the Question Pool is not “null” (step 2 of basic flow)
   1. The system verifies that not all the related questions were already submitted and that the “Question Pool” value is equal or greater than 1
   2. The system sets, for each question response, its “IsSubmitted” field to “true”
   3. The system calls, for each question, the Use Case [*Determine Question Response Correction*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0011-Determine%20Question%20Response%20Correction.md)
   4. The system calls, for each question, the Use Case [Submit Question Response](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0012-Submit%20Question%20Response.md)
   5. The system updates the “Grade Value” field with the addition of “Partial Grade Value” of all question responses
   6. The system calculates the “Grade %” by dividing the “Grade Value” by the “Question Pool” field in the related module
   7. The system verifies that the “Grade %” is less than the “Approval Grade”
   8. The system sets the “IsApproved” field to “false”
   9. The system saves the module response
   10. End of flow   
      
##### 5. The module response is not approved when all the related question responses are submitted and the Question Pool is “null” (step 6 of basic flow)
   1. The system verifies that all the related questions are submitted and that the “Question Pool” is “null”
   2. The system updates the “Grade Value” field with the addition of “Partial Grade Value” of all question responses
   3. The system calculates the “Grade %” by dividing the “Grade Value” by the “Total Value” field in the related module
   4. The system verifies that the “Grade %” is less than the “Approval Grade”
   5. The system sets the “IsApproved” field to “false”
   6. The system saves the module response
   7. End of flow
 
##### 6. The module response is approved when all the related question responses are submitted and the “Question Pool” is not null (step 6 of basic flow)
   1. The system verifies that all the related questions are submitted and that the “Question Pool” value is equal or greater than 1
   2. The system updates the “Grade Value” field with the addition of “Partial Grade Value” of all question responses
   3. The system calculates the “Grade %” by dividing the “Grade Value” by the “Question Pool” field in the related module
   4. Back to step 7 of basic flow
   
##### 7. The module response is not approved when all the related question responses are submitted and the “Question Pool” is not null (step 6 of basic flow)
   1. The system verifies that all the related questions are submitted and that the “Question Pool” value is equal or greater than 1
   2. The system updates the “Grade Value” field with the addition of “Partial Grade Value” of all question responses
   3. The system calculates the “Grade %” by dividing the “Grade Value” by the “Question Pool” field in the related module
   4. The system verifies that the “Grade %” is less than the “Approval Grade”
   5. The system sets the “IsApproved” field to “false”
   6. The system saves the module response
   7. End of flow

##### 8. The related course is not active (step 2 of basic flow)
   1. The system verifies that the related course is not active
   2. The system displays an error message
   3. The system does not save the module response
   4. End of flow
   
##### 9. The related module is not active (step 2 of basic flow)
   1. The system verifies that the related module is not active
   2. The system displays an error message
   3. The system does not save the module response
   4. End of flow   

 ##### 10. The number of “Approved Modules” is equal to the number of “Active Modules” of the related course (step 15 of basic flow)
   1. The system verifies that the number of “Approved Modules” is equal to the number of “Active Modules” of the related course
   2. The system updates the “Completed Date” field in the related Course Status with the current date/time
   3. Back to step 16 of basic flow

 ##### 11. The system verifies that the “Progress” is equal to 100% (step 17 of basic flow)
   1. The system verifies that the “Progress” is equal to 100%
   2. The system updates the “Course Accomplished” field in the related Course Status, setting it as “true”
   3. End of flow
