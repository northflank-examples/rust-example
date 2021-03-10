FROM ekidd/rust-musl-builder:stable AS build
COPY . ./
RUN sudo chown -R rust:rust .
RUN cargo build --release

FROM scratch
COPY --from=build /home/rust/src/target/x86_64-unknown-linux-musl/release/rust-starter /
EXPOSE 8181
CMD ["/rust-starter"]