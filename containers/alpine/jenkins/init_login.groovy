import hudson.security.*
import jenkins.model.*

def instance = Jenkins.getInstance()

def adminID = System.getenv("JENKINS_ADMIN_ID")
def adminPW = System.getenv("JENKINS_ADMIN_PW")

println "--> Checking user information"

// if (!instance.isUseSecurity()) {
    println "--> Creating jenkins user"

    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    hudsonRealm.createAccount(adminID, adminPW)
    instance.setSecurityRealm(hudsonRealm)

    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    instance.setAuthorizationStrategy(strategy)
    instance.save()
// }
