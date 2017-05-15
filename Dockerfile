FROM multiarch/ubuntu-core:i386-trusty

RUN apt-get update
RUN apt-get -y install build-essential binutils-msp430 gcc-msp430 msp430-libc binutils-avr gcc-avr gdb-avr avr-libc avrdude binutils-arm-none-eabi gcc-arm-none-eabi gdb-arm-none-eabi openjdk-7-jdk openjdk-7-jre ant libncurses5-dev doxygen srecord git

RUN useradd -ms /bin/bash cooja
USER cooja
WORKDIR /home/cooja

RUN git clone git://github.com/contiki-os/contiki.git contiki
RUN cd contiki && \
    git checkout release-3-1 && \
    git submodule update --init --recursive

ENV JAVA_TOOL_OPTIONS -Dfile.encoding=UTF8

WORKDIR /home/cooja/contiki/tools/cooja
RUN ant jar

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-i386
