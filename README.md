# k8s-jenkins-slave-nodejs-xvfb-chrome
k8s-jenkins-slave-nodejs-xvfb-chrome


### Jenkins Slave Documentation

A Jenkins Slave Dockerized Container is started with the following parameters:

 * Docker CMD parameters:
   * `secret` and `nodeName`
     * We will use `JENKINS_NAME` Env var instead of `nodeName`
     * We will use `JENKINS_SECRET` Env var instead of `secret`
 * Docker ENV Vars:

```
JENKINS_LOCATION_URL: https://jenkins.foo.com/
JENKINS_SECRET:       050...42d
JENKINS_JNLP_URL:     http://jenkins.foo.com:8080/computer/k8s-jenkins-slave-
                      nodejs-xvfb-chrome-21ce6ca6fe87e/slave-agent.jnlp
JENKINS_NAME:         k8s-jenkins-slave-nodejs-xvfb-chrome-21ce6ca6fe87e
JENKINS_URL:          http://jenkins.foo.com:8080
HOME:                 /work
```

The `secret` and `nodeName` is the passed to the JNLP remoting JAR `slave.jar` to connect to the Jenkins Host via JNLP protocol.
The outline of the process is as follows:

 * container creation with `secret` and `nodeName`
 * inside docker-entrypoint:
   * Download of `${JENKINS_URL}/jnlpJars/slave.jar`.
   * Executing `java -jar slave.jar ${secret} ${nodeName}`.


-----
&nbsp;

### License

[MIT](https://github.com/cloutainer/k8s-jenkins-slave-nodejs-xvfb-chrome/blob/master/LICENSE) © [Bernhard Grünewaldt](https://github.com/clouless)
