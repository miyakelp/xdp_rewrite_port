# xdp_rewrite_port

XDPでTCPの宛先ポートを書き換えるサンプルです。以下のブログ記事のサンプルコードとなります。
https://recruit.gmo.jp/engineer/jisedai/blog/xdp-packet-rewrite/

## Usage

Host
```shell
> vagrant up
```

Vagrant guests
```shell
mysql-server $ sudo systemctl start mysqld
mysql_server $ mysql_secure_installation
mysql_server $ mysql -uroot -p
# Create a your MySQL user
mysql_server $ git clone git@github.com:miyakelp/xdp_rewrite_port.git
mysql_server $ cd xdp_rewrite_port
mysql_server $ make && make attach_server

mysql_client $ git clone git@github.com:miyakelp/xdp_rewrite_port.git
mysql_client $ cd xdp_rewrite_port
mysql_client $ make && make attach_client
mysql_client $ mysql -u[Your user] -h 192.168.33.10 -P 3307 -p
```
