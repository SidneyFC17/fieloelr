## Create Course Backend Page
 
### Objectives 
The present use case describes how the system creates a Course through its backend page
 
### Preconditions
The administrator must be logged in
 
### Postconditions
A course was created
 
### Flow of Events
 
### Basic Flow
   1. The administrator presses the Courses tab
   2. The system displays the Courses landing page
   3. The administrator selects a Program
   4. The administrator presses the New button
   5. The system displays the New Course page
   6. The system displays the fields defined in the fieldset of the page settings for the New Course page 
   7. The system displays the buttons Cancel and Save
   8. The administrator fills the Course Name field
   9. The administrator keeps the Program field value
   10. The administrator selects the Segments for the course by clicking them and then clicking the arrow to the right
   11. The administrator selects the Subscription Mode
   12. The administrator fills the Description field
   13. The administrator fills the Start Date field with a date equal or greater than the current date
   14. The administrator fills the End Date field with a date equal or greater than the current date
   15. The administrator presses the Save button 
   16. The system sets the Course status to "Draft"
   17. The system calls the Use Case [*Create Course*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0001-Create%20Course.md)
   18. The system displays the Course view backend page with all its defined related lists 
   19. End of flow
 
### Alternative flows
 
##### 1. The Course Name is not filled (step 8 of basic flow)
   1. The administrator does not fill the Course Name field
   2. The administrator presses the Save button
   3. The system does not create the Course
   4. The system displays an error message
   5. End of flow

##### 2. The Program is not filled (step 9 of basic flow)
   1. The administrator clears the Program field
   2. The administrator presses the Save button
   3. The system considers for the Program field the program that user selected before pressing the New button
   4. Back to step 16 of basic flow
   
##### 3. Subscription Mode is not selected (step 11 of basic flow)
   1. The administrator does not select a Subscription Mode
   2. The administrator presses the Save button
   3. The system considers the Subscription Mode as "Manual"
   4. Back to step 11 of basic flow
   
##### 4. The administrator presses the New button in the Course Dependencies related list (step 18 of basic flow)
   1. The administrator presses the New course dependency button
   2. The system displays the New Course Dependency page
   3. The system displays the fields defined in the fieldset of the page settings for the New Course Dependency page 
   4. The system displays the buttons Cancel and Save
   5. The administrator fills the required fields
   6. The administrator presses the Save button 
   7. The system calls the Use Case [*Create Course Dependency*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0002-Create%20Course%20Dependency.md)
   8. Back to step 12 of basic flow
 
##### 5. Edit course (step 18 of basic flow)
   1. The administrator presses the Edit button in the Course view backend page
   2. The administrator makes the desired changes
   3. Back to step 17 of basic flow
