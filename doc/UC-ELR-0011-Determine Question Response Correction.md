## Determine Question Response Correction

### Objectives
This use case determines the question response correction when the question response is submitted (IsSubmitted = TRUE)

### Preconditions
The question response is submitted (IsSubmitted = TRUE)

### Postconditions
The question correction was determined

### Flow of Events

### Basic Flow 
   1. The system verifies that the question is from type “Single Choice”
   2. The system verifies that the received answer is the correct one
   3. The system sets the “IsCorrect” field to “true”
   4. End of flow

### Alternative Flows

##### 1.The question is from type “Single Choice” and the answer is not correct (step 2 of basic flow)
   1. The system verifies that the received answer is not the correct one
   2. The system sets the “IsCorrect” to “false” 
   3. End of flow
   
##### 2. The question is from type “Multiple Choice” and all the answers are correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Multiple Choice”
   2. The system verifies that all received answers match the correct ones
   3. The system sets the “IsCorrect” field to “true”
   4. End of flow

##### 3. The question is from type “Multiple Choice” and not all the answers are correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Multiple Choice”
   2. The system verifies that the received answers don’t match the correct ones
   3. The systems sets the “IsCorrect” field to “false”
   4. End of flow

##### 4. The question is from type “Short Answer” and the answer is correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Short Answer”
   2. The system verifies that the received answer matches one of the possible correct answers
   3. The system sets the “IsCorrect” field to “true”
   4. End of flow

##### 5. The question is from type “Short Answer” and the answer is not correct (step 1 of basic flow)
   1. The system verifies that the question is from type “Short Answer”
   2. The system verifies that the received answer doesn’t match any of the possible correct answers
   3. The system sets the “IsCorrect” field to “false”
   4. End of flow
