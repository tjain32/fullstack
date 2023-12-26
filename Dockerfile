
# Start from golang base image
FROM golang:alpine as builder

RUN apk update && apk add --no-cache git

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download 

# Copy the source from the current directory to the working Directory inside the container 
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Start a new stage from scratch
FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /root/

COPY --from=builder /app/main .
COPY --from=builder /app/.env .       

EXPOSE 8080

CMD ["./main"]