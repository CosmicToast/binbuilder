FROM binbuilder:cbase
RUN apk add --no-cache cargo rust
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install sccache && rm -rf /root/.cargo/registry
