FROM hub.rat.dev/centos:8

WORKDIR /etc/yum.repos.d/
RUN mkdir backup && mv *repo backup/
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo
RUN sed -i -e"s|mirrors.cloud.aliyuncs.com|mirrors.aliyun.com|g " /etc/yum.repos.d/CentOS-* && \
    sed -i -e "s|releasever|releasever-stream|g" /etc/yum.repos.d/CentOS-* && \
    yum clean all && yum makecache

RUN yum install -y java-11-openjdk-devel
RUN yum install -y maven

RUN mkdir -p /etc/maven
RUN cat <<EOF > /etc/maven/settings.xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

  <proxies>
  </proxies>

  <servers>
  </servers>

  <mirrors>
    <mirror>
      <id>aliyunmaven</id>
      <mirrorOf>*</mirrorOf>
      <name>aliyun</name>
      <url>https://maven.aliyun.com/repository/public</url>
    </mirror>
  </mirrors>

  <profiles>
  </profiles>

</settings>
EOF

RUN yum install -y openssh-server openssh-clients
RUN ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key

RUN mkdir -p /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

ENV SSH_PASSWORD Lmop192!

RUN cat <<\EOF > /start.sh
#/bin/bash

echo "Setting ssh password"
echo "root:$SSH_PASSWORD" | chpasswd

# To avoid the warning message "System is booting up. Unprivileged users are not permitted to log in yet"
echo "Rmoving nologin file"
rm -f /run/nologin

echo "Starting SSH service"
/usr/sbin/sshd -D
EOF

RUN chmod +x /start.sh

WORKDIR /app

CMD ["/bin/sh", "-c", "/start.sh"]
