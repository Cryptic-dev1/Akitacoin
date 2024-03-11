FROM amd64/ubuntu:20.04 AS base

#If you found this docker image helpful please donate AKIC to the maintainer
LABEL maintainer="RV9zdNeUTQUToZUcRp9uNF8gwH5LzDFtan"

EXPOSE 7766/tcp
EXPOSE 7788/tcp

ENV DEBIAN_FRONTEND=noninteractive

#Install runtime dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	bash wget net-tools libminiupnpc17 \
	libevent-2.1 libevent-pthreads-2.1 \
	libboost-system1.71 libboost-filesystem1.71 libboost-chrono1.71 \
	libboost-program-options1.71 libboost-thread1.71 \
	libzmq5 && \
	apt-get clean

FROM base AS build

#Install build dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	bash net-tools build-essential libtool autotools-dev automake \
	pkg-config libssl-dev libevent-dev bsdmainutils python3 \
	libboost-system1.71-dev libboost-filesystem1.71-dev libboost-chrono1.71-dev \
	libboost-program-options1.71-dev libboost-test1.71-dev libboost-thread1.71-dev \
	libzmq3-dev libminiupnpc-dev && \
	apt-get clean

#Copy source dir
COPY . /home/akitacoin/build/Akitacoin/
WORKDIR /home/akitacoin/build/Akitacoin

#build db4 from source
WORKDIR /home/akitacoin/build/Akitacoin/contrib
RUN ./install_db4.sh ../../

# build Akitacoincore
WORKDIR /home/akitacoin/build/Akitacoin
RUN ./autogen.sh && ./configure --disable-tests BDB_LIBS="-L/home/akitacoin/build/db4/lib -ldb_cxx-4.8" BDB_CFLAGS="-I/home/akitacoin/build/db4/include" --with-gui=no  && make -j4

FROM base AS final

#Add our service account user
RUN useradd -ms /bin/bash akitacoin && \
	mkdir /var/lib/akitacoin && \
	chown akitacoin:akitacoin /var/lib/akitacoin && \
	ln -s /var/lib/akitacoin /home/akitacoin/.akitacoin && \
	chown -h akitacoin:akitacoin /home/akitacoin/.akitacoin

VOLUME /var/lib/akitacoin

#Copy the compiled binaries from the build
COPY --from=build /home/akitacoin/build/Akitacoin/src/akitacoind /usr/local/bin/akitacoind
COPY --from=build /home/akitacoin/build/Akitacoin/src/akitacoin-cli /usr/local/bin/akitacoin-cli

WORKDIR /home/akitacoin
USER akitacoin

CMD /usr/local/bin/akitacoind -datadir=/var/lib/akitacoin -printtoconsole -onlynet=ipv4
