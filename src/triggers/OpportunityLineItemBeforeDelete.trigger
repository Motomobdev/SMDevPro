trigger OpportunityLineItemBeforeDelete on OpportunityLineItem (before delete) {

String ProfileId = UserInfo.getProfileId();    

  List<Profile> profiles=[select id from Profile where Name ='MD - GTM Sales Operations' or Name ='System Administrator'];  

  if (2!=profiles.size())  

    {  

       

    } else{ 
  
for (OpportunityLineItem opp: Trigger.old){
       if ((ProfileId !=profiles[0].id) && (ProfileId !=profiles[1].id))
      {
        opp.addError('If you wish to delete, Please move Opportunity to Omitted category or contact Sales Ops.');
        System.debug('ProfileId'+ProfileId );
}
}
}
}