
#! /bin/bash 

  echo 1 > /proc/sys/net/ipv4/ip_forward
  sed -i "$a\ec2-user          ALL=(ALL)       NOPASSWD: ALL" /etc/sudoers
  sed -i "$a\172.16.0.20 master1,172.16.0.21 master2,172.16.0.30 worker1,172.16.0.31 worker2,172.16.0.32 worker3" /etc/hosts 
  sed -i "s/,/\n/g" /etc/hosts
  su ec2-user
  cd ~
  ssh-keygen -t rsa -b 4096 -N "" -f /home/ec2-user/test 
  export AWS_ACCESS_KEY_ID=AKIAZJWU426JS5O42H6F
  export AWS_SECRET_ACCESS_KEY=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
  aws s3 cp s3://terraform-test-com/test4.pem /home/ec2-user
  sudo chmod 400 /home/ec2-user/test4.pem
  cat test.pub | ssh -i "test4.pem" -o StrictHostKeyChecking=no ec2-user@172.16.0.20 ->> ~/.ssh/authorized_keys
  cat test.pub | ssh -i "test4.pem" -o StrictHostKeyChecking=no ec2-user@172.16.0.21 ->> ~/.ssh/authorized_keys
  cat test.pub | ssh -i "test4.pem" -o StrictHostKeyChecking=no ec2-user@172.16.0.30 ->> ~/.ssh/authorized_keys
  cat test.pub | ssh -i "test4.pem" -o StrictHostKeyChecking=no ec2-user@172.16.0.31 ->> ~/.ssh/authorized_keys
  cat test.pub | ssh -i "test4.pem" -o StrictHostKeyChecking=no ec2-user@172.16.0.32 ->> ~/.ssh/authorized_keys
  sudo curl -o /usr/local/bin/kubectl  \
   https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
  sudo chmod +x /usr/local/bin/kubectl
  export PATH=/usr/local/bin:$PATH
  sudo mkdir -p $HOME/.kube
  sudo chown ec2-user:ec2-user $HOME/.kube
  ssh -i /home/ec2-user/test4.pem ec2-user@172.16.0.20 << EOF
  sudo -i
  sed -i "$a\ec2-user          ALL=(ALL)       NOPASSWD: ALL" /etc/sudoers
  echo 1 > /proc/sys/net/ipv4/ip_forward
  sed -i "s/^SELINUX=.*/SELINUX=disabled/g" /etc/sysconfig/selinux 
	setenforce 0
	swapoff -a
  sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config 
  su ec2-user
  cd ~
  sudo curl -o /usr/local/bin/kubectl  \
   https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
  sudo chmod +x /usr/local/bin/kubectl
  export PATH=/usr/local/bin:$PATH
  sudo mkdir -p $HOME/.kube
  sudo chown ec2-user:ec2-user $HOME/.kube
 exit
EOF
  ssh -i /home/ec2-user/test4.pem ec2-user@172.16.0.21 << EOF
  sudo -i
  sed -i "$a\ec2-user          ALL=(ALL)       NOPASSWD: ALL" /etc/sudoers
  echo 1 > /proc/sys/net/ipv4/ip_forward
  sed -i "s/^SELINUX=.*/SELINUX=disabled/g" /etc/sysconfig/selinux 
	setenforce 0
	swapoff -a
  sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config 
  su ec2-user
  cd ~
  sudo curl -o /usr/local/bin/kubectl  \
   https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
  sudo chmod +x /usr/local/bin/kubectl
  export PATH=/usr/local/bin:$PATH
  sudo mkdir -p $HOME/.kube
  sudo chown ec2-user:ec2-user $HOME/.kube
EOF
  ssh -i /home/ec2-user/test4.pem ec2-user@172.16.0.30 << EOF
  sudo -i
  sed -i "$a\ec2-user          ALL=(ALL)       NOPASSWD: ALL" /etc/sudoers
  echo 1 > /proc/sys/net/ipv4/ip_forward
  sed -i "s/^SELINUX=.*/SELINUX=disabled/g" /etc/sysconfig/selinux 
	setenforce 0
	swapoff -a
  sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config 
  su ec2-user
  cd ~
  sudo curl -o /usr/local/bin/kubectl  \
   https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
  sudo chmod +x /usr/local/bin/kubectl
  export PATH=/usr/local/bin:$PATH
  sudo mkdir -p $HOME/.kube
  sudo chown ec2-user:ec2-user $HOME/.kube
exit
EOF
  ssh -i /home/ec2-user/test4.pem ec2-user@172.16.0.31 << EOF
  sudo -i
  sed -i "$a\ec2-user          ALL=(ALL)       NOPASSWD: ALL" /etc/sudoers
  echo 1 > /proc/sys/net/ipv4/ip_forward
  sed -i "s/^SELINUX=.*/SELINUX=disabled/g" /etc/sysconfig/selinux 
	setenforce 0
	swapoff -a
  sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config 
  su ec2-user
  cd ~
  sudo curl -o /usr/local/bin/kubectl  \
   https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
  sudo chmod +x /usr/local/bin/kubectl
  export PATH=/usr/local/bin:$PATH
  sudo mkdir -p $HOME/.kube
  sudo chown ec2-user:ec2-user $HOME/.kube
exit
EOF
  ssh -i /home/ec2-user/test4.pem ec2-user@172.16.0.32 << EOF
  sudo -i
  sed -i "$a\ec2-user          ALL=(ALL)       NOPASSWD: ALL" /etc/sudoers
  echo 1 > /proc/sys/net/ipv4/ip_forward
  sed -i "s/^SELINUX=.*/SELINUX=disabled/g" /etc/sysconfig/selinux 
	setenforce 0
	swapoff -a
  sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config 
  su ec2-user
  cd ~
  sudo curl -o /usr/local/bin/kubectl  \
   https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
  sudo chmod +x /usr/local/bin/kubectl
  export PATH=/usr/local/bin:$PATH
  sudo mkdir -p $HOME/.kube
  sudo chown ec2-user:ec2-user $HOME/.kube
exit
EOF
sudo yum repolist
sudo sed -i "s/^SELINUX=.*/SELINUX=disabled/g" /etc/sysconfig/selinux 
sudo setenforce 0
sudo swapoff -a
 sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config  
 sudo systemctl restart sshd
sudo amazon-linux-extras install epel -y
sudo yum -y update
sudo yum -y install git curl
 export GIT_SSL_NO_VERIFY=0
sudo git clone https://github.com/kubernetes-sigs/kubespray.git
sudo pip3 install -r ~/kubespray/requirements.txt
  sudo cp -rfp ~/kubespray/inventory/sample ~/kubespray/inventory/gitopscluster
  declare -a IPS=(master1,172.16.0.20 master2,172.16.0.21 worker1,172.16.0.30 worker2,172.16.0.31 worker3,172.16.0.32)
  sudo CONFIG_FILE=~/kubespray/inventory/gitopscluster/hosts.yaml python3 ~/kubespray/contrib/inventory_builder/inventory.py ${IPS[@]}
  export PATH=/usr/local/bin:$PATH
  sudo chmod 777 ~/kubespray/inventory/gitopscluster
  ansible-playbook -i ~/kubespray/inventory/gitopscluster/hosts.yaml  --private-key /home/ec2-user/test4.pem --become --become-user=root ~/kubespray/cluster.yml
  scp -i /home/ec2-user/test4.pem /home/ec2-user/test4.pem ec2-user@172.16.0.20:/home/ec2-user
  ssh -i /home/ec2-user/test4.pem ec2-user@172.16.0.20 << EOF
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  sudo chown ec2-user:ec2-user .kube
  scp -i /home/ec2-user/test4.pem -o StrictHostKeyChecking=no $HOME/.kube/config  ec2-user@172.16.0.10:/home/ec2-user/.kube/config
  scp -i /home/ec2-user/test4.pem -o StrictHostKeyChecking=no $HOME/.kube/config  ec2-user@172.16.0.21:/home/ec2-user/.kube/config
  scp -i /home/ec2-user/test4.pem  -o StrictHostKeyChecking=no $HOME/.kube/config ec2-user@172.16.0.30:/home/ec2-user/.kube/config
  scp -i /home/ec2-user/test4.pem -o StrictHostKeyChecking=no $HOME/.kube/config  ec2-user@172.16.0.31:/home/ec2-user/.kube/config
  scp -i /home/ec2-user/test4.pem -o StrictHostKeyChecking=no $HOME/.kube/config  ec2-user@172.16.0.32:/home/ec2-user/.kube/config
exit
EOF
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo service docker enable
sudo usermod -a -G docker ec2-user
sudo -i 
 cat <<EOF >> /etc/docker/daemon.json
{
 "hosts":["unix:///var/run/docker.sock", "tcp://0.0.0.0:2376"],
 "tls":false,
 "insecure-registries":["10.0.2.4:5000"]
}
EOF
sudo chown ec2-user:ec2-user /etc/docker/daemon.json
ssh -i /home/ec2-user/test4.pem -o StrictHostKeyChecking=no ec2-user@172.16.0.20 << EOF
sudo -i
chown ec2-user:ec2-user /etc/docker
exit
EOF
ssh -i /home/ec2-user/test4.pem -o StrictHostKeyChecking=no ec2-user@172.16.0.21 << EOF
sudo -i
chown ec2-user:ec2-user /etc/docker
exit
EOF
ssh -i /home/ec2-user/test4.pem -o StrictHostKeyChecking=no ec2-user@172.16.0.30 << EOF
sudo -i
chown ec2-user:ec2-user /etc/docker
exit
EOF
ssh -i /home/ec2-user/test4.pem -o StrictHostKeyChecking=no ec2-user@172.16.0.31 << EOF
sudo -i
chown ec2-user:ec2-user /etc/docker
exit
EOF
ssh -i /home/ec2-user/test4.pem -o StrictHostKeyChecking=no ec2-user@172.16.0.32 << EOF
sudo -i
chown ec2-user:ec2-user /etc/docker
exit
EOF
scp -i /home/ec2-user/test4.pem /etc/docker/daemon.json ec2-user@172.16.0.20:/etc/docker/daemon.json
scp -i /home/ec2-user/test4.pem /etc/docker/daemon.json ec2-user@172.16.0.21:/etc/docker/daemon.json
scp -i /home/ec2-user/test4.pem /etc/docker/daemon.json ec2-user@172.16.0.30:/etc/docker/daemon.json
scp -i /home/ec2-user/test4.pem /etc/docker/daemon.json ec2-user@172.16.0.31:/etc/docker/daemon.json
scp -i /home/ec2-user/test4.pem /etc/docker/daemon.json ec2-user@172.16.0.32:/etc/docker/daemon.json

