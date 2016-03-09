public class APTPS_RedirectUserClass{
    
    private Apttus__APTS_Agreement__c agr;
    
    public APTPS_RedirectUserClass(Apexpages.StandardController stdcon){
        agr = (Apttus__APTS_Agreement__c)stdcon.getRecord();
        agr = [SELECT Id, Redirect_User__c FROM Apttus__APTS_Agreement__c WHERE Id =: agr.Id];
    }

    public PageReference RedirectUser(){
        if(agr.Redirect_User__c != null && agr.Redirect_User__c.contains(UserInfo.getUserId())){
            PageReference pageref = Page.APTPS_CA_CreateContract;
            pageref.getParameters().put('id', agr.Id);           
            pageref.setredirect(true);
            return pageref;
           // return new PageReference('/apex/APTPS_CA_CreateContract?Id=' + agr.Id);
        }else{
            return new PageReference('/' + agr.Id + '?nooverride=1');
        }
    }
}