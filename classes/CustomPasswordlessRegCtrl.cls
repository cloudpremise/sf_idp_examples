public without sharing class CustomPasswordlessRegCtrl {

    public String verificationCode {get;set;}  
    public String registrationIdentifier {get;set;}
    public String userEmail {get;set;}
    
    public CustomPasswordlessRegCtrl(){
        System.debug('CustomPasswordlessRegCtrl()');
    }

    public void registerUserEmail() {
        System.debug('registerUserEmail()');      
        
        
        Account acct = [SELECT Id from Account WHERE Name = 'Portal Users' Limit 1];
        Contact cont = new Contact();
        cont.AccountId = acct.Id;
        cont.LastName = 'Unverified Passwordless User';
        cont.Email = userEmail;
        insert cont;
        
        
        Profile prof = [SELECT Id from Profile where Name = 'High Volume Customer Portal User' LIMIT 1];

        User u = new user();
        u.LastName = 'Test 1';
        u.Email = this.userEmail;
        u.Alias = 'Tcode';
        u.Username = this.userEmail; //NOTE - this will need to be unique each sign up
        u.CommunityNickname = 'test1'; //NOTE - this will need to be unique each sign up
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = prof.Id; //hvcpu
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.ContactId = cont.Id;
        System.debug('u:'+u);
        //insert u;
 
        this.registrationIdentifier = System.UserManagement.initSelfRegistration(Auth.VerificationMethod.Email, u);
        System.debug('this.registrationIdentifier:'+this.registrationIdentifier);

    }
    public PageReference verifyEmailRegistration() {
		System.debug('verifyEmailRegistration()');
        String startUrl = '';
        Auth.VerificationResult res = System.UserManagement.verifySelfRegistration(Auth.VerificationMethod.EMAIL, this.registrationIdentifier, this.verificationCode, startUrl);
        System.debug('res:'+String.valueOf(res));
        if(res.success == true){
     		return res.redirect;
        }
        return null;
    }
}