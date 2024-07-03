/*
 * Description of a TCP packet
 */


#ifndef __TCP_H__
#define __TCP_H__

#include <inttypes.h>

/* RFC 793

 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |          Source Port          |       Destination Port        |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                        Sequence Number                        |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                    Acknowledgment Number                      |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |  Data |           |U|A|P|R|S|F|                               |
 | Offset| Reserved  |R|C|S|S|Y|I|            Window             |
 |       |           |G|K|H|T|N|N|                               |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |           Checksum            |         Urgent Pointer        |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                    Options                    |    Padding    |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |                             data                              |
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

 */

typedef struct tcp_header {
  uint16_t src_port;
  uint16_t dst_port;
  uint32_t seq;
  uint32_t ack_num;
#  if __BYTE_ORDER == __LITTLE_ENDIAN
    uint8_t res1:4;
    uint8_t doff:4;
    uint8_t fin:1;
    uint8_t syn:1;
    uint8_t rst:1;
    uint8_t psh:1;
    uint8_t ack:1;
    uint8_t urg:1;
    uint8_t res2:2;
#  elif __BYTE_ORDER == __BIG_ENDIAN
    uint8_t doff:4;
    uint8_t res1:4;
    uint8_t res2:2;
    uint8_t urg:1;
    uint8_t ack:1;
    uint8_t psh:1;
    uint8_t rst:1;
    uint8_t syn:1;
    uint8_t fin:1;
#  else
#   error "Adjust your <bits/endian.h> defines"
#  endif
  uint16_t window;
  uint16_t checksum;
  uint16_t urgent_ptr;

} __attribute__ ((__packed__)) tcp_header_t;

#endif /* __TCP_H__ */


