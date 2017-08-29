## Change Status of Course

### Objectives 
This use case describes the possible status for the Course
 
### Preconditions
The administrator must be logged in  
There must be at least one Course in “Draft” status
 
### Postconditions
The Course has its status changed
 
### Flow of Events

### Basic Flow  
   1. The administrator selects, in the Courses Landing Page, a course which status is “Draft”
   2. The system displays the course details page
   3. The system displays the “Activate” button
   4. The administrator presses the “Activate” button
   5. The system verifies that there is, at least, one active related module
   6. The system verifies that the current date is within the period set for the course
   7. The system updates the course status to “Active”
   8. The system refreshes the course details page
   9. The system displays the “Inactivate” button
   10. End of flow

### Alternative flows  

##### 1. Activate a course in status “Draft” that has no defined period (step 6 of basic flow)
   1. The system verifies that there is no start date and no end date defined to the course
   2. Back to step 7 of basic flow

##### 2. Schedule a course in status “Draft” that has its start date in the future (step 6 of basic flow)
   1. The system verifies that the start date set to the course is in the future
   2. The system updates the course status to “Scheduled”
   3. Back to step 7 of basic flow

##### 3. Complete a course in status “Draft” that has its end date in the past (step 6 of basic flow)
   1. The system verifies that the end date set to the course is in the past
   2. The system updates the course status to “Completed”
   3. Back to step 7 of basic flow

##### 4. Activate a course that has no active related modules (step 5 of basic flow)
   1. The system verifies that there is no active related modules
   2. The system does not update the course status
   3. The system displays an error message 
   4. End of flow

##### 5. Inactivate an active course (step 1 of basic flow)
   1. The administrator selects, in the Courses Landing Page, a course which status is “Active”
   2. The system displays the course details page
   3. The system displays the “Inactivate” button
   4. The administrator presses the “Inactivate” button
   5. The system updates the course status to “Inactive”
   6. The system refreshes the course details page
   7. The system displays the “Activate” button
   8. End of flow

##### 6. Inactivate a scheduled course (step 1 of basic flow)
   1. The administrator selects, in the Courses Landing Page, a course which status is “Scheduled”
   2. The system displays the course details page
   3. The system displays the “Inactivate” button
   4. The administrator presses the “Inactivate” button
   5. The system updates the course status to “Inactive”
   6. The system refreshes the course details page
   7. The system displays the “Activate” button
   8. End of flow

##### 7. Inactivate a completed course (step 1 of basic flow)
   1. The administrator selects, in the Courses Landing Page, a course which status is “Completed”
   2. The system displays the course details page
   3. The system displays the “Inactivate” button
   4. The administrator presses the “Inactivate” button
   5. The system updates the course status to “Inactive”
   6. The system refreshes the course details page
   7. The system displays the “Activate” button
   8. End of flow

##### 8. Activate an inactive course (step 1 of basic flow)
   1. The administrator selects, in the Courses Landing Page, a course which status is “Inactive”
   2. The system displays the course details page
   3. The system displays the “Activate” button
   4. The administrator presses the “Activate” button
   5. The system verifies that there is, at least, one active related module
   6. The system verifies that the current date is within the period set for the course or that the course has no period
   7. The system updates the course status to “Active”
   8. The system refreshes the course details page
   9. The system displays the “Inactivate” button
   10. End of flow

##### 9. Schedule an inactive course (step 1 of basic flow)
   1. The administrator selects, in the Courses Landing Page, a course which status is “Inactive”
   2. The system displays the course details page
   3. The system displays the “Activate” button
   4. The administrator presses the “Activate” button
   5. The system verifies that there is, at least, one active related module
   6. The system verifies that the start date set to the course is in the future
   7. The system updates the course status to “Scheduled”
   8. The system refreshes the course details page
   9. The system displays the “Inactivate” button
   10. End of flow

##### 10. Complete an inactive course (step 1 of basic flow)
   1. The administrator selects, in the Courses Landing Page, a course which status is “Inactive”
   2. The system displays the course details page
   3. The system displays the “Activate” button
   4. The administrator presses the “Activate” button
   5. The system verifies that there is, at least, one active related module
   6. The system verifies that the end date set to the course is in the past
   7. The system updates the course status to “Completed”
   8. The system refreshes the course details page
   9. The system displays the “Inactivate” button
   10. End of flow
