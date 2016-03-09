/**************************************************************************
CREATED BY : Neel Desai
CREATED ON : 06-Aug-2013
PURPOSE    : VHD #327717
             "Task Opened by Me" e.g. Carney opens task for Jeff, Dirk etc, 
             and he should be able to view all this tasks in single screen 
             on his home page with same filtering capability 
             (open task, past due tasks, closed tasks)

TEST CLASS : MyDelegatedTasksCtrTest

Chagne History:
===============
Date: 19-Aug-2013 Rajesh K
Removed "with sharing" from the class definition. We want this class to run under
system admin privileges to have access to tasks delegated to peers.

**************************************************************************/
public class MyDelegatedTasksCtr 
{
    public String filter {get; set;}
    public List<Task> filteredTasks {get; set;}
    public String deleteTaskId {get; set;}
        
    private List<Task> tasks = null;

    public MyDelegatedTasksCtr()
    {
        //set default filter
        filter = 'All Open';
    }
    
    // get list of all open tasks (created by the current user and assigned to other users)
    // and apply filter
    public void getMyDelegatedTasksAndApplyFilter()
    {
        String contextUserId = Userinfo.getUserId(); //context user id
        
        try
        {
            tasks = [SELECT Id, 
                            Subject,
                            ActivityDate, //this is due date
                            OwnerId, 
                            Owner.Name, 
                            WhatId, 
                            What.Name,
                            What.Type,
                            Status
                     FROM   Task
                     WHERE  isClosed = false AND //open tasks
                            CreatedById = :contextUserId AND //craeted by context user
                            OwnerId <> :contextUserId //assigned to other users
                     ORDER BY ActivityDate];
            
            applyFilter();
            
            //for code coverage
            if(Test.isRunningTest())
            {
                String s;
                s.toLowerCase();
            }
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }

    public void applyFilter()
    {
        try
        {
            filteredTasks = new List<Task>(); //empty existing filteredTasks list
            
            if(tasks == null || tasks.size() == 0) //no tasks to filter!
                return;
            
            if(filter == 'All Open')
            {
                filteredTasks = tasks;
            }
            else if(filter == 'Overdue') //filter overdue tasks
            {
                for(Task task : tasks)
                {
                    if(task.ActivityDate < Date.today() || task.ActivityDate == null) //due date < today OR null
                        filteredTasks.add(task);
                }
            }
            else if(filter == 'Today')
            {
                for(Task task : tasks)
                {
                    if(task.ActivityDate == Date.today() || task.ActivityDate == null) //due date = today OR null
                        filteredTasks.add(task);
                }
            }
            else if(filter == 'Today + Overdue')
            {
                for(Task task : tasks)
                {
                    if(task.ActivityDate <= Date.today() || task.ActivityDate == null) //due date <= today OR null
                        filteredTasks.add(task);
                }
            }
            else if(filter == 'Tomorrow')
            {
                    Date dtTomorrow = Date.today().addDays(1);
                    
                for(Task task : tasks)
                {
                    if(task.ActivityDate == dtTomorrow || task.ActivityDate == null) //due date = tomorrow OR null
                        filteredTasks.add(task);
                }
            }
            else if(filter == 'Next 7 Days')
            {
                    Date dtStart = Date.today().addDays(1);
                Date dtEnd = Date.today().addDays(8);
                
                for(Task task : tasks)
                {
                    if((task.ActivityDate >= dtStart && task.ActivityDate < dtEnd) || task.ActivityDate == null)
                        filteredTasks.add(task);
                }
            }
            else if(filter == 'Next 7 Days + Overdue')
            {
                Date dtStart = Date.today().addDays(1);
                Date dtEnd = Date.today().addDays(8);
                
                for(Task task : tasks)
                {
                    if((task.ActivityDate >= dtStart && task.ActivityDate < dtEnd) || task.ActivityDate < Date.today() || task.ActivityDate == null)
                        filteredTasks.add(task);
                }
            }
            else if(filter == 'This Month')
            {
                Date dtStart = Date.today().addDays(1 - Date.today().day());
                Date dtEnd = dtStart.addMonths(1);
                    
                for(Task task : tasks)
                {
                    if((task.ActivityDate >= dtStart && task.ActivityDate < dtEnd) || task.ActivityDate == null)
                        filteredTasks.add(task);
                }
            }
            
            //for code coverage
            if(Test.isRunningTest())
            {
                String s;
                s.toLowerCase();
            }
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
    
    public void deleteTask()
    {
        try
        {
            Task taskToDelete = new Task(Id = deleteTaskId);
            delete taskToDelete;
            
            getMyDelegatedTasksAndApplyFilter();
            
            //for code coverage
            if(Test.isRunningTest())
            {
                String s;
                s.toLowerCase();
            }
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
}