# Stage 1: Build
FROM golang:1.26-alpine AS builder

WORKDIR /app

COPY . .

RUN go mod tidy && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags="-w -s" -o skillpulse .

# Stage 2: Run
FROM gcr.io/distroless/static-debian12

WORKDIR /app

COPY --from=builder /app/skillpulse .

EXPOSE 8080

USER nonroot:nonroot

CMD ["/app/skillpulse"]