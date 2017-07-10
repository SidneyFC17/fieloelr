## Create Module Backend Page
 
### Objectives 
The present use case describes how the system creates a Module through its backend page
 
### Preconditions
The administrator must be logged in  
The related course must be in status "Draft" or "Inactive"
 
### Postconditions
A module was created
 
### Flow of Events
 
### Basic Flow
   1. The administrator goes to the Course details page
   2. The administrator presses the New button in the Modules related list
   3. The system displays the New Module page
   4. The system displays the fields defined in the fieldset of the page settings for the New Module page 
   5. The system displays the buttons Cancel and Save
   6. The administrator fills the required fields
   7. The administrator presses the Save button 
   8. The system calls the Use Case [*Create Module*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0003-Create%20Module.md)
   9. The system displays the Module view backend page with all its defined related lists
   10. End of flow
 
### Alternative flows
 
##### 1. The administrator presses the New button in the Module Dependencies related list (step 9 of basic flow)
   1. The administrator presses the New module dependency button
   2. The system displays the New Module Dependency page
   3. The system displays the fields defined in the fieldset of the page settings for the New Module Dependency page 
   4. The system displays the buttons Cancel and Save
   5. The administrator fills the required fields
   6. The administrator presses the Save button 
   7. The system calls the Use Case [*Create Module Dependency*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0004-Create%20Module%20Dependency.md)
   8. Back to step 9 of basic flow
 
##### 2. Edit module (step 9 of basic flow)
   1. The administrator presses the Edit button in the Module view backend page
   2. The administrator makes the desired changes
   3. Back to step 8 of basic flow
