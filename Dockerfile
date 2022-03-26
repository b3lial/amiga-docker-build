FROM ubuntu:20.04

COPY VERSION /
COPY entrypoint.sh /sbin/entrypoint.sh
COPY m68k-amigaos_linux_i386.tar.gz /tmp
COPY vasm.tar.gz /tmp
COPY vlink.tar.gz /tmp

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install \
        --no-install-recommends -y \
        gcc-multilib make

RUN cd /opt && tar zxf /tmp/m68k-amigaos_linux_i386.tar.gz \
    && tar zxf /tmp/vasm.tar.gz && tar xfz /tmp/vlink.tar.gz

RUN cd /usr/bin && ln -s /opt/m68k-amigaos/bin/m68k* . \
    && cd /opt/vasm && make CPU=m68k SYNTAX=mot \
    && mkdir -p /opt/vbcc/bin && cp vasmm68k_mot vobjdump /opt/vbcc/bin \
    && cd /opt/vlink && make && mkdir -p /opt/vbcc/bin \
    && cp vlink /opt/vbcc/bin \
    && echo "export VBCC=/opt/vbcc" >> /root/.bashrc \
    && echo "export PATH=\$PATH:/opt/vbcc/bin" >> /root/.bashrc

ENTRYPOINT ["/sbin/entrypoint.sh"]
