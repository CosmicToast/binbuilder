# easier to get go than clang + no CGO override needed this way
apk --no-cache add go
./build.sh --static
