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
   8. The administrator fills the required fields
   9. The administrator selects the Segments for the course by clicking them and then clicking the arrow to the right
   10. The administrator presses the Save button 
   11. The system calls the Use Case [*Create Course*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0001-Create%20Course.md)
   12. The system displays the Course view backend page with all its defined related lists 
   13. End of flow
 
### Alternative flows
 
##### 1. The Program is not filled (step 8 of basic flow)
   1. The administrator clears the Program field
   2. The administrator presses the Save button
   3. The system considers for the Program field the program that user had selected before pressing the New button
   4. Back to step 11 of basic flow
 
##### 2. The administrator presses the New button in the Course Dependencies related list (step 12 of basic flow)
   1. The administrator presses the New course dependency button
   2. The system displays the New Course Dependency page
   3. The system displays the fields defined in the fieldset of the page settings for the New Course Dependency page 
   4. The system displays the buttons Cancel and Save
   5. The administrator fills the required fields
   6. The administrator presses the Save button 
   7. The system calls the Use Case [*Create Course Dependency*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0002-Create%20Course%20Dependency.md)
   8. Back to step 12 of basic flow
 
##### 3. Edit course (step 12 of basic flow)
   1. The administrator presses the Edit button in the Course view backend page
   2. The administrator makes the desired changes
   3. Back to step 10 of basic flow
