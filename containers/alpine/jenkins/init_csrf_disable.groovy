import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.model.Jenkins

def jenkins = Jenkins.instance;
jenkins.setCrumbIssuer(null); 
jenkins.save();
