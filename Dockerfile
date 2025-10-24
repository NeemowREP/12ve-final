FROM golang:latest AS firststage

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download 

COPY . .

RUN go build -o tracker .

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends sqlite3 

WORKDIR /app

COPY --from=firststage /app/tracker .

RUN touch tracker.db

CMD ["./tracker"]