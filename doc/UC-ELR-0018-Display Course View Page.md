## Display Course View Page
 
### Objectives
The present use case describes how the system displays the Course details and the action buttons for each course status
 
### Preconditions
The administrator must be logged in  
There must be Courses in all status (Draft, Active and Inactive)
 
### Postconditions
The system displayed the details of the selected course
 
### Flow of Events
 
### Basic Flow
   1. The administrator presses the Courses tab
   2. The system displays the Courses landing page
   3. The administrator selects a Program
   4. The administrator selects one of the courses of the selected Program, which status is “Draft”
   5. The system displays the Course details page, containing:
       - The course name
       - Edit button
       - Activate button
       - Tools button (with the options View, Delete, Settings and Export)
       - Fieldset defined for the Course view
       - Fieldset defined for the Course detail
       - Related lists defined for the Courses view page (Modules, Course Dependencies and Course Status)
   6. The system displays, in the Course Status related list, the Name column where the Name of the course status is the name of the Member related to the course status
   7. End of flow
 
### Alternative Flows
 
##### 1. Course status is “Active” (step 4 of basic flow)
   1. The administrator selects one of the courses of the selected Program, which status is "Active"
   2. The system displays the Course details page, containing:
       - The course name
       - Edit button
       - Inactivate button
       - Tools button (with the options View, Delete, Settings and Export)
       - Fieldset defined for the Course view
       - Fieldset defined for the Course detail
       - Related lists defined for the Courses view page (Modules, Course Dependencies and Course Status)
   3. End of flow
 
##### 2. Course status is "Inactive" (step 4 of basic flow)
   1. The administrator selects one of the courses of the selected Program, which status is "Inactive"
   2. The system displays the course details page, containing:
       - The course name
       - Edit button
       - Activate button
       - Tools button (with the options View, Delete, Settings and Export)
       - Fieldset defined for the Course view
       - Fieldset defined for the Course detail
       - Related lists defined for the Courses view page (Modules, Course Dependencies and Course Status)
   3. End of flow
 
##### 3. Edit course (step 5 of basic flow)
   1. The administrator presses the Edit button
   2. The system displays the Edit page of the course
   3. The system displays the fieldset defined for the course edit page
   4. The administrator makes the desired changes
   5. The administrator presses the Save button
   6. The system calls the Use Case [*Create Course*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0001-Create%20Course.md)
   7. End of flow
 
##### 4. Activate course (step 5 of basic flow)
   1. The administrator presses the Activate button 
   2. The system calls the Use Case [*Create Course*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0001-Create%20Course.md)
   3. End of flow
 
##### 5. Inactivate course (step 2 of alternative flow 1)
   1. The administrator presses the Inactivate button
   2. The system calls the Use Case [*Create Course*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0001-Create%20Course.md)
   3. End of flow
 
##### 6. Reorder Modules (step 5 of basic flow)
   1. The administrator presses the Reorder button on the Modules related list
   2. The system displays the Reorder Module page
   3. The administrator uses the drag&drop functionality to position the module in the desired order
   4. The administrator presses the Save button
   5. The system sets the Order field of each module as defined by the administrator in the Reorder Module page
   6. End of flow
 
##### 7. Create new module (step 5 of basic flow)
   1. The administrator presses the New button on the Modules related list
   2. The system calls the Use Case [*Create Module Backend Page*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0015-Create%20Module%20Backend%20Page.md)
   3. End of flow
 
##### 8. Create new Course Dependency (step 5 of basic flow)
   1. The administrator presses the New button on the Course Dependencies related list
   2. The system calls the Use Case [*Create Course Backend Page*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0014-Create%20Course%20Backend%20Page.md)
   3. End of flow
