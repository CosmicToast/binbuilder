# for now only builds ncat
apk add openssl-dev

confc() {
	cd $1
	./configure
	cd -
}
confc nbase
confc nsock/src
confc libpcap
confc ncat

make -C libpcap
make -C ncat

bin=ncat/ncat
