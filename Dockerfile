FROM golang:1.19 as builder


RUN go version
RUN  go env -w GOPROXY=https://goproxy.io,direct
RUN  go env -w GO111MODULE=on

COPY . /go/src/ipmi_exporter/
WORKDIR /go/src/ipmi_exporter/

RUN make build

FROM k8s.gcr.io/debian-base:v2.0.0
COPY --from=builder /go/src/ipmi_exporter/ /
COPY --from=builder /go/src/ipmi_exporter/ipmi_exporter /etc/ipmi_exporter
RUN chmod +x /etc/ipmi_exporter
EXPOSE      9290
ENTRYPOINT  [ "/etc/ipmi_exporter" ]