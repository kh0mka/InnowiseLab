**1. Создать сервер t2.micro, он должен иметь публичный ip и доступ в интернет. Разрешить http трафик в security group, ассоциированной с данным сервером.**

Создать легко, публичный айпи дается по дефолту. В Security Group указал для SSH anywhere, потому что в компании может быть DHCP. когда время аренды закочнится, потом хер зайдешь. К тому же, если требуется можно поменять порт SSH, а плюс еще доступ онли по ключу.

**2. Установить Nginx, напиши конфигурационный файл, который будет раздавать html-страницу blue.html. Проверить работоспособность(выдает ли он нужную страницу).**

```bash
sudo apt update -y && sudo apt upgrade -y && sudo apt install nginx
systemctl status nginx
pwd
mkdir Git && cd Git
git clone https://devops-gitlab.inno.ws/devops-board/nginx-html
mkdir /var/www/blue
cp nginx-html/blue.html /var/www/blue/
cp /etc/nginx/sites-available/default blue.conf
cd /etc/nginx/sites-available/
nano blue.conf
```

Конфигурация blue.conf
```
server {
    listen 80;
    server_name _;

    root /var/www/blue;
    index blue.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

```bash
cd /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/blue.conf blue.conf
rm /etc/nginx/sites-enabled/default
systemctl restart nginx
```

**3. Создать еще два сервера t2.micro, на одном настроить раздачу страницы yellow.html, на втором настроить балансировщик между yellow и blue. Балансировщик должен направлять запрос на сервер с меньшим количеством подключений. По итогу должно получиться так, что при каждом новом подключении цвет заднего фона должен меняться.** /
+
**4. Добавить в конфигурацию вывод логов, который будет показывать, куда проксируется запрос клиента.** \

```bash
sudo apt update -y && sudo apt upgrade -y && sudo apt install nginx
systemctl status nginx
mkdir Git && cd Git
git clone https://devops-gitlab.inno.ws/devops-board/nginx-html
mkdir /var/www/yellow && cp nginx-html/yellow.html /var/www/yellow/
cp /etc/nginx/sites-available/default yellow.conf
cd /etc/nginx/sites-available/
nano yellow.conf
```

Конфигурация yellow.conf:
```
server {
    listen 80;
    server_name _;

    root /var/www/yellow;
    index yellow.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

```bash
cd /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/yellow.conf yellow.conf
rm /etc/nginx/sites-enabled/default
systemctl restart nginx
```

### Balancer

```bash
sudo apt update -y && sudo apt upgrade -y && sudo apt install nginx
cp /etc/nginx/sites-available/default balancer.conf
nano /etc/nginx/sites-available/balancer.conf
```

Конфигурация balancer.conf:
```
upstream backend {
    server 13.51.146.133; # Yellow Site
    server 13.51.85.168; # Blue Site
    server 16.171.28.252 backup;
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://backend;
	    proxy_connect_timeout 500ms;
        access_log /var/log/nginx/balancer.log balancer_log;
    }
}
```

```bash
cd /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/balancer.conf balancer.conf
rm /etc/nginx/sites-enabled/default
systemctl restart nginx
nano /etc/nginx/nginx.conf
```

Помимо этого, чтобы работали логи отредактировал блок http в главном файле конфигурации, добавив кастомное логирование:

```
log_format balancer_log '$remote_addr - $remote_user [$time_local] '
                                '"$request" $status $body_bytes_sent '
                                '"$http_referer" "$http_user_agent" '
                                '[ProxyTo]: $upstream_addr/$proxy_host';
```

Как итог, что мы видим при `cat /var/log/nginx/balancer.log`:

```bash
[ProxyTo]: 13.53.134.109:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:13 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.51.196.143:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:13 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.53.134.109:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:14 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.51.196.143:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:14 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.53.134.109:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:14 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.51.196.143:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:14 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.53.134.109:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:14 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.51.196.143:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:14 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.53.134.109:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:14 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.51.196.143:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:15 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.53.134.109:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:15 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.51.196.143:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:15 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.53.134.109:80/backend
82.135.241.208 - - [07/Aug/2023:12:41:15 +0000] "GET / HTTP/1.1" 200 574 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36" [ProxyTo]: 13.51.196.143:80/backend
```

**5. Создать еще один сервер с сайтом и добавить его в конфигурацию как backup сервер.**

From Balancer SRV:
nano /etc/nginx/sites-available/balancer.conf

```
upstream backend {
    server 13.51.146.133; # Yellow Site
    server 13.51.85.168; # Blue Site
    server 16.171.28.252 backup;
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://backend;
	    proxy_connect_timeout 500ms;
        access_log /var/log/nginx/balancer.log balancer_log;
    }
}
```

```bash
systemctl restart nginx
```

**6. Выгрузить конфиги в личный репозиторий на devops-gitlab.inno.ws.**

1. Конфиг Yellow: [`yellow.conf`](cfg/yellow.conf)
2. Конфиг Blue: [`blue.conf`](cfg/blue.conf)
3. Конфиг Balancer: [`balancer.conf`](cfg/balancer.conf) \
    3.1. Конфиг Balancer (nginx.conf): [`nginx.conf`](cfg/nginx.conf)
4. Конфиг Backup: [`backup.conf`](cfg/backup.conf)






