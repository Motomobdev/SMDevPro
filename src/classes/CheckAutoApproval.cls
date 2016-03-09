global class CheckAutoApproval implements Schedulable {

    // Class to assembly the jwt
    public class JWTClaimSet
    {
       public string iss {get;set;}
       public string scope {get;set;}
       public string aud {get;set;}
       public Long exp {get;set;}
       public Long iat {get;set;}
    }

    // Class to deserialize the token response
    public class TokenResponse
    {
       public string access_token {get;set;}
       public string token_type {get;set;}
       public string expires_in {get;set;}
    }
    
    // Class to deserialize the build status
    public class BuildStatus
    {
       public string kind {get;set;}
       public string approvalStatus {get;set;}
    }
    
    global static void ScheduleMe()
    {
        String nextFireTime = '0 0 * * * ?'; 
        System.schedule('Check Auto Approval', nextFireTime, new CheckAutoApproval());    
    }
    
    private static void SendEmail(List<Device__c> dev, String buildFingerprint)
    {
        /*for (Device__c d : dev) {
            String[] toAddresses = new String[] {'espinola@motorola.com'};
            Messaging.reserveSingleEmailCapacity(1); // Check if there will be more people in the list.

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Check Auto Approval');
            mail.setSubject('Final Approval [' + d.Name + ']');
            mail.setHtmlBody('<p>Hi Everyone,</p>' +
                             '<p>Congratulations on the approval! - please confirm the Build Fingerprint below is the one that will ship.</p>' +
                             '<p>Device Name: ' + d.Name + '</p>' +
                             '<p>FINGERPRINT: ' + buildFingerprint + '</p>' +
                             '<p>Thanks,<br>Google Alliance Team</p>');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }*/
    }
    
    private static void Reschedule()
    {
        //ScheduleMe();
    }
    
    WebService static String CheckNow(String buildFingerprint)
    {
        System.debug('Checking fingerprint:' + buildFingerprint);
        String res = checkAutoApproval(buildFingerprint);
        
        return res;
    }
    
    global static void PublicTestMethod(String buildFingerprint)
    {
        doStuff(buildFingerprint);
    }

    global void execute(SchedulableContext SC)
    {
        try {
            doStuff('');
        } catch (Exception ex) {
            System.debug('CheckAutoApproval ' + ex.getMessage());
        } finally {
//	        System.abortJob(SC.getTriggerId());
        }
    }

    @future(callout=true)
    private static void doStuff(String fingerprint)
    {
        checkAutoApproval(fingerprint);
    }

    private static String checkAutoApproval(String fingerprint)
    {
        String res = '';

        try {
            TokenResponse tr = LoginToGoogle();
            
            List<String> inProgress = new List<String>();
            
            if (String.isBlank(fingerprint)) {
                inProgress = GetInProgressBuilds();
            } else {
                inProgress.add(fingerprint);
            }
            
            for (String buildFingerprint : inProgress) {
                BuildStatus bs = GetBuildStatus(buildFingerprint, tr.access_token);
                
                if (bs != null && bs.approvalStatus != null) {
                    res = bs.approvalStatus;

                    if (res.Equals('APPROVED')) {
                        List<Device__c> updatedDev = UpdateDeviceFields(buildFingerprint);
                        SendEmail(updatedDev, buildFingerprint);
                    }
                } else {
                    res = 'Unable to query fingerprint ['+ buildFingerprint +'] status';
                    System.debug(res);
                }
            }
        } catch (Exception ex) {
            res = 'CheckAutoApproval: ' + ex.getMessage();
            System.debug(res);
        } finally {
            if (String.isBlank(fingerprint)) {
            	Reschedule();
            }
        }

        return res;
    }

    private static TokenResponse LoginToGoogle()
    {
        //Set your username and password here        
        String clientId = '25525294422-k86ii13cfp1bu179o89f35r62fk5i1ks.apps.googleusercontent.com';
    
        //Construct HTTP request and response
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        String JWTHeader =  '{"typ":"JWT","alg":"RS256"}';
        String Base64EncodedJWTHeader = EncodingUtil.base64Encode(Blob.valueOf(JWTHeader)); //'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9';
        Long expires_at = math.roundToLong(DateTime.now().addMinutes(40).getTime() / 1000);
        Long issued_at = math.roundToLong(DateTime.now().addSeconds(-2).getTime() / 1000);
    
        JWTClaimSet JWT = new JWTClaimSet();
        JWT.iss = '501576318676-viea9qka844arsqntq021f0b6a1kicjd@developer.gserviceaccount.com';
        JWT.scope = 'https://www.googleapis.com/auth/androidPartner';
        JWT.aud = 'https://accounts.google.com/o/oauth2/token';
        JWT.iat = issued_at;
        JWT.exp = expires_at;

        String strJWTJSON = JSON.Serialize(JWT);
        Blob ClaimsetBlob = Blob.valueOf(strJWTJSON);
        String Base64EncodedClaimset = EncodingUtil.base64Encode(ClaimsetBlob);

        // constructing the base64 encoded string to sign it
        string Base64EncodedString = Base64EncodedJWTHeader + '.' + Base64EncodedClaimset;

        // Steps to sign the base64Encoded string
        String algorithmName = 'RSA-SHA256';
        String key = 'MIICXQIBAAKBgQCn8ifx50JenYwk9Zw6Etm/ayKiQIqATV0HC6F3XtVBrj0CbsoCsOSbd/c3XYEq5dyRRbPjorvTEYtMMazdvxRJDLRP3qS7e+mxXyy+eqAWx9CZnrK+SM2GhT0IP3tPbrnY8PwT1222V+Adsx5MQoPDKTe7HFy+cALuoifetkf8eQIDAQABAoGARC709qnr8RvHXO32OkGS87rcOcE4ObSu8wBO0nbG376MeGNgUk1c0p2W2Xx1x2PA85231dAorx1tT0bPpss/wWwwgCYLclggY1xtH3X7VuQehJWqudIIX9dBRKYo98CgzpHeBfGRbciXLBkwiHkKCnTQ3AgsKMMTeka2HlWD24ECQQDP6PwF/p/2IK+CJMFyyPusJNAANdPPj7luLAERPHrFxuYVUle7rjgf96blypznUiEXbnJgHvzhmKt4dRfHXW1RAkEAzsrEJzPxwAHz0ViUVAGWDqO6QuhCNHvtte0wU+ra10L8/h8jdQg/ZjUQZYsDE8coD20LQ1hK+nPypesIofEyqQJBAMnBcJesoLPqwgYL/wGRkdBaJNKfaXzZHvuPjjWYuBcmzW3RazvAc8xpubbyaFJ9u4kOb8VhLMsLKRKKplmcCxECQQC8m5e4odn25FD7Oa1fyWqRw6dY6vmnYPj4m3MetvAOsdyJ8uCmF3WrxO5FjzqpSVYya6SAMgGA2UwRJINlINaxAkADOgVC4eocpo5ZVlkwVIsZ7rA0+c6rkfYJLDH++OzlY3IDq41hYFE2ZMJHvRMxyOMdsFNhpJd2INpgIo5uJUEl';
        Blob privateKey = EncodingUtil.base64Decode(key);
    
        Blob input = Blob.valueOf(Base64EncodedString);
        Blob Blobsign = Crypto.sign(algorithmName, input , privateKey);

        String base64EncodedSignature = EncodingUtil.base64Encode(Blobsign); 
        string URLEncodedUTF8GrantType = encodingUtil.urlEncode('urn:ietf:params:oauth:grant-type:jwt-bearer','UTF-8');
        string URLEncodedUTF8Assertion = encodingUtil.urlEncode(Base64EncodedString+'.'+base64EncodedSignature,'UTF-8');        
    
        //Making the call out
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody('grant_type='+URLEncodedUTF8GrantType+'&assertion='+URLEncodedUTF8Assertion);
        HttpResponse res = http.send(req);
        system.debug('Response : '+res.getBody());
        
        // Getting the status
        TokenResponse tr = (TokenResponse)JSON.deserialize(res.getBody(), TokenResponse.class);
        
        return tr;
    }
    
    private static List<String> GetInProgressBuilds()
    {
        String statusToCheck = 'In Progress';
		List<AggregateResult> devs = [SELECT GMS_Last_SW_Submitted__c FROM Device__c WHERE Google_TA_Approval_Status__c = :statusToCheck GROUP BY GMS_Last_SW_Submitted__c];
        
        List<String> bfp = new List<String>();
        
        for (AggregateResult d : devs) {
            bfp.add((String)d.get('GMS_Last_SW_Submitted__c'));
        }

        return bfp;
    }
    
    private static BuildStatus GetBuildStatus(String buildFingerprint, String access_token)
    {
        Http http = new Http();
        HttpRequest reqStatus = new HttpRequest();
        String params = '?buildFingerprint=' + encodingUtil.urlEncode(buildFingerprint,'UTF-8');

        reqStatus.setEndpoint('https://www.googleapis.com/androidpartner/v1/devices/build_status'+params);
        reqStatus.setMethod('GET');
        reqStatus.setHeader('Authorization','Bearer ' + access_token);
        HttpResponse res = http.send(reqStatus);
        system.debug('Response : '+res.getBody());
        
        BuildStatus bs = (BuildStatus)JSON.deserialize(res.getBody(), BuildStatus.class);
        
        return bs;
    }
    
    private static List<Device__c> UpdateDeviceFields(String buildFingerprint)
    {
        String statusComplete = 'Completed';
        List<Device__c> dev = [SELECT Name, Approval_Type__c, Date_of_Google_TA_Approval_by_Google__c, Google_TA_Approval_Status__c, White_Listed_Build_Fingerprint__c FROM Device__c WHERE Google_TA_Approval_Status__c != :statusComplete AND GMS_Last_SW_Submitted__c = :buildFingerprint FOR UPDATE];
		List<Device__c> updatedDev = new List<Device__c>();
        
        System.debug('Updating fields...');
        
        for (Device__c d : dev) {
            System.debug('Device: ' + d.Name);

            d.Date_of_Google_TA_Approval_by_Google__c = Date.today();
            d.Google_TA_Approval_Status__c = 'Completed';
            d.White_Listed_Build_Fingerprint__c = buildFingerprint;
            
            updatedDev.add(d);
        }
        
        Database.update(updatedDev);
        
        return updatedDev;
    }
}