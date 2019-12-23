#include <linux/bpf.h>
#include <linux/in.h>
#include <linux/if_ether.h>
#include <linux/if_packet.h>
#include <linux/ip.h>
#include <linux/tcp.h>



#define SWAP_ORDER_16(X) ( (((X) & 0xff00) >> 8) | (((X) & 0xff) << 8))


#ifndef __section
# define __section(NAME)                  \
   __attribute__((section(NAME), used))
#endif


__section("prog")
int xdp_rewrite_port(struct xdp_md *ctx)
{
  void* data_end = (void*)(long)ctx->data_end;
  void* data = (void*)(long)ctx->data;

  struct ethhdr *eth = data;
  if (data + sizeof(struct ethhdr) > data_end) {
    return XDP_PASS;
  }
  __u16 eth_payload_proto = eth->h_proto;
  if (eth_payload_proto != SWAP_ORDER_16(ETH_P_IP)) {
    return XDP_PASS;
  }

  struct iphdr *iph = data + sizeof(*eth);
  if (data + sizeof(struct ethhdr) + sizeof(struct iphdr) > data_end) {
    return XDP_PASS;
  }
  __u16 ip_payload_proto = iph->protocol;
  if (ip_payload_proto != IPPROTO_TCP) {
    return XDP_PASS;
  }

  struct tcphdr *tcph = data + sizeof(*eth) + sizeof(*iph);
  if (data + sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(struct iphdr) > data_end) {
    return XDP_PASS;
  }

  if (tcph->dest == SWAP_ORDER_16(PORT_BEFORE)) {
    tcph->dest = SWAP_ORDER_16(PORT_AFTER);
    unsigned long sum = SWAP_ORDER_16(tcph->check) + PORT_BEFORE + ((~PORT_AFTER & 0xffff) + 1);
    tcph->check = SWAP_ORDER_16(sum & 0xffff);
  }
  return XDP_PASS;
}

char __license[] __section("license") = "GPL";

