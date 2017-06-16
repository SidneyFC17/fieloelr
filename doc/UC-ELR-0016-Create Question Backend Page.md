## Create Question Backend Page
 
### Objectives 
The present use case describes how the system creates a Question through its backend page
 
### Preconditions
The administrator must be logged in
 
### Postconditions
A question was created
 
### Flow of Events
 
### Basic Flow
   1. The administrator goes to Module view backend page
   2. The administrator presses the New button in the Questions related list
   3. The system displays the Question Wizard page
   4. The administrator selects the “Multiple Choice” type of Question
   5. The administrator presses the Next button
   6. The system displays the Multiple Choice Question Wizard
   7. The system displays the following fields for the Question:
	    - Module (read only)
	    - Question Name (text)
	    - Shuffle Answer Options (checkbox)
	    - Question Text (text)
   8. The system displays the Answer Options area with the following fields:
	    - Answer Option Text
      - IsCorrect (checkbox)
   9. The system displays the New button in the Answer Options area
   10. The system displays for each answer option a Remove icon
   11. The system displays at the bottom of the page the buttons “Cancel”, “Save” and “Save and new”
   12. The administrator fills the required fields
   13. The administrator presses the Save button 
   14. The system calls the Use Case [*Create Question*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0005-Create%20Question.md)
   15. The system calls the Use Case [*Create Answer Option*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0006-Create%20Answer%20Option.md)
   16. The system displays the Module view backend page with all its defined related lists
   17. End of flow
 
### Alternative flows
 
##### 1. Question is from type “Single Choice” (step 4 of basic flow)
   1. The administrator selects the “Single Choice” type of Question
   2. The administrator presses the Next button
   3. The system displays the Single Choice Question Wizard
   4. The system displays the following fields for the Question:
	    - Module (read only)
	    - Question Name (text)
	    - Shuffle Answer Options (checkbox)
	    - Question Text (text)
   5. The system displays the Answer Options area with the following fields:
	    - Answer Option Text
      - IsCorrect (checkbox, set as “true” by default)
   6. The system displays the New button in the Answer Options area
   7. The system displays for each answer option a Remove icon
   8. The system displays at the bottom of the page the buttons “Cancel”, “Save” and “Save and new”
   9. The administrator fills the required fields
   10. The administrator presses the Save button 
   11. The system calls the Use Case [*Create Question*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0005-Create%20Question.md)
   12. The system calls the Use Case [*Create Answer Option*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0006-Create%20Answer%20Option.md)
   13. The system displays the Module view backend page with all its defined related lists
   14. End of flow
 
##### 2. Question is from type “Short Answer” (step 4 of basic flow)
   1. The administrator selects the “Short Answer” type of Question
   2. The administrator presses the Next button
   3. The system displays the Short Answer Question Wizard
   4. The system displays the following fields for the Question:
	    - Module (read only)
	    - Question Name (text)
	    - Shuffle Answer Options (checkbox)
	    - Question Text (text)
   5. The system displays the Answer Options area with the following field:
	    - Answer Option Text
   6. The system displays the New button in the Answer Options area
   7. The system displays for each answer option a Remove icon
   8. The system displays at the bottom of the page the buttons “Cancel”, “Save” and “Save and new”
   9. The administrator fills the required fields
   10. The administrator presses the Save button 
   11. The system calls the Use Case [*Create Question*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0005-Create%20Question.md)
   12. The system calls the Use Case [*Create Answer Option*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0006-Create%20Answer%20Option.md)
   13. The system displays the Module view backend page with all its defined related lists
   14. End of flow
 
##### 3. Question is from type “Statement” (step 4 of basic flow)
   1. The administrator selects the “Statement” type of Question
   2. The administrator presses the Next button
   3. The system displays the Statement Question Wizard
   4. The system displays the following fields for the Question:
	    - Module (read only)
	    - Question Name (text)
	    - Shuffle Answer Options (checkbox)
	    - Question Text (text)
   5. The system displays the Answer Options area with two lines already created where the Answer Option Text are “True” and “False”
   6. For the first line, the IsCorrect checkbox is set to “true” by default
   7. The system displays at the bottom of the page the buttons “Cancel”, “Save” and “Save and new”
   8. The administrator fills the required fields
   9. The administrator presses the Save button 
   10. The system calls the Use Case [*Create Question*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0005-Create%20Question.md)
   11. The system calls the Use Case [*Create Answer Option*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0006-Create%20Answer%20Option.md)
   12. The system displays the Module view backend page with all its defined related lists
   13. End of flow
 
##### 4. Question is from type “Matching Options” (step 4 of basic flow)
   1. The administrator selects the “Matching Options” type of Question
   2. The administrator presses the Next button
   3. The system displays the Matching Options Question Wizard
   4. The system displays the following fields for the Question:
	    - Module (read only)
	    - Question Name (text)
	    - Shuffle Answer Options (checkbox)
	    - Question Text (text)
   5. The system displays the Answer Options area with the following fields:
      - Answer Option Text
      - Matching Text
   6. The system displays the New button in the Answer Options area
   7. The system displays for each answer option a Remove icon
   8. The system displays at the bottom of the page the buttons “Cancel”, “Save” and “Save and new”
   9. The administrator fills the required fields
   10. The administrator presses the Save button 
   11. The system calls the Use Case [*Create Question*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0005-Create%20Question.md)
   12. The system calls the Use Case [*Create Answer Option*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0006-Create%20Answer%20Option.md)
   13. The system displays the Module view backend page with all its defined related lists
   14. End of flow
 
##### 5. The administrator does not select any type of question (step 4 of basic flow)
   1. The administrator does not select  any type of question
   2. The administrator presses the Next button
   3. The system displays an error message
   4. The system doesn’t resume the creation of the question
   5. End of flow
 
##### 6. Question name is null (step 12 of basic flow)
   1. The administrator does not fill the Question Name field
   2. The administrator presses the Save button 
   3. The system automatically fills the Question Name field with the 20 first characters of the Question Text
   4. The system calls the Use Case [*Create Question*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0005-Create%20Question.md)
   5. The system calls the Use Case [*Create Answer Option*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0006-Create%20Answer%20Option.md)
   6. The system displays the Module view backend page with all its defined related lists
   7. End of flow
 
##### 7. The administrator presses the New button (step 9 of basic flow)
   1. The administrator presses the New button in the Answer Options area
   2. The system adds a new line to the Answer Options area
   3. Back to step 10 of basic flow
 
##### 8. The administrator presses the Save and new button (step 13 of basic flow)
   1. The administrator presses the Save and new button
   2. The system calls the Use Case [*Create Question*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0005-Create%20Question.md)
   3. The system calls the Use Case [*Create Answer Option*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0006-Create%20Answer%20Option.md)
   4. The system automatically opens the Question Wizard first page
   5. End of flow