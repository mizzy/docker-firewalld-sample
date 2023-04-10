# Dockerでの特定ネットワークへの接続制限サンプル

VagrantでVMを起動してログイン。

```sh
$ vagrant up
$ vagrant ssh
```

Dockerから8.8.8.8へpingが通ることを確認。

```shell
[vagrant@localhost ~]$ sudo docker run -it --rm centos:8 /bin/ping -c 3 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=61 time=8.44 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=61 time=8.20 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=61 time=8.93 ms

--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 8.199/8.523/8.932/0.305 ms
```

Dockerからmizzy.orgへpingが通らないことを確認。

```shell
[vagrant@localhost ~]$ sudo docker run -it --rm centos:8 /bin/ping -c 3 mizzy.org
PING mizzy.org (185.199.110.153) 56(84) bytes of data.

--- mizzy.org ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2077ms
```

Docker外からmizzy.orgへpingが通ることを確認。

```shell
[vagrant@localhost ~]$ ping -c 3 mizzy.org
PING mizzy.org (185.199.109.153) 56(84) bytes of data.
64 bytes from cdn-185-199-109-153.github.com (185.199.109.153): icmp_seq=1 ttl=63 time=7.47 ms
64 bytes from cdn-185-199-109-153.github.com (185.199.109.153): icmp_seq=2 ttl=63 time=6.51 ms
64 bytes from cdn-185-199-109-153.github.com (185.199.109.153): icmp_seq=3 ttl=63 time=13.1 ms

--- mizzy.org ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 6.509/9.015/13.062/2.888 ms
```

念のためHeadless Chromiumからも確認。

まずはChromiumのイメージビルド。

```sh
[vagrant@localhost ~]$ cd /vagrant
[vagrant@localhost ~]$ sudo docker build -t mizzy/chromium .
```

google.comのPDF化ができることを確認。

```sh
[vagrant@localhost ~]$ sudo docker run \
  --rm \
  -v /vagrant:/tmp \
  mizzy/chromium \
  chromium \
    --headless \
    --no-sandbox \
    --disable-gpu \
    --print-to-pdf=/tmp/output.pdf \
    https://google.com/
```

mizzy.orgのPDF化ができないことを確認。

```sh
[vagrant@localhost ~]$ sudo docker run \
  --rm \
  -v /vagrant:/tmp \
  mizzy/chromium \
  chromium \
    --headless \
    --no-sandbox \
    --disable-gpu \
    --print-to-pdf=/tmp/output.pdf \
    https://mizzy.org/
```

