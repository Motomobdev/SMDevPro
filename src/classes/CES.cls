public with sharing class CES
{
    
    public Integer sortColumn { get; set; }
   public Integer sortColumn1 { get; set; }
 
   public String userType { get; set; }
    public String year {get; set;}
    public String year1 {get; set;}
    public transient String htmlBody {get; set;}
    public customer_meeting__c cust{get;set;}
     public String publiccalender{get;set;}
     public Integer currentYear {get;set;}
     public Date currentDate {get;set;}
    public CES()
    {
    sortColumn=0;
    sortColumn1=0;
        if(ApexPages.currentPage().getParameters().get('year') != null){
            year = ApexPages.currentPage().getParameters().get('year');
            }
        else
        {
            year = String.valueOf(Date.today().year());
          //buildHtmlTable();
          }
          year1 = String.valueOf(Date.today().year()-1);
        Schema.DescribeFieldResult fieldResult = customer_meeting__c.PublicCalendar__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
    }
    
   public void search() {
     currentDate = system.Today();
          currentYear = currentDate.year();
     
    if(userType =='Current Year Meetings')
        {
       
           buildHtmlTable1();
           userType=''+string.valueof(currentYear) + '  Meetings';
                  
        }else if(userType =='Last Year Meetings')
        {
        buildHtmlTable2();
        
         userType=' '+ string.valueof(currentYear-1) +'  Meetings';
        }
              
    }
    
    public PageReference sort() {
           currentDate = system.Today();
          currentYear = currentDate.year();
    buildHtmlTable1();
       userType=''+string.valueof(currentYear) + '  Meetings';
        return null;
    }
 
 public PageReference sort1() {
           currentDate = system.Today();
          currentYear = currentDate.year();
    buildHtmlTable2();
       userType=' '+ string.valueof(currentYear-1) +'  Meetings';
        return null;
    }
     private void buildHtmlTable1()
    {
        String okrName = 'CES ' + year;
        
        Map<ID, customer_meeting__c> meetingMap =
            new Map<ID, customer_meeting__c>(
              [select id, name from customer_meeting__c limit5000
              ]);
        
        Map<ID, List<String>> gDocAttachmentMap = new Map<ID, List<String>>();
        
        for (Attachment a : [select id, name, parentid from Attachment where parentid in :meetingmap.keyset()]) {
        
            String s = '<a href="https://mobility.my.salesforce.com/servlet/servlet.FileDownload?file='
                    + a.id + '"><span>' + a.name + '</span></a>';
        
            List<String> attachments = gDocAttachmentMap.get(a.parentid);
            if (attachments == null) {
                attachments = new List<String>{s} ;
                gDocAttachmentMap.put(a.parentid, attachments);
            } else
                attachments.add(s);
        }
        
        for (GoogleDoc g : [select id, name, parentid, url from GoogleDoc where parentid in :meetingmap.keyset()]) {
        
            String s = '<a href="' + g.url + '"><span>' + g.name + '</span></a>';
            List<String> gdocIds = gDocAttachmentMap.get(g.parentid);
            if (gdocIds == null) {
                gdocIds = new List<String>{s} ;
                gDocAttachmentMap.put(g.parentid, gdocIds);
            } else
                gdocIds.add(s);
        }
              
         htmlBody = '<table border="1" id="my_table" cellpadding="2" cellspacing="0" width="100%" style="border-collapse:collapse;"> '
                        + '<tbody><th><a href="#" onclick="setSortIndex(0)">Account</a></th> <th>Meeting Subject</th> <th>Meeting Agenda</th> <th>Attachment(s)</th> '
                        + '<th><a href="#" onclick="setSortIndex(1)">Start Date/Time (EST)</a></th> <th><a href="#" onclick="setSortIndex(2)">End Date/Time (EST)</a></th> <th><a href="#" onclick="setSortIndex(3)">Created By</a></th> '
                        + '<th><a href="#" onclick="setSortIndex(4)">Region</a></th> <th><a href="#" onclick="setSortIndex(5)">Sub Region</a></th> <th><a href="#" onclick="setSortIndex(6)">Country</a></th><th>Public Calender</th>';
        
           //htmlBody += '';
         
           List<String> sortColumnArr = new List<String> { 'Account__r.Name', 'Meeting_Start_Date__c','Meeting_End_Date__c','createdby.name','account__r.region__c','account__r.sub_region__c','account__r.country__c'};
           String orderByColumn = sortColumnArr.get(sortColumn);
           
           String queryStr = 'select id, name, Objective__c, Meeting_Start_Date__c, Meeting_End_Date__c,PublicCalendar__c,account__r.Id, account__r.name, account__r.region__c, account__r.sub_region__c, account__r.country__c,createdby.name from customer_meeting__c where Meeting_Start_Date__c > LAST_YEAR and Meeting_End_Date__c < NEXT_YEAR AND PublicCalendar__c =:publiccalender ORDER BY  '+ orderByColumn + ' Limit 4000';
            List<customer_meeting__c> results = Database.query(queryStr);                
        for (customer_meeting__c c : results ) {
                            System.debug('temp'+c);
                       
            
            String sdate = c.Meeting_Start_Date__c.format('MM/dd/yyyy hh:mm a', 'America/New_York');
            String edate = c.Meeting_End_Date__c.format('MM/dd/yyyy hh:mm a', 'America/New_York');
        
            htmlBody += '<tr>';
            htmlBody += '<td><a target="_blank" href="https://mobility.my.salesforce.com/' + c.Account__r.Id  + '"><span>' + c.Account__r.Name + '</span></a></td>';
            htmlBody += '<td><a target="_blank" href="https://mobility.my.salesforce.com/' + c.Id + '"><span>' + c.Name + '</span></a></td>';
            if (c.Objective__c != null)
                htmlBody += '<td>' + c.Objective__c + '</td>';
            else
                htmlBody += '<td>&nbsp;</td>';
        
            List<String> l = gDocAttachmentMap.get(c.id);
            htmlBody += '<td>';
            if (l != null) {
                for (String s : l) {
                    htmlBody += s + '<br/>';
                }
            } else {
                htmlBody += '&nbsp;';
            }
            htmlBody += '</td>';
            htmlBody += '<td>' + sdate + '</td>';
            htmlBody += '<td>' + edate + '</td>';
        
        
            htmlBody += '<td>' + c.createdby.name + '</td>';
            htmlBody += '<td>' + c.account__r.region__c + '</td>';
            htmlBody += '<td>' + c.account__r.sub_region__c + '</td>';
            htmlBody += '<td>' + c.account__r.country__c + '</td>';
            htmlBody += '<td>' + c.PublicCalendar__c + '</td>';
            htmlBody += '</tr>';
        }
        htmlBody += '</tbody>';
        htmlBody += '</table>';
    }
     private void buildHtmlTable2()
    {
        String okrName = 'CES ' + year;
        
        Map<ID, customer_meeting__c> meetingMap =
            new Map<ID, customer_meeting__c>(
              [select id, name from customer_meeting__c limit5000
              ]);
        
        Map<ID, List<String>> gDocAttachmentMap = new Map<ID, List<String>>();
        
        for (Attachment a : [select id, name, parentid from Attachment where parentid in :meetingmap.keyset()]) {
        
            String s = '<a href="https://mobility.my.salesforce.com/servlet/servlet.FileDownload?file='
                    + a.id + '"><span>' + a.name + '</span></a>';
        
            List<String> attachments = gDocAttachmentMap.get(a.parentid);
            if (attachments == null) {
                attachments = new List<String>{s} ;
                gDocAttachmentMap.put(a.parentid, attachments);
            } else
                attachments.add(s);
        }
        
        for (GoogleDoc g : [select id, name, parentid, url from GoogleDoc where parentid in :meetingmap.keyset()]) {
        
            String s = '<a href="' + g.url + '"><span>' + g.name + '</span></a>';
            List<String> gdocIds = gDocAttachmentMap.get(g.parentid);
            if (gdocIds == null) {
                gdocIds = new List<String>{s} ;
                gDocAttachmentMap.put(g.parentid, gdocIds);
            } else
                gdocIds.add(s);
        }
              
         htmlBody = '<table border="1" id="my_table" cellpadding="2" cellspacing="0" width="100%" style="border-collapse:collapse;"> '
                        + '<tbody><th><a href="#" onclick="setSortIndex1(0)">Account</a></th> <th>Meeting Subject</th> <th>Meeting Agenda</th> <th>Attachment(s)</th> '
                        + '<th><a href="#" onclick="setSortIndex1(1)">Start Date/Time (EST)</a></th> <th><a href="#" onclick="setSortIndex1(2)">End Date/Time (EST)</a></th> <th><a href="#" onclick="setSortIndex1(3)">Created By</a></th> '
                        + '<th><a href="#" onclick="setSortIndex1(4)">Region</a></th> <th><a href="#" onclick="setSortIndex1(5)">Sub Region</a></th> <th><a href="#" onclick="setSortIndex1(6)">Country</a></th><th>Public Calender</th>';
        
           //htmlBody += '';
         
           List<String> sortColumnArr = new List<String> { 'Account__r.Name', 'Meeting_Start_Date__c','Meeting_End_Date__c','createdby.name','account__r.region__c','account__r.sub_region__c','account__r.country__c'};
           String orderByColumn = sortColumnArr.get(sortColumn1);
           
           String queryStr = 'select id, name, Objective__c, Meeting_Start_Date__c, Meeting_End_Date__c,PublicCalendar__c,account__r.Id, account__r.name, account__r.region__c, account__r.sub_region__c, account__r.country__c,createdby.name from customer_meeting__c where Meeting_Start_Date__c = LAST_YEAR and Meeting_End_Date__c < THIS_YEAR AND PublicCalendar__c =:publiccalender ORDER BY  '+ orderByColumn + ' Limit 4000';
            List<customer_meeting__c> results = Database.query(queryStr);                
        for (customer_meeting__c c : results ) {
                            System.debug('temp'+c);
                       
            
            String sdate = c.Meeting_Start_Date__c.format('MM/dd/yyyy hh:mm a', 'America/New_York');
            String edate = c.Meeting_End_Date__c.format('MM/dd/yyyy hh:mm a', 'America/New_York');
        
            htmlBody += '<tr>';
            htmlBody += '<td><a target="_blank" href="https://mobility.my.salesforce.com/' + c.Account__r.Id  + '"><span>' + c.Account__r.Name + '</span></a></td>';
            htmlBody += '<td><a target="_blank" href="https://mobility.my.salesforce.com/' + c.Id + '"><span>' + c.Name + '</span></a></td>';
            if (c.Objective__c != null)
                htmlBody += '<td>' + c.Objective__c + '</td>';
            else
                htmlBody += '<td>&nbsp;</td>';
        
            List<String> l = gDocAttachmentMap.get(c.id);
            htmlBody += '<td>';
            if (l != null) {
                for (String s : l) {
                    htmlBody += s + '<br/>';
                }
            } else {
                htmlBody += '&nbsp;';
            }
            htmlBody += '</td>';
            htmlBody += '<td>' + sdate + '</td>';
            htmlBody += '<td>' + edate + '</td>';
        
        
            htmlBody += '<td>' + c.createdby.name + '</td>';
            htmlBody += '<td>' + c.account__r.region__c + '</td>';
            htmlBody += '<td>' + c.account__r.sub_region__c + '</td>';
            htmlBody += '<td>' + c.account__r.country__c + '</td>';
            htmlBody += '<td>' + c.PublicCalendar__c + '</td>';
            htmlBody += '</tr>';
        }
        htmlBody += '</tbody>';
        htmlBody += '</table>';
    }
    public List<SelectOption> getCalender()
{
  List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('','-None-'));
   Schema.DescribeFieldResult fieldResult =
 customer_meeting__c.PublicCalendar__c.getDescribe();
   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
   for( Schema.PicklistEntry f : ple)
   {
      options.add(new SelectOption(f.getLabel(), f.getValue()));
   }       
   
   return options;
}

public String getPubliccalender() {
            return publiccalender;
        }
            
        public void setPubliccalender(String publiccalender) {
            this.publiccalender = publiccalender;
            System.debug('calci'+publiccalender);
        }
        
    public void sendEmail()
    {
        String userName = UserInfo.getUserName();
        User u = [Select Email From User where Username = :userName limit 1];
        String userEmail = u.email;
        String[] toAddresses = new String[] {userEmail};
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('CES ' + year + ' meeetings and their attachments - '
                + System.now().format('MM/dd/yyyy hh:mm a z', 'America/New_York'));
        mail.setToAddresses(toAddresses);
        mail.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
}