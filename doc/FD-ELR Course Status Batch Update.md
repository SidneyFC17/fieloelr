# Installation script to schedule the batch process for Course Status
The batch process analyzes the course dates and its status. According to them, the course status may be changed as follows:

- The system looks for courses in (status = *Schedule* and startdate = today) or (status = *Active* and enddate = yesterday)
    - For courses that match the above conditions, if status is *Schedule*, it will be changed to *Active*;
    - For courses that match the above conditions, if status is *Active*, it will be changed to *Completed*.

The job that runs the batch process must have been set at:
> Jobs  
   |_> Scheduled Jobs -> <job name, e.g., **_Course Status Update_**>

If no schedule job is set to Course Status changing, it must be created as follows:
1. Go to:   
> Develop  
   |_> Apex Classes  
2. Press the *Schedule Apex* button;   
![image](https://user-images.githubusercontent.com/26011197/30222834-a7dadbee-949e-11e7-92c0-618904925248.png)  

3. Give the job a name, e.g., **_Course Status Update_**;
4. Select the Apex Class: *CourseStatusBatchSchedule*;
5. Set the frequency to *Weekly* and mark all days of the week;
6. Define a *Start* date and an *End* date as well as the *Preferred Start Time*;
7. Click *Save* button.  
![image](https://user-images.githubusercontent.com/26011197/30222977-56fafd8e-949f-11e7-9c11-564c2d8754ac.png)  

By setting this schedule job, the batch process will run every day at the defined Preferred Start Time, from the defined Start date up to the defined End date.

### Manual Batch Execution
To manually run the batch process that updates the course status, follow the below instructions:
1. In the desired Org, from the user's menu, click *Developer Console*;
2. On the Developer Console screen, click on the menu item *Debug -> Open Execute Anonymous Window*;
3. A new window will be opened where the code automatically inserted can be deleted.
4. Type the command line below, where *CourseStatusBatchSchedule* is the class name for the batch:  

        Database.executeBatch(new CourseStatusBatchSchedule());  
  
5. Press *Execute* button;
6. At the Org where the batch were executed, go to *Apex Jobs* page;
7. Compare the results in the page to your execution info  
7.1  If no errors were found, and the execution has found registers to update, it will indicate the total batch quantity (in this case 1) and the batches that were executed (in this case 1);
![image](https://user-images.githubusercontent.com/26011197/30215742-4c117cee-9487-11e7-9815-686661f3b3ee.png)  

7.2 If the execution has found no errors and no registers to update, it will indicate that no batches were executed;  
![image](https://user-images.githubusercontent.com/26011197/30215794-724d5f90-9487-11e7-9f28-0edcdea65632.png)  

7.3 If errors were found, it will show the errors.  
![image](https://user-images.githubusercontent.com/26011197/30215840-a13e4292-9487-11e7-9f9f-34e7ac924f93.png)
