<img src="https://cloutainer.github.io/documentation/images/cloutainer.svg?v5" align="right">

# k8s-jenkins-slave-nodejs-xvfb-chrome

[![](https://codeclou.github.io/doc/badges/generated/docker-image-size-403.svg)](https://hub.docker.com/r/cloutainer/k8s-jenkins-slave-nodejs-xvfb-chrome/tags/) [![](https://codeclou.github.io/doc/badges/generated/docker-from-ubuntu-16.04.svg)](https://www.ubuntu.com/) [![](https://codeclou.github.io/doc/badges/generated/docker-run-as-non-root.svg)](https://docs.docker.com/engine/reference/builder/#/user)

Kubernetes Docker image providing Jenkins Slave JNLP with Node.JS, xvfb and Google Chrome.


-----
&nbsp;

### Preinstalled Tools

| tool | version |
|------|---------|
| yarn | 0.27.5 |
| node.js | 8.1.3 |
| npm | 5.0.3 |
| google-chrome-stable | 59 |
| cloudfoundry cli | apt-get |
| Xvfb | apt-get |
| git | apt-get |
| curl, wget | apt-get |
| zip, bzip2 | apt-get |
| jq | apt-get |

-----
&nbsp;

### Usage

Use with [Kubernetes Jenkins Plugin](https://github.com/jenkinsci/kubernetes-plugin) like so:

```groovy
podTemplate(
  name: 'nodejs-xvfb-chrome-v17',
  label: 'k8s-jenkins-slave-nodejs-xvfb-chrome-v17',
  cloud: 'mycloud',
  nodeSelector: 'failure-domain.beta.kubernetes.io/zone=eu-west-1a',
  containers: [
    containerTemplate(
      name: 'jnlp',
      image: 'cloutainer/k8s-jenkins-slave-nodejs-xvfb-chrome:v17',
      privileged: false,
      command: '/opt/docker-entrypoint.sh',
      args: '',
      alwaysPullImage: false,
      workingDir: '/home/jenkins',
      resourceRequestCpu: '500m',
      resourceLimitCpu: '1',
      resourceRequestMemory: '3000Mi',
      resourceLimitMemory: '3000Mi'
    )
  ]
) {
  node('k8s-jenkins-slave-nodejs-xvfb-chrome-v17') {
    stage('build and test') {
      sh 'yarn -version'
      sh 'git clone https://github.com/clouless/angular-4-unit-test-dummy.git code'
      dir('code') {
        sh 'yarn && yarn test'
      }
    }
  }
}
```


-----
&nbsp;

### License

[MIT](https://github.com/cloutainer/k8s-jenkins-slave-nodejs-xvfb-chrome/blob/master/LICENSE) © [Bernhard Grünewaldt](https://github.com/clouless)
