## Create Course

### Objectives 
This use case describes the creation of a Course

### Preconditions
The administrator must be logged in

### Postconditions
A course is created

### Flow of Events

### Basic Flow

   1. The system receives the required fields for the course
   2. The system receives the optional fields for the course
   3. The administrator presses the Save button
   4. The system verifies that the “Program” field is filled
   5. The system verifies that the “Segment” belongs to the “Program” already set
   6. The system sets the course status to “Draft”
   7. The system saves the course
   8. The system displays the course detail page
   9. End of flow

### Alternative flows

##### 1. The Program is not filled (step 4 of basic flow)
   1. The system verifies that the Program is not set
   2. The system does not create the course
   3. The system displays an error message
   4. End of flow

##### 2. The segment is not from the same program (step 5 of basic flow)
   1. The system verifies that the segment does not belong to the program set to the course
   2. The system does not create the course
   3. The system displays an error message
   4. End of flow

##### 3. The course is activated having active related modules (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the course status to “true”
   3. The administrator presses the Save button
   4. The system verifies that there is, at least, one active related module
   5. The system updates the course
   6. End of flow

##### 4. The course is activated having no active related modules (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator sets the course status to “true”
   3. The administrator presses the Save button
   4. The system verifies that there is no active related module
   5. The system does not update the module
   6. The system displays an error message 
   7. End of flow

##### 5. A draft course is edited (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the course status is “Draft”
   5. The system updates the course
   6. End of flow
   
##### 6. An active course with no related course statuses is edited (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the course status is “Active”
   5. The system verifies that the course has no related course status
   6. The system updates the course
   7. End of flow

##### 7. An active course with related course statuses is edited (step 8 of basic flow)
   1. The administrator presses the Edit button
   2. The administrator makes the desired changes 
   3. The administrator presses the Save button
   4. The system verifies that the course status is “Active”
   5. The system verifies that the course has related course status
   6. The system does not update the module
   7. The system displays an error message
   8. End of flow

##### 8. An active course with no related course statuses is deleted (step 8 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the course has no related course status
   3. The system deletes the course
   4. The system deletes all the related course dependencies, related Modules and related Course Status
   4. End of flow

##### 9. An active course with related course statuses is deleted (step 8 of basic flow)
   1. The administrator presses the Delete button
   2. The system verifies that the course has related course status
   3. The system does not delete the course
   4. The system displays an error message
   5. End of flow
