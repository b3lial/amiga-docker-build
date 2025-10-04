FROM ubuntu:22.04

COPY VERSION /
COPY entrypoint.sh /sbin/entrypoint.sh
COPY amiga-gcc /tmp/amiga-gcc
COPY vasm.tar.gz /tmp
COPY vlink.tar.gz /tmp

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install \
        --no-install-recommends -y \
        ca-certificates patch make wget git gcc g++ lhasa libgmp-dev libmpfr-dev libmpc-dev \
        flex bison gettext texinfo ncurses-dev autoconf rsync libreadline-dev && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN cd /opt && tar zxf /tmp/vasm.tar.gz && tar xfz /tmp/vlink.tar.gz \
    && cd /tmp/amiga-gcc && mkdir /opt/amiga && make update \
    && make all -j8

RUN cd /usr/bin && ln -s /opt/amiga/bin/m68k* . \
    && cd /opt/vasm && make CPU=m68k SYNTAX=mot \
    && mkdir -p /opt/vbcc/bin && cp vasmm68k_mot vobjdump /opt/vbcc/bin \
    && cd /opt/vlink && make && mkdir -p /opt/vbcc/bin \
    && cp vlink /opt/vbcc/bin \
    && echo "export VBCC=/opt/vbcc" >> /root/.bashrc \
    && echo "export PATH=\$PATH:/opt/vbcc/bin" >> /root/.bashrc

ENTRYPOINT ["/sbin/entrypoint.sh"]
