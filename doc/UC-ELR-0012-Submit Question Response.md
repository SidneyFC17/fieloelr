## Submit Question Response
 
### Objectives
This use case describes the partial grade calculations performed when a question response has its correction determined
 
### Preconditions
The question response correction is already determined (Use Case [*Determine Question Response Correction*](https://github.com/FieloIncentiveAutomation/fieloelr/blob/feature/elrbackend/doc/UC-ELR-0001-Determine%20Question%20Response%20Correction.md) already run)
 
### Postconditions
The partial grade value was calculated
 
### Flow of Events
 
### Basic Flow 
   1. The system verifies that “IsCorrect” field is set to “true” and the “Penalty Mode” is set to “None”
   2. The system updates the “Partial Grade Value” with the “Correct Weight” field value in the related question
   3. End of flow
 
### Alternative Flows
 
##### 1. The question response is not correct and the “Penalty Mode” is set to “None” (step 1 of basic flow)
   1. The system verifies that “IsCorrect” field is set to “false” and the “Penalty Mode” is set to “None”
   2. The system updates the “Partial Grade Value” with the value 0 (zero)
   3. End of flow
 
##### 2. The question response is correct and the “Penalty Mode” is set to “Negative Weight” (step 1 of basic flow)
   1. The system verifies that “IsCorrect” field is set to “true” and the “Penalty Mode” is set to “Negative Weight”
   2. The system updates the “Partial Grade Value” with the “Correct Weight” field value in the related question
   3. End of flow
 
##### 3. The question response is not correct and the “Penalty Mode” is set to “Negative Weight” (step 1 of basic flow)
   1. The system verifies that “IsCorrect” field is set to “false” and the “Penalty Mode” is set to “Negative Weight”
   2. The system updates the “Partial Grade Value” with the “Incorrect Weight” field value in the related question
   3. End of flow
 
##### 4. The question response is correct and the “Penalty Mode” is set to “Percent Decrease” (step 1 of basic flow)
   1. The system verifies that “IsCorrect” field is set to “true” and the “Penalty Mode” is set to “Percent Decrease”
   2. The system updates the “Partial Grade Value” by decreasing the "Correct Weight" from the "Penalty per Attempt" applied to each previous attempt (see Note 1)
   3. End of flow
 
##### 5. The question response is not correct and the “Penalty Mode” is set to “Percent Decrease” (step 1 of basic flow)
   1. The system verifies that “IsCorrect” field is set to “false” and the “Penalty Mode” is set to “Percent Decrease”
   2. The system updates the “Partial Grade Value” with the value 0 (zero)
   3. End of flow

   
###### *Note 1*
###### The partial grade is calculated by the following formula:
######          CW x (1 - PA (%)) ⌃ (AN - 1)
###### where: 	CW = Correct Weight
###### PA = Penalty per Attempt
###### AN = Attempt Number

