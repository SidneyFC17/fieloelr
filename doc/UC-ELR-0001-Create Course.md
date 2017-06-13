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
 
##### 3. Activate a course that has active related modules (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the status of the course to “Active”
   3. The administrator presses the Save button
   4. The system verifies that there is, at least, one active related module
   5. The system verifies that all other validations succeed
   6. The system updates the course
   7. The system displays the course detail page
   8. End of flow
 
##### 4. Activate a course that has no active related modules (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the status of the course to “Active”
   3. The administrator presses the Save button
   4. The system verifies that there is no active related modules
   5. The system does not update the module
   6. The system displays an error message 
   7. End of flow
 
##### 5. Edit a draft course (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes (except change the status)
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Draft”
   5. The system verifies that all other validations succeed
   6. The system updates the course
   7. The system displays the course detail page
   8. End of flow
 
##### 6. Edit an active course with no related course statuses (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes (except change the status)
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Active”
   5. The system verifies that the course has no related course status
   6. The system verifies that all other validations succeed
   7. The system updates the course
   8. The system displays the course detail page
   9. End of flow
 
##### 7. Edit the name of an active course with related course statuses (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Course Name” 
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Active”
   5. The system verifies that the course has related course status
   6. The system updates the course
   7. The system displays the course detail page
   8. End of flow
 
##### 8. Edit the description of an active course with related course statuses (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the course “Description”
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Active”
   5. The system verifies that the course has related course status
   6. The system updates the course
   7. The system displays the course detail page
   8. End of flow
 
##### 9. Edit the subscription mode of an active course with related course statuses (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Subscription Mode”
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Active”
   5. The system verifies that the course has related course status
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow
 
##### 10. Edit the program of an active course with related course statuses (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Program”
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Active”
   5. The system verifies that the course has related course status
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow
 
##### 11. Edit the segment of an active course with related course statuses (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Segment”
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Active”
   5. The system verifies that the course has related course status
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow
 
##### 12. Edit the start date of an active course with related course statuses (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “Start Date”
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Active”
   5. The system verifies that the course has related course status
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow
 
##### 13. Edit  the end date of an active course with related course statuses (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator changes the “End Date”
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Active”
   5. The system verifies that the course has related course status
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow
 
##### 14. Delete an active course with no related course statuses (step 9 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the course has no related course status
   3. The system deletes the course
   4. The system deletes the related course dependencies
   5. The system deletes the related course modules
   6. End of flow
 
##### 15. Delete an active course with related course statuses (step 9 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the course has related course status
   3. The system does not delete the module
   4. The system displays an error message
   5. End of flow
 
##### 16. Inactivate an active course with no related course statuses (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the status of the course to “Inactive” 
   3. The administrator presses the Save button
   4. The system verifies that the course has no related course status
   5. The system updates the course
   6. The system displays the course detail page
   7. End of flow
 
##### 17. Inactivate an active course with related course statuses (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the status of the course to “Inactive” 
   3. The administrator presses the Save button
   4. The system verifies that the course has related course status
   5. The system updates the course
   6. The system displays the course detail page
   7. End of flow
 
##### 18. Edit an inactive course (step 9 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes (except change the status)
   3. The administrator presses the Save button
   4. The system verifies that the status of the course is “Inactive”
   5. The system verifies that all other validations succeed
   6. The system updates the course
   7. The system displays the course detail page
   8. End of flow
 
#### 19. The start date is earlier than the current date (step 5 of basic flow)
   1. The system verifies that “Start Date” is earlier than the current date
   2. The system does not create the course
   3. The system displays an error message
   4. End of flow
 
##### 20. The end date is earlier than the current date (step 5 of basic flow)
   1. The system verifies that “End Date” is earlier than the current date
   2. The system does not create the course
   3. The system displays an error message
   4. End of flow
 
##### 21. The start date is later than the end date (step 5 of basic flow)
   1. The system verifies that the “Start Date” is later than the “End Date”
   2. The system does not create the course
   3. The system displays an error message
   4. End of flow
