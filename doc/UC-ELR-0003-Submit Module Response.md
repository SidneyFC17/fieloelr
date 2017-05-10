## Submit Module Response

### Objectives
This use case describes the course calculations performed when a course is submitted (IsSubmitted = TRUE)

### Preconditions

### Postconditions
The score was calculated for the course and the approval status was determined

### Flow of Events

### Basic Flow
   1. The system verifies that the course response is submitted (“IsSubmitted” field in “Course Response” object is set to “true”)
   2. The system verifies that the course dependency is correct 
   3. The system verifies that the related course is active
   4. The system verifies that the “Number of Attempts” is less than the “Limit of Attempts” course field
   5. The system verifies that the number of question responses is equal or greater than the number specified in the course
   6. The system verifies that all the related questions were already submitted
   7. The system calculates the “Score Value” field by adding the values of the correct answers
   8. The system calculates the “Total Value Response” field which is the sum of the values of all answered questions, even those that were answered more than once, respecting the “Attempt Limit per Question” field
   9. The system calculates the score by dividing the “Score Value” by the “Total Value Response”
   10. The system verifies that the score is equal or higher than the approval score
   11. The system sets the “IsApproved” field to “true”
   12. The system increments by one the “Number of Attempts” field
   13. End of flow

### Alternative Flows

##### 1. Not all the related questions are submitted (step 6 of basic flow)
   1. The system verifies that not all the related questions were already submitted (“IsSubmitted” field in “Question Response” object is set to “false”)
   2. The system calls, for each question, the Use Case [Determine Question Result](?name=UC-ELR-0001)
   5. For each correct answer, the system updates the “Score Value” field in “Course Response” by adding the question “Value”   
   4. Back to step 8 of basic flow

##### 2. The member is not approved (step 10 of basic flow)
   1. The system verifies that the score is less than the approval score
   2. The system sets the “IsApproved” field to “false”
   3. Back to step 12 of basic flow
