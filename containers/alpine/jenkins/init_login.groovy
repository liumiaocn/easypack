import hudson.security.*
import jenkins.model.*

def instance = Jenkins.getInstance()

//def adminID = System.getenv("JENKINS_ADMIN_ID")
//def adminPW = System.getenv("JENKINS_ADMIN_PW")
adminID="admin"
adminPW="admin"

println "--> Checking security status"

if (!instance.isUseSecurity()) {
    println "--> Setting user security info"

    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    hudsonRealm.createAccount(adminID, adminPW)
    instance.setSecurityRealm(hudsonRealm)

    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    instance.setAuthorizationStrategy(strategy)
    instance.save()
}
