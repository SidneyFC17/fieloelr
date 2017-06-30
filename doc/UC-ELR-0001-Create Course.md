## Create Course
 
### Objectives 
This use case describes the creation of a Course
 
### Preconditions
The administrator must be logged in
 
### Postconditions
A course is created
 
### Flow of Events
 
### Basic Flow
 
   1. The system receives the field values for the course
   2. The administrator presses the Save button
   3. The system verifies that the “Program” field is filled
   4. The system verifies that the “Segment” belongs to the “Program” already set
   5. The system verifies that the “Start Date” and “End Date” are valid
   6. The system sets the course status to “Draft”
   7. The system sets the “ActiveModules” field to 0 (zero)
   8. The system saves the course
   9. The system displays the course detail page with the options to Edit or Delete
   10. End of flow
 
### Alternative flows
 
##### 1. The Program is not filled (step 3 of basic flow)
   1. The system verifies that the Program is not set
   2. The system does not create the course
   3. The system displays an error message
   4. End of flow
 
##### 2. The segment is not from the same program (step 4 of basic flow)
   1. The system verifies that the segment does not belong to the program set to the course
   2. The system does not create the course
   3. The system displays an error message
   4. End of flow
   
##### 3. The start date is earlier than the current date (step 5 of basic flow)
   1. The system verifies that “Start Date” is earlier than the current date
   2. The system does not create the course
   3. The system displays an error message
   4. End of flow
 
##### 4. The end date is earlier than the current date (step 5 of basic flow)
   1. The system verifies that “End Date” is earlier than the current date
   2. The system does not create the course
   3. The system displays an error message
   4. End of flow
 
##### 5. The start date is later than the end date (step 5 of basic flow)
   1. The system verifies that the “Start Date” is later than the “End Date”
   2. The system does not create the course
   3. The system displays an error message
   4. End of flow

##### 6. Activate a course that has active related modules (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the status of the course to “Active”
   3. The administrator presses the Save button
   4. The system verifies that there is, at least, one active related module
   5. The system updates the course
   6. The system displays the course detail page
   7. End of flow
 
##### 7. Activate a course that has no active related modules (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the status of the course to “Active”
   3. The administrator presses the Save button
   4. The system verifies that there is no active related modules
   5. The system does not update the course
   6. The system displays an error message 
   7. End of flow
   
##### 8. Edit the program of a course (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the program of the course
   3. The administrator presses the Save button
   4. The system does not update the course
   5. The system displays an error message
   6. End of flow
 
##### 9. Edit a draft course (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes (except the status and program change)
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Draft”
   5. The system updates the course
   6. The system displays the course detail page
   7. End of flow
 
##### 10. Edit an active course (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes (except the status and program change)
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Active”
   5. The system does not update the course
   6. The system displays an error message
   7. End of flow
   
##### 11. Edit an inactive course (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes (except the status and program change)
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Inactive”
   5. The system updates the course
   6. The system displays the course detail page
   7. End of flow
 
 ##### 12. Inactivate an active course (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the status of the course to “Inactive” 
   3. The administrator presses the Save button
   4. The system saves the course
   5. The system displays the course detail page
   6. End of flow
   
##### 13. Delete a draft course (step 9 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that course status is "Draft"
   3. The system deletes the course
   4. The system deletes the related course dependencies
   5. The system deletes the related course modules
   6. End of flow
 
##### 14. Delete an active course with no related course status (step 9 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that course status is "Active"
   3. The system verifies that the course has no related course status
   4. The system deletes the course
   5. The system deletes the related course dependencies
   6. The system deletes the related course modules
   7. End of flow
 
##### 15. Delete an active course with related course status (step 9 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the status of the course is "Active"
   3. The system verifies that the course has related course status
   4. The system does not delete the course
   5. The system displays an error message
   6. End of flow

##### 16. Delete an inactive course with no related course status (step 9 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the status of the course is "Inactive"
   3. The system verifies that the course has no related course status
   4. The system deletes the course
   5. The system deletes the related course dependencies
   6. The system deletes the related course modules
   7. End of flow
   
##### 17. Delete an inactive course with related course status (step 9 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the status of the course is "Inactive"
   3. The system verifies that the course has related course status
   4. The system does not delete the course
   5. The system displays an error message
   6. End of flow
