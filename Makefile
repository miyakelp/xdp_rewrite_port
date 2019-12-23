all: xdp_mysql_server.o xdp_mysql_client.o


xdp_mysql_server.o: xdp_rewrite_port.c
	clang -D PORT_BEFORE=3307 -D PORT_AFTER=3306 -O2 -Wall -target bpf -c xdp_rewrite_port.c -o xdp_mysql_server.o

xdp_mysql_client.o: xdp_rewrite_port.c
	clang -D PORT_BEFORE=3306 -D PORT_AFTER=3307 -O2 -Wall -target bpf -c xdp_rewrite_port.c -o xdp_mysql_client.o


reload_server: xdp_mysql_server.o
	make dettach_server
	make attach_server

reload_clientr: xdp_mysql_client.o
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
