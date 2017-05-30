## Determine Question Response Correction
 
### Objectives
This use case determines the question response correction when the question response is submitted
 
### Preconditions
The question response is submitted (IsSubmitted = TRUE)
 
### Postconditions
The question correction was determined
 
### Flow of Events
 
### Basic Flow 
   1. The system verifies that the related question is from type “Single Choice”
   2. The system verifies that the answer is the same as the correct answer option
   3. The system sets the “IsCorrect” field to “true”
   4. End of flow
 
### Alternative Flows
 
##### 1. The related question is from type “Single Choice” and the answer is not correct (step 2 of basic flow)
   1. The system verifies that the answer is not the same as the correct answer option
   2. The system sets the “IsCorrect” to “false”
   3. End of flow
 
##### 2. The related question is from type “Multiple Choice” and all the answers are correct (step 1 of basic flow)
   1. The system verifies that the related question is from type “Multiple Choice”
   2. The system verifies that all answers match the correct answers options
   3. The system verifies that no answer is missing
   4. The system sets the “IsCorrect” field to “true”
   5. End of flow
 
##### 3. The related question is from type “Multiple Choice” and not all the answers are correct (step 1 of basic flow)
   1. The system verifies that the related question is from type “Multiple Choice”
   2. The system verifies that at least one of the answers doesn’t match the correct answers options
   3. The systems sets the “IsCorrect” field to “false”
   4. End of flow
 
##### 4. The related question is from type “Short Answer” and the answer is correct (step 1 of basic flow)
   1. The system verifies that the related question is from type “Short Answer”
   2. The system verifies that the “Text Value” field in the question response matches one of the possible correct answer options
   3. The system sets the “IsCorrect” field to “true”
   4. End of flow
 
##### 5. The related question is from type “Short Answer” and the answer is not correct (step 1 of basic flow)
   1. The system verifies that the related question is from type “Short Answer”
   2. The system verifies that the “Text Value” field in the question response does not match any of the possible correct answers
   3. The system sets the “IsCorrect” field to “false”
   4. End of flow
 
##### 6. The related question is from type “Statement” and the answer is correct (step 1 of basic flow)
   1. The system verifies that the related question is from type “Statement”
   2. The system verifies that the answer is the same as the correct answer option
   3. The system sets the “IsCorrect” field to “true”
   4. End of flow
 
##### 7. The related question is from type “Statement” and the answer is not correct (step 1 of basic flow)
   1. The system verifies that the related question is from type “Statement”
   2. The system verifies that the answer is not the same as the correct answer option
   3. The system sets the “IsCorrect” field to “false”
   4. End of flow
 
##### 8. The related question is from type “Matching Options” and all the answers are correct (step 1 of basic flow)
   1. The system verifies that the related question is from type “Matching Options”
   2. The system verifies that all the “Text Value” fields in the “Answer” match one of the “Answer text” field in answer option 
   3. The system sets the “IsCorrect” field to “true”
   4. End of flow
 
##### 9. The related question is from type “Matching Options” and not all the answers are correct (step 1 of basic flow)
   1. The system verifies that the related question is from type “Matching Options”
   2. The system verifies that at least one of the “Text Value” fields in the “Answer” don’t match the “Answer text” field in the answer option
   3. The system sets the “IsCorrect” field to “false”
   4. End of flow
