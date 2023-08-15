FROM lncm/bitcoind:v22.0
MAINTAINER Kim Duffy "kimhd@mit.edu"

USER root

COPY . /cert-issuer
COPY conf_regtest.ini /etc/cert-issuer/conf.ini

RUN apk add --update \
        bash \
        ca-certificates \
        curl \
        gcc \
        gmp-dev \
        libffi-dev \
        libressl-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        make \
        musl-dev \
        python2 \
        python3 \
        python3-dev \
        tar 
RUN python3 -m ensurepip 
RUN pip3 install --upgrade pip setuptools 
RUN pip3 install Cython 
RUN pip3 install wheel 
RUN mkdir -p /etc/cert-issuer/data/unsigned_certificates 
RUN mkdir /etc/cert-issuer/data/blockchain_certificates 
RUN mkdir ~/.bitcoin 
RUN echo $'[regtest]\nrpcuser=foo\nrpcpassword=bar\nrpcport=8332\nregtest=1\nrelaypriority=0\nrpcallowip=127.0.0.1\nrpcconnect=127.0.0.1\n' > /root/.bitcoin/bitcoin.conf 
RUN pip3 install /cert-issuer/. 
RUN pip3 install -r /cert-issuer/ethereum_requirements.txt 
RUN rm -r /usr/lib/python*/ensurepip 
RUN rm -rf /var/cache/apk/* 
RUN rm -rf /root/.cache


ENTRYPOINT bitcoind -daemon RUN bash


