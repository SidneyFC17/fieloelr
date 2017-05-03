## Determine Question Result

### Objectives
This use case describes how to determine if a question response is correct when it’s submitted (IsSubmitted = TRUE)

### Preconditions

### Postconditions
The question correction status was calculated

### Flow of Events

### Basic Flow 
   1. The system verifies that the question response is submitted ("IsSubmitted" field is set to "True")
   2. The system verifies that there is, at least, one answer for the question
   3. The system verifies that the question is not already correctly answered (“IsCorrect” is set to “false”)
   4. The system verifies that all the answer responses related to the question are the correct ones
   5. The system sets the “IsCorrect” field to “true”
   6. End of flow

### Alternative Flows

##### 1.Not all the answers for the question are correct (step 4 of basic flow)
   1. The system verifies that not all the answer responses related to the question are correct
   2. The system sets the “IsCorrect” field to “false” 
   3. End of flow
