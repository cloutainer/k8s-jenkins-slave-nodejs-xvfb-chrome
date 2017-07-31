# k8s-jenkins-slave-nodejs-xvfb-chrome
k8s-jenkins-slave-nodejs-xvfb-chrome


### Jenkins Slave Documentation

A Jenkins Slave Dockerized Container is started with the following CMD parameters:

 * `secret` and `nodeName`

The `secret` and `nodeName` is the passed to the JNLP remoting JAR `slave.jar` to connect to the Jenkins Host via JNLP protocol.

The outline of the process is as follows:

 * container creation with `secret` and `nodeName`
 * inside docker-entrypoint:
   * Download of `${JENKINS_URL}/jnlpJars/slave.jar`
   * Executing `java -jar slave.jar ${secret} ${nodeName}`


-----
&nbsp;

### License

[MIT](https://github.com/cloutainer/k8s-jenkins-slave-nodejs-xvfb-chrome/blob/master/LICENSE) © [Bernhard Grünewaldt](https://github.com/clouless)
