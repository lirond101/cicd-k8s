# cicd-k8s-project

## What Is This Project?
This project is aim to build thr infrasructure behing the ci-cd process of my-pub-ip web-app. (https://github.com/lirond101/my-pub-ip).
This process is executed by Jenkins running on a container inside a EKS cluster.
The project is mainly automatic from establishment the vpc and eks with Terraform and bash scrpits, with few manual steps on Jenkins UI.

## How to run?
### Your variables
Please change variables here:
 Terraform: variables.tf and tfvars.tf.

### Setup project
```shell script
$ chmod +x init.sh
$ ./init.sh
```
### Provision
#### Dockerize Jenkins
```shell script
$ docker build -t <repo-dockerhub>/<container-name>:<tag> . --no-cache
```

#### Configure Jenkins
   1. Go to http://<your-domain>/jenkins.
   2. Add admin username and password.
   3. Configure k8s cloud - (k8s plugin for jenkins is already installed see here for installed plugins - https://github.com/lirond101/kandula-project/blob/vpc/infrastructure/jenkins/controller/jenkins-plugins.txt)

      3.1. Jenkins URL: http://<your-domain>/jenkins

      3.2. Jenkins tunnel: jenkins-svc.jenkins.svc.cluster.local:50000

      3.3. Credentials of secret text - K8s jenkins service account -use the output JWT from ./provision-k8s.sh execution.
   4. Store credentials for Jenkins pipeline:

      4.1. Dockerhub - add key 'dockerhub.id' of type username / password.

      4.2. Github - add key 'github' of type SSH Username with private key - generate a key pair and store its private part. the public part will be stored on your Github account:
           Settings -> "SSH and GPG keys" -> Click "New SSH key".

      4.3. Slack - add key 'slack' of secret text type - read more details here
      https://plugins.jenkins.io/slack/#plugin-content-creating-your-app     

      4.4. Go to global credentials and update the github known keys - I prefer to choose "provide it manually" and put there the response of:
         ```shell script
            $ ssh-keyscan github.com
         ```

### SSH
```shell script
$ eval "$(ssh-agent)"
$ echo $SSH_AUTH_SOCK
$ chmod 400 your_aws_ec2_key.pem
$ ssh-add -k ~/.ssh/your_aws_ec2_key.pem
$ ssh -A <user>@<bastion-ip>
$ ssh <user>@<private-instance-ip>
```

### Go to http://your-domain>/ and explore your public ip.

### Destroy project
```shell script
$ chmod +x destroy.sh
$ ./destroy.sh
```
