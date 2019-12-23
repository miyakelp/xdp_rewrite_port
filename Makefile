all: xdp_mysql_server.o xdp_mysql_client.o


xdp_mysql_server.o:
	clang -D PORT_BEFORE=3307 -D PORT_AFTER=3306 -O2 -Wall -target bpf -c xdp_rewrite_port.c -o xdp_mysql_server.o

xdp_mysql_client.o:
	clang -D PORT_BEFORE=3306 -D PORT_AFTER=3307 -O2 -Wall -target bpf -c xdp_rewrite_port.c -o xdp_mysql_client.o

