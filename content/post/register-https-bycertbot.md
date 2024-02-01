+++
title = "使用certbot申请免费https泛域名证书"
date = 2021-02-18T12:50:00+08:00
lastmod = 2024-02-01T16:31:27+08:00
tags = ["Nginx", "HTTPS", "泛域名"]
draft = false
+++

## 免费的https证书 {#免费的https证书}

部署https访问最简单的办法就是使用域名商提供的https服务，简单、省事、可靠、有保障。

但是，价格同样也不便宜啊，像我等穷人，当然要捡着物美价廉的吃了，如果能薅羊毛坚决不能放过。

letsencrypt.org是一个免费的证书颁发机构，提供单域名的证书，也提供泛域名的证书。

但是缺点也比较明显，就是有效期会比较短，只有三个月。当然了，每隔几个月搞一次就好了嘛，谁让咱穷呢


## 安装certbot {#安装certbot}

因为我使用的是 `freebsd`,所以我直接使用 `portmaster` 来安装。

```sh
sudo portmaster security/py-certbot
```

其它的操作系统同理，使用包管理器就可以安装，例如

```sh
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot
```

如果不知道怎么安装，可以详见官网 `https://certbot.eff.org/instructions`


## 申请证书 {#申请证书}

```sh
certbot certonly –manual -d grass.work -d "*.grass.work" --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory
```

其中 `-d` 后面的参数是要申请的域名，可以是单域名，也可以是泛域名，可以有多个

`--preferred-challenges dns-01` 表示使用验证方式为dns，当然也可以选择http方式——如果需要的话

`--server` 选择要使用的证书服务器

然后：

```text
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.
Are you OK with your IP being logged?【确认生成证书的机器的IP是域名解析到的IP地址】
```

输入 `yes`

```text
Please deploy a DNS TXT record under the name
_acme-challenge.grass.work with the following value:
# 注意：_acme-challenge.域名，是你需要去添加的解析记录 ，记录类型选择 TXT
sdklfasd8fzxckfj23sd9xlkvjx
#此处显示的是你需要添加到解析里的值
Before continuing, verify the record is deployed.
```

这时候，到域名控制台新增TXT的解析记录，如果有多个域名的话，需要配置多次，txt记录可以重复添加。

可以使用 `nslookup -q=TXT _acme-challenge.grass.work` 来验证TXT记录是否生效。

当生效之后，再继续。

```text
Congratulations! Your certificate and chain have been saved at:
/etc/letsencrypt/live/grass.work/fullchain.pem
Your key file has been saved at:
/etc/letsencrypt/live/grass.work/privkey.pem
Your cert will expire on 2020-12-19. To obtain a new or tweaked
version of this certificate in the future, simply run certbot-auto
again. To non-interactively renew *all* of your certificates, run
"certbot renew"
```

当看到上面的内容的时候，说明已经申请成功了，如果失败了，按照提示重新来过就好。

`/etc/letsencrypt/live/grass.work/fullchain.pem` 是证书的位置

`/etc/letsencrypt/live/grass.work/privkey.pem` 是私钥的位置

记下来待会要用


## 配置Nginx {#配置nginx}

在 `nginx.conf` （不同的系统会在不同的位置，具体查看相应的配置）中增加两行配置

```text
http {

# 配置证书的路径
ssl_certificate        /etc/letsencrypt/live/grass.work/fullchain.pem
# 配置私钥的路径
ssl_certificate_key    /etc/letsencrypt/live/grass.work/privkey.pem

# 其它的配置
}
```


## 使用crontab自动续期 {#使用crontab自动续期}

打开crontab配置

```sh
crontab -e
```

增加两行配置

```text
# 每月的 1号， 4点30 更新证书
30 4 1 * * /usr/local/bin/certbot renew -q
# 每月的 1号， 5点30 重新启动 nginx 服务器
30 5 1 * * /usr/local/sbin/nginx -s reload
```

到此结束。
