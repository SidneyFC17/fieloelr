## Display Question View Page
 
### Objectives
The present use case describes how the system displays the Question details
 
### Preconditions
- The administrator must be logged in
 
### Postconditions
- The system displayed the details of the selected question
 
### Flow of Events
 
### Basic Flow
   1.  The administrator goes to the Module view backend page
   2. The administrator presses the Name of the desired question
   3. The system displays the Question details page, containing:
       - The question name
       - Edit button
       - Tools button (with the options View, Delete and Settings)
       - Fieldset defined for the Question view
       - Fieldset defined for the Question detail
       - Related lists defined for the Question view page (Answer Options)
   4. End of flow
 
### Alternative Flows
 
##### 1. Edit question (step 3 of basic flow)
   1. The administrator presses the Edit button
   2. The system displays the Edit page of the question
   3. The system displays Question Wizard page
   4. The administrator makes the desired changes
   5. The administrator presses the Save button
   6. The system calls the Use Case [*Create Question Backend Page*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0016-Create%20Question%20Backend%20Page.md)
   7. End of flow
