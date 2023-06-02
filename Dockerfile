FROM golang:1.20

#RUN apk --no-cache add ca-certificates make gcc musl-dev net-snmp-dev curl git
RUN apt-get update
RUN apt-get -y install build-essential diffutils libsnmp-dev p7zip-full

WORKDIR /build
COPY . .

FROM alpine:3.17

# RUN apk --no-cache add ca-certificates

COPY --from=0 /build/snmp_exporter  /bin/snmp_exporter
COPY --from=0 /build/snmp.yml       /etc/snmp_exporter/snmp.yml

EXPOSE      9116
ENTRYPOINT  [ "/bin/snmp_exporter" ]
CMD         [ "--config.file=/etc/snmp_exporter/snmp.yml" ]
