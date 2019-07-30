import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.model.Jenkins

def jenkins = Jenkins.instance;
jenkins.setCrumbIssuer(new DefaultCrumbIssuer(true)); 
jenkins.save();
