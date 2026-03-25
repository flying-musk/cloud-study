# FROM golang:1.25-alpine
# WORKDIR /app
# COPY go.mod go.sum ./
# RUN go mod download
# COPY hello.go .
# RUN go build -o main hello.go
# CMD ["./main"]



# 第一階段：編譯階段 (Builder)
FROM golang:1.25-alpine AS builder
WORKDIR /app
# ENV CGO_ENABLED=0
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o main hello.go

# 第二階段：執行階段 (Final)
FROM alpine:latest
WORKDIR /root/
# 從 builder 階段把編譯好的執行檔偷過來
COPY --from=builder /app/main .
# 執行
CMD ["./main"]