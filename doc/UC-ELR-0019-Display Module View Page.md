## Display Module View Page
 
### Objectives
The present use case describes how the system displays the Module details
 
### Preconditions
- The administrator must be logged in
 
### Postconditions
- The system displayed the details of the selected module
 
### Flow of Events
 
### Basic Flow
   1.  The administrator goes to the Course view backend page
   2. The administrator presses the Name of the desired module
   3. The system displays the Module details page, containing:
       - The module name
       - Edit button
       - Activate or Inactivate button
       - Tools button (with the options View, Delete and Settings)
       - Fieldset defined for the Module view
       - Fieldset defined for the Module detail
       - Related lists defined for the Module view page (Questions, Modules Dependencies and Modules Responses)
   4. End of flow
 
### Alternative Flows
 
##### 1. Edit module (step 3 of basic flow)
   1. The administrator presses the Edit button
   2. The system displays the Edit page of the module
   3. The system displays the fieldset defined for the module edit page
   4. The administrator makes the desired changes
   5. The administrator presses the Save button
   6. The system calls the Use Case [*Create Module*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0003-Create%20Module.md)
   7. End of flow
 
##### 2. Activate module (step 3 of basic flow)
   1. The administrator presses the Activate button 
   2. The system calls the Use Case [*Create Module*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0003-Create%20Module.md)
   3. End of flow
 
##### 3. Inactivate module (step 3 of basic flow)
   1. The administrator presses the Inactivate button 
   2. The system calls the Use Case [*Create Module*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0003-Create%20Module.md)
   3. End of flow
 
##### 4. Manage Questions (step 3 of basic flow)
   1. The administrator presses the Manage button on the Questions related list
   2. The system displays the Manage Questions page
   3. The administrator presses the Save button
   4. The system calls the Use Case [*Manage Questions*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0020-Manage%20Questions.md)
   5. End of flow
 
##### 5. Create a new question (step 3 of basic flow)
   1. The administrator presses the New button on the Questions related list
   2. The system calls the Use Case [*Create Question Backend Page*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0016-Create%20Question%20Backend%20Page.md)
   3. End of flow
 
##### 6. Create a new Module Dependency (step 3 of basic flow)
   1. The administrator presses the New button on the Course Dependencies related list
   2. The system calls the Use Case [*Create Module Backend Page*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0015-Create%20Module%20Backend%20Page.md)
   3. End of flow
