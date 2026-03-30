package main

import (
	"context"
	"fmt"
	"net/http"
	"os"

	"github.com/prometheus/client_golang/prometheus/promhttp"
	"github.com/redis/go-redis/v9"
)

var ctx = context.Background()

func main() {
	// 1. 讀取環境變數 APP_NAME
	appName := os.Getenv("APP_NAME")
	if appName == "" {
		appName = "Default-App"
	}

	redisAddr := os.Getenv("REDIS_ADDR")
	if redisAddr == "" {
		redisAddr = "localhost:6379" // Local 測試用的預設值
	}

	// 2. 連結 Redis
	rdb := redis.NewClient(&redis.Options{
		Addr: redisAddr,
	})

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// 使用 Redis 原子指令 INCR 增加計數
		val, err := rdb.Incr(ctx, "visitor_count").Result()
		if err != nil {
			fmt.Fprintf(w, "Redis 錯誤: %v", err)
			return
		}
		fmt.Fprintf(w, "[%s] 你好！你是第 %d 位訪客。 Monday 03/25 - 1", appName, val)
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprint(w, "OK")
	})

	fmt.Printf("服務 [%s] 啟動在 :8080...\n", appName)
	http.Handle("/metrics", promhttp.Handler())
	http.ListenAndServe(":8080", nil)
}
