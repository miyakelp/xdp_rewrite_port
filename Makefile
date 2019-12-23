all: xdp_mysql_server.o xdp_mysql_client.o


xdp_mysql_server.o: xdp_mysql_server.c
	clang -O2 -Wall -target bpf -c xdp_mysql_server.c -o xdp_mysql_server.o

xdp_mysql_client.o: xdp_mysql_client.c
	clang -O2 -Wall -target bpf -c xdp_mysql_client.c -o xdp_mysql_client.o


reload_server: xdp_mysql_server.o
	make dettach_server
	make attach_server

reload_client: xdp_mysql_client.o
	make dettach_client
	make attach_client

attach_server: xdp_mysql_server.o
	sudo  ip link set dev eth1 xdp obj xdp_mysql_server.o

dettach_server: xdp_mysql_server.o
	sudo  ip link set dev eth1 xdp off

attach_client: xdp_mysql_client.o
	sudo  ip link set dev eth1 xdp obj xdp_mysql_client.o

dettach_client: xdp_mysql_client.o
	sudo  ip link set dev eth1 xdp off
