# javadev
用 docker 搭建 java 开发环境，使用 CentOS8，包括：

- yum 源配置为阿里云 http://mirrors.aliyun.com/repo/Centos-8.repo
- mvn 镜像源设置为阿里云 https://maven.aliyun.com/repository/public
- openjdk 11
- ssh

# 使用方法
构建：

```shell
docker build -t jdk11-dev .
```

启动（将当前目录挂载到容器内的 `/app` 目录）：

```shell
docker run -d -v "$(pwd):/app" -p 2222:22 jdk11-dev
```

启动后，可以通过 vscode/idea 远程开发，使用 ssh 连接容器即可

```shell
ssh root@<host> -p 2222
```

默认密码为 `Lmop192!`

# TODO

- [ ] 使用环境变量设置 ssh 密码
- [ ] 启动后增加 ssh 连接提示
