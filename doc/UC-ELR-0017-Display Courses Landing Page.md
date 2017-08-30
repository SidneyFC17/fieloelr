## Display Courses Landing Page
 
### Objectives
The present use case describes the display of the Courses landing page
 
### Preconditions
The administrator must be logged in
 
### Postconditions
Courses for the selected Program and View were displayed
 
### Flow of Events
 
### Basic Flow
1. The administrator presses the Courses tab 
2. The system displays the courses landing page containing the following items:
   - Current Course View
   - Program Selector 
   - New button
   - Tools options
   - Status view options (Draft, Active, Inactive, Scheduled, Completed)
   - Courses list
3. The system shows as the default view, when page loads, the list of Draft Courses
4. The system shows, in the picklist for Programs, all the existing Programs for selection
5. The system shows in the Courses list the columns defined in the fieldset of the page settings for the Courses landing page
6. End of flow
 
### Alternative Flows
 
##### 1. The administrator changes the view (step 3 of the basic flow)
   1. The administrator presses each of the Course views
   2. The system displays the list of Courses which status corresponds the selected view
   3. The system changes the current view info on the top of the page to the selected view
   4. End of flow 
   
##### 2. There is only one Program available (step 4 of the basic flow)
   1. The system does not show the Program selection with its picklist
   2. End of flow
   
##### 3. The administrator changes the Program (step 4 of the basic flow)
   1. The administrator changes the Program in the picklist
   2. The system displays the courses list of the selected Program
   3. End of flow
   
##### 4. The administrator selects a Course of the list (step 5 of the basic flow)
   1. The administrator selects a Course
   2. The system shows the Course detail page
   3. End of flow
