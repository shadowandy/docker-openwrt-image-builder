FROM       ubuntu:14.04
MAINTAINER Lim Cheng Yee "https://github.com/shadowandy/docker-openwrt-image-builder"

# Setting up essential packages

RUN apt-get update \
	&& apt-get install -y \
	openssh-server \
	wget \
	curl \
	vim \
	subversion \
	build-essential \
	libncurses5-dev \
	zlib1g-dev \
	gawk \
	git \
	ccache \
	gettext \
	libssl-dev \
	xsltproc \
	&& apt-get clean

RUN	mkdir /var/run/sshd \
	&& sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
	&& sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
	&& echo 'root:root' | chpasswd \
	&& useradd --home-dir /builder --shell /bin/bash --no-create-home builder \
	&& echo 'builder:builder' | chpasswd
	
RUN mkdir -p /builder/openwrt \
	&& cd /builder/openwrt \
	&& wget --no-check-certificate  https://downloads.openwrt.org/chaos_calmer/15.05.1/ar71xx/generic/OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64.tar.bz2 \
	&& tar -xvjf OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64.tar.bz2 \
	&& mv OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64 chaos_calmer

RUN mkdir -p /builder/openwrt/files
VOLUME /builder/openwrt/files
VOLUME /builder/openwrt/chaos_calmer/bin

RUN chown -R builder /builder

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
