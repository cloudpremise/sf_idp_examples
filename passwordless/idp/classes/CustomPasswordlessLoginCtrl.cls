public without sharing class CustomPasswordlessLoginCtrl {
    public String loginIdentifier {get;set;}
    public String verificationCode {get;set;}
    public String userEmail {get;set;}
    public String userId {get;set;}
    
    public CustomPasswordlessLoginCtrl(){
        System.debug('CustomPasswordlessLoginCtrl()');
    }
    
    public void challengePasswordlessEmailLogin(){
        System.debug('challengePasswordlessEmailLogin()');
        System.debug('this.userEmail:'+this.userEmail);
        User usr = [SELECT Id from User where Email = :this.userEmail];
        System.debug('usr:'+usr);
        
        this.userId = usr.Id;
        this.loginIdentifier = System.UserManagement.initPasswordlessLogin(userId, Auth.VerificationMethod.EMAIL);
    }
    public PageReference verifyEmailLogin() {
		System.debug('verifyEmailLogin()');
        String startUrl = Apexpages.currentPage().getParameters().get('startURL');
        system.debug('startUrl:'+startUrl);
        Auth.VerificationResult res = System.UserManagement.verifyPasswordlessLogin(this.userId, Auth.VerificationMethod.EMAIL, this.loginIdentifier, this.verificationCode, startUrl);
        System.debug('res:'+String.valueOf(res));
        if(res.success == true){
     		return res.redirect;
        }
        return null;
    }
}