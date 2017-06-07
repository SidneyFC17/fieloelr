## Create Course Status
 
### Objectives 
This use case describes the creation of a Course Status
 
### Preconditions
The administrator must be logged in
 
### Postconditions
A course status was created
 
### Flow of Events
 
### Basic Flow
 
   1. The field values for the course status are filled by the administrator
   2. The administrator presses the Save button
   3. The system verifies that the status of the related course is “Active”
   4. The system verifies that the course “Subscription Mode” is “Manual”
   5. The system verifies that the “Member” field is not null
   6. The system verifies that the member belongs to at least one of the course segments
   7. The system verifies that the member belongs to the same program of the course
   8. The system verifies that the member has completed the predecessors courses
   9. The system verifies that there is no equal course status already created (Member + Course)
   10. The system sets the “Approve Modules” field to 0 (zero)
   11. The system saves the course status
   12. The administrator goes to the course detail page with the options to Edit or Delete
   13. End of flow
 
### Alternative flows
 
##### 1. The course status is created by subscription when the “Subscription Mode” is “Manual” (step 1 of basic flow)
   1. The field values for the course status are filled by the system when the member subscribes to the course
   2. Back to step 3 of basic flow 
 
##### 2. The related course is not “Active” (step 3 of basic flow)
   1. The system verifies that the related course is not in status “Active”
   2. The system does not create the course status
   3. The system displays an error message
   4. End of flow
 
##### 3. The course status is created by the administrator when the Subscription Mode is Automatic (step 4 of basic flow)
   1. The system verifies that the subscription mode is “Automatic”
   2. The  system does not create the course status
   3. The system displays an error message
   4. End of flow
 
##### 4. The Member field is null (step 5 of basic flow)
   1. The system verifies that the Member field is null
   2. The  system does not create the course status
   3. The system displays an error message
   4. End of flow
 
##### 4. The course status is created by the system when the Subscription Mode is Automatic (step 1 of basic flow)
   1. The field values for the course status are filled by the system when the module response is being created
   2. Back to step 3 of basic flow 
 
##### 5. The member does not belong to any segment of the course (step 6 of basic flow)
   1. The system verifies that the member does not belong to any of the course segments
   2. The  system does not create the course status
   3. The system displays an error message
   4. End of flow
 
##### 6. The member does not belong to the same program of the course (step 7 of basic flow)
   1. The system verifies that the member does not belong to the same program of the course
   2. The  system does not create the course status
   3. The system displays an error message
   4. End of flow
 
##### 7. The member has not completed the predecessors courses (step 8 of basic flow)
   1. The system verifies that the member has not completed the predecessors courses
   2. The  system does not create the course status
   3. The system displays an error message
   4. End of flow
 
##### 8. There is already a course status created for the member in the course (step 9 of basic flow)
   1. The system verifies that there is already a course status created for the member in the course
   2. The  system does not create the course status
   3. The system displays an error message
   4. End of flow
 
##### 9. Delete course status (step 12 of basic flow)
   1. The administrator presses de Delete button
   2. The system deletes the course status
   4. The system deletes all the related module responses, question responses and answers
   5. End of flow 
 
##### 10. Edit course status (step 12 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes
   3. The system does not update the course status
   4. The system displays an error message
   5. End of flow
