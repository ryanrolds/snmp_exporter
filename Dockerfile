FROM golang:1.19-alpine

RUN apk --no-cache add ca-certificates make gcc musl-dev net-snmp-dev curl

WORKDIR /build
COPY . .

RUN make common-build

FROM alpine:3.17

RUN apk --no-cache add ca-certificates net-snmp

COPY --from=0 /build/snmp_exporter  /bin/snmp_exporter
COPY --from=0 /build/snmp.yml       /etc/snmp_exporter/snmp.yml

EXPOSE      9116
ENTRYPOINT  [ "/bin/snmp_exporter" ]
CMD         [ "--config.file=/etc/snmp_exporter/snmp.yml" ]
