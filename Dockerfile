FROM debian:buster-slim AS builder

RUN apt-get update && apt-get install -y build-essential wget

RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' \
    > /etc/apt/sources.list.d/pgdg.list

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc \
    | apt-key add -

RUN apt-get update && apt-get install -y pkg-config libpq-dev

ADD pg_listen.c Makefile /usr/build/

WORKDIR /usr/build

RUN make

FROM alpine:latest

WORKDIR /usr/local/bin
COPY --from=builder /usr/build/pg_listen .
RUN apk add libpq

ENTRYPOINT ["pg_listen"]