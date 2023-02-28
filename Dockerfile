FROM rust:1.67.1-alpine3.17 as builder

WORKDIR /home/rust
RUN USER=root cargo new --bin rust-docker-web
WORKDIR /home/rust/rust-docker-web

# Cache dependencies
COPY ./Cargo.toml ./Cargo.toml
RUN cargo build --release

# Full build
COPY . ./
RUN cargo build --release

FROM alpine:latest

ARG APP=/usr/src/app

EXPOSE 6767

ENV TZ=Etc/UTC \
    APP_USER=appuser

RUN addgroup -S $APP_USER \
    && adduser -S -g $APP_USER $APP_USER

RUN apk update \
    && apk add --no-cache ca-certificates tzdata \
    && rm -rf /var/cache/apk/*

COPY --from=builder /home/rust/rust-docker-web/target/release/rust-docker-web ${APP}/rust-docker-web
COPY ./static ${APP}/static

RUN chown -R $APP_USER:$APP_USER ${APP}
USER $APP_USER
WORKDIR ${APP}

CMD ["./rust-docker-web"]