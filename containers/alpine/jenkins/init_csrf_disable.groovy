import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.model.Jenkins

def jenkins = Jenkins.instance;
println "--> setting csrf disabled"
jenkins.setCrumbIssuer(null); 
jenkins.save();
println "--> setting csrf disabled... done"
