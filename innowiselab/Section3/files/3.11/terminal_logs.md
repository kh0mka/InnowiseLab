```bash
root@DESKTOP-OB216S1:/home/khomenok# docker run -d -p 127.0.0.1:28080:80 --name rbm-dkr-01 nginx:stable
Unable to find image 'nginx:stable' locally
stable: Pulling from library/nginx
1d5252f66ea9: Pull complete
042c30816db6: Pull complete
d9df362538bd: Pull complete
964e3b6bbd01: Pull complete
cf66a9512a90: Pull complete
223ad801e10f: Pull complete
Digest: sha256:57e42e00530faa65e8acf98c3cf7bf6794093a9841c8a676b6d2fd0a9ba7262f
Status: Downloaded newer image for nginx:stable
e98f510e54f95eade615dcf710d324d267346f819ec04cdd992a8366c7408e40

root@DESKTOP-OB216S1:/home/khomenok# docker ps

CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                     NAMES
e98f510e54f9   nginx:stable   "/docker-entrypoint.…"   47 seconds ago   Up 46 seconds   127.0.0.1:28080->80/tcp   rbm-dkr-01

root@DESKTOP-OB216S1:/home/khomenok# curl http://127.0.0.1:28080

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

root@DESKTOP-OB216S1:/home/khomenok# docker stop rbm-dkr-01
rbm-dkr-01

root@DESKTOP-OB216S1:/home/khomenok# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

root@DESKTOP-OB216S1:/home/khomenok# curl http://127.0.0.1:28080
curl: (7) Failed to connect to 127.0.0.1 port 28080 after 0 ms: Connection refused

root@DESKTOP-OB216S1:/home/khomenok# docker ps -a
CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS                      PORTS     NAMES
e98f510e54f9   nginx:stable   "/docker-entrypoint.…"   About a minute ago   Exited (0) 19 seconds ago
    rbm-dkr-01

root@DESKTOP-OB216S1:/home/khomenok# exit
exit
Script done on 2023-08-14 13:21:26+03:00 [COMMAND_EXIT_CODE="0"]
```